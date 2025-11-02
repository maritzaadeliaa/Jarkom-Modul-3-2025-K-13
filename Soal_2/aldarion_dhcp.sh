#!/bin/bash
set -e

apt update
apt install isc-dhcp-server -y

# ==== (pengganti nano) tulis /etc/dhcp/dhcpd.conf dengan konten persis ====
cat >/etc/dhcp/dhcpd.conf <<'EOF'
default-lease-time 1800;   # 30 menit (manusia)
max-lease-time 3600;       # 1 jam (maks)
authoritative;

# ========= HUMAN DYNAMIC =========
subnet 10.70.1.0 netmask 255.255.255.0 {
    range 10.70.1.6 10.70.1.34;
    range 10.70.1.68 10.70.1.94;
    option routers 10.70.1.1;
    option broadcast-address 10.70.1.255;
    option domain-name-servers 10.70.3.11;   # nanti ke Erendis (DNS master)
}

# ========= ELF DYNAMIC =========
subnet 10.70.2.0 netmask 255.255.255.0 {
    default-lease-time 600; # 10 menit (elf)
    range 10.70.2.35 10.70.2.67;
    range 10.70.2.96 10.70.2.121;
    option routers 10.70.2.1;
    option broadcast-address 10.70.2.255;
    option domain-name-servers 10.70.3.11;
}

# ========= KHAMUL FIXED ADDRESS =========
host khamul {
    hardware ethernet 02:42:4e:5e:98:00;  # ganti MAC Khamul nanti
    fixed-address 10.70.3.95;
}

# ========= OTHER SUBNETS (no DHCP here) =========
subnet 10.70.3.0 netmask 255.255.255.0 { } # DNS, DB LAN
subnet 10.70.4.0 netmask 255.255.255.0 { } # DHCP server LAN (Aldarion)
subnet 10.70.5.0 netmask 255.255.255.0 { } # PHP segmen, no DHCP
EOF

# ==== set interface default DHCP v4 ====
cat >/etc/default/isc-dhcp-server <<'EOF'
INTERFACESv4="eth0"
EOF

service isc-dhcp-server start
service isc-dhcp-server restart
service isc-dhcp-server status
