import subprocess, os, time

os.environ['ANDROID_ADB_SERVER_PORT'] = '5038'
adb_bin = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'

def sh(cmd):
    p = subprocess.run([adb_bin, 'shell', cmd], capture_output=True)
    return p.stdout.decode('utf-8', errors='replace').strip()

print('=== Test setting 5G channel 40 via Connman ===')
sh('dbus-send --system --print-reply --dest=net.connman /net/connman/technology/wifi net.connman.Technology.SetProperty string:Tethering5gChannel variant:int32:40')
# Also check if TetheringChannel needs to be set
sh('dbus-send --system --print-reply --dest=net.connman /net/connman/technology/wifi net.connman.Technology.SetProperty string:Tethering variant:boolean:false')
time.sleep(1.5)
sh('dbus-send --system --print-reply --dest=net.connman /net/connman/technology/wifi net.connman.Technology.SetProperty string:Tethering variant:boolean:true')
time.sleep(4)

res = sh('wpa_cli status')
print('Result after setting 40:')
for l in res.splitlines():
    if any(k in l for k in ['freq', 'mode', 'wpa_state']):
        print(' ', l)

print('=== Test setting 5G channel 149 via Connman ===')
sh('dbus-send --system --print-reply --dest=net.connman /net/connman/technology/wifi net.connman.Technology.SetProperty string:Tethering5gChannel variant:int32:149')
sh('dbus-send --system --print-reply --dest=net.connman /net/connman/technology/wifi net.connman.Technology.SetProperty string:Tethering variant:boolean:false')
time.sleep(1.5)
sh('dbus-send --system --print-reply --dest=net.connman /net/connman/technology/wifi net.connman.Technology.SetProperty string:Tethering variant:boolean:true')
time.sleep(4)

res = sh('wpa_cli status')
print('Result after setting 149:')
for l in res.splitlines():
    if any(k in l for k in ['freq', 'mode', 'wpa_state']):
        print(' ', l)
