#!/bin/bash
set -e

# === /etc/bind/named.conf.local ===
cat >/etc/bind/named.conf.local <<'EOF'
zone "K13.com" {
  type slave;
  masters { 10.70.3.20; };          // IP Erendis (MASTER)
  file "/var/lib/bind/db.K13.com";
};

zone "1.70.10.in-addr.arpa" { type slave; masters { 10.70.3.20; }; file "/var/lib/bind/db.10.70.1"; };
zone "2.70.10.in-addr.arpa" { type slave; masters { 10.70.3.20; }; file "/var/lib/bind/db.10.70.2"; };
zone "3.70.10.in-addr.arpa" { type slave; masters { 10.70.3.20; }; file "/var/lib/bind/db.10.70.3"; };
zone "4.70.10.in-addr.arpa" { type slave; masters { 10.70.3.20; }; file "/var/lib/bind/db.10.70.4"; };
zone "5.70.10.in-addr.arpa" { type slave; masters { 10.70.3.20; }; file "/var/lib/bind/db.10.70.5"; };
EOF

# === /etc/bind/named.conf.options ===
cat >/etc/bind/named.conf.options <<'EOF'
options {
    directory "/var/cache/bind";
    listen-on { any; };
    allow-query { any; };

    recursion no;                 // <— penting agar tidak lari ke internet
    allow-recursion { none; };

    dnssec-validation no;
    auth-nxdomain no;
};
EOF

# named -4 -g -u bind -c /etc/bind/named.conf   # (foreground, optional)
named -4 -u bind -c /etc/bind/named.conf &

dig @10.70.3.21 K13.com NS +short
dig @10.70.3.21 palantir.K13.com +short
dig @10.70.3.21 -x 10.70.4.21 +short
