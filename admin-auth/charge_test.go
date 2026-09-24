package main

import (
	"bytes"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestChargeManager(t *testing.T) {
	tempDir := t.TempDir()
	configPath := filepath.Join(tempDir, "charge_rule.json")
	capPath := filepath.Join(tempDir, "capacity")
	statusPath := filepath.Join(tempDir, "status")
	stopPath := filepath.Join(tempDir, "stop_charge")
	iniPath := filepath.Join(tempDir, "traffic.ini")
	voltPath := filepath.Join(tempDir, "voltage_now")
	currPath := filepath.Join(tempDir, "current_now")

	_ = os.WriteFile(capPath, []byte("75\n"), 0644)
	_ = os.WriteFile(statusPath, []byte("Charging\n"), 0644)
	_ = os.WriteFile(stopPath, []byte("0\n"), 0644)
	_ = os.WriteFile(iniPath, []byte("[settings]\ncharge_auto=0\ncharge_min=20\ncharge_max=80\n"), 0644)
	_ = os.WriteFile(voltPath, []byte("4150000\n"), 0644)
	_ = os.WriteFile(currPath, []byte("-25000\n"), 0644)

	cm := newChargeManager(configPath, capPath, statusPath, stopPath, iniPath, voltPath, currPath)
	cm.load()

	// Initial rule defaults
	if cm.rule.StartPercent != 20 || cm.rule.StopPercent != 80 {
		t.Fatalf("unexpected defaults: %+v", cm.rule)
	}

	// Test GET HTTP
	req := httptest.NewRequest(http.MethodGet, "/air-api/charge", nil)
	w := httptest.NewRecorder()
	cm.ServeHTTP(w, req)
	if w.Code != http.StatusOK {
		t.Fatalf("expected 200, got %d", w.Code)
	}
	var status ChargeStatus
	if err := json.NewDecoder(w.Body).Decode(&status); err != nil {
		t.Fatalf("decode err: %v", err)
	}
	if status.Capacity != 75 || status.Status != "Charging" {
		t.Fatalf("unexpected status: %+v", status)
	}
	if status.VoltageV < 4.14 || status.VoltageV > 4.16 {
		t.Fatalf("expected voltage ~4.15, got %v", status.VoltageV)
	}
	if status.CurrentMA != -25 {
		t.Fatalf("expected current -25, got %v", status.CurrentMA)
	}

	// Test POST to enable rule: stop at 80, resume at 20
	enabled := true
	startP := 25
	stopP := 70
	postBody, _ := json.Marshal(map[string]interface{}{
		"enabled":       &enabled,
		"start_percent": &startP,
		"stop_percent":  &stopP,
	})
	req = httptest.NewRequest(http.MethodPost, "/air-api/charge", bytes.NewReader(postBody))
	w = httptest.NewRecorder()
	cm.ServeHTTP(w, req)
	if w.Code != http.StatusOK {
		t.Fatalf("expected 200 on POST, got %d", w.Code)
	}

	// Capacity is 75, which is >= stop_percent (70) -> should stop charging!
	stopVal, _ := os.ReadFile(stopPath)
	if strings.TrimSpace(string(stopVal)) != "1" {
		t.Fatalf("expected stop_charge to be 1, got %s", stopVal)
	}

	// Check traffic.ini sync
	iniContent, _ := os.ReadFile(iniPath)
	if !strings.Contains(string(iniContent), "charge_auto=1") ||
		!strings.Contains(string(iniContent), "charge_min=25") ||
		!strings.Contains(string(iniContent), "charge_max=70") {
		t.Fatalf("traffic.ini not synced: %s", iniContent)
	}

	// Now simulate battery drops to 20% (<= 25%)
	_ = os.WriteFile(capPath, []byte("20\n"), 0644)
	cm.evaluate()
	stopVal, _ = os.ReadFile(stopPath)
	if strings.TrimSpace(string(stopVal)) != "0" {
		t.Fatalf("expected stop_charge to be 0 (resumed), got %s", stopVal)
	}

	// Now simulate battery reaches 50% (between 25% and 70%) -> should keep charging (0)
	_ = os.WriteFile(capPath, []byte("50\n"), 0644)
	cm.evaluate()
	stopVal, _ = os.ReadFile(stopPath)
	if strings.TrimSpace(string(stopVal)) != "0" {
		t.Fatalf("expected stop_charge to remain 0, got %s", stopVal)
	}

	// Test disabling rule
	disabled := false
	postBody, _ = json.Marshal(map[string]interface{}{
		"enabled": &disabled,
	})
	req = httptest.NewRequest(http.MethodPost, "/air-api/charge", bytes.NewReader(postBody))
	w = httptest.NewRecorder()
	cm.ServeHTTP(w, req)
	if w.Code != http.StatusOK {
		t.Fatalf("expected 200 on POST disable, got %d", w.Code)
	}
	stopVal, _ = os.ReadFile(stopPath)
	if strings.TrimSpace(string(stopVal)) != "0" {
		t.Fatalf("expected stop_charge to be 0 when disabled, got %s", stopVal)
	}
}
