from playwright.sync_api import sync_playwright
import http.server, threading
from pathlib import Path

root = Path(__file__).resolve().parents[1]

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *a, **kw): super().__init__(*a, directory=str(root/'ui'), **kw)
    def log_message(self, *a): pass
    def translate_path(self, path):
        mapping = {
            '/html/proxy.html': '/inner-pages/proxy.html',
            '/html/devices.html': '/inner-pages/devices.html',
            '/html/monitor.html': '/inner-pages/monitor.html',
        }
        p = path.split('?', 1)[0]
        return super().translate_path(mapping.get(p, p.replace('/html/', '/inner-pages/', 1)))

server = http.server.ThreadingHTTPServer(('127.0.0.1', 0), Handler)
threading.Thread(target=server.serve_forever, daemon=True).start()

try:
    with sync_playwright() as p:
        b = p.chromium.launch(headless=True)
        page = b.new_page(viewport={'width': 1200, 'height': 800})
        errors = []
        page.on('pageerror', lambda e: errors.append(str(e)))
        page.on('console', lambda msg: print('[CONSOLE]', msg.text))
        page.on('response', lambda res: print('[RESP]', res.status, res.url) if res.status >= 400 or 'proxy' in res.url else None)
        
        # First mock generic /air-api/** and /api/**
        page.route('**/api/**', lambda r: r.fulfill(json={'Code': 0, 'Data': {}}))
        page.route('**/air-api/**', lambda r: r.fulfill(json={'state': 'idle', 'bytes': 0}))

        # Mock /air-api/proxy with specific handler
        mock_status = {
            "enabled": True,
            "running": True,
            "node_name": "香港专线 01 (CN2/BGP)",
            "protocol": "vless",
            "server": "hk.node.example.com",
            "port": 443,
            "node_link": "vless://test-uuid@hk.node.example.com:443?security=tls&sni=hk.node.example.com#香港专线 01 (CN2/BGP)",
            "memory_rss_kb": 34840,
            "latency_ms": 58,
            "last_error": ""
        }
        page.route('**/air-api/proxy', lambda r: r.fulfill(json=mock_status))
        page.route('**/air-api/proxy/**', lambda r: r.fulfill(json={'ok': True}))

        url = f'http://127.0.0.1:{server.server_port}/index.html'
        page.goto(url)
        page.wait_for_selector('[data-section="proxyweb"]', timeout=8000)
        
        # Click Proxy Settings nav link
        page.click('[data-section="proxyweb"]')
        page.wait_for_selector('#proxyweb-section:not([hidden])', timeout=8000)
        
        frame = page.frame_locator('#proxyweb')
        frame.locator('#proxy-status-text.status-on').wait_for(timeout=8000)
        
        # Verify rendered data in iframe
        status_text = frame.locator('#proxy-status-text').inner_text()
        print('Status text:', status_text)
        assert status_text == '运行中'
        
        node_text = frame.locator('#metric-node').inner_text()
        print('Node text:', node_text)
        assert '香港专线 01' in node_text
        
        assert frame.locator('#metric-server').inner_text() == 'hk.node.example.com'
        assert frame.locator('#dt-proto').inner_text() == 'VLESS'
        
        # Mobile viewport check
        page.set_viewport_size({'width': 390, 'height': 844})
        page.wait_for_timeout(300)
        page.screenshot(path=str(root/'.tools/proxy-mobile.png'), full_page=True)
        
        # Desktop viewport screenshot
        page.set_viewport_size({'width': 1200, 'height': 900})
        page.wait_for_timeout(300)
        page.screenshot(path=str(root/'.tools/proxy-desktop.png'), full_page=True)
        
        assert not errors, errors
        b.close()
        print('UI VERIFICATION SUCCESSFUL!')
finally:
    server.shutdown()
