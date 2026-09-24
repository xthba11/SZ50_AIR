import subprocess, json, os, time
from playwright.sync_api import sync_playwright

ADB = r'原始工具\SZ50_AIR一键破解\adb.exe'
subprocess.run([ADB, 'forward', 'tcp:18899', 'tcp:18080'], capture_output=True)
creds = json.loads(subprocess.run([ADB, 'shell', 'cat /home/root/admin-auth/credentials.json'], capture_output=True, text=True).stdout)
U, P = creds['username'], creds['password']

SECTIONS = [
    ('dashboard', '网络概览'),
    ('monitor', '状态监测'),
    ('clashweb', '网络与SIM'),
    ('usbmodeweb', 'WiFi设置'),
    ('devices', '连接设备'),
    ('tfcweb', '流量管理'),
    ('proxyweb', '代理设置'),
    ('chargeweb', '电池设置'),
    ('atweb', 'AT控制台'),
    ('terminalweb', '网页终端'),
    ('atcommand', '快捷调试'),
    ('clashui', '系统设置'),
]

os.makedirs('.tools/audit_shots', exist_ok=True)

with sync_playwright() as p:
    browser = p.chromium.launch()
    
    # 1. 桌面端全覆盖体检 (1920x1080 & 2560x1300)
    for vp_name, width, height in [('pc_1080p', 1920, 1080), ('mobile_iphone', 390, 844)]:
        ctx = browser.new_context(viewport={'width': width, 'height': height}, is_mobile=(width<500), has_touch=(width<500))
        page = ctx.new_page()
        page_errors = []
        page.on('pageerror', lambda e: page_errors.append(str(e)))
        console_warns = []
        page.on('console', lambda msg: console_warns.append(f"[{msg.type}] {msg.text}") if msg.type in ['error', 'warn'] else None)

        print(f"\n==================== 测试视口: {vp_name} ({width}x{height}) ====================")
        page.goto('http://127.0.0.1:18899/', wait_until='load', timeout=30000)
        if '/air-login' in page.url:
            page.fill('#username', U)
            page.fill('#password', P)
            page.click('.login-submit')
            page.wait_for_load_state('load', timeout=30000)
        page.wait_for_timeout(2000)

        for sec_id, sec_name in SECTIONS:
            # 切换板块
            page.evaluate(f"""(s) => {{
                const a = document.querySelector(`.nav-menu a[data-section="${{s}}"]`);
                if (a) a.click();
            }}""", sec_id)
            page.wait_for_timeout(1800)

            # 诊断检查
            metrics = page.evaluate(f"""(s) => {{
                const sec = document.getElementById(s + '-section');
                if (!sec) return {{ exists: false }};
                const r = sec.getBoundingClientRect();
                
                // 检查水平溢出（横向滚动条产生者）
                const docWidth = document.documentElement.clientWidth;
                const overflows = [];
                sec.querySelectorAll('*').forEach(el => {{
                    const er = el.getBoundingClientRect();
                    if (er.right > docWidth + 2 && er.width > 0) {{
                        overflows.push({{ tag: el.tagName, cls: el.className.slice(0, 30), right: Math.round(er.right), docW: docWidth }});
                    }}
                }});

                // 检查按钮和输入框是否样式正常
                const brokenBtns = [];
                sec.querySelectorAll('button, .btn, input').forEach(el => {{
                    const cs = getComputedStyle(el);
                    const er = el.getBoundingClientRect();
                    if (er.width > 0 && er.height > 0) {{
                        if (cs.color === cs.backgroundColor) brokenBtns.push({{ tag: el.tagName, text: el.textContent.trim().slice(0, 10), issue: 'color-matches-bg' }});
                    }}
                }});

                // 检查文字重叠或截断隐患
                return {{
                    exists: true,
                    hidden: sec.hidden || getComputedStyle(sec).display === 'none',
                    rect: {{ x: Math.round(r.x), y: Math.round(r.y), w: Math.round(r.width), h: Math.round(r.height) }},
                    overflowCount: overflows.length,
                    overflows: overflows.slice(0, 3),
                    brokenCount: brokenBtns.length,
                    brokenBtns: brokenBtns.slice(0, 3)
                }};
            }}""", sec_id)

            screenshot_path = f".tools/audit_shots/{vp_name}_{sec_id}.png"
            page.screenshot(path=screenshot_path)
            
            status_flag = "OK"
            issues = []
            if not metrics.get('exists'):
                status_flag = "FAIL"
                issues.append("板块DOM不存在")
            elif metrics.get('hidden'):
                status_flag = "WARN"
                issues.append("仍处于隐藏状态")
            if metrics.get('overflowCount', 0) > 0:
                status_flag = "ISSUE"
                issues.append(f"有{metrics['overflowCount']}个元素右侧越界({metrics['overflows']})")
            if metrics.get('brokenCount', 0) > 0:
                status_flag = "ISSUE"
                issues.append(f"按钮/输入框异常: {metrics['brokenBtns']}")

            print(f"[{status_flag:4s}] {sec_name:10s} ({sec_id:12s}): {', '.join(issues) if issues else '渲染良好'}")

        if page_errors:
            print(f"  [PAGE ERRORS]: {len(page_errors)} 个未捕获JS错误: {page_errors[:3]}")
        else:
            print("  [PAGE ERRORS]: 0 个未捕获JS错误")

        ctx.close()

    browser.close()
print("\n体检全部完成，截图存放在 .tools/audit_shots/")
