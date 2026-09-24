# -*- coding: utf-8 -*-
"""验证本轮 4 条：容器宽度对齐 / 网速子卡间距 / 流量条件两列 / 卡片半透明"""
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

    print('===== ① 内容区左右边界：三页是否与其它页对齐 =====')
    ref = None
    for sec, name in [('monitor', '状态监测(参照)'), ('clashui', '系统设置(参照)'),
                      ('clashweb', '网络与SIM'), ('usbmodeweb', 'WiFi设置'), ('tfcweb', '流量管理')]:
        pg.evaluate("(s)=>{const a=document.querySelector('a[data-section=\"'+s+'\"]');if(a)a.click()}", sec)
        pg.wait_for_timeout(2600)
        d = pg.evaluate("""(s) => {
          const sec = document.getElementById(s + '-section');
          const c = sec.querySelector('.container, .content-wrapper, .monitor-shell, .air-system-shell');
          if (!c) return null;
          const r = c.getBoundingClientRect();
          return {left: Math.round(r.left), w: Math.round(r.width)};
        }""", sec)
        if '参照' in name and ref is None:
            ref = d
        same = d and ref and d['left'] == ref['left'] and d['w'] == ref['w']
        print('     %-16s left=%-5s w=%-5s %s' % (name, d['left'], d['w'], '✓ 与参照一致' if same else ''))
        if '参照' not in name:
            check('%s 内容区与其它页对齐' % name, same, 'left=%s w=%s（参照 left=%s w=%s）' % (d['left'], d['w'], ref['left'], ref['w']))

    print()
    print('===== ② 网速卡两个子卡的间距 =====')
    pg.evaluate("()=>{const a=document.querySelector('a[data-section=\"clashweb\"]');a&&a.click()}")
    pg.wait_for_timeout(4200)
    r2 = pg.evaluate("""() => {
      const box = document.querySelector('#clashweb-section .stats-box.sim-speed-box');
      const subs = [...box.querySelectorAll('.sim-speed-subcard')];
      const rects = subs.map(e => { const r = e.getBoundingClientRect();
        return {left: Math.round(r.left), right: Math.round(r.right), w: Math.round(r.width)}; });
      const c = getComputedStyle(box);
      return {卡片宽: Math.round(box.getBoundingClientRect().width), gap: c.columnGap,
              间距: rects.length > 1 ? rects[1].left - rects[0].right : null,
              子卡宽: rects.map(x => x.w), 分隔线: getComputedStyle(subs[1]).borderLeftWidth};
    }""")
    print('     %s' % r2)
    check('两子卡间距已拉开', (r2['间距'] or 0) >= 40, '%spx' % r2['间距'])
    check('分隔线已去掉', r2['分隔线'] in ('0px', '0'), r2['分隔线'])

    print()
    print('===== ③ 流量管理：概览整行 → 条件两列 → 图表两列 =====')
    pg.evaluate("()=>{const a=document.querySelector('a[data-section=\"tfcweb\"]');a&&a.click()}")
    pg.wait_for_timeout(4500)
    r3 = pg.evaluate("""() => {
      const cont = document.querySelector('#tfcweb-section .container');
      const kids = [...cont.children].map(e => {
        const r = e.getBoundingClientRect(), c = getComputedStyle(e);
        return {cls: e.className.split(' ').slice(0,2).join('.'), top: Math.round(r.top),
                w: Math.round(r.width), gc: c.gridColumn, display: c.display};
      });
      const sg = document.querySelector('#tfcweb-section .container > .setting-group');
      const rows = sg ? [...sg.children].map(e => { const r = e.getBoundingClientRect();
        return e.tagName + ' top=' + Math.round(r.top) + ' left=' + Math.round(r.left) + ' w=' + Math.round(r.width); }) : [];
      const charts = [...document.querySelectorAll('#tfcweb-section .chart-section')].map(e => {
        const r = e.getBoundingClientRect(); return {top: Math.round(r.top), w: Math.round(r.width)}; });
      return {容器子: kids, 条件行: rows, 图表: charts};
    }""")
    for k, v in r3.items():
        print('     %s:' % k)
        for x in v:
            print('        %s' % x)
    check('流量概览卡片独占一行', any(x['cls'].startswith('stats-box') and x['gc'] == '1 / -1' for x in r3['容器子']), str(r3['容器子']))
    check('流量条件卡片独占一行', any(x['cls'].startswith('setting-group') and x['gc'] == '1 / -1' for x in r3['容器子']))
    rows = r3['条件行']
    two_col = len(rows) >= 3 and rows[1].split('left=')[1].split()[0] == rows[2].split('left=')[1].split()[0] or \
              len({r.split('top=')[1].split()[0] for r in rows[1:]}) < len(rows) - 1
    check('流量条件项排成两列', two_col, str(rows[:4]))
    ch = r3['图表']
    check('两个图表并列', len(ch) == 2 and ch[0]['top'] == ch[1]['top'], str(ch))

    print()
    print('===== ④ 卡片是否半透明（不再有纯白断层） =====')
    for sec, name, sels in [('clashweb', '网络与SIM', ['.stats-box.sim-speed-box', '.stats-box']),
                            ('usbmodeweb', 'WiFi设置', ['.setting-group', '.wifi-radar-card']),
                            ('tfcweb', '流量管理', ['.stats-box.stats-box-unified', '.setting-group']),
                            ('chargeweb', '电池设置', ['.air-charge-card'])]:
        pg.evaluate("(s)=>{const a=document.querySelector('a[data-section=\"'+s+'\"]');if(a)a.click()}", sec)
        pg.wait_for_timeout(4000)
        d = pg.evaluate("""(a) => {
          const [sec, sels] = a;
          return sels.map(s => {
            const e = document.querySelector('#' + sec + '-section ' + s);
            if (!e) return s + ' → 不存在';
            const c = getComputedStyle(e);
            return s + ' → ' + (c.backgroundImage !== 'none' ? c.backgroundImage.slice(0, 62) : c.backgroundColor);
          });
        }""", [sec, sels])
        for x in d:
            print('     %-12s %s' % (name, x))
            check('%s 卡片半透明' % name, 'rgba' in x or '不存在' not in x and 'rgba' in x, x[-60:])

    print()
    print('JS 报错: %d 条' % len(errs))
    for e in errs[:6]:
        print('   ', e)
    pg.screenshot(path='.tools/r4_liuliang.png', full_page=True)
    b.close()

print()
print('结论: %s' % ('全部通过' if not fails else '仍失败: ' + ', '.join(fails)))
