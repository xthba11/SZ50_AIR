from pathlib import Path
import threading,http.server,datetime,cv2,json,numpy as np
from playwright.sync_api import sync_playwright
root=Path(__file__).resolve().parents[1]
class Handler(http.server.SimpleHTTPRequestHandler):
 def __init__(self,*args,**kwargs):super().__init__(*args,directory=str(root/'ui'),**kwargs)
 def log_message(self,*args):pass
server=http.server.ThreadingHTTPServer(('127.0.0.1',0),Handler);threading.Thread(target=server.serve_forever,daemon=True).start()
now=datetime.datetime.now(datetime.timezone.utc)
data={'samples':[{'at':(now-datetime.timedelta(seconds=5*(3-i))).isoformat(),'cpu_percent':25.5,'memory':{'total_bytes':209376*1024,'available_bytes':84528*1024},'storage':{'total_bytes':45300*1024,'available_bytes':20344*1024},'uptime_seconds':12345,'temperatures':{'soc-thmzone (thermal_zone0)':40+i,'battery (thermal_zone10)':35+i/10},'battery_percent':15,'charging':'Discharging','errors':[]} for i in range(4)]}
wifi={'wifi_enabled':'on','wifi_ssid':'我的 WiFi;,:\\"','wifi_key':'p;,:\\"123456','wifi_encryption':'wpa2'}
with sync_playwright() as p:
 browser=p.chromium.launch(headless=True);page=browser.new_page(viewport={'width':390,'height':844});errors=[];page.on('pageerror',lambda e:errors.append(str(e)))
 page.route('**/air-api/monitor',lambda route:route.fulfill(json=data))
 page.goto(f'http://127.0.0.1:{server.server_port}/inner-pages/monitor.html')
 page.get_by_text('25.5%',exact=True).wait_for();assert page.locator('#battery-alert').is_visible();assert page.locator('#temperature-trends .trend-row').first.locator('circle.trend-dot').count()==4
 assert page.evaluate('document.documentElement.scrollWidth<=innerWidth')
 assert page.locator('#temperature-trends .trend-value').nth(1).inner_text()=='35.3 °C'
 page.screenshot(path=str(root/'.tools/monitor-mobile.png'),full_page=True)
 data['samples'][-1]['charging']='Charging';page.get_by_role('button',name='刷新').click();page.wait_for_function("document.getElementById('battery-alert').hidden")
 page.route('**/air-api/monitor',lambda route:route.fulfill(status=503,body='unavailable'))
 page.get_by_role('button',name='刷新').click();page.wait_for_function("document.getElementById('cpu-value').textContent==='—'")
 page.route('**/share-test',lambda route:route.fulfill(content_type='text/html',body='<html><meta charset="utf-8"><button id="share-wifi">Share</button></html>'))
 page.goto(f'http://127.0.0.1:{server.server_port}/share-test')
 page.route('**/cgi-bin/traffic.cgi?action=get_wifi',lambda route:route.fulfill(json=wifi))
 for script in ['vendor/qrcode.js','vendor/qrcode_UTF8.js','air-share.js']:page.add_script_tag(path=str(root/'ui'/script))
 page.add_style_tag(path=str(root/'ui/air-monitor.css'))
 page.locator('#share-wifi').click();page.locator('.qr-code svg').wait_for();page.locator('.qr-code svg').screenshot(path=str(root/'.tools/qr-fixture.png'))
 decoded,_,_=cv2.QRCodeDetector().detectAndDecode(cv2.imdecode(np.frombuffer((root/'.tools/qr-fixture.png').read_bytes(),dtype=np.uint8),cv2.IMREAD_COLOR))
 esc=lambda value:''.join('\\'+c if c in '\\;,:"' else c for c in value)
 expected='WIFI:T:WPA;S:'+esc(wifi['wifi_ssid'])+';P:'+esc(wifi['wifi_key'])+';;'
 assert decoded==expected,(repr(decoded),repr(expected))
 page.get_by_role('button',name='关闭',exact=True).click();assert page.locator('.qr-code svg').count()==0
 wifi['wifi_encryption']='none';wifi['wifi_key']='';page.locator('#share-wifi').click();page.locator('.qr-code svg').wait_for();page.keyboard.press('Escape');assert page.locator('.qr-code svg').count()==0
 wifi['wifi_encryption']='unknown';page.locator('#share-wifi').click();page.get_by_text('暂不支持当前加密方式的二维码',exact=True).wait_for();assert page.locator('.qr-code svg').count()==0
 assert not errors,errors
 browser.close()
server.shutdown()
print('PASS monitor mobile/chart/sensor/low-battery/error; QR decoded with Chinese and special characters; open network; close clears; unknown encryption rejected')
