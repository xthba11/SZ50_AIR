package main

import (
	"bytes"
	"encoding/base64"
	"encoding/json"
	"net/http/httptest"
	"os"
	"path/filepath"
	"testing"
)

func TestParseVLESS(t *testing.T) {
	link := "vless://a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d@hk.example.com:443?type=ws&security=tls&path=%2Fvless-ws&sni=hk.example.com#HongKong-01"
	out, err := parseProxyLink(link)
	if err != nil {
		t.Fatalf("parseVLESS failed: %v", err)
	}
	if out.Protocol != "vless" {
		t.Errorf("expected vless, got %s", out.Protocol)
	}
	if out.Server != "hk.example.com" {
		t.Errorf("expected hk.example.com, got %s", out.Server)
	}
	if out.Port != 443 {
		t.Errorf("expected 443, got %d", out.Port)
	}
	if out.Name != "HongKong-01" {
		t.Errorf("expected HongKong-01, got %s", out.Name)
	}

	cfg := buildXrayConfig(out, "bypass_cn", nil)
	if len(cfg["inbounds"].([]map[string]interface{})) != 3 {
		t.Errorf("expected 3 inbounds (tcp-redirect, dns, socks)")
	}

	routing := cfg["routing"].(map[string]interface{})
	rules := routing["rules"].([]map[string]interface{})
	// bypass_cn should have dns rule, private CIDR rule, china domains rule, china CIDRs rule, and proxy rule
	if len(rules) < 5 {
		t.Errorf("expected at least 5 routing rules in bypass_cn mode, got %d", len(rules))
	}

	// Test global mode
	cfgGlobal := buildXrayConfig(out, "global", nil)
	rulesGlobal := cfgGlobal["routing"].(map[string]interface{})["rules"].([]map[string]interface{})
	if len(rulesGlobal) >= len(rules) {
		t.Errorf("global mode should have fewer rules than bypass_cn mode")
	}

	// Test custom bypass list in both global and bypass_cn modes
	customList := []string{"www.bing.com", "bing.com", "204.79.197.200"}
	cfgBypassGlobal := buildXrayConfig(out, "global", customList)
	rulesBypassGlobal := cfgBypassGlobal["routing"].(map[string]interface{})["rules"].([]map[string]interface{})
	foundBing := false
	foundIP := false
	for _, r := range rulesBypassGlobal {
		if r["outboundTag"] == "direct" {
			if doms, ok := r["domain"].([]string); ok {
				for _, d := range doms {
					if d == "domain:www.bing.com" || d == "domain:bing.com" {
						foundBing = true
					}
				}
			}
			if ips, ok := r["ip"].([]string); ok {
				for _, ip := range ips {
					if ip == "204.79.197.200" {
						foundIP = true
					}
				}
			}
		}
	}
	if !foundBing {
		t.Errorf("expected custom domain www.bing.com to be direct in global mode")
	}
	if !foundIP {
		t.Errorf("expected custom IP 204.79.197.200 to be direct in global mode")
	}
}

func TestParseVMess(t *testing.T) {
	vmessObj := map[string]interface{}{
		"v":    "2",
		"ps":   "Japan-02",
		"add":  "jp.example.com",
		"port": 443,
		"id":   "b2c3d4e5-f6a7-8b9c-0d1e-2f3a4b5c6d7e",
		"aid":  0,
		"net":  "ws",
		"type": "none",
		"host": "jp.example.com",
		"path": "/vmess",
		"tls":  "tls",
	}
	data, _ := json.Marshal(vmessObj)
	encoded := base64.StdEncoding.EncodeToString(data)
	link := "vmess://" + encoded

	out, err := parseProxyLink(link)
	if err != nil {
		t.Fatalf("parseVMess failed: %v", err)
	}
	if out.Protocol != "vmess" {
		t.Errorf("expected vmess, got %s", out.Protocol)
	}
	if out.Server != "jp.example.com" {
		t.Errorf("expected jp.example.com, got %s", out.Server)
	}
	if out.Port != 443 {
		t.Errorf("expected 443, got %d", out.Port)
	}
	if out.Name != "Japan-02" {
		t.Errorf("expected Japan-02, got %s", out.Name)
	}
}

func TestParseTrojan(t *testing.T) {
	link := "trojan://password123@sg.example.com:443?security=tls&sni=sg.example.com#Singapore-03"
	out, err := parseProxyLink(link)
	if err != nil {
		t.Fatalf("parseTrojan failed: %v", err)
	}
	if out.Protocol != "trojan" {
		t.Errorf("expected trojan, got %s", out.Protocol)
	}
	if out.Server != "sg.example.com" {
		t.Errorf("expected sg.example.com, got %s", out.Server)
	}
	if out.Port != 443 {
		t.Errorf("expected 443, got %d", out.Port)
	}
	if out.Name != "Singapore-03" {
		t.Errorf("expected Singapore-03, got %s", out.Name)
	}
}

func TestParseShadowsocks(t *testing.T) {
	userinfo := base64.RawStdEncoding.EncodeToString([]byte("aes-256-gcm:secretpass"))
	link := "ss://" + userinfo + "@us.example.com:8388#USA-04"
	out, err := parseProxyLink(link)
	if err != nil {
		t.Fatalf("parseShadowsocks failed: %v", err)
	}
	if out.Protocol != "shadowsocks" {
		t.Errorf("expected shadowsocks, got %s", out.Protocol)
	}
	if out.Server != "us.example.com" {
		t.Errorf("expected us.example.com, got %s", out.Server)
	}
	if out.Port != 8388 {
		t.Errorf("expected 8388, got %d", out.Port)
	}
	if out.Name != "USA-04" {
		t.Errorf("expected USA-04, got %s", out.Name)
	}
}

func TestSubscriptionParsing(t *testing.T) {
	l1 := "trojan://pass1@sg.example.com:443#SG"
	l2 := "ss://" + base64.RawStdEncoding.EncodeToString([]byte("aes-256-gcm:p")) + "@jp.example.com:8388#JP"
	plain := l1 + "\n" + l2

	nodes, err := parseSubscriptionText(plain)
	if err != nil {
		t.Fatalf("parseSubscriptionText failed: %v", err)
	}
	if len(nodes) != 2 {
		t.Fatalf("expected 2 nodes, got %d", len(nodes))
	}
	if nodes[0].Name != "SG" || nodes[1].Name != "JP" {
		t.Errorf("names mismatch: %v", nodes)
	}

	// Test base64 wrapped subscription
	b64Sub := base64.StdEncoding.EncodeToString([]byte(plain))
	nodes2, err := parseSubscriptionText(b64Sub)
	if err != nil {
		t.Fatalf("parseSubscriptionText with base64 failed: %v", err)
	}
	if len(nodes2) != 2 {
		t.Fatalf("expected 2 nodes from base64, got %d", len(nodes2))
	}
}

func TestProxyServiceAPI(t *testing.T) {
	tmp := t.TempDir()
	mgr := &proxyManager{
		dir:        tmp,
		statePath:  filepath.Join(tmp, "state.json"),
		configPath: filepath.Join(tmp, "config.json"),
		xrayBin:    "echo",
		xrayPID:    filepath.Join(tmp, "xray.pid"),
		iptables:   "echo",
	}

	// 1. GET status
	req := httptest.NewRequest("GET", "/air-api/proxy", nil)
	w := httptest.NewRecorder()
	mgr.ServeHTTP(w, req)
	if w.Code != 200 {
		t.Fatalf("expected 200, got %d", w.Code)
	}

	var status proxyStatus
	if err := json.Unmarshal(w.Body.Bytes(), &status); err != nil {
		t.Fatalf("unmarshal error: %v", err)
	}
	if status.Enabled {
		t.Errorf("expected enabled=false initially")
	}
	if status.RoutingMode != "bypass_cn" {
		t.Errorf("expected default routing_mode=bypass_cn, got %s", status.RoutingMode)
	}

	// 2. POST /node (single link)
	nodeReq := map[string]string{
		"link": "trojan://password123@sg.example.com:443?security=tls&sni=sg.example.com#Singapore-03",
	}
	nodeBody, _ := json.Marshal(nodeReq)
	req = httptest.NewRequest("POST", "/air-api/proxy/node", bytes.NewReader(nodeBody))
	w = httptest.NewRecorder()
	mgr.ServeHTTP(w, req)
	if w.Code != 200 {
		t.Fatalf("expected 200 on /node, got %d: %s", w.Code, w.Body.String())
	}

	// 3. POST /mode
	modeReq := map[string]string{"mode": "global"}
	mBody, _ := json.Marshal(modeReq)
	req = httptest.NewRequest("POST", "/air-api/proxy/mode", bytes.NewReader(mBody))
	w = httptest.NewRecorder()
	mgr.ServeHTTP(w, req)
	if w.Code != 200 {
		t.Fatalf("expected 200 on /mode, got %d: %s", w.Code, w.Body.String())
	}

	// Verify mode was changed
	req = httptest.NewRequest("GET", "/air-api/proxy", nil)
	w = httptest.NewRecorder()
	mgr.ServeHTTP(w, req)
	var st2 proxyStatus
	_ = json.Unmarshal(w.Body.Bytes(), &st2)
	if st2.RoutingMode != "global" {
		t.Errorf("expected routing_mode=global, got %s", st2.RoutingMode)
	}
	if len(st2.Nodes) != 1 {
		t.Fatalf("expected 1 node, got %d", len(st2.Nodes))
	}

	// 4. GET /air-api/network/speed
	req = httptest.NewRequest("GET", "/air-api/network/speed", nil)
	w = httptest.NewRecorder()
	mgr.ServeHTTP(w, req)
	if w.Code != 200 {
		t.Fatalf("expected 200 on /network/speed, got %d", w.Code)
	}
	var speedRes map[string]interface{}
	_ = json.Unmarshal(w.Body.Bytes(), &speedRes)
	if _, ok := speedRes["samples"]; !ok {
		t.Errorf("expected samples in speedRes")
	}

	// 5. POST /air-api/proxy/node/rename
	renameReq := map[string]string{"id": st2.Nodes[0].ID, "name": "重命名节点-01"}
	rBody, _ := json.Marshal(renameReq)
	req = httptest.NewRequest("POST", "/air-api/proxy/node/rename", bytes.NewReader(rBody))
	w = httptest.NewRecorder()
	mgr.ServeHTTP(w, req)
	if w.Code != 200 {
		t.Fatalf("expected 200 on rename, got %d: %s", w.Code, w.Body.String())
	}
	if mgr.state.Nodes[0].Name != "重命名节点-01" {
		t.Fatalf("expected node name to be updated, got %s", mgr.state.Nodes[0].Name)
	}

	// 6. DELETE /air-api/proxy/node/delete
	delReq := map[string]string{"id": st2.Nodes[0].ID}
	dBody, _ := json.Marshal(delReq)
	req = httptest.NewRequest("POST", "/air-api/proxy/node/delete", bytes.NewReader(dBody))
	w = httptest.NewRecorder()
	mgr.ServeHTTP(w, req)
	if w.Code != 200 {
		t.Fatalf("expected 200 on delete, got %d", w.Code)
	}

	// Verify state file created
	if _, err := os.Stat(mgr.statePath); err != nil {
		t.Fatalf("state file was not written: %v", err)
	}
}
