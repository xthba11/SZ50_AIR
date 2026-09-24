# -*- coding: utf-8 -*-
"""验证登录页流程：浏览器跳登录页、输错有提示、API 仍走 Basic 401"""
import http.client, json, subprocess, urllib.parse

ADB = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'
HOST, PORT = '127.0.0.1', 18899
creds = json.loads(subprocess.run([ADB, 'shell', 'cat /home/root/admin-auth/credentials.json'],
                                  capture_output=True, text=True).stdout)
U, P = creds['username'], creds['password']
BROWSER = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,*/*;q=0.8'
fails = []


def req(method, path, headers=None, body=None):
    c = http.client.HTTPConnection(HOST, PORT, timeout=25)
    h = {'Accept': '*/*'}
    if headers:
        h.update(headers)
    c.request(method, path, body=body, headers=h)
    r = c.getresponse()
    data = r.read()
    out = (r.status, dict(r.getheaders()), data.decode('utf-8', 'replace'))
    c.close()
    return out


def check(label, cond, extra=''):
    print('  %s %s%s' % ('ok ' if cond else '!! ', label, ('  ' + extra) if extra else ''))
    if not cond:
        fails.append(label)


print('凭据: 用户名=%s 密码长度=%d' % (U, len(P)))
print()
print('=== 浏览器路径（Accept: text/html）===')
st, hd, body = req('GET', '/', {'Accept': BROWSER})
check('未登录访问首页 → 302 跳登录页', st == 302, 'Status=%s Location=%s' % (st, hd.get('Location')))
check('  跳转带 next 参数', 'next=' in (hd.get('Location') or ''), hd.get('Location', ''))
check('  响应里没有 Basic 挑战（浏览器不会再弹框）', 'Www-Authenticate' not in hd)

st, hd, body = req('GET', '/air-login?next=%2F', {'Accept': BROWSER})
check('登录页可访问 → 200', st == 200, 'Status=%s' % st)
check('  含标题与表单', 'SZ50 后台' in body and 'name="password"' in body)
check('  含 next 隐藏域', 'name="next"' in body)
check('  首次进入不显示错误提示', '用户名或密码错误' not in body)

st, hd, body = req('GET', '/air-login?next=https://evil.example.com', {'Accept': BROWSER})
check('外部 next 被拦下（防开放重定向）', 'value="https://evil.example.com"' not in body, '已回退为 /')

form = urllib.parse.urlencode({'username': U, 'password': 'wrong-password-123', 'next': '/'})
st, hd, body = req('POST', '/air-login', {'Accept': BROWSER, 'Content-Type': 'application/x-www-form-urlencoded'}, form)
check('密码输错 → 页面提示「用户名或密码错误」', st == 200 and '用户名或密码错误' in body, 'Status=%s' % st)
check('  没有签发会话 cookie', 'Set-Cookie' not in hd)

form = urllib.parse.urlencode({'username': U, 'password': P, 'next': '/'})
st, hd, body = req('POST', '/air-login', {'Accept': BROWSER, 'Content-Type': 'application/x-www-form-urlencoded'}, form)
check('密码正确 → 302 回首页', st == 302, 'Status=%s Location=%s' % (st, hd.get('Location')))
cookie = hd.get('Set-Cookie', '')
check('  签发了会话 cookie', cookie.startswith('SZ50_ADMIN_SESSION='))
sess = cookie.split(';')[0]

st, _, body = req('GET', '/', {'Accept': BROWSER, 'Cookie': sess})
check('带 cookie 访问首页 → 200', st == 200, 'Status=%s' % st)
st, _, _ = req('GET', '/html/system.html', {'Accept': BROWSER, 'Cookie': sess})
check('带 cookie 打开系统设置页 → 200', st == 200, 'Status=%s' % st)
st, hd, _ = req('GET', '/air-login', {'Accept': BROWSER, 'Cookie': sess})
check('已登录再访问登录页 → 302 回首页', st == 302, 'Location=%s' % hd.get('Location'))

print()
print('=== API / 命令行路径（Accept: */*）===')
st, hd, _ = req('GET', '/')
check('无凭据调 API → 仍 401 + Basic 挑战', st == 401 and 'Www-Authenticate' in hd, 'Status=%s' % st)
st, _, _ = req('GET', '/air-api/monitor')
check('无凭据调 /air-api/monitor → 401（不跳登录页）', st == 401, 'Status=%s' % st)
st, _, _ = req('GET', '/air-api/monitor', {'Cookie': sess})
check('带 cookie 调 /air-api/monitor → 200', st == 200, 'Status=%s' % st)
import base64
tok = base64.b64encode(('%s:%s' % (U, P)).encode()).decode()
st, _, _ = req('GET', '/air-api/monitor', {'Authorization': 'Basic ' + tok})
check('Basic 凭据仍可用（老客户端不受影响）→ 200', st == 200, 'Status=%s' % st)
st, _, _ = req('GET', '/favicon.ico', {'Accept': BROWSER})
check('favicon 不跳登录页 → 204', st == 204, 'Status=%s' % st)

print()
print('结论: %s' % ('全部通过' if not fails else '有失败项: ' + ', '.join(fails)))
