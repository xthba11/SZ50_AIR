
import subprocess, json
ADB = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'
c = json.loads(subprocess.run([ADB,'shell','cat /home/root/admin-auth/credentials.json'],capture_output=True,text=True).stdout)
from playwright.sync_api import sync_playwright
PROBE = '''() => {
  const sb = document.getElementById('sidebar');
  const r = sb.getBoundingClientRect(), cs = getComputedStyle(sb);
  const mc = document.querySelector('.main-content').getBoundingClientRect();
  return {视口: window.innerWidth + 'x' + window.innerHeight,
          sidebar: {x: Math.round(r.x), w: Math.round(r.width), transform: cs.transform,
                    anim: cs.animationName, cls: sb.className},
          侧边栏在屏内: r.right > 0 && r.left < window.innerWidth,
          内容被遮宽度: Math.max(0, Math.min(r.right, window.innerWidth) - Math.max(r.left, mc.left))};
}'''
fails = []
def check(l, cond, extra=''):
    print('  %s %s%s' % ('ok ' if cond else '!! ', l, ('   ' + extra) if extra else ''))
    if not cond: fails.append(l)
with sync_playwright() as p:
    b = p.chromium.launch()
    # --- 手机视口 ---
    ctx = b.new_context(viewport={'width': 390, 'height': 844}, is_mobile=True, has_touch=True)
    pg = ctx.new_page()
    pg.goto('http://192.168.0.1/', wait_until='load', timeout=45000)
    if '/air-login' in pg.url:
        pg.fill('#username', c['username']); pg.fill('#password', c['password'])
        pg.click('.login-submit'); pg.wait_for_load_state('load', timeout=30000)
    pg.wait_for_timeout(3000)
    st = pg.evaluate(PROBE)
    print('===== 手机 390x844 =====')
    print('   ', st)
    check('手机端侧边栏默认收起（移出屏外）', st['sidebar']['x'] <= -200 and not st['侧边栏在屏内'],
          'x=%s 在屏内=%s' % (st['sidebar']['x'], st['侧边栏在屏内']))
    check('手机端内容没有被遮挡', st['内容被遮宽度'] <= 0, '%spx' % st['内容被遮宽度'])
    pg.screenshot(path='.tools/mobile_after_closed.png')
    # 展开
    pg.evaluate("()=>{ if (window.toggleSidebar) toggleSidebar(); else document.getElementById('sidebar').classList.add('active'); }")
    pg.wait_for_timeout(900)
    so = pg.evaluate(PROBE)
    print('     展开后:', {k: so['sidebar'][k] for k in ['x', 'transform', 'cls']})
    check('手机端点开按钮能正常展开', so['sidebar']['x'] == 0, 'x=%s' % so['sidebar']['x'])
    pg.screenshot(path='.tools/mobile_after_open.png')
    # 点导航项应自动收起
    pg.evaluate("()=>{const a=document.querySelector('.nav-menu a[data-section=\\'devices\\']'); a&&a.click();}")
    pg.wait_for_timeout(1200)
    sc = pg.evaluate(PROBE)
    check('手机端选择导航后自动收起', sc['sidebar']['x'] <= -200, 'x=%s' % sc['sidebar']['x'])
    ctx.close()

    # --- 桌面视口回归 ---
    ctx2 = b.new_context(viewport={'width': 2560, 'height': 1300})
    pg2 = ctx2.new_page()
    pg2.goto('http://192.168.0.1/', wait_until='load', timeout=45000)
    if '/air-login' in pg2.url:
        pg2.fill('#username', c['username']); pg2.fill('#password', c['password'])
        pg2.click('.login-submit'); pg2.wait_for_load_state('load', timeout=30000)
    pg2.wait_for_timeout(3000)
    sd = pg2.evaluate(PROBE)
    print('===== 桌面 2560x1300（回归） =====')
    print('   ', sd)
    check('桌面端侧边栏正常显示', sd['sidebar']['x'] == 0 and sd['sidebar']['w'] == 228, str(sd['sidebar']))
    check('桌面端保留了入场动画', sd['sidebar']['anim'] == 'airSlideIn', sd['sidebar']['anim'])
    b.close()
print()
print('结论: %s' % ('全部通过' if not fails else '仍失败: ' + ', '.join(fails)))
