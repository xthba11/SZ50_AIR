
import subprocess, json
ADB = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'
c = json.loads(subprocess.run([ADB,'shell','cat /home/root/admin-auth/credentials.json'],capture_output=True,text=True).stdout)
from playwright.sync_api import sync_playwright
fails = []
def check(l, cond, extra=''):
    print('  %s %s%s' % ('ok ' if cond else '!! ', l, ('   ' + extra) if extra else ''))
    if not cond: fails.append(l)
SAMPLE = """() => {
  const c = document.getElementById('air-bg');
  if (!c) return null;
  const ctx = c.getContext('2d');
  const d = ctx.getImageData(0, 0, c.width, c.height).data;
  let n = 0;
  for (let i = 3; i < d.length; i += 64) { if (d[i] > 8) n++; }
  return {像素: n, canvas: c.width + 'x' + c.height,
          htmlClass: document.documentElement.className || '(无)', lite: document.documentElement.classList.contains('air-lite')};
}"""
with sync_playwright() as p:
    b = p.chromium.launch(); ctx = b.new_context(viewport={'width':2560,'height':1300}); pg = ctx.new_page()
    errs = []
    pg.on('pageerror', lambda e: errs.append(str(e)[:140]))
    pg.goto('http://192.168.0.1/', wait_until='load', timeout=45000)
    if '/air-login' in pg.url:
        pg.fill('#username', c['username']); pg.fill('#password', c['password'])
        pg.click('.login-submit'); pg.wait_for_load_state('load', timeout=30000)
    # 早期采样（降级若存在，会在约 0.7s 后触发）
    pg.wait_for_timeout(1200)
    s1 = pg.evaluate(SAMPLE)
    print('     1.2 秒时:', s1)
    pg.wait_for_timeout(7000)
    s2 = pg.evaluate(SAMPLE)
    print('     8.2 秒时:', s2)
    if s1 and s2:
        check('粒子密度不再随时间下降', s2['像素'] >= s1['像素'] * 0.85,
              '%s → %s' % (s1['像素'], s2['像素']))
        check('未再添加 air-lite（降级已移除）', not s2['lite'] and 'air-lite' not in s2['htmlClass'], s2['htmlClass'])

    print()
    print('===== 对比登录页密度（同尺寸窗口） =====')
    pg2 = ctx.new_page()
    pg2.goto('http://192.168.0.1/air-login.html', wait_until='load', timeout=40000)
    pg2.wait_for_timeout(2500)
    sl = pg2.evaluate(SAMPLE)
    print('     登录页:', sl)
    if sl and s2:
        ratio = s2['像素'] / sl['像素'] if sl['像素'] else 0
        print('     主界面/登录页 像素比 = %.3f' % ratio)
        check('主界面密度与登录页同一量级', 0.7 <= ratio <= 1.4, '%.3f' % ratio)

    print()
    print('JS 报错: %d 条' % len(errs))
    check('无 JS 报错', not errs)
    b.close()
print()
print('结论: %s' % ('全部通过' if not fails else '仍需处理: ' + ', '.join(fails)))
