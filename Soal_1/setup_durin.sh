#!/bin/bash
set -e

echo "Set IP eth0 (NAT) → 192.168.122.10/24"
ip link set eth0 up || true
ip addr show dev eth0 | grep -q "192.168.122.10/24" || ip addr add 192.168.122.10/24 dev eth0

echo "Tampilkan route saat ini"
ip route || true

echo "Set IP untuk LAN (eth1..eth5)"
ip link set eth1 up || true
ip link set eth2 up || true
ip link set eth3 up || true
ip link set eth4 up || true
ip link set eth5 up || true

ip addr show dev eth1 | grep -q "10.70.1.1/24" || ip addr add 10.70.1.1/24 dev eth1
ip addr show dev eth2 | grep -q "10.70.2.1/24" || ip addr add 10.70.2.1/24 dev eth2
ip addr show dev eth3 | grep -q "10.70.3.1/24" || ip addr add 10.70.3.1/24 dev eth3
ip addr show dev eth4 | grep -q "10.70.4.1/24" || ip addr add 10.70.4.1/24 dev eth4
ip addr show dev eth5 | grep -q "10.70.5.1/24" || ip addr add 10.70.5.1/24 dev eth5

echo "Default route via 192.168.122.1 dev eth0"
ip route del default 2>/dev/null || true
ip route add default via 192.168.122.1 dev eth0

echo "Enable IPv4 forwarding"
echo 1 > /proc/sys/net/ipv4/ip_forward
grep -q '^net.ipv4.ip_forward=1' /etc/sysctl.conf || echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p || true

echo "NAT Masquerade lewat eth0"
if iptables -t nat -C POSTROUTING -o eth0 -j MASQUERADE 2>/dev/null; then
  echo "   - Rule NAT sudah ada"
else
  iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
fi

echo "Set resolver ke 192.168.122.1"
echo "nameserver 192.168.122.1" > /etc/resolv.conf

echo "Test ping (IP & DNS)"
echo "   - Ping 8.8.8.8"
ping -c 3 8.8.8.8 || echo "Ping 8.8.8.8 gagal (cek NAT/route)"
echo "   - Ping google.com"
ping -c 3 google.com || echo "Ping google.com gagal (cek DNS/resolver)"
