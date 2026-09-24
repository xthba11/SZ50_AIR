from playwright.sync_api import sync_playwright
import http.server, threading
from pathlib import Path

root = Path(__file__).resolve().parents[1]

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *a, **kw): super().__init__(*a, directory=str(root/'ui'), **kw)
    def log_message(self, *a): pass
    def translate_path(self, path):
        mapping = {
            '/at-test': '/inner-pages/at-index.html',
            '/speedtest.html': '/inner-pages/speedtest.html',
            '/js/app.e4a615bb.js': '/at-app.js',
            '/js/chunk-vendors.907bf020.js': '/at-vendors.js',
            '/css/app.54fd2b3f.css': '/at-app.css',
            '/css/chunk-vendors.2c686ef2.css': '/at-vendors.css'
        }
        p = path.split('?', 1)[0]
        return super().translate_path(mapping.get(p, p.replace('/html/', '/inner-pages/', 1)))

server = http.server.ThreadingHTTPServer(('127.0.0.1', 0), Handler)
threading.Thread(target=server.serve_forever, daemon=True).start()

try:
    with sync_playwright() as p:
        b = p.chromium.launch(headless=True)
        page = b.new_page(viewport={'width': 390, 'height': 844})
        errors = []
        page.on('pageerror', lambda e: errors.append(str(e)))
        page.route('**/api/**', lambda r: r.fulfill(json={'Code': 0, 'Data': {}}))
        page.route('**/air-api/**', lambda r: r.fulfill(json={'state': 'idle', 'bytes': 0}))
        
        page.goto(f'http://127.0.0.1:{server.server_port}/at-test')
        page.get_by_role('tab', name='锁频').wait_for()
        
        # Verify animation on tab change
        anim = page.locator('#pane-band').evaluate('el => window.getComputedStyle(el).animationName')
        print('pane-band animationName:', anim)
        assert 'atPaneEnter' in anim, f'Expected atPaneEnter, got {anim}'
        
        page.get_by_role('tab', name='锁基站').click()
        anim_st = page.locator('#pane-bandStation').evaluate('el => window.getComputedStyle(el).animationName')
        print('pane-bandStation animationName:', anim_st)
        assert 'atPaneEnter' in anim_st
        
        # Test 调试 & 测速
        page.get_by_role('tab', name='调试').click()
        page.get_by_role('button', name='测速').click()
        
        frame = page.frame_locator('iframe[src*="speedtest"]')
        frame.locator('#speed-start').wait_for(timeout=8000)
        page.wait_for_timeout(600)
        
        iframe = page.locator('iframe[src*="speedtest"]')
        frame_h = iframe.evaluate('el => el.getBoundingClientRect().height')
        inner_h = frame.locator('body').evaluate('el => el.getBoundingClientRect().height')
        has_scrollbar = frame.locator('html').evaluate('el => el.scrollHeight > el.clientHeight || el.scrollWidth > el.clientWidth')
        
        print(f'Iframe height: {frame_h}px, Inner body height: {inner_h}px, Has scrollbar: {has_scrollbar}')
        assert not has_scrollbar, 'Inner frame has scrollbar!'
        assert frame_h >= inner_h - 2, f'Frame height {frame_h} does not fit inner {inner_h}'
        
        page.screenshot(path=str(root/'.tools/at-transition-speedtest.png'), full_page=True)
        assert not errors, errors
        b.close()
        print('VERIFICATION SUCCESSFUL!')
finally:
    server.shutdown()
