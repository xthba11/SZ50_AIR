import urllib.request, zipfile
from pathlib import Path

p = Path(".tools")
p.mkdir(exist_ok=True)
upx_zip = p / "upx.zip"

url = "https://github.com/upx/upx/releases/download/v5.2.1/upx-5.2.1-win64.zip"
print("Downloading UPX...")
req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
with urllib.request.urlopen(req, timeout=60) as resp, open(upx_zip, 'wb') as f:
    f.write(resp.read())

print("Extracting UPX...")
with zipfile.ZipFile(upx_zip) as z:
    for member in z.namelist():
        if member.endswith("upx.exe"):
            with z.open(member) as src, open(p / "upx.exe", 'wb') as dst:
                dst.write(src.read())
            print("Extracted upx.exe successfully!")
