# -*- coding: utf-8 -*-
"""验证：① 白块半透明 ② 折叠区对齐 ③ 两个卡片已合并且按钮仍可用"""
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

    print('===== ② 折叠区（设备标识 / 更多参数）对齐 =====')
    d = pg.evaluate("""() => {
      const out = [];
      ['设备标识', '更多参数'].forEach(txt => {
        const det = [...document.querySelectorAll('#dashboard-section .device-details')]
                    .find(e => e.querySelector('summary') && e.querySelector('summary').textContent.includes(txt));
        if (!det) { out.push({名称: txt, 结果: '不存在'}); return; }
        det.open = true;
        const card = det.closest('.info-card');
        const sm = det.querySelector('summary'), tb = det.querySelector('table');
        const rs = sm.getBoundingClientRect(), rt = tb.getBoundingClientRect();
        const rc = card.getBoundingClientRect();
        out.push({名称: txt, details显示: getComputedStyle(det).display,
                  卡片宽: Math.round(rc.width), 卡片左: Math.round(rc.left),
                  summary宽: Math.round(rs.width), summary左: Math.round(rs.left),
                  表格宽: Math.round(rt.width), 表格左: Math.round(rt.left),
                  左对齐: Math.abs(rs.left - rt.left) <= 2, 加号右端: getComputedStyle(sm, '::after').content});
      });
      return out;
    }""")
    for x in d:
        print('     %s' % x)
        if '结果' not in x:
            check('%s 展开内容与摘要左对齐' % x['名称'], x['左对齐'], 'summary左=%s 表格左=%s' % (x['summary左'], x['表格左']))
            check('%s 摘要与内容同宽（占满内容区）' % x['名称'],
                  abs(x['summary宽'] - x['表格宽']) <= 2 and x['summary宽'] >= x['卡片宽'] - 90,
                  'summary=%s 表格=%s 卡片=%s(含内边距)' % (x['summary宽'], x['表格宽'], x['卡片宽']))
            check('%s 已改回块级布局' % x['名称'], x['details显示'] == 'block', x['details显示'])

    print()
    print('===== ③ 合并后的「SIM 卡与网络模式」卡片 =====')
    pg.evaluate("()=>{const a=document.querySelector('a[data-section=\"clashweb\"]');a&&a.click()}")
    pg.wait_for_timeout(5000)
    m = pg.evaluate("""() => {
      const sgs = [...document.querySelectorAll('#clashweb-section .container > .setting-group')];
      const target = sgs.find(g => g.textContent.includes('SIM') && g.textContent.includes('网络模式'));
      if (!target) return {错误: '没找到合并后的卡片', 卡片数: sgs.length};
      const r = target.getBoundingClientRect();
      const rows = [...target.querySelectorAll('.control-group')].map(g => {
        const rr = g.getBoundingClientRect();
        return {top: Math.round(rr.top), h: Math.round(rr.height), 标签: (g.querySelector('.setting-label')||{}).textContent,
                按钮: [...g.querySelectorAll('button')].map(b => b.id + (b.disabled ? '(禁用)' : ''))};
      });
      return {卡片数: sgs.length, 合并卡宽: Math.round(r.width), 标题: (target.querySelector('h2')||{}).textContent,
              行: rows, 全部按钮id: [...target.querySelectorAll('button')].map(b => b.id)};
    }""")
    for k, v in m.items():
        print('     %-10s %s' % (k, v))
    need = ['switch-to-sim1', 'switch-to-sim2', 'switch-to-auto', 'switch-to-5g', 'switch-to-4g']
    check('5 个按钮都在合并后的卡片里', all(x in (m.get('全部按钮id') or []) for x in need), str(m.get('全部按钮id')))
    check('两个卡片已合并成一个', m.get('卡片数') == 1 and 'SIM' in str(m.get('标题')), '卡片数=%s 标题=%s' % (m.get('卡片数'), m.get('标题')))

    print()
    print('===== ① 文字周围的白块 → 半透明 =====')
    pg.evaluate("()=>{const a=document.querySelector('a[data-section=\"tfcweb\"]');a&&a.click()}")
    pg.wait_for_timeout(4500)
    t = pg.evaluate("""() => {
      const out = {};
      const c1 = document.querySelector('#tfcweb-section .breakdown-card');
      const c2 = document.querySelector('#tfcweb-section .metric-col');
      out.breakdown = c1 ? getComputedStyle(c1).backgroundColor : '无';
      out.metricCol = c2 ? getComputedStyle(c2).backgroundColor : '无';
      const txt = [...document.querySelectorAll('#tfcweb-section .breakdown-card-body')].map(e => e.textContent.trim().slice(0, 30));
      out.示例文字 = txt.slice(0, 2);
      return out;
    }""")
    for k, v in t.items():
        print('     %-10s %s' % (k, v))
    check('breakdown-card 半透明', 'rgba' in str(t['breakdown']) and ', 1)' not in str(t['breakdown']), str(t['breakdown']))
    check('metric-col 半透明', 'rgba' in str(t['metricCol']) and ', 1)' not in str(t['metricCol']), str(t['metricCol']))

    pg.evaluate("()=>{const a=document.querySelector('a[data-section=\"chargeweb\"]');a&&a.click()}")
    pg.wait_for_timeout(4500)
    q = pg.evaluate("""() => { const e = document.querySelector('.air-charge-tip');
      return e ? {bg: getComputedStyle(e).backgroundColor, 文字: e.textContent.trim().slice(0, 34)} : '无'; }""")
    print('     电池页 tip  %s' % q)
    check('电池页提示条半透明', isinstance(q, dict) and 'rgba' in q['bg'] and ', 1)' not in q['bg'], str(q))

    print()
    print('JS 报错: %d 条' % len(errs))
    for e in errs[:6]:
        print('   ', e)
    check('无 JS 报错', not errs)
    b.close()

print()
print('结论: %s' % ('全部通过' if not fails else '仍失败: ' + ', '.join(fails)))
