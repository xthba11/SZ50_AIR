import sys,json,base64,urllib.request
from pathlib import Path
sys.path.insert(0,str(Path('admin-auth').resolve()))
from deploy_devices import shell,adb
print(shell('df -Pk /home/root'))
adb('forward','tcp:18880','tcp:18080')
try:
 c=json.loads(shell('cat /home/root/admin-auth/credentials.json'))
 headers={'Authorization':'Basic '+base64.b64encode((c['username']+':'+c['password']).encode()).decode()}
 with urllib.request.urlopen(urllib.request.Request('http://127.0.0.1:18880/air-api/monitor',headers=headers),timeout=15) as r:data=json.load(r)
 s=data['samples'][-1];print(json.dumps({'sample_at':s['at'],'storage':s['storage'],'errors':s['errors']}))
 from playwright.sync_api import sync_playwright
 with sync_playwright() as p:
  browser=p.chromium.launch(headless=True);page=browser.new_page(http_credentials={'username':c['username'],'password':c['password']})
  page.goto('http://127.0.0.1:18880/html/monitor.html',wait_until='networkidle')
  page.wait_for_function("document.getElementById('disk-value').textContent.includes('MiB')")
  print('Live page: '+page.locator('#disk-value').inner_text());browser.close()
finally:adb('forward','--remove','tcp:18880')
