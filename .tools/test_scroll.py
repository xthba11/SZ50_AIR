import subprocess, json
ADB = r'原始工具\SZ50_AIR一键破解\adb.exe'
subprocess.run([ADB, 'forward', 'tcp:18899', 'tcp:18080'])
from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    b = p.chromium.launch()
    ctx = b.new_context(viewport={'width': 390, 'height': 844})
    pg = ctx.new_page()
    pg.goto('http://127.0.0.1:18899/')
    if '/air-login' in pg.url:
        pg.fill('#username', 'admin')
        pg.fill('#password', 'immersing')
        pg.click('.login-submit')
        pg.wait_for_load_state('load')
    pg.wait_for_timeout(2000)
    
    dash_res = pg.evaluate('''() => {
        return {
            bodyScrollW: document.body.scrollWidth,
            htmlScrollW: document.documentElement.scrollWidth,
            clientWidth: document.documentElement.clientWidth,
            tableScroll: (() => {
                const ts = document.querySelector('.table-scroll');
                return ts ? { clientW: ts.clientWidth, scrollW: ts.scrollWidth, rect: ts.getBoundingClientRect() } : null;
            })()
        };
    }''')
    print('Dashboard:', json.dumps(dash_res, indent=2))

    pg.evaluate("""() => {
        const a = document.querySelector('.nav-menu a[data-section="usbmodeweb"]');
        if (a) a.click();
    }""")
    pg.wait_for_timeout(2500)

    wifi_res = pg.evaluate('''() => {
        const apList = document.querySelector('.radar-ap-list');
        const firstItem = document.querySelector('.radar-ap-item');
        const crypto = document.querySelector('.radar-ap-crypto-tag');
        return {
            bodyScrollW: document.body.scrollWidth,
            htmlScrollW: document.documentElement.scrollWidth,
            clientWidth: document.documentElement.clientWidth,
            apList: apList ? { clientW: apList.clientWidth, scrollW: apList.scrollWidth, rect: apList.getBoundingClientRect() } : null,
            firstItem: firstItem ? { clientW: firstItem.clientWidth, scrollW: firstItem.scrollWidth, rect: firstItem.getBoundingClientRect() } : null,
            cryptoRight: crypto ? crypto.getBoundingClientRect().right : null
        };
    }''')
    print('WiFi Radar:', json.dumps(wifi_res, indent=2))
    
    # 诊断其它页面在手机视口下的 scrollWidth
    sections = ['monitor', 'clashweb', 'devices', 'tfcweb', 'proxyweb', 'chargeweb', 'atweb', 'terminalweb', 'atcommand', 'clashui']
    print("\n--- 各模块在手机下的页面宽度检测 ---")
    for sec in sections:
        pg.evaluate(f"""() => {{
            const a = document.querySelector('.nav-menu a[data-section="{sec}"]');
            if (a) a.click();
        }}""")
        pg.wait_for_timeout(1000)
        sw = pg.evaluate("() => document.documentElement.scrollWidth")
        cw = pg.evaluate("() => document.documentElement.clientWidth")
        print(f"[{sec:12s}] clientWidth={cw}, scrollWidth={sw}, hasOverflow={sw > cw}")

    b.close()
