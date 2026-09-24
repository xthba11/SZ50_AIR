# -*- coding: utf-8 -*-
"""验证本轮 5 条修复"""
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
    pg.wait_for_timeout(3000)

    print('===== ① 网络概览标题 vs 状态监测标题 =====')
    r = pg.evaluate("""() => {
      const g = (s) => { const e = document.querySelector(s); if (!e) return null;
        const c = getComputedStyle(e), r = e.getBoundingClientRect();
        return {fs: c.fontSize, fw: c.fontWeight, text: e.textContent.trim().slice(0,12),
                mt: c.marginTop, h: Math.round(r.height), delta: c.letterSpacing}; };
      return {dash: g('#dashboard-section .panel-heading h2'), dashSub: g('#dashboard-section .panel-heading p'),
              mon:  g('#monitor-section .panel-heading h2'), monSub: g('#monitor-section .panel-heading p'),
              old:  document.querySelector('#dashboard-section .page-heading') ? 'page-heading 还在' : '已换成 panel-heading'};
    }""")
    for k, v in r.items():
        print('     %-10s %s' % (k, v))
    check('标题结构与其它页一致', r['old'] == '已换成 panel-heading', r['old'])
    check('标题字号与其它页一致', r['dash'] and r['mon'] and r['dash']['fs'] == r['mon']['fs'],
          '%s vs %s' % (r['dash'] and r['dash']['fs'], r['mon'] and r['mon']['fs']))
    check('标题字重一致', r['dash'] and r['mon'] and r['dash']['fw'] == r['mon']['fw'])

    print()
    print('===== ② 右边两个按钮：文字不再溢出 =====')
    r2 = pg.evaluate("""() => [...document.querySelectorAll('#dashboard-section .connection-actions .btn')].map(e => {
      const c = getComputedStyle(e), r = e.getBoundingClientRect();
      return {text: e.textContent.trim(), w: Math.round(r.width), sw: e.scrollWidth, cw: e.clientWidth,
              ov: e.scrollWidth > e.clientWidth + 1, bg: c.backgroundColor};
    })""")
    for x in r2:
        print('     %-12s 宽=%s 内容宽=%s 溢出=%s' % (x['text'], x['w'], x['sw'], x['ov']))
    check('所有按钮文字不再溢出', all(not x['ov'] for x in r2), '%d 个按钮' % len(r2))
    check('两个按钮都在（没被 display:none）', len(r2) >= 2, '%d 个' % len(r2))

    print()
    print('===== ③ connection-banner 已半透明 =====')
    r3 = pg.evaluate("""() => { const e = document.querySelector('#dashboard-section .connection-banner');
      const c = getComputedStyle(e); return {bg: c.backgroundImage.slice(0, 80), bd: c.borderColor}; }""")
    print('     %s' % r3)
    check('横幅背景改成 rgba 半透明', 'rgba' in r3['bg'], r3['bg'][:60])

    print()
    print('===== ④ 电池设置页卡片已半透明 =====')
    pg.evaluate("()=>{const a=document.querySelector('a[data-section=\"chargeweb\"]');a&&a.click()}")
    pg.wait_for_timeout(5000)
    r4 = pg.evaluate("""() => { const e = document.querySelector('.air-charge-card');
      if (!e) return null; const c = getComputedStyle(e);
      return {bg: c.backgroundImage.slice(0, 90)}; }""")
    print('     %s' % r4)
    check('电池页主卡片改成 rgba 半透明', r4 and 'rgba' in r4['bg'], (r4 or {}).get('bg', '')[:60])

    print()
    print('===== ⑤ 代理 / 非代理分隔线 =====')
    pg.evaluate("()=>{const a=document.querySelector('a[data-section=\"clashweb\"]');a&&a.click()}")
    pg.wait_for_timeout(5000)
    r5 = pg.evaluate("""() => { const e = document.querySelector('.sim-speed-subcard.proxy-chart-subcard');
      if (!e) return null; const c = getComputedStyle(e);
      return {bl: c.borderLeftWidth + ' ' + c.borderLeftStyle + ' ' + c.borderLeftColor}; }""")
    print('     %s' % r5)
    check('两个子卡之间有分隔线', r5 and r5['bl'].startswith('1px'), str(r5))

    print()
    print('===== ⑥ 流量管理两个图表并列 =====')
    pg.evaluate("()=>{const a=document.querySelector('a[data-section=\"tfcweb\"]');a&&a.click()}")
    pg.wait_for_timeout(5000)
    r6 = pg.evaluate("""() => { const s = [...document.querySelectorAll('#tfcweb-section .chart-section')];
      const c = getComputedStyle(document.querySelector('#tfcweb-section .charts-unified-grid'));
      return {display: c.display, cols: c.gridTemplateColumns.slice(0, 40),
              图表: s.map(e => { const r = e.getBoundingClientRect(); return {top: Math.round(r.top), w: Math.round(r.width)}; })}; }""")
    print('     %s' % r6)
    ch = r6['图表']
    check('两个图表并列（同一行、各半宽）', len(ch) == 2 and ch[0]['top'] == ch[1]['top'] and ch[0]['w'] < 700, str(ch))

    print()
    print('JS 报错: %d 条' % len(errs))
    for e in errs[:6]:
        print('   ', e)
    pg.screenshot(path='.tools/r3_overview.png')
    b.close()

print()
print('结论: %s' % ('全部通过' if not fails else '仍失败: ' + ', '.join(fails)))
