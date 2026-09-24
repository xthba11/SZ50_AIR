# -*- coding: utf-8 -*-
"""验证：输入框浅边框 / 模式按钮选中色 / 保存按钮主色"""
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
    pg.on('pageerror', lambda e: errs.append(str(e)[:140]))
    pg.goto('http://127.0.0.1:18899/', wait_until='load', timeout=45000)
    if '/air-login' in pg.url:
        pg.fill('#username', U); pg.fill('#password', P)
        pg.click('.login-submit'); pg.wait_for_load_state('load', timeout=30000)
    pg.wait_for_timeout(2500)

    print('===== ① SIM 卡切换 / 网络模式切换：能否看出哪个是选中 =====')
    pg.evaluate("()=>{const a=document.querySelector('a[data-section=\"clashweb\"]');a&&a.click()}")
    pg.wait_for_timeout(5000)
    d = pg.evaluate("""() => {
      const target = [...document.querySelectorAll('#clashweb-section .setting-group')]
                     .find(g => g.textContent.includes('SIM') && g.textContent.includes('网络模式'));
      if (!target) return 'none';
      return [...target.querySelectorAll('button')].map(b => {
        const c = getComputedStyle(b);
        return {id: b.id, 文本: b.textContent.trim(), 禁用: b.disabled,
                bg: c.backgroundColor, color: c.color, fw: c.fontWeight};
      });
    }""")
    for x in d:
        print('     %-18s %-10s 禁用=%-5s bg=%-24s color=%s' % (x['id'], x['文本'], x['禁用'], x['bg'], x['color']))
    sel = [x for x in d if x['禁用']]
    unsel = [x for x in d if not x['禁用']]
    check('选中的模式按钮有蓝底蓝字', bool(sel) and all('55, 108, 244' in x['bg'] and '55, 108, 244' in x['color'] for x in sel),
          str([(x['文本'], x['bg']) for x in sel]))
    check('未选中的按钮与选中态可区分', bool(sel) and bool(unsel) and sel[0]['bg'] != unsel[0]['bg'],
          '选中=%s / 未选=%s' % (sel[0]['bg'] if sel else '?', unsel[0]['bg'] if unsel else '?'))

    print()
    print('===== ② Wi-Fi 设置页的保存按钮 =====')
    pg.evaluate("()=>{const a=document.querySelector('a[data-section=\"usbmodeweb\"]');a&&a.click()}")
    pg.wait_for_timeout(5000)
    w = pg.evaluate("""() => {
      const ids = ['apply-settings', 'apply-security', 'apply-channel'];
      return ids.map(id => { const e = document.getElementById(id);
        if (!e) return {id, 结果: '不存在'};
        const c = getComputedStyle(e);
        return {id, 文本: e.textContent.trim(), bg: c.backgroundColor, color: c.color, 禁用: e.disabled}; });
    }""")
    for x in w:
        print('     %-16s %-8s bg=%-26s color=%s' % (x.get('id'), x.get('文本', ''), x.get('bg', ''), x.get('color', '')))
    ok = [x for x in w if x.get('bg') and '55, 108, 244' in x['bg']]
    check('保存按钮都是主色（不是白底）', len(ok) == len([x for x in w if x.get('bg')]), '%d/%d' % (len(ok), len(w)))

    pg.evaluate("()=>{const a=document.querySelector('a[data-section=\"chargeweb\"]');a&&a.click()}")
    pg.wait_for_timeout(4500)
    for s in ['.air-charge-btn-save', '.pwd-save']:
        pg.evaluate("()=>{const a=document.querySelector('a[data-section=\"clashui\"]');a&&a.click()}")
        pg.wait_for_timeout(2500)
        pg.evaluate("()=>{const a=document.querySelector('a[data-section=\"chargeweb\"]');a&&a.click()}")
        pg.wait_for_timeout(2500)
        r = pg.evaluate("(sel)=>{const e=document.querySelector(sel);if(!e)return sel+' → 无';const c=getComputedStyle(e);return sel+' → '+c.backgroundColor+' / '+c.color;}", s)
        print('     %s' % r)
    cb = pg.evaluate("()=>{const e=document.querySelector('.air-charge-btn-save');return e?getComputedStyle(e).backgroundColor:null;}")
    check('电池页保存按钮也是主色', bool(cb) and '55, 108, 244' in cb, str(cb))

    print()
    print('===== ③ 输入框浅边界线 =====')
    pg.evaluate("()=>{const a=document.querySelector('a[data-section=\"tfcweb\"]');a&&a.click()}")
    pg.wait_for_timeout(4000)
    inp = pg.evaluate("""() => {
      const out = [];
      for (const s of ['#tfcweb-section input[type=number]', '#tfcweb-section .layui-input',
                       '#usbmodeweb-section input[type=text]', '#chargeweb-section .air-charge-input',
                       '#devices-section .device-limits input']) {
        const e = document.querySelector(s);
        if (!e) { out.push(s + ' → 无'); continue; }
        const c = getComputedStyle(e);
        out.push(s.split(' ').pop() + ' → ' + c.borderTopWidth + ' ' + c.borderTopColor);
      }
      return out;
    }""")
    for x in inp:
        print('     %s' % x)
    vis = [x for x in inp if '无' not in x and 'rgba(125, 148, 185' in x]
    check('输入框有可见的浅边界线', len(vis) >= 2, '命中 %d 项' % len(vis))

    print()
    print('JS 报错: %d 条' % len(errs))
    for e in errs[:6]:
        print('   ', e)
    check('无 JS 报错', not errs)
    b.close()

print()
print('结论: %s' % ('全部通过' if not fails else '仍失败: ' + ', '.join(fails)))
