from pathlib import Path
import re

root=Path(__file__).resolve().parent
original=(root/'templates/overview.html').read_text(encoding='utf-8')
icons={
 'wifi':'<path d="M3 8.5a15 15 0 0 1 18 0M6 12a10 10 0 0 1 12 0M9 15.5a5 5 0 0 1 6 0"/><circle cx="12" cy="19" r=".7"/>',
 'grid':'<rect x="3" y="3" width="7" height="7" rx="2"/><rect x="14" y="3" width="7" height="7" rx="2"/><rect x="3" y="14" width="7" height="7" rx="2"/><rect x="14" y="14" width="7" height="7" rx="2"/>',
 'sim':'<path d="M8 3h9a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6z"/><rect x="8" y="10" width="8" height="7" rx="1"/><path d="M12 10v7M8 13.5h8"/>',
 'battery':'<rect x="2" y="7" width="18" height="10" rx="3"/><path d="M23 10v4M6 10v4M9 10v4M12 10v4"/>',
 'chart':'<path d="M4 4v16h16M8 15l4-5 4 2 4-7"/>',
 'terminal':'<rect x="2" y="4" width="20" height="16" rx="3"/><path d="m6 9 3 3-3 3m7 0h4"/>',
 'code':'<path d="m7 6-5 6 5 6m10-12 5 6-5 6M14 3l-4 18"/>',
 'settings':'<path d="M4 7h16M4 17h16"/><circle cx="9" cy="7" r="3" fill="currentColor" stroke="none"/><circle cx="16" cy="17" r="3" fill="currentColor" stroke="none"/>',
 'signal':'<path d="M4 19v-3m5 3v-7m5 7V8m5 11V4"/>',
 'temp':'<path d="M9 14.5V5a3 3 0 0 1 6 0v9.5a5 5 0 1 1-6 0Z"/><path d="M12 7v10"/><circle cx="12" cy="18" r="1.5"/>',
 'arrow':'<path d="M5 12h14m-5-5 5 5-5 5"/>',
 'refresh':'<path d="M20 10a8 8 0 0 0-14-4L3 9m0-6v6h6m-5 5a8 8 0 0 0 14 4l3-3m0 6v-6h-6"/>',
 'shield':'<path d="M12 2 3 6v5c0 6 9 11 9 11s9-5 9-11V6Z"/><path d="m8 12 3 3 5-6"/>',
 'menu':'<path d="M4 6h16M4 12h16M4 18h16"/>',
 'tower':'<circle cx="12" cy="7" r="2"/><path d="m12 9-4 12m4-12 4 12M9 17h6M6 3a8 8 0 0 0 0 8m12-8a8 8 0 0 1 0 8"/>',
 'chip':'<rect x="5" y="5" width="14" height="14" rx="3"/><path d="M9 2v3m6-3v3M9 19v3m6-3v3M2 9h3m-3 6h3m14-6h3m-3 6h3"/><rect x="9" y="9" width="6" height="6" rx="1"/>'}
def icon(name):return f'<svg class="icon" aria-hidden="true"><use href="#i-{name}"/></svg>'
def heading(name,title,sub=''):return f'<div class="card-heading">{icon(name)}<div><div class="card-title">{title}</div>'+ (f'<div class="card-subtitle">{sub}</div>' if sub else '')+'</div></div>'
sections=[('dashboard','grid','网络概览'),('clashweb','sim','网络与 SIM'),('usbmodeweb','wifi','Wi-Fi 设置'),('devices','wifi','连接设备'),('monitor','temp','设备监测'),('tfcweb','chart','流量管理'),('atweb','settings','AT 控制台'),('terminalweb','terminal','网页终端'),('atcommand','code','快捷调试'),('clashui','chip','系统设置')]
symbols='<svg class="symbol-library" aria-hidden="true">'+''.join(f'<symbol id="i-{name}" viewBox="0 0 24 24">{drawing}</symbol>' for name,drawing in icons.items())+'</svg>'
navigation=''
for i,(key,ico,label) in enumerate(sections):
 if i in (0,6):navigation+='<li class="nav-caption">'+('工作台' if i==0 else '设备工具')+'</li>'
 navigation+=f'<li><a href="#{key}" data-section="{key}">{icon(ico)}<span>{label}</span></a></li>'
stats=''
for label,id_,ico,color,sub in [('蜂窝网络','technology','signal','','当前无线接入制式'),('信号强度','RSRP','wifi','mint','RSRP · 接收信号功率'),('设备温度','temperature','temp','amber','主处理器温度'),('电池电量','batteryLevel','battery','violet','设备当前剩余电量')]:
 stats+=f'<div class="stat-card"><div class="stat-top"><span>{label}</span><span class="stat-icon {color}">{icon(ico)}</span></div><div class="stat-value" id="{id_}">--</div></div>'
body=f'''{symbols}
<aside class="sidebar" id="sidebar" aria-label="主导航">
 <a class="brand" href="#dashboard" data-section="dashboard"><span class="brand-mark">{icon('wifi')}</span><div><strong>SZ50 <span>AIR</span></strong></div></a>
 <ul class="nav-menu">{navigation}</ul>
</aside><div id="overlay" class="overlay" aria-hidden="true"></div>
<main class="main-content"><div class="content-wrapper">
 <header class="topbar"><button class="icon-button mobile-menu-btn" id="menu-toggle" aria-label="打开导航菜单" aria-expanded="false" aria-controls="sidebar">{icon('menu')}</button><div class="breadcrumbs"><span>工作台</span><span>/</span><strong id="page-location">网络概览</strong></div><div class="toolbar"><span class="freshness" id="data-freshness" role="status">正在读取设备</span><button class="icon-button" id="refresh-page" title="刷新状态" aria-label="刷新状态">{icon('refresh')}</button><div class="avatar"><b>A</b><span>管理员</span></div></div></header>
 <section id="dashboard-section">
  <div class="page-heading"><h1>网络概览</h1></div>
  <div class="connection-banner compact"><div class="connection-copy"><span class="status-inline" id="networkStatus">读取中</span></div><div class="connection-actions"><button class="btn primary" data-section="usbmodeweb">{icon('wifi')}Wi-Fi 设置</button><button class="btn" data-section="clashweb">网络设置</button></div></div>
  <div class="quick-actions">{stats}</div>
  <div class="cards-grid">
   <article class="info-card"><div class="card-header">{heading('wifi','无线连接')}<span class="pill" id="wifiSwitchStatus">读取中</span></div><div class="wifi-identity"><div><div class="wifi-name" id="wifiSsid">--</div></div><span class="wifi-glyph">{icon('wifi')}</span></div><table class="info-table"><tr><td>Wi-Fi 频段</td><td id="wifiBand">--</td></tr><tr><td>当前信道</td><td id="wifiChannel">--</td></tr><tr><td>加密方式</td><td id="wifiEncryption">--</td></tr><tr><td>连接密码</td><td><span id="wifiPassword" class="secret-value">--</span><button id="reveal-password" class="reveal-btn" aria-pressed="false">显示</button></td></tr><tr><td>运营商</td><td id="ISP">--</td></tr><tr><td>SIM 卡状态</td><td id="simStatus">--</td></tr></table><button id="share-wifi" type="button">分享 Wi-Fi</button><details class="device-details"><summary>设备标识</summary><table class="info-table"><tr><td>IMEI</td><td id="imei">--</td></tr><tr><td>ICCID</td><td id="iccid">--</td></tr></table></details></article>
   <article class="info-card"><div class="card-header">{heading('signal','蜂窝信号')}<button class="text-link" data-section="clashweb">网络设置{icon('arrow')}</button></div><div class="signal-metrics"><div><small>频段 BAND</small><b id="Band">--</b></div><div><small>小区 PCI</small><b id="PCI">--</b></div><div><small>频道 ARFCN</small><b id="ARFCN">--</b></div></div>
    <div id="signal-trends" class="signal-trends"></div><p id="signal-history-status" class="trend-error" role="status" hidden></p>
   </article>
  </div>
  <div class="cards-grid secondary-grid">
   <article class="info-card"><div class="card-header">{heading('battery','电源与内存')}</div><table class="info-table"><tr><td>供电状态</td><td id="chargeStatus">--</td></tr><tr><td>当前电流</td><td id="currentNow">--</td></tr></table><div class="memory-box"><div class="signal-label"><span>可用内存 / 总量</span><span id="memory-text">--</span></div><div class="meter-track"><div class="meter-fill" id="memory-bar"></div></div></div></article>
   <article class="info-card"><div class="card-header">{heading('temp','温度监控')}</div><table class="info-table"><tbody id="tempTableBody"><tr><td>传感器</td><td>读取中</td></tr></tbody></table><p class="caption">设备传感器实时读数</p></article>
   <article class="info-card"><div class="card-header">{heading('chart','签约速率')}<span class="pill neutral">套餐参数</span></div><table class="info-table"><tr><td>下行上限</td><td id="dl">--</td></tr><tr><td>上行上限</td><td id="ul">--</td></tr><tr><td>服务等级 QCI</td><td id="qci">--</td></tr></table><p class="caption">运营商返回的签约参数，不代表实时网速。</p></article>
  </div>
  <article class="info-card nearby-card"><div class="card-header">{heading('tower','基站列表')}<span id="technology2"></span></div><div class="table-scroll" tabindex="0" role="region" aria-label="附近基站数据，可横向滚动"><table class="network-table"><thead><tr><th>BAND <small>频段</small></th><th>ARFCN <small>频道</small></th><th>PCI <small>小区</small></th><th>RSRP <small>强度</small></th><th>RSRQ <small>质量</small></th><th>SINR <small>信噪比</small></th></tr></thead><tbody id="networkTableBody"><tr><td colspan="6">正在读取小区信息…</td></tr></tbody></table></div></article>
 </section>
'''
# Consolidate the existing status cards instead of duplicating the AT dashboard.
start=body.index('  <div class="cards-grid secondary-grid">')
end=body.index('  <article class="info-card nearby-card">',start)
body=body[:start]+(root/'overview_cards.html').read_text(encoding='utf-8')+body[end:]
contract='<div class="cell-contract"><div><small>签约下行上限</small><b id="dl">--</b></div><div><small>签约上行上限</small><b id="ul">--</b></div><div><small>服务等级 QCI</small><b id="qci">--</b></div></div>'
body=body.replace('<div id="signal-trends"',contract+'<div id="signal-trends"',1)
body=body.replace("蜂窝信号","蜂窝网络与基站").replace("附近基站","基站列表").replace("当前网络报告的小区信息","汇总设备报告的小区，频段、频道与信号集中查看")
body=body.replace('设备温度','基带温度').replace('主处理器温度','首个基带传感器读数')
at=re.search(r'<!-- AT命令模块 -->(.*?)<!-- 其他模块 -->',original,re.S).group(1)
at=at.replace('style="display:none"','hidden',1).replace('<div class="info-card">','<div class="panel-heading"><h2>快捷调试</h2></div><div class="info-card">',1)
body+=at
frames={'monitor':('设备监测','资源状态与温度历史','/html/monitor.html'), 'devices':('连接设备','在线状态、IP 与设备备注','/html/devices.html'), 'atweb':('AT 控制台','设备参数与 AT 调试工具','8080'), 'terminalweb':('网页终端','在浏览器中使用设备终端','7681'),'clashweb':('网络与 SIM','管理网络模式与 SIM 卡槽','/html/sim.html'),'usbmodeweb':('Wi-Fi 设置','管理无线连接与热点配置','/html/z50_air_wifi.html'),'tfcweb':('流量管理','查看流量使用与统计配置','/html/liuliang.html'),'clashui':('系统设置','设备运行与系统管理','/html/system.html')}
for name,(title,subtitle,src) in frames.items():
 body+=f'<section id="{name}-section" hidden><div class="panel-heading"><h2>{title}</h2></div><div class="info-card frame-card"><iframe id="{name}" data-target="{src}" title="{title}" height="800"></iframe></div></section>'
body+='</div></main>'
imei=re.search(r'function setImei\(type\).*?(?=</script>)',original,re.S).group(0)
metrics=original.split('// 完整的JavaScript代码',1)[1].split('</script>',1)[0]
metrics='// 完整的JavaScript代码'+metrics
metrics=metrics.replace("const wifiBaseUrl = 'http://' + window.location.hostname + ':80/';", "const wifiBaseUrl = window.location.origin + '/';")
metrics=metrics.replace("technology == 'nr5g'", "technology == 'nr5g' || technology == 'nr'")
metrics=metrics.replace('technology.toUpperCase()',"String(technology || '--').toUpperCase()")
metrics=metrics.replace("document.getElementById('technology2').innerHTML = technologyDisplay;", "document.getElementById('technology2').innerHTML = technologyDisplay;\n            window.airDataUpdated();")
metrics=metrics.replace("console.error('fetchNetwork err', error);", "window.airDataFailed(); console.error('fetchNetwork err', error);")
metrics=metrics.replace('✓ 已联网','签约信息已获取').replace('× 疑似断网','签约信息暂不可用')
for name in ('wifiSsid','wifiPassword'):
 metrics=metrics.replace(name+'.innerHTML =',name+'.textContent =')
metrics=metrics.replace('if (sysData.POWER_SUPPLY_CAPACITY) {','if (sysData.POWER_SUPPLY_CAPACITY != null) {')
metrics=metrics.replace('if (sysData.POWER_SUPPLY_CURRENT_NOW) {','if (sysData.POWER_SUPPLY_CURRENT_NOW != null) {')
# Current hotspot channel and encryption are shown only in the overview.
metrics=metrics.replace('function updateWifiDisplay(wifiData) {', "function updateWifiDisplay(wifiData) {\n        document.getElementById('wifiChannel').textContent = wifiData.wifi_channel && wifiData.wifi_channel !== 'unknown' ? wifiData.wifi_channel : '--';\n        const security = String(wifiData.wifi_encryption || '').toLowerCase();\n        document.getElementById('wifiEncryption').textContent = ({none:'开放',wpa:'WPA',wpa2:'WPA2'})[security] || (security && security !== 'unknown' ? security.toUpperCase() : '--');")
metrics=metrics.replace("document.getElementById('wifiBand').innerHTML = '--';", "document.getElementById('wifiBand').innerHTML = '--';document.getElementById('wifiChannel').textContent='--';document.getElementById('wifiEncryption').textContent='--';")
# Share the existing system poll with all new system and battery fields.
metrics=re.sub(r'    function fetchTempData\(\).*?(?=    function fetchNetwork)', '', metrics, flags=re.S)
metrics=metrics.replace('fetchTempData();','')
system_poll="""    function fetchSysInfo() {
        fetch(baseUrl + 'api/get/sysinfo').then(response => {
            if (!response.ok) throw new Error('System status unavailable');
            return response.json();
        }).then(data => {
            if (data.Code !== 0 || !data.Data) throw new Error('System status unavailable');
            window.airRenderSystem(data.Data);
        }).catch(() => window.airSystemFailed());
    }

"""
metrics=re.sub(r'    function fetchSysInfo\(\).*?(?=    // AT命令发送)',lambda _:system_poll,metrics,flags=re.S)
# Signal history replaces the old percentage bars.
metrics=metrics.replace('                updateRSRPDisplay(rsrpValue);','')
metrics=re.sub(r'                let rsrqPercent.*?sinrPercent}%`;\n','',metrics,flags=re.S)
metrics=re.sub(r'function updateRSRPDisplay\(rsrpValue\) \{.*?(?=function getIMEI\(\))','',metrics,flags=re.S)
frame_setup="document.querySelectorAll('iframe[data-target]').forEach(frame=>{const target=frame.dataset.target;if(target.startsWith('/')){frame.dataset.src=target}else{const url=new URL(window.location.origin);url.port=target;frame.dataset.src=url.origin+'/';}});"
html='<!DOCTYPE html><html lang="zh-CN"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><meta name="theme-color" content="#f5f7fb"><title>网络概览 · SZ50 AIR</title><link rel="stylesheet" href="/layui/css/layui.css"><link rel="stylesheet" href="/air-ui.css?v=2.13"><link rel="stylesheet" href="/air-overview.css?v=2.3"><link rel="stylesheet" href="/air-monitor.css?v=2.13"><link rel="stylesheet" href="/air-trend.css?v=2.13"><script src="/layui/layui.js"></script></head><body>'+body+'<script>'+frame_setup+'</script><script src="/air-ui.js?v=2.13"></script><script src="/air-overview.js?v=2.9"></script><script src="/air-trend.js?v=2.13"></script><script src="/air-signal.js?v=2.9"></script><script src="/vendor/qrcode.js"></script><script src="/vendor/qrcode_UTF8.js"></script><script src="/air-share.js?v=2.9"></script><script>'+imei+'</script><script>'+metrics+'</script></body></html>'
ids=re.findall(r'\bid="([^"]+)"',html)
assert len(ids)==len(set(ids)), 'Duplicate IDs'
required=set(re.findall(r"getElementById\('([^']+)'\)",metrics))
assert required<=set(ids),required-set(ids)
(root/'index.html').write_bytes(html.encode('utf-8'))
print('Built UI:',len(html.encode('utf-8')),'bytes;',len(ids),'unique element IDs')
