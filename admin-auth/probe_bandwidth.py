"""验证：能否从 wpa_cli bss 的 IE 字节流解析出每个 AP 的真实带宽（20/40/80/160MHz）。"""
import os, subprocess, re, time

os.environ['ANDROID_ADB_SERVER_PORT'] = '5038'
ADB = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'

def adb(cmd):
    return subprocess.run([ADB, 'shell', cmd], capture_output=True, text=True).stdout

def parse_ie(hexstr):
    """遍历 Information Elements，返回 (bandwidth, hasHT, htSecondary, vhtWidth, hasVHT)"""
    try:
        data = bytes.fromhex(hexstr.strip())
    except ValueError:
        return None
    i = 0
    has_ht = False
    ht_secondary = 0
    vht_width = None
    while i + 2 <= len(data):
        eid = data[i]
        elen = data[i + 1]
        if i + 2 + elen > len(data):
            break
        body = data[i + 2: i + 2 + elen]
        if eid == 45 and elen >= 2:          # HT Capabilities
            has_ht = True
        elif eid == 61 and elen >= 1:        # HT Operation
            ht_secondary = body[0] & 0x03
        elif eid == 192 and elen >= 1:       # VHT Operation
            vht_width = body[0]
        i += 2 + elen
    # 判定带宽：VHT Operation 的 channel width 优先，其次 HT 的 secondary channel offset
    if vht_width == 1:
        bw = 80
    elif vht_width in (2, 3):
        bw = 160
    elif vht_width == 0:
        bw = 40 if ht_secondary else 20
    else:
        bw = 40 if ht_secondary else (20 if has_ht else 20)
    return bw, has_ht, ht_secondary, vht_width

adb('wpa_cli -i wlan0 scan >/dev/null 2>&1')
time.sleep(6)
scan = adb('wpa_cli -i wlan0 scan_results 2>/dev/null')
rows = []
for line in scan.split('\n')[1:21]:
    parts = line.split('\t')
    if len(parts) < 4:
        continue
    bssid, freq = parts[0].strip(), parts[1].strip()
    rssi, ssid = parts[2].strip(), (parts[4].strip() if len(parts) > 4 else '')
    info = adb('wpa_cli -i wlan0 bss %s 2>/dev/null' % bssid)
    ie = ''
    tp = ''
    for l in info.split('\n'):
        if l.startswith('ie='):
            ie = l[3:].strip()
        elif l.startswith('est_throughput='):
            tp = l.split('=')[1].strip()
    r = parse_ie(ie)
    ch = (int(freq) - 5000) // 5 if int(freq) > 5000 else (int(freq) - 2412) // 5 + 1
    rows.append((bssid, freq, ch, rssi, ssid[:22], r, tp))

print('%-18s %6s %4s %5s %-22s %-8s %-12s %s' % ('BSSID', 'freq', 'ch', 'rssi', 'SSID', '带宽', 'HTsec/VHTw', 'est_tp'))
for bssid, freq, ch, rssi, ssid, r, tp in rows:
    if r:
        bw, has_ht, sec, vw = r
        print('%-18s %6s %4d %5s %-22s %-8s %-12s %s' % (
            bssid, freq, ch, rssi, ssid, '%dMHz' % bw,
            'HT=%s sec=%d vht=%s' % (int(has_ht), sec, vw), tp))
    else:
        print('%-18s %6s %4d %5s %-22s %s' % (bssid, freq, ch, rssi, ssid, '(IE 解析失败)'))
