
# ERENDIS (MASTER – ns1)

apt update
apt install -y bind9 bind9utils

nano /etc/bind/named.conf.options

options {
    directory "/var/cache/bind";
    dnssec-validation no;
    listen-on { any; };
    allow-query { any; };

    // biar bisa resolve ke internet
    forwarders { 192.168.122.1; 8.8.8.8; };
};

named.conf.local

nano /etc/bind/named.conf.local

zone "K13.com" {
    type master;
    file "/etc/bind/zones/db.K13.com";
    allow-transfer { 10.70.4.22; };   // IP Amdir (ns2)
    also-notify { 10.70.4.22; };
};

mkdir -p /etc/bind/zones
nano /etc/bind/zones/db.K13.com

$TTL    604800
@       IN      SOA     ns1.K13.com. root.K13.com. (
                        2025100401      ; Serial (YYYYMMDDnn) → NAIKKAN jika mengubah file ini
                        604800          ; Refresh
                        86400           ; Retry
                        2419200         ; Expire
                        604800 )        ; Neg TTL
;

@       IN      NS      ns1.K13.com.
@       IN      NS      ns2.K13.com.

; A records
ns1     IN      A       10.70.3.3       ; Erendis (master)
ns2     IN      A       10.70.3.4       ; Amdir (slave)

; Lokasi penting (EDIT jika IP hostmu beda)
palantir    IN  A   10.70.4.20
elros       IN  A   10.70.3.10
pharazon    IN  A   10.70.4.30
elendil     IN  A   10.70.1.10
isildur     IN  A   10.70.1.11
anarion     IN  A   10.70.1.12
galadriel   IN  A   10.70.2.10
celeborn    IN  A   10.70.2.11
oropher     IN  A   10.70.2.12
EOF

pkill named 2>/dev/null
named -g -c /etc/bind/named.conf &
