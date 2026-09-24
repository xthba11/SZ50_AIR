import subprocess, json
from playwright.sync_api import sync_playwright

ADB = r'原始工具\SZ50_AIR一键破解\adb.exe'
subprocess.run([ADB, 'forward', 'tcp:18899', 'tcp:18080'], capture_output=True)
creds = json.loads(subprocess.run([ADB, 'shell', 'cat /home/root/admin-auth/credentials.json'], capture_output=True, text=True).stdout)
U, P = creds['username'], creds['password']

with sync_playwright() as p:
    browser = p.chromium.launch()
    page = browser.new_page(viewport={'width': 1920, 'height': 1080})
    page.goto('http://127.0.0.1:18899/')
    if '/air-login' in page.url:
        page.fill('#username', U)
        page.fill('#password', P)
        page.click('.login-submit')
        page.wait_for_load_state('load')
    page.wait_for_timeout(1000)

    # Click atweb button
    page.click("a[data-section='atweb']")
    page.wait_for_timeout(3000)
    page.screenshot(path='.tools/audit_shots/test_atweb_direct.png')

    # Click terminalweb button
    page.click("a[data-section='terminalweb']")
    page.wait_for_timeout(3000)
    page.screenshot(path='.tools/audit_shots/test_terminalweb_direct.png')

    frames = page.frames
    print('PAGE FRAMES COUNT:', len(frames))
    for f in frames:
        print('FRAME:', f.name, f.url)
    browser.close()
