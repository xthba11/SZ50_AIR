import subprocess, os, time

os.environ['ANDROID_ADB_SERVER_PORT'] = '5038'
adb_bin = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'

def sh(cmd):
    p = subprocess.run([adb_bin, 'shell', cmd], capture_output=True)
    return p.stdout.decode('utf-8', errors='replace').strip()

print('Initial status:', sh('wpa_cli status | grep -E "(wpa_state|freq|ssid)"'))
print('Triggering scan:', sh('wpa_cli scan'))
for i in range(10):
    time.sleep(1)
    status = sh('wpa_cli status | grep -E "(wpa_state|freq|ssid)"')
    print(f't={i+1}s: {status}')
    if 'wpa_state=COMPLETED' in status:
        print('AP restored at t=', i+1)
        break
