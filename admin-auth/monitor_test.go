package main

import (
	"fmt"
	"net/http/httptest"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestMonitorParsers(t *testing.T) {
	total, idle, e := parseCPU("cpu 100 20 30 400 50 2 3 4 60 10\ncpu0 1 2 3 4\n")
	if e != nil || total != 609 || idle != 450 {
		t.Fatal(total, idle, e)
	}
	for _, raw := range []string{"", "cpu x 0 1 2", "cpu0 1 2 3 4"} {
		if _, _, e := parseCPU(raw); e == nil {
			t.Fatal("accepted invalid CPU")
		}
	}
	memory, e := parseMemory("MemTotal: 1000 kB\nMemFree: 10 kB\nMemAvailable: 400 kB\n")
	if e != nil || memory.Available != 409600 {
		t.Fatal(memory, e)
	}
	if _, e := parseMemory("MemTotal: 1000 kB\nMemFree: 10 kB"); e == nil {
		t.Fatal("free incorrectly used as available")
	}
	disk, e := parseStorage("Filesystem 1024-blocks Used Available Capacity Mounted on\n/dev/data 45300 24444 20344 55% /mnt/userdata\n")
	if e != nil || disk.Total != 45300*1024 || disk.Available != 20344*1024 {
		t.Fatal(disk, e)
	}
	if _, e := parseStorage("bad"); e == nil {
		t.Fatal("invalid disk")
	}
	for _, raw := range []string{"NaN", "Inf", "oops"} {
		if _, e := parseNumber([]byte(raw)); e == nil {
			t.Fatal("invalid number")
		}
	}
}
func TestMonitorSampling(t *testing.T) {
	s := newMonitorService()
	s.network = func() ([]byte, error) {
		return []byte(`{"Code":0,"Data":{"Technology":"nr","Network":[{"Band":"78","ARFCN":"1","PCI":"2","RSRP":"-63.3","RSRQ":"-1","SINR":"29.5"}]}}`), nil
	}
	counter := 0
	diskCalls := 0
	s.glob = func(string) ([]string, error) { return []string{filepath.Join("test", "thermal_zone0")}, nil }
	s.read = func(path string) ([]byte, error) {
		switch path {
		case "/proc/stat":
			counter++
			return []byte(fmt.Sprintf("cpu %d 0 0 %d 0 0 0 0", counter*25, counter*75)), nil
		case "/proc/meminfo":
			return []byte("MemTotal: 1000 kB\nMemAvailable: 400 kB"), nil
		case "/proc/uptime":
			return []byte("123.45 678.90"), nil
		case filepath.Join("test", "thermal_zone0", "type"):
			return []byte("soc-thmzone\n"), nil
		case filepath.Join("test", "thermal_zone0", "temp"):
			return []byte("41428\n"), nil
		case "/sys/class/power_supply/battery/capacity":
			return []byte("19"), nil
		case "/sys/class/power_supply/battery/status":
			return []byte("Discharging"), nil
		}
		return nil, os.ErrNotExist
	}
	s.run = func(string, ...string) (string, error) {
		diskCalls++
		return "Filesystem 1024-blocks Used Available Capacity Mounted on\n/dev/data 1000 400 600 40% /data", nil
	}
	s.sample()
	if s.samples[0].CPU != nil {
		t.Fatal("first CPU sample must be unknown")
	}
	s.sample()
	p := s.samples[1]
	if p.CPU == nil || *p.CPU != 25 || p.Temperatures["soc-thmzone (thermal_zone0)"] != 41.428 || p.Battery == nil || *p.Battery != 19 || diskCalls != 1 {
		t.Fatal(p, diskCalls)
	}
	for i := 0; i < 130; i++ {
		s.sample()
	}
	if len(s.samples) != 30 {
		t.Fatal("history unbounded")
	}
	s.read = func(string) ([]byte, error) { return nil, os.ErrPermission }
	s.sample()
	p = s.samples[len(s.samples)-1]
	if p.CPU != nil || p.Memory != nil || len(p.Temperatures) != 0 || len(p.Errors) == 0 {
		t.Fatal("failure shown as valid", p)
	}
}
func TestMonitorAuthentication(t *testing.T) {
	h := authHandler(credentials{"admin", "test"}, "http://127.0.0.1:1", "")
	for _, tc := range []struct {
		method, pass, origin string
		code                 int
	}{{"GET", "", "", 401}, {"GET", "test", "", 200}, {"GET", "test", "http://foreign.invalid", 403}, {"POST", "test", "", 405}} {
		r := httptest.NewRequest(tc.method, "/air-api/monitor", strings.NewReader(""))
		if tc.pass != "" {
			r.SetBasicAuth("admin", tc.pass)
		}
		r.Header.Set("Origin", tc.origin)
		w := httptest.NewRecorder()
		h.ServeHTTP(w, r)
		if w.Code != tc.code {
			t.Fatal(tc, w.Code)
		}
	}
}
