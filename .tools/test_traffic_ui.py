from pathlib import Path
import threading, http.server
from playwright.sync_api import sync_playwright
from datetime import datetime, timezone, timedelta

root=Path(__file__).resolve().parents[1]
class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self,*args,**kwargs): super().__init__(*args,directory=str(root/'ui'),**kwargs)
    def log_message(self,*args): pass
server=http.server.ThreadingHTTPServer(('127.0.0.1',0),Handler)
threading.Thread(target=server.serve_forever,daemon=True).start()
now=datetime.now(timezone.utc)
stamp=now.isoformat()
samples=[{'at':(now-timedelta(seconds=(29-i)*2)).isoformat(),'down_bps':(i+1)*125000,'up_bps':(30-i)*25000} for i in range(30)]
devices={'devices':[
 {'mac':'12:c4:6a:d2:17:d6','online':True,'connected_seconds':3661,'addresses':['192.168.0.3'],'note':'iPhone','last_seen':stamp},
 {'mac':'22:85:6b:95:c1:be','online':True,'connected_seconds':420,'addresses':['192.168.0.4'],'note':'HuaWei','last_seen':stamp},
 {'mac':'32:85:6b:95:c1:cf','online':False,'connected_seconds':None,'addresses':[],'note':'旧设备','last_seen':stamp}],
 'sampled_at':stamp,'error':'','address_warning':False,'storage_warning':False}
clients={'clients':[
 {'mac':'12:c4:6a:d2:17:d6','ip':'192.168.0.3','down_bytes':12345678,'up_bytes':2345678,'limit_down_kbps':0,'limit_up_kbps':0,'quota_mb':0,'blocked':False,'samples':samples},
 {'mac':'22:85:6b:95:c1:be','ip':'192.168.0.4','down_bytes':45678901,'up_bytes':8901234,'limit_down_kbps':1000,'limit_up_kbps':500,'quota_mb':500,'blocked':True,'samples':samples},
 {'mac':'32:85:6b:95:c1:cf','ip':'','down_bytes':1234,'up_bytes':567,'limit_down_kbps':0,'limit_up_kbps':0,'quota_mb':0,'blocked':False,'samples':[]}],
 'sampled_at':stamp,'error':''}
seen=[]

with sync_playwright() as p:
 browser=p.chromium.launch(headless=True)
 page=browser.new_page(viewport={'width':1366,'height':900})
 errors=[];page.on('pageerror',lambda e:errors.append(str(e)));page.on('dialog',lambda d:d.accept())
 def device_api(route):
  if route.request.method=='DELETE':
   seen.append(('devices',route.request.post_data_json));route.fulfill(json={'deleted':True})
  elif route.request.method=='POST':
   seen.append(('kick',route.request.post_data_json));devices['devices'][0]['online']=False;route.fulfill(json={'disconnected':True})
  elif route.request.method=='PUT': route.fulfill(json={'saved':True})
  else: route.fulfill(json=devices)
 def traffic_api(route):
  if route.request.method in ('PUT','DELETE'):
   seen.append((route.request.method.lower(),route.request.post_data_json));route.fulfill(json={'saved':True,'deleted':True})
  else: route.fulfill(json=clients)
 page.route('**/air-api/devices/kick',device_api);page.route('**/air-api/devices',device_api);page.route('**/air-api/traffic',traffic_api)
 page.goto(f'http://127.0.0.1:{server.server_port}/inner-pages/devices.html')
 page.locator('#summary').filter(has_text='2 台在线 · 3 台已记录').wait_for()
 assert page.locator('.device-card').count()==3
 assert page.locator('.speed-panel').count()==3 and page.locator('.speed-panel [class*="speed-line-"]').count()==12
 assert page.get_by_text('30/30 点 · 每 2 秒',exact=True).count()==2
 assert page.get_by_role('button',name='删除记录',exact=True).count()==1
 assert page.get_by_role('button',name='强制下线',exact=True).count()==2
 first=page.locator('.device-limits').first
 first.locator('input').nth(0).fill('0.625');first.locator('input').nth(2).fill('2048')
 first.get_by_role('button',name='保存设置',exact=True).click()
 first.get_by_text('设置已生效',exact=True).wait_for()
 assert seen[-1][1]['limit_down_kbps']==5000 and seen[-1][1]['quota_mb']==2048
 page.screenshot(path=str(root/'.tools/traffic-desktop.png'),full_page=True)
 page.set_viewport_size({'width':390,'height':844})
 assert page.evaluate('document.documentElement.scrollWidth<=innerWidth')
 page.screenshot(path=str(root/'.tools/traffic-mobile.png'),full_page=True)
 page.get_by_role('button',name='恢复使用',exact=True).click()
 assert seen[-1][1]=={'mac':'22:85:6b:95:c1:be','unblock':True}
 iphone=page.locator('.device-card').filter(has_text='iPhone')
 iphone.get_by_role('button',name='强制下线',exact=True).click()
 iphone.get_by_text('离线',exact=True).wait_for()
 assert seen[-1]==('kick',{'mac':'12:c4:6a:d2:17:d6'})
 old=page.locator('.device-card').filter(has_text='旧设备')
 old.get_by_role('button',name='删除记录',exact=True).click()
 old.wait_for(state='detached')
 assert seen[-2:]==[('delete',{'mac':'32:85:6b:95:c1:cf'}),('devices',{'mac':'32:85:6b:95:c1:cf'})]
 assert page.locator('.device-card').count()==2
 assert not errors,errors
 print('traffic UI OK; requests:',seen)
 browser.close()
