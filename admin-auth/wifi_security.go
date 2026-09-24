package main

import (
	"context"
	"fmt"
	"net/http"
	"os"
	"os/exec"
	"regexp"
	"strconv"
	"strings"
	"sync"
	"time"
)

type hotspotState struct {
	Mode        string
	Enabled     bool
	HasPassword bool
}

func dbusString(raw, key string) string {
	pattern := regexp.MustCompile(`string "` + regexp.QuoteMeta(key) + `"\s+variant\s+string ("(?:\\.|[^"\\])*")`)
	match := pattern.FindStringSubmatch(raw)
	if len(match) != 2 {
		return ""
	}
	value, e := strconv.Unquote(match[1])
	if e != nil {
		return ""
	}
	return value
}
func parseHotspot(raw string) (hotspotState, error) {
	mode := dbusString(raw, "TetheringProtocol")
	if !supportedSecurity(mode) {
		return hotspotState{}, fmt.Errorf("unknown security")
	}
	match := regexp.MustCompile(`string "Tethering"\s+variant\s+boolean (true|false)`).FindStringSubmatch(raw)
	if len(match) != 2 {
		return hotspotState{}, fmt.Errorf("missing state")
	}
	password := dbusString(raw, "TetheringPassphrase")
	return hotspotState{Mode: mode, Enabled: match[1] == "true", HasPassword: len(password) >= 8 && len(password) <= 63}, nil
}
func supportedSecurity(mode string) bool { return mode == "none" || mode == "wpa" || mode == "wpa2" }
func securityCommand(name string, args ...string) (string, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 6*time.Second)
	defer cancel()
	raw, e := exec.CommandContext(ctx, name, args...).Output()
	return string(raw), e
}

type securityResult struct {
	Current   string `json:"current"`
	Requested string `json:"requested"`
	State     string `json:"state"`
	Error     string `json:"error"`
	Available bool   `json:"available"`
	Enabled   bool   `json:"enabled"`
}
type securityService struct {
	mu     sync.Mutex
	result securityResult
	run    func(string, ...string) (string, error)
	sleep  func(time.Duration)
}

func newSecurityService() *securityService {
	return &securityService{result: securityResult{State: "idle"}, run: securityCommand, sleep: time.Sleep}
}
func (s *securityService) dbus(method string, args ...string) (string, error) {
	base := []string{"--system", "--print-reply", "--reply-timeout=4000", "--dest=net.connman", "/net/connman/technology/wifi", "net.connman.Technology." + method}
	return s.run("/usr/bin/dbus-send", append(base, args...)...)
}
func parseSettingsFile(content string) (hotspotState, error) {
	lines := strings.Split(content, "\n")
	inWifi := false
	mode := "wpa2"
	enabled := true
	passphrase := ""
	found := false
	for _, l := range lines {
		line := strings.TrimSpace(l)
		if strings.HasPrefix(line, "[") && strings.HasSuffix(line, "]") {
			inWifi = strings.EqualFold(line, "[WiFi]")
			continue
		}
		if inWifi {
			parts := strings.SplitN(line, "=", 2)
			if len(parts) == 2 {
				k := strings.TrimSpace(parts[0])
				v := strings.TrimSpace(parts[1])
				found = true
				switch k {
				case "Tethering":
					enabled = v == "true"
				case "Tethering.Protocol":
					mode = v
				case "Tethering.Passphrase":
					passphrase = v
				}
			}
		}
	}
	if !found {
		return hotspotState{}, fmt.Errorf("no wifi section")
	}
	if !supportedSecurity(mode) {
		mode = "wpa2"
	}
	return hotspotState{
		Mode:        mode,
		Enabled:     enabled,
		HasPassword: len(passphrase) >= 8 && len(passphrase) <= 63,
	}, nil
}

func (s *securityService) read() (hotspotState, error) {
	raw, e := s.dbus("GetProperties")
	if e == nil {
		if state, err := parseHotspot(raw); err == nil {
			return state, nil
		}
	}
	// Fallback 1: Read directly from /var/lib/connman/settings
	data, err := os.ReadFile("/var/lib/connman/settings")
	if err == nil {
		if state, err := parseSettingsFile(string(data)); err == nil {
			return state, nil
		}
	}
	// Fallback 2: Query wpa_cli status
	wpaStatus, err := s.run("/usr/sbin/wpa_cli", "-i", "wlan0", "status")
	if err == nil && strings.Contains(wpaStatus, "mode=AP") {
		mode := "wpa2"
		if strings.Contains(wpaStatus, "key_mgmt=WPA-PSK") {
			mode = "wpa"
		} else if strings.Contains(wpaStatus, "key_mgmt=NONE") {
			mode = "none"
		}
		return hotspotState{Mode: mode, Enabled: true, HasPassword: true}, nil
	}
	return hotspotState{}, fmt.Errorf("hotspot service unavailable")
}
func (s *securityService) set(key, value string) error {
	_, e := s.dbus("SetProperty", "string:"+key, value)
	return e
}
func (s *securityService) verified(mode string, enabled bool) bool {
	config, e := s.read()
	if e != nil || config.Mode != mode || config.Enabled != enabled {
		return false
	}
	if !enabled {
		return true
	}
	raw, e := s.run("/usr/sbin/wpa_cli", "-i", "wlan0", "status")
	if e != nil || !strings.Contains(raw, "mode=AP") || !strings.Contains(raw, "wpa_state=COMPLETED") {
		return false
	}
	key := ""
	for _, line := range strings.Split(raw, "\n") {
		if strings.HasPrefix(strings.TrimSpace(line), "key_mgmt=") {
			key = strings.TrimSpace(strings.TrimPrefix(strings.TrimSpace(line), "key_mgmt="))
		}
	}
	switch mode {
	case "none":
		return key == "NONE"
	case "wpa":
		return key == "WPA-PSK"
	case "wpa2":
		return key == "WPA2-PSK"
	}
	return false
}
func (s *securityService) change(mode string, enabled bool) error {
	if enabled {
		if e := s.set("Tethering", "variant:boolean:false"); e != nil {
			return e
		}
	}
	if e := s.set("TetheringProtocol", "variant:string:"+mode); e != nil {
		return e
	}
	if enabled {
		if e := s.set("Tethering", "variant:boolean:true"); e != nil {
			return e
		}
	}
	for attempt := 0; attempt < 10; attempt++ {
		if s.verified(mode, enabled) {
			return nil
		}
		s.sleep(time.Second)
	}
	return fmt.Errorf("security was not applied")
}
func (s *securityService) apply(target string, previous hotspotState) {
	e := s.change(target, previous.Enabled)
	message := ""
	if e != nil {
		// Restore the previous protocol and AP state before reporting a failed change.
		_ = s.set("Tethering", "variant:boolean:false")
		restoreErr := s.set("TetheringProtocol", "variant:string:"+previous.Mode)
		if previous.Enabled {
			if err := s.set("Tethering", "variant:boolean:true"); err != nil {
				restoreErr = err
			}
		}
		restored := false
		if restoreErr == nil {
			for i := 0; i < 10; i++ {
				if s.verified(previous.Mode, previous.Enabled) {
					restored = true
					break
				}
				s.sleep(time.Second)
			}
		}
		if restored {
			message = "修改失败，已恢复原设置"
		} else {
			message = "修改失败且未确认恢复，请通过 USB 检查热点"
		}
	}
	s.mu.Lock()
	defer s.mu.Unlock()
	s.result.State = "done"
	s.result.Error = message
	s.result.Available = true
	if e != nil {
		s.result.State = "failed"
		s.result.Current = previous.Mode
		s.result.Available = message == "修改失败，已恢复原设置"
	} else {
		s.result.Current = target
	}
}
func (s *securityService) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	if r.Method != "GET" && r.Method != "PUT" {
		w.Header().Set("Allow", "GET, PUT")
		http.Error(w, "Method not allowed", 405)
		return
	}
	var input struct {
		Mode    string `json:"mode"`
		Confirm bool   `json:"confirm"`
	}
	if r.Method == "PUT" && (readJSON(w, r, &input) != nil || !input.Confirm || !supportedSecurity(input.Mode)) {
		jsonReply(w, 400, map[string]string{"error": "请选择有效加密方式并确认修改"})
		return
	}
	s.mu.Lock()
	defer s.mu.Unlock()
	if s.result.State == "applying" {
		code := 200
		if r.Method == "PUT" {
			code = 409
		}
		jsonReply(w, code, s.result)
		return
	}
	previous, e := s.read()
	if e != nil {
		result := s.result
		result.Available = false
		result.Error = "热点管理服务不可用"
		jsonReply(w, 503, result)
		return
	}
	s.result.Current = previous.Mode
	s.result.Enabled = previous.Enabled
	s.result.Available = true
	if r.Method == "GET" {
		jsonReply(w, 200, s.result)
		return
	}
	if previous.Mode == input.Mode && s.verified(input.Mode, previous.Enabled) {
		s.result = securityResult{Current: previous.Mode, Requested: input.Mode, State: "done", Available: true, Enabled: previous.Enabled}
		jsonReply(w, 200, s.result)
		return
	}
	if input.Mode != "none" && !previous.HasPassword {
		jsonReply(w, 400, map[string]string{"error": "请先保存 8–63 字节的热点密码"})
		return
	}
	s.result = securityResult{Current: previous.Mode, Requested: input.Mode, State: "applying", Available: true, Enabled: previous.Enabled}
	go s.apply(input.Mode, previous)
	jsonReply(w, 202, s.result)
}

var wifiSecurity = newSecurityService()
