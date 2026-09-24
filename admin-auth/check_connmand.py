import os, subprocess

os.environ['ANDROID_ADB_SERVER_PORT'] = '5038'
ADB = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'

cmd = "strings /usr/sbin/connmand | grep -C 5 '5G channel'"
r = subprocess.run([ADB, 'shell', cmd], capture_output=True, text=True)
print(r.stdout)
