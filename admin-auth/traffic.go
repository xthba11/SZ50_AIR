package main

// Per-client traffic accounting, rate limiting and quota.
//
// Design notes (verified on the real device):
//   * The SIPa fast-forward path bypasses netfilter once a flow is established,
//     so iptables byte counters are useless here (measured: 4 MiB downloaded,
//     only 63 KiB counted). Everything therefore goes through tc.
//   * Download limiting works on the client-facing bridge port egress
//     (wlan0 for Wi-Fi stations, sipa_usb0 for USB tethering).
//   * Upload limiting cannot use the WAN egress because the source address is
//     already NATed there; instead client traffic is redirected from the
//     bridge-port ingress into ifb0 and shaped on ifb0's egress.
//   * tc class counters reset whenever a qdisc is rebuilt, so totals are kept
//     in this process and only the delta is added on every sample.

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net"
	"net/http"
	"os"
	"os/exec"
	"sort"
	"strconv"
	"strings"
	"sync"
	"time"
)

const (
	tcBin     = "/sbin/tc"
	ifbName   = "ifb0"
	rateUnlim = "1000mbit"
	rateBlock = "8kbit"
	classRoot = "1:1"
	classDflt = "1:99"
	// Client classes are allocated from this range.
	classFirst = 10
	classLast  = 89
)

var iptablesBin = "/usr/sbin/iptables"

func init() {
	for _, p := range []string{"/usr/sbin/iptables", "/sbin/iptables", "iptables"} {
		if _, err := exec.LookPath(p); err == nil {
			iptablesBin = p
			break
		}
	}
}

// Bridge ports that carry downstream clients.
var trafficIfaces = []string{"wlan0", "sipa_usb0"}

type trafficSample struct {
	At            time.Time `json:"at"`
	DownBps       uint64    `json:"down_bps"`
	UpBps         uint64    `json:"up_bps"`
	ProxyDownBps  uint64    `json:"proxy_down_bps"`
	ProxyUpBps    uint64    `json:"proxy_up_bps"`
	DirectDownBps uint64    `json:"direct_down_bps"`
	DirectUpBps   uint64    `json:"direct_up_bps"`
}

type clientTraffic struct {
	MAC             string          `json:"mac"`
	IP              string          `json:"ip"`
	IPv6Addresses   []string        `json:"ipv6_addresses,omitempty"`
	DownBytes       uint64          `json:"down_bytes"`
	UpBytes         uint64          `json:"up_bytes"`
	ProxyDownBytes  uint64          `json:"proxy_down_bytes"`
	ProxyUpBytes    uint64          `json:"proxy_up_bytes"`
	DirectDownBytes uint64          `json:"direct_down_bytes"`
	DirectUpBytes   uint64          `json:"direct_up_bytes"`
	LimitDown       uint64          `json:"limit_down_kbps"`
	LimitUp         uint64          `json:"limit_up_kbps"`
	QuotaMB         uint64          `json:"quota_mb"`
	Blocked         bool            `json:"blocked"`
	ProxyDisabled   bool            `json:"proxy_disabled"`
	ProxyEnabled    bool            `json:"proxy_enabled"`
	LastSeen        time.Time       `json:"last_seen"`
	Note            string          `json:"note"`
	Samples         []trafficSample `json:"samples"`

	// Runtime state, never persisted.
	ipv6Addrs    []string
	iface        string
	classID      int
	rawDown      uint64
	rawUp        uint64
	rawProxyDown uint64
	rawProxyUp   uint64
	lastRate     time.Time
}

type trafficService struct {
	mu       sync.Mutex
	path     string
	run      func(string, ...string) (string, error)
	clients  map[string]*clientTraffic
	sampled  time.Time
	problem  string
	ready    bool
	sig      string
	lastSave time.Time
}

func trafficCommand(name string, args ...string) (string, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 6*time.Second)
	defer cancel()
	b, e := exec.CommandContext(ctx, name, args...).Output()
	return string(b), e
}

func newTrafficService(path string) *trafficService {
	s := &trafficService{path: path, run: trafficCommand, clients: map[string]*clientTraffic{}}
	b, e := os.ReadFile(path)
	if e != nil {
		return s
	}
	var records []clientTraffic
	if len(b) > 1<<20 || json.Unmarshal(b, &records) != nil || len(records) > 256 {
		return s
	}
	for i := range records {
		c := &records[i]
		if canonicalMAC(c.MAC) != c.MAC {
			continue
		}
		c.Blocked = false
		c.LastSeen = time.Time{}
		c.ProxyEnabled = !c.ProxyDisabled
		if c.DirectDownBytes == 0 && c.ProxyDownBytes == 0 && c.DownBytes > 0 {
			c.DirectDownBytes = c.DownBytes
			c.DirectUpBytes = c.UpBytes
		}
		s.clients[c.MAC] = c
	}
	return s
}

// firstIPv4 picks a usable IPv4 address.
func firstIPv4(addrs []string) string {
	for _, a := range addrs {
		ip := net.ParseIP(a)
		if ip != nil && ip.To4() != nil && !ip.IsLoopback() && !ip.IsLinkLocalUnicast() {
			return ip.String()
		}
	}
	return ""
}

// allIPv6 picks all usable global unicast IPv6 addresses.
func allIPv6(addrs []string) []string {
	res := []string{}
	seen := map[string]bool{}
	for _, a := range addrs {
		ip := net.ParseIP(a)
		if ip != nil && ip.To4() == nil && ip.To16() != nil && !ip.IsLoopback() && !ip.IsLinkLocalUnicast() && !ip.IsMulticast() && !ip.IsUnspecified() {
			s := ip.String()
			if !seen[s] {
				seen[s] = true
				res = append(res, s)
			}
		}
	}
	sort.Strings(res)
	return res
}

// bridgePorts maps station MAC -> bridge port number for the tether bridge.
func (s *trafficService) bridgePorts() map[string]int {
	out, e := s.run("/usr/bin/brctl", "showmacs", "tether")
	if e != nil {
		return nil
	}
	res := map[string]int{}
	for _, line := range strings.Split(out, "\n") {
		f := strings.Fields(line)
		if len(f) < 3 || f[2] != "no" {
			continue
		}
		port, e1 := strconv.Atoi(f[0])
		mac := canonicalMAC(f[1])
		if e1 == nil && mac != "" {
			res[mac] = port
		}
	}
	return res
}

func (s *trafficService) ifaceForPort(port int) string {
	for _, iface := range trafficIfaces {
		b, e := os.ReadFile("/sys/class/net/tether/brif/" + iface + "/port_no")
		if e != nil {
			continue
		}
		v, e1 := strconv.ParseInt(strings.TrimSpace(string(b)), 0, 32)
		if e1 == nil && int(v) == port {
			return iface
		}
	}
	return ""
}

// parseClassCounts reads "tc -s class show" output into classID -> bytes sent.
func parseClassCounts(out string) map[int]uint64 {
	res := map[int]uint64{}
	cur := -1
	for _, line := range strings.Split(out, "\n") {
		line = strings.TrimSpace(line)
		if strings.HasPrefix(line, "class ") {
			f := strings.Fields(line)
			if len(f) >= 3 {
				if _, idStr, ok := strings.Cut(f[2], ":"); ok {
					if n, e := strconv.Atoi(idStr); e == nil {
						cur = n
					}
				}
			}
			continue
		}
		if cur >= 0 && strings.HasPrefix(line, "Sent ") {
			f := strings.Fields(line)
			if len(f) >= 2 {
				if n, e := strconv.ParseUint(f[1], 10, 64); e == nil {
					res[cur] = n
				}
			}
			cur = -1
		}
	}
	return res
}

func (s *trafficService) readCounts(iface string) map[int]uint64 {
	out, e := s.run(tcBin, "-s", "class", "show", "dev", iface)
	if e != nil {
		return nil
	}
	return parseClassCounts(out)
}

func (s *trafficService) readClientProxyCounts() map[string][2]uint64 {
	out, err := s.run(iptablesBin, "-t", "filter", "-L", "AIR_CLIENT_PROXY_STATS", "-v", "-n", "-x")
	if err != nil {
		return nil
	}
	res := make(map[string][2]uint64)
	for _, line := range strings.Split(out, "\n") {
		line = strings.TrimSpace(line)
		if !strings.Contains(line, "12345") {
			continue
		}
		fields := strings.Fields(line)
		if len(fields) < 9 {
			continue
		}
		bytesVal, err := strconv.ParseUint(fields[1], 10, 64)
		if err != nil {
			continue
		}
		src := fields[7]
		dst := fields[8]
		if strings.Contains(line, "spt:12345") && dst != "0.0.0.0/0" {
			ip := strings.Split(dst, "/")[0]
			pair := res[ip]
			pair[0] = bytesVal // rx (downlink)
			res[ip] = pair
		} else if strings.Contains(line, "dpt:12345") && src != "0.0.0.0/0" {
			ip := strings.Split(src, "/")[0]
			pair := res[ip]
			pair[1] = bytesVal // tx (uplink)
			res[ip] = pair
		}
	}
	return res
}

// accumulate folds tc counters into persisted totals and keeps 30 speed samples.
func (s *trafficService) accumulate() {
	if !s.ready {
		return
	}
	byIface := map[string]map[int]uint64{}
	for _, iface := range trafficIfaces {
		byIface[iface] = s.readCounts(iface)
	}
	up := s.readCounts(ifbName)
	proxyCounts := s.readClientProxyCounts()
	now := time.Now()
	for _, c := range s.clients {
		if c.classID == 0 || c.iface == "" {
			continue
		}
		rawDown, rawUp := byIface[c.iface][c.classID], up[c.classID]
		downDelta, upDelta := rawDown, rawUp
		if rawDown >= c.rawDown {
			downDelta = rawDown - c.rawDown
		}
		if rawUp >= c.rawUp {
			upDelta = rawUp - c.rawUp
		}
		c.rawDown, c.rawUp = rawDown, rawUp

		var proxyDownDelta, proxyUpDelta uint64
		if !c.ProxyDisabled && proxyCounts != nil && c.IP != "" {
			pair := proxyCounts[c.IP]
			rawProxyDown, rawProxyUp := pair[0], pair[1]
			if c.rawProxyDown > 0 && rawProxyDown >= c.rawProxyDown {
				proxyDownDelta = rawProxyDown - c.rawProxyDown
			}
			if c.rawProxyUp > 0 && rawProxyUp >= c.rawProxyUp {
				proxyUpDelta = rawProxyUp - c.rawProxyUp
			}
			c.rawProxyDown = rawProxyDown
			c.rawProxyUp = rawProxyUp
		} else {
			c.rawProxyDown = 0
			c.rawProxyUp = 0
		}

		var directDownDelta uint64
		if downDelta > proxyDownDelta {
			directDownDelta = downDelta - proxyDownDelta
		}
		var directUpDelta uint64
		if upDelta > proxyUpDelta {
			directUpDelta = upDelta - proxyUpDelta
		}

		c.ProxyDownBytes += proxyDownDelta
		c.ProxyUpBytes += proxyUpDelta
		c.DirectDownBytes += directDownDelta
		c.DirectUpBytes += directUpDelta
		c.DownBytes = c.ProxyDownBytes + c.DirectDownBytes
		c.UpBytes = c.ProxyUpBytes + c.DirectUpBytes

		if !c.lastRate.IsZero() {
			elapsed := now.Sub(c.lastRate).Seconds()
			if elapsed >= 1 {
				proxyDownBps := uint64(float64(proxyDownDelta*8) / elapsed)
				proxyUpBps := uint64(float64(proxyUpDelta*8) / elapsed)
				directDownBps := uint64(float64(directDownDelta*8) / elapsed)
				directUpBps := uint64(float64(directUpDelta*8) / elapsed)
				downBps := proxyDownBps + directDownBps
				upBps := proxyUpBps + directUpBps

				c.Samples = append(c.Samples, trafficSample{
					At:            now,
					DownBps:       downBps,
					UpBps:         upBps,
					ProxyDownBps:  proxyDownBps,
					ProxyUpBps:    proxyUpBps,
					DirectDownBps: directDownBps,
					DirectUpBps:   directUpBps,
				})
				if len(c.Samples) > 30 {
					c.Samples = append([]trafficSample(nil), c.Samples[len(c.Samples)-30:]...)
				}
			}
		}
		c.lastRate = now
	}
}

func (s *trafficService) ensureIfb() error {
	if _, e := s.run("/sbin/ip", "link", "show", ifbName); e != nil {
		_, _ = s.run("/sbin/modprobe", "ifb")
		if _, e1 := s.run("/sbin/ip", "link", "add", ifbName, "type", "ifb"); e1 != nil {
			return fmt.Errorf("ifb: %w", e1)
		}
	}
	_, _ = s.run("/sbin/ip", "link", "set", ifbName, "up")
	return nil
}

// rebuild wipes and recreates the whole shaping tree. Totals are folded in
// first, so no accounting is lost even though tc counters restart at zero.
func (s *trafficService) rebuild(online []*clientTraffic) error {
	applySFPSetting()
	if err := s.ensureIfb(); err != nil {
		return err
	}
	for _, iface := range trafficIfaces {
		_, _ = s.run(tcBin, "qdisc", "del", "dev", iface, "root")
		_, _ = s.run(tcBin, "qdisc", "del", "dev", iface, "ingress")
		if _, e := s.run(tcBin, "qdisc", "add", "dev", iface, "root", "handle", "1:", "htb", "default", "99"); e != nil {
			return fmt.Errorf("qdisc %s: %w", iface, e)
		}
		_, _ = s.run(tcBin, "class", "add", "dev", iface, "parent", "1:", "classid", classRoot, "htb", "rate", rateUnlim)
		_, _ = s.run(tcBin, "class", "add", "dev", iface, "parent", classRoot, "classid", classDflt, "htb", "rate", rateUnlim, "ceil", rateUnlim)
		_, _ = s.run(tcBin, "qdisc", "add", "dev", iface, "handle", "ffff:", "ingress")
	}
	_, _ = s.run(tcBin, "qdisc", "del", "dev", ifbName, "root")
	if _, e := s.run(tcBin, "qdisc", "add", "dev", ifbName, "root", "handle", "1:", "htb", "default", "99"); e != nil {
		return fmt.Errorf("qdisc ifb0: %w", e)
	}
	_, _ = s.run(tcBin, "class", "add", "dev", ifbName, "parent", "1:", "classid", classRoot, "htb", "rate", rateUnlim)
	_, _ = s.run(tcBin, "class", "add", "dev", ifbName, "parent", classRoot, "classid", classDflt, "htb", "rate", rateUnlim, "ceil", rateUnlim)
	for _, c := range s.clients {
		c.classID = 0
		c.rawDown, c.rawUp = 0, 0
		c.rawProxyDown, c.rawProxyUp = 0, 0
	}
	for i, c := range online {
		if i >= classLast-classFirst {
			break
		}
		c.classID = classFirst + i
		cls := fmt.Sprintf("1:%d", c.classID)
		down, up := rateUnlim, rateUnlim
		if c.Blocked {
			down, up = rateBlock, rateBlock
		} else {
			if c.LimitDown > 0 {
				down = fmt.Sprintf("%dkbit", c.LimitDown)
			}
			if c.LimitUp > 0 {
				up = fmt.Sprintf("%dkbit", c.LimitUp)
			}
		}
		// Download: shape egress towards the client.
		_, _ = s.run(tcBin, "class", "add", "dev", c.iface, "parent", classRoot, "classid", cls, "htb", "rate", down, "ceil", down)
		if c.IP != "" {
			_, _ = s.run(tcBin, "filter", "add", "dev", c.iface, "parent", "1:", "protocol", "ip",
				"prio", "1", "u32", "match", "ip", "dst", c.IP+"/32", "flowid", cls)
		}
		for _, ip6 := range c.ipv6Addrs {
			_, _ = s.run(tcBin, "filter", "add", "dev", c.iface, "parent", "1:", "protocol", "ipv6",
				"prio", "2", "u32", "match", "ip6", "dst", ip6+"/128", "flowid", cls)
		}

		// Upload: redirect ingress into ifb0 and shape there.
		if c.IP != "" {
			_, _ = s.run(tcBin, "filter", "add", "dev", c.iface, "parent", "ffff:", "protocol", "ip",
				"prio", "1", "u32", "match", "ip", "src", c.IP+"/32", "action", "mirred", "egress", "redirect", "dev", ifbName)
		}
		for _, ip6 := range c.ipv6Addrs {
			_, _ = s.run(tcBin, "filter", "add", "dev", c.iface, "parent", "ffff:", "protocol", "ipv6",
				"prio", "2", "u32", "match", "ip6", "src", ip6+"/128", "action", "mirred", "egress", "redirect", "dev", ifbName)
		}

		_, _ = s.run(tcBin, "class", "add", "dev", ifbName, "parent", classRoot, "classid", cls, "htb", "rate", up, "ceil", up)
		if c.IP != "" {
			_, _ = s.run(tcBin, "filter", "add", "dev", ifbName, "parent", "1:", "protocol", "ip",
				"prio", "1", "u32", "match", "ip", "src", c.IP+"/32", "flowid", cls)
		}
		for _, ip6 := range c.ipv6Addrs {
			_, _ = s.run(tcBin, "filter", "add", "dev", ifbName, "parent", "1:", "protocol", "ipv6",
				"prio", "2", "u32", "match", "ip6", "src", ip6+"/128", "flowid", cls)
		}
	}
	return nil
}

func (s *trafficService) teardown() {
	for _, iface := range trafficIfaces {
		_, _ = s.run(tcBin, "qdisc", "del", "dev", iface, "root")
		_, _ = s.run(tcBin, "qdisc", "del", "dev", iface, "ingress")
	}
	_, _ = s.run(tcBin, "qdisc", "del", "dev", ifbName, "root")
	for _, c := range s.clients {
		c.classID = 0
		c.rawDown, c.rawUp = 0, 0
		c.rawProxyDown, c.rawProxyUp = 0, 0
	}
}

func (s *trafficService) syncProxyBypass(online []*clientTraffic) {
	outBypass, errBypass := s.run(iptablesBin, "-t", "nat", "-L", "AIR_PROXY_BYPASS", "-n")
	hasBypassChain := errBypass == nil && strings.Contains(outBypass, "Chain AIR_PROXY_BYPASS")

	outStats, errStats := s.run(iptablesBin, "-t", "filter", "-L", "AIR_CLIENT_PROXY_STATS", "-n")
	hasStatsChain := errStats == nil && strings.Contains(outStats, "Chain AIR_CLIENT_PROXY_STATS")

	for _, c := range online {
		if c.IP == "" {
			continue
		}
		if c.ProxyDisabled {
			// Ensure device IP is bypassed in AIR_PROXY_BYPASS with -j ACCEPT
			if hasBypassChain && !strings.Contains(outBypass, c.IP) {
				_, _ = s.run(iptablesBin, "-t", "nat", "-I", "AIR_PROXY_BYPASS", "1", "-s", c.IP, "-j", "ACCEPT")
			}
			// Remove from AIR_CLIENT_PROXY_STATS
			if hasStatsChain && strings.Contains(outStats, c.IP) {
				_, _ = s.run(iptablesBin, "-t", "filter", "-D", "AIR_CLIENT_PROXY_STATS", "-d", c.IP, "-p", "tcp", "--sport", "12345", "-j", "RETURN")
				_, _ = s.run(iptablesBin, "-t", "filter", "-D", "AIR_CLIENT_PROXY_STATS", "-s", c.IP, "-p", "tcp", "--dport", "12345", "-j", "RETURN")
			}
		} else {
			// Normal proxy routing: remove from bypass
			if hasBypassChain && strings.Contains(outBypass, c.IP) {
				for {
					_, err := s.run(iptablesBin, "-t", "nat", "-D", "AIR_PROXY_BYPASS", "-s", c.IP, "-j", "ACCEPT")
					if err != nil {
						break
					}
				}
			}
			// Add to AIR_CLIENT_PROXY_STATS
			if hasStatsChain && !strings.Contains(outStats, c.IP) {
				_, _ = s.run(iptablesBin, "-t", "filter", "-A", "AIR_CLIENT_PROXY_STATS", "-d", c.IP, "-p", "tcp", "--sport", "12345", "-j", "RETURN")
				_, _ = s.run(iptablesBin, "-t", "filter", "-A", "AIR_CLIENT_PROXY_STATS", "-s", c.IP, "-p", "tcp", "--dport", "12345", "-j", "RETURN")
			}
		}
	}
}

func applySFPSetting() {
	enabled := systemManager.isSFPEnabled()
	expected := "0"
	if enabled {
		expected = "1"
	}
	b, err := os.ReadFile("/proc/net/sfp/enable")
	if err == nil && strings.TrimSpace(string(b)) != expected {
		_ = os.WriteFile("/proc/net/sfp/enable", []byte(expected+"\n"), 0644)
	}
}

func (s *trafficService) refresh() {
	applySFPSetting()
	s.mu.Lock()
	defer s.mu.Unlock()
	s.problem = ""

	wifiDevices.mu.Lock()
	devs := make([]wifiDevice, 0, len(wifiDevices.devices))
	for _, d := range wifiDevices.devices {
		devs = append(devs, d)
	}
	wifiDevices.mu.Unlock()

	ports := s.bridgePorts()
	neighbors, _ := s.run("/sbin/ip", "neigh", "show", "dev", "tether")
	liveAddrs := parseNeighbors(neighbors)

	now := time.Now()
	online := []*clientTraffic{}
	for _, d := range devs {
		if !d.Online {
			continue
		}
		addrs := d.Addresses
		if extra, ok := liveAddrs[d.MAC]; ok {
			seen := map[string]bool{}
			for _, a := range addrs {
				seen[a] = true
			}
			for _, a := range extra {
				if !seen[a] {
					addrs = append(addrs, a)
				}
			}
		}
		ip := firstIPv4(addrs)
		if ip == "" {
			continue
		}
		iface := s.ifaceForPort(ports[d.MAC])
		if iface == "" {
			iface = "wlan0"
		}
		c := s.clients[d.MAC]
		if c == nil {
			c = &clientTraffic{MAC: d.MAC}
			s.clients[d.MAC] = c
		}
		c.IP = ip
		c.ipv6Addrs = allIPv6(addrs)
		c.iface = iface
		c.Note = d.Note
		c.LastSeen = now
		if c.QuotaMB > 0 && !c.Blocked && (c.DownBytes+c.UpBytes) >= c.QuotaMB*1024*1024 {
			c.Blocked = true
		}
		online = append(online, c)
	}
	sort.Slice(online, func(i, j int) bool { return online[i].MAC < online[j].MAC })

	parts := make([]string, 0, len(online))
	for _, c := range online {
		parts = append(parts, fmt.Sprintf("%s|%s|%s|%s|%d|%d|%d|%v|%v", c.MAC, c.IP, strings.Join(c.ipv6Addrs, ","), c.iface, c.LimitDown, c.LimitUp, c.QuotaMB, c.Blocked, c.ProxyDisabled))
	}
	sig := strings.Join(parts, ";")

	if !s.ready {
		if err := s.ensureIfb(); err != nil {
			s.problem = "限速组件初始化失败"
			return
		}
		s.ready = true
	}
	if sig != s.sig {
		s.syncProxyBypass(online)
		s.accumulate()
		if err := s.rebuild(online); err != nil {
			s.problem = "限速规则应用失败"
			s.ready = false
			s.sig = ""
			return
		}
		s.sig = sig
	}
	s.syncProxyBypass(online)
	s.accumulate()
	s.sampled = now
	if time.Since(s.lastSave) >= 5*time.Minute {
		s.persistLocked()
	}
}

func (s *trafficService) persistLocked() error {
	records := make([]clientTraffic, 0, len(s.clients))
	for _, c := range s.clients {
		record := *c
		record.Samples = nil // Two-second chart history is intentionally memory-only.
		record.IPv6Addresses = nil
		records = append(records, record)
	}
	b, e := json.Marshal(records)
	if e != nil {
		return e
	}
	if e = os.WriteFile(s.path+".tmp", b, 0600); e != nil {
		return e
	}
	if e = os.Rename(s.path+".tmp", s.path); e != nil {
		return e
	}
	s.lastSave = time.Now()
	return nil
}

func (s *trafficService) start() {
	go func() {
		s.refresh()
		ticker := time.NewTicker(2 * time.Second)
		defer ticker.Stop()
		for range ticker.C {
			s.refresh()
		}
	}()
}

func (s *trafficService) snapshot() []clientTraffic {
	out := make([]clientTraffic, 0, len(s.clients))
	for _, c := range s.clients {
		c.ProxyEnabled = !c.ProxyDisabled
		c.IPv6Addresses = c.ipv6Addrs
		out = append(out, *c)
	}
	sort.Slice(out, func(i, j int) bool {
		if out[i].LastSeen.Equal(out[j].LastSeen) {
			return out[i].MAC < out[j].MAC
		}
		return out[i].LastSeen.After(out[j].LastSeen)
	})
	return out
}

func (s *trafficService) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.Header().Set("Cache-Control", "no-store")
	if r.URL.Path != "/air-api/traffic" {
		http.NotFound(w, r)
		return
	}
	s.mu.Lock()
	defer s.mu.Unlock()
	switch r.Method {
	case http.MethodGet:
		json.NewEncoder(w).Encode(struct {
			Clients []clientTraffic `json:"clients"`
			Sampled time.Time       `json:"sampled_at"`
			Error   string          `json:"error"`
		}{s.snapshot(), s.sampled, s.problem})
	case http.MethodPut:
		if !strings.HasPrefix(r.Header.Get("Content-Type"), "application/json") {
			http.Error(w, "JSON required", 415)
			return
		}
		var input struct {
			MAC          string  `json:"mac"`
			LimitDown    *uint64 `json:"limit_down_kbps"`
			LimitUp      *uint64 `json:"limit_up_kbps"`
			QuotaMB      *uint64 `json:"quota_mb"`
			ProxyEnabled *bool   `json:"proxy_enabled"`
			Reset        bool    `json:"reset"`
			Unblock      bool    `json:"unblock"`
		}
		dec := json.NewDecoder(http.MaxBytesReader(w, r.Body, 2048))
		dec.DisallowUnknownFields()
		if dec.Decode(&input) != nil {
			http.Error(w, "Invalid JSON", 400)
			return
		}
		var extra any
		if dec.Decode(&extra) != io.EOF {
			http.Error(w, "Invalid JSON", 400)
			return
		}
		mac := canonicalMAC(input.MAC)
		c, ok := s.clients[mac]
		if !ok {
			http.Error(w, "Unknown device", 404)
			return
		}
		if input.LimitDown != nil {
			if *input.LimitDown > 1000000 {
				http.Error(w, "Limit out of range", 400)
				return
			}
			c.LimitDown = *input.LimitDown
		}
		if input.LimitUp != nil {
			if *input.LimitUp > 1000000 {
				http.Error(w, "Limit out of range", 400)
				return
			}
			c.LimitUp = *input.LimitUp
		}
		if input.QuotaMB != nil {
			if *input.QuotaMB > 1024*1024 {
				http.Error(w, "Quota out of range", 400)
				return
			}
			c.QuotaMB = *input.QuotaMB
			if c.QuotaMB == 0 {
				c.Blocked = false
			}
		}
		if input.ProxyEnabled != nil {
			c.ProxyDisabled = !*input.ProxyEnabled
			c.ProxyEnabled = *input.ProxyEnabled
			if c.IP == "" {
				wifiDevices.mu.Lock()
				if dev, ok := wifiDevices.devices[mac]; ok {
					c.IP = firstIPv4(dev.Addresses)
				}
				wifiDevices.mu.Unlock()
			}
			s.syncProxyBypass([]*clientTraffic{c})
		}
		if input.Reset {
			c.DownBytes, c.UpBytes = 0, 0
			c.ProxyDownBytes, c.ProxyUpBytes = 0, 0
			c.DirectDownBytes, c.DirectUpBytes = 0, 0
			c.Blocked = false
		}
		if input.Unblock {
			// Start a fresh quota period so the next refresh does not
			// immediately block the client again at the old total.
			c.DownBytes, c.UpBytes = 0, 0
			c.ProxyDownBytes, c.ProxyUpBytes = 0, 0
			c.DirectDownBytes, c.DirectUpBytes = 0, 0
			c.Blocked = false
		}
		s.accumulate()
		s.persistLocked()
		s.sig = ""
		json.NewEncoder(w).Encode(map[string]bool{"saved": true})
	case http.MethodDelete:
		var input struct {
			MAC string `json:"mac"`
		}
		dec := json.NewDecoder(http.MaxBytesReader(w, r.Body, 2048))
		dec.DisallowUnknownFields()
		if dec.Decode(&input) != nil {
			http.Error(w, "Invalid JSON", 400)
			return
		}
		var extra any
		if dec.Decode(&extra) != io.EOF {
			http.Error(w, "Invalid JSON", 400)
			return
		}
		mac := canonicalMAC(input.MAC)
		if mac == "" {
			http.Error(w, "Invalid MAC", 400)
			return
		}
		previous, ok := s.clients[mac]
		if ok {
			delete(s.clients, mac)
			if before, e := os.ReadFile(s.path); e == nil {
				if s.persistLocked() != nil {
					s.clients[mac] = previous
					_ = os.WriteFile(s.path, before, 0600)
					http.Error(w, "Cannot delete traffic record", 500)
					return
				}
			} else if !os.IsNotExist(e) {
				s.clients[mac] = previous
				http.Error(w, "Cannot delete traffic record", 500)
				return
			} else if s.persistLocked() != nil {
				s.clients[mac] = previous
				http.Error(w, "Cannot delete traffic record", 500)
				return
			}
			s.sig = ""
		}
		json.NewEncoder(w).Encode(map[string]bool{"deleted": true})
	default:
		w.Header().Set("Allow", "GET, PUT, DELETE")
		http.Error(w, "Method not allowed", 405)
	}
}

func isVnstatdRunning() bool {
	out, err := exec.Command("pidof", "vnstatd").Output()
	if err == nil && len(strings.TrimSpace(string(out))) > 0 {
		return true
	}
	out, err = exec.Command("pgrep", "vnstatd").Output()
	return err == nil && len(strings.TrimSpace(string(out))) > 0
}

func (s *trafficService) ServeVnstatdHTTP(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
	if r.Method == http.MethodOptions {
		w.WriteHeader(http.StatusOK)
		return
	}
	switch r.Method {
	case http.MethodGet:
		running := isVnstatdRunning()
		_ = json.NewEncoder(w).Encode(map[string]any{
			"ok":      true,
			"running": running,
		})
	case http.MethodPost:
		var input struct {
			Enabled *bool `json:"enabled"`
		}
		if err := json.NewDecoder(r.Body).Decode(&input); err != nil || input.Enabled == nil {
			http.Error(w, `{"error":"Invalid JSON"}`, 400)
			return
		}
		if *input.Enabled {
			if !isVnstatdRunning() {
				cmd := exec.Command("/webui/vnstatd", "-d")
				if err := cmd.Start(); err != nil {
					_ = exec.Command("vnstatd", "-d").Start()
				}
				time.Sleep(300 * time.Millisecond)
			}
		} else {
			_ = exec.Command("pkill", "vnstatd").Run()
			time.Sleep(300 * time.Millisecond)
		}
		running := isVnstatdRunning()
		msg := "统计服务已停止"
		if running {
			msg = "统计服务已启动"
		}
		_ = json.NewEncoder(w).Encode(map[string]any{
			"ok":      true,
			"running": running,
			"message": msg,
		})
	default:
		http.Error(w, "Method not allowed", 405)
	}
}

var trafficStats = newTrafficService("/home/root/admin-auth/traffic.json")
