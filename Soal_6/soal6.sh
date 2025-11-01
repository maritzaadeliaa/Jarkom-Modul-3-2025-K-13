soal6

ALDARION:
nano /etc/dhcp/dhcpd.conf

Manusia — 10.70.1.0/24

subnet 10.70.1.0 netmask 255.255.255.0 {
    range 10.70.1.20 10.70.1.99;
    range 10.70.1.150 10.70.1.169;
    option routers 10.70.1.1;
    option domain-name-servers 10.70.5.2;
    default-lease-time 1800;   # 30 menit
    max-lease-time 3600;       # 60 menit
}

Peri — 10.70.2.0/24

subnet 10.70.2.0 netmask 255.255.255.0 {
    range 10.70.2.30 10.70.2.50;
    range 10.70.2.155 10.70.2.185;
    option routers 10.70.2.1;
    option domain-name-servers 10.70.5.2;
    default-lease-time 600;    # 10 menit (1/6 jam)
    max-lease-time 3600;       # 60 menit
}


Restart DHCP server di Aldarion
pkill dhcpd
dhcpd -4 -d -cf /etc/dhcp/dhcpd.conf eth0 &

Test di salah satu client manusia & peri
ip addr flush dev eth0
dhclient -v eth0

grep lease /var/lib/dhcp/dhclient.leases

/
lease-time 1800;
renew 1800;
/
