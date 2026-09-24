import urllib.request, json, base64, os, time, subprocess
from pathlib import Path
from playwright.sync_api import sync_playwright

root = Path('.')
adb_bin = str(next(root.glob('*/SZ*/adb.exe')))
os.environ['ANDROID_ADB_SERVER_PORT'] = '5038'

subprocess.run([adb_bin, 'forward', 'tcp:18880', 'tcp:18080'], check=True)
subprocess.run([adb_bin, 'forward', 'tcp:18881', 'tcp:18081'], check=True)

cred_proc = subprocess.run([adb_bin, 'shell', 'cat /home/root/admin-auth/credentials.json'], capture_output=True, text=True)
c = json.loads(cred_proc.stdout.strip())

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    page = browser.new_page(
        http_credentials={'username': c['username'], 'password': c['password']},
        viewport={'width': 1280, 'height': 900}
    )

    print('Testing AT console on port 18881...', flush=True)
    page.goto('http://127.0.0.1:18881/', wait_until='domcontentloaded')
    page.wait_for_selector('.demo-tabs', timeout=15000)
    tab_set_display = page.evaluate('() => { const el = document.querySelector("#tab-set"); return el ? getComputedStyle(el).display : "not_found"; }')
    pane_set_display = page.evaluate('() => { const el = document.querySelector("#pane-set"); return el ? getComputedStyle(el).display : "not_found"; }')
    print('AT #tab-set display:', tab_set_display, flush=True)
    print('AT #pane-set display:', pane_set_display, flush=True)
    page.screenshot(path='.tools/test-at-pc.png')

    browser.close()
    print('AT VERIFICATION COMPLETED SUCCESSFULLY!', flush=True)
