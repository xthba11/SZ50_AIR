# -*- coding: utf-8 -*-
"""验证本轮修复：顶栏全宽固定 / 跨 iframe 鼠标传给粒子 / 终端 iframe 圆角 / 内嵌页无实心块"""
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
    pg.wait_for_timeout(2400)

    # 顶栏：全宽 + 固定
    tb = pg.evaluate("""() => {
      const t = document.querySelector('.topbar'); const r = t.getBoundingClientRect();
      return {left: Math.round(r.left), right: Math.round(window.innerWidth - r.right), w: Math.round(r.width),
              top: Math.round(r.top), pos: getComputedStyle(t).position, vw: window.innerWidth};
    }""")
    check('顶栏横跨整个视口（左右都贴边）', tb['left'] == 0 and tb['right'] == 0,
          'left=%s right=%s 宽=%s/视口%s' % (tb['left'], tb['right'], tb['w'], tb['vw']))
    check('顶栏固定定位', tb['pos'] == 'fixed', tb['pos'])

    # 滚动后顶栏仍在最顶
    pg.evaluate("() => window.scrollTo(0, 600)")
    pg.wait_for_timeout(700)
    top_after = pg.evaluate("() => Math.round(document.querySelector('.topbar').getBoundingClientRect().top)")
    check('页面滚动后顶栏仍在顶端', top_after == 0, 'top=%s' % top_after)
    pg.evaluate("() => window.scrollTo(0, 0)")
    pg.wait_for_timeout(400)

    # 跨 iframe 鼠标：在 iframe 区域移动鼠标，主界面应收到 air-mouse 消息
    pg.evaluate("""() => { window.__mm = 0; window.addEventListener('message', e => { if (e.data && e.data.type === 'air-mouse') window.__mm++; }); }""")
    pg.click('a[data-section="clashui"]')
    pg.wait_for_timeout(2400)
    box = pg.locator('#clashui').bounding_box()
    for dx in (0.3, 0.45, 0.6):          # 在 iframe 内部划几下
        pg.mouse.move(box['x'] + box['width'] * dx, box['y'] + 200)
        pg.wait_for_timeout(160)
    msgs = pg.evaluate("() => window.__mm")
    check('鼠标在 iframe 内移动时，位置已转发给主界面（粒子可跟随）', msgs > 0, '收到 %s 条 air-mouse' % msgs)

    # 内嵌页：不该再有实心整块背景
    solid = pg.evaluate("""() => {
      const fr = document.getElementById('clashui');
      const d = fr.contentDocument, w = fr.contentWindow;
      const out = [];
      [d.documentElement, d.body].forEach(el => {
        const bg = w.getComputedStyle(el).backgroundColor;
        if (bg && bg !== 'rgba(0, 0, 0, 0)') out.push(el.tagName + ':' + bg);
      });
      return out;
    }""")
    check('内嵌页 html/body 全透明（无分界线来源）', len(solid) == 0, str(solid))

    # 网页终端：iframe 圆角
    pg.click('a[data-section="terminalweb"]')
    pg.wait_for_timeout(2600)
    radius = pg.evaluate("""() => {
      const f = document.querySelector('#terminalweb-section iframe');
      return f ? getComputedStyle(f).borderRadius : 'no-iframe';
    }""")
    check('网页终端 iframe 已加圆角', '14px' in str(radius), str(radius))
    pg.screenshot(path='.tools/fix_terminal.png')
    pg.click('a[data-section="chargeweb"]')
    pg.wait_for_timeout(2600)
    pg.screenshot(path='.tools/fix_charge.png')
    cw = pg.evaluate("""() => {
      const fr = document.querySelector('#chargeweb-section iframe');
      const d = fr.contentDocument;
      const el = d.querySelector('.air-charge-form-box') || d.querySelector('[class*=charge]');
      const shell = d.querySelector('.charge-shell');
      return {card: el ? Math.round(el.getBoundingClientRect().width) : 0,
              shell: shell ? Math.round(shell.getBoundingClientRect().width) : 0,
              shellMaxW: shell ? getComputedStyle(shell).maxWidth : 'n/a'};
    }""")
    check('电池页容器宽度已放开（不再被 max-width 卡住）',
          str(cw['shellMaxW']) in ('none', '100%') or cw['shell'] >= 1080,
          'shell 宽=%s maxWidth=%s 卡片宽=%s' % (cw['shell'], cw['shellMaxW'], cw['card']))
    b.close()

print()
print('结论: %s' % ('全部通过' if not fails else '有失败项: ' + ', '.join(fails)))
print('截图: fix_terminal.png（网页终端）/ fix_charge.png（电池设置）')
