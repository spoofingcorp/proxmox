nano /etc/pve/firewall/cluster.fw

_____________________________________

[OPTIONS]

enable: 1

[IPSET cluster_ip]

10.10.0.0/24
10.20.0.0/24
10.30.0.0/24
10.40.0.0/24
192.168.1.0/24

[IPSET ip_admin]

192.168.1.0/24

[IPSET ip_ceph]

10.20.0.0/24
10.30.0.0/24

[RULES]

IN ACCEPT -source +dc/ip_ceph -dest +dc/ip_ceph -log nolog
IN ACCEPT -source +dc/cluster_ip -dest +dc/cluster_ip -p udp -sport 111 -log nolog
IN ACCEPT -source +dc/cluster_ip -dest +dc/cluster_ip -p tcp -dport 2049,111 -log nolog
IN ACCEPT -source +dc/cluster_ip -dest +dc/cluster_ip -p tcp -dport 60000:60050 -log nolog
IN ACCEPT -source +dc/cluster_ip -dest +dc/cluster_ip -p tcp -dport 3128 -log nolog
IN ACCEPT -source +dc/cluster_ip -dest +dc/cluster_ip -p tcp -dport 6844 -log nolog
IN ACCEPT -source +dc/cluster_ip -dest +dc/cluster_ip -p tcp -dport 6844 -log nolog
IN ACCEPT -source +dc/cluster_ip -dest +dc/cluster_ip -p tcp -dport 6800:7300 -log nolog
IN ACCEPT -source +dc/cluster_ip -dest +dc/cluster_ip -p tcp -dport 3300:6789 -log nolog
IN ACCEPT -source +dc/cluster_ip -dest +dc/cluster_ip -p igmp -log nolog
IN ACCEPT -source +dc/cluster_ip -dest +dc/cluster_ip -p tcp -dport 3260 -log nolog
IN ACCEPT -source +dc/cluster_ip -dest +dc/cluster_ip -p icmp -log nolog
IN ACCEPT -source +dc/cluster_ip -dest +dc/cluster_ip -p tcp -sport 60000:60050 -log nolog
IN ACCEPT -source +dc/cluster_ip -dest +dc/cluster_ip -p tcp -dport 3128 -log nolog
IN ACCEPT -source +dc/cluster_ip -dest +dc/cluster_ip -p tcp -sport 5900:5999 -log nolog
IN ACCEPT -source +dc/cluster_ip -dest +dc/cluster_ip -p udp -sport 5405:5412 -log nolog # coro
IN ACCEPT -source +ip_admin -dest +dc/cluster_ip -p tcp -dport 22,8006 -log nolog # Accès Admin SSH/WebUI
IN SSH(ACCEPT) -source +dc/cluster_ip -dest +dc/cluster_ip -log nolog
