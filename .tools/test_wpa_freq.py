import subprocess, os, time

os.environ['ANDROID_ADB_SERVER_PORT'] = '5038'
adb_bin = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'

def sh(cmd):
    p = subprocess.run([adb_bin, 'shell', cmd], capture_output=True)
    return p.stdout.decode('utf-8', errors='replace').strip()

print('=== Current wpa_cli status ===')
print(sh('wpa_cli status'))

print('=== Test set_network 0 frequency 5220 (Channel 44) ===')
print('disable:', sh('wpa_cli disable_network 0'))
time.sleep(1)
print('set freq:', sh('wpa_cli set_network 0 frequency 5220'))
print('enable:', sh('wpa_cli enable_network 0'))
time.sleep(3)

print('=== New wpa_cli status ===')
print(sh('wpa_cli status'))
