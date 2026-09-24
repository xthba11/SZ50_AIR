import os, subprocess, json
os.environ['ANDROID_ADB_SERVER_PORT'] = '5038'
from pathlib import Path
adb = str(next(Path('.').glob('*/SZ*/adb.exe')))

def run_cmd(cmd):
    return subprocess.run([adb, 'shell', cmd], capture_output=True, text=True).stdout

res = run_cmd("curl -s http://127.0.0.1:8080/api/get/sysinfo")
try:
    d = json.loads(res)
    print("Code:", d.get('Code'))
    print("Data keys:", list(d.get('Data', {}).keys()))
    print("Battery info:", {k: v for k, v in d.get('Data', {}).items() if 'BAT' in k or 'POWER' in k or 'CAPACITY' in k or 'CHARGE' in k})
except Exception as e:
    print("Error:", e, res)
