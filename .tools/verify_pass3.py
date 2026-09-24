# -*- coding: utf-8 -*-
"""验证新一轮：布局（侧边栏全高 / 顶栏从右边缘）、透明度、帧率"""
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


FPS_PROBE = """async () => {
  const gaps = [];
  await new Promise(res => {
    let n = 0, last = performance.now();
    function tick(now) {
      gaps.push(now - last); last = now;
      if (++n < 90) { requestAnimationFrame(tick); } else { res(); }
    }
    requestAnimationFrame(tick);
  });
  gaps.sort((a, b) => a - b);
  const avg = gaps.reduce((a, b) => a + b, 0) / gaps.length;
  return {
    avgGap: +avg.toFixed(2),
    p95: +gaps[Math.floor(gaps.length * 0.95)].toFixed(2),
    fps: +(1000 / avg).toFixed(1),
    janky: gaps.filter(g => g > 50).length
  };
}"""

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
    pg.wait_for_timeout(3000)

    lay = pg.evaluate("""() => {
      const sb = document.querySelector('.sidebar'), tb = document.querySelector('.topbar');
      const rs = sb.getBoundingClientRect(), rt = tb.getBoundingClientRect();
      return {
        sbTop: Math.round(rs.top), sbH: Math.round(rs.height), sbW: Math.round(rs.width),
        tbLeft: Math.round(rt.left), tbTop: Math.round(rt.top), tbRight: Math.round(innerWidth - rt.right),
        sbZ: getComputedStyle(sb).zIndex, tbZ: getComputedStyle(tb).zIndex,
        sbBg: getComputedStyle(sb).backgroundImage.match(/rgba?\\([^)]+\\)/g),
        tbBg: getComputedStyle(tb).backgroundImage.match(/rgba?\\([^)]+\\)/g),
        sbBlur: getComputedStyle(sb).backdropFilter
      };
    }""")
    check('侧边栏贯穿全高（到顶）', lay['sbTop'] == 0 and lay['sbH'] >= 880,
          'top=%s 高=%s' % (lay['sbTop'], lay['sbH']))
    check('顶栏从侧边栏右边缘开始、右侧贴边', lay['tbLeft'] == lay['sbW'] and lay['tbRight'] == 0,
          'left=%s(侧边栏宽%s) right=%s' % (lay['tbLeft'], lay['sbW'], lay['tbRight']))
    check('侧边栏在顶栏之上（覆盖其左侧）', int(lay['sbZ']) > int(lay['tbZ']),
          'sidebar z=%s / topbar z=%s' % (lay['sbZ'], lay['tbZ']))
    check('侧边栏透明度已提高（首值 <= 0.45）',
          lay['sbBg'] and float(lay['sbBg'][0].split(',')[-1].strip(' )')) <= 0.45,
          str(lay['sbBg']))
    check('模糊半径已下调', 'blur(18px)' in (lay['sbBlur'] or ''), lay['sbBlur'])

    perf = pg.evaluate(FPS_PROBE)
    check('帧率正常（平均帧间隔 < 25ms、无长卡顿）',
          perf['avgGap'] < 25 and perf['janky'] <= 2,
          '平均 %sms (≈%sfps) p95=%sms 掉帧>50ms: %s 次' % (perf['avgGap'], perf['fps'], perf['p95'], perf['janky']))

    pg.click('a[data-section="clashui"]')
    pg.wait_for_timeout(2800)
    perf2 = pg.evaluate(FPS_PROBE)
    check('切到内嵌页后帧率也正常', perf2['avgGap'] < 28,
          '平均 %sms (≈%sfps) p95=%sms' % (perf2['avgGap'], perf2['fps'], perf2['p95']))
    pg.screenshot(path='.tools/pass3_home.png')
    pg.click('a[data-section="dashboard"]')
    pg.wait_for_timeout(1800)
    pg.screenshot(path='.tools/pass3_shell.png')
    b.close()

print()
print('结论: %s' % ('全部通过' if not fails else '有失败项: ' + ', '.join(fails)))
print('截图: pass3_shell.png（外壳布局）/ pass3_home.png（内嵌页）')
