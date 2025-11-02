#!/bin/bash

ip link set eth0 up
ip addr flush dev eth0
ip addr add 10.70.2.20/24 dev eth0
ip route replace default via 10.70.2.1
echo "nameserver 192.168.122.1" > /etc/resolv.conf
ping -c 2 8.8.8.8; ping -c 2 google.com
