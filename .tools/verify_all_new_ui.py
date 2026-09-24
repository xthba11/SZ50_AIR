import os, subprocess, pathlib, json, base64, time
from playwright.sync_api import sync_playwright

ROOT = pathlib.Path(__file__).resolve().parents[1]
adb = str(next(ROOT.glob('*/SZ*/adb.exe')))
os.environ['ANDROID_ADB_SERVER_PORT'] = '5038'

subprocess.run([adb, 'forward', 'tcp:18899', 'tcp:18080'])
try:
    out = subprocess.run([adb, 'shell', 'cat /home/root/admin-auth/credentials.json'], capture_output=True, text=True).stdout
    c = json.loads(out)
    auth = {'username': c['username'], 'password': c['password']}

    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)

        # 1. Desktop - Index with Sidebar
        page = browser.new_page(http_credentials=auth, viewport={'width': 1366, 'height': 850})
        page.goto('http://127.0.0.1:18899/?page=devices', wait_until='networkidle')
        time.sleep(2)
        page.screenshot(path=str(ROOT / '.tools/devices-desktop.png'), full_page=True)

        # 2. Devices Iframe standalone (Desktop & Mobile)
        page_dev = browser.new_page(http_credentials=auth, viewport={'width': 1200, 'height': 800})
        page_dev.goto('http://127.0.0.1:18899/html/devices.html', wait_until='networkidle')
        time.sleep(2)
        page_dev.screenshot(path=str(ROOT / '.tools/devices-compact-desktop.png'), full_page=True)

        page_dev_m = browser.new_page(http_credentials=auth, viewport={'width': 390, 'height': 844})
        page_dev_m.goto('http://127.0.0.1:18899/html/devices.html', wait_until='networkidle')
        time.sleep(2)
        page_dev_m.screenshot(path=str(ROOT / '.tools/devices-compact-mobile.png'), full_page=True)

        # 3. Traffic Management Page (Desktop & Mobile)
        page_tf = browser.new_page(http_credentials=auth, viewport={'width': 1200, 'height': 900})
        page_tf.goto('http://127.0.0.1:18899/html/liuliang.html', wait_until='networkidle')
        time.sleep(2)
        page_tf.screenshot(path=str(ROOT / '.tools/liuliang-unified-desktop.png'), full_page=True)

        page_tf_m = browser.new_page(http_credentials=auth, viewport={'width': 390, 'height': 844})
        page_tf_m.goto('http://127.0.0.1:18899/html/liuliang.html', wait_until='networkidle')
        time.sleep(2)
        page_tf_m.screenshot(path=str(ROOT / '.tools/liuliang-unified-mobile.png'), full_page=True)

        # 4. Independent Battery Settings Page
        page_ch = browser.new_page(http_credentials=auth, viewport={'width': 1200, 'height': 800})
        page_ch.goto('http://127.0.0.1:18899/html/charge.html', wait_until='networkidle')
        time.sleep(2)
        page_ch.screenshot(path=str(ROOT / '.tools/charge-independent-desktop.png'), full_page=True)

        browser.close()
    print("ALL SCREENSHOTS CAPTURED SUCCESSFULLY!")
finally:
    subprocess.run([adb, 'forward', '--remove', 'tcp:18899'])
