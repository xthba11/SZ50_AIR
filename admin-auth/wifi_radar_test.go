package main

import (
	"bytes"
	"encoding/json"
	"net/http/httptest"
	"path/filepath"
	"strings"
	"testing"
	"time"
)

func TestFreqToChannel(t *testing.T) {
	cases := []struct {
		freq int
		ch   int
		band string
	}{
		{2412, 1, "2.4G"},
		{2437, 6, "2.4G"},
		{2462, 11, "2.4G"},
		{2472, 13, "2.4G"},
		{2484, 14, "2.4G"},
		{5180, 36, "5G"},
		{5200, 40, "5G"},
		{5220, 44, "5G"},
		{5745, 149, "5G"},
		{5825, 165, "5G"},
		{1000, 0, "unknown"},
	}

	for _, c := range cases {
		ch, band := freqToChannel(c.freq)
		if ch != c.ch || band != c.band {
			t.Errorf("freqToChannel(%d) = (%d, %s), want (%d, %s)", c.freq, ch, band, c.ch, c.band)
		}
	}
}

func TestParseScanResults(t *testing.T) {
	raw := `bssid / frequency / signal level / flags / ssid
68:77:da:6b:a9:cf	2437	-47	[WPA-PSK-CCMP][WPA2-PSK-CCMP][ESS]	ZTE-511
70:2a:d7:81:a9:29	2462	-50	[WPA2-PSK-CCMP][ESS]	H3C_81A928
06:74:9c:de:5d:95	5825	-59	[WPA2-PSK-CCMP][ESS]	APM
68:77:da:6b:a9:d0	5180	-73	[WPA2-PSK-CCMP][ESS]	ZTE-511-5G
`
	nets := parseScanResults(raw)
	if len(nets) != 4 {
		t.Fatalf("expected 4 networks, got %d", len(nets))
	}
	if nets[0].SSID != "ZTE-511" || nets[0].Channel != 6 || nets[0].Band != "2.4G" || nets[0].RSSI != -47 {
		t.Errorf("unexpected top network: %+v", nets[0])
	}
	if nets[3].SSID != "ZTE-511-5G" || nets[3].Channel != 36 || nets[3].Band != "5G" {
		t.Errorf("unexpected 4th network: %+v", nets[3])
	}
}

func TestCalculateScores(t *testing.T) {
	nets := []ScannedNetwork{
		{BSSID: "11:22:33:44:55:66", SSID: "Busy-24", Freq: 2412, Channel: 1, Band: "2.4G", RSSI: -40},
		{BSSID: "11:22:33:44:55:67", SSID: "Busy-24b", Freq: 2417, Channel: 2, Band: "2.4G", RSSI: -45},
		{BSSID: "aa:bb:cc:dd:ee:ff", SSID: "Busy-5G", Freq: 5180, Channel: 36, Band: "5G", RSSI: -42},
	}

	scores24G, scores5G, best24G, best5G := calculateScores(nets)
	if len(scores24G) != 13 {
		t.Errorf("expected 13 scores for 2.4G, got %d", len(scores24G))
	}
	if len(scores5G) != 13 {
		t.Errorf("expected 13 scores for 5G (including 52-64), got %d", len(scores5G))
	}

	// Channel 1 has heavy interference (-40dBm), Channel 11 or 6 should be much cleaner
	if best24G == 1 {
		t.Errorf("channel 1 should not be recommended when heavily congested")
	}
	// Channel 36 is occupied, other 5G channel (e.g. 149) should be recommended
	if best5G == 36 {
		t.Errorf("channel 36 should not be recommended when occupied")
	}

	// Verify empty 5G channels (e.g. 52, 56) receive 100 score
	for _, sc := range scores5G {
		if sc.Channel == 52 || sc.Channel == 56 {
			if sc.Score != 100 {
				t.Errorf("empty channel %d expected score 100, got %d", sc.Channel, sc.Score)
			}
		}
		if sc.Channel == 36 {
			if sc.Score > 85 {
				t.Errorf("occupied channel 36 expected score <= 85, got %d", sc.Score)
			}
		}
	}

	// Test current channel stability protection (clean current channel should stay recommended)
	_, _, _, best5GProtected := calculateScoresWithContext(nets, 44, "5G", "MySZ50", "00:11:22:33:44:55")
	if best5GProtected != 44 {
		t.Errorf("clean current channel 44 should remain recommended, got %d", best5GProtected)
	}
}

func TestWifiRadarHTTP(t *testing.T) {
	service := newWifiRadarService()
	service.softapIniPath = filepath.Join(t.TempDir(), "softap.ini")
	service.sleep = func(d time.Duration) {}
	service.runCmd = func(cmd string, args ...string) (string, error) {
		if strings.Contains(cmd, "wpa_cli") {
			if len(args) >= 3 && args[2] == "scan_results" {
				return "bssid / frequency / signal level / flags / ssid\n00:11:22:33:44:55\t5180\t-55\t[WPA2-PSK-CCMP][ESS]\tNeighbor-5G\n", nil
			}
			if len(args) >= 3 && args[2] == "status" {
				return "freq=5180\nssid=MySZ50\nmode=AP\n", nil
			}
			return "OK\n", nil
		}
		return "method return\n", nil
	}

	// Test GET /air-api/wifi/radar
	req := httptest.NewRequest("GET", "/air-api/wifi/radar", nil)
	w := httptest.NewRecorder()
	service.ServeHTTP(w, req)

	if w.Code != 200 {
		t.Fatalf("expected 200, got %d: %s", w.Code, w.Body.String())
	}
	var resp RadarResponse
	if err := json.NewDecoder(w.Body).Decode(&resp); err != nil {
		t.Fatalf("failed to decode response: %v", err)
	}
	if resp.CurrentSSID != "MySZ50" || resp.CurrentChannel != 36 {
		t.Errorf("unexpected radar response: %+v", resp)
	}
	if len(resp.Networks) != 1 || resp.Networks[0].SSID != "Neighbor-5G" {
		t.Errorf("unexpected networks list: %+v", resp.Networks)
	}

	// Test POST /air-api/wifi/channel with channel 52 (now unlocked and supported)
	dfsBody := bytes.NewBufferString(`{"channel": 52, "mode": "5G"}`)
	reqDFS := httptest.NewRequest("POST", "/air-api/wifi/channel", dfsBody)
	wDFS := httptest.NewRecorder()
	service.ServeHTTP(wDFS, reqDFS)
	if wDFS.Code != 200 {
		t.Fatalf("expected 200 on channel 52, got %d: %s", wDFS.Code, wDFS.Body.String())
	}

	// Test POST /air-api/wifi/channel with valid channel 44
	body := bytes.NewBufferString(`{"channel": 44, "mode": "5G"}`)
	reqChan := httptest.NewRequest("POST", "/air-api/wifi/channel", body)
	wChan := httptest.NewRecorder()
	service.ServeHTTP(wChan, reqChan)

	if wChan.Code != 200 {
		t.Fatalf("expected 200, got %d: %s", wChan.Code, wChan.Body.String())
	}
}
