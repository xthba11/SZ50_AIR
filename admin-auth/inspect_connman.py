import sys
sys.path.insert(0, 'admin-auth')
import deploy_devices

script = """
with open('/usr/sbin/connmand', 'rb') as f:
    data = f.read()

import re
print re.findall(r'net\.connman\.[A-Za-z0-9_.]+', data[1120000:1125000])
"""
out = deploy_devices.adb('shell', 'python -c ' + deploy_devices.shlex.quote(script))
print(out.decode('utf-8', errors='replace'))
