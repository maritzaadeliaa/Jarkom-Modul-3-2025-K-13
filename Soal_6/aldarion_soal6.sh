#!/bin/bash
set -e

# Tulis ulang /etc/dhcp/dhcpd.conf persis sesuai instruksi
cat >/etc/dhcp/dhcpd.conf <<'EOF'
default-lease-time 1800;    # default 30 menit jika tidak override
max-lease-time 3600;        # maksimal 1 jam

Subnet Keluarga Manusia (10.70.1.0/24)
subnet 10.70.1.0 netmask 255.255.255.0 {
    range 10.70.1.10 10.70.1.50;
    option routers 10.70.1.1;
    option domain-name-servers 10.70.3.20, 10.70.3.21; 
    default-lease-time 1800;      # 30 menit
    max-lease-time 3600;          # 1 jam
}

Subnet Keluarga Peri (10.70.2.0/24)
subnet 10.70.2.0 netmask 255.255.255.0 {
    range 10.70.2.10 10.70.2.50;
    option routers 10.70.2.1;
    option domain-name-servers 10.70.3.20, 10.70.3.21; 
    default-lease-time 600;       # 10 menit
    max-lease-time 3600;          # 1 jam
}
EOF

service isc-dhcp-server restart
