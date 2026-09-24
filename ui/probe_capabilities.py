"""Read-only device capability inventory; no settings are changed."""
from pathlib import Path
import subprocess,json,re,gzip
root=Path(__file__).resolve().parents[1]
adb=str(next(root.glob('*/SZ*/adb.exe')))
def read(cmd):
 return subprocess.run([adb,'shell',cmd],text=True,capture_output=True,encoding='utf-8',errors='replace',timeout=20).stdout.strip()
commands={
 'tools':'for tool in tc iw iwconfig hostapd hostapd_cli dnsmasq udhcpd iptables ip6tables ebtables nft conntrack vnstat crond iperf3; do command -v "$tool"; done',
 'wpa_status':'wpa_cli -i wlan0 status',
 'stations':'wpa_cli -i wlan0 all_sta',
 'key_management':'wpa_cli -i wlan0 get_capability key_mgmt',
 'kernel_builtins':'cat /lib/modules/4.14.98/modules.builtin',
 'sfp_enabled':'cat /proc/net/sfp/enable',
 'hostapd_version':'hostapd -v',
 'tc':'tc -s qdisc show',
 'qos_modules':'cat /proc/modules',
 'runtime_paths':'ls /var/run',
 'hostapd_paths':'ls /etc/hostapd* /data/misc/wifi /var/lib/connman',
 'leases_paths':'ls /var/lib/misc /var/lib/dhcp /var/run/udhcp* /tmp/dhcp*',
 'phy':'ls /sys/class/ieee80211',
 'processes':'ps',
 'iptables_matches':'cat /proc/net/ip_tables_matches',
 'ip6tables_matches':'cat /proc/net/ip6_tables_matches',
}
if __name__=='__main__':
 for name,cmd in commands.items():
  out=read(cmd)
  if name=='processes':out='\n'.join(x for x in out.splitlines() if any(v in x for v in ('hostapd','udhcp','dnsmasq','connmand','crond','vnstat','sipa')) and not any(v in x for v in ('sh -c','grep','python')))
  if name=='kernel_builtins':out='\n'.join(x for x in out.splitlines() if '/sched/' in x or 'ifb' in x)
  if name=='qos_modules':out='\n'.join(x for x in out.splitlines() if any(v in x for v in ('sch_','cls_','act_','ifb','sipa','sprd','offload')))
  if name in ('stations','wpa_status'):out=re.sub(r'(?:[0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}','<MAC>',out)
  print(json.dumps({'check':name,'output':out[:6500]},ensure_ascii=True),flush=True)
 raw=subprocess.run([adb,'exec-out','cat','/proc/config.gz'],capture_output=True,timeout=10).stdout
 try:
  if not raw:raise ValueError('No kernel configuration returned')
  config=gzip.decompress(raw).decode()
  print(json.dumps({'check':'kernel_qos','output':'\n'.join(x for x in config.splitlines() if re.search(r'CONFIG_(NET_SCH_(HTB|HFSC|TBF|FQ_CODEL|CAKE|INGRESS)|NET_CLS_(U32|FW|FLOWER)|NET_ACT_(MIRRED|POLICE)|IFB|NETFILTER_XT_MATCH_(MAC|QUOTA|CONNLIMIT|CONNBYTES)|BRIDGE_NETFILTER|NET_NS)',x))}))
 except Exception:print(json.dumps({'check':'kernel_qos','output':'kernel config unavailable'}))
