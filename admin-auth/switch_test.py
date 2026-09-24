"""验证加固后的信道切换：切换 → 校验 AP 存活 + 接口回报 + 驱动输入文件；最后恢复信道。"""
import os, subprocess, json, time

os.environ['ANDROID_ADB_SERVER_PORT'] = '5038'
ADB = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'

def adb(*a):
    return subprocess.run([ADB, *a], capture_output=True, text=True).stdout.strip()

adb('forward', 'tcp:18880', 'tcp:18080')
c = json.loads(adb('shell', 'cat /home/root/admin-auth/credentials.json'))
cred = '%s:%s' % (c['username'], c['password'])

def api(path, payload=None):
    cmd = ['curl', '-s', '--max-time', '60', '-u', cred, 'http://127.0.0.1:18880' + path]
    if payload is not None:
        cmd += ['-X', 'POST', '-H', 'Content-Type: application/json', '-d', json.dumps(payload)]
    return json.loads(subprocess.run(cmd, capture_output=True, text=True).stdout)

def snap(label):
    hook = adb('shell', 'dmesg | grep "reset channel" | tail -n 1 | sed "s/.*reset channel/reset channel/"')
    ini = adb('shell', 'cat /data/vendor/wifi/hostapd/softap.ini | tr -d "\\r"')
    state = adb('shell', 'wpa_cli -i wlan0 status 2>/dev/null | grep -o "wpa_state=[A-Z]*"')
    ch = api('/air-api/wifi/channel')
    print('  [%s] API信道=%s 状态=%s %s | 驱动输入=%s' % (
        label, ch.get('current_channel'), state, ('钩子: ' + hook) if hook else '钩子: (无)', ini))

print('切换前:'); snap('before')

for target in (44, 56):
    print('切到 %d:' % target)
    print('   POST ->', json.dumps(api('/air-api/wifi/channel', {'channel': target, 'mode': '5G'}), ensure_ascii=False))
    time.sleep(15)
    snap('after-%d' % target)

print('最终状态:'); snap('final')
