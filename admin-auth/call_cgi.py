import subprocess, os

env = os.environ.copy()
env['REQUEST_METHOD'] = 'POST'
env['CONTENT_TYPE'] = 'application/x-www-form-urlencoded'
env['CONTENT_LENGTH'] = '17'

print("--- Calling /webui/cgi-bin/traffic.cgi with action=toggle_wifi ---")
p = subprocess.run(
    ['/webui/cgi-bin/traffic.cgi'],
    input=b'action=toggle_wifi',
    capture_output=True,
    env=env
)
print('Exit code:', p.returncode)
print('STDOUT:\n', p.stdout.decode('utf-8', errors='replace'))
print('STDERR:\n', p.stderr.decode('utf-8', errors='replace'))
