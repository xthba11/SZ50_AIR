import os, subprocess

os.environ['ANDROID_ADB_SERVER_PORT'] = '5038'
ADB = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'

cmd = "find /mnt -name '*ini*' 2>/dev/null; find /data -name '*ini*' 2>/dev/null; find /etc -name '*ini*' 2>/dev/null; find /var -name '*ini*' 2>/dev/null"
r = subprocess.run([ADB, 'shell', cmd], capture_output=True, text=True)
print(r.stdout)
