"""深度诊断：抓取 5GHz 各 AP 的完整 IE，逐元素列出 HT/VHT/HE 相关字段，
用于定位"手机报 160MHz 而设备报 20MHz"这类个案。"""
import os, subprocess, time

os.environ['ANDROID_ADB_SERVER_PORT'] = '5038'
ADB = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'

def adb(*a):
    return subprocess.run([ADB, 'shell', *a], capture_output=True, text=True).stdout

def elements(hexie):
    try:
        data = bytes.fromhex(hexie.strip())
    except ValueError:
        return []
    out, i = [], 0
    while i + 2 <= len(data):
        eid, elen = data[i], data[i+1]
        if i + 2 + elen > len(data):
            break
        out.append((eid, data[i+2:i+2+elen]))
        i += 2 + elen
    return out

def verdict(elems):
    ht = vht = None
    for eid, body in elems:
        if eid == 45 and len(body) >= 2:
            ht = 'has'
        if eid == 61 and len(body) >= 2:
            ht = 'op sec=%d' % (body[1] & 0x03)
        if eid == 192 and len(body) >= 3:
            vht = 'width=%d seg0=0x%02x seg1=0x%02x' % (body[0], body[1], body[2])
    return ht, vht

print('第 1 轮扫描 ...')
adb('wpa_cli', '-i', 'wlan0', 'scan')
time.sleep(3.5)
print('第 2 轮（定向 5G）...')
adb('wpa_cli', '-i', 'wlan0', 'scan', 'freq=5180,5200,5220,5240,5260,5280,5300,5320,5745,5765,5785,5805,5825')
time.sleep(3.5)

res = adb('wpa_cli', '-i', 'wlan0', 'scan_results')
targets = []
for line in res.split('\n')[1:]:
    p = line.split('\t')
    if len(p) >= 5 and p[1].strip().isdigit() and int(p[1]) > 5000:
        targets.append((p[0].strip(), int(p[1]), p[2].strip(), p[4].strip()))

print('5GHz 目标 %d 个\n' % len(targets))
print('%-18s %6s %5s %-22s %-10s %s' % ('BSSID', 'freq', 'rssi', 'SSID', 'dev推断', 'VHT/HT'))
for bssid, freq, rssi, ssid in targets:
    info = adb('wpa_cli', '-i', 'wlan0', 'bss', bssid)
    ie = ''
    tp = ''
    for l in info.split('\n'):
        if l.startswith('ie='):
            ie = l[3:].strip()
        elif l.startswith('est_throughput='):
            tp = l.split('=')[1].strip()
    elems = elements(ie)
    ht, vht = verdict(elems)
    # 用与 Go 端相同的规则推断
    if vht and 'width=1' in vht and 'seg1=0x00' not in vht:
        dev = '160MHz'
    elif vht and 'width=2' in vht or (vht and 'width=3' in vht):
        dev = '160MHz'
    elif vht and 'width=1' in vht:
        dev = '80MHz'
    elif ht and 'sec=0' not in ht and ht != 'has':
        dev = '40MHz'
    else:
        dev = '20MHz'
    extra = '' if ie else '  ⚠️ 无 ie（查询失败）'
    print('%-18s %6d %5s %-22s %-10s %s  tp=%s%s' % (
        bssid, freq, rssi, ssid[:22], dev, (vht or ht or '-'), tp, extra))
