# -*- coding: utf-8 -*-
"""验证安全退出：清会话、压住缓存的 Basic 凭据、重新登录恢复"""
import http.client, json, subprocess, urllib.parse, base64

ADB = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'
HOST, PORT = '127.0.0.1', 18899
creds = json.loads(subprocess.run([ADB, 'shell', 'cat /home/root/admin-auth/credentials.json'],
                                  capture_output=True, text=True).stdout)
U, P = creds['username'], creds['password']
BROWSER = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
BASIC = {'Authorization': 'Basic ' + base64.b64encode(('%s:%s' % (U, P)).encode()).decode()}
fails = []


def req(method, path, headers=None, body=None):
    c = http.client.HTTPConnection(HOST, PORT, timeout=25)
    h = {'Accept': '*/*'}
    if headers:
        h.update(headers)
    c.request(method, path, body=body, headers=h)
    r = c.getresponse()
    data = r.read()
    out = (r.status, r.getheaders(), data.decode('utf-8', 'replace'))
    c.close()
    return out


def setcookies(hdrs):
    return '; '.join(v.split(';')[0] for k, v in hdrs if k.lower() == 'set-cookie')


def hval(hdrs, name):
    return next((v for k, v in hdrs if k.lower() == name), '')


def check(label, cond, extra=''):
    print('  %s %s%s' % ('ok ' if cond else '!! ', label, ('  ' + extra) if extra else ''))
    if not cond:
        fails.append(label)


print('=== 先登录拿会话 ===')
form = urllib.parse.urlencode({'username': U, 'password': P, 'next': '/'})
st, hd, _ = req('POST', '/air-login', {'Accept': BROWSER, 'Content-Type': 'application/x-www-form-urlencoded'}, form)
sess = [v.split(';')[0] for k, v in hd if k.lower() == 'set-cookie' and v.startswith('SZ50_ADMIN_SESSION')][0]
check('登录成功并拿到会话 cookie', bool(sess) and st == 302)
st, _, _ = req('GET', '/', {'Accept': BROWSER, 'Cookie': sess})
check('  会话可用（首页 200）', st == 200, 'Status=%s' % st)

print()
print('=== 退出 ===')
st, hd, _ = req('POST', '/air-logout', {'Accept': '*/*', 'Cookie': sess})
sc = setcookies(hd)
check('POST /air-logout → 204', st == 204, 'Status=%s' % st)
check('  清掉了会话 cookie（Max-Age=0 / 过期）', 'SZ50_ADMIN_SESSION=;' in (sc + ';') or 'SZ50_ADMIN_SESSION=' in sc)
check('  设置了「已退出」标记，压住缓存的 Basic 凭据', 'SZ50_NO_BASIC=1' in sc)
no_basic = 'SZ50_NO_BASIC=1'
check('  非 POST 方法 → 405', req('GET', '/air-logout')[0] == 405)

print()
print('=== 退出后的行为 ===')
st, hd, _ = req('GET', '/', {'Accept': BROWSER, 'Cookie': no_basic})
check('浏览器访问（已退出标记）→ 跳登录页', st == 302 and '/air-login' in hval(hd, 'location'),
      '%s %s' % (st, hval(hd, 'location')))
st, hd, _ = req('GET', '/', {'Accept': BROWSER, 'Cookie': no_basic, **BASIC})
check('★ 带缓存 Basic 凭据也不会被自动登录 → 仍是登录页', st == 302 and '/air-login' in hval(hd, 'location'),
      '%s %s' % (st, hval(hd, 'location')))
st, _, _ = req('GET', '/air-api/monitor', {'Cookie': no_basic, **BASIC})
check('★ 带缓存 Basic 凭据调 API → 401', st == 401, 'Status=%s' % st)

print()
print('=== 其它客户端不受影响 ===')
st, _, _ = req('GET', '/', {'Accept': BROWSER, **BASIC})
check('没有退出标记的客户端用 Basic 凭据 → 200（老客户端/脚本照旧）', st == 200, 'Status=%s' % st)
st, _, _ = req('GET', '/air-api/monitor', {'Cookie': sess})
check('退出前签发的旧会话 cookie 本身仍有效（无状态令牌的特性）', st == 200, 'Status=%s' % st)

print()
print('=== 重新登录后标记被清除 ===')
st, hd, _ = req('POST', '/air-login',
                {'Accept': BROWSER, 'Content-Type': 'application/x-www-form-urlencoded', 'Cookie': no_basic}, form)
sc = setcookies(hd)
new_sess = [v.split(';')[0] for k, v in hd if k.lower() == 'set-cookie' and v.startswith('SZ50_ADMIN_SESSION')]
check('重新登录成功 → 302', st == 302, 'Status=%s' % st)
check('  下发了新会话 cookie', bool(new_sess))
check('  同时清掉了「已退出」标记（Basic 兼容对这台浏览器恢复）', 'SZ50_NO_BASIC=' in sc and 'SZ50_NO_BASIC=1' not in sc)
st, _, _ = req('GET', '/', {'Accept': BROWSER, 'Cookie': new_sess[0] if new_sess else ''})
check('  新会话可用（首页 200）', st == 200, 'Status=%s' % st)

print()
print('结论: %s' % ('全部通过' if not fails else '有失败项: ' + ', '.join(fails)))
