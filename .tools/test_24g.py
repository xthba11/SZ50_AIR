import subprocess, os, time

os.environ['ANDROID_ADB_SERVER_PORT'] = '5038'
adb_bin = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'

def sh(cmd):
    p = subprocess.run([adb_bin, 'shell', cmd], capture_output=True)
    return p.stdout.decode('utf-8', errors='replace').strip()

print('=== Switch to 2.4G mode ===')
print(sh('dbus-send --system --print-reply --dest=net.connman /net/connman/technology/wifi net.connman.Technology.SetProperty string:TetheringMode variant:string:"2.4G"'))
print(sh('dbus-send --system --print-reply --dest=net.connman /net/connman/technology/wifi net.connman.Technology.SetProperty string:TetheringChannel variant:int32:6'))
print(sh('dbus-send --system --print-reply --dest=net.connman /net/connman/technology/wifi net.connman.Technology.SetProperty string:Tethering variant:boolean:false'))
time.sleep(2)
print(sh('dbus-send --system --print-reply --dest=net.connman /net/connman/technology/wifi net.connman.Technology.SetProperty string:Tethering variant:boolean:true'))
time.sleep(5)
print(sh('wpa_cli status'))
