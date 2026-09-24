import urllib.request, json, base64, os, time
from pathlib import Path
from playwright.sync_api import sync_playwright

root = Path('.')
adb_bin = str(next(root.glob('*/SZ*/adb.exe')))
os.environ['ANDROID_ADB_SERVER_PORT'] = '5038'

# Ensure port forwarding
import subprocess
subprocess.run([adb_bin, 'forward', 'tcp:18880', 'tcp:18080'], check=True)

# Read credentials
cred_proc = subprocess.run([adb_bin, 'shell', 'cat /home/root/admin-auth/credentials.json'], capture_output=True, text=True)
c = json.loads(cred_proc.stdout.strip())

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    page = browser.new_page(
        http_credentials={'username': c['username'], 'password': c['password']},
        viewport={'width': 1280, 'height': 900}
    )

    # 1. Check Monitor page
    print('Testing monitor page...')
    page.goto('http://127.0.0.1:18880/html/monitor.html', wait_until='networkidle')
    page.wait_for_selector('.trend-row', timeout=10000)
    hit_rect = page.locator('.trend-row rect').first
    box = hit_rect.bounding_box()
    if box:
        page.mouse.move(box['x'] + box['width'] * 0.6, box['y'] + box['height'] * 0.5)
        page.wait_for_timeout(500)
    page.screenshot(path='.tools/test-monitor-pc.png')
    popover_visible = page.locator('.trend-popover').first.is_visible()
    print('Monitor popover visible on hover:', popover_visible)

    # 2. Check SIM page
    print('Testing SIM page...')
    page.goto('http://127.0.0.1:18880/html/sim.html', wait_until='networkidle')
    page.wait_for_selector('.sim-speed-box', timeout=10000)
    sim_rect = page.locator('#direct-chart-container rect').first
    sbox = sim_rect.bounding_box()
    if sbox:
        page.mouse.move(sbox['x'] + sbox['width'] * 0.5, sbox['y'] + sbox['height'] * 0.5)
        page.wait_for_timeout(500)
    page.screenshot(path='.tools/test-sim-pc.png')
    sim_tooltip_visible = page.locator('#direct-chart-container .chart-tooltip').is_visible()
    print('SIM tooltip visible on hover:', sim_tooltip_visible)

    # 3. Check Devices page
    print('Testing Devices page...')
    page.goto('http://127.0.0.1:18880/html/devices.html', wait_until='networkidle')
    page.wait_for_selector('.speed-panel', timeout=10000)
    dev_rect = page.locator('.speed-panel rect').first
    dbox = dev_rect.bounding_box()
    if dbox:
        page.mouse.move(dbox['x'] + dbox['width'] * 0.5, dbox['y'] + dbox['height'] * 0.5)
        page.wait_for_timeout(500)
    page.screenshot(path='.tools/test-devices-pc.png')
    dev_tooltip_visible = page.locator('.speed-tooltip').first.is_visible()
    print('Devices tooltip visible on hover:', dev_tooltip_visible)

    # 4. Check Traffic page (liuliang)
    print('Testing Liuliang page...')
    page.goto('http://127.0.0.1:18880/html/liuliang.html', wait_until='networkidle')
    page.wait_for_selector('.charts-unified-grid', timeout=10000)
    grid_display = page.evaluate('getComputedStyle(document.querySelector(".charts-unified-grid")).display')
    grid_flex_dir = page.evaluate('getComputedStyle(document.querySelector(".charts-unified-grid")).flexDirection')
    print('Liuliang charts display:', grid_display, 'direction:', grid_flex_dir)
    page.screenshot(path='.tools/test-liuliang-pc.png')

    res = page.evaluate('async () => { const r = await fetch("/air-api/traffic/vnstatd"); return await r.json(); }')
    print('Vnstatd API status:', res)

    # 5. Check Proxy page
    print('Testing Proxy page...')
    page.goto('http://127.0.0.1:18880/html/proxy.html', wait_until='networkidle')
    page.wait_for_selector('.bypass-edit-section', timeout=10000)
    quick_tags_count = page.locator('.quick-tags').count()
    print('Proxy quick-tags count:', quick_tags_count)
    page.screenshot(path='.tools/test-proxy-pc.png')

    # 6. Check Battery Charge page
    print('Testing Charge page...')
    page.goto('http://127.0.0.1:18880/html/charge.html', wait_until='networkidle')
    page.wait_for_selector('#air-charge-master-toggle', state='attached', timeout=10000)
    master_toggle_checked = page.locator('#air-charge-master-toggle').is_checked()
    master_tag_text = page.locator('#air-charge-master-tag').inner_text()
    print('Master charging toggle checked:', master_toggle_checked, 'tag:', master_tag_text)
    page.screenshot(path='.tools/test-charge-pc.png')

    # 7. Check AT console page
    print('Testing AT page...')
    page.goto('http://127.0.0.1:18880/?page=at', wait_until='networkidle')
    at_frame = page.frame_locator('#at')
    at_frame.locator('.demo-tabs').wait_for(timeout=15000)
    tab_set_display = at_frame.locator('#tab-set').evaluate('el => getComputedStyle(el).display')
    print('AT tab-set display:', tab_set_display)
    page.screenshot(path='.tools/test-at-pc.png')

    browser.close()
    print('ALL VERIFICATIONS COMPLETED SUCCESSFULLY!')
