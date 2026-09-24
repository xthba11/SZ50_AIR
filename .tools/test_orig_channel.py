import subprocess, os, time, urllib.request

os.environ['ANDROID_ADB_SERVER_PORT'] = '5038'
adb_bin = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'

def sh(cmd):
    p = subprocess.run([adb_bin, 'shell', cmd], capture_output=True)
    return p.stdout.decode('utf-8', errors='replace').strip()

# Check connmand
ps = sh('ps | grep connman')
if 'connmand' not in ps:
    print('Starting connmand...')
    sh('/usr/sbin/connmand -n -d >/dev/null 2>&1 &')
    time.sleep(2)

print('Connman status:', sh('ps | grep connman'))

# Port forward 80
subprocess.run([adb_bin, 'forward', 'tcp:18088', 'tcp:80'])
try:
    data = 'action=switch_wifi_channel&target_channel=40'.encode('utf-8')
    req = urllib.request.Request('http://127.0.0.1:18088/cgi-bin/traffic.cgi', data=data, headers={'Content-Type': 'application/x-www-form-urlencoded'})
    try:
        with urllib.request.urlopen(req, timeout=5) as res:
            print('traffic.cgi response:', res.read().decode('utf-8', errors='replace'))
    except Exception as e:
        print('traffic.cgi error:', e)
    
    time.sleep(3)
    print('wpa status:', sh('wpa_cli status | grep freq'))
    print('connman settings channel:', sh('cat /var/lib/connman/settings | grep -i channel'))
finally:
    subprocess.run([adb_bin, 'forward', '--remove', 'tcp:18088'])
