import os, subprocess, time

os.environ['ANDROID_ADB_SERVER_PORT'] = '5038'
ADB = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'

for ch in [36, 40, 44, 48, 52, 56, 149]:
    cmd = f"/usr/bin/connmanctl tethering_5g_channel {ch} >/dev/null; /usr/bin/connmanctl tether wifi off >/dev/null; sleep 1; /usr/bin/connmanctl tether wifi on >/dev/null; sleep 2; wpa_cli -i wlan0 status | grep freq"
    res = subprocess.run([ADB, 'shell', cmd], capture_output=True, text=True)
    out = res.stdout.strip()
    print(f"Target 5G Channel {ch} -> Hardware actual: {out}")
