#!/bin/sh
export REQUEST_METHOD="POST"
export CONTENT_TYPE="application/x-www-form-urlencoded"
export CONTENT_LENGTH="17"

echo "=== Calling traffic.cgi toggle_wifi ==="
printf "action=toggle_wifi" | /webui/cgi-bin/traffic.cgi
echo ""
echo "=== Exit code: $? ==="
