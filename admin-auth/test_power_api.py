"""验证 Wi-Fi 开关：API 状态回报 + 指示灯 + 驱动真值。"""
import os, subprocess, json, time, base64, urllib.request

os.environ['ANDROID_ADB_SERVER_PORT'] = '5038'
ADB = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'

def adb(*a):
    return subprocess.run([ADB, *a], capture_output=True, text=True).stdout.strip()

adb('forward', 'tcp:18880', 'tcp:18080')
creds = json.loads(adb('shell', 'cat /home/root/admin-auth/credentials.json'))
AUTH = 'Basic ' + base64.b64encode(f"{creds['username']}:{creds['password']}".encode()).decode()

def api(path, method='GET', payload=None):
    data = json.dumps(payload).encode() if payload is not None else None
    req = urllib.request.Request('http://127.0.0.1:18880' + path, data=data,
                                headers={'Authorization': AUTH, 'Content-Type': 'application/json'}, method=method)
    return json.loads(urllib.request.urlopen(req, timeout=60).read().decode())

def light():
    return 'LED=%s' % adb('shell', 'cat /sys/class/leds/wifi_green/brightness | tr -d "\\r"')

print('[初始]   power =', json.dumps(api('/air-api/wifi/power'), ensure_ascii=False), '|', light())

print('[关闭]   ->', json.dumps(api('/air-api/wifi/power', 'POST', {'enable': False}), ensure_ascii=False))
time.sleep(5)
print('  5s后   power =', json.dumps(api('/air-api/wifi/power'), ensure_ascii=False), '|', light())
print('  射频:  ', adb('shell', 'connmanctl technologies | sed -n "/net.connman.technology.wifi/,/^$/p" | grep -E "Powered|Tethering =" | tr "\\n" " "'))

print('[开启]   ->', json.dumps(api('/air-api/wifi/power', 'POST', {'enable': True}), ensure_ascii=False))
time.sleep(12)
print('  12s后  power =', json.dumps(api('/air-api/wifi/power'), ensure_ascii=False), '|', light())
print('  wpa:   ', adb('shell', 'wpa_cli -i wlan0 status | grep -E "ssid|wpa_state" | tr "\\n" " "'))
print('  softap.ini:', adb('shell', 'cat /data/vendor/wifi/hostapd/softap.ini | tr -d "\\r"'))
print('  驱动真值:', adb('shell', 'dmesg | grep "reset channel" | tail -n 1'))
