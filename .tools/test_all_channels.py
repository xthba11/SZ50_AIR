import subprocess, os, time

os.environ['ANDROID_ADB_SERVER_PORT'] = '5038'
adb_bin = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'

def sh(cmd):
    p = subprocess.run([adb_bin, 'shell', cmd], capture_output=True)
    return p.stdout.decode('utf-8', errors='replace').strip()

print('=== 1. Test 5G with channel 149 ===')
sh('dbus-send --system --print-reply --dest=net.connman /net/connman/technology/wifi net.connman.Technology.SetProperty string:Tethering5gChannel variant:int32:149')
sh('dbus-send --system --print-reply --dest=net.connman /net/connman/technology/wifi net.connman.Technology.SetProperty string:Tethering variant:boolean:false')
time.sleep(1.5)
sh('dbus-send --system --print-reply --dest=net.connman /net/connman/technology/wifi net.connman.Technology.SetProperty string:Tethering variant:boolean:true')
time.sleep(4)
print('5G 149 result:', sh('wpa_cli status | grep -E "(freq|channel|ssid)"'))

print('=== 2. Check iw phy or supported channels ===')
print('iw list:', sh('iw phy0 info 2>/dev/null || iw list 2>/dev/null || wl country 2>/dev/null'))
