
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

    print('===== ① 白底按钮是否都有可见的细勾线 =====')
    for sec, name in [('clashweb','网络与SIM'), ('usbmodeweb','WiFi设置'), ('tfcweb','流量管理'),
                      ('chargeweb','电池设置'), ('clashui','系统设置'), ('dashboard','网络概览')]:
        pg.evaluate("(s)=>{const a=document.querySelector('a[data-section=\"'+s+'\"]');if(a)a.click()}", sec)
        pg.wait_for_timeout(3600)
        r = pg.evaluate("""(s) => {
          const out = [];
          document.querySelectorAll('#' + s + '-section .btn, #' + s + '-section button.btn, #' + s + '-section .air-charge-btn-save, #' + s + '-section .pwd-save').forEach(e => {
            const c = getComputedStyle(e), rr = e.getBoundingClientRect();
            if (rr.width < 12) return;
            if (e.classList.contains('radar-tab-btn')) return;
            out.push((e.textContent||'').trim().slice(0,8) + ': ' + c.borderTopWidth + ' ' + c.borderTopColor + ' | ' + c.backgroundColor);
          });
          return [...new Set(out)];
        }""", sec)
        print('     --- %s' % name)
        for x in r[:6]:
            print('        %s' % x)
    # 汇总：所有白底按钮的边框色
    allb = pg.evaluate("""() => {
      const s = new Set();
      document.querySelectorAll('.btn, button.btn, .air-charge-btn-save, .pwd-save').forEach(e => {
        const c = getComputedStyle(e), rr = e.getBoundingClientRect();
        if (rr.width < 12 || e.classList.contains('radar-tab-btn')) return;
        const bg = c.backgroundColor;
        if (/rgba\\(255,\\s*255,\\s*255/.test(bg)) s.add(c.borderTopWidth + ' ' + c.borderTopColor);
      });
      return [...s];
    }""")
    print('     → 白底按钮的勾线集合: %s' % allb)
    check('白底按钮都有统一的细勾线', allb == ['1px rgba(125, 148, 185, 0.32)'], str(allb))

    print()
    print('===== ② 回归：雷达频段按钮仍无框、主按钮仍为蓝底 =====')
    pg.evaluate("()=>{const a=document.querySelector('a[data-section=\"usbmodeweb\"]');a&&a.click()}")
    pg.wait_for_timeout(4500)
    r2 = pg.evaluate("""() => {
      const tabs = [...document.querySelectorAll('#usbmodeweb-section .radar-tab-btn')].map(e => {
        const c = getComputedStyle(e); return e.textContent.trim() + ' → ' + c.borderTopWidth + ' ' + c.backgroundColor; });
      const primary = [...document.querySelectorAll('#usbmodeweb-section [id^="apply-"]')].map(e => {
        const c = getComputedStyle(e); return e.id + ' → ' + c.backgroundColor + ' / ' + c.borderTopColor; });
      return {频段按钮: tabs, 保存按钮: primary};
    }""")
    for k, v in r2.items():
        print('     %s: %s' % (k, v))
    check('雷达频段按钮仍无边框', all('0px' in x for x in r2['频段按钮']), str(r2['频段按钮']))
    check('保存按钮仍是主色蓝底', all('55, 108, 244' in x for x in r2['保存按钮']), str(r2['保存按钮']))

    print()
    print('JS 报错: %d 条' % len(errs))
    for e in errs[:5]: print('   ', e)
    check('无 JS 报错', not errs)
    b.close()
print()
print('结论: %s' % ('全部通过' if not fails else '仍失败: ' + ', '.join(fails)))
