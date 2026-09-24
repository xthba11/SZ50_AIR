from pathlib import Path
import threading, http.server
from playwright.sync_api import sync_playwright
from datetime import datetime, timezone, timedelta

root = Path(__file__).resolve().parents[1]

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=str(root / 'ui'), **kwargs)
    def log_message(self, *args):
        pass

server = http.server.ThreadingHTTPServer(('127.0.0.1', 0), Handler)
threading.Thread(target=server.serve_forever, daemon=True).start()

now = datetime.now(timezone.utc)
speed_samples = [
    {
        'at': (now - timedelta(seconds=(29 - i) * 2)).isoformat(),
        'total_down_bps': (i + 1) * 200000,
        'total_up_bps': (i + 1) * 50000,
        'proxy_down_bps': (i + 1) * 120000,
        'proxy_up_bps': (i + 1) * 30000,
        'direct_down_bps': (i + 1) * 80000,
        'direct_up_bps': (i + 1) * 20000,
    }
    for i in range(30)
]

vnstat_days = [
    {
        'date': '2026-09-19',
        'rx_bytes': 14018180786,
        'tx_bytes': 2188119912,
        'total_bytes': 16206300698,
    },
    {
        'date': '2026-09-20',
        'rx_bytes': 12256347726,
        'tx_bytes': 5002727291,
        'total_bytes': 17259075017,
    },
]

try:
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page(viewport={'width': 1200, 'height': 800})
        errors = []
        page.on('pageerror', lambda e: errors.append(str(e)))

        # Mock APIs
        def cgi_mock(route):
            url = route.request.url
            if 'action=get_stats' in url:
                route.fulfill(json={
                    'today_result': '下载 11.41 GiB，上传 4.66 GiB，总量 16.07 GiB',
                    'month_result': '下载 24.47 GiB，上传 6.70 GiB，总量 31.17 GiB',
                    'flight_status': '飞行模式已禁用',
                    'limit_enabled': '1',
                    'current_limit': '50',
                    'vnstatd_status': '运行中',
                    'service_status': '运行中',
                })
            elif 'action=get_wifi' in url:
                route.fulfill(json={'sim_status': 'SIM1'})
            elif 'action=get_network_mode' in url:
                route.fulfill(json={'network_mode': '5G/4G 自动模式', 'mode_code': 'auto', 'mode_desc': '自动驻留最优网络'})
            else:
                route.fulfill(json={'ok': True, 'message': '成功'})

        def air_api_mock(route):
            url = route.request.url
            if 'network/speed' in url:
                route.fulfill(json={'ok': True, 'proxy_enabled': True, 'samples': speed_samples})
            elif 'traffic/daily' in url:
                route.fulfill(json={'ok': True, 'days': vnstat_days})
            elif 'proxy' in url:
                route.fulfill(json={
                    'enabled': True,
                    'running': True,
                    'routing_mode': 'bypass_cn',
                    'active_node_id': 'node-1',
                    'node_name': '香港优质专线 01',
                    'protocol': 'vless',
                    'server': 'hk01.example.com',
                    'port': 443,
                    'latency_ms': 42,
                    'memory_rss_kb': 32400,
                    'nodes': [
                        {'id': 'node-1', 'name': '香港优质专线 01', 'protocol': 'vless', 'server': 'hk01.example.com', 'port': 443, 'latency_ms': 42},
                        {'id': 'node-2', 'name': '日本高速 02', 'protocol': 'trojan', 'server': 'jp02.example.com', 'port': 443, 'latency_ms': 68},
                    ]
                })
            else:
                route.fulfill(json={'ok': True})

        page.route('**/cgi-bin/**', cgi_mock)
        page.route('**/air-api/**', air_api_mock)

        # 1. Test liuliang.html (流量管理)
        print('--- Testing 流量管理 (liuliang.html) ---')
        page.goto(f'http://127.0.0.1:{server.server_port}/inner-pages/liuliang.html')
        page.wait_for_selector('#today-result', state='attached')
        page.wait_for_selector('#daily-traffic-chart svg')
        
        today_text = page.locator('#today-result').inner_text()
        month_text = page.locator('#month-result').inner_text()
        print('Today traffic text:', today_text)
        print('Month traffic text:', month_text)
        assert '11.41 GiB' in today_text
        assert '24.47 GiB' in month_text

        # Verify 30-day chart rendered
        assert page.locator('#daily-traffic-chart svg').count() == 1
        assert page.locator('#daily-traffic-chart rect').count() >= 2
        print('Daily chart SVG rendered successfully with bars!')

        # Verify switches
        switch_limit = page.locator('#switch-limit')
        switch_flight = page.locator('#switch-flight')
        switch_vnstatd = page.locator('#switch-vnstatd')
        assert switch_limit.is_checked()
        assert not switch_flight.is_checked()
        assert switch_vnstatd.is_checked()
        print('System setting switches verified: limit=ON, flight=OFF, vnstatd=ON')

        # Verify traffic limit setting is inside
        assert page.locator('#limit-value').input_value() == '50'
        page.screenshot(path=str(root / '.tools/liuliang-new.png'), full_page=True)

        # 2. Test sim.html (网络与 SIM)
        print('--- Testing 网络与 SIM (sim.html) ---')
        page.goto(f'http://127.0.0.1:{server.server_port}/inner-pages/sim.html')
        page.wait_for_selector('#sim-speed-chart svg')
        page.wait_for_selector('.speed-line-direct')
        page.wait_for_selector('.speed-line-proxy')
        page.wait_for_selector('.speed-line-direct-up')
        page.wait_for_selector('.speed-line-proxy-up')

        assert page.locator('.speed-line-direct').count() == 1
        assert page.locator('.speed-line-proxy').count() == 1
        assert page.locator('.speed-line-direct-up').count() == 1
        assert page.locator('.speed-line-proxy-up').count() == 1
        assert page.locator('.speed-dot-direct').count() == 1
        assert page.locator('.speed-dot-proxy').count() == 1

        total_rate = page.locator('#sim-speed-total').inner_text()
        direct_rate = page.locator('#rate-direct-text').inner_text()
        proxy_rate = page.locator('#rate-proxy-text').inner_text()
        print('Total rate:', total_rate)
        print('Direct rate (Blue):', direct_rate)
        print('Proxy rate (Purple):', proxy_rate)
        assert 'MB/s' in total_rate
        assert 'MB/s' in direct_rate
        assert 'MB/s' in proxy_rate
        page.screenshot(path=str(root / '.tools/sim-speed-chart.png'), full_page=True)
        print('Network speed two-row dual-line chart verified!')

        # 3. Test proxy.html (代理设置)
        print('--- Testing 代理设置 (proxy.html) ---')
        page.goto(f'http://127.0.0.1:{server.server_port}/inner-pages/proxy.html')
        page.wait_for_selector('#metric-mode')
        page.wait_for_selector('.node-item')

        mode_text = page.locator('#metric-mode').inner_text()
        print('Proxy routing mode:', mode_text)
        assert '智能分流' in mode_text

        # Verify node list
        node_items = page.locator('.node-item')
        assert node_items.count() == 2
        assert '香港优质专线 01' in node_items.nth(0).inner_text()
        assert '日本高速 02' in node_items.nth(1).inner_text()

        # Verify rename and delete buttons exist with proper data-id
        rename_btn = node_items.nth(0).locator('.btn-rename')
        del_btn = node_items.nth(0).locator('.btn-del')
        select_btn = node_items.nth(1).locator('.btn-select')
        assert rename_btn.count() == 1
        assert rename_btn.get_attribute('data-id') == 'node-1'
        assert del_btn.get_attribute('data-id') == 'node-1'
        assert select_btn.get_attribute('data-id') == 'node-2'

        # Test selecting node 2
        select_btn.click()
        print('Clicked select button successfully!')

        page.screenshot(path=str(root / '.tools/proxy-new.png'), full_page=True)

        assert not errors, f'Found browser errors: {errors}'
        browser.close()
        print('ALL NEW FEATURES VERIFIED SUCCESSFULLY!')
finally:
    server.shutdown()
