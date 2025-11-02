#!/bin/bash

ip link set eth0 up
ip addr flush dev eth0
ip addr add 10.70.4.20/24 dev eth0      # IP Aldarion sementara (boleh ganti, tetap di 10.70.4.0/24)
ip route replace default via 10.70.4.1   # Gateway = Durin eth4
echo "nameserver 192.168.122.1" > /etc/resolv.conf

# cek ip 
ip -br a
