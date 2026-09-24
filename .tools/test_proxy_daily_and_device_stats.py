import http.server
import json
import threading
from datetime import datetime, timezone, timedelta
from pathlib import Path
from playwright.sync_api import sync_playwright

root = Path(__file__).resolve().parents[1]

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=str(root / 'ui'), **kwargs)
    def log_message(self, *args):
        pass

server = http.server.ThreadingHTTPServer(('127.0.0.1', 0), Handler)
threading.Thread(target=server.serve_forever, daemon=True).start()

now = datetime.now(timezone.utc)
stamp = now.isoformat()

# Generate 14 days mock data
days = []
proxy_days = []
for i in range(14, 0, -1):
    d_str = (now - timedelta(days=i)).strftime('%Y-%m-%d')
    days.append({
        'date': d_str,
        'rx_bytes': (15 - i) * 1024 * 1024 * 200,
        'tx_bytes': (15 - i) * 1024 * 1024 * 30,
        'total_bytes': (15 - i) * 1024 * 1024 * 230,
    })
    proxy_days.append({
        'date': d_str,
        'rx_bytes': (15 - i) * 1024 * 1024 * 80,
        'tx_bytes': (15 - i) * 1024 * 1024 * 15,
        'total_bytes': (15 - i) * 1024 * 1024 * 95,
    })

daily_traffic_resp = {
    'ok': True,
    'days': days,
    'proxy_days': proxy_days,
    'proxy_today': {
        'date': now.strftime('%Y-%m-%d'),
        'rx_bytes': 1024 * 1024 * 350,
        'tx_bytes': 1024 * 1024 * 45,
        'total_bytes': 1024 * 1024 * 395,
    },
    'proxy_month': {
        'date': now.strftime('%Y-%m'),
        'rx_bytes': 1024 * 1024 * 1024 * 8 + 1024 * 1024 * 200,
        'tx_bytes': 1024 * 1024 * 1024 * 1 + 1024 * 1024 * 500,
        'total_bytes': 1024 * 1024 * 1024 * 9 + 1024 * 1024 * 700,
    },
}

traffic_cgi_resp = {
    'today_result': '下载: 1.25 GiB | 上传: 120.5 MiB | 总计: 1.37 GiB',
    'month_result': '下载: 18.60 GiB | 上传: 2.10 GiB | 总计: 20.70 GiB',
    'limit_enabled': '1',
    'current_limit': '15',
    'flight_status': '已禁用',
    'vnstatd_status': '运行中',
    'service_status': '运行中',
}

devices_resp = {
    'devices': [
        {
            'mac': '12:c4:6a:d2:17:d6',
            'online': True,
            'connected_seconds': 3661,
            'addresses': ['192.168.0.2'],
            'note': '华为笔记本电脑',
            'last_seen': stamp,
        },
        {
            'mac': '22:85:6b:95:c1:be',
            'online': True,
            'connected_seconds': 1420,
            'addresses': ['192.168.0.3'],
            'note': 'iPhone 15 Pro',
            'last_seen': stamp,
        },
    ],
    'sampled_at': stamp,
    'error': '',
}

clients_resp = {
    'clients': [
        {
            'mac': '12:c4:6a:d2:17:d6',
            'ip': '192.168.0.2',
            'down_bytes': 1024 * 1024 * 5200,
            'up_bytes': 1024 * 1024 * 480,
            'proxy_down_bytes': 1024 * 1024 * 1850,
            'proxy_up_bytes': 1024 * 1024 * 190,
            'limit_down_kbps': 0,
            'limit_up_kbps': 0,
            'quota_mb': 0,
            'blocked': False,
            'proxy_enabled': True,
            'samples': [],
        },
        {
            'mac': '22:85:6b:95:c1:be',
            'ip': '192.168.0.3',
            'down_bytes': 1024 * 1024 * 2400,
            'up_bytes': 1024 * 1024 * 150,
            'proxy_down_bytes': 1024 * 1024 * 980,
            'proxy_up_bytes': 1024 * 1024 * 65,
            'limit_down_kbps': 0,
            'limit_up_kbps': 0,
            'quota_mb': 0,
            'blocked': False,
            'proxy_enabled': False,
            'samples': [],
        },
    ],
    'sampled_at': stamp,
    'error': '',
}

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)

    # 1. Verify liuliang.html (Traffic Management)
    page = browser.new_page(viewport={'width': 1280, 'height': 1200})
    page_errors = []
    page.on('pageerror', lambda e: page_errors.append(str(e)))

    def handle_traffic_routes(route):
        url = route.request.url
        if '/air-api/traffic/daily' in url:
            route.fulfill(json=daily_traffic_resp)
        elif '/cgi-bin/traffic.cgi' in url:
            route.fulfill(json=traffic_cgi_resp)
        else:
            route.continue_()

    page.route('**/*', handle_traffic_routes)
    page.goto(f'http://127.0.0.1:{server.server_port}/inner-pages/liuliang.html')
    page.wait_for_timeout(1500)

    # Assert cellular chart and proxy chart are rendered
    assert page.locator('#daily-traffic-chart svg').count() == 1, 'Cellular chart SVG missing'
    assert page.locator('#daily-proxy-chart svg').count() == 1, 'Proxy chart SVG missing'
    assert page.locator('#daily-proxy-chart rect[fill="#8b5cf6"]').count() > 0, 'Proxy download bars missing'
    assert page.locator('#daily-proxy-chart rect[fill="#f59e0b"]').count() > 0, 'Proxy upload bars missing'

    # Assert proxy stats text
    today_text = page.locator('#today-proxy-result').inner_text()
    month_text = page.locator('#month-proxy-result').inner_text()
    assert '下载:' in today_text and '总计:' in today_text, f'Unexpected today proxy text: {today_text}'
    assert '下载:' in month_text and '总计:' in month_text, f'Unexpected month proxy text: {month_text}'

    page.screenshot(path=str(root / '.tools/liuliang-proxy-chart-desktop.png'), full_page=True)

    # Mobile test for liuliang
    page.set_viewport_size({'width': 390, 'height': 844})
    page.wait_for_timeout(500)
    page.screenshot(path=str(root / '.tools/liuliang-proxy-chart-mobile.png'), full_page=True)

    # 2. Verify devices.html (Per-device proxy traffic stats)
    page2 = browser.new_page(viewport={'width': 1280, 'height': 1000})
    page2.on('pageerror', lambda e: page_errors.append(str(e)))

    def handle_device_routes(route):
        url = route.request.url
        if '/air-api/devices' in url:
            route.fulfill(json=devices_resp)
        elif '/air-api/traffic' in url:
            route.fulfill(json=clients_resp)
        elif '/air-api/proxy' in url:
            route.fulfill(json={'enabled': True, 'running': True, 'state': {'enabled': True}})
        else:
            route.continue_()

    page2.route('**/*', handle_device_routes)
    page2.goto(f'http://127.0.0.1:{server.server_port}/inner-pages/devices.html')
    page2.wait_for_timeout(1500)

    # Check compact traffic panel of device cards
    cards = page2.locator('.device-card')
    assert cards.count() == 2, f'Expected 2 device cards, got {cards.count()}'

    first_traffic = cards.nth(0).locator('.traffic-panel-compact .traffic-col')
    assert first_traffic.count() == 2, f'Expected 2 traffic cols in compact layout, got {first_traffic.count()}'

    card_text = cards.nth(0).locator('.traffic-panel-compact').inner_text().replace('\n', ' ')
    print('First card traffic text:', card_text)

    assert '累计下载' in card_text, 'Missing cumulative download'
    assert '累计上传' in card_text, 'Missing cumulative upload'
    assert '代理:' in card_text or '代理' in card_text, 'Missing proxy traffic stats'
    assert '直连:' in card_text or '直连' in card_text, 'Missing direct traffic stats'

    page2.screenshot(path=str(root / '.tools/devices-proxy-stats-desktop.png'), full_page=True)

    page2.set_viewport_size({'width': 390, 'height': 844})
    page2.wait_for_timeout(500)
    page2.screenshot(path=str(root / '.tools/devices-proxy-stats-mobile.png'), full_page=True)

    assert not page_errors, f'Page errors encountered: {page_errors}'
    print('All Playwright verifications passed!')
    browser.close()
