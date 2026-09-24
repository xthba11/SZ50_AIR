
import subprocess, json
ADB = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'
subprocess.run([ADB,'forward','tcp:18899','tcp:18080'],capture_output=True)
c = json.loads(subprocess.run([ADB,'shell','cat /home/root/admin-auth/credentials.json'],capture_output=True,text=True).stdout)
from playwright.sync_api import sync_playwright
fails = []
def check(l, cond, extra=''):
    print('  %s %s%s' % ('ok ' if cond else '!! ', l, ('   ' + extra) if extra else ''))
    if not cond: fails.append(l)
with sync_playwright() as p:
    b = p.chromium.launch(); ctx = b.new_context(viewport={'width':2560,'height':1300}); pg = ctx.new_page()
    errs = []
    pg.on('pageerror', lambda e: errs.append(str(e)[:140]))
    pg.goto('http://127.0.0.1:18899/', wait_until='load', timeout=45000)
    if '/air-login' in pg.url:
        pg.fill('#username', c['username']); pg.fill('#password', c['password'])
        pg.click('.login-submit'); pg.wait_for_load_state('load', timeout=30000)
    pg.wait_for_timeout(2500)

    print('===== ① 各页滑块底色是否统一 =====')
    allbg = {}
    for sec, name in [('usbmodeweb','WiFi设置'), ('tfcweb','流量管理'), ('chargeweb','电池设置'), ('clashui','系统设置')]:
        pg.evaluate("(s)=>{const a=document.querySelector('a[data-section=\"'+s+'\"]');if(a)a.click()}", sec)
        pg.wait_for_timeout(4000)
        r = pg.evaluate("""(s) => {
          const out = [];
          document.querySelectorAll('#' + s + '-section .toggle-slider, #' + s + '-section .slider, #' + s + '-section .air-charge-slider').forEach(e => {
            const c = getComputedStyle(e);
            out.push(c.backgroundColor);
          });
          return [...new Set(out)];
        }""", sec)
        print('     %-10s %s' % (name, r))
        allbg[name] = r
    flat = set(x for v in allbg.values() for x in v)
    check('滑块底色已统一（只剩一套值）', flat <= {'rgb(203, 213, 225)', 'rgb(55, 108, 244)'}, str(flat))

    print()
    print('===== ② 雷达频段按钮（2.4 / 5 GHz）是否还有边框 =====')
    pg.evaluate("()=>{const a=document.querySelector('a[data-section=\"usbmodeweb\"]');a&&a.click()}")
    pg.wait_for_timeout(5000)
    r2 = pg.evaluate("""() => [...document.querySelectorAll('#usbmodeweb-section .radar-tab-btn')].map(e => {
      const c = getComputedStyle(e);
      return {文本: e.textContent.trim(), 边框: c.borderTopWidth + ' ' + c.borderTopStyle,
              bg: c.backgroundColor, 选中: e.classList.contains('active')}; })""")
    for x in r2:
        print('     %-10s 边框=%-12s bg=%-24s 选中=%s' % (x['文本'], x['边框'], x['bg'], x['选中']))
    check('频段按钮无边框', all(x['边框'].startswith('0px') for x in r2), str([x['边框'] for x in r2]))

    print()
    print('===== ③ WiFi 设置页两张卡片是否都独占一行 =====')
    r3 = pg.evaluate("""() => [...document.querySelectorAll('#usbmodeweb-section .container > *')].map(e => {
      const r = e.getBoundingClientRect();
      return {cls: String(e.className).split(' ').slice(0,2).join('.'), w: Math.round(r.width),
              gc: getComputedStyle(e).gridColumn}; })""")
    for x in r3:
        print('     %-34s 宽=%-6s grid-column=%s' % (x['cls'], x['w'], x['gc']))
    check('Wi-Fi 设置卡已独占一行', bool(r3) and all(x['w'] > 1200 for x in r3), str([x['w'] for x in r3]))

    print()
    print('JS 报错: %d 条' % len(errs))
    for e in errs[:5]: print('   ', e)
    check('无 JS 报错', not errs)
    pg.screenshot(path='.tools/r9_wifi.png', full_page=True)
    b.close()
print()
print('结论: %s' % ('全部通过' if not fails else '仍失败: ' + ', '.join(fails)))
