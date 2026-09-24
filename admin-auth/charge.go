package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"strconv"
	"strings"
	"sync"
	"time"
)

type ChargeRule struct {
	ChargingEnabled bool `json:"charging_enabled"` // Hardware charging master switch
	Enabled         bool `json:"enabled"`          // Smart battery protection rule
	StartPercent    int  `json:"start_percent"`    // e.g. 20 (resume charging when capacity <= start_percent)
	StopPercent     int  `json:"stop_percent"`     // e.g. 80 (stop charging when capacity >= stop_percent)
}

type ChargeStatus struct {
	ChargingEnabled bool    `json:"charging_enabled"`
	Enabled         bool    `json:"enabled"`
	StartPercent    int     `json:"start_percent"`
	StopPercent     int     `json:"stop_percent"`
	Capacity        int     `json:"capacity"`
	Status          string  `json:"status"`
	VoltageV        float64 `json:"voltage_v"`
	CurrentMA       int     `json:"current_ma"`
	ChargingStopped bool    `json:"charging_stopped"`
	Message         string  `json:"message"`
}

type ChargeManager struct {
	mu           sync.Mutex
	rule         ChargeRule
	configPath   string
	capacityPath string
	statusPath   string
	stopFile     string
	trafficIni   string
	voltagePath  string
	currentPath        string
	currentControlPath string
	capacity           int
	batteryState       string
	voltageV           float64
	currentMA          int
	stopped            bool
	phase              string // "charging" (heading to stop_percent) or "discharging" (heading to start_percent)
	message            string
}

var chargeManager = newChargeManager(
	"/home/root/admin-auth/charge_rule.json",
	"/sys/class/power_supply/battery/capacity",
	"/sys/class/power_supply/battery/status",
	"/sys/class/power_supply/battery/charger.0/stop_charge",
	"/webui/traffic.ini",
	"/sys/class/power_supply/battery/voltage_now",
	"/sys/class/power_supply/battery/current_now",
	"/sys/class/power_supply/sgm4154x-charger/constant_charge_current",
)

func newChargeManager(config, capacity, status, stop, trafficIni string, optional ...string) *ChargeManager {
	voltage := "/sys/class/power_supply/battery/voltage_now"
	current := "/sys/class/power_supply/battery/current_now"
	currentControl := "/sys/class/power_supply/sgm4154x-charger/constant_charge_current"
	if len(optional) > 0 && optional[0] != "" {
		voltage = optional[0]
	}
	if len(optional) > 1 && optional[1] != "" {
		current = optional[1]
	}
	if len(optional) > 2 {
		currentControl = optional[2]
	}
	return &ChargeManager{
		configPath:         config,
		capacityPath:       capacity,
		statusPath:         status,
		stopFile:           stop,
		trafficIni:         trafficIni,
		voltagePath:        voltage,
		currentPath:        current,
		currentControlPath: currentControl,
		rule: ChargeRule{
			ChargingEnabled: true,
			Enabled:         false,
			StartPercent:    20,
			StopPercent:     80,
		},
		message: "智能充电保护已就绪",
	}
}

func (cm *ChargeManager) load() {
	cm.rule.ChargingEnabled = true
	data, err := os.ReadFile(cm.configPath)
	if err == nil {
		var r struct {
			ChargingEnabled *bool `json:"charging_enabled"`
			Enabled         bool  `json:"enabled"`
			StartPercent    int   `json:"start_percent"`
			StopPercent     int   `json:"stop_percent"`
		}
		if json.Unmarshal(data, &r) == nil {
			if r.ChargingEnabled != nil {
				cm.rule.ChargingEnabled = *r.ChargingEnabled
			}
			cm.rule.Enabled = r.Enabled
			if r.StartPercent < 5 {
				r.StartPercent = 20
			}
			if r.StopPercent > 100 || r.StopPercent <= r.StartPercent {
				r.StopPercent = 80
			}
			cm.rule.StartPercent = r.StartPercent
			cm.rule.StopPercent = r.StopPercent
		}
	}
}

func (cm *ChargeManager) save() error {
	data, err := json.MarshalIndent(cm.rule, "", "  ")
	if err != nil {
		return err
	}
	return os.WriteFile(cm.configPath, data, 0644)
}

func (cm *ChargeManager) setHardwareStop(stop bool) {
	val := "0\n"
	if stop {
		val = "1\n"
	}
	_ = os.WriteFile(cm.stopFile, []byte(val), 0644)

	if cm.currentControlPath != "" {
		curVal := "960000\n"
		if stop {
			curVal = "0\n"
		}
		_ = os.WriteFile(cm.currentControlPath, []byte(curVal), 0644)
	}

	cm.stopped = stop
}

func (cm *ChargeManager) readBattery() (int, string, bool, float64, int) {
	capVal := 0
	data, err := os.ReadFile(cm.capacityPath)
	if err == nil {
		n, _ := strconv.Atoi(strings.TrimSpace(string(data)))
		capVal = n
	}
	stateVal := "Unknown"
	data, err = os.ReadFile(cm.statusPath)
	if err == nil {
		stateVal = strings.TrimSpace(string(data))
	}
	stoppedVal := false
	data, err = os.ReadFile(cm.stopFile)
	if err == nil {
		stoppedVal = strings.TrimSpace(string(data)) == "1"
	}
	if !stoppedVal && cm.currentControlPath != "" {
		if curData, curErr := os.ReadFile(cm.currentControlPath); curErr == nil {
			if strings.TrimSpace(string(curData)) == "0" {
				stoppedVal = true
			}
		}
	}
	voltVal := 0.0
	if cm.voltagePath != "" {
		if data, err := os.ReadFile(cm.voltagePath); err == nil {
			if uv, err := strconv.ParseFloat(strings.TrimSpace(string(data)), 64); err == nil && uv > 0 {
				voltVal = float64(int(uv/1000.0+0.5)) / 1000.0
			}
		}
	}
	currVal := 0
	if cm.currentPath != "" {
		if data, err := os.ReadFile(cm.currentPath); err == nil {
			if ua, err := strconv.ParseInt(strings.TrimSpace(string(data)), 10, 64); err == nil {
				currVal = int(ua / 1000)
			}
		}
	}
	return capVal, stateVal, stoppedVal, voltVal, currVal
}

func (cm *ChargeManager) syncTrafficIni() {
	if cm.trafficIni == "" {
		return
	}
	content, err := os.ReadFile(cm.trafficIni)
	if err != nil {
		return
	}
	lines := strings.Split(string(content), "\n")
	newLines := make([]string, 0, len(lines)+3)
	hasAuto, hasMin, hasMax := false, false, false
	autoVal := "0"
	if cm.rule.Enabled {
		autoVal = "1"
	}
	for _, line := range lines {
		trimmed := strings.TrimSpace(line)
		if strings.HasPrefix(trimmed, "charge_auto=") {
			newLines = append(newLines, "charge_auto="+autoVal)
			hasAuto = true
		} else if strings.HasPrefix(trimmed, "charge_min=") {
			newLines = append(newLines, fmt.Sprintf("charge_min=%d", cm.rule.StartPercent))
			hasMin = true
		} else if strings.HasPrefix(trimmed, "charge_max=") {
			newLines = append(newLines, fmt.Sprintf("charge_max=%d", cm.rule.StopPercent))
			hasMax = true
		} else if trimmed != "" {
			newLines = append(newLines, line)
		}
	}
	if !hasAuto {
		newLines = append(newLines, "charge_auto="+autoVal)
	}
	if !hasMin {
		newLines = append(newLines, fmt.Sprintf("charge_min=%d", cm.rule.StartPercent))
	}
	if !hasMax {
		newLines = append(newLines, fmt.Sprintf("charge_max=%d", cm.rule.StopPercent))
	}
	_ = os.WriteFile(cm.trafficIni, []byte(strings.Join(newLines, "\n")+"\n"), 0644)
}

func (cm *ChargeManager) evaluate() {
	cm.mu.Lock()
	defer cm.mu.Unlock()

	capVal, stateVal, stoppedVal, voltVal, currVal := cm.readBattery()
	cm.capacity = capVal
	cm.batteryState = stateVal
	cm.stopped = stoppedVal
	cm.voltageV = voltVal
	cm.currentMA = currVal

	if !cm.rule.ChargingEnabled {
		if !cm.stopped {
			cm.setHardwareStop(true)
		}
		cm.message = "电池硬件充电已手动关闭（纯电池供电中）"
		return
	}

	if !cm.rule.Enabled {
		// Smart rule disabled: ensure charging is not stopped by rule
		if cm.stopped {
			cm.setHardwareStop(false)
		}
		cm.message = "智能保护未启用，维持正常充电"
		return
	}

	// Rule enabled: check thresholds with hysteresis phase
	if capVal >= cm.rule.StopPercent {
		cm.phase = "discharging"
		if !cm.stopped {
			cm.setHardwareStop(true)
		}
		cm.message = fmt.Sprintf("当前电量 %d%% ≥ %d%%，已自动停止充电保护电池", capVal, cm.rule.StopPercent)
	} else if capVal <= cm.rule.StartPercent {
		cm.phase = "charging"
		if cm.stopped {
			cm.setHardwareStop(false)
		}
		cm.message = fmt.Sprintf("当前电量 %d%% ≤ %d%%，已自动恢复充电", capVal, cm.rule.StartPercent)
	} else {
		if cm.phase == "" {
			if cm.stopped {
				cm.phase = "discharging"
			} else {
				cm.phase = "charging"
			}
		}
		if cm.phase == "discharging" {
			if !cm.stopped {
				cm.setHardwareStop(true)
			}
			cm.message = fmt.Sprintf("当前电量 %d%%，保护生效中（将在 ≤%d%% 时恢复充电）", capVal, cm.rule.StartPercent)
		} else {
			// In charging phase: keep charging active until StopPercent is reached
			if cm.stopped {
				cm.setHardwareStop(false)
			}
			cm.message = fmt.Sprintf("当前电量 %d%%，充电中（将在 ≥%d%% 时停止充电）", capVal, cm.rule.StopPercent)
		}
	}
}

func (cm *ChargeManager) start() {
	cm.load()
	cm.evaluate()
	go func() {
		ticker := time.NewTicker(10 * time.Second)
		defer ticker.Stop()
		for range ticker.C {
			cm.evaluate()
		}
	}()
}

func (cm *ChargeManager) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")

	if r.Method == http.MethodOptions {
		w.WriteHeader(http.StatusOK)
		return
	}

	if r.Method == http.MethodGet {
		cm.mu.Lock()
		capVal, stateVal, stoppedVal, voltVal, currVal := cm.readBattery()
		cm.capacity = capVal
		cm.batteryState = stateVal
		cm.stopped = stoppedVal
		cm.voltageV = voltVal
		cm.currentMA = currVal
		resp := ChargeStatus{
			ChargingEnabled: cm.rule.ChargingEnabled,
			Enabled:         cm.rule.Enabled,
			StartPercent:    cm.rule.StartPercent,
			StopPercent:     cm.rule.StopPercent,
			Capacity:        cm.capacity,
			Status:          cm.batteryState,
			VoltageV:        cm.voltageV,
			CurrentMA:       cm.currentMA,
			ChargingStopped: cm.stopped,
			Message:         cm.message,
		}
		cm.mu.Unlock()
		_ = json.NewEncoder(w).Encode(resp)
		return
	}

	if r.Method == http.MethodPost {
		var req struct {
			ChargingEnabled *bool `json:"charging_enabled"`
			Enabled         *bool `json:"enabled"`
			StartPercent    *int  `json:"start_percent"`
			StopPercent     *int  `json:"stop_percent"`
		}
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			http.Error(w, `{"error":"请求格式无效"}`, http.StatusBadRequest)
			return
		}

		cm.mu.Lock()
		if req.ChargingEnabled != nil {
			cm.rule.ChargingEnabled = *req.ChargingEnabled
		}
		if req.Enabled != nil {
			oldEnabled := cm.rule.Enabled
			cm.rule.Enabled = *req.Enabled
			if !oldEnabled && *req.Enabled {
				if cm.capacity < cm.rule.StopPercent {
					cm.phase = "charging"
					cm.stopped = false
					cm.setHardwareStop(false)
				}
			}
		}
		if req.StartPercent != nil {
			if *req.StartPercent >= 0 && *req.StartPercent <= 95 {
				cm.rule.StartPercent = *req.StartPercent
			}
		}
		if req.StopPercent != nil {
			if *req.StopPercent >= 10 && *req.StopPercent <= 100 {
				cm.rule.StopPercent = *req.StopPercent
			}
		}
		if cm.rule.StartPercent >= cm.rule.StopPercent {
			cm.rule.StartPercent = cm.rule.StopPercent - 10
		}
		_ = cm.save()
		cm.syncTrafficIni()
		cm.mu.Unlock()

		cm.evaluate()

		cm.mu.Lock()
		resp := ChargeStatus{
			ChargingEnabled: cm.rule.ChargingEnabled,
			Enabled:         cm.rule.Enabled,
			StartPercent:    cm.rule.StartPercent,
			StopPercent:     cm.rule.StopPercent,
			Capacity:        cm.capacity,
			Status:          cm.batteryState,
			VoltageV:        cm.voltageV,
			CurrentMA:       cm.currentMA,
			ChargingStopped: cm.stopped,
			Message:         cm.message,
		}
		cm.mu.Unlock()
		_ = json.NewEncoder(w).Encode(resp)
		return
	}

	http.Error(w, `{"error":"方法不受支持"}`, http.StatusMethodNotAllowed)
}
