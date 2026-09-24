from pathlib import Path
import threading,http.server,json
from playwright.sync_api import sync_playwright
root=Path(__file__).resolve().parents[1]
class Handler(http.server.SimpleHTTPRequestHandler):
 def __init__(self,*args,**kwargs):super().__init__(*args,directory=str(root/'ui'),**kwargs)
 def log_message(self,*args):pass
server=http.server.ThreadingHTTPServer(('127.0.0.1',0),Handler)
threading.Thread(target=server.serve_forever,daemon=True).start()
from datetime import datetime,timezone
snapshot={'devices':[{'mac':'12:34:56:78:90:ab','online':True,'connected_seconds':3661,'addresses':['192.168.0.2','2001:db8::1'],'note':'<img src=x onerror=alert(1)>','last_seen':datetime.now(timezone.utc).isoformat()}],'sampled_at':datetime.now(timezone.utc).isoformat(),'error':'','address_warning':False,'storage_warning':False}
with sync_playwright() as p:
 browser=p.chromium.launch(headless=True)
 page=browser.new_page(viewport={'width':390,'height':844})
 errors=[];page.on('pageerror',lambda e:errors.append(str(e)))
 def api(route):
  if route.request.method=='PUT':snapshot['devices'][0]['note']=route.request.post_data_json['note'];route.fulfill(json={'saved':True})
  else:route.fulfill(json=snapshot)
 page.route('**/air-api/devices',api)
 page.route('**/air-api/proxy',lambda route:route.fulfill(json={'enabled':False}))
 page.route('**/air-api/traffic',lambda route:route.fulfill(json={'clients':[],'sampled_at':snapshot['sampled_at']}))
 page.goto(f'http://127.0.0.1:{server.server_port}/inner-pages/devices.html')
 page.get_by_text('1 台在线 · 1 台已记录',exact=False).wait_for()
 assert page.locator('.device-card img').count()==0
 assert page.evaluate('document.documentElement.scrollWidth<=innerWidth')
 page.locator('.device-note input').fill('我的手机');page.get_by_role('button',name='保存备注',exact=True).click();page.get_by_text('备注已保存',exact=True).wait_for()
 page.reload();page.get_by_role('heading',name='我的手机',exact=True).wait_for()
 snapshot['error']='热点状态暂不可用，保留上次记录';page.locator('#refresh').click();page.get_by_text('状态未知',exact=True).wait_for()
 page.screenshot(path=str(root/'.tools/devices-mobile.png'),full_page=True)
 assert not errors,errors
 page.set_viewport_size({'width':1366,'height':900});page.screenshot(path=str(root/'.tools/devices-desktop.png'),full_page=True)
 browser.close()
server.shutdown()
print('PASS mobile layout, note save/reload, safe text rendering, stale state; no browser errors')
