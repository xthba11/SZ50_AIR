package main

import (
	"context"
	"encoding/json"
	"errors"
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
	"unicode/utf8"
)

type wifiDevice struct {
	MAC       string    `json:"mac"`
	Online    bool      `json:"online"`
	Connected *int64    `json:"connected_seconds"`
	Addresses []string  `json:"addresses"`
	Note      string    `json:"note"`
	LastSeen  time.Time `json:"last_seen"`
}
type deviceService struct {
	mu             sync.Mutex
	devices        map[string]wifiDevice
	path           string
	run            func(string, ...string) (string, error)
	sampled        time.Time
	lastWrite      time.Time
	problem        string
	addressWarning bool
	storageWarning bool
}

func canonicalMAC(s string) string {
	m, e := net.ParseMAC(s)
	if e != nil || len(m) != 6 {
		return ""
	}
	return m.String()
}
func deviceCommand(name string, args ...string) (string, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 3*time.Second)
	defer cancel()
	b, e := exec.CommandContext(ctx, name, args...).Output()
	// This firmware returns 255 at the end of ALL_STA iteration, even on success.
	// Accept only that exact command/exit combination and a structurally valid response.
	var exitError *exec.ExitError
	if name == "/usr/sbin/wpa_cli" && len(args) == 3 && args[2] == "all_sta" && ctx.Err() == nil && errors.As(e, &exitError) && exitError.ExitCode() == 255 && len(exitError.Stderr) == 0 {
		if _, parseError := parseStations(string(b)); parseError == nil {
			e = nil
		}
	}
	return string(b), e
}
func newDeviceService(path string) *deviceService {
	s := &deviceService{devices: map[string]wifiDevice{}, path: path, run: deviceCommand}
	b, e := os.ReadFile(path)
	if e == nil {
		var records []wifiDevice
		if len(b) > 1<<20 || json.Unmarshal(b, &records) != nil || len(records) > 256 {
			s.storageWarning = true
			return s
		}
		for _, d := range records {
			if canonicalMAC(d.MAC) == d.MAC {
				d.Online = false
				d.Connected = nil
				d.Addresses = []string{}
				s.devices[d.MAC] = d
			}
		}
	} else if !os.IsNotExist(e) {
		s.storageWarning = true
	}
	return s
}
func parseStations(raw string) ([]wifiDevice, error) {
	out := []wifiDevice{}
	var current *wifiDevice
	for _, line := range strings.Split(raw, "\n") {
		line = strings.TrimSpace(line)
		if line == "" {
			continue
		}
		if mac := canonicalMAC(line); mac != "" {
			out = append(out, wifiDevice{MAC: mac, Addresses: []string{}})
			current = &out[len(out)-1]
			continue
		}
		if strings.HasPrefix(line, "Selected interface") {
			continue
		}
		if current == nil || !strings.Contains(line, "=") {
			return nil, errors.New("invalid station response")
		}
		k, v, _ := strings.Cut(line, "=")
		if k == "flags" {
			current.Online = strings.Contains(v, "[ASSOC]")
		}
		if k == "connected_time" {
			n, e := strconv.ParseInt(v, 10, 64)
			if e == nil && n >= 0 {
				current.Connected = &n
			}
		}
	}
	return out, nil
}
func parseNeighbors(raw string) map[string][]string {
	out := map[string][]string{}
	for _, line := range strings.Split(raw, "\n") {
		f := strings.Fields(line)
		if len(f) < 4 || net.ParseIP(f[0]) == nil {
			continue
		}
		if strings.Contains(line, "FAILED") || strings.Contains(line, "INCOMPLETE") {
			continue
		}
		for i := 1; i+1 < len(f); i++ {
			if f[i] == "lladdr" {
				mac := canonicalMAC(f[i+1])
				if mac != "" {
					duplicate := false
					for _, v := range out[mac] {
						if v == f[0] {
							duplicate = true
						}
					}
					if !duplicate {
						out[mac] = append(out[mac], f[0])
					}
				}
				break
			}
		}
	}
	return out
}
func (s *deviceService) persistLocked() error {
	records := make([]wifiDevice, 0, len(s.devices))
	for _, d := range s.devices {
		records = append(records, d)
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
	s.lastWrite = time.Now()
	return nil
}
func (s *deviceService) refresh() {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.problem = ""
	status, e := s.run("/usr/sbin/wpa_cli", "-i", "wlan0", "status")
	if e != nil || !strings.Contains(status, "mode=AP") || !strings.Contains(status, "wpa_state=COMPLETED") {
		s.problem = "热点状态暂不可用，保留上次记录"
		if s.sampled.IsZero() {
			s.sampled = time.Now()
		}
		return
	}
	raw, e := s.run("/usr/sbin/wpa_cli", "-i", "wlan0", "all_sta")
	if e != nil {
		s.problem = "无法读取 Wi-Fi 关联列表"
		if s.sampled.IsZero() {
			s.sampled = time.Now()
		}
		return
	}
	stations, e := parseStations(raw)
	if e != nil {
		s.problem = "Wi-Fi 关联列表响应异常"
		if s.sampled.IsZero() {
			s.sampled = time.Now()
		}
		return
	}
	neighbors, e := s.run("/sbin/ip", "neigh", "show", "dev", "tether")
	s.addressWarning = e != nil
	addresses := parseNeighbors(neighbors)
	now := time.Now()
	for mac, d := range s.devices {
		d.Online = false
		d.Connected = nil
		d.Addresses = []string{}
		s.devices[mac] = d
	}
	seen := map[string]bool{}
	for _, d := range stations {
		if !d.Online {
			continue
		}
		seen[d.MAC] = true
		previous := s.devices[d.MAC]
		d.Note = previous.Note
		d.LastSeen = now
		d.Addresses = addresses[d.MAC]
		if d.Addresses == nil {
			d.Addresses = []string{}
		}
		s.devices[d.MAC] = d
	}
	// Also detect non-Wi-Fi clients connected via bridge ports (e.g. USB tethering)
	bridgeOut, _ := s.run("/usr/bin/brctl", "showmacs", "tether")
	for _, line := range strings.Split(bridgeOut, "\n") {
		f := strings.Fields(line)
		if len(f) < 3 || f[2] != "no" {
			continue
		}
		mac := canonicalMAC(f[1])
		if mac == "" || seen[mac] {
			continue
		}
		addrs := addresses[mac]
		if len(addrs) == 0 || firstIPv4(addrs) == "" {
			continue
		}
		seen[mac] = true
		previous := s.devices[mac]
		note := previous.Note
		if note == "" {
			note = "USB 连接设备"
		}
		s.devices[mac] = wifiDevice{
			MAC:       mac,
			Online:    true,
			Addresses: addrs,
			Note:      note,
			LastSeen:  now,
		}
	}
	for len(s.devices) > 256 {
		oldest := ""
		for mac, d := range s.devices {
			if !d.Online && (oldest == "" || d.LastSeen.Before(s.devices[oldest].LastSeen)) {
				oldest = mac
			}
		}
		if oldest == "" {
			break
		}
		delete(s.devices, oldest)
	}
	s.sampled = now
	if time.Since(s.lastWrite) >= 5*time.Minute {
		s.storageWarning = s.persistLocked() != nil
	}
}
func (s *deviceService) start() {
	go func() {
		s.refresh()
		ticker := time.NewTicker(15 * time.Second)
		defer ticker.Stop()
		for range ticker.C {
			s.refresh()
		}
	}()
}
func (s *deviceService) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.Header().Set("Cache-Control", "no-store")
	if r.URL.Path != "/air-api/devices" && r.URL.Path != "/air-api/devices/kick" {
		http.NotFound(w, r)
		return
	}
	s.mu.Lock()
	defer s.mu.Unlock()
	if r.URL.Path == "/air-api/devices/kick" {
		if r.Method != http.MethodPost {
			w.Header().Set("Allow", "POST")
			http.Error(w, "Method not allowed", 405)
			return
		}
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
		d, ok := s.devices[mac]
		if !ok {
			http.Error(w, "Unknown device", 404)
			return
		}
		if !d.Online {
			http.Error(w, "Device is already offline", 409)
			return
		}
		out, err := s.run("/usr/sbin/wpa_cli", "-i", "wlan0", "deauthenticate", mac)
		if err != nil || strings.TrimSpace(out) != "OK" {
			http.Error(w, "Cannot disconnect device", 502)
			return
		}
		d.Online = false
		d.Connected = nil
		d.Addresses = []string{}
		s.devices[mac] = d
		json.NewEncoder(w).Encode(map[string]bool{"disconnected": true})
		return
	}
	switch r.Method {
	case http.MethodGet:
		records := make([]wifiDevice, 0, len(s.devices))
		for _, d := range s.devices {
			records = append(records, d)
		}
		sort.Slice(records, func(i, j int) bool {
			if records[i].Online != records[j].Online {
				return records[i].Online
			}
			return records[i].MAC < records[j].MAC
		})
		json.NewEncoder(w).Encode(struct {
			Devices        []wifiDevice `json:"devices"`
			Sampled        time.Time    `json:"sampled_at"`
			Error          string       `json:"error"`
			AddressWarning bool         `json:"address_warning"`
			StorageWarning bool         `json:"storage_warning"`
		}{records, s.sampled, s.problem, s.addressWarning, s.storageWarning})
	case http.MethodPut:
		if !strings.HasPrefix(r.Header.Get("Content-Type"), "application/json") {
			http.Error(w, "JSON required", 415)
			return
		}
		var input struct {
			MAC  string `json:"mac"`
			Note string `json:"note"`
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
		d, ok := s.devices[mac]
		if !ok {
			http.Error(w, "Unknown device", 404)
			return
		}
		input.Note = strings.TrimSpace(input.Note)
		if !utf8.ValidString(input.Note) || utf8.RuneCountInString(input.Note) > 64 {
			http.Error(w, "Note too long", 400)
			return
		}
		previous := d
		d.Note = input.Note
		s.devices[mac] = d
		if s.persistLocked() != nil {
			s.devices[mac] = previous
			s.storageWarning = true
			http.Error(w, "Cannot save note", 500)
			return
		}
		s.storageWarning = false
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
		d, ok := s.devices[mac]
		if !ok {
			http.Error(w, "Unknown device", 404)
			return
		}
		if d.Online {
			http.Error(w, "Online device cannot be deleted", 409)
			return
		}
		delete(s.devices, mac)
		if s.persistLocked() != nil {
			s.devices[mac] = d
			s.storageWarning = true
			http.Error(w, "Cannot delete device", 500)
			return
		}
		s.storageWarning = false
		json.NewEncoder(w).Encode(map[string]bool{"deleted": true})
	default:
		w.Header().Set("Allow", "GET, PUT, DELETE")
		http.Error(w, "Method not allowed", 405)
	}
}

var wifiDevices = newDeviceService("/home/root/admin-auth/devices.json")
