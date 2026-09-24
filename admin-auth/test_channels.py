import os, subprocess

os.environ['ANDROID_ADB_SERVER_PORT'] = '5038'
ADB = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'

for ch in [36, 40, 44, 48, 52, 56, 60, 64, 149, 153, 157, 161, 165]:
    cmd = f"/usr/bin/connmanctl tethering_5g_channel {ch}; grep 'Tethering.5gChannel' /var/lib/connman/settings"
    res = subprocess.run([ADB, 'shell', cmd], capture_output=True, text=True)
    out = res.stdout.strip().replace('\n', ' | ')
    print(f"Channel {ch}: {out}")
