
import subprocess, json
ADB = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'
subprocess.run([ADB,'forward','tcp:18899','tcp:18080'],capture_output=True)
c = json.loads(subprocess.run([ADB,'shell','cat /home/root/admin-auth/credentials.json'],capture_output=True,text=True).stdout)
from playwright.sync_api import sync_playwright
fails = []
def check(l, cond, extra=''):
    print('  %s %s%s' % ('ok ' if cond else '!! ', l, ('   ' + extra) if extra else ''))
    if not cond: fails.append(l)
with sync_playwright() as p:
    b = p.chromium.launch(); ctx = b.new_context(viewport={'width':2560,'height':1300}); pg = ctx.new_page()
    errs = []
    pg.on('pageerror', lambda e: errs.append(str(e)[:150]))
    pg.goto('http://127.0.0.1:18899/', wait_until='load', timeout=45000)
    if '/air-login' in pg.url:
        pg.fill('#username', c['username']); pg.fill('#password', c['password'])
        pg.click('.login-submit'); pg.wait_for_load_state('load', timeout=30000)
    pg.wait_for_timeout(2500)

    print('===== ① 侧边栏「连接设备」的图标 =====')
    ic = pg.evaluate("""() => {
      const a = document.querySelector('.nav-menu a[data-section="devices"]');
      if (!a) return null;
      const use = a.querySelector('use');
      const svg = a.querySelector('svg');
      const rr = svg.getBoundingClientRect();
      return {href: use ? (use.getAttribute('href') || use.getAttribute('xlink:href')) : null,
              w: Math.round(rr.width), h: Math.round(rr.height),
              symbol存在: !!document.getElementById('i-phone')};
    }""")
    print('     %s' % ic)
    check('「连接设备」已用小手机图标', ic and ic['href'] == '#i-phone' and ic['symbol存在'], str(ic))

    print()
    print('===== ② 消息提示框是否居中（三个页各测一次） =====')
    for sec, tid, name in [('tfcweb', 'liu-toast', '流量管理'), ('usbmodeweb', 'wifi-toast', 'WiFi设置'),
                           ('clashweb', 'toast', '网络与SIM')]:
        pg.evaluate("(s)=>{const a=document.querySelector('a[data-section=\"'+s+'\"]');if(a)a.click()}", sec)
        pg.wait_for_timeout(4000)
        r = pg.evaluate("""(id) => {
          const e = document.getElementById(id);
          if (!e) return {错误: '元素不存在: ' + id};
          e.classList.add('show');
          const rr = e.getBoundingClientRect();
          const cs = getComputedStyle(e);
          return {视口宽: window.innerWidth, toast宽: Math.round(rr.width),
                  toast左: Math.round(rr.left), toast右: Math.round(rr.right),
                  左空白: Math.round(rr.left), 右空白: Math.round(window.innerWidth - rr.right),
                  left样式: cs.left, transform: cs.transform, top: Math.round(rr.top),
                  position: cs.position};
        }""", tid)
        print('     --- %s ( #%s )' % (name, tid))
        for k, v in r.items():
            print('        %-10s %s' % (k, v))
        if '错误' not in r:
            check('%s 提示框水平居中' % name, abs(r['左空白'] - r['右空白']) <= 2,
                  '左%s / 右%s' % (r['左空白'], r['右空白']))
            check('%s 提示框在顶部' % name, r['top'] <= 30, 'top=%s' % r['top'])
        pg.evaluate("(id)=>{const e=document.getElementById(id);e&&e.classList.remove('show');}", tid)

    print()
    print('JS 报错: %d 条' % len(errs))
    for e in errs[:5]: print('   ', e)
    check('无 JS 报错', not errs)
    b.close()
print()
print('结论: %s' % ('全部通过' if not fails else '仍失败: ' + ', '.join(fails)))
