"""用 Playwright 真实渲染设备页面，验证频谱带宽与省略段效果（截图供人工/视觉复核）。"""
import os, subprocess, json, base64

os.environ['ANDROID_ADB_SERVER_PORT'] = '5038'
ADB = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'
OUT = '.tools'

def adb(*a):
    return subprocess.run([ADB, *a], capture_output=True, text=True).stdout

subprocess.run([ADB, 'forward', '--remove', 'tcp:18881'], capture_output=True)
subprocess.run([ADB, 'forward', 'tcp:18881', 'tcp:18080'], check=True)
creds = json.loads(adb('shell', 'cat /home/root/admin-auth/credentials.json'))

from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch()
    ctx = browser.new_context(
        viewport={'width': 1180, 'height': 1500},
        http_credentials={'username': creds['username'], 'password': creds['password']},
    )
    page = ctx.new_page()
    errs = []
    page.on('console', lambda m: errs.append(m.text) if m.type == 'error' else None)
    page.on('pageerror', lambda e: errs.append('pageerror: %s' % e))

    page.goto('http://127.0.0.1:18881/html/z50_air_wifi.html', wait_until='load', timeout=45000)
    page.wait_for_timeout(4000)

    # 触发一次探测（会真实扫描周边热点）
    try:
        page.click('#btn-scan-radar', timeout=6000)
        print('已点击“探测周围信道”')
    except Exception as e:
        print('点击探测按钮失败:', e)
    page.wait_for_timeout(9000)

    # 2.4G 视图（默认按当前模式自动选择，先切到 2.4G 再截）
    try:
        page.click('#radar-tab-24g', timeout=4000)
        page.wait_for_timeout(1500)
    except Exception as e:
        print('切 2.4G 失败:', e)
    page.locator('#wifi-radar-svg').screenshot(path=OUT + '/radar_24g.png')
    print('已保存 2.4G 频谱图')

    try:
        page.click('#radar-tab-5g', timeout=4000)
        page.wait_for_timeout(1500)
    except Exception as e:
        print('切 5G 失败:', e)
    page.locator('#wifi-radar-svg').screenshot(path=OUT + '/radar_5g.png')
    print('已保存 5G 频谱图')

    page.screenshot(path=OUT + '/radar_full_page.png', full_page=True)
    print('已保存整页截图')

    # 程序化验证：带宽越大，钟形曲线应越宽（读 SVG path 的实际像素跨度）
    pairs = page.evaluate("""() => {
        const nets = (window.radarData && window.radarData.networks) || [];
        const bwOf = {};
        nets.forEach(n => { bwOf['ap_' + (n.bssid || '').replace(/[^a-zA-Z0-9]/g, '')] = n.bandwidth; });
        const out = [];
        document.querySelectorAll('#radar-curves-layer .radar-curve-group').forEach(g => {
            const p = g.querySelector('path');
            if (!p) return;
            const b = p.getBBox();
            out.push({ id: g.getAttribute('data-id'), bw: bwOf[g.getAttribute('data-id')] || null, w: Math.round(b.width) });
        });
        return out;
    }""")
    print('带宽 → 曲线像素跨度 对照（%d 条）:' % len(pairs))
    for r in pairs[:16]:
        print('   bw=%-6s width=%spx' % (r['bw'] if r['bw'] is not None else '自带', r['w']))

    # 抓取页面上的 AP 列表文本（确认带宽徽标渲染）
    try:
        rows = page.locator('.radar-ap-item .radar-ap-col-ch').all_inner_texts()
        print('AP 列表前 10 行（信道 + 带宽）:', [r.replace('\n', ' ') for r in rows[:10]])
    except Exception as e:
        print('读取 AP 列表失败:', e)

    print('页面 JS 错误:', errs[:6] if errs else '无')
    browser.close()
