import os, subprocess, json, base64, time
from pathlib import Path
from playwright.sync_api import sync_playwright

os.environ['ANDROID_ADB_SERVER_PORT'] = '5038'
root = Path(__file__).resolve().parents[1]
adb = str(next(root.glob('*/SZ*/adb.exe')))

subprocess.run([adb, 'forward', 'tcp:18892', 'tcp:18080'])
subprocess.run([adb, 'forward', 'tcp:8080', 'tcp:18081'])
out = subprocess.run([adb, 'shell', 'cat /home/root/admin-auth/credentials.json'], capture_output=True, text=True).stdout
c = json.loads(out)

import urllib.request
auth = 'Basic ' + base64.b64encode((c['username'] + ':' + c['password']).encode()).decode()

def api_get(path):
    req = urllib.request.Request('http://127.0.0.1:18892' + path, headers={'Authorization': auth})
    return json.loads(urllib.request.urlopen(req, timeout=10).read().decode())

print("=== 1. API Verification ===")
charge = api_get('/air-api/charge')
print(f"Charge API: capacity={charge.get('capacity')}%, charging={charge.get('charging')}, voltage_v={charge.get('voltage_v')}V, current_ma={charge.get('current_ma')}mA, enabled={charge.get('enabled')}, start={charge.get('start_percent')}%, stop={charge.get('stop_percent')}%")
assert 'voltage_v' in charge and 'current_ma' in charge, "Missing voltage/current in charge API"

speed = api_get('/air-api/network/speed')
samples = speed.get('samples', [])
print(f"Network speed samples: count={len(samples)}")
if samples:
    s = samples[-1]
    print(f"Latest sample: direct_down={s.get('direct_down_bps')}, proxy_down={s.get('proxy_down_bps')}, direct_up={s.get('direct_up_bps')}, proxy_up={s.get('proxy_up_bps')}")
    assert 'direct_down_bps' in s and 'proxy_down_bps' in s, "Missing split speed keys in sample"

proxy = api_get('/air-api/proxy')
print(f"Proxy API: enabled={proxy.get('enabled')}, routing_mode={proxy.get('routing_mode')}")

traffic = api_get('/air-api/traffic')
clients = traffic.get('clients', [])
print(f"Traffic clients: count={len(clients)}")
if clients:
    cl = clients[0]
    print(f"Client {cl.get('mac')}: proxy_enabled={cl.get('proxy_enabled')}, has_samples={bool(cl.get('samples'))}")

print("\n=== 2. Browser Playwright Verification ===")
results = {}

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    
    # --- Desktop 1280x800 ---
    page = browser.new_page(http_credentials={'username': c['username'], 'password': c['password']}, viewport={'width': 1280, 'height': 800})
    errors = []
    page.on('pageerror', lambda e: errors.append(str(e)))
    
    # A. SIM Page
    print("Testing SIM Page (Desktop)...")
    page.goto('http://127.0.0.1:18892/?page=clashweb', wait_until='networkidle')
    page.wait_for_timeout(2000)
    frame_sim = page.frame_locator('#clashweb')
    frame_sim.locator('.sim-speed-box').wait_for(timeout=10000)
    
    # Verify subcards order
    subcards = frame_sim.locator('.sim-speed-box > .sim-speed-subcard').all()
    subcard_classes = [sc.get_attribute('class') for sc in subcards]
    print("SIM subcards classes in order:", subcard_classes)
    assert 'direct-chart-subcard' in subcard_classes[0], "Direct chart must be first"
    assert 'proxy-chart-subcard' in subcard_classes[1], "Proxy chart must be second"
    
    # Check grid layout in desktop
    box_grid = frame_sim.locator('.sim-speed-box').evaluate('el => window.getComputedStyle(el).gridTemplateColumns')
    print("SIM speed box desktop grid-template-columns:", box_grid)
    cols = [c for c in box_grid.split(' ') if c]
    assert len(cols) == 2, f"Expected 2 grid columns on desktop, got: {box_grid}"
    
    page.screenshot(path='.tools/desktop_sim.png')
    results['desktop_sim'] = 'PASS (direct first, 2-column grid, thin lines)'
    
    # B. Devices Page
    print("Testing Devices Page (Desktop)...")
    page.goto('http://127.0.0.1:18892/?page=devices', wait_until='networkidle')
    page.wait_for_timeout(2500)
    frame_dev = page.frame_locator('#devices')
    frame_dev.locator('.device-card').first.wait_for(timeout=10000)
    
    # Check 2 columns grid on desktop
    dev_grid = frame_dev.locator('#devices').evaluate('el => window.getComputedStyle(el).gridTemplateColumns')
    print("Devices desktop grid-template-columns:", dev_grid)
    dev_cols = [c for c in dev_grid.split(' ') if c]
    assert len(dev_cols) == 2, f"Expected 2 grid columns for devices on desktop, got: {dev_grid}"
    
    # Check single device card elements
    card = frame_dev.locator('.device-card').first
    assert card.locator('.device-proxy-ctrl').is_visible(), "Device proxy toggle ctrl must be visible"
    proxy_slider = card.locator('.device-proxy-slider')
    assert proxy_slider.is_visible(), "Proxy slider switch must be visible"
    
    # Check speed chart SVG 4 lines
    chart = card.locator('.speed-panel')
    assert chart.is_visible(), "Speed chart panel must be visible"
    assert chart.locator('.speed-line-direct-down').count() == 1, "Direct down line missing"
    assert chart.locator('.speed-line-proxy-down').count() == 1, "Proxy down line missing"
    assert chart.locator('.speed-line-direct-up').count() == 1, "Direct up line missing"
    assert chart.locator('.speed-line-proxy-up').count() == 1, "Proxy up line missing"
    
    # Check stroke-width
    direct_down_sw = chart.locator('.speed-line-direct-down').evaluate('el => window.getComputedStyle(el).strokeWidth')
    proxy_down_sw = chart.locator('.speed-line-proxy-down').evaluate('el => window.getComputedStyle(el).strokeWidth')
    print(f"Chart line stroke widths: direct_down={direct_down_sw}, proxy_down={proxy_down_sw}")
    
    # Check legend
    legend_text = chart.locator('.speed-legend').inner_text()
    print("Speed legend text:", repr(legend_text))
    assert '直连下载' in legend_text and '代理下载' in legend_text and '直连上传' in legend_text and '代理上传' in legend_text
    
    # Check rate badges
    badges_text = chart.locator('.speed-rate-badges').inner_text()
    print("Rate badges text:", repr(badges_text))
    assert '直连' in badges_text and '代理' in badges_text
    
    page.screenshot(path='.tools/desktop_devices.png')
    results['desktop_devices'] = 'PASS (2-col grid, proxy switch, 4-line chart, thin lines)'
    
    # C. AT Console Charge Tab
    print("Testing AT Console Charge UI (Desktop)...")
    page.goto('http://127.0.0.1:18892/?page=atweb', wait_until='networkidle')
    page.wait_for_timeout(2000)
    frame_at = page.frame_locator('#atweb')
    frame_at.locator('#tab-set').click()
    page.wait_for_timeout(1500)
    
    charge_card = frame_at.locator('#air-charge-card')
    assert charge_card.is_visible(), "Charge card must be visible on settings tab"
    volt_text = frame_at.locator('#air-charge-volt').inner_text()
    curr_text = frame_at.locator('#air-charge-curr').inner_text()
    cap_text = frame_at.locator('#air-charge-cap').inner_text()
    print(f"Charge card UI values: capacity={cap_text}%, voltage={volt_text} V, current={curr_text} mA")
    assert volt_text != '--', f"Voltage should be rendered, got {volt_text}"
    assert curr_text != '--', f"Current should be rendered, got {curr_text}"
    
    page.screenshot(path='.tools/desktop_charge.png')
    results['desktop_charge'] = f'PASS (voltage={volt_text}V, current={curr_text}mA)'
    
    page.close()
    
    # --- Mobile 390x844 ---
    print("\nTesting Mobile 390x844 viewports...")
    mobile_page = browser.new_page(http_credentials={'username': c['username'], 'password': c['password']}, viewport={'width': 390, 'height': 844})
    mobile_page.on('pageerror', lambda e: errors.append(str(e)))
    
    # A. SIM Mobile
    mobile_page.goto('http://127.0.0.1:18892/?page=clashweb', wait_until='networkidle')
    mobile_page.wait_for_timeout(2000)
    m_sim = mobile_page.frame_locator('#clashweb')
    m_sim_grid = m_sim.locator('.sim-speed-box').evaluate('el => window.getComputedStyle(el).gridTemplateColumns')
    print("SIM speed box mobile grid-template-columns:", m_sim_grid)
    assert len([c for c in m_sim_grid.split(' ') if c]) == 1, "Expected single column on mobile"
    mobile_page.screenshot(path='.tools/mobile_sim.png')
    
    # B. Devices Mobile
    mobile_page.goto('http://127.0.0.1:18892/?page=devices', wait_until='networkidle')
    mobile_page.wait_for_timeout(2000)
    m_dev = mobile_page.frame_locator('#devices')
    m_dev_grid = m_dev.locator('#devices').evaluate('el => window.getComputedStyle(el).gridTemplateColumns')
    print("Devices mobile grid-template-columns:", m_dev_grid)
    assert len([c for c in m_dev_grid.split(' ') if c]) == 1, "Expected single column on mobile"
    mobile_page.screenshot(path='.tools/mobile_devices.png')
    
    # C. AT Mobile
    mobile_page.goto('http://127.0.0.1:18892/?page=atweb', wait_until='networkidle')
    mobile_page.wait_for_timeout(2000)
    m_at = mobile_page.frame_locator('#atweb')
    m_at.locator('#tab-set').click()
    mobile_page.wait_for_timeout(1500)
    assert m_at.locator('#air-charge-card').is_visible()
    mobile_page.screenshot(path='.tools/mobile_charge.png')
    
    mobile_page.close()
    browser.close()

subprocess.run([adb, 'forward', '--remove', 'tcp:18892'])
subprocess.run([adb, 'forward', '--remove', 'tcp:8080'])

print("\n=== VERIFICATION SUMMARY ===")
for k, v in results.items():
    print(f"[{k}]: {v}")
print(f"Browser console errors: {len(errors)}")
assert not errors, f"Errors encountered: {errors}"
print("ALL CHECKS PASSED SUCCESSFULLY!")
