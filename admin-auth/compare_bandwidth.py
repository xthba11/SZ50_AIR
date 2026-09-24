"""把后台雷达数据与手机 Cellular-Z 导出的 CSV 逐条对照，统计带宽一致率。

用法：python admin-auth/compare_bandwidth.py "<Cellular-Z 导出的 CSV 路径>"
"""
import os, sys, csv, json, subprocess, io

os.environ['ANDROID_ADB_SERVER_PORT'] = '5038'
ADB = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'
CSV_PATH = sys.argv[1] if len(sys.argv) > 1 else r'C:\Users\19835\Desktop\Cellular-Z 20260922 14_29_20.609 WiFi.CSV'

def adb(*a):
    return subprocess.run([ADB, *a], capture_output=True, text=True).stdout

# ---- 手机侧 ----
phone = {}
with io.open(CSV_PATH, 'r', encoding='utf-8-sig', newline='') as f:
    for row in csv.DictReader(f):
        bssid = (row.get('BSSID') or '').strip().lower()
        width = (row.get('WIDTH') or '').strip().upper().replace('MHZ', '')
        if not bssid or not width.isdigit():
            continue
        phone[bssid] = {
            'bw': int(width),
            'rssi': (row.get('RSSI') or '').strip(),
            'ssid': (row.get('SSID') or '').strip(),
            'freq': (row.get('FREQUENCY') or '').strip(),
        }

# ---- 后台侧 ----
subprocess.run([ADB, 'forward', 'tcp:18882', 'tcp:18080'], capture_output=True)
creds = json.loads(adb('shell', 'cat /home/root/admin-auth/credentials.json'))
cred = '%s:%s' % (creds['username'], creds['password'])
raw = subprocess.run(['curl', '-s', '--max-time', '90', '-u', cred,
                      'http://127.0.0.1:18882/air-api/wifi/radar'], capture_output=True, text=True).stdout
radar = json.loads(raw)
backend = {}
for n in radar.get('networks') or []:
    backend[(n.get('bssid') or '').lower()] = {
        'bw': n.get('bandwidth'), 'ch': n.get('channel'),
        'rssi': n.get('rssi'), 'ssid': (n.get('ssid') or '').strip(),
    }

print('手机 CSV: %d 个 BSSID  |  后台扫描: %d 个 BSSID' % (len(phone), len(backend)))
print('本机热点（扫描不到自己，后台为合成条目）: 手机 =', phone.get('e8:6d:98:73:5a:ce', {}).get('bw'), 'MHz')
print()
print('%-18s %-22s %-8s %-8s %s' % ('BSSID', 'SSID', '手机', '后台', '结果'))

both = same = diff = 0
mismatches = []
for bssid, p in sorted(phone.items(), key=lambda kv: -int(kv[1]['rssi'] or -99)):
    b = backend.get(bssid)
    if not b:
        print('%-18s %-22s %-8s %-8s %s' % (bssid, p['ssid'][:22], '%dMHz' % p['bw'], '未扫到', '（后台没扫到这个热点）'))
        continue
    both += 1
    ok = (b['bw'] == p['bw'])
    if ok:
        same += 1
    else:
        diff += 1
        mismatches.append((bssid, p, b))
    print('%-18s %-22s %-8s %-8s %s' % (bssid, p['ssid'][:22], '%dMHz' % p['bw'], '%dMHz' % b['bw'], '一致' if ok else '❌ 不一致'))

print()
print('可比对 %d 个：一致 %d，不一致 %d（一致率 %.0f%%）' % (both, same, diff, (same * 100.0 / both) if both else 0))

if mismatches:
    print('\n=== 不一致明细（含驱动 IE 佐证） ===')
    for bssid, p, b in mismatches[:6]:
        info = adb('shell', 'wpa_cli -i wlan0 bss %s 2>/dev/null' % bssid)
        ie = ''
        for line in info.split('\n'):
            if line.startswith('ie='):
                ie = line[3:].strip()
        print('\n%s (%s) 手机=%dMHz 后台=%dMHz ch=%s freq=%s' % (bssid, p['ssid'], p['bw'], b['bw'], b['ch'], p['freq']))
        # 打印 HT/VHT 相关 IE 片段帮助定位
        data = bytes.fromhex(ie) if ie else b''
        i = 0
        while i + 2 <= len(data):
            eid, elen = data[i], data[i + 1]
            if i + 2 + elen > len(data):
                break
            body = data[i + 2:i + 2 + elen]
            if eid in (45, 61, 191, 192, 255):
                name = {45: 'HT Cap', 61: 'HT Op', 191: 'VHT Cap', 192: 'VHT Op', 255: 'Ext'}[eid]
                print('   IE %-8s id=%-3d len=%-3d body=%s' % (name, eid, elen, body[:8].hex()))
            i += 2 + elen
