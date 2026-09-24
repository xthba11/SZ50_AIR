
for act in get_wifi set_wifi wifi_on wifi_off toggle_wifi wifi_toggle switch_wifi switch_wifi_mode switch_wifi_channel update_wifi_settings wifi_status set_wifi_status switch_wifi_status enable_wifi disable_wifi wifi_enable wifi_disable wifi_switch set_wifi_switch wifi_power set_wifi_power power_wifi change_wifi turn_wifi turn_wifi_on turn_wifi_off open_wifi close_wifi wifi_ctrl wifi_control control_wifi wifi_setting set_wifi_state wifi_state wifi wifi_on_off on_off_wifi; do
    res=$(REQUEST_METHOD=POST QUERY_STRING="action=$act" /webui/cgi-bin/traffic.cgi 2>/dev/null)
    if ! echo "$res" | grep -q "未知操作"; then
        echo "MATCH POST QUERY_STRING: $act -> $res"
    fi
    res2=$(echo "action=$act" | REQUEST_METHOD=POST CONTENT_TYPE=application/x-www-form-urlencoded CONTENT_LENGTH=${#act}+7 /webui/cgi-bin/traffic.cgi 2>/dev/null)
    if ! echo "$res2" | grep -q "未知操作"; then
        echo "MATCH POST STDIN: $act -> $res2"
    fi
    res3=$(REQUEST_METHOD=GET QUERY_STRING="action=$act" /webui/cgi-bin/traffic.cgi 2>/dev/null)
    if ! echo "$res3" | grep -q "未知操作"; then
        echo "MATCH GET QUERY_STRING: $act -> $res3"
    fi
done
