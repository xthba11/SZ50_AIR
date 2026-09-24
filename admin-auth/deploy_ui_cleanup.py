"""Deploy UI 2.10 without restarting the gateway or resetting history."""
from pathlib import Path
import json,time,hashlib,base64,urllib.request,urllib.error
from deploy_devices import ROOT,adb,shell

FILES=[('ui/index.html','/webui/index.html'),('ui/air-ui.js','/webui/air-ui.js'),('ui/inner-pages/z50_air_wifi.html','/webui/html/z50_air_wifi.html'),('ui/air-inner.css','/webui/air-inner.css'),('ui/at-app.js','/home/root/8080/dist/js/app.e4a615bb.js'),('ui/inner-pages/at-index.html','/home/root/8080/dist/index.html')]

def verify_ui():
 adb('forward','tcp:18880','tcp:18080');adb('forward','tcp:18881','tcp:18081')
 try:
  credentials=json.loads(shell('cat /home/root/admin-auth/credentials.json'))
  header={'Authorization':'Basic '+base64.b64encode((credentials['username']+':'+credentials['password']).encode()).decode()}
  def get(path):return urllib.request.urlopen(urllib.request.Request('http://127.0.0.1:18880'+path,headers=header),timeout=15).read()
  wifi=json.loads(get('/cgi-bin/traffic.cgi?action=get_wifi'))
  try:get('/html/charger.html');raise AssertionError('Retired charging page still available')
  except urllib.error.HTTPError as e:assert e.code==404
  from playwright.sync_api import sync_playwright
  with sync_playwright() as p:
   browser=p.chromium.launch(headless=True);page=browser.new_page(http_credentials=credentials,viewport={'width':390,'height':844});errors=[];page.on('pageerror',lambda e:errors.append(str(e)))
   page.goto('http://127.0.0.1:18880/?page=dashboard',wait_until='domcontentloaded');page.wait_for_function("document.getElementById('wifiEncryption').textContent!=='--'")
   assert page.locator('#wifiChannel').inner_text()==str(wifi['wifi_channel'])
   security={'none':'开放','wpa':'WPA','wpa2':'WPA2'}.get(wifi['wifi_encryption'],wifi['wifi_encryption'].upper())
   assert page.locator('#wifiEncryption').inner_text()==security
   assert page.locator('[data-section="timerebootweb"],#timerebootweb-section').count()==0
   page.goto('http://127.0.0.1:18880/?page=usbmodeweb',wait_until='domcontentloaded');frame=page.frame_locator('#usbmodeweb');frame.locator('#ssid-input').wait_for()
   frame.locator('#channel-select option').first.wait_for(state='attached')
   assert frame.locator('.stats-box,#wifi-status-text,#refresh-timer').count()==0
   assert frame.locator('#channel-select').input_value()==str(wifi['wifi_channel'])
   assert page.evaluate('document.documentElement.scrollWidth<=innerWidth')
   page.screenshot(path=str(ROOT/'.tools/wifi-live-2.10.png'),full_page=True)
   page.goto('http://127.0.0.1:18881/',wait_until='domcontentloaded');page.get_by_role('tab',name='锁频',exact=True).wait_for()
   assert page.get_by_role('tab',name='状态',exact=True).count()==0 and page.locator('#pane-info').count()==0
   assert page.get_by_role('tab',name='锁频',exact=True).get_attribute('aria-selected')=='true'
   for name in ['锁基站','调试','设置','锁频']:page.get_by_role('tab',name=name,exact=True).click()
   assert page.evaluate('document.documentElement.scrollWidth<=innerWidth')
   page.screenshot(path=str(ROOT/'.tools/at-live-2.10.png'),full_page=True)
   assert not errors,errors
   browser.close()
  print('PASS live overview channel/security; Wi-Fi settings; retired charging page 404; AT status removed; remaining tabs; no JS errors')
 finally:
  adb('forward','--remove','tcp:18880');adb('forward','--remove','tcp:18881')

if __name__=='__main__':
 stamp=time.strftime('%Y%m%d-%H%M%S');backup='/home/root/admin-auth/ui-cleanup-'+stamp;stage=backup+'/stage'
 shell(f'mkdir -m 700 {backup}; mkdir -m 700 {stage}')
 for local,remote in FILES:
  name=Path(local).name;shell(f'cp -p {remote} {backup}/{name}')
  adb('push',str(ROOT/local),stage+'/'+name)
  assert shell('sha256sum '+stage+'/'+name).split()[0]==hashlib.sha256((ROOT/local).read_bytes()).hexdigest()
 rollback=['#!/bin/sh','set -eu']+[f'cp -p {backup}/{Path(local).name} {remote}.restore; mv {remote}.restore {remote}' for local,remote in FILES]
 rollback += [f'if [ -f {backup}/charger.html ]; then cp -p {backup}/charger.html /webui/html/charger.html; fi']
 script=ROOT/'.tools/rollback-ui-cleanup.sh';script.write_bytes(('\n'.join(rollback)+'\n').encode())
 adb('push',str(script),backup+'/rollback.sh');shell(f'chmod 700 {backup}/rollback.sh; sh -n {backup}/rollback.sh')
 try:
  commands=['set -eu']+[f'mv {stage}/{Path(local).name} {remote}' for local,remote in FILES]
  commands += [f'if [ -f /webui/html/charger.html ]; then mv /webui/html/charger.html {backup}/charger.html; fi']
  shell('\n'.join(commands));verify_ui()
 except Exception:
  shell('/bin/sh '+backup+'/rollback.sh');print('UI restored from backup');raise
 print('Rollback: /bin/sh '+backup+'/rollback.sh')
