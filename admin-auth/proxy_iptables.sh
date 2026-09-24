#!/bin/sh
set -eu

ACTION="${1:-status}"
SERVER_IP="${2:-}"

case "$ACTION" in
  start)
    # Tear down any existing chain first
    iptables -t nat -D PREROUTING -i tether -j AIR_PROXY 2>/dev/null || true
    iptables -t nat -F AIR_PROXY 2>/dev/null || true
    iptables -t nat -X AIR_PROXY 2>/dev/null || true

    iptables -t nat -N AIR_PROXY

    # Bypass private / local networks
    iptables -t nat -A AIR_PROXY -d 0.0.0.0/8 -j RETURN
    iptables -t nat -A AIR_PROXY -d 10.0.0.0/8 -j RETURN
    iptables -t nat -A AIR_PROXY -d 127.0.0.0/8 -j RETURN
    iptables -t nat -A AIR_PROXY -d 169.254.0.0/16 -j RETURN
    iptables -t nat -A AIR_PROXY -d 172.16.0.0/12 -j RETURN
    iptables -t nat -A AIR_PROXY -d 192.168.0.0/16 -j RETURN
    iptables -t nat -A AIR_PROXY -d 224.0.0.0/4 -j RETURN
    iptables -t nat -A AIR_PROXY -d 240.0.0.0/4 -j RETURN

    # Bypass proxy server IP so outbound traffic from xray does not loop
    if [ -n "$SERVER_IP" ]; then
      for ip in $SERVER_IP; do
        iptables -t nat -A AIR_PROXY -d "$ip" -j RETURN
      done
    fi

    # Client-specific proxy bypass (devices with individual proxy switch set to OFF)
    iptables -t nat -N AIR_PROXY_BYPASS 2>/dev/null || iptables -t nat -F AIR_PROXY_BYPASS
    iptables -t nat -A AIR_PROXY -j AIR_PROXY_BYPASS

    # Redirect DNS queries (UDP & TCP port 53)
    iptables -t nat -A AIR_PROXY -p udp --dport 53 -j REDIRECT --to-ports 1053
    iptables -t nat -A AIR_PROXY -p tcp --dport 53 -j REDIRECT --to-ports 1053

    # Redirect remaining TCP traffic from tether interface
    iptables -t nat -A AIR_PROXY -p tcp -j REDIRECT --to-ports 12345

    # Insert into PREROUTING for tether interface
    iptables -t nat -I PREROUTING 1 -i tether -j AIR_PROXY

    # Accounting chain for proxy throughput (downlink & uplink on port 12345)
    iptables -t filter -N AIR_PROXY_STATS 2>/dev/null || true
    iptables -t filter -F AIR_PROXY_STATS 2>/dev/null || true
    iptables -t filter -N AIR_CLIENT_PROXY_STATS 2>/dev/null || true
    iptables -t filter -F AIR_CLIENT_PROXY_STATS 2>/dev/null || true
    iptables -t filter -A AIR_PROXY_STATS -j AIR_CLIENT_PROXY_STATS
    iptables -t filter -A AIR_PROXY_STATS -p tcp --sport 12345 -j ACCEPT
    iptables -t filter -A AIR_PROXY_STATS -p tcp --dport 12345 -j ACCEPT
    iptables -t filter -D INPUT -j AIR_PROXY_STATS 2>/dev/null || true
    iptables -t filter -D OUTPUT -j AIR_PROXY_STATS 2>/dev/null || true
    iptables -t filter -I INPUT 1 -j AIR_PROXY_STATS
    iptables -t filter -I OUTPUT 1 -j AIR_PROXY_STATS

    echo "AIR_PROXY started successfully"
    ;;

  stop)
    iptables -t nat -D PREROUTING -i tether -j AIR_PROXY 2>/dev/null || true
    iptables -t nat -F AIR_PROXY_BYPASS 2>/dev/null || true
    iptables -t nat -X AIR_PROXY_BYPASS 2>/dev/null || true
    iptables -t nat -F AIR_PROXY 2>/dev/null || true
    iptables -t nat -X AIR_PROXY 2>/dev/null || true

    iptables -t filter -D INPUT -j AIR_PROXY_STATS 2>/dev/null || true
    iptables -t filter -D OUTPUT -j AIR_PROXY_STATS 2>/dev/null || true
    iptables -t filter -F AIR_CLIENT_PROXY_STATS 2>/dev/null || true
    iptables -t filter -X AIR_CLIENT_PROXY_STATS 2>/dev/null || true
    iptables -t filter -F AIR_PROXY_STATS 2>/dev/null || true
    iptables -t filter -X AIR_PROXY_STATS 2>/dev/null || true

    echo "AIR_PROXY stopped successfully"
    ;;

  status)
    if iptables -t nat -C PREROUTING -i tether -j AIR_PROXY 2>/dev/null; then
      echo "RUNNING"
    else
      echo "STOPPED"
    fi
    ;;

  *)
    echo "Usage: $0 {start [server_ip]|stop|status}"
    exit 1
    ;;
esac
