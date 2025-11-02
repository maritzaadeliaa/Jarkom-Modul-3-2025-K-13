#!/bin/bash
set -e

# Tambah CNAME & TXT ke zone K13.com
cat >>/etc/bind/zones/db.K13.com <<'EOF'

; === CNAME untuk alias website ===
www     IN  CNAME   K13.com.

; === Pesan rahasia ===
CincinSauron     IN TXT "Lokasi: Elros"
AliansiTerakhir  IN TXT "Lokasi: Pharazon"
EOF

# Tambah PTR nameserver ke reverse zone 10.70.3
cat >>/etc/bind/zones/db.10.70.3 <<'EOF'

; PTR record untuk nameserver
20  IN PTR ns1.K13.com.
21  IN PTR ns2.K13.com.
EOF

# Jalankan named (background)
named -4 -u bind -c /etc/bind/named.conf &
