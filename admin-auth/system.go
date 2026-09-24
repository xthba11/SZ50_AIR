package main

import (
	"encoding/json"
	"net/http"
	"os"
	"strings"
	"sync"
)

type systemService struct {
	mu         sync.Mutex
	configFile string
}

type sfpConfig struct {
	Enabled bool `json:"enabled"`
}

var systemManager = &systemService{
	configFile: "/home/root/admin-auth/sfp.json",
}

func (s *systemService) start() {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.applyCurrentLocked()
}

func (s *systemService) isSFPEnabled() bool {
	s.mu.Lock()
	defer s.mu.Unlock()

	// 1. Read persistent configuration file if available
	data, err := os.ReadFile(s.configFile)
	if err == nil {
		var cfg sfpConfig
		if json.Unmarshal(data, &cfg) == nil {
			return cfg.Enabled
		}
	}

	// 2. Default: if no config file, check current /proc/net/sfp/enable (default to 0/disabled)
	b, err := os.ReadFile("/proc/net/sfp/enable")
	if err == nil {
		return strings.TrimSpace(string(b)) == "1"
	}
	return false
}

func (s *systemService) applyCurrentLocked() {
	enabled := false
	data, err := os.ReadFile(s.configFile)
	if err == nil {
		var cfg sfpConfig
		if json.Unmarshal(data, &cfg) == nil {
			enabled = cfg.Enabled
		}
	} else {
		// Default to 0 (disabled) to ensure traffic stats work
		enabled = false
		cfg := sfpConfig{Enabled: false}
		if d, e := json.Marshal(cfg); e == nil {
			_ = os.WriteFile(s.configFile, d, 0644)
		}
	}

	val := "0\n"
	if enabled {
		val = "1\n"
	}
	b, err := os.ReadFile("/proc/net/sfp/enable")
	if err == nil && strings.TrimSpace(string(b)) != strings.TrimSpace(val) {
		_ = os.WriteFile("/proc/net/sfp/enable", []byte(val), 0644)
	}
}

func (s *systemService) setSFPEnabled(enabled bool) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	val := "0\n"
	if enabled {
		val = "1\n"
	}

	// 1. Write to /proc/net/sfp/enable
	_ = os.WriteFile("/proc/net/sfp/enable", []byte(val), 0644)

	// 2. Persist to sfp.json
	cfg := sfpConfig{Enabled: enabled}
	data, err := json.Marshal(cfg)
	if err == nil {
		_ = os.WriteFile(s.configFile, data, 0644)
	}
	return nil
}

func (s *systemService) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.Header().Set("Cache-Control", "no-store")

	if r.URL.Path == "/air-api/system/sfp" {
		if r.Method == http.MethodGet {
			enabled := s.isSFPEnabled()
			statusStr := "0"
			if enabled {
				statusStr = "1"
			}
			_ = json.NewEncoder(w).Encode(map[string]interface{}{
				"ok":      true,
				"enabled": enabled,
				"status":  statusStr,
				"name":    "紫光展锐 SFP 硬件加速旁路",
			})
			return
		}

		if r.Method == http.MethodPost || r.Method == http.MethodPut {
			var body struct {
				Enabled bool `json:"enabled"`
			}
			if err := json.NewDecoder(r.Body).Decode(&body); err != nil {
				http.Error(w, `{"error":"invalid json"}`, http.StatusBadRequest)
				return
			}

			_ = s.setSFPEnabled(body.Enabled)
			statusStr := "0"
			if body.Enabled {
				statusStr = "1"
			}
			_ = json.NewEncoder(w).Encode(map[string]interface{}{
				"ok":      true,
				"enabled": body.Enabled,
				"status":  statusStr,
			})
			return
		}

		http.Error(w, `{"error":"method not allowed"}`, http.StatusMethodNotAllowed)
		return
	}

	http.NotFound(w, r)
}
