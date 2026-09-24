package main

import (
	"bufio"
	"context"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io"
	"net"
	"net/http"
	"net/url"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
	"sync"
	"time"
)

type ProxyDayRecord struct {
	Date       string `json:"date"`
	RxBytes    uint64 `json:"rx_bytes"`
	TxBytes    uint64 `json:"tx_bytes"`
	TotalBytes uint64 `json:"total_bytes"`
}

type ProxyNode struct {
	ID        string    `json:"id"`
	Name      string    `json:"name"`
	Protocol  string    `json:"protocol"`
	Server    string    `json:"server"`
	Port      int       `json:"port"`
	Link      string    `json:"link"`
	LatencyMS int       `json:"latency_ms"`
	AddedAt   time.Time `json:"added_at"`
}

type NetworkSpeedPoint struct {
	At            time.Time `json:"at"`
	TotalDownBps  uint64    `json:"total_down_bps"`
	TotalUpBps    uint64    `json:"total_up_bps"`
	ProxyDownBps  uint64    `json:"proxy_down_bps"`
	ProxyUpBps    uint64    `json:"proxy_up_bps"`
	DirectDownBps uint64    `json:"direct_down_bps"`
	DirectUpBps   uint64    `json:"direct_up_bps"`
}

type proxyState struct {
	Enabled      bool        `json:"enabled"`
	RoutingMode  string      `json:"routing_mode"` // "bypass_cn" or "global"
	ActiveNodeID string      `json:"active_node_id"`
	Nodes        []ProxyNode `json:"nodes"`
	BypassList   []string    `json:"bypass_list,omitempty"`

	// Legacy backward compatibility fields
	NodeLink  string    `json:"node_link"`
	NodeName  string    `json:"node_name"`
	Protocol  string    `json:"protocol"`
	Server    string    `json:"server"`
	Port      int       `json:"port"`
	UpdatedAt time.Time `json:"updated_at"`
}

type proxyStatus struct {
	Enabled      bool        `json:"enabled"`
	Running      bool        `json:"running"`
	RoutingMode  string      `json:"routing_mode"`
	ActiveNodeID string      `json:"active_node_id"`
	Nodes        []ProxyNode `json:"nodes"`
	BypassList   []string    `json:"bypass_list"`
	NodeName     string      `json:"node_name"`
	Protocol     string      `json:"protocol"`
	Server       string      `json:"server"`
	Port         int         `json:"port"`
	NodeLink     string      `json:"node_link"`
	MemoryRSSKB  int         `json:"memory_rss_kb"`
	LatencyMS    int         `json:"latency_ms"`
	LastError    string      `json:"last_error"`
	UpdatedAt    string      `json:"updated_at"`
}

type proxyManager struct {
	mu           sync.RWMutex
	state        proxyState
	statePath    string
	dir          string
	xrayBin      string
	xrayPID      string
	iptables     string
	configPath   string
	lastError    string

	// Real-time network speed ring buffer
	speedSamples []NetworkSpeedPoint
	lastSampleAt time.Time
	lastTotalRx  uint64
	lastTotalTx  uint64
	lastProxyRx  uint64
	lastProxyTx  uint64

	// 30-day daily proxy traffic store
	dailyRecordPath   string
	dailyProxyRecords []ProxyDayRecord
	lastDailySave     time.Time
}

var proxyService = &proxyManager{
	dir:               "/home/root/admin-auth/proxy",
	statePath:         "/home/root/admin-auth/proxy/state.json",
	configPath:        "/home/root/admin-auth/proxy/config.json",
	dailyRecordPath:   "/home/root/admin-auth/proxy/daily_traffic.json",
	xrayBin:           "/home/root/admin-auth/xray",
	xrayPID:           "/var/run/xray.pid",
	iptables:          "/home/root/admin-auth/proxy_iptables.sh",
	speedSamples:      make([]NetworkSpeedPoint, 0, 30),
	dailyProxyRecords: make([]ProxyDayRecord, 0),
}

func (m *proxyManager) start() {
	m.mu.Lock()
	_ = os.MkdirAll(m.dir, 0755)
	m.loadState()
	m.loadDailyRecordsLocked()
	if m.state.Enabled && m.getActiveNodeLocked() != nil {
		if err := m.applyLocked(); err != nil {
			m.lastError = err.Error()
		}
	} else {
		// Ensure clean iptables state
		_ = exec.Command(m.iptables, "stop").Run()
	}
	m.mu.Unlock()

	// Start background speed sampler
	go m.speedSamplerLoop()
}

func (m *proxyManager) loadDailyRecordsLocked() {
	if m.dailyRecordPath == "" {
		m.dailyRecordPath = "/home/root/admin-auth/proxy/daily_traffic.json"
	}
	data, err := os.ReadFile(m.dailyRecordPath)
	if err != nil {
		m.dailyProxyRecords = make([]ProxyDayRecord, 0)
		return
	}
	var records []ProxyDayRecord
	if err := json.Unmarshal(data, &records); err == nil {
		m.dailyProxyRecords = records
	} else {
		m.dailyProxyRecords = make([]ProxyDayRecord, 0)
	}
}

func (m *proxyManager) saveDailyRecordsLocked() {
	if m.dailyRecordPath == "" {
		m.dailyRecordPath = "/home/root/admin-auth/proxy/daily_traffic.json"
	}
	_ = os.MkdirAll(filepath.Dir(m.dailyRecordPath), 0755)
	data, err := json.MarshalIndent(m.dailyProxyRecords, "", "  ")
	if err != nil {
		return
	}
	tmp := m.dailyRecordPath + ".tmp"
	if err := os.WriteFile(tmp, data, 0644); err == nil {
		_ = os.Rename(tmp, m.dailyRecordPath)
	}
}

func (m *proxyManager) recordProxyTrafficDeltaLocked(deltaRx, deltaTx uint64) {
	if deltaRx == 0 && deltaTx == 0 {
		return
	}
	today := time.Now().Format("2006-01-02")
	found := false
	for i := range m.dailyProxyRecords {
		if m.dailyProxyRecords[i].Date == today {
			m.dailyProxyRecords[i].RxBytes += deltaRx
			m.dailyProxyRecords[i].TxBytes += deltaTx
			m.dailyProxyRecords[i].TotalBytes = m.dailyProxyRecords[i].RxBytes + m.dailyProxyRecords[i].TxBytes
			found = true
			break
		}
	}
	if !found {
		m.dailyProxyRecords = append(m.dailyProxyRecords, ProxyDayRecord{
			Date:       today,
			RxBytes:    deltaRx,
			TxBytes:    deltaTx,
			TotalBytes: deltaRx + deltaTx,
		})
	}
	if len(m.dailyProxyRecords) > 30 {
		m.dailyProxyRecords = m.dailyProxyRecords[len(m.dailyProxyRecords)-30:]
	}
	if time.Since(m.lastDailySave) > 30*time.Second {
		m.saveDailyRecordsLocked()
		m.lastDailySave = time.Now()
	}
}


func (m *proxyManager) loadState() {
	data, err := os.ReadFile(m.statePath)
	if err != nil {
		if m.state.RoutingMode == "" {
			m.state.RoutingMode = "bypass_cn"
		}
		return
	}
	_ = json.Unmarshal(data, &m.state)

	if m.state.RoutingMode == "" {
		m.state.RoutingMode = "bypass_cn"
	}
	if m.state.BypassList == nil {
		m.state.BypassList = []string{}
	}

	// Migrate legacy single node to Nodes slice if needed
	if len(m.state.Nodes) == 0 && m.state.NodeLink != "" {
		out, err := parseProxyLink(m.state.NodeLink)
		name := m.state.NodeName
		proto := m.state.Protocol
		server := m.state.Server
		port := m.state.Port
		if err == nil && out != nil {
			if name == "" {
				name = out.Name
			}
			if proto == "" {
				proto = out.Protocol
			}
			if server == "" {
				server = out.Server
			}
			if port == 0 {
				port = out.Port
			}
		}
		node := ProxyNode{
			ID:       "node-1",
			Name:     name,
			Protocol: proto,
			Server:   server,
			Port:     port,
			Link:     m.state.NodeLink,
			AddedAt:  time.Now(),
		}
		m.state.Nodes = []ProxyNode{node}
		m.state.ActiveNodeID = "node-1"
	}

	// Ensure ActiveNodeID is valid
	if m.state.ActiveNodeID == "" && len(m.state.Nodes) > 0 {
		m.state.ActiveNodeID = m.state.Nodes[0].ID
	}
	m.syncActiveNodeFieldsLocked()
}

func (m *proxyManager) syncActiveNodeFieldsLocked() {
	active := m.getActiveNodeLocked()
	if active != nil {
		m.state.NodeLink = active.Link
		m.state.NodeName = active.Name
		m.state.Protocol = active.Protocol
		m.state.Server = active.Server
		m.state.Port = active.Port
	} else {
		m.state.NodeLink = ""
		m.state.NodeName = ""
		m.state.Protocol = ""
		m.state.Server = ""
		m.state.Port = 0
	}
}

func (m *proxyManager) getActiveNodeLocked() *ProxyNode {
	if m.state.ActiveNodeID != "" {
		for i := range m.state.Nodes {
			if m.state.Nodes[i].ID == m.state.ActiveNodeID {
				return &m.state.Nodes[i]
			}
		}
	}
	if len(m.state.Nodes) > 0 {
		m.state.ActiveNodeID = m.state.Nodes[0].ID
		return &m.state.Nodes[0]
	}
	return nil
}

func (m *proxyManager) saveState() error {
	m.syncActiveNodeFieldsLocked()
	m.state.UpdatedAt = time.Now()
	data, err := json.MarshalIndent(m.state, "", "  ")
	if err != nil {
		return err
	}
	return os.WriteFile(m.statePath, data, 0600)
}

// ParsedOutbound represents a single node outbound config for Xray
type ParsedOutbound struct {
	Protocol string
	Name     string
	Server   string
	Port     int
	Config   map[string]interface{}
}

func parseProxyLink(raw string) (*ParsedOutbound, error) {
	raw = strings.TrimSpace(raw)
	if raw == "" {
		return nil, fmt.Errorf("节点链接不能为空")
	}

	if strings.HasPrefix(raw, "vmess://") {
		return parseVMess(raw)
	} else if strings.HasPrefix(raw, "vless://") {
		return parseVLESS(raw)
	} else if strings.HasPrefix(raw, "trojan://") {
		return parseTrojan(raw)
	} else if strings.HasPrefix(raw, "ss://") {
		return parseShadowsocks(raw)
	}
	return nil, fmt.Errorf("不支持的代理链接格式，仅支持 vless://, vmess://, trojan://, ss://")
}

func parseVLESS(raw string) (*ParsedOutbound, error) {
	u, err := url.Parse(raw)
	if err != nil {
		return nil, fmt.Errorf("解析 VLESS 链接失败: %v", err)
	}

	uuid := u.User.Username()
	host := u.Hostname()
	port, err := strconv.Atoi(u.Port())
	if err != nil || port <= 0 {
		port = 443
	}

	name := u.Fragment
	if name == "" {
		name = fmt.Sprintf("VLESS-%s:%d", host, port)
	} else {
		name, _ = url.QueryUnescape(name)
	}

	query := u.Query()
	security := query.Get("security")
	netType := query.Get("type")
	if netType == "" {
		netType = "tcp"
	}
	sni := query.Get("sni")
	if sni == "" {
		sni = host
	}

	streamSettings := map[string]interface{}{
		"network": netType,
	}

	if security == "tls" || security == "reality" {
		streamSettings["security"] = security
		if security == "tls" {
			streamSettings["tlsSettings"] = map[string]interface{}{
				"serverName":    sni,
				"allowInsecure": false,
			}
		} else if security == "reality" {
			reality := map[string]interface{}{
				"serverName": sni,
				"publicKey":  query.Get("pbk"),
				"shortId":    query.Get("sid"),
				"spiderX":    query.Get("spx"),
			}
			streamSettings["realitySettings"] = reality
		}
	}

	if netType == "ws" {
		wsPath := query.Get("path")
		if wsPath == "" {
			wsPath = "/"
		}
		streamSettings["wsSettings"] = map[string]interface{}{
			"path": wsPath,
			"headers": map[string]string{
				"Host": query.Get("host"),
			},
		}
	} else if netType == "grpc" {
		streamSettings["grpcSettings"] = map[string]interface{}{
			"serviceName": query.Get("serviceName"),
		}
	}

	out := map[string]interface{}{
		"tag":            "proxy",
		"protocol":       "vless",
		"streamSettings": streamSettings,
		"settings": map[string]interface{}{
			"vnext": []map[string]interface{}{
				{
					"address": host,
					"port":    port,
					"users": []map[string]interface{}{
						{
							"id":         uuid,
							"encryption": "none",
							"flow":       query.Get("flow"),
						},
					},
				},
			},
		},
	}

	return &ParsedOutbound{
		Protocol: "vless",
		Name:     name,
		Server:   host,
		Port:     port,
		Config:   out,
	}, nil
}

func parseVMess(raw string) (*ParsedOutbound, error) {
	b64Part := strings.TrimPrefix(raw, "vmess://")
	decoded, err := decodeBase64Flexible(b64Part)
	if err != nil {
		return nil, fmt.Errorf("解析 VMess base64 失败: %v", err)
	}

	var data map[string]interface{}
	if err := json.Unmarshal(decoded, &data); err != nil {
		return nil, fmt.Errorf("解析 VMess JSON 失败: %v", err)
	}

	host, _ := data["add"].(string)
	var port int
	switch p := data["port"].(type) {
	case float64:
		port = int(p)
	case string:
		port, _ = strconv.Atoi(p)
	}
	if port <= 0 {
		port = 443
	}

	uuid, _ := data["id"].(string)
	name, _ := data["ps"].(string)
	if name == "" {
		name = fmt.Sprintf("VMess-%s:%d", host, port)
	}

	netType, _ := data["net"].(string)
	if netType == "" {
		netType = "tcp"
	}
	security, _ := data["tls"].(string)
	sni, _ := data["sni"].(string)
	if sni == "" {
		sni, _ = data["host"].(string)
	}
	if sni == "" {
		sni = host
	}

	streamSettings := map[string]interface{}{
		"network": netType,
	}
	if security == "tls" {
		streamSettings["security"] = "tls"
		streamSettings["tlsSettings"] = map[string]interface{}{
			"serverName":    sni,
			"allowInsecure": false,
		}
	}
	if netType == "ws" {
		wsPath, _ := data["path"].(string)
		if wsPath == "" {
			wsPath = "/"
		}
		h, _ := data["host"].(string)
		streamSettings["wsSettings"] = map[string]interface{}{
			"path": wsPath,
			"headers": map[string]string{
				"Host": h,
			},
		}
	}

	out := map[string]interface{}{
		"tag":            "proxy",
		"protocol":       "vmess",
		"streamSettings": streamSettings,
		"settings": map[string]interface{}{
			"vnext": []map[string]interface{}{
				{
					"address": host,
					"port":    port,
					"users": []map[string]interface{}{
						{
							"id":       uuid,
							"alterId":  0,
							"security": "auto",
						},
					},
				},
			},
		},
	}

	return &ParsedOutbound{
		Protocol: "vmess",
		Name:     name,
		Server:   host,
		Port:     port,
		Config:   out,
	}, nil
}

func parseTrojan(raw string) (*ParsedOutbound, error) {
	u, err := url.Parse(raw)
	if err != nil {
		return nil, fmt.Errorf("解析 Trojan 链接失败: %v", err)
	}

	password := u.User.Username()
	host := u.Hostname()
	port, err := strconv.Atoi(u.Port())
	if err != nil || port <= 0 {
		port = 443
	}

	name := u.Fragment
	if name == "" {
		name = fmt.Sprintf("Trojan-%s:%d", host, port)
	} else {
		name, _ = url.QueryUnescape(name)
	}

	query := u.Query()
	sni := query.Get("sni")
	if sni == "" {
		sni = host
	}

	netType := query.Get("type")
	if netType == "" {
		netType = "tcp"
	}

	streamSettings := map[string]interface{}{
		"network":  netType,
		"security": "tls",
		"tlsSettings": map[string]interface{}{
			"serverName":    sni,
			"allowInsecure": false,
		},
	}

	if netType == "ws" {
		wsPath := query.Get("path")
		if wsPath == "" {
			wsPath = "/"
		}
		streamSettings["wsSettings"] = map[string]interface{}{
			"path": wsPath,
			"headers": map[string]string{
				"Host": query.Get("host"),
			},
		}
	}

	out := map[string]interface{}{
		"tag":            "proxy",
		"protocol":       "trojan",
		"streamSettings": streamSettings,
		"settings": map[string]interface{}{
			"servers": []map[string]interface{}{
				{
					"address":  host,
					"port":     port,
					"password": password,
				},
			},
		},
	}

	return &ParsedOutbound{
		Protocol: "trojan",
		Name:     name,
		Server:   host,
		Port:     port,
		Config:   out,
	}, nil
}

func parseShadowsocks(raw string) (*ParsedOutbound, error) {
	u, err := url.Parse(raw)
	if err != nil {
		return nil, fmt.Errorf("解析 Shadowsocks 链接失败: %v", err)
	}

	var method, password, host string
	var port int

	name := u.Fragment
	if name != "" {
		name, _ = url.QueryUnescape(name)
	}

	if u.User != nil {
		method = u.User.Username()
		password, _ = u.User.Password()
		host = u.Hostname()
		port, _ = strconv.Atoi(u.Port())
	}

	if method == "" || password == "" || host == "" {
		b64Part := strings.TrimPrefix(raw, "ss://")
		if idx := strings.Index(b64Part, "#"); idx != -1 {
			b64Part = b64Part[:idx]
		}
		if atIdx := strings.Index(b64Part, "@"); atIdx != -1 {
			userBytes, err := decodeBase64Flexible(b64Part[:atIdx])
			if err == nil {
				parts := strings.SplitN(string(userBytes), ":", 2)
				if len(parts) == 2 {
					method = parts[0]
					password = parts[1]
				}
			}
			hostPort := b64Part[atIdx+1:]
			hp := strings.Split(hostPort, ":")
			if len(hp) == 2 {
				host = hp[0]
				port, _ = strconv.Atoi(hp[1])
			}
		} else {
			decoded, err := decodeBase64Flexible(b64Part)
			if err == nil {
				str := string(decoded)
				atIdx := strings.Index(str, "@")
				if atIdx != -1 {
					mp := strings.SplitN(str[:atIdx], ":", 2)
					if len(mp) == 2 {
						method = mp[0]
						password = mp[1]
					}
					hp := strings.Split(str[atIdx+1:], ":")
					if len(hp) == 2 {
						host = hp[0]
						port, _ = strconv.Atoi(hp[1])
					}
				}
			}
		}
	}

	if host == "" || port <= 0 || method == "" {
		return nil, fmt.Errorf("无效的 Shadowsocks 节点参数")
	}

	if name == "" {
		name = fmt.Sprintf("SS-%s:%d", host, port)
	}

	out := map[string]interface{}{
		"tag":      "proxy",
		"protocol": "shadowsocks",
		"settings": map[string]interface{}{
			"servers": []map[string]interface{}{
				{
					"address":  host,
					"port":     port,
					"method":   method,
					"password": password,
				},
			},
		},
	}

	return &ParsedOutbound{
		Protocol: "shadowsocks",
		Name:     name,
		Server:   host,
		Port:     port,
		Config:   out,
	}, nil
}

func decodeBase64Flexible(s string) ([]byte, error) {
	s = strings.TrimSpace(s)
	// Try standard
	if b, err := base64.StdEncoding.DecodeString(s); err == nil {
		return b, nil
	}
	// Try RawStdEncoding
	if b, err := base64.RawStdEncoding.DecodeString(s); err == nil {
		return b, nil
	}
	// Try URLEncoding
	if b, err := base64.URLEncoding.DecodeString(s); err == nil {
		return b, nil
	}
	// Try RawURLEncoding
	if b, err := base64.RawURLEncoding.DecodeString(s); err == nil {
		return b, nil
	}
	// Try adding padding
	if m := len(s) % 4; m != 0 {
		s += strings.Repeat("=", 4-m)
		if b, err := base64.StdEncoding.DecodeString(s); err == nil {
			return b, nil
		}
		if b, err := base64.URLEncoding.DecodeString(s); err == nil {
			return b, nil
		}
	}
	return nil, fmt.Errorf("base64 解码失败")
}

func parseSubscriptionText(text string) ([]ProxyNode, error) {
	text = strings.TrimSpace(text)
	if text == "" {
		return nil, fmt.Errorf("内容为空")
	}

	// Try base64 decoding the whole content
	if decoded, err := decodeBase64Flexible(text); err == nil && len(decoded) > 0 {
		decStr := string(decoded)
		if strings.Contains(decStr, "://") {
			text = decStr
		}
	}

	scanner := bufio.NewScanner(strings.NewReader(text))
	var nodes []ProxyNode
	now := time.Now()
	idx := 0

	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}
		out, err := parseProxyLink(line)
		if err != nil {
			continue
		}
		idx++
		nodeID := fmt.Sprintf("node-%d-%d", now.Unix(), idx)
		nodes = append(nodes, ProxyNode{
			ID:       nodeID,
			Name:     out.Name,
			Protocol: out.Protocol,
			Server:   out.Server,
			Port:     out.Port,
			Link:     line,
			AddedAt:  now,
		})
	}

	if len(nodes) == 0 {
		return nil, fmt.Errorf("未从内容中解析出有效的节点链接")
	}
	return nodes, nil
}

func fetchSubscription(subURL string) ([]ProxyNode, error) {
	subURL = strings.TrimSpace(subURL)
	if !strings.HasPrefix(subURL, "http://") && !strings.HasPrefix(subURL, "https://") {
		return nil, fmt.Errorf("无效的订阅链接，必须以 http:// 或 https:// 开头")
	}

	client := &http.Client{
		Timeout: 12 * time.Second,
	}
	req, err := http.NewRequest("GET", subURL, nil)
	if err != nil {
		return nil, err
	}
	req.Header.Set("User-Agent", "v2rayN/6.23 Clash/1.18.0 (SZ50-AIR)")

	resp, err := client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("拉取订阅失败: %v", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != 200 {
		return nil, fmt.Errorf("订阅服务器返回 HTTP %d", resp.StatusCode)
	}

	body, err := io.ReadAll(io.LimitReader(resp.Body, 2<<20)) // 2MB max
	if err != nil {
		return nil, fmt.Errorf("读取订阅内容失败: %v", err)
	}

	return parseSubscriptionText(string(body))
}

func buildXrayConfig(outbound *ParsedOutbound, routingMode string, bypassList []string) map[string]interface{} {
	if routingMode == "" {
		routingMode = "bypass_cn"
	}

	// Base routing rules
	rules := []map[string]interface{}{
		{
			"type":        "field",
			"inboundTag":  []string{"dns-in"},
			"outboundTag": "proxy",
		},
		{
			"type":        "field",
			"ip":          privateCIDRs,
			"outboundTag": "direct",
		},
	}

	// User Custom Bypass List (Force direct in ALL modes: both bypass_cn and global)
	var customDomains []string
	var customIPs []string
	for _, item := range bypassList {
		item = strings.ToLower(strings.TrimSpace(item))
		if item == "" {
			continue
		}
		if strings.Contains(item, "/") || net.ParseIP(item) != nil {
			customIPs = append(customIPs, item)
		} else {
			if strings.Contains(item, ":") {
				customDomains = append(customDomains, item)
			} else {
				customDomains = append(customDomains, "domain:"+item)
			}
		}
	}
	if len(customDomains) > 0 {
		rules = append(rules, map[string]interface{}{
			"type":        "field",
			"domain":      customDomains,
			"outboundTag": "direct",
		})
	}
	if len(customIPs) > 0 {
		rules = append(rules, map[string]interface{}{
			"type":        "field",
			"ip":          customIPs,
			"outboundTag": "direct",
		})
	}

	// If bypass_cn (smart split routing), bypass China domains and CIDRs
	if routingMode == "bypass_cn" {
		rules = append(rules,
			map[string]interface{}{
				"type":        "field",
				"domain":      chinaDomains,
				"outboundTag": "direct",
			},
			map[string]interface{}{
				"type":        "field",
				"ip":          chinaCIDRs,
				"outboundTag": "direct",
			},
		)
	}

	// Final catch-all: all TCP/UDP goes to proxy
	rules = append(rules, map[string]interface{}{
		"type":        "field",
		"network":     "tcp,udp",
		"outboundTag": "proxy",
	})

	return map[string]interface{}{
		"log": map[string]interface{}{
			"loglevel": "warning",
		},
		"inbounds": []map[string]interface{}{
			{
				"tag":      "transparent-tcp",
				"port":     12345,
				"protocol": "dokodemo-door",
				"settings": map[string]interface{}{
					"network":        "tcp",
					"followRedirect": true,
				},
				"sniffing": map[string]interface{}{
					"enabled":      true,
					"destOverride": []string{"http", "tls"},
				},
			},
			{
				"tag":      "dns-in",
				"port":     1053,
				"protocol": "dokodemo-door",
				"settings": map[string]interface{}{
					"network": "tcp,udp",
					"address": "1.1.1.1",
					"port":    53,
				},
			},
			{
				"tag":      "socks-in",
				"listen":   "127.0.0.1",
				"port":     10808,
				"protocol": "socks",
				"settings": map[string]interface{}{
					"auth": "noauth",
					"udp":  true,
				},
			},
		},
		"outbounds": []map[string]interface{}{
			outbound.Config,
			{
				"tag":      "direct",
				"protocol": "freedom",
				"settings": map[string]interface{}{},
			},
			{
				"tag":      "block",
				"protocol": "blackhole",
				"settings": map[string]interface{}{},
			},
		},
		"routing": map[string]interface{}{
			"domainStrategy": "IPIfNonMatch",
			"rules":          rules,
		},
	}
}

func (m *proxyManager) isRunning() bool {
	pidBytes, err := os.ReadFile(m.xrayPID)
	if err != nil {
		return false
	}
	pidStr := strings.TrimSpace(string(pidBytes))
	if pidStr == "" {
		return false
	}
	_, err = os.Stat(fmt.Sprintf("/proc/%s", pidStr))
	return err == nil
}

func (m *proxyManager) getMemoryRSS() int {
	pidBytes, err := os.ReadFile(m.xrayPID)
	if err != nil {
		return 0
	}
	pidStr := strings.TrimSpace(string(pidBytes))
	data, err := os.ReadFile(fmt.Sprintf("/proc/%s/status", pidStr))
	if err != nil {
		return 0
	}
	for _, line := range strings.Split(string(data), "\n") {
		if strings.HasPrefix(line, "VmRSS:") {
			fields := strings.Fields(line)
			if len(fields) >= 2 {
				kb, _ := strconv.Atoi(fields[1])
				return kb
			}
		}
	}
	return 0
}

func (m *proxyManager) applyLocked() error {
	if !m.state.Enabled {
		// Stop transparent proxy iptables first
		_ = exec.Command(m.iptables, "stop").Run()
		go trafficStats.refresh()
		// Stop xray
		_ = exec.Command("/sbin/start-stop-daemon", "-K", "-p", m.xrayPID, "-x", m.xrayBin).Run()
		return nil
	}

	active := m.getActiveNodeLocked()
	if active == nil {
		_ = exec.Command(m.iptables, "stop").Run()
		go trafficStats.refresh()
		_ = exec.Command("/sbin/start-stop-daemon", "-K", "-p", m.xrayPID, "-x", m.xrayBin).Run()
		return fmt.Errorf("未选择可用代理节点")
	}

	outbound, err := parseProxyLink(active.Link)
	if err != nil {
		return err
	}

	m.state.NodeName = outbound.Name
	m.state.Protocol = outbound.Protocol
	m.state.Server = outbound.Server
	m.state.Port = outbound.Port

	cfg := buildXrayConfig(outbound, m.state.RoutingMode, m.state.BypassList)
	cfgBytes, err := json.MarshalIndent(cfg, "", "  ")
	if err != nil {
		return err
	}

	if err := os.WriteFile(m.configPath, cfgBytes, 0644); err != nil {
		return fmt.Errorf("写入配置失败: %v", err)
	}

	// Test config validity
	testOut, err := exec.Command(m.xrayBin, "run", "-test", "-c", m.configPath).CombinedOutput()
	if err != nil {
		return fmt.Errorf("Xray 配置测试未通过: %s", string(testOut))
	}

	// Stop any existing instance
	_ = exec.Command("/sbin/start-stop-daemon", "-K", "-p", m.xrayPID, "-x", m.xrayBin).Run()
	time.Sleep(300 * time.Millisecond)

	// Start xray in background with start-stop-daemon
	startCmd := exec.Command("/sbin/start-stop-daemon", "-S", "-b", "-m", "-p", m.xrayPID, "-x", m.xrayBin, "--", "run", "-c", m.configPath)
	if err := startCmd.Run(); err != nil {
		return fmt.Errorf("启动 Xray 进程失败: %v", err)
	}

	// Wait up to 3s for port 12345 to listen
	ready := false
	for i := 0; i < 15; i++ {
		time.Sleep(200 * time.Millisecond)
		conn, err := net.DialTimeout("tcp", "127.0.0.1:12345", 200*time.Millisecond)
		if err == nil {
			conn.Close()
			ready = true
			break
		}
	}
	if !ready {
		_ = exec.Command("/sbin/start-stop-daemon", "-K", "-p", m.xrayPID, "-x", m.xrayBin).Run()
		return fmt.Errorf("Xray 启动后未在指定端口监听")
	}

	// Resolve server IP for iptables bypass
	serverIP := outbound.Server
	if ips, err := net.LookupIP(outbound.Server); err == nil && len(ips) > 0 {
		var ipStrs []string
		for _, ip := range ips {
			if ip.To4() != nil {
				ipStrs = append(ipStrs, ip.String())
			}
		}
		if len(ipStrs) > 0 {
			serverIP = strings.Join(ipStrs, " ")
		}
	}

	// Apply iptables redirection
	if err := exec.Command(m.iptables, "start", serverIP).Run(); err != nil {
		_ = exec.Command(m.iptables, "stop").Run()
		_ = exec.Command("/sbin/start-stop-daemon", "-K", "-p", m.xrayPID, "-x", m.xrayBin).Run()
		return fmt.Errorf("启用透明代理 iptables 规则失败: %v", err)
	}
	go trafficStats.refresh()

	return nil
}

func (m *proxyManager) testLatency(server string, port int) (int, error) {
	if server == "" || port == 0 {
		return 0, fmt.Errorf("未配置代理节点")
	}

	addr := fmt.Sprintf("%s:%d", server, port)
	start := time.Now()
	conn, err := net.DialTimeout("tcp", addr, 3*time.Second)
	if err != nil {
		return 0, fmt.Errorf("节点连接测试失败: %v", err)
	}
	conn.Close()
	return int(time.Since(start).Milliseconds()), nil
}

// Background network speed sampler loop
func (m *proxyManager) speedSamplerLoop() {
	ticker := time.NewTicker(2 * time.Second)
	defer ticker.Stop()

	for range ticker.C {
		m.sampleSpeed()
	}
}

func (m *proxyManager) sampleSpeed() {
	now := time.Now()

	// 1. Read WAN bytes (/proc/net/dev for sipa_eth0)
	totalRx, totalTx := readNetDevWAN()

	// 2. Read proxy bytes (AIR_PROXY_STATS iptables)
	proxyRx, proxyTx := readIptablesProxyBytes(m.iptables)

	m.mu.Lock()
	defer m.mu.Unlock()

	if m.lastSampleAt.IsZero() {
		m.lastSampleAt = now
		m.lastTotalRx = totalRx
		m.lastTotalTx = totalTx
		m.lastProxyRx = proxyRx
		m.lastProxyTx = proxyTx
		return
	}

	elapsed := now.Sub(m.lastSampleAt).Seconds()
	if elapsed <= 0.1 {
		return
	}

	var totalDownBps, totalUpBps uint64
	if totalRx >= m.lastTotalRx {
		totalDownBps = uint64(float64(totalRx-m.lastTotalRx) * 8.0 / elapsed)
	}
	if totalTx >= m.lastTotalTx {
		totalUpBps = uint64(float64(totalTx-m.lastTotalTx) * 8.0 / elapsed)
	}

	var proxyDownBps, proxyUpBps uint64
	var deltaProxyRx, deltaProxyTx uint64
	if proxyRx >= m.lastProxyRx {
		deltaProxyRx = proxyRx - m.lastProxyRx
		proxyDownBps = uint64(float64(deltaProxyRx) * 8.0 / elapsed)
	}
	if proxyTx >= m.lastProxyTx {
		deltaProxyTx = proxyTx - m.lastProxyTx
		proxyUpBps = uint64(float64(deltaProxyTx) * 8.0 / elapsed)
	}
	if deltaProxyRx > 0 || deltaProxyTx > 0 {
		m.recordProxyTrafficDeltaLocked(deltaProxyRx, deltaProxyTx)
	}


	// Calculate direct non-proxy bytes
	var directDownBps, directUpBps uint64
	if totalDownBps > proxyDownBps {
		directDownBps = totalDownBps - proxyDownBps
	}
	if totalUpBps > proxyUpBps {
		directUpBps = totalUpBps - proxyUpBps
	}

	m.lastSampleAt = now
	m.lastTotalRx = totalRx
	m.lastTotalTx = totalTx
	m.lastProxyRx = proxyRx
	m.lastProxyTx = proxyTx

	point := NetworkSpeedPoint{
		At:            now,
		TotalDownBps:  totalDownBps,
		TotalUpBps:    totalUpBps,
		ProxyDownBps:  proxyDownBps,
		ProxyUpBps:    proxyUpBps,
		DirectDownBps: directDownBps,
		DirectUpBps:   directUpBps,
	}

	if len(m.speedSamples) >= 30 {
		m.speedSamples = append(m.speedSamples[1:], point)
	} else {
		m.speedSamples = append(m.speedSamples, point)
	}
}

func readNetDevWAN() (rx uint64, tx uint64) {
	data, err := os.ReadFile("/proc/net/dev")
	if err != nil {
		return 0, 0
	}
	for _, line := range strings.Split(string(data), "\n") {
		line = strings.TrimSpace(line)
		if strings.HasPrefix(line, "sipa_eth0:") {
			fields := strings.Fields(line[len("sipa_eth0:"):])
			if len(fields) >= 9 {
				r, _ := strconv.ParseUint(fields[0], 10, 64)
				t, _ := strconv.ParseUint(fields[8], 10, 64)
				return r, t
			}
		}
	}
	return 0, 0
}

func readIptablesProxyBytes(iptablesPath string) (rx uint64, tx uint64) {
	ctx, cancel := context.WithTimeout(context.Background(), 1*time.Second)
	defer cancel()
	out, err := exec.CommandContext(ctx, "iptables", "-t", "filter", "-L", "AIR_PROXY_STATS", "-v", "-n", "-x").Output()
	if err != nil {
		return 0, 0
	}
	lines := strings.Split(string(out), "\n")
	for _, l := range lines {
		l = strings.TrimSpace(l)
		if strings.Contains(l, "spt:12345") {
			fields := strings.Fields(l)
			if len(fields) >= 2 {
				bytes, _ := strconv.ParseUint(fields[1], 10, 64)
				rx = bytes
			}
		} else if strings.Contains(l, "dpt:12345") {
			fields := strings.Fields(l)
			if len(fields) >= 2 {
				bytes, _ := strconv.ParseUint(fields[1], 10, 64)
				tx = bytes
			}
		}
	}
	return rx, tx
}

func (m *proxyManager) ServeDailyVnstat(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json; charset=utf-8")

	if r.Method == http.MethodDelete {
		m.mu.Lock()
		m.dailyProxyRecords = []ProxyDayRecord{}
		m.saveDailyRecordsLocked()
		m.mu.Unlock()
		_ = json.NewEncoder(w).Encode(map[string]interface{}{"ok": true, "message": "代理流量统计已清空"})
		return
	}

	days := make([]map[string]interface{}, 0)
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	cmd := exec.CommandContext(ctx, "/webui/vnstat", "-i", "sipa_eth0", "--json", "d", "30")
	out, err := cmd.Output()
	if err == nil {
		var raw map[string]interface{}
		if json.Unmarshal(out, &raw) == nil {
			if ifaces, ok := raw["interfaces"].([]interface{}); ok && len(ifaces) > 0 {
				if iface, ok := ifaces[0].(map[string]interface{}); ok {
					if traffic, ok := iface["traffic"].(map[string]interface{}); ok {
						if dayList, ok := traffic["day"].([]interface{}); ok {
							for _, d := range dayList {
								if dMap, ok := d.(map[string]interface{}); ok {
									dateMap, _ := dMap["date"].(map[string]interface{})
									year, _ := dateMap["year"].(float64)
									month, _ := dateMap["month"].(float64)
									day, _ := dateMap["day"].(float64)
									rx, _ := dMap["rx"].(float64)
									tx, _ := dMap["tx"].(float64)
									dateStr := fmt.Sprintf("%04d-%02d-%02d", int(year), int(month), int(day))
									days = append(days, map[string]interface{}{
										"date":        dateStr,
										"rx_bytes":    uint64(rx),
										"tx_bytes":    uint64(tx),
										"total_bytes": uint64(rx + tx),
									})
								}
							}
						}
					}
				}
			}
		}
	}

	m.mu.RLock()
	proxyDays := make([]ProxyDayRecord, len(m.dailyProxyRecords))
	copy(proxyDays, m.dailyProxyRecords)
	m.mu.RUnlock()

	todayStr := time.Now().Format("2006-01-02")
	monthPrefix := time.Now().Format("2006-01")

	var proxyToday ProxyDayRecord
	proxyToday.Date = todayStr
	var proxyMonth ProxyDayRecord
	proxyMonth.Date = monthPrefix

	for _, d := range proxyDays {
		if d.Date == todayStr {
			proxyToday.RxBytes = d.RxBytes
			proxyToday.TxBytes = d.TxBytes
			proxyToday.TotalBytes = d.TotalBytes
		}
		if strings.HasPrefix(d.Date, monthPrefix) {
			proxyMonth.RxBytes += d.RxBytes
			proxyMonth.TxBytes += d.TxBytes
			proxyMonth.TotalBytes += d.TotalBytes
		}
	}

	_ = json.NewEncoder(w).Encode(map[string]interface{}{
		"ok":          true,
		"days":        days,
		"proxy_days":  proxyDays,
		"proxy_today": proxyToday,
		"proxy_month": proxyMonth,
	})
}


func (m *proxyManager) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	path := r.URL.Path

	// Route network speed API
	if path == "/air-api/network/speed" || path == "/air-api/proxy/speed" {
		if r.Method != "GET" {
			http.Error(w, `{"error":"Method not allowed"}`, 405)
			return
		}
		m.mu.RLock()
		running := m.isRunning()
		enabled := m.state.Enabled && running
		samplesCopy := make([]NetworkSpeedPoint, len(m.speedSamples))
		copy(samplesCopy, m.speedSamples)
		m.mu.RUnlock()

		var last NetworkSpeedPoint
		if len(samplesCopy) > 0 {
			last = samplesCopy[len(samplesCopy)-1]
		}
		_ = json.NewEncoder(w).Encode(map[string]interface{}{
			"ok":            true,
			"proxy_enabled": enabled,
			"samples":       samplesCopy,
			"last":          last,
		})
		return
	}

	subpath := strings.TrimPrefix(path, "/air-api/proxy")

	switch subpath {
	case "", "/":
		if r.Method != "GET" {
			http.Error(w, `{"error":"Method not allowed"}`, 405)
			return
		}
		m.mu.RLock()
		running := m.isRunning()
		rss := 0
		if running {
			rss = m.getMemoryRSS()
		}
		active := m.getActiveNodeLocked()
		mode := m.state.RoutingMode
		if mode == "" {
			mode = "bypass_cn"
		}
		bypassList := m.state.BypassList
		if bypassList == nil {
			bypassList = []string{}
		}
		status := proxyStatus{
			Enabled:      m.state.Enabled,
			Running:      running,
			RoutingMode:  mode,
			ActiveNodeID: m.state.ActiveNodeID,
			Nodes:        m.state.Nodes,
			BypassList:   bypassList,
			NodeName:     m.state.NodeName,
			Protocol:     m.state.Protocol,
			Server:       m.state.Server,
			Port:         m.state.Port,
			NodeLink:     m.state.NodeLink,
			MemoryRSSKB:  rss,
			LastError:    m.lastError,
			UpdatedAt:    m.state.UpdatedAt.Format(time.RFC3339),
		}
		if active != nil {
			status.LatencyMS = active.LatencyMS
		}
		m.mu.RUnlock()
		_ = json.NewEncoder(w).Encode(status)

	case "/toggle":
		if r.Method != "POST" {
			http.Error(w, `{"error":"Method not allowed"}`, 405)
			return
		}
		var req struct {
			Enabled bool `json:"enabled"`
		}
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			http.Error(w, fmt.Sprintf(`{"error":"无效的请求参数: %v"}`, err), 400)
			return
		}

		m.mu.Lock()
		m.state.Enabled = req.Enabled
		var err error
		if err = m.applyLocked(); err != nil {
			m.lastError = err.Error()
		} else {
			m.lastError = ""
		}
		_ = m.saveState()
		m.mu.Unlock()

		if err != nil {
			http.Error(w, fmt.Sprintf(`{"error":"操作失败: %v"}`, err), 500)
			return
		}
		_ = json.NewEncoder(w).Encode(map[string]interface{}{"ok": true, "enabled": req.Enabled})

	case "/mode":
		if r.Method != "POST" {
			http.Error(w, `{"error":"Method not allowed"}`, 405)
			return
		}
		var req struct {
			Mode string `json:"mode"`
		}
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil || (req.Mode != "bypass_cn" && req.Mode != "global") {
			http.Error(w, `{"error":"无效的分流模式，支持 bypass_cn 或 global"}`, 400)
			return
		}

		m.mu.Lock()
		m.state.RoutingMode = req.Mode
		var err error
		if m.state.Enabled {
			if err = m.applyLocked(); err != nil {
				m.lastError = err.Error()
			} else {
				m.lastError = ""
			}
		}
		_ = m.saveState()
		m.mu.Unlock()

		if err != nil {
			http.Error(w, fmt.Sprintf(`{"error":"切换分流模式失败: %v"}`, err), 500)
			return
		}
		_ = json.NewEncoder(w).Encode(map[string]interface{}{"ok": true, "mode": req.Mode})

	case "/node":
		if r.Method != "POST" {
			http.Error(w, `{"error":"Method not allowed"}`, 405)
			return
		}
		var req struct {
			Link   string `json:"link"`
			SubURL string `json:"sub_url"`
			Text   string `json:"text"`
		}
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			http.Error(w, `{"error":"无效的请求体"}`, 400)
			return
		}

		var newNodes []ProxyNode
		var err error

		if req.SubURL != "" {
			newNodes, err = fetchSubscription(req.SubURL)
			if err != nil {
				http.Error(w, fmt.Sprintf(`{"error":"%v"}`, err), 400)
				return
			}
		} else {
			rawContent := req.Link
			if rawContent == "" {
				rawContent = req.Text
			}
			if strings.TrimSpace(rawContent) == "" {
				http.Error(w, `{"error":"缺少节点链接或内容"}`, 400)
				return
			}
			newNodes, err = parseSubscriptionText(rawContent)
			if err != nil {
				http.Error(w, fmt.Sprintf(`{"error":"%v"}`, err), 400)
				return
			}
		}

		m.mu.Lock()
		// Append new nodes, avoid duplicate links
		existingLinks := make(map[string]bool)
		for _, n := range m.state.Nodes {
			existingLinks[n.Link] = true
		}
		addedCount := 0
		for _, n := range newNodes {
			if !existingLinks[n.Link] {
				m.state.Nodes = append(m.state.Nodes, n)
				existingLinks[n.Link] = true
				addedCount++
			}
		}

		if m.state.ActiveNodeID == "" && len(m.state.Nodes) > 0 {
			m.state.ActiveNodeID = m.state.Nodes[0].ID
		}
		m.syncActiveNodeFieldsLocked()

		if m.state.Enabled {
			if err = m.applyLocked(); err != nil {
				m.lastError = err.Error()
			} else {
				m.lastError = ""
			}
		}
		_ = m.saveState()
		active := m.getActiveNodeLocked()
		nodesCopy := make([]ProxyNode, len(m.state.Nodes))
		copy(nodesCopy, m.state.Nodes)
		m.mu.Unlock()

		_ = json.NewEncoder(w).Encode(map[string]interface{}{
			"ok":          true,
			"added_count": addedCount,
			"total_nodes": len(nodesCopy),
			"active_id":   m.state.ActiveNodeID,
			"active_node": active,
		})

	case "/node/select":
		if r.Method != "POST" {
			http.Error(w, `{"error":"Method not allowed"}`, 405)
			return
		}
		var req struct {
			ID string `json:"id"`
		}
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil || req.ID == "" {
			http.Error(w, `{"error":"缺少节点 ID"}`, 400)
			return
		}

		m.mu.Lock()
		found := false
		for _, n := range m.state.Nodes {
			if n.ID == req.ID {
				found = true
				break
			}
		}
		if !found {
			m.mu.Unlock()
			http.Error(w, `{"error":"未找到指定节点"}`, 404)
			return
		}

		m.state.ActiveNodeID = req.ID
		m.syncActiveNodeFieldsLocked()

		var err error
		if m.state.Enabled {
			if err = m.applyLocked(); err != nil {
				m.lastError = err.Error()
			} else {
				m.lastError = ""
			}
		}
		_ = m.saveState()
		active := m.getActiveNodeLocked()
		m.mu.Unlock()

		if err != nil {
			http.Error(w, fmt.Sprintf(`{"error":"应用节点失败: %v"}`, err), 500)
			return
		}
		_ = json.NewEncoder(w).Encode(map[string]interface{}{
			"ok":          true,
			"active_id":   req.ID,
			"active_node": active,
		})

	case "/node/delete":
		if r.Method != "POST" && r.Method != "DELETE" {
			http.Error(w, `{"error":"Method not allowed"}`, 405)
			return
		}
		var req struct {
			ID string `json:"id"`
		}
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil || req.ID == "" {
			http.Error(w, `{"error":"缺少节点 ID"}`, 400)
			return
		}

		m.mu.Lock()
		newNodes := make([]ProxyNode, 0, len(m.state.Nodes))
		for _, n := range m.state.Nodes {
			if n.ID != req.ID {
				newNodes = append(newNodes, n)
			}
		}
		m.state.Nodes = newNodes
		wasActive := m.state.ActiveNodeID == req.ID
		if wasActive {
			if len(m.state.Nodes) > 0 {
				m.state.ActiveNodeID = m.state.Nodes[0].ID
			} else {
				m.state.ActiveNodeID = ""
			}
		}
		m.syncActiveNodeFieldsLocked()

		var err error
		if wasActive && m.state.Enabled {
			if err = m.applyLocked(); err != nil {
				m.lastError = err.Error()
			} else {
				m.lastError = ""
			}
		}
		_ = m.saveState()
		m.mu.Unlock()

		_ = json.NewEncoder(w).Encode(map[string]interface{}{
			"ok":          true,
			"total_nodes": len(newNodes),
			"active_id":   m.state.ActiveNodeID,
		})

	case "/node/rename":
		if r.Method != "POST" {
			http.Error(w, `{"error":"Method not allowed"}`, 405)
			return
		}
		var req struct {
			ID   string `json:"id"`
			Name string `json:"name"`
		}
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil || req.ID == "" {
			http.Error(w, `{"error":"缺少节点 ID"}`, 400)
			return
		}
		req.Name = strings.TrimSpace(req.Name)
		if req.Name == "" {
			http.Error(w, `{"error":"节点名称不能为空"}`, 400)
			return
		}

		m.mu.Lock()
		found := false
		for i := range m.state.Nodes {
			if m.state.Nodes[i].ID == req.ID {
				m.state.Nodes[i].Name = req.Name
				found = true
				break
			}
		}
		if !found {
			m.mu.Unlock()
			http.Error(w, `{"error":"未找到指定节点"}`, 404)
			return
		}
		if m.state.ActiveNodeID == req.ID {
			m.state.NodeName = req.Name
		}
		_ = m.saveState()
		m.mu.Unlock()

		_ = json.NewEncoder(w).Encode(map[string]interface{}{
			"ok":   true,
			"id":   req.ID,
			"name": req.Name,
		})

	case "/node/clear":
		if r.Method != "POST" {
			http.Error(w, `{"error":"Method not allowed"}`, 405)
			return
		}
		m.mu.Lock()
		m.state.Nodes = []ProxyNode{}
		m.state.ActiveNodeID = ""
		m.syncActiveNodeFieldsLocked()
		if m.state.Enabled {
			_ = m.applyLocked()
		}
		_ = m.saveState()
		m.mu.Unlock()
		_ = json.NewEncoder(w).Encode(map[string]interface{}{"ok": true})

	case "/test":
		if r.Method != "POST" {
			http.Error(w, `{"error":"Method not allowed"}`, 405)
			return
		}
		var req struct {
			ID string `json:"id"`
		}
		_ = json.NewDecoder(r.Body).Decode(&req)

		m.mu.RLock()
		targetServer := m.state.Server
		targetPort := m.state.Port
		targetID := m.state.ActiveNodeID
		if req.ID != "" {
			for _, n := range m.state.Nodes {
				if n.ID == req.ID {
					targetServer = n.Server
					targetPort = n.Port
					targetID = n.ID
					break
				}
			}
		}
		m.mu.RUnlock()

		latency, err := m.testLatency(targetServer, targetPort)
		if err != nil {
			_ = json.NewEncoder(w).Encode(map[string]interface{}{"ok": false, "error": err.Error()})
			return
		}

		// Update latency in node record
		m.mu.Lock()
		for i := range m.state.Nodes {
			if m.state.Nodes[i].ID == targetID {
				m.state.Nodes[i].LatencyMS = latency
				break
			}
		}
		_ = m.saveState()
		m.mu.Unlock()

		_ = json.NewEncoder(w).Encode(map[string]interface{}{
			"ok":         true,
			"id":         targetID,
			"latency_ms": latency,
		})

	case "/test-all":
		if r.Method != "POST" {
			http.Error(w, `{"error":"Method not allowed"}`, 405)
			return
		}
		m.mu.RLock()
		nodesCopy := make([]ProxyNode, len(m.state.Nodes))
		copy(nodesCopy, m.state.Nodes)
		m.mu.RUnlock()

		var wg sync.WaitGroup
		type pingRes struct {
			id      string
			latency int
			err     error
		}
		ch := make(chan pingRes, len(nodesCopy))

		for _, n := range nodesCopy {
			wg.Add(1)
			go func(node ProxyNode) {
				defer wg.Done()
				lat, err := m.testLatency(node.Server, node.Port)
				ch <- pingRes{id: node.ID, latency: lat, err: err}
			}(n)
		}
		wg.Wait()
		close(ch)

		results := make(map[string]interface{})
		m.mu.Lock()
		for res := range ch {
			if res.err == nil {
				results[res.id] = res.latency
				for i := range m.state.Nodes {
					if m.state.Nodes[i].ID == res.id {
						m.state.Nodes[i].LatencyMS = res.latency
						break
					}
				}
			} else {
				results[res.id] = -1
				for i := range m.state.Nodes {
					if m.state.Nodes[i].ID == res.id {
						m.state.Nodes[i].LatencyMS = -1
						break
					}
				}
			}
		}
		_ = m.saveState()
		m.mu.Unlock()

	case "/bypass":
		if r.Method == "GET" {
			m.mu.RLock()
			list := m.state.BypassList
			if list == nil {
				list = []string{}
			}
			m.mu.RUnlock()
			_ = json.NewEncoder(w).Encode(map[string]interface{}{
				"ok":          true,
				"bypass_list": list,
			})
			return
		}
		if r.Method != "POST" {
			http.Error(w, `{"error":"Method not allowed"}`, 405)
			return
		}
		var req struct {
			BypassList []string `json:"bypass_list"`
		}
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			http.Error(w, fmt.Sprintf(`{"error":"无效的请求格式: %v"}`, err), 400)
			return
		}

		cleanList := make([]string, 0, len(req.BypassList))
		seen := make(map[string]bool)
		for _, rawItem := range req.BypassList {
			item := strings.TrimSpace(rawItem)
			item = strings.TrimPrefix(item, "http://")
			item = strings.TrimPrefix(item, "https://")
			if idx := strings.Index(item, "/"); idx != -1 {
				item = item[:idx]
			}
			if idx := strings.Index(item, ":"); idx != -1 && !strings.Contains(item, "::") {
				if host, _, err := net.SplitHostPort(item); err == nil {
					item = host
				}
			}
			item = strings.ToLower(strings.TrimSpace(item))
			if item == "" || seen[item] {
				continue
			}
			seen[item] = true
			cleanList = append(cleanList, item)
		}

		m.mu.Lock()
		m.state.BypassList = cleanList
		var err error
		if m.state.Enabled {
			if err = m.applyLocked(); err != nil {
				m.lastError = err.Error()
			} else {
				m.lastError = ""
			}
		}
		_ = m.saveState()
		m.mu.Unlock()

		if err != nil {
			http.Error(w, fmt.Sprintf(`{"error":"应用排除名单失败: %v"}`, err), 500)
			return
		}
		_ = json.NewEncoder(w).Encode(map[string]interface{}{
			"ok":          true,
			"bypass_list": cleanList,
		})

	default:
		http.NotFound(w, r)
	}
}
