from pathlib import Path
import re,json
root=Path(__file__).resolve().parent
out=root/'inner-pages';out.mkdir(exist_ok=True)
pages={
'sim.html':('sim','NETWORK & SIM','网络与 SIM','查看当前接入状态，管理 SIM 卡槽与网络模式。'),
'z50_air_wifi.html':('wifi','WIRELESS SETTINGS','Wi-Fi 设置','管理热点名称、连接密码与无线频段。'),
'liuliang.html':('liuliang','DATA USAGE','流量管理','查看用量统计，管理流量上限与相关服务。'),
'system.html':('system','DEVICE CONTROL','系统设置','设备电源与运行管理。'),
'band.html':('band','RADIO BANDS','频段信息','查看设备支持与启用的无线频段。')}
reports=[]
def scripts(text):return re.findall(r'<script\b[^>]*>.*?</script>',text,re.S)
for filename,(kind,kicker,title,subtitle) in pages.items():
 original=(root/'templates/settings'/filename).read_text(encoding='utf-8');s=original
 s=s.replace('</head>','<link rel="stylesheet" href="/air-inner.css?v=2.18"><script>if(window.self!==window.top)document.documentElement.classList.add("air-embedded");</script></head>',1)
 s=re.sub(r'<body([^>]*)>',lambda m:f'<body{m.group(1)} class="air-inner" data-page="{kind}">',s,count=1)
 s=re.sub(r'<meta name="viewport"[^>]*>', '<meta name="viewport" content="width=device-width,initial-scale=1">',s,count=1)
 old_heading=re.search(r'<h1\b[^>]*>.*?</h1>',s,re.S)
 # Keep existing heading nodes, including IDs used by the original status scripts.
 heading=old_heading.group(0) if old_heading else '<h1>'+title+'</h1>'
 if kind=='system':heading='<h1>系统设置</h1>'
 header=f'<header class="air-page-header">{heading}</header>'
 if old_heading:s=s[:old_heading.start()]+header+s[old_heading.end():]
 elif '<div class="container">' in s:s=s.replace('<div class="container">','<div class="container">'+header,1)
 else:s=re.sub(r'(<body[^>]*>)',r'\1'+header,s,count=1)
 if kind=='system':
  s=s.replace(header,'<div class="air-system-shell">'+header,1)
  s=s.replace('<!-- 顶部下拉确认对话框 -->','<p class="air-system-note">重启或关机会断开连接。</p></div><!-- 顶部下拉确认对话框 -->',1)
  for cls,title_,description,cta,drawing in [
   ('reboot-btn','重启设备','重新启动系统与网络服务，完成后可重新连接。','选择重启 →','<path d="M20 10a8 8 0 1 0-1 7M20 4v6h-6"/>'),
   ('shutdown-btn','关闭设备','结束当前运行并关闭设备，需要手动重新开机。','选择关机 →','<path d="M12 2v10M6 5a9 9 0 1 0 12 0"/>')]:
   pattern=r'(<button class="btn '+cls+r'"[^>]*>).*?(</button>)'
   replacement=f'<span class="air-action-icon"><svg viewBox="0 0 24 24" aria-hidden="true">{drawing}</svg></span><span class="air-action-copy"><strong>{title_}</strong></span>'
   s=re.sub(pattern,lambda m:m.group(1)+replacement+m.group(2),s,count=1,flags=re.S)
  s=s.replace('<div class="dialog">','<div class="dialog" role="dialog" aria-modal="true" aria-labelledby="dialog-title">',1)
 s=s.replace('</body>','<script src="/air-embed.js?v=2.5"></script></body>')
 original_scripts=scripts(original)
 assert all(script in s for script in original_scripts),filename+' script changed'
 ids=lambda text:re.findall(r'\bid="([^"]+)"',text)
 assert sorted(ids(s))==sorted(ids(original)),filename+' IDs changed'
 handlers=lambda text:re.findall(r'\bon(?:click|change|input)="[^"]*"',text)
 assert sorted(handlers(s))==sorted(handlers(original)),filename+' handlers changed'
 (out/filename).write_bytes(s.encode('utf-8'))
 reports.append({'file':filename,'original_scripts_preserved':len(original_scripts),'ids_preserved':len(ids(original))})
at=(root/'templates/at.html').read_text(encoding='utf-8')
at_new=at.replace('</head>','<link rel="stylesheet" href="/air-inner.css?v=2.18"></head>',1).replace('<body>','<body class="air-inner" data-page="at">',1)
at_new=at_new.replace('</head>','<link rel="stylesheet" href="/air-at.css?v=2.16"></head>')
assert scripts(at_new)==scripts(at)
at_new=at_new.replace('</body>','<script src="/air-embed.js?v=2.5"></script></body>')
at_new=at_new.replace('/js/app.e4a615bb.js"','/js/app.e4a615bb.js?v=2.15"')
(out/'at-index.html').write_bytes(at_new.encode('utf-8'))
(out/'preservation-check.json').write_text(json.dumps(reports,indent=2),encoding='utf-8')
print('Built settings pages and AT skin; original scripts, IDs and handlers preserved.')

# Device management, monitor, speedtest, proxy and charge are maintained as source templates.
(out/"devices.html").write_bytes((root/"templates/settings/devices.html").read_bytes())

(out/"monitor.html").write_bytes((root/"templates/settings/monitor.html").read_bytes())
(out/"speedtest.html").write_bytes((root/"templates/settings/speedtest.html").read_bytes())
(out/"proxy.html").write_bytes((root/"templates/settings/proxy.html").read_bytes())
(out/"charge.html").write_bytes((root/"templates/settings/charge.html").read_bytes())


