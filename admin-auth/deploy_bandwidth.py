"""部署 Wi-Fi 信道 + 频谱带宽修复（gateway + 前端 3 个资源），并验证 API 返回带宽。"""
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

print('[2] 推送前端资源（js / css / 页面）...')
adb('push', 'ui/air-wifi-radar.js', '/webui/air-wifi-radar.js')
adb('push', 'ui/air-wifi-radar.css', '/webui/air-wifi-radar.css')
adb('push', 'ui/inner-pages/z50_air_wifi.html', '/webui/html/z50_air_wifi.html')

print('[3] 重启 gateway ...')
adb('shell', 'killall -9 admin-gateway 2>/dev/null; sleep 6; ps | grep admin-gateway | grep -v grep | wc -l')
time.sleep(3)

print('[4] 拉取雷达数据验证带宽字段 ...')
adb('forward', '--remove', 'tcp:18880', check=False)
adb('forward', 'tcp:18880', 'tcp:18080')
c = json.loads(adb('shell', 'cat /home/root/admin-auth/credentials.json'))
cred = '%s:%s' % (c['username'], c['password'])

raw = subprocess.run(['curl', '-s', '--max-time', '90', '-u', cred,
                      'http://127.0.0.1:18880/air-api/wifi/radar'], capture_output=True, text=True).stdout
radar = json.loads(raw)
nets = radar.get('networks') or []
print('  本机信道: %s (%s MHz, %s)' % (radar.get('current_channel'), radar.get('current_freq'), radar.get('current_mode')))
print('  周围热点: %d 个，带宽分布:' % len(nets))
from collections import Counter
bw_count = Counter(n.get('bandwidth', 0) for n in nets)
for bw, n in sorted(bw_count.items()):
    print('     %3s MHz : %d 个' % (bw, n))
print('  前 8 个热点（信道 / 带宽 / 信号 / 名称）:')
for n in nets[:8]:
    print('     CH %-4s %-5sMHz %-5s dBm  %s' % (n.get('channel'), n.get('bandwidth'), n.get('rssi'), (n.get('ssid') or '(隐藏)')[:24]))
print('  前端版本:', adb('shell', 'grep -o "air-wifi-radar[^\"]*" /webui/html/z50_air_wifi.html | sort -u | tr "\\n" " "'))
