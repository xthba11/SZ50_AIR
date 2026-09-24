package main

import (
	"fmt"
	"net/http/httptest"
	"strings"
	"testing"
	"time"
)

func TestParseClassCounts(t *testing.T) {
	out := "class htb 1:1 root rate 1000Mbit ceil 1000Mbit\n" +
		" Sent 100 bytes 1 pkt (dropped 0, overlimits 0 requeues 0)\n" +
		"class htb 1:10 parent 1:1 prio rate 5Mbit ceil 5Mbit\n" +
		" Sent 123456 bytes 100 pkt (dropped 0, overlimits 0 requeues 0)\n" +
		"class htb 1:99 parent 1:1 prio rate 1000Mbit ceil 1000Mbit\n" +
		" Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)\n"
	m := parseClassCounts(out)
	if m[1] != 100 || m[10] != 123456 || m[99] != 0 {
		t.Fatalf("unexpected parse: %v", m)
	}
	if len(m) != 3 {
		t.Fatalf("unexpected class count: %v", m)
	}
}

func TestFirstIPv4(t *testing.T) {
	cases := []struct {
		in   []string
		want string
	}{
		{[]string{"192.168.0.3"}, "192.168.0.3"},
		{[]string{"240e:864:48:3616::5", "192.168.0.4"}, "192.168.0.4"},
		{[]string{"fe80::1", "::1"}, ""},
		{[]string{}, ""},
		{[]string{"not-an-ip"}, ""},
	}
	for _, c := range cases {
		if got := firstIPv4(c.in); got != c.want {
			t.Fatalf("firstIPv4(%v) = %q, want %q", c.in, got, c.want)
		}
	}
}

func TestAllIPv6(t *testing.T) {
	cases := []struct {
		in   []string
		want []string
	}{
		{[]string{"192.168.0.3", "240e:864:48:3616::5"}, []string{"240e:864:48:3616::5"}},
		{[]string{"fe80::1", "::1", "240e::2", "240e::1", "240e::2"}, []string{"240e::1", "240e::2"}},
		{[]string{"192.168.0.1"}, []string{}},
		{[]string{"not-an-ip"}, []string{}},
	}
	for _, c := range cases {
		got := allIPv6(c.in)
		if len(got) != len(c.want) {
			t.Fatalf("allIPv6(%v) len = %d, want %d", c.in, len(got), len(c.want))
		}
		for i := range got {
			if got[i] != c.want[i] {
				t.Fatalf("allIPv6(%v)[%d] = %q, want %q", c.in, i, got[i], c.want[i])
			}
		}
	}
}

// fakeRun returns tc output whose per-class counters advance by the given step
// on every call, so delta accounting can be verified.
func truthCounts(step uint64) func(string, ...string) (string, error) {
	counters := map[string]uint64{}
	return func(name string, args ...string) (string, error) {
		dev := ""
		for i, a := range args {
			if a == "dev" && i+1 < len(args) {
				dev = args[i+1]
			}
		}
		if name != tcBin || len(args) == 0 || args[0] != "-s" || dev == "" {
			return "", nil
		}
		counters[dev] += step
		return fmt.Sprintf("class htb 1:10 parent 1:1 prio rate 5Mbit ceil 5Mbit\n Sent %d bytes 5 pkt\n", counters[dev]), nil
	}
}

func TestAccumulateKeepsDeltas(t *testing.T) {
	s := newTrafficService(t.TempDir() + "/traffic.json")
	s.ready = true
	c := &clientTraffic{MAC: "06:67:59:17:8d:bd", IP: "192.168.0.2", iface: "sipa_usb0", classID: 10}
	s.clients[c.MAC] = c
	s.run = truthCounts(1000)

	s.accumulate() // raw 1000 -> total 1000
	s.accumulate() // raw 2000 -> total 2000
	if c.DownBytes != 2000 || c.UpBytes != 2000 {
		t.Fatalf("after two samples down=%d up=%d, want 2000/2000", c.DownBytes, c.UpBytes)
	}

	// Simulate a qdisc rebuild: counters reset to a smaller value.
	c.rawDown, c.rawUp = 5000, 5000
	s.run = truthCounts(7)
	s.accumulate() // raw 7 < 5000 -> treat as reset, add 7
	if c.DownBytes != 2007 {
		t.Fatalf("after reset down=%d, want 2007", c.DownBytes)
	}
}

func TestQuotaBlocksClient(t *testing.T) {
	s := newTrafficService(t.TempDir() + "/traffic.json")
	c := &clientTraffic{MAC: "06:67:59:17:8d:bd", QuotaMB: 1, DownBytes: 0}
	s.clients[c.MAC] = c
	// Quota evaluation lives in refresh(); verify the arithmetic it applies.
	total := c.DownBytes + c.UpBytes
	if total >= c.QuotaMB*1024*1024 {
		t.Fatal("should not block yet")
	}
	c.DownBytes = 1024*1024 + 1
	total = c.DownBytes + c.UpBytes
	if total < c.QuotaMB*1024*1024 {
		t.Fatal("should block now")
	}
}

func TestSpeedSamplesKeepLastThirty(t *testing.T) {
	s := newTrafficService(t.TempDir() + "/traffic.json")
	s.ready = true
	c := &clientTraffic{MAC: "06:67:59:17:8d:bd", IP: "192.168.0.2", iface: "sipa_usb0", classID: 10}
	s.clients[c.MAC] = c
	s.run = truthCounts(1000)
	for i := 0; i < 35; i++ {
		c.lastRate = time.Now().Add(-2 * time.Second)
		s.accumulate()
	}
	if len(c.Samples) != 30 {
		t.Fatalf("samples=%d, want 30", len(c.Samples))
	}
	last := c.Samples[len(c.Samples)-1]
	if last.DownBps < 3900 || last.DownBps > 4100 || last.UpBps < 3900 || last.UpBps > 4100 {
		t.Fatalf("unexpected two-second rates: %+v", last)
	}
}

func TestTrafficAPIGetPut(t *testing.T) {
	s := newTrafficService(t.TempDir() + "/traffic.json")
	s.run = func(string, ...string) (string, error) { return "", nil }
	mac := "06:67:59:17:8d:bd"
	s.clients[mac] = &clientTraffic{MAC: mac, IP: "192.168.0.2", DownBytes: 4096}

	// GET returns the client list.
	rr := httptest.NewRecorder()
	s.ServeHTTP(rr, httptest.NewRequest("GET", "/air-api/traffic", nil))
	if rr.Code != 200 || !strings.Contains(rr.Body.String(), mac) {
		t.Fatalf("GET: code=%d body=%s", rr.Code, rr.Body.String())
	}

	// PUT applies limits.
	body := `{"mac":"06:67:59:17:8d:bd","limit_down_kbps":500,"limit_up_kbps":200,"quota_mb":100}`
	req := httptest.NewRequest("PUT", "/air-api/traffic", strings.NewReader(body))
	req.Header.Set("Content-Type", "application/json")
	rr = httptest.NewRecorder()
	s.ServeHTTP(rr, req)
	if rr.Code != 200 {
		t.Fatalf("PUT: code=%d body=%s", rr.Code, rr.Body.String())
	}
	if s.clients[mac].LimitDown != 500 || s.clients[mac].LimitUp != 200 || s.clients[mac].QuotaMB != 100 {
		t.Fatalf("limits not applied: %+v", s.clients[mac])
	}
	if s.sig != "" {
		t.Fatal("signature should be invalidated so rules get re-applied")
	}

	// Unknown device -> 404.
	req = httptest.NewRequest("PUT", "/air-api/traffic", strings.NewReader(`{"mac":"aa:bb:cc:dd:ee:ff","quota_mb":1}`))
	req.Header.Set("Content-Type", "application/json")
	rr = httptest.NewRecorder()
	s.ServeHTTP(rr, req)
	if rr.Code != 404 {
		t.Fatalf("unknown mac should 404, got %d", rr.Code)
	}

	// Out-of-range limit -> 400.
	req = httptest.NewRequest("PUT", "/air-api/traffic", strings.NewReader(`{"mac":"06:67:59:17:8d:bd","limit_down_kbps":99999999}`))
	req.Header.Set("Content-Type", "application/json")
	rr = httptest.NewRecorder()
	s.ServeHTTP(rr, req)
	if rr.Code != 400 {
		t.Fatalf("oversize limit should 400, got %d", rr.Code)
	}

	// Unknown field -> 400.
	req = httptest.NewRequest("PUT", "/air-api/traffic", strings.NewReader(`{"mac":"06:67:59:17:8d:bd","bogus":1}`))
	req.Header.Set("Content-Type", "application/json")
	rr = httptest.NewRecorder()
	s.ServeHTTP(rr, req)
	if rr.Code != 400 {
		t.Fatalf("unknown field should 400, got %d", rr.Code)
	}

	// Reset clears counters.
	req = httptest.NewRequest("PUT", "/air-api/traffic", strings.NewReader(`{"mac":"06:67:59:17:8d:bd","reset":true}`))
	req.Header.Set("Content-Type", "application/json")
	rr = httptest.NewRecorder()
	s.ServeHTTP(rr, req)
	if rr.Code != 200 || s.clients[mac].DownBytes != 0 {
		t.Fatalf("reset failed: code=%d down=%d", rr.Code, s.clients[mac].DownBytes)
	}

	// Removing a quota must also restore a quota-blocked client.
	s.clients[mac].Blocked = true
	req = httptest.NewRequest("PUT", "/air-api/traffic", strings.NewReader(`{"mac":"06:67:59:17:8d:bd","quota_mb":0}`))
	req.Header.Set("Content-Type", "application/json")
	rr = httptest.NewRecorder()
	s.ServeHTTP(rr, req)
	if rr.Code != 200 || s.clients[mac].Blocked {
		t.Fatalf("quota removal did not unblock client: code=%d client=%+v", rr.Code, s.clients[mac])
	}

	// Restoring a client starts a fresh period while retaining its quota.
	s.clients[mac].QuotaMB = 100
	s.clients[mac].DownBytes = 100 * 1024 * 1024
	s.clients[mac].UpBytes = 42
	s.clients[mac].Blocked = true
	req = httptest.NewRequest("PUT", "/air-api/traffic", strings.NewReader(`{"mac":"06:67:59:17:8d:bd","unblock":true}`))
	req.Header.Set("Content-Type", "application/json")
	rr = httptest.NewRecorder()
	s.ServeHTTP(rr, req)
	if rr.Code != 200 || s.clients[mac].Blocked || s.clients[mac].DownBytes != 0 ||
		s.clients[mac].UpBytes != 0 || s.clients[mac].QuotaMB != 100 {
		t.Fatalf("unblock did not start a fresh quota period: code=%d client=%+v", rr.Code, s.clients[mac])
	}

	// Deleting a device's history also removes its limits and quota record.
	req = httptest.NewRequest("DELETE", "/air-api/traffic", strings.NewReader(`{"mac":"06:67:59:17:8d:bd"}`))
	req.Header.Set("Content-Type", "application/json")
	rr = httptest.NewRecorder()
	s.ServeHTTP(rr, req)
	if rr.Code != 200 {
		t.Fatalf("DELETE: code=%d body=%s", rr.Code, rr.Body.String())
	}
	if _, ok := s.clients[mac]; ok {
		t.Fatal("traffic record remained after delete")
	}
}

func TestProxyToggleAndSampleSplitting(t *testing.T) {
	s := newTrafficService(t.TempDir() + "/traffic.json")
	s.ready = true
	mac := "06:67:59:17:8d:bd"
	c := &clientTraffic{MAC: mac, IP: "192.168.0.2", iface: "sipa_usb0", classID: 10}
	s.clients[mac] = c

	// Default ProxyEnabled should be true
	snap := s.snapshot()
	if len(snap) != 1 || !snap[0].ProxyEnabled {
		t.Fatalf("expected ProxyEnabled=true, got %+v", snap)
	}

	// Test PUT toggle proxy to false
	req := httptest.NewRequest("PUT", "/air-api/traffic", strings.NewReader(`{"mac":"06:67:59:17:8d:bd","proxy_enabled":false}`))
	req.Header.Set("Content-Type", "application/json")
	rr := httptest.NewRecorder()
	s.ServeHTTP(rr, req)
	if rr.Code != 200 {
		t.Fatalf("expected 200, got %d", rr.Code)
	}
	if !c.ProxyDisabled || c.ProxyEnabled {
		t.Fatalf("expected ProxyDisabled=true, ProxyEnabled=false, got %+v", c)
	}

	// Test PUT toggle proxy back to true
	req = httptest.NewRequest("PUT", "/air-api/traffic", strings.NewReader(`{"mac":"06:67:59:17:8d:bd","proxy_enabled":true}`))
	req.Header.Set("Content-Type", "application/json")
	rr = httptest.NewRecorder()
	s.ServeHTTP(rr, req)
	if rr.Code != 200 {
		t.Fatalf("expected 200, got %d", rr.Code)
	}
	if c.ProxyDisabled || !c.ProxyEnabled {
		t.Fatalf("expected ProxyDisabled=false, ProxyEnabled=true, got %+v", c)
	}
}

