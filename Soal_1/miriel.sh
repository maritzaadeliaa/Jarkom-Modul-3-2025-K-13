#!/bin/bash

ip link set eth0 up
ip addr flush dev eth0
ip addr add 10.70.1.23/24 dev eth0
ip route replace default via 10.70.1.1
echo "nameserver 192.168.122.1" > /etc/resolv.conf
ping -c 2 8.8.8.8; ping -c 2 google.com
