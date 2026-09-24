import json, os, urllib.request, base64, subprocess
from pathlib import Path
from playwright.sync_api import sync_playwright

ROOT = Path(__file__).resolve().parents[1]
ADB = str(next(ROOT.glob('*/SZ*/adb.exe')))
os.environ.setdefault('ANDROID_ADB_SERVER_PORT', '5038')

def adb(*args):
    return subprocess.check_output([ADB, *args])

def main():
    adb('forward', 'tcp:18890', 'tcp:18080')
    try:
        cred_raw = subprocess.check_output([ADB, 'shell', 'cat /home/root/admin-auth/credentials.json']).decode('utf-8')
        c = json.loads(cred_raw)
        auth = 'Basic ' + base64.b64encode(f"{c['username']}:{c['password']}".encode()).decode()

        def api_get(path):
            req = urllib.request.Request('http://127.0.0.1:18890' + path, headers={'Authorization': auth})
            return json.loads(urllib.request.urlopen(req, timeout=10).read())

        daily_data = api_get('/air-api/traffic/daily')
        print('Real device /air-api/traffic/daily:', json.dumps(daily_data, ensure_ascii=False, indent=2))

        traffic_data = api_get('/air-api/traffic')
        print('Real device /air-api/traffic clients count:', len(traffic_data.get('clients', [])))
        for cl in traffic_data.get('clients', []):
            print(f"Device {cl.get('mac')}: down={cl.get('down_bytes')}, up={cl.get('up_bytes')}, proxy_down={cl.get('proxy_down_bytes')}, proxy_up={cl.get('proxy_up_bytes')}")

        with sync_playwright() as p:
            browser = p.chromium.launch(headless=True)

            # 1. Capture real devices page on PC
            page = browser.new_page(http_credentials={'username': c['username'], 'password': c['password']}, viewport={'width': 1280, 'height': 900})
            page.goto('http://127.0.0.1:18890/?page=devices', wait_until='networkidle')
            page.wait_for_timeout(2000)
            page.screenshot(path=str(ROOT / '.tools/live-devices-desktop.png'), full_page=True)

            # 2. Capture real liuliang inner page on PC
            page_ll = browser.new_page(http_credentials={'username': c['username'], 'password': c['password']}, viewport={'width': 1280, 'height': 1000})
            page_ll.goto('http://127.0.0.1:18890/html/liuliang.html', wait_until='networkidle')
            page_ll.wait_for_timeout(2000)
            page_ll.screenshot(path=str(ROOT / '.tools/live-liuliang-desktop.png'), full_page=True)

            # 3. Capture real liuliang inner page on mobile
            page_ll.set_viewport_size({'width': 390, 'height': 844})
            page_ll.wait_for_timeout(500)
            page_ll.screenshot(path=str(ROOT / '.tools/live-liuliang-mobile.png'), full_page=True)

            browser.close()
            print('Live screenshots saved successfully!')
    finally:
        adb('forward', '--remove', 'tcp:18890')

if __name__ == '__main__':
    main()
