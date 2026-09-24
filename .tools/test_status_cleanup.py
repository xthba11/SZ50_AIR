from pathlib import Path
import http.server,threading,json
from playwright.sync_api import sync_playwright
root=Path(__file__).resolve().parents[1]
class Handler(http.server.SimpleHTTPRequestHandler):
 def __init__(self,*a,**kw):super().__init__(*a,directory=str(root/'ui'),**kw)
 def log_message(self,*a):pass
 def translate_path(self,path):
  mapping={'/at-test':'/inner-pages/at-index.html','/js/app.e4a615bb.js':'/at-app.js','/js/chunk-vendors.907bf020.js':'/at-vendors.js','/css/app.54fd2b3f.css':'/at-app.css','/css/chunk-vendors.2c686ef2.css':'/at-vendors.css'}
  path=path.split('?',1)[0];path=mapping.get(path,path.replace('/html/','/inner-pages/',1));return super().translate_path(path)
server=http.server.ThreadingHTTPServer(('127.0.0.1',0),Handler);threading.Thread(target=server.serve_forever,daemon=True).start()
wifi={'wifi_enabled':'on','wifi_mode':'5G','wifi_ssid':'Test Network','wifi_key':'test12345','wifi_channel':'48','wifi_encryption':'wpa2'}
network={'Code':0,'Data':{'Technology':'nr','Network':[{'Band':'78','ARFCN':'633984','PCI':'300','RSRP':'-63','RSRQ':'-1','SINR':'29'}],'Cgeqosrdp':{'Qci':9,'DL':100000,'UL':50000}}}
posts=[]
with sync_playwright() as p:
 browser=p.chromium.launch(headless=True);page=browser.new_page(viewport={'width':390,'height':844});errors=[];page.on('pageerror',lambda e:errors.append(str(e)))
 def cgi(route):
  if route.request.method=='POST':posts.append(route.request.post_data);route.fulfill(json={'success':True,'message':'已保存'})
  else:route.fulfill(json=wifi)
 page.route('**/cgi-bin/traffic.cgi*',cgi)
 page.route('**/api/get/network',lambda r:r.fulfill(json=network))
 page.route('**/api/get/band/info',lambda r:r.fulfill(json={'Code':0,'Data':{'N78':True,'B3':True}}))
 page.route('**/api/get/sysinfo',lambda r:r.fulfill(json={'Code':0,'Data':{'CPU_TEMP':[41000],'POWER_SUPPLY_CAPACITY':80,'POWER_SUPPLY_STATUS':'Charging'}}))
 page.route('**/api/exec/atcmd',lambda r:r.fulfill(json={'Code':0,'Data':'OK'}))
 page.route('**/air-api/monitor',lambda r:r.fulfill(json={'samples':[]}))
 base=f'http://127.0.0.1:{server.server_port}'
 page.goto(base+'/html/z50_air_wifi.html');page.wait_for_function("document.getElementById('ssid-input').value==='Test Network'")
 assert page.locator('.stats-box,#wifi-status-text,#wifi-key-display,#refresh-timer').count()==0
 assert page.locator('#channel-select').input_value()=='48'
 assert page.locator('#switch-mode input').is_checked()
 page.locator('#ssid-input').fill('Test Changed');page.locator('#apply-settings').click();page.get_by_text('已保存',exact=True).wait_for();assert 'action=update_wifi_settings' in posts[-1]
 page.locator('#channel-select').select_option('44');page.locator('#apply-channel').click();page.wait_for_timeout(150);assert posts[-1]=='action=switch_wifi_channel&target_channel=44'
 assert page.evaluate('document.documentElement.scrollWidth<=innerWidth')
 page.screenshot(path=str(root/'.tools/wifi-settings-2.10.png'),full_page=True)
 page.goto(base+'/?page=dashboard');page.wait_for_function("document.getElementById('wifiChannel').textContent==='48'")
 assert page.locator('#wifiEncryption').inner_text()=='WPA2'
 assert page.locator('[data-section="timerebootweb"],#timerebootweb-section').count()==0
 assert '充电管理' not in page.locator('body').inner_text()
 wifi['wifi_channel']='unknown';wifi['wifi_encryption']='none';page.reload();page.wait_for_function("document.getElementById('wifiEncryption').textContent==='开放'")
 assert page.locator('#wifiChannel').inner_text()=='--' and page.locator('#wifiEncryption').inner_text()=='开放'
 page.goto(base+'/at-test');page.get_by_role('tab',name='锁频',exact=True).wait_for()
 assert page.get_by_role('tab',name='状态',exact=True).count()==0
 assert page.get_by_role('tab',name='设置',exact=True).count()==0
 assert page.locator('#pane-info').count()==0
 assert page.get_by_role('tab',name='锁频',exact=True).get_attribute('aria-selected')=='true'
 for name in ['锁基站','调试','锁频']:page.get_by_role('tab',name=name,exact=True).click()
 assert page.evaluate('document.documentElement.scrollWidth<=innerWidth')
 page.screenshot(path=str(root/'.tools/at-tabs-2.10.png'),full_page=True)
 assert not errors,errors
 browser.close()
server.shutdown()
print('PASS Wi-Fi settings load/save/channel (mock only); overview channel/security; charging navigation removed; AT status removed; all remaining AT tabs; no JS errors')
