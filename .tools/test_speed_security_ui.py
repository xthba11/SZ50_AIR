from pathlib import Path
import http.server,threading,json
from playwright.sync_api import sync_playwright
root=Path(__file__).resolve().parents[1]
class Handler(http.server.SimpleHTTPRequestHandler):
 def __init__(self,*a,**kw):super().__init__(*a,directory=str(root/'ui'),**kw)
 def log_message(self,*a):pass
 def translate_path(self,path):
  mapping={'/at-test':'/inner-pages/at-index.html','/speedtest.html':'/inner-pages/speedtest.html','/js/app.e4a615bb.js':'/at-app.js','/js/chunk-vendors.907bf020.js':'/at-vendors.js','/css/app.54fd2b3f.css':'/at-app.css','/css/chunk-vendors.2c686ef2.css':'/at-vendors.css'}
  path=path.split('?',1)[0];return super().translate_path(mapping.get(path,path.replace('/html/','/inner-pages/',1)))
server=http.server.ThreadingHTTPServer(('127.0.0.1',0),Handler);threading.Thread(target=server.serve_forever,daemon=True).start()
security={'current':'wpa2','requested':'','state':'idle','error':'','available':True,'enabled':True};puts=[]
speed={'state':'idle','phase':'','bytes':0,'budget_bytes':25165824};starts=[]
with sync_playwright() as p:
 browser=p.chromium.launch(headless=True);page=browser.new_page(viewport={'width':390,'height':844});errors=[];page.on('pageerror',lambda e:errors.append(str(e)))
 page.route('**/cgi-bin/traffic.cgi*',lambda r:r.fulfill(json={'wifi_enabled':'on','wifi_mode':'5G','wifi_ssid':'Test','wifi_key':'test12345','wifi_channel':'48','wifi_encryption':'wpa2'}))
 def wifi_api(r):
  if r.request.method=='PUT':puts.append(r.request.post_data_json);security.update(current=r.request.post_data_json['mode'],state='done')
  r.fulfill(json=security)
 page.route('**/air-api/wifi-security',wifi_api)
 def speed_api(r):
  if r.request.method=='POST':starts.append(r.request.post_data_json);speed.update(state='running',phase='download',bytes=100)
  if r.request.method=='DELETE':speed.update(state='cancelled',phase='')
  r.fulfill(json=speed)
 page.route('**/air-api/speedtest',speed_api)
 page.route('**/api/get/network',lambda r:r.fulfill(json={'Code':0,'Data':{'Technology':'nr','Network':[]}}))
 page.route('**/api/get/band/info',lambda r:r.fulfill(json={'Code':0,'Data':{'N78':True}}))
 page.route('**/api/get/sysinfo',lambda r:r.fulfill(json={'Code':0,'Data':{'POWER_SUPPLY_STATUS':'Charging'}}))
 base=f'http://127.0.0.1:{server.server_port}'
 page.goto(base+'/html/z50_air_wifi.html');page.wait_for_function("!document.getElementById('apply-security').disabled")
 assert page.locator('#security-select').input_value()=='wpa2'
 page.locator('#security-select').select_option('wpa');page.once('dialog',lambda d:d.dismiss());page.locator('#apply-security').click();assert not puts
 page.once('dialog',lambda d:d.accept());page.locator('#apply-security').click();page.get_by_text('[已生效]',exact=True).wait_for();assert puts==[{'mode':'wpa','confirm':True}]
 page.locator('#security-select').select_option('none');page.once('dialog',lambda d:d.accept());page.locator('#apply-security').click();page.wait_for_function("document.getElementById('security-select').value==='none'")
 page.goto(base+'/at-test');page.get_by_role('tab',name='调试',exact=True).click();page.get_by_role('button',name='测速',exact=True).click();frame=page.frame_locator('iframe[title="网络测速"]');frame.locator('#speed-start').wait_for();assert not starts
 frame.locator('#speed-start').click();frame.locator('#speed-stop').wait_for();page.wait_for_timeout(100);assert starts==[{'confirm':True}];assert frame.locator('#speed-start').is_disabled()
 frame.locator('#speed-stop').click();frame.get_by_text('已停止',exact=False).wait_for()
 speed.update(state='done',download_mbps=45.6,upload_mbps=12.3,latency_ms=80.5,bytes=25165824,node='TEST');frame.get_by_text('5.70',exact=True).wait_for(timeout=7000)
 assert page.evaluate('document.documentElement.scrollWidth<=innerWidth')
 page.screenshot(path=str(root/'.tools/speed-ui-2.11.png'),full_page=True)
 assert not errors,errors
 browser.close()
server.shutdown()
print('PASS encryption selection, confirmation cancel/apply; speed panel, no autostart, start/stop/results; mobile layout; no JS errors')
