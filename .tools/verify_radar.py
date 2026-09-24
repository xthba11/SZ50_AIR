# -*- coding: utf-8 -*-
"""验证：频谱图/雷达区恢复正常（内部元素不再被拉满）+ 折线图空白消失 + 流量管理图表恢复并列"""
import subprocess, json

ADB = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'
subprocess.run([ADB, 'forward', 'tcp:18899', 'tcp:18080'], capture_output=True)
creds = json.loads(subprocess.run([ADB, 'shell', 'cat /home/root/admin-auth/credentials.json'],
                                  capture_output=True, text=True).stdout)
U, P = creds['username'], creds['password']
BASE = 'http://127.0.0.1:18899'
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
    pg.goto(BASE + '/', wait_until='load', timeout=45000)
    if '/air-login' in pg.url:
        pg.fill('#username', U); pg.fill('#password', P)
        pg.click('.login-submit'); pg.wait_for_load_state('load', timeout=30000)
    pg.wait_for_timeout(2500)

    print('============ WiFi 页：雷达区内部元素宽度（之前被通配符拉成整行） ============')
    pg.evaluate("()=>{const a=document.querySelector('a[data-section=\"usbmodeweb\"]');a&&a.click()}")
    pg.wait_for_timeout(6000)
    d = pg.evaluate("""() => {
      const q = (s) => { const e = document.querySelector(s); if (!e) return null;
        const r = e.getBoundingClientRect(); const cs = getComputedStyle(e);
        return {w: Math.round(r.width), h: Math.round(r.height), display: cs.display}; };
      const cont = document.querySelector('#usbmodeweb-section .container');
      const card = document.querySelector('.wifi-radar-card');
      return {
        container: cont ? Math.round(cont.getBoundingClientRect().width) : null,
        card: card ? Math.round(card.getBoundingClientRect().width) : null,
        tabBtn: q('.radar-tab-btn'), scanBtn: q('.radar-scan-btn'),
        tabs: q('.radar-band-tabs'), header: q('.radar-header'),
        apItem: q('.radar-ap-item'), apTag: q('.radar-ap-crypto-tag'),
        apList: q('.radar-ap-list'), chart: q('.radar-chart-container'),
        svg: q('.radar-chart-container svg'),
        cardW: card ? Math.round(card.getBoundingClientRect().width) : 0
      };
    }""")
    for k, v in d.items():
        print('     %-12s %s' % (k, v))
    tb = d.get('tabBtn') or {}
    check('频段切换按钮宽度正常（不再拉满整行）', tb.get('w', 9999) < d.get('cardW', 0) * 0.5,
          '%spx（卡片 %spx）' % (tb.get('w'), d.get('cardW')))
    check('探测按钮宽度正常', (d.get('scanBtn') or {}).get('w', 9999) < d.get('cardW', 0) * 0.5,
          str((d.get('scanBtn') or {}).get('w')) + 'px')
    if d.get('apTag'):
        check('周边明细行宽度正常（不再一行占满）', d['apTag']['w'] < d.get('cardW', 0) * 0.95,
              '%spx（卡片 %spx）' % (d['apTag']['w'], d.get('cardW')))
    check('雷达卡仍独占一行', (d.get('card') or 0) > 1000, '%spx' % d.get('card'))
    pg.screenshot(path='.tools/r3_wifi.png', full_page=True)

    print()
    print('============ 网络与SIM：折线图容器高度（之前被强撑到 190 → 曲线下方一大片空白） ============')
    pg.evaluate("()=>{const a=document.querySelector('a[data-section=\"clashweb\"]');a&&a.click()}")
    pg.wait_for_timeout(5000)
    s = pg.evaluate("""() => {
      const out = {};
      ['proxy-chart-container','direct-chart-container'].forEach(id => {
        const c = document.getElementById(id); if (!c) return;
        const svg = c.querySelector('svg');
        out[id] = {容器高: Math.round(c.getBoundingClientRect().height),
                   曲线svg高: svg ? Math.round(svg.getBoundingClientRect().height) : 0,
                   svg数: c.querySelectorAll('svg').length};
      });
      const box = document.querySelector('#clashweb-section .stats-box.sim-speed-box');
      out['网速卡'] = box ? Math.round(box.getBoundingClientRect().width) + 'x' + Math.round(box.getBoundingClientRect().height) : null;
      const cont = document.querySelector('#clashweb-section .container');
      out['容器宽'] = cont ? Math.round(cont.getBoundingClientRect().width) : null;
      return out;
    }""")
    for k, v in s.items():
        print('     %-22s %s' % (k, v))
    for cid in ['proxy-chart-container', 'direct-chart-container']:
        c = s.get(cid, {})
        gap = c.get('容器高', 0) - c.get('曲线svg高', 0)
        check('%s 曲线下方空白已收窄' % cid, gap <= 8, '容器 %s / 曲线 %s → 空白 %s px' %
              (c.get('容器高'), c.get('曲线svg高'), gap))
    pg.screenshot(path='.tools/r3_sim.png', full_page=True)

    print()
    print('============ 流量管理：两个图表是否恢复并列（同一行） ============')
    pg.evaluate("()=>{const a=document.querySelector('a[data-section=\"tfcweb\"]');a&&a.click()}")
    pg.wait_for_timeout(5000)
    t = pg.evaluate("""() => {
      const secs = [...document.querySelectorAll('#tfcweb-section .chart-section')];
      const cont = document.querySelector('#tfcweb-section .container');
      return {容器宽: cont ? Math.round(cont.getBoundingClientRect().width) : null,
              cols: getComputedStyle(cont).gridTemplateColumns,
              图表: secs.map(e => { const r = e.getBoundingClientRect();
                        return {top: Math.round(r.top), w: Math.round(r.width)}; })};
    }""")
    print('     %s' % t)
    ch = t.get('图表', [])
    check('两个图表恢复并列（同一行、半宽）', len(ch) == 2 and ch[0]['top'] == ch[1]['top'] and ch[0]['w'] < 700,
          str(ch))
    pg.screenshot(path='.tools/r3_liuliang.png', full_page=True)

    print()
    print('JS 报错: %d 条' % len(errs))
    for e in errs[:6]:
        print('   ', e)
    b.close()

print()
print('结论: %s' % ('全部通过' if not fails else '仍失败: ' + ', '.join(fails)))
