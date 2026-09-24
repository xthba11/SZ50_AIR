from pathlib import Path
import threading,http.server,datetime,json,math
from playwright.sync_api import sync_playwright
root=Path(__file__).resolve().parents[1]
class Handler(http.server.SimpleHTTPRequestHandler):
 def __init__(self,*args,**kwargs):super().__init__(*args,directory=str(root/'ui'),**kwargs)
 def log_message(self,*args):pass
 def translate_path(self,path):return super().translate_path(path.replace('/html/','/inner-pages/',1))
server=http.server.ThreadingHTTPServer(('127.0.0.1',0),Handler);threading.Thread(target=server.serve_forever,daemon=True).start()
now=datetime.datetime.now(datetime.timezone.utc)
names=['soc-thmzone','apcpu0-thmzone','nrcp-thmzone','apcpu1-thmzone','ank0-thmzone','ank1-thmzone','cluster0-thmzone','pa-thmzone','pa5g-thmzone','battery-thmzone','battery']
samples=[]
for i in range(35):
 temps={f'{name} (thermal_zone{j})':round(37+j*.4+math.sin(i/3+j),3) for j,name in enumerate(names)}
 if i==14:temps.pop('soc-thmzone (thermal_zone0)')
 signal=None if i==20 else {'cell':'nr|78|123|'+('1' if i<26 else '2'),'rsrp':-70+math.sin(i/2)*3,'rsrq':-10+math.sin(i/3),'sinr':20+math.sin(i/4)*2}
 samples.append({'at':(now-datetime.timedelta(seconds=5*(34-i))).isoformat(),'cpu_percent':25.5,'memory':{'total_bytes':209376*1024,'available_bytes':84528*1024},'storage':{'total_bytes':45300*1024,'available_bytes':20344*1024},'uptime_seconds':12345,'temperatures':temps,'battery_percent':15,'charging':'Discharging','errors':[],'signal':signal,'signal_error':'' if signal else '信号读取失败'})
data={'samples':samples,'interval_seconds':5}
network={'Code':0,'Data':{'Technology':'nr','Network':[{'Band':'78','ARFCN':'633984','PCI':'300','RSRP':'-63.3','RSRQ':'-1.0','SINR':'29.5'}],'Cgeqosrdp':{'Qci':9,'DL':100000,'UL':50000}}}
with sync_playwright() as p:
 browser=p.chromium.launch(headless=True);page=browser.new_page(viewport={'width':390,'height':844});errors=[];page.on('pageerror',lambda e:errors.append(str(e)))
 page.route('**/air-api/monitor',lambda r:r.fulfill(json=data))
 page.route('**/api/get/network',lambda r:r.fulfill(json=network))
 page.route('**/api/get/sysinfo',lambda r:r.fulfill(json={'Code':0,'Data':{'CPU_TEMP':[41000],'POWER_SUPPLY_CAPACITY':70}}))
 page.route('**/api/exec/atcmd',lambda r:r.fulfill(json={'Code':0,'Data':'OK'}))
 page.route('**/cgi-bin/traffic.cgi?*',lambda r:r.fulfill(json={'wifi_enabled':'on','wifi_ssid':'Test Wi-Fi','wifi_key':'test12345','wifi_encryption':'wpa2','wifi_mode':'5G','sim_status':'SIM2'}))
 base=f'http://127.0.0.1:{server.server_port}'
 page.goto(base+'/inner-pages/monitor.html');page.get_by_text('25.5%',exact=True).wait_for()
 assert page.locator('#temperature-trends .trend-row').count()==11
 assert page.locator('#temperature-trends svg text, #temperature-trends svg line').count()==0
 assert page.locator('#temperature-trends .trend-row').nth(1).locator('circle.trend-dot').count()==30
 assert page.locator('#temperature-trends .trend-row').first.locator('circle.trend-dot').count()==29
 assert page.locator('#temperature-trends .trend-row').first.locator('path.trend-line').count()==2
 assert page.locator('#sensor, #sensor-list, #temperature-chart').count()==0
 assert page.evaluate('document.documentElement.scrollWidth<=innerWidth')
 page.screenshot(path=str(root/'.tools/trends-mobile.png'),full_page=True)
 page.set_viewport_size({'width':1366,'height':900});page.screenshot(path=str(root/'.tools/trends-desktop.png'),full_page=True)
 page.set_viewport_size({'width':390,'height':844});page.goto(base+'/?page=dashboard');page.locator('#signal-trends circle').first.wait_for()
 assert page.locator('#signal-trends .trend-row').count()==3
 assert page.locator('#signal-trends .trend-row').first.locator('circle.trend-dot').count()==29
 assert page.locator('#signal-trends .trend-row').first.locator('path.trend-line').count()==3
 assert page.locator('#signal-trends svg text, #signal-trends svg line').count()==0
 assert page.get_by_text('基带与运行',exact=True).count()==0
 assert page.locator('#memory-text,#tempTableBody,#rsrp-bar,#rsrq-bar,#sinr-bar').count()==0
 assert page.evaluate('document.documentElement.scrollWidth<=innerWidth')
 page.screenshot(path=str(root/'.tools/overview-clean-mobile.png'),full_page=True)
 page.set_viewport_size({'width':1366,'height':900});page.screenshot(path=str(root/'.tools/overview-clean-desktop.png'),full_page=True)
 assert not errors,errors
 # Failures keep historical curves but never present a stale reading as current.
 page.goto(base+'/inner-pages/monitor.html');page.locator('#temperature-trends .trend-row').first.wait_for();page.route('**/air-api/monitor',lambda r:r.fulfill(status=503,body='unavailable'));page.get_by_role('button',name='刷新').click();page.wait_for_function("document.getElementById('cpu-value').textContent==='—'")
 assert set(page.locator('.trend-value').all_text_contents())=={'—'}
 assert page.locator('#temperature-trends circle').count()>0
 browser.close()
server.shutdown()
print('PASS 11 temperature rows; 3 signal rows; 30-point cap; no axes; gaps and cell switches; overview removal; mobile/desktop; failure state; no JS errors')
