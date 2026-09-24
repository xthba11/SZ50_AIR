package main

import (
	"context"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"math"
	"net/http"
	"os"
	"os/exec"
	"path/filepath"
	"sort"
	"strconv"
	"strings"
	"sync"
	"time"
)

type ScannedNetwork struct {
	BSSID     string `json:"bssid"`
	SSID      string `json:"ssid"`
	Freq      int    `json:"freq"`
	Channel   int    `json:"channel"`
	Band      string `json:"band"`      // "2.4G" or "5G"
	RSSI      int    `json:"rssi"`
	Flags     string `json:"flags"`
	Bandwidth int    `json:"bandwidth"` // MHz: 20 / 40 / 80 / 160
}

type ChannelScore struct {
	Channel int `json:"channel"`
	Score   int `json:"score"` // 0-100 (100 = cleanest, 0 = congested)
	APCount int `json:"ap_count"`
	MaxRSSI int `json:"max_rssi"`
}

type RadarResponse struct {
	CurrentChannel     int            `json:"current_channel"`
	CurrentFreq        int            `json:"current_freq"`
	CurrentMode        string         `json:"current_mode"` // "2.4G" or "5G"
	CurrentSSID        string         `json:"current_ssid"`
	RecommendedChannel int            `json:"recommended_channel"`
	BestChannel24G     int            `json:"best_channel_24g"`
	BestChannel5G      int            `json:"best_channel_5g"`
	Networks           []ScannedNetwork `json:"networks"`
	Scores24G          []ChannelScore `json:"scores_24g"`
	Scores5G           []ChannelScore `json:"scores_5g"`
	Timestamp          int64          `json:"timestamp"`
}

type wifiRadarService struct {
	mu            sync.Mutex
	lastScan      time.Time
	lastResult    *RadarResponse
	runCmd        func(string, ...string) (string, error)
	sleep         func(time.Duration)
	softapIniPath string
	lastApplied   int // 最近一次用户请求生效的信道
}

func newWifiRadarService() *wifiRadarService {
	return &wifiRadarService{
		runCmd: func(name string, args ...string) (string, error) {
			ctx, cancel := context.WithTimeout(context.Background(), 8*time.Second)
			defer cancel()
			out, err := exec.CommandContext(ctx, name, args...).CombinedOutput()
			return string(out), err
		},
		sleep:         time.Sleep,
		softapIniPath: "/data/vendor/wifi/hostapd/softap.ini",
	}
}

var wifiRadar = newWifiRadarService()

func freqToChannel(freq int) (int, string) {
	if freq >= 2412 && freq <= 2484 {
		if freq == 2484 {
			return 14, "2.4G"
		}
		return (freq-2412)/5 + 1, "2.4G"
	}
	if freq >= 5180 && freq <= 5825 {
		return (freq - 5000) / 5, "5G"
	}
	return 0, "unknown"
}

// parseBSSBandwidth 从 IE 字节流解析带宽（MHz）。
// HT(45)/HT-OP(61)/VHT-OP(192) 三个 IE 足够覆盖 11n/11ac：
// 11ax 在 5GHz 沿用 VHT Operation 的带宽字段，在 2.4GHz 沿用 HT Operation，无需额外处理。
func parseBSSBandwidth(hexIE string) int {
	hexIE = strings.TrimSpace(hexIE)
	if hexIE == "" {
		return 0
	}
	data, err := hex.DecodeString(hexIE)
	if err != nil || len(data) < 2 {
		return 0
	}
	hasHT := false
	htSecondary := 0
	vhtWidth := -1
	vhtSeg1 := false
	for i := 0; i+2 <= len(data); {
		eid := data[i]
		elen := int(data[i+1])
		if i+2+elen > len(data) {
			break
		}
		body := data[i+2 : i+2+elen]
		switch eid {
		case 45: // HT Capabilities
			if elen >= 2 {
				hasHT = true
			}
		case 61: // HT Operation
			// 注意：body[0] 是 Primary Channel，body[1] 的低两位才是 Secondary Channel Offset
			// （0 = 不使用次信道 = 20MHz，1 = SCA，3 = SCB = 40MHz）。
			// 早期实现误用 body[0] 会拿主信道号当带宽标志 —— 例如主信道 11(0x0b) 会被误判成 40MHz。
			if elen >= 2 {
				htSecondary = int(body[1] & 0x03)
			}
		case 192: // VHT Operation
			// body[0] = Channel Width，body[1] = Center Frequency Segment 0，body[2] = Segment 1。
			// width=1(80MHz) 时若 seg1 非 0，实际是 160MHz（seg0/seg1 分别是两个 80MHz 段的中心频率）
			// —— 实测这类 AP（如 H3C Wi-Fi5）Cellular-Z 报 160MHz，只读 width 会误判成 80MHz。
			if elen >= 1 {
				vhtWidth = int(body[0])
			}
			if elen >= 3 && body[2] != 0 {
				vhtSeg1 = true
			}
		}
		i += 2 + elen
	}
	switch {
	case vhtWidth == 1:
		if vhtSeg1 {
			return 160
		}
		return 80
	case vhtWidth == 2 || vhtWidth == 3:
		return 160
	case vhtWidth == 0:
		if htSecondary != 0 {
			return 40
		}
		return 20
	}
	if htSecondary != 0 {
		return 40
	}
	if hasHT {
		return 20
	}
	return 20 // 11b/g/a 老式 AP 按 20MHz 记
}

// bandwidthWorkers 并发补读带宽的协程数。
// ⚠️ 实测 wpa_supplicant 的 ctrl 接口在并发请求下会**静默失败**（6 路并发时约 7% 的
// `wpa_cli bss` 拿不到 ie，串行则 8/8 全中），失败会被兜底成 20MHz 造成带宽误报。
// 因此并发压到 3 路，并在 bssBandwidth 里带退避重试。
const bandwidthWorkers = 3

// scanPlan 扫描计划：第一轮全频段（覆盖 2.4G 与所有 5G），第二轮只扫 5GHz 的 13 个信道。
// 原因：全信道扫描时每个信道驻留时间短，149-165（UNII-3）这类偏远的信道最容易被"跳过"——
// 实测同一环境下全频段轮只得到 8~9 个 149-165 的 AP，定向再扫一轮后可到 10 个以上，
// 而手机（天线更多、且不承担 AP 广播）能看到 18 个左右。
// ⚠️ 剩下的差距是物理层面的：设备在 AP 模式下只能用抢来的时隙扫描、且为 1x1 单天线，
// 与手机放在不同位置时的接收强度也不同，软件无法完全补齐。
var scanPlan = []string{
	"", // 全频段
	"freq=5180,5200,5220,5240,5260,5280,5300,5320,5745,5765,5785,5805,5825", // 5GHz 定向
}

func (s *wifiRadarService) bssBandwidth(bssid string) int {
	// 带退避重试：wpa_supplicant 的 ctrl 接口在并发/繁忙时会静默返回不含 ie 的结果，
	// 单次失败就把一个 160MHz 的 AP 兜底成 20MHz，因此最多试 3 次。
	for attempt := 0; attempt < 3; attempt++ {
		if attempt > 0 {
			s.sleep(time.Duration(150*attempt) * time.Millisecond)
		}
		out, err := s.runCmd("/usr/sbin/wpa_cli", "-i", "wlan0", "bss", bssid)
		if err != nil {
			continue
		}
		for _, line := range strings.Split(out, "\n") {
			line = strings.TrimSpace(line)
			if strings.HasPrefix(line, "ie=") {
				if bw := parseBSSBandwidth(strings.TrimPrefix(line, "ie=")); bw > 0 {
					return bw
				}
			}
		}
	}
	return 0
}

// fillBandwidths 为每个扫到的 AP 补读真实带宽。
// 三段式：① 并发 3 路快速补读 → ② 对仍取不到的重试（串行，实测串行 8/8 全中，
// 并发的少数静默失败就靠这一步捞回）→ ③ 最终仍无值的按 20MHz 记（最常见的值）。
func (s *wifiRadarService) fillBandwidths(networks []ScannedNetwork) {
	if len(networks) == 0 {
		return
	}
	sem := make(chan struct{}, bandwidthWorkers)
	var wg sync.WaitGroup
	for i := range networks {
		wg.Add(1)
		sem <- struct{}{}
		go func(idx int) {
			defer wg.Done()
			defer func() { <-sem }()
			networks[idx].Bandwidth = s.bssBandwidth(networks[idx].BSSID)
		}(i)
	}
	wg.Wait()

	retryIdx := make([]int, 0, 8)
	for i := range networks {
		if networks[i].Bandwidth <= 0 {
			retryIdx = append(retryIdx, i)
		}
	}
	for _, i := range retryIdx {
		if bw := s.bssBandwidth(networks[i].BSSID); bw > 0 {
			networks[i].Bandwidth = bw
		}
	}
	for i := range networks {
		if networks[i].Bandwidth <= 0 {
			networks[i].Bandwidth = 20
		}
	}
}

func parseScanResults(output string) []ScannedNetwork {
	lines := strings.Split(output, "\n")
	var networks []ScannedNetwork
	seen := make(map[string]bool)

	for _, line := range lines {
		line = strings.TrimSpace(line)
		if line == "" || strings.HasPrefix(line, "bssid") {
			continue
		}
		parts := strings.Split(line, "\t")
		if len(parts) < 4 {
			continue
		}
		bssid := strings.TrimSpace(parts[0])
		freq, err1 := strconv.Atoi(strings.TrimSpace(parts[1]))
		rssi, err2 := strconv.Atoi(strings.TrimSpace(parts[2]))
		if err1 != nil || err2 != nil {
			continue
		}
		flags := parts[3]
		ssid := ""
		if len(parts) >= 5 {
			ssid = strings.TrimSpace(parts[4])
		}

		ch, band := freqToChannel(freq)
		if ch == 0 {
			continue
		}

		// Deduplicate by BSSID
		if seen[bssid] {
			continue
		}
		seen[bssid] = true

		networks = append(networks, ScannedNetwork{
			BSSID:   bssid,
			SSID:    ssid,
			Freq:    freq,
			Channel: ch,
			Band:    band,
			RSSI:    rssi,
			Flags:   flags,
		})
	}

	// Sort by RSSI descending
	sort.Slice(networks, func(i, j int) bool {
		return networks[i].RSSI > networks[j].RSSI
	})

	return networks
}

func calculateScores(networks []ScannedNetwork) ([]ChannelScore, []ChannelScore, int, int) {
	return calculateScoresWithContext(networks, 0, "", "", "")
}

func calculateScoresWithContext(networks []ScannedNetwork, curCh int, curMode string, curSSID string, curBSSID string) ([]ChannelScore, []ChannelScore, int, int) {
	// 2.4G standard non-overlapping / usable channels: 1 to 13
	channels24G := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13}
	// 5G usable channels supported by sc2355 SoftAP (including channels 52, 56, 60, 64):
	channels5G := []int{36, 40, 44, 48, 52, 56, 60, 64, 149, 153, 157, 161, 165}

	curBSSIDClean := strings.ToLower(strings.TrimSpace(curBSSID))
	curSSIDClean := strings.TrimSpace(curSSID)

	calcForChannels := func(candidateChannels []int, targetBand string, is24G bool) ([]ChannelScore, int) {
		scores := make([]ChannelScore, 0, len(candidateChannels))
		var minInterference float64 = math.MaxFloat64
		bestCh := candidateChannels[0]

		type chDetail struct {
			ch               int
			score            int
			apCount          int
			maxRSSI          int
			effectivePenalty float64
		}
		var details []chDetail

		for _, ch := range candidateChannels {
			var totalEnergy float64 = 0
			apCount := 0
			maxRSSI := -120

			for _, net := range networks {
				if net.Band != targetBand {
					continue
				}

				// Skip own AP signal if captured by active scan
				isSelf := false
				if curBSSIDClean != "" && strings.EqualFold(net.BSSID, curBSSIDClean) {
					isSelf = true
				} else if curSSIDClean != "" && net.SSID == curSSIDClean && net.Channel == curCh && targetBand == curMode {
					isSelf = true
				}
				if isSelf {
					continue
				}

				if is24G {
					diff := math.Abs(float64(net.Channel - ch))
					if diff == 0 {
						// Co-channel interference
						apCount++
						if net.RSSI > maxRSSI {
							maxRSSI = net.RSSI
						}
						energy := math.Pow(10, float64(net.RSSI+100)/10.0)
						totalEnergy += energy
					} else if diff < 5.0 {
						// Adjacent channel bleed (2.4G)
						weight := 1.0 - (diff / 5.0)
						energy := math.Pow(10, float64(net.RSSI+100)/10.0)
						totalEnergy += weight * energy * 0.4
					}
				} else {
					if net.Channel == ch {
						// Co-channel interference (5G)
						apCount++
						if net.RSSI > maxRSSI {
							maxRSSI = net.RSSI
						}
						energy := math.Pow(10, float64(net.RSSI+100)/10.0)
						totalEnergy += energy
					} else if math.Abs(float64(net.Channel-ch)) <= 4 {
						// Adjacent 5G channel bleed (minor)
						weight := 0.1
						energy := math.Pow(10, float64(net.RSSI+100)/10.0)
						totalEnergy += weight * energy
					}
				}
			}

			// Clean scoring logic:
			// 100 = completely clean (0 AP, 0 energy)
			var score int
			if apCount == 0 {
				if totalEnergy == 0 {
					score = 100
				} else {
					// Slight bleed penalty (at most 5-8 points)
					bleedPenalty := int(math.Min(8.0, totalEnergy/300.0))
					score = 100 - bleedPenalty
					if score < 92 {
						score = 92
					}
				}
				maxRSSI = 0
			} else {
				// Co-channel APs exist: must penalize noticeably!
				// Base penalty: 12 points per co-channel AP (capped at 30)
				basePenalty := apCount * 12
				if basePenalty > 30 {
					basePenalty = 30
				}
				// RSSI energy penalty
				energyPenalty := int(math.Min(50.0, totalEnergy/250.0))
				score = 100 - basePenalty - energyPenalty
				// Capped at 85 so an occupied channel NEVER scores higher than an empty one!
				if score > 85 {
					score = 85
				}
				if score < 10 {
					score = 10
				}
			}

			// Priority & Interference weight for best channel selection
			isPreferred24G := ch == 1 || ch == 6 || ch == 11
			effectivePenalty := totalEnergy + float64(apCount)*5000.0
			if is24G && !isPreferred24G {
				effectivePenalty += 2000.0 // penalty for non-standard 2.4G channels
			}

			details = append(details, chDetail{
				ch:               ch,
				score:            score,
				apCount:          apCount,
				maxRSSI:          maxRSSI,
				effectivePenalty: effectivePenalty,
			})

			scores = append(scores, ChannelScore{
				Channel: ch,
				Score:   score,
				APCount: apCount,
				MaxRSSI: maxRSSI,
			})
		}

		// Find candidate with lowest effective penalty
		for _, d := range details {
			if d.effectivePenalty < minInterference {
				minInterference = d.effectivePenalty
				bestCh = d.ch
			}
		}

		// Hysteresis / Stability Protection:
		// If current channel is in this band and is clean or nearly identical to the best candidate,
		// avoid recommending unnecessary channel changes (which drop active connections).
		if targetBand == curMode && curCh > 0 {
			var curDetail *chDetail
			for i := range details {
				if details[i].ch == curCh {
					curDetail = &details[i]
					break
				}
			}
			if curDetail != nil {
				var bestDetail *chDetail
				for i := range details {
					if details[i].ch == bestCh {
						bestDetail = &details[i]
						break
					}
				}
				if bestDetail != nil && curDetail.score >= bestDetail.score {
					bestCh = curCh
				} else if curDetail.apCount == 0 && curDetail.score >= 90 {
					bestCh = curCh
				} else if bestDetail != nil && (bestDetail.score-curDetail.score) < 10 {
					bestCh = curCh
				}
			}
		}

		return scores, bestCh
	}

	scores24G, best24G := calcForChannels(channels24G, "2.4G", true)
	scores5G, best5G := calcForChannels(channels5G, "5G", false)

	return scores24G, scores5G, best24G, best5G
}

func (s *wifiRadarService) getCurrentWifi() (int, int, string, string, string) {
	currentChannel := 0
	currentFreq := 0
	currentMode := "5G"
	currentSSID := ""
	currentBSSID := ""
	liveFreq := 0

	// 1. wpa_cli status：SSID / BSSID 可信；freq 只是"意图值"，信道切换后不会跟着变，仅作最后兜底。
	out, err := s.runCmd("/usr/sbin/wpa_cli", "-i", "wlan0", "status")
	if err == nil {
		for _, line := range strings.Split(out, "\n") {
			line = strings.TrimSpace(line)
			switch {
			case strings.HasPrefix(line, "freq="):
				if f, e := strconv.Atoi(strings.TrimPrefix(line, "freq=")); e == nil && f > 0 {
					liveFreq = f
				}
			case strings.HasPrefix(line, "ssid="):
				currentSSID = strings.TrimPrefix(line, "ssid=")
			case strings.HasPrefix(line, "bssid="):
				currentBSSID = strings.TrimPrefix(line, "bssid=")
			}
		}
	}

	// 2. 真实射频信道：驱动 sc2355 sprdwl_ng.ko 每次 START_AP 前打印
	//    "sprdwl_hook_reset_channel done, reset channel X -> Y"，Y 才是驱动真正用于建 AP 的信道。
	//    dmesg 只保留本次开机的记录，不会读到跨重启的陈旧值。
	if dmesgOut, dErr := s.runCmd("/bin/dmesg"); dErr == nil {
		lines := strings.Split(dmesgOut, "\n")
		for i := len(lines) - 1; i >= 0; i-- {
			line := lines[i]
			if !strings.Contains(line, "sprdwl_hook_reset_channel done, reset channel") {
				continue
			}
			idx := strings.Index(line, "-> ")
			if idx == -1 {
				continue
			}
			fields := strings.Fields(strings.TrimSpace(line[idx+3:]))
			if len(fields) == 0 {
				continue
			}
			if hookCh, e := strconv.Atoi(fields[0]); e == nil && hookCh > 0 {
				currentChannel = hookCh
				break
			}
		}
	}

	// 3. 驱动输入文件 softap.ini：驱动读它决定 AP 信道，正常与 hook 的 Y 值一致。
	if currentChannel == 0 {
		currentChannel = s.readSoftapChannel()
	}

	// 4. connman 配置值（热点未起过时的兜底；注意它也只是配置值，不等于射频现状）
	if currentChannel == 0 {
		data, err := os.ReadFile("/var/lib/connman/settings")
		if err == nil {
			lines := strings.Split(string(data), "\n")
			inWifi := false
			for _, l := range lines {
				line := strings.TrimSpace(l)
				if strings.HasPrefix(line, "[") && strings.HasSuffix(line, "]") {
					inWifi = strings.EqualFold(line, "[WiFi]")
					continue
				}
				if inWifi {
					parts := strings.SplitN(line, "=", 2)
					if len(parts) == 2 {
						k := strings.TrimSpace(parts[0])
						v := strings.TrimSpace(parts[1])
						if k == "Tethering.Mode" && v != "" {
							currentMode = v
						}
						if k == "Tethering.Identifier" && currentSSID == "" {
							currentSSID = v
						}
						if k == "Tethering.Channel" && currentMode == "2.4G" {
							if ch, e := strconv.Atoi(v); e == nil && ch > 0 {
								currentChannel = ch
							}
						}
						if k == "Tethering.5gChannel" && (currentMode == "5G" || currentMode == "") {
							if ch, e := strconv.Atoi(v); e == nil && ch > 0 {
								currentChannel = ch
							}
						}
					}
				}
			}
		}
	}

	// 5. wpa_cli 上报的 freq：信道切换后它不会更新（实测切到 56 仍报 157），
	//    只在前面的真值来源全部拿不到时才用，避免拿滞后值冒充真实信道。
	if currentChannel == 0 && liveFreq > 0 {
		currentChannel, _ = freqToChannel(liveFreq)
		currentFreq = liveFreq
	}

	if currentChannel == 0 {
		currentChannel = 44
	}

	// 信道决定频段与频率
	if currentChannel <= 14 {
		currentMode = "2.4G"
	} else {
		currentMode = "5G"
	}
	if currentFreq <= 0 {
		currentFreq = channelToFreq(currentChannel, currentMode)
	}

	return currentChannel, currentFreq, currentMode, currentSSID, currentBSSID
}

// writeSoftapIni 原子写入驱动输入文件：先写临时文件再 rename。
// 直接 O_TRUNC 写有窗口期（掉电/进程被杀会留下 0 字节文件），
// 而空文件会让驱动打印 "Keywords channel not found" 并静默使用内部默认信道（实测 36），
// 表现就是用户看到的"信道自己跳回去了"。
func writeSoftapIni(path string, channel int) error {
	if path == "" || channel <= 0 {
		return nil
	}
	dir := filepath.Dir(path)
	if err := os.MkdirAll(dir, 0755); err != nil {
		return err
	}
	tmp := path + ".tmp"
	if err := os.WriteFile(tmp, []byte(fmt.Sprintf("channel=%d\n", channel)), 0666); err != nil {
		return err
	}
	return os.Rename(tmp, path)
}

// ensureSoftapIni 启动自愈：设备重启/掉电后 softap.ini 可能丢失或变成 0 字节，
// 此时用 connman 里保存的配置值重建它（都没有则回落到 44），并重载一次热点让驱动读到。
func (s *wifiRadarService) ensureSoftapIni() {
	if s.softapIniPath == "" {
		return
	}
	s.sleep(5 * time.Second) // 等开机流程先把热点拉起来
	if s.readSoftapChannel() > 0 {
		return
	}
	channel := connmanChannelFromSettings()
	if channel <= 0 {
		channel = 44
	}
	if err := writeSoftapIni(s.softapIniPath, channel); err != nil {
		return
	}
	go restartTethering(s.runCmd)
}

// startSoftapWatchdog 周期检查驱动输入文件。
// 实测设备上 /data/vendor/wifi/hostapd/softap.ini 会被莫名清空（掉电、驱动/其它进程重写），
// 空文件会让驱动打印 "Keywords channel not found" 并静默使用内部默认信道 —— 用户看到的就是"信道自己跳回去了"。
// 这里发现无效就按最近一次生效值（或 connman 配置值）重建，并重载一次热点让它真正生效。
func (s *wifiRadarService) startSoftapWatchdog() {
	go func() {
		unhealthy := 0
		for {
			time.Sleep(30 * time.Second)

			// (a) 热点健康检查：Wi-Fi 开着但 AP 实际不在（connman 假状态）时尝试恢复。
			//     连续两次（约 60 秒）异常才动手，避免打断正常的信道重载过程。
			if s.wifiPowered() && !tetheringUp(s.runCmd) {
				unhealthy++
				if unhealthy >= 2 {
					unhealthy = 0
					s.mu.Lock()
					s.lastResult = nil
					s.mu.Unlock()
					go restartTethering(s.runCmd)
					continue
				}
			} else {
				unhealthy = 0
			}

			// (b) 驱动输入文件自愈
			if s.softapIniPath == "" {
				continue
			}
			if s.readSoftapChannel() > 0 {
				continue
			}
			s.mu.Lock()
			target := s.lastApplied
			s.mu.Unlock()
			if target <= 0 {
				target = connmanChannelFromSettings()
			}
			if target <= 0 {
				target = 44
			}
			if err := writeSoftapIni(s.softapIniPath, target); err == nil {
				s.mu.Lock()
				s.lastResult = nil
				s.mu.Unlock()
				go restartTethering(s.runCmd)
			}
		}
	}()
}

// connmanChannelFromSettings 读取 /var/lib/connman/settings 里保存的 5G / 2.4G 信道
func connmanChannelFromSettings() int {
	data, err := os.ReadFile("/var/lib/connman/settings")
	if err != nil {
		return 0
	}
	channel := 0
	inWifi := false
	for _, l := range strings.Split(string(data), "\n") {
		line := strings.TrimSpace(l)
		if strings.HasPrefix(line, "[") && strings.HasSuffix(line, "]") {
			inWifi = strings.EqualFold(line, "[WiFi]")
			continue
		}
		if !inWifi {
			continue
		}
		for _, k := range []string{"Tethering.Channel=", "Tethering.5gChannel="} {
			if strings.HasPrefix(line, k) {
				if ch, e := strconv.Atoi(strings.TrimSpace(strings.TrimPrefix(line, k))); e == nil && ch > 0 {
					channel = ch
				}
			}
		}
	}
	return channel
}

// tetheringUp 判定热点是否真的在广播：以 wpa_supplicant 的接口状态为准。
func tetheringUp(runCmd func(string, ...string) (string, error)) bool {
	out, err := runCmd("/usr/sbin/wpa_cli", "-i", "wlan0", "status")
	return err == nil && strings.Contains(out, "wpa_state=COMPLETED")
}

// wifiPowered 判定 Wi-Fi 射频是否开启（用户没有主动关掉 Wi-Fi）。
func (s *wifiRadarService) wifiPowered() bool {
	out, err := s.runCmd("/usr/bin/connmanctl", "technologies")
	if err != nil {
		return false
	}
	inWifi := false
	for _, l := range strings.Split(out, "\n") {
		trim := strings.TrimSpace(l)
		if strings.HasPrefix(trim, "/net/connman/technology/wifi") {
			inWifi = true
			continue
		}
		if strings.HasPrefix(trim, "/net/connman/technology/") {
			inWifi = false
		}
		if inWifi && strings.EqualFold(trim, "Powered = True") {
			return true
		}
	}
	return false
}

// restartTethering 异步重载热点：热点重启会重建 tether 桥 / USB 链路，
// 同步等待会让调用方的 HTTP 连接被重置（实测前端报 RemoteDisconnected，但其实切换已生效），
// 所以先让响应发出去，再重载射频。
//
// 实机教训：off 之后太快 on 会失败，而 connman 会留下"tethering 已启用"的假状态 ——
// 此后 `tether wifi on` 一直返回 "Not supported"，热点永久起不来（本次只能重启设备恢复）。
// 因此这里必须带重试 + 健康校验，并且在兜底路径里重置 wifi technology。
func restartTethering(runCmd func(string, ...string) (string, error)) {
	time.Sleep(800 * time.Millisecond)
	_, _ = runCmd("/usr/bin/connmanctl", "tether", "wifi", "off")
	for attempt := 1; attempt <= 3; attempt++ {
		time.Sleep(time.Duration(1200+attempt*1200) * time.Millisecond)
		_, _ = runCmd("/usr/bin/connmanctl", "tether", "wifi", "on")
		if tetheringUp(runCmd) {
			return
		}
	}
	// 兜底：重置 wifi technology 后再拉起热点
	_, _ = runCmd("/usr/bin/connmanctl", "disable", "wifi")
	time.Sleep(3 * time.Second)
	_, _ = runCmd("/usr/bin/connmanctl", "enable", "wifi")
	time.Sleep(6 * time.Second)
	_, _ = runCmd("/usr/bin/connmanctl", "tether", "wifi", "on")
}

// readSoftapChannel 读取驱动输入文件里的信道（sc2355 sprdwl_ng.ko 建 AP 时读它）
func (s *wifiRadarService) readSoftapChannel() int {
	if s.softapIniPath == "" {
		return 0
	}
	data, err := os.ReadFile(s.softapIniPath)
	if err != nil {
		return 0
	}
	for _, line := range strings.Split(string(data), "\n") {
		line = strings.TrimSpace(line)
		if strings.HasPrefix(line, "channel=") {
			v := strings.TrimSpace(strings.TrimPrefix(line, "channel="))
			if ch, e := strconv.Atoi(v); e == nil && ch > 0 {
				return ch
			}
		}
	}
	return 0
}

func (s *wifiRadarService) scanNow() (*RadarResponse, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	// Return cached if scanned within 5 seconds
	if s.lastResult != nil && time.Since(s.lastScan) < 5*time.Second {
		return s.lastResult, nil
	}

	// 主动扫描：按 scanPlan 跑多轮并按 BSSID 合并（同 BSSID 取信号较强的一次；
	// 同名同信道不同 MAC 的 AP 各自保留），显著提高覆盖率。
	merged := map[string]ScannedNetwork{}
	for round, freqArg := range scanPlan {
		if round > 0 {
			s.sleep(600 * time.Millisecond)
		}
		if freqArg == "" {
			_, _ = s.runCmd("/usr/sbin/wpa_cli", "-i", "wlan0", "scan")
		} else {
			_, _ = s.runCmd("/usr/sbin/wpa_cli", "-i", "wlan0", "scan", freqArg)
		}
		s.sleep(2500 * time.Millisecond)

		out, err := s.runCmd("/usr/sbin/wpa_cli", "-i", "wlan0", "scan_results")
		if err != nil {
			continue
		}
		for _, n := range parseScanResults(out) {
			if n.BSSID == "" {
				continue
			}
			if prev, ok := merged[n.BSSID]; !ok || n.RSSI > prev.RSSI {
				merged[n.BSSID] = n
			}
		}
	}
	if len(merged) == 0 {
		return nil, fmt.Errorf("scan failed: no results")
	}

	networks := make([]ScannedNetwork, 0, len(merged))
	for _, n := range merged {
		networks = append(networks, n)
	}
	sort.Slice(networks, func(i, j int) bool { return networks[i].RSSI > networks[j].RSSI })
	s.fillBandwidths(networks)
	curCh, curFreq, curMode, curSSID, curBSSID := s.getCurrentWifi()
	scores24G, scores5G, best24G, best5G := calculateScoresWithContext(networks, curCh, curMode, curSSID, curBSSID)

	recCh := best5G
	if curMode == "2.4G" {
		recCh = best24G
	}

	resp := &RadarResponse{
		CurrentChannel:     curCh,
		CurrentFreq:        curFreq,
		CurrentMode:        curMode,
		CurrentSSID:        curSSID,
		RecommendedChannel: recCh,
		BestChannel24G:     best24G,
		BestChannel5G:      best5G,
		Networks:           networks,
		Scores24G:          scores24G,
		Scores5G:           scores5G,
		Timestamp:          time.Now().Unix(),
	}

	s.lastScan = time.Now()
	s.lastResult = resp
	return resp, nil
}

func channelToFreq(channel int, band string) int {
	if band == "2.4G" || (band == "" && channel <= 14) {
		if channel >= 1 && channel <= 13 {
			return 2412 + (channel-1)*5
		}
		if channel == 14 {
			return 2484
		}
	}
	if channel >= 36 && channel <= 165 {
		return 5000 + channel*5
	}
	return 0
}

func updateConnmanSettingsFile(propKey string, channel int, mode string) {
	settingsPath := "/var/lib/connman/settings"
	data, err := os.ReadFile(settingsPath)
	if err != nil {
		return
	}
	var configKey string
	if propKey == "TetheringChannel" {
		configKey = "Tethering.Channel"
	} else {
		configKey = "Tethering.5gChannel"
	}
	lines := strings.Split(string(data), "\n")
	foundChan := false
	foundMode := (mode == "")
	for i, l := range lines {
		trim := strings.TrimSpace(l)
		if strings.HasPrefix(trim, configKey+"=") {
			lines[i] = fmt.Sprintf("%s=%d", configKey, channel)
			foundChan = true
		}
		if mode != "" && strings.HasPrefix(trim, "Tethering.Mode=") {
			lines[i] = fmt.Sprintf("Tethering.Mode=%s", mode)
			foundMode = true
		}
	}
	if !foundChan {
		for i, l := range lines {
			if strings.TrimSpace(l) == "[WiFi]" {
				lines = append(lines[:i+1], append([]string{fmt.Sprintf("%s=%d", configKey, channel)}, lines[i+1:]...)...)
				foundChan = true
				break
			}
		}
	}
	if !foundMode && mode != "" {
		for i, l := range lines {
			if strings.TrimSpace(l) == "[WiFi]" {
				lines = append(lines[:i+1], append([]string{fmt.Sprintf("Tethering.Mode=%s", mode)}, lines[i+1:]...)...)
				foundMode = true
				break
			}
		}
	}
	_ = os.WriteFile(settingsPath, []byte(strings.Join(lines, "\n")), 0600)
}

func updateConnmanSetting(key, value string) {
	settingsPath := "/var/lib/connman/settings"
	data, err := os.ReadFile(settingsPath)
	if err != nil {
		return
	}
	lines := strings.Split(string(data), "\n")
	found := false
	inWifi := false
	for i, l := range lines {
		trim := strings.TrimSpace(l)
		if strings.HasPrefix(trim, "[") && strings.HasSuffix(trim, "]") {
			inWifi = strings.EqualFold(trim, "[WiFi]")
			continue
		}
		if inWifi && strings.HasPrefix(trim, key+"=") {
			lines[i] = fmt.Sprintf("%s=%s", key, value)
			found = true
			break
		}
	}
	if !found {
		for i, l := range lines {
			if strings.EqualFold(strings.TrimSpace(l), "[WiFi]") {
				lines = append(lines[:i+1], append([]string{fmt.Sprintf("%s=%s", key, value)}, lines[i+1:]...)...)
				found = true
				break
			}
		}
	}
	_ = os.WriteFile(settingsPath, []byte(strings.Join(lines, "\n")), 0600)
}

func (s *wifiRadarService) getWifiPower() (bool, bool, error) {
	out, err := s.runCmd("/usr/bin/connmanctl", "technologies")
	powered := false
	tethering := false
	sawWifi := false
	if err == nil {
		inWifi := false
		for _, l := range strings.Split(out, "\n") {
			trim := strings.TrimSpace(l)
			if strings.HasPrefix(trim, "/net/connman/technology/wifi") {
				inWifi = true
				sawWifi = true
				continue
			} else if strings.HasPrefix(trim, "/net/connman/technology/") {
				inWifi = false
			}
			if inWifi {
				if strings.EqualFold(trim, "Powered = True") {
					powered = true
				}
				if strings.EqualFold(trim, "Tethering = True") {
					tethering = true
				}
			}
		}
	}
	// 只有在根本没解析到 wifi 段时才回落到配置文件，而且必须按 [WiFi] 段解析：
	// 之前用 strings.Contains 全文搜 "Tethering=true" 会命中 [Gadget] 段，
	// 导致关掉 Wi-Fi 后接口依然回报"已启用"。
	if !sawWifi {
		if data, err := os.ReadFile("/var/lib/connman/settings"); err == nil {
			inWifi := false
			for _, l := range strings.Split(string(data), "\n") {
				trim := strings.TrimSpace(l)
				if strings.HasPrefix(trim, "[") && strings.HasSuffix(trim, "]") {
					inWifi = strings.EqualFold(trim, "[WiFi]")
					continue
				}
				if !inWifi {
					continue
				}
				if strings.EqualFold(trim, "Enable=true") {
					powered = true
				}
				if strings.EqualFold(trim, "Tethering=true") {
					tethering = true
				}
			}
		}
	}
	// Wi-Fi hotspot switch state is determined by Tethering
	_ = powered
	return tethering, tethering, nil
}

func (s *wifiRadarService) setWifiPower(enable bool) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if !enable {
		// 关闭 Wi-Fi：走原厂命令 —— connmanctl disable wifi 会真正下电无线射频并让驱动熄灭指示灯
		// （实测：Powered=False / Tethering=False / wifi_green=0，且不会自动恢复）。
		// 不再改写 /var/lib/connman/settings，避免 connman 配置与内存状态打架。
		_, _ = s.runCmd("/usr/bin/connmanctl", "disable", "wifi")
		_ = os.WriteFile("/sys/class/leds/wifi_green/brightness", []byte("0\n"), 0644)
		s.lastResult = nil
		return nil
	}

	// 开启 Wi-Fi: 确保驱动在线并启用射频与点亮指示灯
	if out, _ := s.runCmd("/sbin/lsmod"); !strings.Contains(out, "sprdwl_ng") {
		_, _ = s.runCmd("/sbin/modprobe", "sprdwl_ng")
		s.sleep(600 * time.Millisecond)
	}

	_, _ = s.runCmd("/usr/bin/connmanctl", "enable", "wifi")
	_ = os.WriteFile("/sys/class/leds/wifi_green/brightness", []byte("1\n"), 0644)
	s.sleep(1200 * time.Millisecond)

	// 重新拉起热点；信道由驱动输入文件 softap.ini 决定，disable/enable 不会清掉它，
	// 所以关闭再打开不会丢失用户选定的信道。
	_, _ = s.runCmd("/usr/bin/connmanctl", "tether", "wifi", "on")
	s.lastResult = nil
	return nil
}

func (s *wifiRadarService) switchChannel(channel int, mode string) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if channel <= 0 {
		return fmt.Errorf("无效的信道")
	}

	if mode == "" {
		if channel <= 14 {
			mode = "2.4G"
		} else {
			mode = "5G"
		}
	}
	s.lastApplied = channel

	targetFreq := channelToFreq(channel, mode)
	if targetFreq == 0 {
		return fmt.Errorf("不支持的信道: %d", channel)
	}

	// 1. 写入真实驱动 ini 路径: /data/vendor/wifi/hostapd/softap.ini（原子写，掉电也不会留下空文件）
	_ = writeSoftapIni(s.softapIniPath, channel)

	// 2. 调用原厂 connmanctl 设定指令并持久化至 /var/lib/connman/settings
	if mode == "2.4G" || channel <= 14 {
		_, _ = s.runCmd("/usr/bin/connmanctl", "tethering_channel", strconv.Itoa(channel))
		updateConnmanSettingsFile("TetheringChannel", channel, mode)
	} else {
		_, _ = s.runCmd("/usr/bin/connmanctl", "tethering_5g_channel", strconv.Itoa(channel))
		updateConnmanSettingsFile("Tethering5gChannel", channel, mode)
	}

	// 3. 异步重载热点让新信道生效（同步等待会重置调用方的 HTTP 连接）
	s.lastResult = nil
	go restartTethering(s.runCmd)

	return nil
}

func (s *wifiRadarService) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.Header().Set("Cache-Control", "no-store")

	if r.URL.Path == "/air-api/wifi/power" {
		if r.Method == "POST" || r.Method == "PUT" {
			var req struct {
				Enable *bool `json:"enable"`
			}
			if err := json.NewDecoder(r.Body).Decode(&req); err != nil || req.Enable == nil {
				jsonReply(w, 400, map[string]string{"error": "缺少或无效的 enable 参数"})
				return
			}
			if err := s.setWifiPower(*req.Enable); err != nil {
				jsonReply(w, 500, map[string]string{"error": err.Error()})
				return
			}
			statusText := "已开启"
			if !*req.Enable {
				statusText = "已关闭"
			}
			jsonReply(w, 200, map[string]interface{}{
				"status":  "success",
				"enabled": *req.Enable,
				"message": fmt.Sprintf("Wi-Fi 热点%s", statusText),
			})
			return
		}
		enabled, tether, _ := s.getWifiPower()
		curCh, curFreq, curMode, curSSID, _ := s.getCurrentWifi()
		jsonReply(w, 200, map[string]interface{}{
			"enabled":   enabled,
			"tethering": tether,
			"channel":   curCh,
			"freq":      curFreq,
			"mode":      curMode,
			"ssid":      curSSID,
		})
		return
	}

	if r.URL.Path == "/air-api/wifi/channel" {
		if r.Method == "POST" || r.Method == "PUT" {
			var req struct {
				Channel int    `json:"channel"`
				Mode    string `json:"mode"`
			}
			if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
				jsonReply(w, 400, map[string]string{"error": "无效的信道参数"})
				return
			}
			if err := s.switchChannel(req.Channel, req.Mode); err != nil {
				jsonReply(w, 500, map[string]string{"error": err.Error()})
				return
			}
			jsonReply(w, 200, map[string]interface{}{
				"status":  "success",
				"channel": req.Channel,
				"message": fmt.Sprintf("信道已切换至 %d，热点正在重启", req.Channel),
			})
			return
		}
		curCh, curFreq, curMode, curSSID, _ := s.getCurrentWifi()
		jsonReply(w, 200, map[string]interface{}{
			"current_channel": curCh,
			"current_freq":    curFreq,
			"current_mode":    curMode,
			"current_ssid":    curSSID,
		})
		return
	}

	// GET /air-api/wifi/radar
	if r.Method != "GET" {
		http.Error(w, "Method not allowed", 405)
		return
	}

	resp, err := s.scanNow()
	if err != nil {
		jsonReply(w, 500, map[string]string{"error": err.Error()})
		return
	}

	jsonReply(w, 200, resp)
}
