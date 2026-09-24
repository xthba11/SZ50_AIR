import subprocess, json
from playwright.sync_api import sync_playwright

ADB = r'原始工具\SZ50_AIR一键破解\adb.exe'
subprocess.run([ADB, 'forward', 'tcp:18899', 'tcp:18080'], capture_output=True)
creds = json.loads(subprocess.run([ADB, 'shell', 'cat /home/root/admin-auth/credentials.json'], capture_output=True, text=True).stdout)
U, P = creds['username'], creds['password']

with sync_playwright() as p:
    browser = p.chromium.launch()
    page = browser.new_page(viewport={'width': 1400, 'height': 900})
    page.goto('http://127.0.0.1:18899/')
    if '/air-login' in page.url:
        page.fill('#username', U)
        page.fill('#password', P)
        page.click('.login-submit')
        page.wait_for_load_state('load')
    page.wait_for_timeout(1500)
    page.screenshot(path='test-overview-battery.png')
    
    # Click sidebar link for chargeweb
    page.locator('#sidebar a[data-section="chargeweb"]').click()
    page.wait_for_timeout(2500)
    page.screenshot(path='test-charge-page.png')
    print('ALL OK')
    browser.close()
