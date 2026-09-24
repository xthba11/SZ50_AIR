import os, subprocess, time

os.environ['ANDROID_ADB_SERVER_PORT'] = '5038'
ADB = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'

def test_channel(ch):
    cmd = f"/usr/bin/connmanctl tethering_5g_channel {ch}; /usr/bin/connmanctl tether wifi off; sleep 1; /usr/bin/connmanctl tether wifi on"
    subprocess.run([ADB, 'shell', cmd], capture_output=True, timeout=15)
    time.sleep(2)
    res = subprocess.run([ADB, 'shell', 'wpa_cli -i wlan0 status'], capture_output=True, text=True)
    freq = None
    for line in res.stdout.split('\n'):
        if line.startswith('freq='):
            freq = line.strip().split('=')[1]
            break
    actual_ch = None
    if freq:
        f = int(freq)
        actual_ch = (f - 5000) // 5
    print(f"Set 5G Channel {ch:3d} -> Actual Freq: {freq} (Channel {actual_ch})")
    return actual_ch

print("Testing 5G channels:")
for ch in [36, 44, 48, 56, 149]:
    test_channel(ch)

# restore to 44
print("\nRestoring to channel 44...")
test_channel(44)
