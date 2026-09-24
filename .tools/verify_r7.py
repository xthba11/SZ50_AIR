# -*- coding: utf-8 -*-
"""验证：按钮/滑块统一、电池页四行对齐、WiFi 名称条透明，并统计全站圆角种类"""
import subprocess, json, collections

ADB = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'
subprocess.run([ADB, 'forward', 'tcp:18899', 'tcp:18080'], capture_output=True)
creds = json.loads(subprocess.run([ADB, 'shell', 'cat /home/root/admin-auth/credentials.json'],
                                  capture_output=True, text=True).stdout)
U, P = creds['username'], creds['password']
fails = []

def check(label, cond, extra=''):
    print('  %s %s%s' % ('ok ' if cond else '!! ', label, ('   ' + extra) if extra else ''))
    if not cond:
        fails.append(label)

from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    b = p.chromium.launch()
    ctx = b.new_context(viewport={'width': 2560, 'height': 1300})
    pg = ctx.new_page()
    errs = []
    pg.on('pageerror', lambda e: errs.append(str(e)[:140]))
    pg.goto('http://127.0.0.1:18899/', wait_until='load', timeout=45000)
    if '/air-login' in pg.url:
        pg.fill('#username', U); pg.fill('#password', P)
        pg.click('.login-submit'); pg.wait_for_load_state('load', timeout=30000)
    pg.wait_for_timeout(2500)

    print('===== ① 全站按钮圆角 / 底色统一情况（逐页统计） =====')
    allr = collections.Counter()
    for sec in ['dashboard', 'monitor', 'devices', 'clashweb', 'usbmodeweb', 'tfcweb', 'chargeweb', 'clashui']:
        pg.evaluate("(s)=>{const a=document.querySelector('a[data-section=\"'+s+'\"]');if(a)a.click()}", sec)
        pg.wait_for_timeout(3200)
        r = pg.evaluate("""(s) => {
          const c = {};
          document.querySelectorAll('#' + s + '-section .btn, #' + s + '-section button.btn, #' + s + '-section .air-charge-btn-save, #' + s + '-section .pwd-save, #' + s + '-section .radar-scan-btn, #' + s + '-section .btn-auto-switch, #' + s + '-section .dialog-btn').forEach(e => {
            if (e.getBoundingClientRect().width < 10) return;
            const cs = getComputedStyle(e);
            c[cs.borderRadius] = (c[cs.borderRadius] || 0) + 1;
          });
          const sl = [...document.querySelectorAll('#' + s + '-section .toggle-switch, #' + s + '-section .slider, #' + s + '-section .toggle-slider')]
                     .filter(e => e.getBoundingClientRect().width > 8)
                     .map(e => getComputedStyle(e).borderRadius);
          return {btn: c, slider: [...new Set(sl)]};
        }""", sec)
        for k, v in r['btn'].items():
            allr[k] += v
        print('     %-12s 按钮圆角 %s   滑块圆角 %s' % (sec, dict(r['btn']), r['slider']))
    print('     → 全站合计：%s' % dict(allr))
    check('按钮圆角已统一为一种', len(allr) == 1, str(dict(allr)))
    check('圆角值与卡片一致(16px)', list(allr.keys()) == ['16px'], str(list(allr.keys())))

    print()
    print('===== ② 电池页四行对齐 =====')
    pg.evaluate("()=>{const a=document.querySelector('a[data-section=\"chargeweb\"]');a&&a.click()}")
    pg.wait_for_timeout(5000)
    d = pg.evaluate("""() => {
      return [...document.querySelectorAll('.air-charge-card .air-charge-field-row')].map(r => {
        const rr = r.getBoundingClientRect(); const info = r.querySelector('.air-charge-field-info');
        const ir = info ? info.getBoundingClientRect() : null;
        return {标题: (info||{}).textContent ? info.textContent.trim().slice(0,12) : '?',
                row左: Math.round(rr.left), row宽: Math.round(rr.width),
                pad: getComputedStyle(r).padding,
                info左: ir ? Math.round(ir.left) : null, info宽: ir ? Math.round(ir.width) : null,
                row高: Math.round(rr.height)};
      });
    }""")
    for x in d:
        print('     %-14s pad=%-14s info左=%-5s info宽=%-5s 行高=%s' % (x['标题'], x['pad'], x['info左'], x['info宽'], x['row高']))
    lefts = {x['info左'] for x in d}
    pads = {x['pad'] for x in d}
    check('四行内边距一致', len(pads) == 1, str(pads))
    check('四行文字/控件左边距一致', len(lefts) == 1, str(lefts))

    print()
    print('===== ③ WiFi 名称条（网络概览）是否半透明 =====')
    pg.evaluate("()=>{const a=document.querySelector('a[data-section=\"dashboard\"]');a&&a.click()}")
    pg.wait_for_timeout(3500)
    w = pg.evaluate("""() => { const e = document.querySelector('.wifi-identity');
      return e ? {bg: getComputedStyle(e).backgroundColor, bd: getComputedStyle(e).borderColor} : null; }""")
    print('     %s' % w)
    check('WiFi 名称条已半透明', w and 'rgba' in w['bg'] and not w['bg'].endswith(', 1)'), str(w))

    print()
    print('===== ④ 网络概览两张卡片底色是否一致 =====')
    c2 = pg.evaluate("""() => {
      return [...document.querySelectorAll('#dashboard-section .info-card')].map(e => {
        const t = (e.querySelector('.card-title')||{}).textContent || '';
        const cs = getComputedStyle(e);
        return t.trim().slice(0,10) + ' → ' + (cs.backgroundImage !== 'none' ? cs.backgroundImage.slice(0,52) : cs.backgroundColor);
      });
    }""")
    for x in c2:
        print('     %s' % x)

    print()
    print('JS 报错: %d 条' % len(errs))
    for e in errs[:6]:
        print('   ', e)
    check('无 JS 报错', not errs)
    pg.screenshot(path='.tools/r7_unified.png')
    b.close()

print()
print('结论: %s' % ('全部通过' if not fails else '仍需处理: ' + ', '.join(fails)))
