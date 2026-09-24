import urllib.request, zipfile, subprocess, os
from pathlib import Path

p = Path(".tools")
xray_zip = p / "xray_arm64.zip"
url = "https://github.com/XTLS/Xray-core/releases/download/v26.3.27/Xray-linux-arm64-v8a.zip"

print("Downloading Xray linux-arm64...")
req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
with urllib.request.urlopen(req, timeout=120) as resp, open(xray_zip, 'wb') as f:
    f.write(resp.read())

print("Extracting xray binary...")
with zipfile.ZipFile(xray_zip) as z:
    for member in z.namelist():
        if member == "xray":
            with z.open(member) as src, open(p / "xray_arm64", 'wb') as dst:
                dst.write(src.read())

raw_size = (p / "xray_arm64").stat().st_size
print(f"Extracted xray size: {raw_size / 1024 / 1024:.2f} MB ({raw_size} bytes)")

# Run UPX
print("Compressing with UPX...")
subprocess.run([str(p / "upx.exe"), "--best", "--lzma", str(p / "xray_arm64")], check=True)
compressed_size = (p / "xray_arm64").stat().st_size
print(f"Compressed xray size: {compressed_size / 1024 / 1024:.2f} MB ({compressed_size} bytes)")
