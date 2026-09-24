package main

import "testing"

// 合成 IE 样本：ID 45 = HT Capabilities，ID 61 = HT Operation，ID 192(0xc0) = VHT Operation。
// HT Operation body[0] = Primary Channel，**body[1] 的低两位才是 secondary channel offset**
// （0 = 20MHz，1 = SCA，3 = SCB = 40MHz）；
// VHT Operation body[0] = channel width（0 = 20/40 由 HT 决定，1 = 80MHz，2/3 = 160MHz）。
func TestParseBSSBandwidthSynthetic(t *testing.T) {
	// 注意：IE 的 len 字段必须与 body 字节数一致，否则解析器会按长度跳过或读串（下面样本已对齐）
	// HT Operation body 布局：body[0] = Primary Channel，body[1] 低两位 = Secondary Channel Offset
	const htCap = "2d06000000000000" // ID 45, len 6, body 6 字节
	cases := []struct {
		name string
		ie   string
		want int
	}{
		// 旧实现把 body[0]（主信道号）当带宽标志：主信道 11(0x0b) & 0x03 = 3 → 会误判为 40MHz。
		// 这两个用例就是钉住该回归的（与 Cellular-Z 在实地的取值一致）。
		{"11n 20MHz（主信道 11，旧实现会误判 40）", htCap + "3d060b0000000000", 20},
		{"11n 20MHz（主信道 1，旧实现会误判 40）", htCap + "3d06010000000000", 20},
		{"11n 20MHz（主信道 165=0xa5）", htCap + "3d06a50000000000", 20},
		{"11n 40MHz SCB（主信道 11）", htCap + "3d060b0300000000", 40},
		{"11n 40MHz SCA（主信道 1）", htCap + "3d06010100000000", 40},
		{"11ac 80MHz（seg1=0）", htCap + "3d060b0000000000" + "c005012a00ffff", 80},
		// width=1 但 Center Frequency Segment 1 非 0 → 实际是 160MHz（实测 H3C Wi-Fi5 这类 AP 都是这种写法，
		// Cellular-Z 亦报 160MHz；只读 width 字段会误判成 80MHz）
		{"11ac 160MHz（width=1 且 seg1≠0）", htCap + "3d060b0000000000" + "c005012a32faff", 160},
		{"11ac 160MHz（width=2）", htCap + "3d060b0000000000" + "c005023232faff", 160},
		{"11ac 80+80MHz（width=3）", htCap + "3d060b0000000000" + "c005032a32faff", 160},
		{"VHT width=0 且 HT 为 40MHz", htCap + "3d060b0300000000" + "c00500323fffff", 40},
		{"VHT width=0 且 HT 为 20MHz", htCap + "3d060b0000000000" + "c00500323fffff", 20},
		{"老式 11b/g（无 HT）", "01040b16240c", 20},
		{"空字符串", "", 0},
		{"非法十六进制", "zzzz", 0},
		{"数据过短无法判断", "2d", 0},
		{"长度越界", "2dffff", 20},
	}
	for _, c := range cases {
		if got := parseBSSBandwidth(c.ie); got != c.want {
			t.Errorf("%s: parseBSSBandwidth() = %d, want %d", c.name, got, c.want)
		}
	}
}

// 真实样本：设备实测抓取的 H3C_81A928_5G（5180MHz / ch36）的完整 IE 字节流。
// 它的 VHT Operation 是 `c0 05 01 2a 32 fa ff` —— width=1 且 seg1=0x32（非 0），
// 即 160MHz 的写法；Cellular-Z 对同一 BSSID（70:2a:d7:81:a9:2a）同样报 160MHZ。
// 证明真实驱动的 IE（含 country / RM / 厂商自定义等大量干扰元素）也能被正确解析。
func TestParseBSSBandwidthRealSample(t *testing.T) {
	const ie = "000d4833435f3831413932385f354701088c129824b048606c030124070c434e0424041734041795051e2001" +
		"0023021e004605030200000030140100000fac040100000fac040100000fac020c00dd180050f2020101800003" +
		"a4000027a4000042435e0062322f000b050000c3127a2d1aef0103ffff00000000000000000000010000000000" +
		"00000000003d16240511000000000000000000000000000000000000007f080000080000000040bf0cf6798903fa" +
		"ff9e07faff9e27c005012a32faffff1a230108080e00580c2f4ec96fc927de018f00fafffafffafffaffff0724" +
		"e43f0007fcffff03270500ff0e260000ffff20ffff40ffff60ffffff02252add08ac853d8201000000dd04ac853d" +
		"bddd08ac853d2013000000dd160050f20101000050f20401000050f20401000050f202dd0800e0fc81f10e0400dd" +
		"7a0050f204104a0001101044000102103b00010310470010876543219abcdef01234ee3d1a757c9f102100096875" +
		"6177656974656310230003574150102400033132331042000531323334351054000800060050f20400011011000a" +
		"686973696c69636f6e20100800020004103c0001021049000600372a000120"
	if got := parseBSSBandwidth(ie); got != 160 {
		t.Fatalf("真实样本（H3C_81A928_5G，VHT seg1 非 0 = 160MHz）解析结果 = %d, want 160", got)
	}
}

// 扫描结果解析：带宽字段默认为 0，由 fillBandwidths 补齐。
func TestScannedNetworkHasBandwidthField(t *testing.T) {
	line := "bssid / frequency / signal level / flags / ssid\n" +
		"70:2a:d7:81:a9:2d\t5200\t-70\t[WPA2-PSK-CCMP][ESS]\tZTE-511-5G\n"
	nets := parseScanResults(line)
	if len(nets) != 1 {
		t.Fatalf("解析到 %d 个网络, want 1", len(nets))
	}
	if nets[0].Channel != 40 || nets[0].Freq != 5200 {
		t.Fatalf("信道/频率解析错误: ch=%d freq=%d", nets[0].Channel, nets[0].Freq)
	}
	if nets[0].Bandwidth != 0 {
		t.Fatalf("带宽应由 fillBandwidths 补齐，期望初始为 0，实际 %d", nets[0].Bandwidth)
	}
}
