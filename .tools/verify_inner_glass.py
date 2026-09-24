# -*- coding: utf-8 -*-
"""验证内嵌页（iframe 内）的卡片玻璃化是否生效"""
import subprocess, json

ADB = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'
creds = json.loads(subprocess.run([ADB, 'shell', 'cat /home/root/admin-auth/credentials.json'],
                                  capture_output=True, text=True).stdout)
U, P = creds['username'], creds['password']
BASE = 'http://127.0.0.1:18899'
fails = []


def check(label, cond, extra=''):
    print('  %s %s%s' % ('ok ' if cond else '!! ', label, ('  ' + extra) if extra else ''))
    if not cond:
        fails.append(label)


from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    b = p.chromium.launch()
    ctx = b.new_context(viewport={'width': 1440, 'height': 900})
    pg = ctx.new_page()
    pg.goto(BASE + '/', wait_until='load', timeout=45000)
    if '/air-login' in pg.url:
        pg.fill('#username', U)
        pg.fill('#password', P)
        pg.click('.login-submit')
        pg.wait_for_load_state('load', timeout=30000)
        pg.wait_for_timeout(2200)

    for name, frame_id in (('系统设置', 'clashui'), ('状态监测', 'monitor'), ('代理设置', 'proxyweb')):
        pg.click('a[data-section="%s"]' % frame_id)
        pg.wait_for_timeout(2500)
        fr = pg.frame_locator('#' + frame_id)
        info = fr.locator('body').evaluate("""() => {
          const out = [];
          for (const el of document.querySelectorAll('.setting-card,.setting-group,.proxy-card,.monitor-card,.breakdown-card,.metric-box,.stats-box,.info-card')) {
            const cs = getComputedStyle(el);
            const r = el.getBoundingClientRect();
            if (r.width < 60 || r.height < 40) { continue; }
            out.push({ cls: el.className.toString().slice(0, 28),
                       radius: cs.borderRadius,
                       bg: cs.backgroundImage.slice(0, 34),
                       shadow: cs.boxShadow.slice(0, 30) });
          }
          return { count: out.length, sample: out.slice(0, 3) };
        }""")
        check('%s：找到 %d 个卡片容器' % (name, info['count']), info['count'] > 0)
        for s in info['sample']:
            grad = 'gradient' in s['bg']
            radius = '16px' in s['radius']
            check('   %s → 玻璃底=%s 圆角=%s' % (s['cls'], grad, radius), grad and radius, s['shadow'])
        if name == '系统设置':
            pg.screenshot(path='.tools/glass_inner_1.png')
        if name == '状态监测':
            pg.screenshot(path='.tools/glass_inner_2.png')
    b.close()

print()
print('结论: %s' % ('全部通过' if not fails else '有失败项: ' + ', '.join(fails)))
