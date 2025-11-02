#!/bin/bash
set -e

apt update
apt install bind9 -y

# === /etc/bind/named.conf.local ===
cat >/etc/bind/named.conf.local <<'EOF'
// === ZONES for K13.com (MASTER) ===
zone "K13.com" {
    type master;
    file "/etc/bind/zones/db.K13.com";
    allow-transfer { 10.70.3.21; };   // Amdir (SLAVE)
    also-notify { 10.70.3.21; };
};

zone "1.70.10.in-addr.arpa" {
    type master;
    file "/etc/bind/zones/db.10.70.1";
    allow-transfer { 10.70.3.21; };
};

zone "2.70.10.in-addr.arpa" {
    type master;
    file "/etc/bind/zones/db.10.70.2";
    allow-transfer { 10.70.3.21; };
};

zone "3.70.10.in-addr.arpa" {
    type master;
    file "/etc/bind/zones/db.10.70.3";
    allow-transfer { 10.70.3.21; };
};

zone "4.70.10.in-addr.arpa" {
    type master;
    file "/etc/bind/zones/db.10.70.4";
    allow-transfer { 10.70.3.21; };
};

zone "5.70.10.in-addr.arpa" {
    type master;
    file "/etc/bind/zones/db.10.70.5";
    allow-transfer { 10.70.3.21; };
};
EOF

mkdir -p /etc/bind/zones

# === /etc/bind/zones/db.K13.com ===
cat >/etc/bind/zones/db.K13.com <<'EOF'
$TTL 604800
@   IN  SOA ns1.K13.com. root.K13.com. (
        2025110201 ; Serial (YYYYMMDDNN)
        3600       ; Refresh
        1800       ; Retry
        1209600    ; Expire
        86400 )    ; Negative TTL

; Nameservers
@               IN  NS  ns1.K13.com.
@               IN  NS  ns2.K13.com.

; NS addresses
ns1             IN  A   10.70.3.20   ; Erendis (MASTER)
ns2             IN  A   10.70.3.21   ; Amdir   (SLAVE)

; ======== A records per topologi ========

; Subnet 10.70.4.0/24 (prefix.4) via Switch4
palantir        IN  A   10.70.4.21	;
aldarion        IN  A   10.70.4.20   ; DHCP server (referensi)
narvi           IN  A   10.70.4.22  ; (opsional, kalau dipakai)

; Subnet 10.70.1.0/24 (prefix.1) via Switch1/Switch8 — keluarga manusia
elendil         IN  A   10.70.1.20 ;
isildur         IN  A   10.70.1.21 ;
anarion         IN  A   10.70.1.22 ;
miriel		IN  A   10.70.1.23 ;
amandil		IN  A   10.70.1.24 ;
elros           IN  A   10.70.1.25 ;

; Subnet 10.70.2.0/24 (prefix.2) — keluarga peri (elf)
Pharazon        IN  A   10.70.2.22 ;
celebrimbor     IN  A   10.70.2.21 ;
gilgalad        IN  A   10.70.2.20 ; 

; Subnet 10.70.5.0/24 (prefix.5)
minastir        IN  A   10.70.5.20
EOF

# === /etc/bind/zones/db.10.70.1 ===
cat >/etc/bind/zones/db.10.70.1 <<'EOF'
$TTL 604800
@ IN SOA ns1.K13.com. root.K13.com. (2025110201 3600 1800 1209600 86400)
@ IN NS  ns1.K13.com.
@ IN NS  ns2.K13.com.

20  IN PTR elendil.K13.com.
21  IN PTR isildur.K13.com.
22  IN PTR anarion.K13.com.
23  IN PTR miriel.K13.com.
24  IN PTR amandil.K13.com.
25  IN PTR elros.K13.com.
EOF

# === /etc/bind/zones/db.10.70.2 ===
cat >/etc/bind/zones/db.10.70.2 <<'EOF'
$TTL 604800
@ IN SOA ns1.K13.com. root.K13.com. (2025110201 3600 1800 1209600 86400)
@ IN NS  ns1.K13.com.
@ IN NS  ns2.K13.com.

20  IN PTR gilgalad.K13.com.
21  IN PTR celebrimbor.K13.com.
22  IN PTR pharazon.K13.com.
EOF

# === /etc/bind/zones/db.10.70.3 ===
cat >/etc/bind/zones/db.10.70.3 <<'EOF'
$TTL 604800
@ IN SOA ns1.K13.com. root.K13.com. (2025110201 3600 1800 1209600 86400)
@ IN NS  ns1.K13.com.
@ IN NS  ns2.K13.com.

20  IN PTR ns1.K13.com.
21  IN PTR ns2.K13.com.
95  IN PTR khamul.K13.com.   ; kalau kamu pake fixed 10.70.3.95
EOF

# === /etc/bind/zones/db.10.70.4 ===
cat >/etc/bind/zones/db.10.70.4 <<'EOF'
$TTL 604800
@ IN SOA ns1.K13.com. root.K13.com. (2025110201 3600 1800 1209600 86400)
@ IN NS  ns1.K13.com.
@ IN NS  ns2.K13.com.

20  IN PTR aldarion.K13.com.
21  IN PTR palantir.K13.com.
22  IN PTR narvi.K13.com.
EOF

# === /etc/bind/zones/db.10.70.5 ===
cat >/etc/bind/zones/db.10.70.5 <<'EOF'
$TTL 604800
@ IN SOA ns1.K13.com. root.K13.com. (2025110201 3600 1800 1209600 86400)
@ IN NS  ns1.K13.com.
@ IN NS  ns2.K13.com.

20  IN PTR minastir.K13.com.
EOF

# === checks ===
named-checkconf
named-checkzone K13.com /etc/bind/zones/db.K13.com
named-checkzone 1.70.10.in-addr.arpa /etc/bind/zones/db.10.70.1
named-checkzone 2.70.10.in-addr.arpa /etc/bind/zones/db.10.70.2
named-checkzone 3.70.10.in-addr.arpa /etc/bind/zones/db.10.70.3
named-checkzone 4.70.10.in-addr.arpa /etc/bind/zones/db.10.70.4
named-checkzone 5.70.10.in-addr.arpa /etc/bind/zones/db.10.70.5

# named -4 -g -u bind -c /etc/bind/named.conf   # (foreground, optional)
named -4 -u bind -c /etc/bind/named.conf &

pgrep -a named
ss -lntup | grep :53
dig @127.0.0.1 K13.com NS +short
dig @127.0.0.1 palantir.K13.com +short
