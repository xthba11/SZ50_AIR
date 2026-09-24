"""部署 Wi-Fi 信道同步修复（gateway + 前端），并验证 API 返回真实信道。"""
import os, subprocess, json, time, base64, urllib.request

os.environ['ANDROID_ADB_SERVER_PORT'] = '5038'
ADB = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'

def adb(*args, check=True):
    p = subprocess.run([ADB, *args], capture_output=True, text=True)
    if check and p.returncode != 0:
        raise RuntimeError(f"ADB failed: {args} :: {p.stderr.strip()}")
    return p.stdout

print('[1] 推送 admin-gateway ...')
adb('push', 'admin-auth/admin-gateway', '/home/root/admin-auth/admin-gateway.new')
adb('shell', 'chmod +x /home/root/admin-auth/admin-gateway.new && mv -f /home/root/admin-auth/admin-gateway.new /home/root/admin-auth/admin-gateway')

print('[2] 推送前端资源 ...')
adb('push', 'ui/air-wifi-radar.js', '/webui/air-wifi-radar.js')
adb('push', 'ui/inner-pages/z50_air_wifi.html', '/webui/html/z50_air_wifi.html')

print('[3] 重启 gateway（supervise.sh 会自动拉起）...')
adb('shell', 'killall -9 admin-gateway 2>/dev/null; sleep 6; ps | grep admin-gateway | grep -v grep')
time.sleep(3)

print('[4] 端口转发并验证 API ...')
adb('forward', '--remove', 'tcp:18880', check=False)
adb('forward', 'tcp:18880', 'tcp:18080')

c = json.loads(adb('shell', 'cat /home/root/admin-auth/credentials.json'))
auth = 'Basic ' + base64.b64encode(f"{c['username']}:{c['password']}".encode()).decode()

def api(path):
    req = urllib.request.Request('http://127.0.0.1:18880' + path, headers={'Authorization': auth})
    return json.loads(urllib.request.urlopen(req, timeout=30).read().decode())

print('  /air-api/wifi/channel ->', json.dumps(api('/air-api/wifi/channel'), ensure_ascii=False))
print('  /air-api/wifi/power   ->', json.dumps(api('/air-api/wifi/power'), ensure_ascii=False))
radar = api('/air-api/wifi/radar')
print('  /air-api/wifi/radar   -> current_channel=%s current_freq=%s current_mode=%s ssid=%s networks=%d' % (
    radar.get('current_channel'), radar.get('current_freq'), radar.get('current_mode'),
    radar.get('current_ssid'), len(radar.get('networks') or [])))
print('\n设备端真实信道对照：', adb('shell', 'dmesg | grep "reset channel" | tail -n 1').strip(),
      '| softap.ini:', adb('shell', 'cat /data/vendor/wifi/hostapd/softap.ini').strip())
