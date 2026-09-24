"""列出 5GHz（尤其 149-165）的设备扫描结果，核对"同 SSID 同信道不同 MAC"是否都在。"""
import os, json, subprocess
from collections import defaultdict

os.environ['ANDROID_ADB_SERVER_PORT'] = '5038'
ADB = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'

def adb(*a):
    return subprocess.run([ADB, *a], capture_output=True, text=True).stdout

subprocess.run([ADB, 'forward', 'tcp:18883', 'tcp:18080'], capture_output=True)
creds = json.loads(adb('shell', 'cat /home/root/admin-auth/credentials.json'))
cred = '%s:%s' % (creds['username'], creds['password'])
raw = subprocess.run(['curl', '-s', '--max-time', '90', '-u', cred,
                      'http://127.0.0.1:18883/air-api/wifi/radar'], capture_output=True, text=True).stdout
radar = json.loads(raw)
nets = radar.get('networks') or []

print('设备共扫到 %d 个 BSSID；本机信道 %s' % (len(nets), radar.get('current_channel')))
print()
by_ch = defaultdict(list)
for n in nets:
    by_ch[n.get('channel')].append(n)

print('=== 5GHz 各信道分布 ===')
for ch in sorted(c for c in by_ch if c and c >= 36):
    print('  CH %-4s : %d 个' % (ch, len(by_ch[ch])))

print()
print('=== 149-165 明细（按信道） ===')
for ch in [149, 153, 157, 161, 165]:
    rows = by_ch.get(ch) or []
    if not rows:
        print('  CH %s : （设备未扫到）' % ch)
        continue
    print('  CH %s :' % ch)
    for n in sorted(rows, key=lambda x: -x.get('rssi', -100)):
        print('     %-18s %-24s %5s dBm  %sMHz' % (
            n.get('bssid'), (n.get('ssid') or '(隐藏)')[:24], n.get('rssi'), n.get('bandwidth')))

print()
print('=== 同 SSID + 同信道 的多 BSSID 组 ===')
groups = defaultdict(list)
for n in nets:
    if n.get('ssid'):
        groups[(n['ssid'], n.get('channel'))].append(n.get('bssid'))
for (ssid, ch), bssids in sorted(groups.items()):
    if len(bssids) > 1:
        print('  %-22s CH %-4s → %d 个 BSSID: %s' % (ssid[:22], ch, len(bssids), ', '.join(b[:17] for b in bssids)))
