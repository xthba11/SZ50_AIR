# -*- coding: utf-8 -*-
"""本轮验证：① 分界线消失（2K 视口）② 三个原厂页数据/图表不再需要刷新"""
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

PROBE = """() => {
  const g = el => el ? getComputedStyle(el) : null;
  const b = document.body, h = document.documentElement;
  const br = b.getBoundingClientRect();
  const o = {
    vh: innerHeight, htmlBg: g(h).backgroundColor, bodyBg: g(b).backgroundColor,
    bodyH: Math.round(br.height), gap: Math.round(innerHeight - br.bottom)
  };
  const big = [];
  document.querySelectorAll('svg').forEach(el => {
    const r = el.getBoundingClientRect();
    if (el.id === 'air-bg' || (r.width < 60 && r.height < 60)) return;
    big.push(Math.round(r.width) + 'x' + Math.round(r.height) + ' kids=' + el.querySelectorAll('*').length);
  });
  o.bigSvg = big;
  o.charts = [];
  ['proxy-chart-container', 'direct-chart-container'].forEach(id => {
    const el = document.getElementById(id);
    if (el) o.charts.push(id + ' ' + Math.round(el.getBoundingClientRect().width) + 'x' +
                          Math.round(el.getBoundingClientRect().height) + ' 子=' + el.children.length +
                          ' svg=' + el.querySelectorAll('svg').length);
  });
  return o;
}"""

# 各页关键数据元素：「读取中 / -- / 空」= 还是没数据
DATA_PROBE = """(sel) => {
  const out = {};
  sel.forEach(s => {
    const el = document.querySelector(s);
    out[s] = el ? (el.textContent || '').trim().slice(0, 26) : '【元素不存在】';
  });
  return out;
}"""

from playwright.sync_api import sync_playwright

PAGES = [('dashboard', '网络概览'), ('chargeweb', '电池设置'), ('clashui', '系统设置'),
         ('clashweb', '网络与SIM'), ('tfcweb', '流量管理'), ('usbmodeweb', 'WiFi设置')]

with sync_playwright() as p:
    b = p.chromium.launch()
    ctx = b.new_context(viewport={'width': 2560, 'height': 1300})
    pg = ctx.new_page()
    errs = []
    pg.on('pageerror', lambda e: errs.append(str(e)[:150]))
    pg.goto(BASE + '/', wait_until='load', timeout=45000)
    if '/air-login' in pg.url:
        pg.fill('#username', U); pg.fill('#password', P)
        pg.click('.login-submit'); pg.wait_for_load_state('load', timeout=30000)
    pg.wait_for_timeout(2500)

    print('==================== ① 分界线（视口 2560x1300，2K 屏等效） ====================')
    for sec, name in PAGES:
        pg.evaluate("(s)=>{const a=document.querySelector('a[data-section=\"'+s+'\"]');if(a)a.click()}", sec)
        pg.wait_for_timeout(3000)
        d = pg.evaluate(PROBE)
        check('%s 无下方分界线' % name, d['gap'] <= 2,
              'html=%s body=%s body高=%s 视口=%s 露出=%spx' %
              (d['htmlBg'], d['bodyBg'], d['bodyH'], d['vh'], d['gap']))
        if sec == 'clashweb':
            print('     折线容器: %s' % d['charts'])
            print('     可见图表: %s' % d['bigSvg'])

    print()
    print('==================== ② 三个原厂页：切过去就有数据（不刷新） ====================')
    pg.evaluate("()=>{const a=document.querySelector('a[data-section=\"clashweb\"]');a&&a.click()}")
    pg.wait_for_timeout(4500)
    sim = pg.evaluate(DATA_PROBE, ['#current-sim', '#current-network-mode', '#rate-direct-text',
                                   '#direct-down-text', '#sim-speed-total'])
    for k, v in sim.items():
        print('     %-26s → %s' % (k, v))
    check('网络与SIM 当前SIM卡有值', '读取' not in sim.get('#current-sim', '读取中') and sim.get('#current-sim', '') not in ('', '--'))
    check('网络与SIM 折线图已创建', pg.evaluate("()=>{const e=document.getElementById('direct-chart-container');return e?e.querySelectorAll('svg').length:0}") > 0)
    check('网络与SIM 直连速率文本已填', '--' not in sim.get('#direct-down-text', '--') or '0.000' in sim.get('#direct-down-text', ''))

    pg.evaluate("()=>{const a=document.querySelector('a[data-section=\"usbmodeweb\"]');a&&a.click()}")
    pg.wait_for_timeout(4500)
    wifi = pg.evaluate(DATA_PROBE, ['#wifi-ssid', '#current-ssid', '#wifi-password', '#wifi-channel', '.radar-rec-badge'])
    print()
    for k, v in wifi.items():
        print('     %-26s → %s' % (k, v))

    pg.evaluate("()=>{const a=document.querySelector('a[data-section=\"tfcweb\"]');a&&a.click()}")
    pg.wait_for_timeout(4500)
    liu = pg.evaluate(DATA_PROBE, ['#today-result', '#month-result', '#today-total', '#liuliang-today'])
    print()
    for k, v in liu.items():
        print('     %-26s → %s' % (k, v))

    pg.screenshot(path='.tools/after_fix_clashweb.png', full_page=True)
    print()
    print('JS 报错: %d 条' % len(errs))
    for e in errs[:8]:
        print('   ', e)
    b.close()

print()
print('结论: %s' % ('全部通过' if not fails else '仍失败: ' + ', '.join(fails)))
