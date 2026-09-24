package main

import (
	"bytes"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"os"
	"path/filepath"
	"testing"
)

func TestSystemSFP(t *testing.T) {
	tempDir := t.TempDir()
	systemManager.configFile = filepath.Join(tempDir, "sfp_test.json")

	// 1. Initial GET
	req := httptest.NewRequest(http.MethodGet, "/air-api/system/sfp", nil)
	rec := httptest.NewRecorder()
	systemManager.ServeHTTP(rec, req)

	if rec.Code != http.StatusOK {
		t.Fatalf("expected 200, got %d", rec.Code)
	}

	var res map[string]interface{}
	if err := json.NewDecoder(rec.Body).Decode(&res); err != nil {
		t.Fatalf("decode err: %v", err)
	}
	if res["ok"] != true {
		t.Fatalf("expected ok true, got %v", res)
	}

	// 2. Set SFP to enabled (true)
	body, _ := json.Marshal(map[string]bool{"enabled": true})
	req2 := httptest.NewRequest(http.MethodPost, "/air-api/system/sfp", bytes.NewReader(body))
	rec2 := httptest.NewRecorder()
	systemManager.ServeHTTP(rec2, req2)

	if rec2.Code != http.StatusOK {
		t.Fatalf("expected 200, got %d", rec2.Code)
	}
	if !systemManager.isSFPEnabled() {
		t.Fatalf("expected isSFPEnabled to be true")
	}

	// 3. Set SFP to disabled (false)
	body3, _ := json.Marshal(map[string]bool{"enabled": false})
	req3 := httptest.NewRequest(http.MethodPost, "/air-api/system/sfp", bytes.NewReader(body3))
	rec3 := httptest.NewRecorder()
	systemManager.ServeHTTP(rec3, req3)

	if rec3.Code != http.StatusOK {
		t.Fatalf("expected 200, got %d", rec3.Code)
	}
	if systemManager.isSFPEnabled() {
		t.Fatalf("expected isSFPEnabled to be false")
	}

	// 4. Verify config file was written
	data, err := os.ReadFile(systemManager.configFile)
	if err != nil {
		t.Fatalf("cannot read config file: %v", err)
	}
	var cfg sfpConfig
	if err := json.Unmarshal(data, &cfg); err != nil || cfg.Enabled != false {
		t.Fatalf("unexpected config content: %s", string(data))
	}
}
