#!/bin/bash
set -e

apt update
apt install isc-dhcp-client -y
dhclient -r eth0
dhclient eth0
ip a

# Kenapa masih ada 10.70.2.20?
# Karena itu IP manual dari nomor 1 yang masih nempel.
# Kita harus hapus IP statis itu biar murni DHCP.
ip addr flush dev eth0
dhclient eth0
ip a
