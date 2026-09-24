import os, subprocess, json, base64, urllib.request, time

os.environ['ANDROID_ADB_SERVER_PORT'] = '5038'
ADB = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'

def adb_shell(cmd):
    p = subprocess.run([ADB, 'shell', cmd], capture_output=True, text=True)
    return p.stdout.strip(), p.stderr.strip()

print("--- 1. Current State ---")
out, _ = adb_shell('wpa_cli -i wlan0 status; connmanctl technologies')
print(out)

print("\n--- 2. Invoking toggle_wifi via HTTP POST (simulating browser) ---")
c_raw = subprocess.check_output([ADB, 'shell', 'cat /home/root/admin-auth/credentials.json']).decode()
c = json.loads(c_raw)
auth = 'Basic ' + base64.b64encode(f"{c['username']}:{c['password']}".encode()).decode()

req = urllib.request.Request(
    'http://127.0.0.1:18880/cgi-bin/traffic.cgi',
    headers={'Authorization': auth, 'Content-Type': 'application/x-www-form-urlencoded'},
    data=b'action=toggle_wifi'
)
try:
    resp = urllib.request.urlopen(req, timeout=15).read().decode()
    print("HTTP Response:", resp)
except Exception as e:
    print("HTTP Error:", e)

time.sleep(3)

print("\n--- 3. State After 1st Toggle (Turning OFF) ---")
out, _ = adb_shell('wpa_cli -i wlan0 status; connmanctl technologies; ps | grep -E "connman|wpa"')
print(out)

print("\n--- 4. Invoking toggle_wifi AGAIN (Turning ON) ---")
try:
    req = urllib.request.Request(
        'http://127.0.0.1:18880/cgi-bin/traffic.cgi',
        headers={'Authorization': auth, 'Content-Type': 'application/x-www-form-urlencoded'},
        data=b'action=toggle_wifi'
    )
    resp = urllib.request.urlopen(req, timeout=15).read().decode()
    print("HTTP Response 2:", resp)
except Exception as e:
    print("HTTP Error 2:", e)

time.sleep(3)

print("\n--- 5. State After 2nd Toggle (Turning ON) ---")
out, _ = adb_shell('wpa_cli -i wlan0 status; connmanctl technologies; ps | grep -E "connman|wpa"')
print(out)
