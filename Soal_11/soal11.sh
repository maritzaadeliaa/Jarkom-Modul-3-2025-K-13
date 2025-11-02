#!/bin/bash
# /root/check_dhcp.sh
set -e
echo "Periksa isc-dhcp-server status"
systemctl restart isc-dhcp-server
systemctl status isc-dhcp-server --no-pager
echo
echo "Tampilkan konfigurasi dhcpd.conf (baris penting)"
grep -E "subnet|range|host khamul|default-lease-time|max-lease-time" -n /etc/dhcp/dhcpd.conf || true
echo
echo "Cek log terakhir (syslog)"
tail -n 80 /var/log/syslog | egrep -i "dhcp|dhcpd" || true
