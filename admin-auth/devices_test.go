package main

import (
	"errors"
	"net/http/httptest"
	"path/filepath"
	"strings"
	"testing"
	"time"
)

const stationFixture = "12:34:56:78:90:ab\nflags=[AUTH][ASSOC][AUTHORIZED]\nconnected_time=42\nrx_bytes=999999\n"

func TestStationParsing(t *testing.T) {
	d, e := parseStations(stationFixture + "22:34:56:78:90:ab\nflags=[AUTH]\nconnected_time=-1\n")
	if e != nil || len(d) != 2 || !d[0].Online || *d[0].Connected != 42 || d[1].Online || d[1].Connected != nil {
		t.Fatal(d, e)
	}
	for _, bad := range []string{"FAIL\n", "UNKNOWN COMMAND\n", "Could not connect to wpa_supplicant\n"} {
		if _, e := parseStations(bad); e == nil {
			t.Fatal("accepted failure", bad)
		}
	}
	if d, e := parseStations(""); e != nil || len(d) != 0 {
		t.Fatal("empty AP", d, e)
	}
}
func TestNeighborParsing(t *testing.T) {
	m := parseNeighbors("192.168.0.2 lladdr 12:34:56:78:90:ab STALE\n2001:db8::1 lladdr 12:34:56:78:90:ab REACHABLE\n192.168.0.9 lladdr 12:34:56:78:90:ab FAILED\n192.168.0.2 lladdr 12:34:56:78:90:ab STALE\n")
	if len(m["12:34:56:78:90:ab"]) != 2 {
		t.Fatal(m)
	}
}
func fakeService(t *testing.T) *deviceService {
	s := newDeviceService(filepath.Join(t.TempDir(), "devices.json"))
	s.run = func(name string, args ...string) (string, error) {
		if name == "/sbin/ip" {
			return "192.168.0.2 lladdr 12:34:56:78:90:ab STALE", nil
		}
		if args[len(args)-1] == "status" {
			return "mode=AP\nwpa_state=COMPLETED", nil
		}
		return stationFixture, nil
	}
	s.refresh()
	return s
}
func TestSamplingFailureAndOffline(t *testing.T) {
	s := fakeService(t)
	stamp := s.sampled
	s.run = func(string, ...string) (string, error) { return "", errors.New("unavailable") }
	s.refresh()
	if s.problem == "" || !s.sampled.Equal(stamp) || !s.devices["12:34:56:78:90:ab"].Online {
		t.Fatal("failure destroyed last known state")
	}
	s.run = func(name string, args ...string) (string, error) {
		if args[len(args)-1] == "status" {
			return "mode=AP\nwpa_state=COMPLETED", nil
		}
		return "", nil
	}
	s.refresh()
	d := s.devices["12:34:56:78:90:ab"]
	if d.Online || d.Connected != nil || len(d.Addresses) != 0 || !d.LastSeen.Equal(stamp) {
		t.Fatal(d)
	}
}
func TestNotesAndPersistence(t *testing.T) {
	s := fakeService(t)
	for _, tc := range []struct {
		body string
		code int
	}{
		{`{"mac":"12:34:56:78:90:ab","note":"my phone"}`, 200},
		{`{"mac":"12:34:56:78:90:ab","note":"x"} {}`, 400},
		{`{"mac":"00:11:22:33:44:55","note":"x"}`, 404},
		{`{"mac":"12:34:56:78:90:ab","note":"` + strings.Repeat("a", 65) + `"}`, 400},
	} {
		r := httptest.NewRequest("PUT", "/air-api/devices", strings.NewReader(tc.body))
		r.Header.Set("Content-Type", "application/json")
		w := httptest.NewRecorder()
		s.ServeHTTP(w, r)
		if w.Code != tc.code {
			t.Fatal(w.Code, w.Body.String())
		}
	}
	restored := newDeviceService(s.path)
	d := restored.devices["12:34:56:78:90:ab"]
	if d.Note != "my phone" || d.Online || d.Connected != nil {
		t.Fatal(d)
	}
	s.path = filepath.Join(t.TempDir(), "missing", "devices.json")
	r := httptest.NewRequest("PUT", "/air-api/devices", strings.NewReader(`{"mac":"12:34:56:78:90:ab","note":"unsaved"}`))
	r.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	s.ServeHTTP(w, r)
	if w.Code != 500 || s.devices[d.MAC].Note != "my phone" {
		t.Fatal("failed write accepted")
	}
}
func TestKickOnlineDevice(t *testing.T) {
	s := fakeService(t)
	baseRun := s.run
	called := ""
	s.run = func(name string, args ...string) (string, error) {
		if name == "/usr/sbin/wpa_cli" && len(args) == 4 && args[2] == "deauthenticate" {
			called = args[3]
			return "OK\n", nil
		}
		return baseRun(name, args...)
	}
	r := httptest.NewRequest("POST", "/air-api/devices/kick", strings.NewReader(`{"mac":"12:34:56:78:90:ab"}`))
	r.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	s.ServeHTTP(w, r)
	d := s.devices["12:34:56:78:90:ab"]
	if w.Code != 200 || called != d.MAC || d.Online || d.Connected != nil || len(d.Addresses) != 0 {
		t.Fatalf("kick failed: code=%d called=%q device=%+v body=%s", w.Code, called, d, w.Body.String())
	}
}

func TestDeleteOfflineDevice(t *testing.T) {
	s := fakeService(t)
	body := `{"mac":"12:34:56:78:90:ab"}`
	r := httptest.NewRequest("DELETE", "/air-api/devices", strings.NewReader(body))
	r.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	s.ServeHTTP(w, r)
	if w.Code != 409 {
		t.Fatalf("online delete code=%d body=%s", w.Code, w.Body.String())
	}
	d := s.devices["12:34:56:78:90:ab"]
	d.Online = false
	s.devices[d.MAC] = d
	r = httptest.NewRequest("DELETE", "/air-api/devices", strings.NewReader(body))
	r.Header.Set("Content-Type", "application/json")
	w = httptest.NewRecorder()
	s.ServeHTTP(w, r)
	if w.Code != 200 {
		t.Fatalf("offline delete code=%d body=%s", w.Code, w.Body.String())
	}
	if _, ok := s.devices[d.MAC]; ok {
		t.Fatal("device remained in memory")
	}
	if _, ok := newDeviceService(s.path).devices[d.MAC]; ok {
		t.Fatal("device remained on disk")
	}
}

func TestDeviceAuthentication(t *testing.T) {
	previous := wifiDevices
	wifiDevices = fakeService(t)
	defer func() { wifiDevices = previous }()
	h := authHandler(credentials{"admin", "test"}, "http://127.0.0.1:1", "")
	for _, tc := range []struct {
		pass, origin string
		code         int
	}{{"", "", 401}, {"test", "", 200}, {"test", "http://foreign.invalid", 403}} {
		r := httptest.NewRequest("GET", "/air-api/devices", nil)
		if tc.pass != "" {
			r.SetBasicAuth("admin", tc.pass)
		}
		r.Header.Set("Origin", tc.origin)
		w := httptest.NewRecorder()
		h.ServeHTTP(w, r)
		if w.Code != tc.code {
			t.Fatal(w.Code)
		}
	}
}
func TestHistoryBound(t *testing.T) {
	s := fakeService(t)
	for i := 0; i < 300; i++ {
		s.devices[time.Unix(int64(i), 0).String()] = wifiDevice{LastSeen: time.Unix(int64(i), 0)}
	}
	s.refresh()
	if len(s.devices) != 256 {
		t.Fatal(len(s.devices))
	}
}
