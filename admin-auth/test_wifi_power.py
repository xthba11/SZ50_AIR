import os, subprocess, json, base64, urllib.request, time

os.environ['ANDROID_ADB_SERVER_PORT'] = '5038'
ADB = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'

subprocess.run([ADB, 'forward', 'tcp:18880', 'tcp:18080'])

c_raw = subprocess.check_output([ADB, 'shell', 'cat /home/root/admin-auth/credentials.json']).decode()
c = json.loads(c_raw)
auth = 'Basic ' + base64.b64encode(f"{c['username']}:{c['password']}".encode()).decode()

def get_power():
    req = urllib.request.Request('http://127.0.0.1:18880/air-api/wifi/power', headers={'Authorization': auth})
    return json.loads(urllib.request.urlopen(req, timeout=10).read().decode())

def set_power(enable):
    req = urllib.request.Request(
        'http://127.0.0.1:18880/air-api/wifi/power',
        headers={'Authorization': auth, 'Content-Type': 'application/json'},
        data=json.dumps({'enable': enable}).encode()
    )
    return json.loads(urllib.request.urlopen(req, timeout=15).read().decode())

print("[1] Initial WiFi power state:")
print(json.dumps(get_power(), indent=2))

print("\n[2] Turning OFF WiFi (enable=False)...")
res_off = set_power(False)
print("Turn off response:", res_off)
time.sleep(2)
print("After turn off state:", json.dumps(get_power(), indent=2))

print("\n[3] Turning ON WiFi (enable=True)...")
res_on = set_power(True)
print("Turn on response:", res_on)
time.sleep(3)
print("After turn on state:", json.dumps(get_power(), indent=2))

print("\n[4] Hardware wpa_cli status:")
out = subprocess.check_output([ADB, 'shell', 'wpa_cli -i wlan0 status; connmanctl technologies']).decode()
print(out)
