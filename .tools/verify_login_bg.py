# -*- coding: utf-8 -*-
"""线上登录页验证：背景跟随生效 + 登录流程不受影响"""
import subprocess, json

ADB = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'
subprocess.run([ADB, 'forward', 'tcp:18899', 'tcp:18080'], capture_output=True)
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
    ctx = b.new_context(viewport={'width': 1280, 'height': 800})
    pg = ctx.new_page()

    pg.goto(BASE + '/', wait_until='load', timeout=45000)
    pg.wait_for_timeout(1200)
    check('未登录访问 → 落在登录页', '/air-login' in pg.url, pg.url)

    info = pg.evaluate("""() => {
      const cv = document.getElementById('bg');
      const g = cv && cv.getContext ? cv.getContext('2d') : null;
      let inked = 0;
      if (g) {
        const d = g.getImageData(0, 0, cv.width, cv.height).data;
        for (let i = 3; i < d.length; i += 4) { if (d[i] > 8) inked++; }
      }
      return { canvas: !!cv, wash: !!document.querySelector('.wash'), inked: inked, leftover: document.querySelectorAll('.blob').length };
    }""")
    check('背景 canvas 已渲染并持续绘制',
          info['canvas'] and info['wash'] and info['inked'] > 5000,
          'canvas=%s wash=%s 着墨像素=%s' % (info['canvas'], info['wash'], info['inked']))
    check('旧柔光层已彻底移除', info['leftover'] == 0, 'blob 残留 %s 个' % info['leftover'])
    pg.screenshot(path='.tools/login_bg_live_1.png')

    # 鼠标移动后画布内容应当变化（粒子被牵引/刷新）
    pg.mouse.move(1150, 120)
    pg.wait_for_timeout(1600)
    inked2 = pg.evaluate("""() => {
      const cv = document.getElementById('bg');
      const d = cv.getContext('2d').getImageData(0, 0, cv.width, cv.height).data;
      let n = 0; for (let i = 3; i < d.length; i += 4) { if (d[i] > 8) n++; }
      return n;
    }""")
    pg.screenshot(path='.tools/login_bg_live_2.png')
    check('画布在持续重绘（鼠标移动后着墨像素变化）', inked2 != info['inked'],
          '%s → %s' % (info['inked'], inked2))

    # 登录流程不受影响
    pg.fill('#username', U)
    pg.fill('#password', P)
    pg.click('.login-submit')
    pg.wait_for_load_state('load', timeout=30000)
    pg.wait_for_timeout(2500)
    check('登录功能正常（进入后台首页）', pg.url.rstrip('/') == BASE, pg.url)
    check('  主界面已加载', pg.locator('aside.sidebar').is_visible())

    # 退出后回到登录页，背景依旧
    pg.click('a[data-section="clashui"]')
    pg.wait_for_timeout(2200)
    pg.frame_locator('#clashui').locator('#logout-btn').click()
    pg.wait_for_timeout(500)
    pg.frame_locator('#clashui').locator('#dialog-confirm').click()
    pg.wait_for_timeout(3000)
    check('退出后回登录页且背景仍在',
          '/air-login' in pg.url and pg.locator('#bg').count() == 1 and pg.locator('.wash').count() == 1, pg.url)
    b.close()

print()
print('结论: %s' % ('全部通过' if not fails else '有失败项: ' + ', '.join(fails)))
print('截图: .tools/login_bg_live_1.png（初始）/ login_bg_live_2.png（鼠标在右上）')
