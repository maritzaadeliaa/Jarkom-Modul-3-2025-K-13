# Aldarion
nano /etc/dhcp/dhcpd.conf

ddns-update-style none;
authoritative;

default-lease-time 600;
max-lease-time 7200;

# ==========================
#  Subnet Manusia (10.70.1.0/24)
# ==========================
subnet 10.70.1.0 netmask 255.255.255.0 {
    range 10.70.1.6 10.70.1.34;
    range 10.70.1.68 10.70.1.94;
    option routers 10.70.1.1;
    option domain-name-servers 10.70.5.2;
}

# ==========================
#  Subnet Peri (10.70.2.0/24)
# ==========================
subnet 10.70.2.0 netmask 255.255.255.0 {
    range 10.70.2.35 10.70.2.67;
    range 10.70.2.96 10.70.2.121;
    option routers 10.70.2.1;
    option domain-name-servers 10.70.5.2;
}

# ==========================
#  Static untuk Khamul
# ==========================
host khamul {
    hardware ethernet 02:42:4e:5e:98:00;  # MAC Khamul
    fixed-address 10.70.3.95;
}

# ==========================
#  Subnet Khamul (wajib ada kosong)
# ==========================
subnet 10.70.3.0 netmask 255.255.255.0 { }

# ==========================
#  Subnet Server Aldarion
# ==========================
subnet 10.70.4.0 netmask 255.255.255.0 {
    range 10.70.4.30 10.70.4.50;
    option routers 10.70.4.1;
}

# ==========================
#  Subnet DNS (kosong)
# ==========================
subnet 10.70.5.0 netmask 255.255.255.0 { }

pkill dhcpd
dhcpd -4 -d -cf /etc/dhcp/dhcpd.conf eth0
