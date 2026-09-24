"""只读核对：API 返回的信道/状态 与 设备驱动真值是否一致（用 curl 带凭据，避免手工拼认证头）。"""
import os, subprocess, json

os.environ['ANDROID_ADB_SERVER_PORT'] = '5038'
ADB = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'

def adb(*a):
    return subprocess.run([ADB, *a], capture_output=True, text=True).stdout.strip()

adb('forward', 'tcp:18880', 'tcp:18080')
c = json.loads(adb('shell', 'cat /home/root/admin-auth/credentials.json'))
cred = '%s:%s' % (c['username'], c['password'])

def api(path):
    out = subprocess.run(['curl', '-s', '--max-time', '45', '-u', cred,
                          'http://127.0.0.1:18880' + path], capture_output=True, text=True).stdout
    return json.loads(out)

hook = adb('shell', 'dmesg | grep "reset channel" | tail -n 1 | sed "s/.*reset channel/reset channel/"')
ini = adb('shell', 'cat /data/vendor/wifi/hostapd/softap.ini | tr -d "\\r"')
wpa = adb('shell', 'wpa_cli -i wlan0 status 2>/dev/null | grep -E "ssid=|freq|wpa_state" | tr "\\n" " "')
led = adb('shell', 'cat /sys/class/leds/wifi_green/brightness | tr -d "\\r"')
uptime = adb('shell', 'cut -d " " -f1 /proc/uptime')

print('设备开机时长               :', uptime, '秒')
print('接口 /air-api/wifi/channel :', json.dumps(api('/air-api/wifi/channel'), ensure_ascii=False))
print('接口 /air-api/wifi/power   :', json.dumps(api('/air-api/wifi/power'), ensure_ascii=False))
print('驱动钩子（真实射频信道）   :', hook or '(本次开机暂无钩子记录)')
print('softap.ini（驱动输入）     :', ini)
print('wpa_cli（滞后意图值，对照）:', wpa)
print('指示灯 wifi_green          :', led)
