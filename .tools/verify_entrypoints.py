# -*- coding: utf-8 -*-
"""回归：网页终端(7681→17681) 与 AT 控制台(8080→18081) 这两个入口是否仍可用"""
import http.client, json, subprocess, urllib.parse

ADB = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'
for local, remote in (('18999', '17681'), ('18998', '18081')):
    subprocess.run([ADB, 'forward', '--remove', 'tcp:' + local], capture_output=True)
    subprocess.run([ADB, 'forward', 'tcp:' + local, 'tcp:' + remote], capture_output=True)

creds = json.loads(subprocess.run([ADB, 'shell', 'cat /home/root/admin-auth/credentials.json'],
                                  capture_output=True, text=True).stdout)
U, P = creds['username'], creds['password']
BROWSER = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
fails = []


def req(port, method, path, headers=None, body=None):
    c = http.client.HTTPConnection('127.0.0.1', int(port), timeout=25)
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


# 先登录拿会话 cookie
form = urllib.parse.urlencode({'username': U, 'password': P, 'next': '/'})
st, hd, _ = req('18899', 'POST', '/air-login', {'Accept': BROWSER, 'Content-Type': 'application/x-www-form-urlencoded'}, form)
sess = hd.get('Set-Cookie', '').split(';')[0]
print('登录: HTTP %s，已取得会话 cookie\n' % st)

print('=== 网页终端（7681 → 网关 17681）===')
st, hd, body = req('18999', 'GET', '/', {'Accept': BROWSER})
check('未登录访问 → 跳到登录页（不裸奔、不弹框）', st == 302 and '/air-login' in hd.get('Location', ''), '%s %s' % (st, hd.get('Location')))
st, hd, body = req('18999', 'GET', '/', {'Accept': BROWSER, 'Cookie': sess})
check('带会话 cookie 访问 → 200（ttyd 页面正常）', st == 200, 'Status=%s 长度=%d' % (st, len(body)))
check('  确实是 ttyd（页面含 ttyd 特征）', 'ttyd' in body.lower() or 'xterm' in body.lower())
st, hd, _ = req('18999', 'GET', '/', {'Cookie': sess})
check('WebSocket 式请求（Accept: */*）带 cookie → 200', st == 200, 'Status=%s' % st)
st, hd, _ = req('18999', 'GET', '/')
check('WebSocket 式请求不带 cookie → 401（不返回 HTML）', st == 401, 'Status=%s' % st)

print()
print('=== AT 控制台（8080 → 网关 18081）===')
st, hd, body = req('18998', 'GET', '/', {'Accept': BROWSER})
check('未登录访问 → 跳到登录页', st == 302, '%s %s' % (st, hd.get('Location')))
st, hd, body = req('18998', 'GET', '/', {'Accept': BROWSER, 'Cookie': sess})
check('带会话 cookie 访问 → 200（原厂页面正常）', st == 200, 'Status=%s 长度=%d' % (st, len(body)))
st, hd, body = req('18998', 'GET', '/api/get/sysinfo', {'Cookie': sess})
check('带 cookie 调 AT REST 接口 → 200', st == 200, 'Status=%s' % st)

print()
print('结论: %s' % ('全部通过' if not fails else '有失败项: ' + ', '.join(fails)))
