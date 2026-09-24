package main

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"os"
	"path/filepath"
	"strings"
	"testing"
	"time"
)

func TestProxyDailyTrafficStore(t *testing.T) {
	tempDir := t.TempDir()
	dailyPath := filepath.Join(tempDir, "daily_traffic.json")

	mgr := &proxyManager{
		dailyRecordPath:   dailyPath,
		dailyProxyRecords: make([]ProxyDayRecord, 0),
	}

	// 1. Record some traffic
	mgr.mu.Lock()
	mgr.recordProxyTrafficDeltaLocked(1024*1024*5, 1024*1024*1)   // 5MB rx, 1MB tx
	mgr.recordProxyTrafficDeltaLocked(1024*1024*10, 1024*1024*2) // +10MB rx, +2MB tx
	mgr.saveDailyRecordsLocked()
	mgr.mu.Unlock()

	today := time.Now().Format("2006-01-02")
	if len(mgr.dailyProxyRecords) != 1 {
		t.Fatalf("expected 1 record, got %d", len(mgr.dailyProxyRecords))
	}
	rec := mgr.dailyProxyRecords[0]
	if rec.Date != today {
		t.Errorf("expected date %s, got %s", today, rec.Date)
	}
	expectedRx := uint64(15 * 1024 * 1024)
	expectedTx := uint64(3 * 1024 * 1024)
	if rec.RxBytes != expectedRx || rec.TxBytes != expectedTx || rec.TotalBytes != expectedRx+expectedTx {
		t.Errorf("unexpected record bytes: rx=%d, tx=%d, total=%d", rec.RxBytes, rec.TxBytes, rec.TotalBytes)
	}

	// 2. Load from disk with a new manager
	mgr2 := &proxyManager{
		dailyRecordPath: dailyPath,
	}
	mgr2.loadDailyRecordsLocked()
	if len(mgr2.dailyProxyRecords) != 1 {
		t.Fatalf("mgr2 expected 1 record, got %d", len(mgr2.dailyProxyRecords))
	}
	if mgr2.dailyProxyRecords[0].TotalBytes != expectedRx+expectedTx {
		t.Errorf("mgr2 loaded bytes mismatch: got %d", mgr2.dailyProxyRecords[0].TotalBytes)
	}

	// 3. Test ServeDailyVnstat GET
	req := httptest.NewRequest(http.MethodGet, "/air-api/traffic/daily", nil)
	w := httptest.NewRecorder()
	mgr2.ServeDailyVnstat(w, req)

	if w.Code != http.StatusOK {
		t.Fatalf("ServeDailyVnstat returned %d", w.Code)
	}
	var resp struct {
		OK         bool             `json:"ok"`
		Days       []any            `json:"days"`
		ProxyDays  []ProxyDayRecord `json:"proxy_days"`
		ProxyToday ProxyDayRecord   `json:"proxy_today"`
		ProxyMonth ProxyDayRecord   `json:"proxy_month"`
	}
	if err := json.Unmarshal(w.Body.Bytes(), &resp); err != nil {
		t.Fatalf("failed to decode response: %v", err)
	}
	if !resp.OK {
		t.Errorf("expected ok: true")
	}
	if len(resp.ProxyDays) != 1 {
		t.Fatalf("expected 1 proxy_day, got %d", len(resp.ProxyDays))
	}
	if resp.ProxyToday.TotalBytes != expectedRx+expectedTx {
		t.Errorf("expected proxy_today %d, got %d", expectedRx+expectedTx, resp.ProxyToday.TotalBytes)
	}
	if resp.ProxyMonth.TotalBytes != expectedRx+expectedTx {
		t.Errorf("expected proxy_month %d, got %d", expectedRx+expectedTx, resp.ProxyMonth.TotalBytes)
	}

	// 4. Test ServeDailyVnstat DELETE (Clear stats)
	delReq := httptest.NewRequest(http.MethodDelete, "/air-api/traffic/daily", nil)
	delW := httptest.NewRecorder()
	mgr2.ServeDailyVnstat(delW, delReq)

	if delW.Code != http.StatusOK {
		t.Fatalf("ServeDailyVnstat DELETE returned %d", delW.Code)
	}
	if len(mgr2.dailyProxyRecords) != 0 {
		t.Errorf("expected 0 records after clear, got %d", len(mgr2.dailyProxyRecords))
	}

	// Check file content after clear
	content, _ := os.ReadFile(dailyPath)
	if !strings.Contains(string(content), "[]") {
		t.Errorf("expected empty JSON array in file, got: %s", string(content))
	}
}
