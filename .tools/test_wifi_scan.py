import subprocess, os, time

os.environ['ANDROID_ADB_SERVER_PORT'] = '5038'
adb_bin = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'

def freq_to_chan(freq):
    if 2412 <= freq <= 2484:
        if freq == 2484: return 14, '2.4G'
        return (freq - 2412) // 5 + 1, '2.4G'
    elif 5180 <= freq <= 5825:
        return (freq - 5000) // 5, '5G'
    return 0, 'unknown'

print('Starting scan on device...')
subprocess.run([adb_bin, 'shell', 'wpa_cli -i wlan0 scan'], capture_output=True)
time.sleep(3)
res = subprocess.run([adb_bin, 'shell', 'wpa_cli -i wlan0 scan_results'], capture_output=True, text=True)
lines = res.stdout.strip().splitlines()
print('Total scan lines:', len(lines))

networks = []
for line in lines[1:]:
    parts = line.split('\t')
    if len(parts) >= 4:
        bssid = parts[0]
        try:
            freq = int(parts[1])
            rssi = int(parts[2])
        except ValueError:
            continue
        flags = parts[3]
        ssid = parts[4] if len(parts) > 4 else ''
        ch, band = freq_to_chan(freq)
        networks.append({'bssid': bssid, 'ssid': ssid, 'freq': freq, 'channel': ch, 'band': band, 'rssi': rssi})

print(f'Parsed {len(networks)} networks:')
for n in sorted(networks, key=lambda x: x['rssi'], reverse=True)[:15]:
    ssid_name = n['ssid'] if n['ssid'] else '(隐藏SSID)'
    print(f"  [{n['band']}] 信道 {n['channel']:3d} ({n['freq']} MHz) {n['rssi']} dBm: {ssid_name}")
