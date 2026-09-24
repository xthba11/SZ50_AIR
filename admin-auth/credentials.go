package main

import (
	"crypto/sha256"
	"crypto/subtle"
	"encoding/json"
	"net/http"
	"os"
	"path/filepath"
	"strings"
	"sync"
	"time"
)

// 后台登录凭据：支持运行时修改（热更新，不需要重启网关）
//
// 认证走的是哈希比对（常量时间比较），这里把两个哈希放在全局、由读写锁保护：
// 请求路径上只做 RLock + 比较，改密码时才写锁，热路径开销与改造前一致。

const credFilePath = "/home/root/admin-auth/credentials.json"

var (
	credMu    sync.RWMutex
	wantUHash [32]byte
	wantPHash [32]byte
)

// applyCred 把凭据写入内存（只存哈希，明文不驻留）
func applyCred(c credentials) {
	u := sha256.Sum256([]byte(c.Username))
	p := sha256.Sum256([]byte(c.Password))
	credMu.Lock()
	wantUHash, wantPHash = u, p
	credMu.Unlock()
}

func credHashes() ([32]byte, [32]byte) {
	credMu.RLock()
	defer credMu.RUnlock()
	return wantUHash, wantPHash
}

// writeCredFile 原子写凭据文件（临时文件 + rename），权限 600
func writeCredFile(c credentials) error {
	data, err := json.Marshal(c)
	if err != nil {
		return err
	}
	dir := filepath.Dir(credFilePath)
	tmp, err := os.CreateTemp(dir, ".cred-*.tmp")
	if err != nil {
		return err
	}
	tmpName := tmp.Name()
	defer os.Remove(tmpName)
	if err := tmp.Chmod(0o600); err != nil {
		tmp.Close()
		return err
	}
	if _, err := tmp.Write(data); err != nil {
		tmp.Close()
		return err
	}
	if err := tmp.Sync(); err != nil {
		tmp.Close()
		return err
	}
	if err := tmp.Close(); err != nil {
		return err
	}
	return os.Rename(tmpName, credFilePath)
}

// credentialsHandler 处理 PUT /air-api/credentials
//
// 请求体：{"old_password":"...","new_username":"...","new_password":"..."}
//   - old_password 必填，用于验证身份（防止会话被借用后直接改密码）
//   - new_username 可选，留空表示不改
//   - new_password 必填，长度 6~64
//
// 成功后：写文件 → 更新内存哈希 → 轮换会话密钥（所有已登录会话立即失效，需重新登录）
func credentialsHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.Header().Set("Cache-Control", "no-store")

	if r.Method != http.MethodPut {
		w.WriteHeader(http.StatusMethodNotAllowed)
		_, _ = w.Write([]byte(`{"error":"method not allowed"}`))
		return
	}

	var in struct {
		OldPassword string `json:"old_password"`
		NewUsername string `json:"new_username"`
		NewPassword string `json:"new_password"`
	}
	dec := json.NewDecoder(http.MaxBytesReader(w, r.Body, 4096))
	if err := dec.Decode(&in); err != nil {
		w.WriteHeader(http.StatusBadRequest)
		_, _ = w.Write([]byte(`{"error":"请求格式错误"}`))
		return
	}

	// 验证当前密码
	gotOld := sha256.Sum256([]byte(in.OldPassword))
	_, wantP := credHashes()
	if subtle.ConstantTimeCompare(gotOld[:], wantP[:]) != 1 {
		time.Sleep(150 * time.Millisecond) // 与登录失败一致的延迟，避免爆破
		w.WriteHeader(http.StatusForbidden)
		_, _ = w.Write([]byte(`{"error":"当前密码不正确"}`))
		return
	}

	// 校验新凭据
	newPwd := in.NewPassword
	if len([]rune(newPwd)) < 6 || len([]rune(newPwd)) > 64 {
		w.WriteHeader(http.StatusBadRequest)
		_, _ = w.Write([]byte(`{"error":"新密码长度需为 6~64 个字符"}`))
		return
	}
	if strings.ContainsAny(newPwd, " \t\r\n") {
		w.WriteHeader(http.StatusBadRequest)
		_, _ = w.Write([]byte(`{"error":"新密码不能包含空白字符"}`))
		return
	}
	newUser := strings.TrimSpace(in.NewUsername)
	if newUser == "" {
		// 不改用户名：读出当前的
		cur, err := readCredFile()
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_, _ = w.Write([]byte(`{"error":"读取当前凭据失败"}`))
			return
		}
		newUser = cur.Username
	}
	if len([]rune(newUser)) < 1 || len([]rune(newUser)) > 32 {
		w.WriteHeader(http.StatusBadRequest)
		_, _ = w.Write([]byte(`{"error":"用户名长度需为 1~32 个字符"}`))
		return
	}

	newCred := credentials{Username: newUser, Password: newPwd}
	if err := writeCredFile(newCred); err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		_, _ = w.Write([]byte(`{"error":"写入凭据失败"}`))
		return
	}
	applyCred(newCred)
	rotateSessionKey() // 旧会话全部失效

	_ = json.NewEncoder(w).Encode(map[string]interface{}{
		"status":   "success",
		"username": newUser,
		"message":  "凭据已更新，请用新密码重新登录",
	})
}

func readCredFile() (credentials, error) {
	var c credentials
	data, err := os.ReadFile(credFilePath)
	if err != nil {
		return c, err
	}
	err = json.Unmarshal(data, &c)
	return c, err
}
