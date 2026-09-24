import subprocess, os, time

os.environ['ANDROID_ADB_SERVER_PORT'] = '5038'
adb_bin = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'

def sh(cmd):
    p = subprocess.run([adb_bin, 'shell', cmd], capture_output=True)
    return p.stdout.decode('utf-8', errors='replace').strip()

print('Current:', sh('wpa_cli status | grep -E "(freq|wpa_state)"'))

print('--- Switch to Channel 44 (5220 MHz) safely ---')
sh('wpa_cli disable_network 0')
sh('wpa_cli set_network 0 frequency 5220')
sh('wpa_cli enable_network 0')
sh('wpa_cli select_network 0')
time.sleep(2)
print('After Ch 44:', sh('wpa_cli status | grep -E "(freq|wpa_state|mode)"'))

print('--- Switch back to Channel 36 (5180 MHz) safely ---')
sh('wpa_cli disable_network 0')
sh('wpa_cli set_network 0 frequency 5180')
sh('wpa_cli enable_network 0')
sh('wpa_cli select_network 0')
time.sleep(2)
print('After Ch 36:', sh('wpa_cli status | grep -E "(freq|wpa_state|mode)"'))
