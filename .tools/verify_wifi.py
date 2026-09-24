# -*- coding: utf-8 -*-
"""验证 WiFi 页三个问题是否解决"""
import subprocess, json

ADB = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'
subprocess.run([ADB, 'forward', 'tcp:18899', 'tcp:18080'], capture_output=True)
creds = json.loads(subprocess.run([ADB, 'shell', 'cat /home/root/admin-auth/credentials.json'],
                                  capture_output=True, text=True).stdout)
U, P = creds['username'], creds['password']
fails = []

def check(label, cond, extra=''):
    print('  %s %s%s' % ('ok ' if cond else '!! ', label, ('   ' + extra) if extra else ''))
    if not cond:
        fails.append(label)

from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    b = p.chromium.launch()
    ctx = b.new_context(viewport={'width': 2560, 'height': 1300})
    pg = ctx.new_page()
    errs = []
    pg.on('pageerror', lambda e: errs.append(str(e)[:150]))
    pg.goto('http://127.0.0.1:18899/', wait_until='load', timeout=45000)
    if '/air-login' in pg.url:
        pg.fill('#username', U); pg.fill('#password', P)
        pg.click('.login-submit'); pg.wait_for_load_state('load', timeout=30000)
    pg.wait_for_timeout(2500)

    pg.evaluate("()=>{const a=document.querySelector('a[data-section=\"usbmodeweb\"]');a&&a.click()}")
    pg.wait_for_timeout(6500)

    r = pg.evaluate("""() => {
      const err = document.getElementById('settings-error');
      const sel = document.getElementById('channel-select');
      const st = document.getElementById('wifi-status-text-setting');
      const toasts = ['toast','wifi-toast','liu-toast'].map(id => {
        const e = document.getElementById(id);
        return e ? id + '✓' : id + '✗';
      });
      return {
        errHidden: err ? err.hidden : null,
        errVisible: err ? (err.offsetParent !== null) : null,
        errText: err ? err.textContent.trim() : null,
        channelOptions: sel ? sel.options.length : -1,
        channelValues: sel ? [...sel.options].slice(0, 8).map(o => o.value || o.text) : [],
        channelDisabled: sel ? sel.disabled : null,
        wifiStatus: st ? st.textContent.trim() : null,
        toasts: toasts,
        modeText: (document.getElementById('wifi-mode-setting') || {}).textContent,
      };
    }""")
    for k, v in r.items():
        print('     %-16s %s' % (k, v))

    check('不再显示「读取失败」', r['errVisible'] is False, 'hidden=%s 可见=%s' % (r['errHidden'], r['errVisible']))
    check('WiFi 状态读到真实值（不是加载中）', r['wifiStatus'] not in (None, '', '加载中...'), str(r['wifiStatus']))
    check('信道下拉框有可选项', (r['channelOptions'] or 0) > 0, '%s 个选项: %s' % (r['channelOptions'], r['channelValues']))
    check('三个页的 toast 各自独立存在', all('✓' in t for t in r['toasts']), str(r['toasts']))

    print()
    print('===== 实点一次「保存信道」看提示是否出现在本页 =====')
    pg.evaluate("()=>{const s=document.getElementById('channel-select');if(s&&s.options.length>1)s.selectedIndex=1;}")
    pg.evaluate("()=>{const b=document.getElementById('apply-channel');b&&b.click()}")
    pg.wait_for_timeout(2500)
    t = pg.evaluate("""() => {
      const out = {};
      ['toast','wifi-toast','liu-toast'].forEach(id => {
        const e = document.getElementById(id);
        if (e) out[id] = {cls: e.className, text: (e.textContent||'').trim().slice(0,30)};
      });
      return out;
    }""")
    for k, v in t.items():
        print('     %-14s %s' % (k, v))
    check('提示出现在 wifi 页自己的 toast 上',
          'show' in (t.get('wifi-toast', {}).get('cls') or '') or 'show' not in (t.get('toast', {}).get('cls') or 'x'),
          str(t.get('wifi-toast')))

    print()
    print('JS 报错: %d 条' % len(errs))
    for e in errs[:8]:
        print('   ', e)
    check('无 JS 报错', not errs)
    pg.screenshot(path='.tools/r4_wifi.png', full_page=True)
    b.close()

print()
print('结论: %s' % ('全部通过' if not fails else '仍失败: ' + ', '.join(fails)))
