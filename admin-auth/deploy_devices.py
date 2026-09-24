"""Deploy the tested devices feature over USB ADB, with an on-device rollback."""
from pathlib import Path
import os,subprocess,json,hashlib,time,urllib.request,urllib.error,base64,sys,shlex
os.environ.setdefault('ANDROID_ADB_SERVER_PORT', '5038')
ROOT=Path(__file__).resolve().parents[1]
ADB=str(next(ROOT.glob('*/SZ*/adb.exe')))

def adb(*args):
 for attempt in range(5):
  p=subprocess.run([ADB,*args],capture_output=True,timeout=60)
  if p.returncode==0: return p.stdout
  err=p.stderr.decode(errors='replace')
  if ('daemon' in err or '10060' in err) and attempt < 4:
   time.sleep(2)
   continue
  raise RuntimeError(err)

def shell(command):
 out=adb('shell','sh -c '+shlex.quote(command)+'; printf "\\n__AIR_EXIT_%s\\n" "$?"').decode('utf-8',errors='replace').strip()
 result,marker=out.rsplit('__AIR_EXIT_',1)
 if marker.strip()!='0':raise RuntimeError('Remote command failed (exit '+marker.strip()+')')
 return result.strip()

def verify():
 adb('forward','tcp:18880','tcp:18080')
 try:
  # Keep credentials in memory; never write them to logs or local files.
  c=json.loads(shell('cat /home/root/admin-auth/credentials.json'))
  auth='Basic '+base64.b64encode((c['username']+':'+c['password']).encode()).decode()
  def get(path,authenticated=True,method='GET',body=None):
   headers={'Authorization':auth} if authenticated else {}
   if body is not None:headers['Content-Type']='application/json'
   req=urllib.request.Request('http://127.0.0.1:18880'+path,headers=headers,method=method,data=body)
   return urllib.request.urlopen(req,timeout=15).read()
  for attempt in range(25):
   try:
    get('/air-api/devices',False)
    raise AssertionError('Anonymous API access accepted')
   except urllib.error.HTTPError as e:
    assert e.code==401
    break
   except Exception:
    time.sleep(1)
  else:raise RuntimeError('Gateway not ready')
  for attempt in range(30):
   try:
    data=json.loads(get('/air-api/devices'))
    if data['sampled_at'].startswith('0001'):time.sleep(1);continue
    break
   except (OSError,ValueError):time.sleep(1)
  else:raise RuntimeError('No device sample received')
  assert not data['error'],data['error']
  assert not data['storage_warning'],'Storage failed'
  assert b'data-section="devices"' in get('/')
  assert b'data-section="proxyweb"' in get('/')
  assert b'data-section="chargeweb"' in get('/')
  for path in ['/html/devices.html','/air-devices.js','/air-devices.css','/html/proxy.html','/air-proxy.js','/air-proxy.css','/html/charge.html']:assert len(get(path))>50
  proxy_info=json.loads(get('/air-api/proxy'))
  assert 'enabled' in proxy_info and 'routing_mode' in proxy_info
  speed_info=json.loads(get('/air-api/network/speed'))
  assert 'samples' in speed_info
  daily_info=json.loads(get('/air-api/traffic/daily'))
  assert 'days' in daily_info
  charge_info=json.loads(get('/air-api/charge'))
  assert 'capacity' in charge_info and 'enabled' in charge_info and 'start_percent' in charge_info
  if data['devices']:
   device=data['devices'][0]
   result=json.loads(get('/air-api/devices',method='PUT',body=json.dumps({'mac':device['mac'],'note':device['note']}).encode()))
   assert result['saved']
  for attempt in range(12):
   monitor=json.loads(get('/air-api/monitor'))
   if monitor['samples'] and monitor['samples'][-1]['cpu_percent'] is not None:break
   time.sleep(2)
  else:raise AssertionError('No CPU interval sample received')
  latest=monitor['samples'][-1]
  assert not latest['errors'],latest['errors']
  assert 0<=latest['cpu_percent']<=100 and latest['memory']['available_bytes']<=latest['memory']['total_bytes']
  assert latest['temperatures'] and latest['storage']['total_bytes']>0
  assert len(monitor['samples'])<=30 and monitor['interval_seconds'] in (5, 15)
  assert latest['signal'] and not latest['signal_error']
  from datetime import datetime
  if len(monitor['samples'])>=2:
   stamps=[datetime.fromisoformat(v['at'].replace('Z','+00:00')) for v in monitor['samples'][-2:]]
   assert 3<=(stamps[1]-stamps[0]).total_seconds()<=17, 'Unexpected sampling interval'
  try:get('/air-api/monitor',False);raise AssertionError('Anonymous monitor access accepted')
  except urllib.error.HTTPError as e:assert e.code==401
  from playwright.sync_api import sync_playwright
  with sync_playwright() as p:
   browser=p.chromium.launch(headless=True)
   page=browser.new_page(http_credentials={'username':c['username'],'password':c['password']},viewport={'width':390,'height':844})
   errors=[];page.on('pageerror',lambda e:errors.append(str(e)))
   page.goto('http://127.0.0.1:18880/?page=devices',wait_until='domcontentloaded')
   frame=page.frame_locator('#devices')
   frame.locator('.device-card').first.wait_for(timeout=20000) if data['devices'] else frame.locator('#summary').wait_for()
   assert page.locator('#devices-section').is_visible()
   assert page.evaluate('document.documentElement.scrollWidth<=innerWidth')
   page.screenshot(path=str(ROOT/'.tools/devices-live.png'),full_page=True)
   page.locator('#menu-toggle').click()
   page.locator('[data-section="monitor"]').click()
   monitor_frame=page.frame_locator('#monitor')
   monitor_frame.locator('#temperature-trends .trend-row').first.wait_for(timeout=15000)
   assert monitor_frame.locator('#temperature-trends .trend-row').count()==len(latest['temperatures'])==11
   assert monitor_frame.locator('#temperature-trends svg text, #temperature-trends svg line').count()==0
   assert '%' in monitor_frame.locator('#cpu-value').inner_text()
   assert page.evaluate('document.documentElement.scrollWidth<=innerWidth')
   page.screenshot(path=str(ROOT/'.tools/monitor-live.png'),full_page=True)
   page.locator('#menu-toggle').click()
   page.locator('[data-section="dashboard"]').first.click()
   page.locator('#signal-trends circle').first.wait_for(timeout=15000)
   assert page.locator('#signal-trends .trend-row').count()==3
   assert page.get_by_text('基带与运行',exact=True).count()==0
   assert page.locator('#memory-text,#tempTableBody,#rsrp-bar,#rsrq-bar,#sinr-bar').count()==0
   assert page.locator('#signal-trends svg text, #signal-trends svg line').count()==0
   page.screenshot(path=str(ROOT/'.tools/overview-live.png'),full_page=True)
   page.locator('#share-wifi').click()
   page.locator('.qr-code svg').wait_for(timeout=15000)
   # Decode real QR in memory only; never persist or log the hotspot password.
   import cv2,numpy as np
   png=page.locator('.qr-code svg').screenshot()
   decoded,_,_=cv2.QRCodeDetector().detectAndDecode(cv2.imdecode(np.frombuffer(png,dtype=np.uint8),cv2.IMREAD_COLOR))
   wifi=json.loads(get('/cgi-bin/traffic.cgi?action=get_wifi'))
   expected=page.evaluate('data=>wifiQRPayload(data)',wifi)
   assert decoded==expected, 'Live Wi-Fi QR decode mismatch'
   page.get_by_role('button',name='关闭',exact=True).click()
   assert page.locator('.qr-code svg').count()==0
   assert not errors,errors
   browser.close()
  print(json.dumps({'authenticated_api':'pass','anonymous_api':'401','notes_save':'pass' if data['devices'] else 'not tested: empty list','online':sum(d['online'] for d in data['devices']),'live_mobile_ui':'pass','monitor_api':'pass','monitor_sensors':len(latest['temperatures']),'live_wifi_qr_decode':'pass','temperature_rows':11,'signal_rows':3,'sample_interval':15,'history_limit':30},ensure_ascii=True))
 finally:adb('forward','--remove','tcp:18880')

if __name__=='__main__':
 if '--verify' in sys.argv:verify();sys.exit()
 stamp=sys.argv[sys.argv.index('--resume')+1] if '--resume' in sys.argv else time.strftime('%Y%m%d-%H%M%S')
 assert len(stamp)==15 and stamp.replace('-','').isdigit()
 backup='/home/root/admin-auth/devices-backup-'+stamp
 stage='/home/root/admin-auth/devices-stage-'+stamp
 files=[('admin-auth/admin-gateway','/home/root/admin-auth/admin-gateway'),('ui/index.html','/webui/index.html'),('ui/air-ui.js','/webui/air-ui.js'),('ui/air-ui.css','/webui/air-ui.css'),('ui/air-overview.css','/webui/air-overview.css'),('ui/inner-pages/devices.html','/webui/html/devices.html'),('ui/air-devices.js','/webui/air-devices.js'),('ui/air-devices.css','/webui/air-devices.css'),('ui/inner-pages/monitor.html','/webui/html/monitor.html'),('ui/air-monitor.js','/webui/air-monitor.js'),('ui/air-monitor.css','/webui/air-monitor.css'),('ui/air-share.js','/webui/air-share.js'),('ui/vendor/qrcode.js','/webui/vendor/qrcode.js'),('ui/vendor/qrcode_UTF8.js','/webui/vendor/qrcode_UTF8.js'),('ui/vendor/qrcode-LICENSE','/webui/vendor/qrcode-LICENSE')]
 files += [('ui/at-app.js','/home/root/8080/dist/js/app.e4a615bb.js'),('ui/inner-pages/at-index.html','/home/root/8080/dist/index.html'),('ui/air-inner.css','/webui/air-inner.css'),('ui/air-inner.css','/home/root/8080/dist/air-inner.css'),('ui/air-embed.js','/webui/air-embed.js'),('ui/air-embed.js','/home/root/8080/dist/air-embed.js')]
 files += [(f'ui/{name}',f'/webui/{name}') for name in ['air-overview.js','air-trend.js','air-trend.css','air-signal.js']]
 files += [(f'ui/inner-pages/{name}',f'/webui/html/{name}') for name in ['sim.html','z50_air_wifi.html','liuliang.html','system.html','band.html']]
 files += [('ui/air-security.js','/webui/air-security.js'),('ui/inner-pages/speedtest.html','/home/root/8080/dist/speedtest.html'),('ui/air-wifi-radar.js','/webui/air-wifi-radar.js'),('ui/air-wifi-radar.css','/webui/air-wifi-radar.css')]
 files += [(f'ui/{name}',f'/home/root/8080/dist/{name}') for name in ['air-speedtest.js','air-speedtest.css','air-at.css']]
 files += [('admin-auth/proxy_iptables.sh','/home/root/admin-auth/proxy_iptables.sh'),('ui/inner-pages/proxy.html','/webui/html/proxy.html'),('ui/air-proxy.js','/webui/air-proxy.js'),('ui/air-proxy.css','/webui/air-proxy.css')]
 files += [('ui/air-charge.js','/home/root/8080/dist/air-charge.js'),('ui/air-charge.css','/home/root/8080/dist/air-charge.css'),('ui/air-charge.js','/webui/air-charge.js'),('ui/air-charge.css','/webui/air-charge.css'),('ui/inner-pages/charge.html','/webui/html/charge.html'),('admin-auth/start.sh','/home/root/admin-auth/start.sh')]
 assert shell('test -x /home/root/admin-auth/admin-gateway && echo READY').endswith('READY')
 # Ensure Xray binary is present on device without duplicating it in staging
 xray_local = ROOT/'.tools/xray_arm64'
 if xray_local.exists():
  xray_hash = hashlib.sha256(xray_local.read_bytes()).hexdigest()
  rh = shell('sha256sum /home/root/admin-auth/xray 2>/dev/null || true').split()
  if not rh or rh[0] != xray_hash:
   adb('push', str(xray_local), '/home/root/admin-auth/xray')
   shell('chmod 755 /home/root/admin-auth/xray')
 # Purge any previous backups and stale stages so we have maximum headroom for the new deployment
 print('Purging old stages and checking free space...', flush=True)
 shell('for d in /home/root/admin-auth/*backup* /home/root/admin-auth/*stage*; do rm -rf "$d"; done')
 free_kb=int(shell('df -Pk /home/root').splitlines()[-1].split()[3])
 assert free_kb*1024 > 2*sum((ROOT/local).stat().st_size for local,_ in files)+131072, 'Not enough space for staging and rollback'
 print(f'Free space: {free_kb} KB. Staging {len(files)} files...', flush=True)
 shell(f'mkdir -p {backup} {stage}; chmod 700 {backup} {stage}')

 for local,remote in files:
  name=Path(local).name
  shell(f'if [ -f {remote} ] && [ ! -f {backup}/{name} ]; then cp -p {remote} {backup}/{name}; fi')
  adb('push',str(ROOT/local),stage+'/'+name)
  assert shell('sha256sum '+stage+'/'+name).split()[0]==hashlib.sha256((ROOT/local).read_bytes()).hexdigest()
 rollback=['#!/bin/sh','set -eu']
 for local,remote in files:
  name=Path(local).name
  rollback.append(f'if [ -f {backup}/{name} ]; then cp -p {backup}/{name} {remote}.restore; mv {remote}.restore {remote}; fi')
 rollback+=['PID=$(cat /var/run/admin-auth.pid)','if [ "$(tr -d "\\000" </proc/$PID/cmdline)" = "/home/root/admin-auth/admin-gateway" ]; then kill "$PID"; fi']
 rollback_path=ROOT/'.tools/rollback-devices.sh';rollback_path.write_bytes(('\n'.join(rollback)+'\n').encode('utf-8'))
 adb('push',str(rollback_path),backup+'/rollback.sh')
 shell(f'chmod 700 {backup}/rollback.sh {stage}/admin-gateway')
 # Every staged file is verified before any live file is replaced.
 commands=['set -eu','mkdir -p /webui/vendor /home/root/8080/dist /home/root/admin-auth/proxy']
 for local,remote in files:commands.append(f'cp -p {stage}/{Path(local).name} {remote}')
 commands+=['chmod 755 /home/root/admin-auth/proxy_iptables.sh']
 commands+=['PID=$(cat /var/run/admin-auth.pid)','case "$(tr -d "\\000" </proc/$PID/cmdline)" in "/home/root/admin-auth/admin-gateway") kill "$PID";; *) echo "Unexpected gateway PID"; exit 1;; esac']
 apply_script=ROOT/'.tools/apply_deploy.sh'
 apply_script.write_bytes(('\n'.join(commands)+'\n').encode('utf-8'))
 adb('push',str(apply_script),stage+'/apply.sh')
 shell(f'chmod 700 {stage}/apply.sh')
 try:
  shell(f'/bin/sh {stage}/apply.sh');time.sleep(8);verify()
  shell(f'for d in /home/root/admin-auth/devices-backup-*; do [ "$d" != "{backup}" ] && rm -rf "$d"; done; rm -rf /home/root/admin-auth/*stage*')
 except Exception:
  print('Verification failed; restoring previous version')
  shell('/bin/sh '+backup+'/rollback.sh');raise
 print('Rollback: /bin/sh '+backup+'/rollback.sh')
