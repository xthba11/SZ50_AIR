# -*- coding: utf-8 -*-
"""验证：连接设备三字段同行 / 速率与配额半透明 / 电池页行底色与卡片一致 / 折叠区仍对齐"""
import subprocess, json

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

    print('===== ① 连接设备：IPv4 地址 / 在线时长 / 最后在线 是否同一行 =====')
    pg.evaluate("()=>{const a=document.querySelector('a[data-section=\"devices\"]');a&&a.click()}")
    pg.wait_for_timeout(5500)
    d = pg.evaluate("""() => {
      const boxes = [...document.querySelectorAll('#devices-section .device-details')];
      const out = [];
      boxes.forEach(box => {
        const items = [...box.querySelectorAll('.detail-item')];
        if (!items.length) return;
        const rects = items.map(e => { const r = e.getBoundingClientRect();
          return {t: (e.querySelector('span')||{}).textContent, top: Math.round(r.top), left: Math.round(r.left)}; });
        out.push({display: getComputedStyle(box).display, cols: getComputedStyle(box).gridTemplateColumns.slice(0,40),
                  项: rects, 同行: new Set(rects.map(r => r.top)).size === 1});
      });
      return out.slice(0, 3);
    }""")
    for x in d:
        print('     display=%s cols=%s 同行=%s' % (x['display'], x['cols'], x['同行']))
        for it in x['项']:
            print('        %-12s top=%-5s left=%s' % (it['t'], it['top'], it['left']))
    check('三个字段恢复同一行（三列网格）',
          bool(d) and all(x['同行'] and x['display'] == 'grid' for x in d),
          '%d 个设备卡' % len(d))

    print()
    print('===== ② 「速率与配额」模块是否半透明 =====')
    r2 = pg.evaluate("""() => [...document.querySelectorAll('#devices-section .limits-panel')].map(e => {
      const c = getComputedStyle(e); const r = e.getBoundingClientRect();
      return {bg: c.backgroundColor, w: Math.round(r.width), h: Math.round(r.height),
              text: (e.querySelector('strong')||{}).textContent};
    })""")
    for x in r2:
        print('     %s  %s  %sx%s' % (x['text'], x['bg'], x['w'], x['h']))
    check('速率与配额模块已半透明', bool(r2) and all('rgba' in x['bg'] and not x['bg'].endswith(', 1)') for x in r2),
          str([x['bg'] for x in r2]))

    print()
    print('===== ③ 电池页：阈值行 / 统计项 底色 与卡片是否一致 =====')
    pg.evaluate("()=>{const a=document.querySelector('a[data-section=\"chargeweb\"]');a&&a.click()}")
    pg.wait_for_timeout(5000)
    r3 = pg.evaluate("""() => {
      const g = (s) => { const e = document.querySelector(s); if (!e) return null;
        const c = getComputedStyle(e); return c.backgroundImage !== 'none' ? c.backgroundImage : c.backgroundColor; };
      return {卡片: g('.air-charge-card'), 统计项: g('.air-charge-stat-item'),
              阈值行: g('.air-charge-field-row'), 提示条: g('.air-charge-tip')};
    }""")
    for k, v in r3.items():
        print('     %-8s %s' % (k, v))
    vals = [v for v in r3.values() if v]
    check('阈值行/统计项 与卡片同底色', r3['卡片'] and r3['阈值行'] == r3['卡片'] and r3['统计项'] == r3['卡片'],
          '卡片=%s\n                  阈值行=%s' % (r3['卡片'], r3['阈值行']))

    print()
    print('===== ④ 回归：网络概览折叠区仍对齐（上轮修的没被改坏） =====')
    pg.evaluate("()=>{const a=document.querySelector('a[data-section=\"dashboard\"]');a&&a.click()}")
    pg.wait_for_timeout(4000)
    r4 = pg.evaluate("""() => {
      const det = [...document.querySelectorAll('#dashboard-section details.device-details')]
                  .find(e => e.querySelector('summary').textContent.includes('设备标识'));
      if (!det) return null;
      det.open = true;
      const sm = det.querySelector('summary').getBoundingClientRect();
      const tb = det.querySelector('table').getBoundingClientRect();
      return {display: getComputedStyle(det).display, summary左: Math.round(sm.left),
              table左: Math.round(tb.left), summary宽: Math.round(sm.width), table宽: Math.round(tb.width)};
    }""")
    print('     %s' % r4)
    check('折叠区仍是块级 + 左对齐', r4 and r4['display'] == 'block' and abs(r4['summary左'] - r4['table左']) <= 2,
          str(r4))

    print()
    print('JS 报错: %d 条' % len(errs))
    for e in errs[:6]:
        print('   ', e)
    check('无 JS 报错', not errs)
    pg.screenshot(path='.tools/r6_devices.png')
    b.close()

print()
print('结论: %s' % ('全部通过' if not fails else '仍失败: ' + ', '.join(fails)))
