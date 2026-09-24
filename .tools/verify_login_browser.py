# -*- coding: utf-8 -*-
"""真实浏览器流程：访问 → 跳登录页 → 输错看提示 → 输对进后台（不预置任何凭据）"""
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
    ctx = b.new_context(viewport={'width': 1280, 'height': 900})
    pg = ctx.new_page()

    # 1) 未登录访问首页 → 应被送到登录页（浏览器不再弹原生框）
    pg.goto(BASE + '/', wait_until='load', timeout=45000)
    pg.wait_for_timeout(1200)
    check('未登录访问首页 → 自动跳到登录页', '/air-login' in pg.url, pg.url)
    check('  页面显示「SZ50 后台」标题', pg.locator('h1').inner_text().strip() == 'SZ50 后台')
    check('  输入框自动聚焦到用户名', pg.evaluate("() => document.activeElement && document.activeElement.id") == 'username')
    pg.screenshot(path='.tools/login_page.png')
    print('     截图: .tools/login_page.png')

    # 2) 输错密码 → 页面上出现提示
    pg.fill('#username', U)
    pg.fill('#password', 'wrong-password-xyz')
    pg.click('.login-submit')
    pg.wait_for_selector('.login-error', timeout=15000)
    err = pg.locator('.login-error').inner_text().strip()
    check('密码输错 → 页面提示错误', err == '用户名或密码错误', '实际: %r' % err)
    check('  仍停留在登录页', '/air-login' in pg.url)
    check('  用户名已保留，无需重输', pg.input_value('#username') == U)
    pg.screenshot(path='.tools/login_page_error.png')
    print('     截图: .tools/login_page_error.png')

    # 3) 输对 → 进入后台
    pg.fill('#password', P)
    pg.click('.login-submit')
    pg.wait_for_load_state('load', timeout=30000)
    pg.wait_for_timeout(2500)
    check('密码正确 → 进入后台首页', pg.url.rstrip('/') == BASE, pg.url)
    title = pg.evaluate("() => document.title")
    check('  主界面已加载', 'air' in pg.evaluate("() => document.body.className") or len(title) > 0, 'title=%s' % title)
    pg.screenshot(path='.tools/after_login_home.png')

    # 4) 会话期内打开系统设置页（含改密码卡片）
    pg.goto(BASE + '/html/system.html', wait_until='load', timeout=45000)
    pg.wait_for_timeout(1500)
    has_card = pg.evaluate("""() => [...document.querySelectorAll('.setting-card')].some(c => c.textContent.includes('后台登录密码'))""")
    check('会话期内可直接打开系统设置页（含改密码卡片）', has_card)
    sub = pg.evaluate("""async () => (await fetch('/air-api/monitor')).status""")
    check('  页内 API 调用正常（cookie 生效）', sub == 200, 'HTTP %s' % sub)

    # 5) 刷新后仍是登录态
    pg.goto(BASE + '/html/system.html', wait_until='load', timeout=45000)
    check('刷新后仍保持登录（未被再次要求登录）', '/air-login' not in pg.url, pg.url)
    b.close()

print()
print('结论: %s' % ('全部通过' if not fails else '有失败项: ' + ', '.join(fails)))
