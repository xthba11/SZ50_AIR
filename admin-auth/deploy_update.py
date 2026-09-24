"""Deploy wifi radar & charging protection updates to device"""
import os, subprocess, json, time, base64, urllib.request

os.environ['ANDROID_ADB_SERVER_PORT'] = '5038'
ADB = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'

def run_adb(*args):
    p = subprocess.run([ADB, *args], capture_output=True, text=True)
    if p.returncode != 0:
        raise RuntimeError(f"ADB failed: {p.stderr.strip()}")
    return p.stdout

print("[1/6] Pushing admin-gateway...")
run_adb('push', 'admin-auth/admin-gateway', '/home/root/admin-auth/admin-gateway.new')
run_adb('shell', 'chmod +x /home/root/admin-auth/admin-gateway.new && mv -f /home/root/admin-auth/admin-gateway.new /home/root/admin-auth/admin-gateway')

print("[2/6] Updating charge_rule.json & resetting charging_enabled=true...")
fix_charge_script = '''
cat << 'EOF' > /home/root/admin-auth/charge_rule.json
{
  "charging_enabled": true,
  "enabled": true,
  "start_percent": 20,
  "stop_percent": 80
}
EOF
echo 0 > /sys/class/power_supply/battery/charger.0/stop_charge 2>/dev/null
echo 960000 > /sys/class/power_supply/sgm4154x-charger/constant_charge_current 2>/dev/null
'''
run_adb('shell', fix_charge_script)

print("[3/6] Updating supervise.sh with connmand & wifi watchdog...")
supervise_script = '''
cat << 'EOF' > /home/root/admin-auth/supervise.sh
#!/bin/sh

check_wifi_and_connman() {
    # 1. 检查 Wi-Fi 驱动，避免系统 rmmod 后热点丢失
    if ! lsmod | grep -q "sprdwl_ng"; then
        modprobe sprdwl_ng 2>/dev/null
        sleep 1
    fi

    # 2. 检查 connmand 守护进程，如果挂掉自动重启
    if ! ps | grep -v grep | grep -q "connmand"; then
        /usr/sbin/connmand 2>/dev/null &
    fi
}

while true; do
    check_wifi_and_connman

    if ! ps | grep -v grep | grep -q "admin-gateway"; then
        /home/root/admin-auth/admin-gateway &
        CHILD=$!
        echo "$CHILD" >/var/run/admin-auth.pid
    fi

    sleep 3
done
EOF
chmod +x /home/root/admin-auth/supervise.sh
'''
run_adb('shell', supervise_script)

print("[4/6] Pushing frontend assets...")
run_adb('push', 'ui/air-wifi-radar.js', '/webui/air-wifi-radar.js')
run_adb('push', 'ui/inner-pages/z50_air_wifi.html', '/webui/html/z50_air_wifi.html')

print("[5/6] Restarting admin-gateway...")
run_adb('shell', 'chmod +x /home/root/admin-auth/*.sh && /home/root/admin-auth/start.sh; killall -9 admin-gateway 2>/dev/null; sleep 3; ps | grep -E "admin-gateway|connmand"')

print("[6/6] Verifying gateway and API responsiveness...")
run_adb('forward', 'tcp:18880', 'tcp:18080')
time.sleep(2)

c_raw = run_adb('shell', 'cat /home/root/admin-auth/credentials.json')
c = json.loads(c_raw)
auth = 'Basic ' + base64.b64encode(f"{c['username']}:{c['password']}".encode()).decode()

req = urllib.request.Request('http://127.0.0.1:18880/air-api/charge', headers={'Authorization': auth})
charge_data = json.loads(urllib.request.urlopen(req, timeout=10).read().decode())
print("Charge Status API:", json.dumps(charge_data, indent=2, ensure_ascii=False))

req_radar = urllib.request.Request('http://127.0.0.1:18880/air-api/wifi/radar', headers={'Authorization': auth})
radar_data = json.loads(urllib.request.urlopen(req_radar, timeout=10).read().decode())
print(f"Radar API: current_channel={radar_data.get('current_channel')}, current_mode={radar_data.get('current_mode')}, recommended={radar_data.get('recommended_channel')}")
print(f"Scores 5G count: {len(radar_data.get('scores_5g', []))}")
channels_in_5g = [s['channel'] for s in radar_data.get('scores_5g', [])]
print(f"5G channels: {channels_in_5g}")

print("\nDeployment successfully verified!")
