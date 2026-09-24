package main

import (
	"encoding/json"
	"fmt"
	"math"
	"net/http"
	"os"
	"path/filepath"
	"strconv"
	"strings"
	"sync"
	"time"
)

const historyLimit = 30

type resourceUsage struct {
	Total     uint64 `json:"total_bytes"`
	Available uint64 `json:"available_bytes"`
}
type monitorSample struct {
	Signal       *cellularSignal    `json:"signal"`
	SignalError  string             `json:"signal_error"`
	At           time.Time          `json:"at"`
	CPU          *float64           `json:"cpu_percent"`
	Memory       *resourceUsage     `json:"memory"`
	Storage      *resourceUsage     `json:"storage"`
	Uptime       *float64           `json:"uptime_seconds"`
	Temperatures map[string]float64 `json:"temperatures"`
	Battery      *float64           `json:"battery_percent"`
	Charging     string             `json:"charging"`
	Errors       []string           `json:"errors"`
}
type monitorService struct {
	network     func() ([]byte, error)
	mu          sync.Mutex
	samples     []monitorSample
	total, idle uint64
	haveCPU     bool
	storage     *resourceUsage
	storageAt   time.Time
	read        func(string) ([]byte, error)
	glob        func(string) ([]string, error)
	run         func(string, ...string) (string, error)
}

func newMonitorService() *monitorService {
	return &monitorService{samples: []monitorSample{}, read: os.ReadFile, glob: filepath.Glob, run: deviceCommand, network: readCellularSignal}
}
func parseCPU(raw string) (uint64, uint64, error) {
	line := strings.SplitN(raw, "\n", 2)[0]
	f := strings.Fields(line)
	if len(f) < 5 || f[0] != "cpu" {
		return 0, 0, fmt.Errorf("invalid CPU counters")
	}
	var total, idle uint64
	// guest and guest_nice are already included in user and nice.
	for i := 1; i < len(f) && i <= 8; i++ {
		n, e := strconv.ParseUint(f[i], 10, 64)
		if e != nil {
			return 0, 0, e
		}
		total += n
		if i == 4 || i == 5 {
			idle += n
		}
	}
	return total, idle, nil
}
func parseMemory(raw string) (*resourceUsage, error) {
	values := map[string]uint64{}
	for _, line := range strings.Split(raw, "\n") {
		f := strings.Fields(line)
		if len(f) != 3 || f[2] != "kB" {
			continue
		}
		n, e := strconv.ParseUint(f[1], 10, 64)
		if e == nil {
			values[strings.TrimSuffix(f[0], ":")] = n * 1024
		}
	}
	total, ok := values["MemTotal"]
	available, has := values["MemAvailable"]
	if !ok || !has || total == 0 || available > total {
		return nil, fmt.Errorf("invalid memory")
	}
	return &resourceUsage{total, available}, nil
}
func parseStorage(raw string) (*resourceUsage, error) {
	lines := strings.Split(strings.TrimSpace(raw), "\n")
	if len(lines) < 2 {
		return nil, fmt.Errorf("invalid storage")
	}
	f := strings.Fields(lines[len(lines)-1])
	if len(f) < 6 {
		return nil, fmt.Errorf("invalid storage")
	}
	total, e := strconv.ParseUint(f[1], 10, 64)
	if e != nil {
		return nil, e
	}
	available, e := strconv.ParseUint(f[3], 10, 64)
	if e != nil || total == 0 || available > total {
		return nil, fmt.Errorf("invalid storage")
	}
	return &resourceUsage{total * 1024, available * 1024}, nil
}
func parseNumber(raw []byte) (*float64, error) {
	n, e := strconv.ParseFloat(strings.TrimSpace(string(raw)), 64)
	if e != nil || math.IsNaN(n) || math.IsInf(n, 0) {
		return nil, fmt.Errorf("invalid number")
	}
	return &n, nil
}
func (s *monitorService) sample() {
	s.mu.Lock()
	defer s.mu.Unlock()
	now := time.Now()
	p := monitorSample{At: now, Temperatures: map[string]float64{}, Errors: []string{}}
	raw, e := s.read("/proc/stat")
	if e == nil {
		total, idle, err := parseCPU(string(raw))
		if err == nil {
			if s.haveCPU && total > s.total && idle >= s.idle && idle-s.idle <= total-s.total {
				percent := 100 * (1 - float64(idle-s.idle)/float64(total-s.total))
				p.CPU = &percent
			}
			s.total = total
			s.idle = idle
			s.haveCPU = true
		} else {
			p.Errors = append(p.Errors, "CPU 读取失败")
			s.haveCPU = false
		}
	} else {
		p.Errors = append(p.Errors, "CPU 读取失败")
		s.haveCPU = false
	}
	raw, e = s.read("/proc/meminfo")
	if e == nil {
		p.Memory, e = parseMemory(string(raw))
	}
	if e != nil {
		p.Errors = append(p.Errors, "内存读取失败")
	}
	raw, e = s.read("/proc/uptime")
	if e == nil {
		f := strings.Fields(string(raw))
		if len(f) > 0 {
			p.Uptime, _ = parseNumber([]byte(f[0]))
		}
	}
	if p.Uptime == nil {
		p.Errors = append(p.Errors, "运行时间读取失败")
	}
	if now.Sub(s.storageAt) >= time.Minute || s.storageAt.IsZero() {
		out, err := s.run("/bin/df", "-Pk", "/home/root")
		s.storage = nil
		if err == nil {
			s.storage, err = parseStorage(out)
		}
		s.storageAt = now
	}
	p.Storage = s.storage
	if p.Storage == nil {
		p.Errors = append(p.Errors, "存储读取失败")
	}
	paths, err := s.glob("/sys/class/thermal/thermal_zone*")
	if err == nil {
		for _, path := range paths {
			kind, e1 := s.read(filepath.Join(path, "type"))
			temp, e2 := s.read(filepath.Join(path, "temp"))
			if e1 != nil || e2 != nil {
				continue
			}
			v, e := parseNumber(temp)
			if e == nil && *v >= -40000 && *v <= 150000 {
				key := strings.TrimSpace(string(kind)) + " (" + filepath.Base(path) + ")"
				p.Temperatures[key] = *v / 1000
			}
		}
	}
	if len(p.Temperatures) == 0 {
		p.Errors = append(p.Errors, "温度读取失败")
	}
	raw, e = s.read("/sys/class/power_supply/battery/capacity")
	if e == nil {
		v, err := parseNumber(raw)
		if err == nil && *v >= 0 && *v <= 100 {
			p.Battery = v
		}
	}
	raw, e = s.read("/sys/class/power_supply/battery/status")
	if e == nil {
		p.Charging = strings.TrimSpace(string(raw))
	}
	if s.network != nil {
		raw, err := s.network()
		if err == nil {
			p.Signal, err = parseCellularSignal(raw)
		}
		if err != nil {
			p.SignalError = "信号读取失败"
		}
	}
	s.samples = append(s.samples, p)
	if len(s.samples) > historyLimit {
		copy(s.samples, s.samples[len(s.samples)-historyLimit:])
		s.samples = s.samples[:historyLimit]
	}
}
func (s *monitorService) start() {
	go func() {
		s.sample()
		ticker := time.NewTicker(5 * time.Second)
		defer ticker.Stop()
		for range ticker.C {
			s.sample()
		}
	}()
}
func (s *monitorService) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Cache-Control", "no-store")
	if r.Method != http.MethodGet {
		w.Header().Set("Allow", "GET")
		http.Error(w, "Method not allowed", 405)
		return
	}
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	s.mu.Lock()
	defer s.mu.Unlock()
	json.NewEncoder(w).Encode(struct {
		Samples  []monitorSample `json:"samples"`
		Interval int             `json:"interval_seconds"`
	}{s.samples, 5})
}

var deviceMonitor = newMonitorService()
