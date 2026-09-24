"""Deploy the domestic speed-test source with rollback."""
from pathlib import Path
import time,json,hashlib,base64,urllib.request,urllib.error
from deploy_devices import ROOT,adb,shell
FILES=[('admin-auth/admin-gateway','/home/root/admin-auth/admin-gateway'),('ui/at-app.js','/home/root/8080/dist/js/app.e4a615bb.js'),('ui/inner-pages/at-index.html','/home/root/8080/dist/index.html'),('ui/inner-pages/speedtest.html','/home/root/8080/dist/speedtest.html'),('ui/air-speedtest.js','/home/root/8080/dist/air-speedtest.js')]

def verify_features():
 adb('forward','tcp:18880','tcp:18080');adb('forward','tcp:18881','tcp:18081')
 try:
  credentials=json.loads(shell('cat /home/root/admin-auth/credentials.json'))
  header={'Authorization':'Basic '+base64.b64encode((credentials['username']+':'+credentials['password']).encode()).decode()}
  def request(path,method='GET',body=None,authenticated=True):
   headers=dict(header) if authenticated else {}
   if body is not None:headers['Content-Type']='application/json'
   req=urllib.request.Request('http://127.0.0.1:18880'+path,method=method,headers=headers,data=json.dumps(body).encode() if body is not None else None)
   with urllib.request.urlopen(req,timeout=15) as r:return json.load(r)
  for path in ['/air-api/speedtest','/air-api/wifi-security']:
   try:request(path,authenticated=False);raise AssertionError('Anonymous access accepted')
   except urllib.error.HTTPError as e:assert e.code==401
  security=request('/air-api/wifi-security');assert security['available'] and security['current']=='wpa2'
  print('PASS authenticated domestic speed endpoint; anonymous access rejected',flush=True)
  result=request('/air-api/speedtest','POST',{'confirm':True});assert result['state']=='running'
  deadline=time.monotonic()+85
  while time.monotonic()<deadline:
   result=request('/air-api/speedtest')
   if result['state']!='running':break
   time.sleep(2)
  assert result['state']=='done',result
  assert result['download_mbps']>0 and result['upload_mbps']>0 and result['latency_ms']>0
  assert 6*1024*1024 < result['bytes'] <= 104*1024*1024
  assert result['download_seconds']>=14.9 or result['download_limited']
  assert result['node']=='南航·南京'
  print(json.dumps({'speed_live':'pass','download_mbps':round(result['download_mbps'],2),'upload_mbps':round(result['upload_mbps'],2),'http_latency_ms':round(result['latency_ms'],1),'node':result['node'],'payload_mib':round(result['bytes']/1048576,2),'download_seconds':round(result['download_seconds'],2),'download_limited':result['download_limited']}),flush=True)
  from playwright.sync_api import sync_playwright
  with sync_playwright() as p:
   browser=p.chromium.launch(headless=True);page=browser.new_page(http_credentials=credentials,viewport={'width':390,'height':844});errors=[];page.on('pageerror',lambda e:errors.append(str(e)))
   page.goto('http://127.0.0.1:18880/?page=usbmodeweb',wait_until='domcontentloaded');frame=page.frame_locator('#usbmodeweb');frame.locator('#security-select').wait_for();page.wait_for_timeout(1000);assert frame.locator('#security-select').input_value()=='wpa2' and frame.locator('#apply-security').is_enabled()
   page.goto('http://127.0.0.1:18881/',wait_until='domcontentloaded');page.get_by_role('tab',name='调试',exact=True).click();page.get_by_role('button',name='测速',exact=True).click();speed=page.frame_locator('iframe[title="网络测速"]');speed.get_by_text('完成',exact=False).wait_for(timeout=15000);assert speed.locator('#speed-down').inner_text()!='—';assert '南航（南京）' in speed.locator('.speed-note').inner_text();assert '15 秒' in speed.locator('.speed-note').inner_text()
   assert page.evaluate('document.documentElement.scrollWidth<=innerWidth');page.screenshot(path=str(ROOT/'.tools/speed-domestic-live.png'),full_page=True)
   assert not errors,errors;browser.close()
  print('PASS live mobile speed panel and Wi-Fi security selector',flush=True)
 finally:
  adb('forward','--remove','tcp:18880');adb('forward','--remove','tcp:18881')

if __name__=='__main__':
 stamp=time.strftime('%Y%m%d-%H%M%S');backup='/home/root/admin-auth/domestic-speed-'+stamp;stage=backup+'/stage'
 free=int(shell('df -Pk /home/root').splitlines()[-1].split()[3])*1024
 assert free>sum((ROOT/local).stat().st_size for local,_ in FILES)+256*1024,'Insufficient staging space'
 shell(f'mkdir -m 700 {backup}; mkdir -m 700 {stage}')
 for local,remote in FILES:
  name=Path(local).name
  if name=='admin-gateway':shell(f'ln {remote} {backup}/{name}')
  else:shell(f'if [ -f {remote} ]; then cp -p {remote} {backup}/{name}; fi')
  adb('push',str(ROOT/local),stage+'/'+name)
  assert shell('sha256sum '+stage+'/'+name).split()[0]==hashlib.sha256((ROOT/local).read_bytes()).hexdigest()
 rollback=['#!/bin/sh','set -eu']
 for local,remote in FILES:
  name=Path(local).name;copy='ln' if name=='admin-gateway' else 'cp -p'
  rollback.append(f'if [ -f {backup}/{name} ]; then {copy} {backup}/{name} {remote}.restore-{stamp}; mv {remote}.restore-{stamp} {remote}; fi')
 restart='PID=$(cat /var/run/admin-auth.pid); CMD=$(tr -d "\\000" </proc/$PID/cmdline); if [ "$CMD" = "/home/root/admin-auth/admin-gateway" ]; then kill "$PID"; else exit 1; fi'
 rollback.append(restart);script=ROOT/'.tools/rollback-domestic-speed.sh';script.write_bytes(('\n'.join(rollback)+'\n').encode());adb('push',str(script),backup+'/rollback.sh');shell(f'chmod 700 {backup}/rollback.sh {stage}/admin-gateway; sh -n {backup}/rollback.sh')
 try:
  shell('\n'.join(['set -eu']+[f'mv {stage}/{Path(local).name} {remote}' for local,remote in FILES]+[restart]));time.sleep(5);verify_features()
 except Exception:
  shell('/bin/sh '+backup+'/rollback.sh');print('Restored previous release',flush=True);raise
 print('Rollback: /bin/sh '+backup+'/rollback.sh')
