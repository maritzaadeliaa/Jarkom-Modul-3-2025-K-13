#!/bin/bash
set -e

apt update
apt install isc-dhcp-client -y

ip addr flush dev eth0
dhclient eth0
ip a
