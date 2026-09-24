# -*- coding: utf-8 -*-
"""验证「退出后不再弹系统窗口」的修复：

协议层  ① 无 Sec-Fetch-*（curl/脚本）→ 401 仍带 Basic 挑战（API 语义不变）
        ② 有 Sec-Fetch-*（真实浏览器页面内请求）→ 401 **不带**挑战 → 浏览器不弹框
        ③ 浏览器导航 → 302 登录页
浏览器层 ④ 在主界面 iframe 里点退出 → 整个页面跳登录页、主界面不再残留、无后续轮询
"""
import http.client, json, subprocess

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


def req(path, headers):
    c = http.client.HTTPConnection('127.0.0.1', 18899, timeout=20)
    c.request('GET', path, headers=headers)
    r = c.getresponse()
    body = r.read(200)
    hd = {k.lower(): v for k, v in r.getheaders()}
    c.close()
    return r.status, hd, body


print('=== 协议层 ===')
st, hd, _ = req('/api/get/network', {'Accept': '*/*'})
check('① curl/脚本（无 Sec-Fetch-*）→ 401 且保留 Basic 挑战', st == 401 and 'www-authenticate' in hd,
      'Status=%s 挑战=%s' % (st, 'www-authenticate' in hd))

browser_hdr = {'Accept': '*/*', 'Sec-Fetch-Site': 'same-origin',
               'Sec-Fetch-Mode': 'cors', 'Sec-Fetch-Dest': 'empty'}
st, hd, _ = req('/api/get/network', browser_hdr)
check('② 浏览器页面内请求（有 Sec-Fetch-*）→ 401 但【无】挑战（不再弹框）',
      st == 401 and 'www-authenticate' not in hd, 'Status=%s 挑战=%s' % (st, 'www-authenticate' in hd))

st, hd, _ = req('/air-api/monitor', browser_hdr)
check('   同上，/air-api/monitor 也是无挑战 401', st == 401 and 'www-authenticate' not in hd)

st, hd, _ = req('/', {'Accept': 'text/html,application/xhtml+xml', 'Sec-Fetch-Site': 'none',
                      'Sec-Fetch-Mode': 'navigate', 'Sec-Fetch-Dest': 'document'})
check('③ 浏览器导航 → 302 跳登录页', st == 302 and '/air-login' in hd.get('location', ''),
      'Status=%s Location=%s' % (st, hd.get('location')))

print()
print('=== 浏览器层（在 iframe 里退出）===')
resp = []


def on_resp(r):
    try:
        resp.append((r.status, r.url.replace(BASE, ''),
                     'www-auth' if 'www-authenticate' in {k.lower() for k in r.headers} else ''))
    except Exception:
        pass


from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    b = p.chromium.launch()
    ctx = b.new_context(viewport={'width': 1200, 'height': 900},
                        http_credentials={'username': U, 'password': P})
    ctx.on('response', on_resp)
    pg = ctx.new_page()

    pg.goto(BASE + '/', wait_until='load', timeout=45000)
    if '/air-login' in pg.url:
        pg.fill('#username', U)
        pg.fill('#password', P)
        pg.click('.login-submit')
        pg.wait_for_load_state('load', timeout=30000)
        pg.wait_for_timeout(2000)

    pg.click('a[data-section="clashui"]')
    pg.wait_for_timeout(2500)
    frame = pg.frame_locator('#clashui')
    check('进到系统设置 iframe，看到退出按钮', frame.locator('#logout-btn').count() == 1)

    resp.clear()
    frame.locator('#logout-btn').click()
    pg.wait_for_timeout(500)
    frame.locator('#dialog-confirm').click()
    pg.wait_for_timeout(3000)

    check('④ 退出后整个页面跳到登录页（不只是 iframe 自己）', '/air-login' in pg.url, pg.url)
    check('   主界面侧边栏已卸载（不再残留）', not pg.locator('aside.sidebar').is_visible())
    check('   登录页表单已出现', pg.locator('#username').count() > 0)

    # 退出后静置，看主界面残留轮询是否还在打请求
    resp.clear()
    pg.wait_for_timeout(7000)
    leftovers = [r for r in resp if '/api/' in r[1] or 'traffic.cgi' in r[1] or '/air-api/' in r[1]]
    check('   退出后 7 秒内没有残留轮询（主界面确实卸载了）', len(leftovers) == 0,
          '残留请求 %d 条' % len(leftovers))
    for st, url, warn in resp:
        print('      %s %s %s' % (st, url, warn))
    b.close()

print()
print('结论: %s' % ('全部通过' if not fails else '有失败项: ' + ', '.join(fails)))
