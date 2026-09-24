import urllib.request,json,hashlib,zipfile
from pathlib import Path
p=Path('.tools')
versions=json.load(urllib.request.urlopen('https://go.dev/dl/?mode=json',timeout=30))
f=next(f for v in versions if v['stable'] for f in v['files'] if f['os']=='windows' and f['arch']=='amd64' and f['kind']=='archive')
a=p/f['filename']
with urllib.request.urlopen('https://go.dev/dl/'+f['filename'],timeout=60) as response, a.open('wb') as target:
 import shutil
 shutil.copyfileobj(response,target)
assert hashlib.sha256(a.read_bytes()).hexdigest()==f['sha256']
with zipfile.ZipFile(a) as z:z.extractall(p)
print('Verified and extracted',f['filename'])
