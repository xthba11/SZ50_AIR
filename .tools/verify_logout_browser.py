# -*- coding: utf-8 -*-
"""端到端：登录 → 系统设置页点「退出登录」→ 确认 → 回登录页 → 再访问仍要求登录 → 重新登录"""
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
    ctx = b.new_context(viewport={'width': 1280, 'height': 1000})
    pg = ctx.new_page()

    # 登录
    pg.goto(BASE + '/', wait_until='load', timeout=45000)
    pg.fill('#username', U)
    pg.fill('#password', P)
    pg.click('.login-submit')
    pg.wait_for_load_state('load', timeout=30000)
    pg.wait_for_timeout(1500)
    check('用登录页登录 → 进入后台', '/air-login' not in pg.url, pg.url)

    # 打开系统设置页，确认退出卡片在
    pg.goto(BASE + '/html/system.html', wait_until='load', timeout=45000)
    pg.wait_for_timeout(1500)
    exists = pg.evaluate("""() => {
      const card = [...document.querySelectorAll('.setting-card')].find(c => c.textContent.includes('退出登录'));
      const btn = document.getElementById('logout-btn');
      return {card: !!card, btn: !!btn, desc: card ? card.querySelector('.card-desc').textContent : null};
    }""")
    check('系统设置页有「退出登录」卡片', exists['card'] and exists['btn'], 'desc=%s' % exists['desc'])
    pg.locator('.setting-card').filter(has_text='退出登录').screenshot(path='.tools/logout_card.png')

    # 点退出 → 应弹确认框
    pg.click('#logout-btn')
    pg.wait_for_timeout(600)
    dlg = pg.evaluate("() => {const d=document.getElementById('confirmation');return {shown: d.style.display==='block', title: document.getElementById('dialog-title').textContent, btn: document.getElementById('dialog-confirm').textContent};}")
    check('点击后弹出确认框', dlg['shown'] and dlg['title'] == '确认退出登录', '%s / %s' % (dlg['title'], dlg['btn']))
    pg.screenshot(path='.tools/logout_confirm.png')

    # 确认退出
    pg.click('#dialog-confirm')
    pg.wait_for_url('**/air-login**', timeout=20000)
    pg.wait_for_timeout(1200)
    check('确认后回到登录页', '/air-login' in pg.url, pg.url)

    # 关键：再访问首页，不能被"自动登录"回去（浏览器可能缓存着旧 Basic 凭据）
    pg.goto(BASE + '/', wait_until='load', timeout=45000)
    pg.wait_for_timeout(1200)
    check('★ 退出后再次访问 → 仍要求登录（没被自动登录回去）', '/air-login' in pg.url, pg.url)

    # 重新登录
    pg.fill('#username', U)
    pg.fill('#password', P)
    pg.click('.login-submit')
    pg.wait_for_load_state('load', timeout=30000)
    pg.wait_for_timeout(1500)
    check('重新登录 → 正常进入后台', '/air-login' not in pg.url, pg.url)
    st = pg.evaluate("""async () => (await fetch('/air-api/monitor')).status""")
    check('  会话可用（页内 API 200）', st == 200, 'HTTP %s' % st)
    b.close()

print()
print('结论: %s' % ('全部通过' if not fails else '有失败项: ' + ', '.join(fails)))
