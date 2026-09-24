import subprocess, os, json, urllib.request, base64, time
from playwright.sync_api import sync_playwright

os.environ['ANDROID_ADB_SERVER_PORT'] = '5038'
adb_bin = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'

# Port forward
subprocess.run([adb_bin, 'forward', 'tcp:18882', 'tcp:18080'], check=True)

try:
    # Read credentials
    creds_raw = subprocess.run([adb_bin, 'shell', 'cat /home/root/admin-auth/credentials.json'], capture_output=True, text=True).stdout
    creds = json.loads(creds_raw)
    user = creds['username']
    pwd = creds['password']
    auth = 'Basic ' + base64.b64encode(f'{user}:{pwd}'.encode()).decode()

    def query(path, method='GET', data=None):
        req = urllib.request.Request(
            'http://127.0.0.1:18882' + path,
            headers={'Authorization': auth, 'Content-Type': 'application/json'},
            method=method,
            data=json.dumps(data).encode('utf-8') if data else None
        )
        with urllib.request.urlopen(req, timeout=15) as res:
            return json.loads(res.read().decode())

    print('=== 1. Test Channel Switch API to Channel 40 ===')
    sw_res = query('/air-api/wifi/channel', method='POST', data={'channel': 40, 'mode': '5G'})
    print('Switch to 40 response:', sw_res)
    time.sleep(2)
    wpa_status = subprocess.run([adb_bin, 'shell', 'wpa_cli status'], capture_output=True, text=True).stdout
    print('wpa_cli status after 40:')
    for l in wpa_status.splitlines():
        if any(k in l for k in ['freq=', 'ssid=', 'bssid=']):
            print(' ', l)
    assert 'freq=5200' in wpa_status, 'wpa_supplicant must be at freq 5200 (channel 40)!'

    print('\n=== 2. Switch back to Channel 36 ===')
    sw_res2 = query('/air-api/wifi/channel', method='POST', data={'channel': 36, 'mode': '5G'})
    print('Switch to 36 response:', sw_res2)
    time.sleep(2)
    wpa_status2 = subprocess.run([adb_bin, 'shell', 'wpa_cli status'], capture_output=True, text=True).stdout
    print('wpa_cli status after 36:')
    for l in wpa_status2.splitlines():
        if any(k in l for k in ['freq=', 'ssid=', 'bssid=']):
            print(' ', l)
    assert 'freq=5180' in wpa_status2, 'wpa_supplicant must be at freq 5180 (channel 36)!'

    print('\n=== 3. Test /air-api/wifi/radar API ===')
    radar = query('/air-api/wifi/radar')
    print('Current Channel:', radar.get('current_channel'))
    print('Current Mode:', radar.get('current_mode'))
    print('Total APs detected:', len(radar.get('networks', [])))

    print('\n=== 4. Playwright Screenshot of Redesigned Wi-Fi Page ===')
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page(http_credentials={'username': user, 'password': pwd}, viewport={'width': 420, 'height': 900})
        page.goto('http://127.0.0.1:18882/html/z50_air_wifi.html', wait_until='domcontentloaded')
        page.wait_for_timeout(3000)
        
        # Verify mode status and channel status elements exist
        assert page.locator('#mode-status').count() == 1
        assert page.locator('#channel-status').count() == 1
        assert page.locator('#radar-ap-list').count() == 1
        
        page.screenshot(path='.tools/wifi_redesign.png', full_page=True)
        print('Screenshot saved to .tools/wifi_redesign.png')
        browser.close()

    print('\nALL LIVE REDESIGN VERIFICATIONS PASSED!')

finally:
    subprocess.run([adb_bin, 'forward', '--remove', 'tcp:18882'])
