# -*- coding: utf-8 -*-
"""验证全站粒子背景 + 玻璃质感 + 入场动画"""
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
    ctx = b.new_context(viewport={'width': 1440, 'height': 900})
    pg = ctx.new_page()

    pg.goto(BASE + '/', wait_until='load', timeout=45000)
    if '/air-login' in pg.url:
        pg.fill('#username', U)
        pg.fill('#password', P)
        pg.click('.login-submit')
        pg.wait_for_load_state('load', timeout=30000)
    pg.wait_for_timeout(2600)

    info = pg.evaluate("""() => {
      const cv = document.getElementById('air-bg');
      let inked = 0;
      if (cv && cv.getContext) {
        const d = cv.getContext('2d').getImageData(0, 0, cv.width, cv.height).data;
        for (let i = 3; i < d.length; i += 4) { if (d[i] > 8) inked++; }
      }
      const sb = document.querySelector('.sidebar');
      const card = document.querySelector('.stat-card') || document.querySelector('.info-card');
      const frame = document.querySelector('.frame-card');
      return {
        canvas: !!cv, inked: inked,
        sidebarBg: getComputedStyle(sb).backgroundImage.slice(0, 40),
        sidebarBlur: getComputedStyle(sb).backdropFilter,
        cardBlur: card ? getComputedStyle(card).backdropFilter : 'n/a',
        cardBg: card ? getComputedStyle(card).backgroundImage.slice(0, 40) : 'n/a',
        frameBlur: frame ? getComputedStyle(frame).backdropFilter : 'n/a',
        sidebarAnim: getComputedStyle(sb).animationName,
        bodyBg: getComputedStyle(document.body).backgroundColor
      };
    }""")
    check('主界面粒子背景在绘制', info['canvas'] and info['inked'] > 10000, '着墨像素 %s' % info['inked'])
    check('侧边栏毛玻璃生效', 'blur' in (info['sidebarBlur'] or ''), info['sidebarBlur'][:40])
    check('卡片毛玻璃生效', 'blur' in (info['cardBlur'] or ''), info['cardBlur'][:40])
    check('侧边栏有入场动画', 'airSlideIn' in (info['sidebarAnim'] or ''), info['sidebarAnim'])
    check('iframe 承载卡未做模糊（让粒子贯穿）', (info['frameBlur'] or 'none') == 'none', info['frameBlur'])
    pg.screenshot(path='.tools/glass_main_1.png')

    # 切到内嵌页，检查 iframe 内 body 是否透明（能看到同一层粒子）
    pg.click('a[data-section="clashui"]')
    pg.wait_for_timeout(2600)
    fr = pg.frame_locator('#clashui')
    body_bg = fr.locator('body').evaluate("() => getComputedStyle(document.body).backgroundColor")
    check('内嵌页 body 透明（粒子能透出来）',
          body_bg in ('rgba(0, 0, 0, 0)', 'transparent'), body_bg)
    pg.screenshot(path='.tools/glass_main_2.png')

    pg.click('a[data-section="monitor"]')
    pg.wait_for_timeout(2600)
    pg.screenshot(path='.tools/glass_main_3.png')
    b.close()

print()
print('结论: %s' % ('全部通过' if not fails else '有失败项: ' + ', '.join(fails)))
print('截图: .tools/glass_main_1.png（概览）/ _2.png（系统设置）/ _3.png（状态监测）')
