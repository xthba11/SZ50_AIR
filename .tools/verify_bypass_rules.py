import os, subprocess, pathlib, json, base64, urllib.request

adb = str(next(pathlib.Path('.').glob('*/SZ*/adb.exe')))
os.environ['ANDROID_ADB_SERVER_PORT'] = '5038'

subprocess.run([adb, 'forward', 'tcp:18893', 'tcp:18080'])
try:
    out = subprocess.run([adb, 'shell', 'cat /home/root/admin-auth/credentials.json'], capture_output=True, text=True).stdout
    c = json.loads(out)
    auth = 'Basic ' + base64.b64encode((c['username'] + ':' + c['password']).encode()).decode()

    # 1. Test in Global Mode
    req = urllib.request.Request('http://127.0.0.1:18893/air-api/proxy/mode', headers={'Authorization': auth, 'Content-Type': 'application/json'}, data=b'{"mode":"global"}')
    urllib.request.urlopen(req)

    req = urllib.request.Request('http://127.0.0.1:18893/air-api/proxy/toggle', headers={'Authorization': auth, 'Content-Type': 'application/json'}, data=b'{"enabled":true}')
    urllib.request.urlopen(req)

    cfg_out = subprocess.run([adb, 'shell', 'cat /home/root/admin-auth/proxy/config.json'], capture_output=True, text=True).stdout
    cfg = json.loads(cfg_out)
    rules_global = cfg.get('routing', {}).get('rules', [])
    print("=== Rules in Global Mode ===")
    for r in rules_global:
        print(f"  outbound: {r.get('outboundTag')}, domain: {r.get('domain')}, ip: {r.get('ip')}, network: {r.get('network')}")

    # 2. Test in Bypass CN Mode
    req = urllib.request.Request('http://127.0.0.1:18893/air-api/proxy/mode', headers={'Authorization': auth, 'Content-Type': 'application/json'}, data=b'{"mode":"bypass_cn"}')
    urllib.request.urlopen(req)

    cfg_out = subprocess.run([adb, 'shell', 'cat /home/root/admin-auth/proxy/config.json'], capture_output=True, text=True).stdout
    cfg = json.loads(cfg_out)
    rules_cn = cfg.get('routing', {}).get('rules', [])
    print("\n=== Rules in Bypass_CN Mode ===")
    for r in rules_cn:
        doms = r.get('domain', [])
        dom_preview = f"[{doms[0]}... {len(doms)} items]" if len(doms) > 3 else doms
        ips = r.get('ip', [])
        ip_preview = f"[{ips[0]}... {len(ips)} items]" if len(ips) > 3 else ips
        print(f"  outbound: {r.get('outboundTag')}, domain: {dom_preview}, ip: {ip_preview}, network: {r.get('network')}")

    # Turn off proxy after verification
    req = urllib.request.Request('http://127.0.0.1:18893/air-api/proxy/toggle', headers={'Authorization': auth, 'Content-Type': 'application/json'}, data=b'{"enabled":false}')
    urllib.request.urlopen(req)
    print("\nProxy turned OFF after testing.")

finally:
    subprocess.run([adb, 'forward', '--remove', 'tcp:18893'])
