"""端到端验收：切信道 / 关开 Wi-Fi（指示灯）全流程，用真实驱动日志交叉验证。"""
import os, subprocess, json, time, base64, urllib.request

os.environ['ANDROID_ADB_SERVER_PORT'] = '5038'
ADB = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'

def adb(*args):
    p = subprocess.run([ADB, *args], capture_output=True, text=True)
    return p.stdout.strip()

adb('forward', 'tcp:18880', 'tcp:18080')
creds = json.loads(adb('shell', 'cat /home/root/admin-auth/credentials.json'))
AUTH = 'Basic ' + base64.b64encode(f"{creds['username']}:{creds['password']}".encode()).decode()

def api(path, method='GET', payload=None):
    data = json.dumps(payload).encode() if payload is not None else None
    req = urllib.request.Request('http://127.0.0.1:18880' + path, data=data, headers={
        'Authorization': AUTH, 'Content-Type': 'application/json'}, method=method)
    return json.loads(urllib.request.urlopen(req, timeout=40).read().decode())

def truth():
    """设备侧真值：驱动 hook 日志 Y + softap.ini + LED + wpa_supplicant 意图值"""
    hook = adb('shell', 'dmesg | grep "reset channel" | tail -n 1')
    hook_y = hook.split('->')[-1].strip().split()[0] if '->' in hook else '?'
    return {
        'hook_y(真实)': hook_y,
        'softap.ini': adb('shell', 'cat /data/vendor/wifi/hostapd/softap.ini | tr -d "\\r\\n"'),
        'LED': adb('shell', 'cat /sys/class/leds/wifi_green/brightness | tr -d "\\r\\n"'),
        'wpa_cli(意图)': adb('shell', 'wpa_cli -i wlan0 status 2>/dev/null | grep -E "freq|wpa_state" | tr "\\n" " " | tr -d "\\r"'),
        '开机时长s': adb('shell', 'cut -d" " -f1 /proc/uptime'),
    }

print('=== 初始状态 ===')
print(' ', json.dumps(truth(), ensure_ascii=False))
print('  API:', json.dumps(api('/air-api/wifi/channel'), ensure_ascii=False))

print('\n=== 测试1：切信道到 44（API）===')
print(' ', api('/air-api/wifi/channel', 'POST', {'channel': 44, 'mode': '5G'}))
time.sleep(8)
print(' ', json.dumps(truth(), ensure_ascii=False))
print('  API:', json.dumps(api('/air-api/wifi/channel'), ensure_ascii=False))

print('\n=== 测试2：关闭 Wi-Fi（API）===')
print(' ', api('/air-api/wifi/power', 'POST', {'enable': False}))
time.sleep(5)
t = truth()
print(' ', json.dumps(t, ensure_ascii=False))
print('  connman:', adb('shell', 'connmanctl technologies | grep -A3 "technology/wifi" | grep -E "Powered|Tethering =" | tr "\\n" " "'))
print('  API:', json.dumps(api('/air-api/wifi/power'), ensure_ascii=False))

print('\n=== 测试3：开启 Wi-Fi（API）===')
print(' ', api('/air-api/wifi/power', 'POST', {'enable': True}))
time.sleep(10)
print(' ', json.dumps(truth(), ensure_ascii=False))
print('  API:', json.dumps(api('/air-api/wifi/power'), ensure_ascii=False))

print('\n=== 测试4：切回 157（API）===')
print(' ', api('/air-api/wifi/channel', 'POST', {'channel': 157, 'mode': '5G'}))
time.sleep(8)
print(' ', json.dumps(truth(), ensure_ascii=False))
print('  API:', json.dumps(api('/air-api/wifi/channel'), ensure_ascii=False))
