import os, subprocess

os.environ['ANDROID_ADB_SERVER_PORT'] = '5038'
ADB = r'C:\Users\19835\Desktop\SZ50_AIR_远程工具\原始工具\SZ50_AIR一键破解\adb.exe'

script = '''
mkdir -p /tmp/bin /tmp/log
cat << 'EOF' > /tmp/bin/wrap.sh
#!/bin/sh
cmd="$0"
base="${cmd##*/}"
echo "CMD: $base $@" >> /tmp/log/cmds.log
for real in /usr/bin /usr/sbin /bin /sbin; do
    if [ -x "$real/$base" ] && [ "$real/$base" != "/tmp/bin/$base" ]; then
        exec "$real/$base" "$@"
    fi
done
EOF
chmod +x /tmp/bin/wrap.sh
for cmd in connmanctl wpa_cli hostapd_cli iw atcmd sed awk grep sh; do
    ln -sf /tmp/bin/wrap.sh /tmp/bin/$cmd
done

test_action() {
    echo "--- Testing $1 ---"
    > /tmp/log/cmds.log
    echo "$2" | PATH="/tmp/bin:$PATH" REQUEST_METHOD=POST CONTENT_TYPE='application/x-www-form-urlencoded' CONTENT_LENGTH=${#2} /webui/cgi-bin/traffic.cgi
    cat /tmp/log/cmds.log
}

test_action "get_wifi" "action=get_wifi"
test_action "switch_wifi_mode to 2.4G" "action=switch_wifi_mode&target_mode=2.4G"
test_action "switch_wifi_channel to 6" "action=switch_wifi_channel&target_channel=6"
test_action "switch_wifi_mode to 5G" "action=switch_wifi_mode&target_mode=5G"
test_action "toggle_wifi" "action=toggle_wifi"
rm -rf /tmp/bin
'''

res = subprocess.run([ADB, 'shell', script], capture_output=True, text=True, encoding='utf-8', errors='replace')
print("STDOUT:\n", res.stdout)
print("STDERR:\n", res.stderr)
