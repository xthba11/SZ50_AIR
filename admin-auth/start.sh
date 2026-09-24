#!/bin/sh
set -eu
ROOT=/home/root/admin-auth

# Ensure sc2355 Wi-Fi driver is loaded and wifi is enabled
if ! lsmod | grep -q sprdwl_ng; then
    modprobe sprdwl_ng 2>/dev/null || true
    sleep 1
    connmanctl enable wifi 2>/dev/null || true
fi

# Ensure connmand daemon is running
if ! pidof connmand >/dev/null 2>&1; then
    nohup /usr/sbin/connmand -n -d >/dev/null 2>&1 &
    sleep 2
    connmanctl enable wifi 2>/dev/null || true
fi

MANAGED_PORTS=80,8080,7681,9998,5555,18080,18081,17681,19998
# Filter originals even if redirection or the authentication process fails.
for FW in iptables ip6tables; do
    for PORT in 80 8080 7681 9998 5555; do
        $FW -C INPUT ! -i lo -p tcp --dport "$PORT" -j DROP 2>/dev/null ||
            $FW -I INPUT 1 ! -i lo -p tcp --dport "$PORT" -j DROP
    done
    # WAN-side hardening. mangle PREROUTING runs BEFORE nat PREROUTING, so this
    # DROP actually takes effect: the filter INPUT DROP above never fires for a
    # redirected port because the nat REDIRECT rewrites the destination port
    # first. It also covers the proxy ports (18080/18081/17681/19998), which
    # otherwise have no protection at all on the WAN side.
    $FW -t mangle -C PREROUTING -i sipa_eth0 -p tcp -m addrtype --dst-type LOCAL -m multiport --dports "$MANAGED_PORTS" -j DROP 2>/dev/null ||
        $FW -t mangle -I PREROUTING 1 -i sipa_eth0 -p tcp -m addrtype --dst-type LOCAL -m multiport --dports "$MANAGED_PORTS" -j DROP
    for PAIR in 80:18080 8080:18081 7681:17681 9998:19998; do
        PORT=${PAIR%:*}
        TARGET=${PAIR#*:}
        $FW -t nat -C PREROUTING -m addrtype --dst-type LOCAL -p tcp --dport "$PORT" -j REDIRECT --to-ports "$TARGET" 2>/dev/null ||
            $FW -t nat -I PREROUTING 1 -m addrtype --dst-type LOCAL -p tcp --dport "$PORT" -j REDIRECT --to-ports "$TARGET"
    done
done
# 注意：不能用 pid 文件判断 —— /var/run 挂在持久化的 userdata 卷上，重启后旧的 pid 文件仍在，
# 而 PID 会被系统复用，kill -0 可能命中一个无关的活进程，导致误判"守护已在运行"而永不启动。
# 用 ps + 方括号模式匹配：supervise.sh 是由 /bin/sh 启动的，进程名是 sh，
# 「pidof supervise.sh」永远匹配不到，会导致每次开机重复拉起守护。
# 方括号写法 `[s]upervise.sh` 可避免匹配到 grep 自身。
if ps | grep -q "[s]upervise\.sh"; then
    exit 0
fi
nohup /bin/sh "$ROOT/supervise.sh" >/var/volatile/admin-auth.log 2>&1 </dev/null &
echo $! >/var/run/admin-auth-supervisor.pid
