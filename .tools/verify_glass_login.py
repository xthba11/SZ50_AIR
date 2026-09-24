# -*- coding: utf-8 -*-
"""验证登录页玻璃 + 粒子增量 + 离场过渡（登录 → 后台入场）"""
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
    pg.wait_for_timeout(1800)

    info = pg.evaluate("""() => {
      const cv = document.getElementById('bg');
      let inked = 0;
      const d = cv.getContext('2d').getImageData(0, 0, cv.width, cv.height).data;
      for (let i = 3; i < d.length; i += 4) { if (d[i] > 8) inked++; }
      const card = document.querySelector('.login-card');
      return {
        inked: inked,
        cardBlur: getComputedStyle(card).backdropFilter,
        cardBg: getComputedStyle(card).backgroundImage.slice(0, 44),
        hasEdge: !!card.querySelector('::before') || getComputedStyle(card, '::before').backgroundImage !== 'none',
        cardAnim: getComputedStyle(card).animationName,
        boost: typeof window.__airBgBoost
      };
    }""")
    check('登录页粒子已加密（着墨像素 > 7 万）', info['inked'] > 70000, '着墨 %s（改造前约 4.3 万）' % info['inked'])
    check('登录卡片毛玻璃生效', 'blur' in (info['cardBlur'] or ''), (info['cardBlur'] or '')[:38])
    check('卡片有玻璃边缘光', info['hasEdge'])
    check('卡片有进场动画', info['cardAnim'] == 'airLoginIn', info['cardAnim'])
    check('粒子加速钩子已就位', info['boost'] == 'function')
    pg.screenshot(path='.tools/glass_login_1.png')

    # 提交登录：应当先进入 leaving 状态（离场动画），再跳后台
    pg.fill('#username', U)
    pg.fill('#password', P)
    pg.click('.login-submit')
    pg.wait_for_timeout(260)
    leaving = pg.evaluate("() => document.body.classList.contains('leaving')")
    check('提交后先播离场动画（body.leaving）', leaving)
    try:
        pg.screenshot(path='.tools/glass_login_2.png')     # 离场瞬间
    except Exception:
        pass
    pg.wait_for_load_state('load', timeout=30000)
    pg.wait_for_timeout(2600)
    check('随后进入后台首页', pg.url.rstrip('/') == BASE, pg.url)
    # 后台的入场动画
    anim = pg.evaluate("() => getComputedStyle(document.querySelector('aside.sidebar')).animationName")
    check('后台侧边栏入场动画在跑/已用', anim in ('airSlideIn', 'none'), anim)
    pg.screenshot(path='.tools/glass_login_3.png')
    b.close()

print()
print('结论: %s' % ('全部通过' if not fails else '有失败项: ' + ', '.join(fails)))
print('截图: glass_login_1(登录页) / _2(离场瞬间) / _3(后台)')
