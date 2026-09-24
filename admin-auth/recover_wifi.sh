#!/bin/sh
# 恢复 SZ50-Air 的 Wi-Fi 热点：重启 connmand 以重新检测接口 AP 能力，
# 再拉起 tether。全部输出写入 /tmp/connman_recover.log。
LOG=/tmp/connman_recover.log
echo "=== start $(date) ===" > $LOG
echo "before: connmand=$(pidof connmand) wpa_supp=$(pidof wpa_supplicant)" >> $LOG

kill -9 $(pidof connmand) 2>/dev/null
sleep 8
echo "after kill: connmand=$(pidof connmand)" >> $LOG

/usr/sbin/connmand -n -d >> $LOG 2>&1 &
sleep 25
echo "restarted: connmand=$(pidof connmand) wpa_supp=$(pidof wpa_supplicant)" >> $LOG

connmanctl enable wifi >> $LOG 2>&1
sleep 6
connmanctl tether wifi on >> $LOG 2>&1
sleep 10

echo "wpa: $(wpa_cli -i wlan0 status 2>&1 | grep -E 'wpa_state|ssid|freq' | tr '\n' ' ')" >> $LOG
echo "hook: $(dmesg | grep 'reset channel' | tail -n 1)" >> $LOG
echo "bridge: $(brctl show | grep -c wlan0)" >> $LOG
echo "=== done $(date) ===" >> $LOG
