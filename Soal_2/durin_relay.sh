#!/bin/bash
set -e

apt update
apt install isc-dhcp-relay -y

# ==== (pengganti nano) tulis /etc/default/isc-dhcp-relay persis ====
cat >/etc/default/isc-dhcp-relay <<'EOF'
SERVERS="10.70.4.20"   # IP Aldarion
INTERFACES="eth1 eth2 eth3 eth4 eth5"
EOF

service isc-dhcp-relay restart
service isc-dhcp-relay status
ps aux | grep dhcp
