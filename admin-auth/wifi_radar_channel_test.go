package main

import (
	"os"
	"path/filepath"
	"testing"
	"time"
)

// writeSoftapIni 必须原子落地：不留 .tmp 残留，且内容可被 readSoftapChannel 读回。
func TestWriteAndReadSoftapChannel(t *testing.T) {
	dir := t.TempDir()
	path := filepath.Join(dir, "wifi", "hostapd", "softap.ini")

	if err := writeSoftapIni(path, 44); err != nil {
		t.Fatalf("writeSoftapIni(44) 失败: %v", err)
	}
	s := &wifiRadarService{softapIniPath: path}
	if got := s.readSoftapChannel(); got != 44 {
		t.Fatalf("readSoftapChannel() = %d, want 44", got)
	}
	if _, err := os.Stat(path + ".tmp"); !os.IsNotExist(err) {
		t.Errorf("原子写不应残留临时文件 %s.tmp", path)
	}

	// 覆盖写：rename 之后内容应整体替换，而不是被截断成空文件
	if err := writeSoftapIni(path, 157); err != nil {
		t.Fatalf("writeSoftapIni(157) 失败: %v", err)
	}
	if got := s.readSoftapChannel(); got != 157 {
		t.Fatalf("覆盖写后 readSoftapChannel() = %d, want 157", got)
	}

	// 设备上该文件会被掉电清空成 0 字节，此时必须报 0（交由看门狗/自愈逻辑重建），
	// 而不是把空值当成合法信道。
	if err := os.WriteFile(path, []byte(""), 0666); err != nil {
		t.Fatal(err)
	}
	if got := s.readSoftapChannel(); got != 0 {
		t.Fatalf("空文件时 readSoftapChannel() = %d, want 0", got)
	}

	// 非法值同样不算有效信道
	if err := os.WriteFile(path, []byte("channel=abc\n"), 0666); err != nil {
		t.Fatal(err)
	}
	if got := s.readSoftapChannel(); got != 0 {
		t.Fatalf("非法内容时 readSoftapChannel() = %d, want 0", got)
	}

	// 空路径应安全返回，不 panic
	empty := &wifiRadarService{}
	if got := empty.readSoftapChannel(); got != 0 {
		t.Fatalf("空 softapIniPath 时 readSoftapChannel() = %d, want 0", got)
	}
}

// 回归测试：关闭 Wi-Fi 后 wifi 段全为 False 时，不能因为 settings 里 [Gadget] 段有
// Tethering=true 就把状态判成"已启用"（原实现用全文 strings.Contains 会命中 gadget 段）。
func TestGetWifiPowerIgnoresOtherTechnologies(t *testing.T) {
	technologies := `/net/connman/technology/gadget
  Name = Gadget
  Type = gadget
  Powered = True
  Connected = False
  Tethering = True
/net/connman/technology/wifi
  Name = WiFi
  Type = wifi
  Powered = False
  Connected = False
  Tethering = False
  TetheringIdentifier = SZ-immersing-5G
`
	svc := &wifiRadarService{
		sleep: func(time.Duration) {},
		runCmd: func(name string, args ...string) (string, error) {
			return technologies, nil
		},
	}
	enabled, tethering, err := svc.getWifiPower()
	if err != nil {
		t.Fatalf("getWifiPower() 返回错误: %v", err)
	}
	if enabled || tethering {
		t.Fatalf("Wi-Fi 段 Powered/Tethering 均为 False 时不应报告已启用，得到 enabled=%v tethering=%v", enabled, tethering)
	}
}

// Wi-Fi 段正常开启时（Powered/Tethering 为 True）应报告已启用。
func TestGetWifiPowerReportsEnabled(t *testing.T) {
	technologies := `/net/connman/technology/wifi
  Name = WiFi
  Type = wifi
  Powered = True
  Connected = False
  Tethering = True
`
	svc := &wifiRadarService{
		sleep: func(time.Duration) {},
		runCmd: func(name string, args ...string) (string, error) {
			return technologies, nil
		},
	}
	enabled, tethering, err := svc.getWifiPower()
	if err != nil {
		t.Fatalf("getWifiPower() 返回错误: %v", err)
	}
	if !enabled || !tethering {
		t.Fatalf("Wi-Fi 段开启时应报告已启用，得到 enabled=%v tethering=%v", enabled, tethering)
	}
}

// 驱动钩子日志是真实信道的首选来源：hook 的 Y 值应压过 wpa_cli 的滞后 freq。
func TestGetCurrentWifiPrefersDriverHook(t *testing.T) {
	svc := &wifiRadarService{
		sleep:         func(time.Duration) {},
		softapIniPath: filepath.Join(t.TempDir(), "softap.ini"),
		runCmd: func(name string, args ...string) (string, error) {
			switch name {
			case "/usr/sbin/wpa_cli":
				return "bssid=e8:6d:98:73:5a:ce\nfreq=5180\nssid=SZ-immersing-5G\nwpa_state=COMPLETED\n", nil
			case "/bin/dmesg":
				return "[  687.600369] c0 sc2355 sprd-wlan:sprdwl_hook_reset_channel done, reset channel 36 -> 157\n", nil
			}
			return "", nil
		},
	}

	ch, freq, mode, ssid, bssid := svc.getCurrentWifi()
	if ch != 157 || freq != 5785 || mode != "5G" {
		t.Fatalf("应以驱动钩子 Y 为准，得到 ch=%d freq=%d mode=%s", ch, freq, mode)
	}
	if ssid != "SZ-immersing-5G" || bssid != "e8:6d:98:73:5a:ce" {
		t.Fatalf("SSID/BSSID 应取自 wpa_cli，得到 ssid=%q bssid=%q", ssid, bssid)
	}
}

// 取最后一条钩子记录（设备会多次重启热点）。
func TestGetCurrentWifiUsesLatestHookLine(t *testing.T) {
	svc := &wifiRadarService{
		sleep:         func(time.Duration) {},
		softapIniPath: filepath.Join(t.TempDir(), "softap.ini"),
		runCmd: func(name string, args ...string) (string, error) {
			switch name {
			case "/bin/dmesg":
				return "[10] c0 sc2355 sprd-wlan:sprdwl_hook_reset_channel done, reset channel 36 -> 44\n" +
					"[20] c1 sc2355 sprd-wlan:sprdwl_hook_reset_channel done, reset channel 44 -> 56\n", nil
			}
			return "", nil
		},
	}
	ch, _, mode, _, _ := svc.getCurrentWifi()
	if ch != 56 || mode != "5G" {
		t.Fatalf("应取最新钩子记录 56，得到 ch=%d mode=%s", ch, mode)
	}
}

// 钩子日志不可用时（dmesg 被清空）回落到驱动输入文件 softap.ini。
func TestGetCurrentWifiFallsBackToSoftapIni(t *testing.T) {
	dir := t.TempDir()
	path := filepath.Join(dir, "softap.ini")
	if err := writeSoftapIni(path, 40); err != nil {
		t.Fatal(err)
	}
	svc := &wifiRadarService{
		sleep:         func(time.Duration) {},
		softapIniPath: path,
		runCmd: func(name string, args ...string) (string, error) {
			if name == "/bin/dmesg" {
				return "", nil // 无钩子记录
			}
			return "freq=5180\nssid=SZ-immersing-5G\n", nil
		},
	}
	ch, freq, mode, _, _ := svc.getCurrentWifi()
	if ch != 40 || freq != 5200 || mode != "5G" {
		t.Fatalf("应回落到 softap.ini 的 40，得到 ch=%d freq=%d mode=%s", ch, freq, mode)
	}
}

// 切换信道后 wpa_cli 仍报旧值；无钩子、无 ini 时才允许使用 wpa_cli 的 freq（最后兜底）。
func TestGetCurrentWifiLastResortWpaCli(t *testing.T) {
	svc := &wifiRadarService{
		sleep:         func(time.Duration) {},
		softapIniPath: filepath.Join(t.TempDir(), "softap.ini"),
		runCmd: func(name string, args ...string) (string, error) {
			if name == "/bin/dmesg" {
				return "", nil
			}
			return "freq=2437\nssid=SZ-immersing-5G\n", nil
		},
	}
	ch, freq, mode, _, _ := svc.getCurrentWifi()
	if ch != 6 || freq != 2437 || mode != "2.4G" {
		t.Fatalf("兜底应使用 wpa_cli freq，得到 ch=%d freq=%d mode=%s", ch, freq, mode)
	}
}
