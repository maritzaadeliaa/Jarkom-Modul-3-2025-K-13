#!/bin/bash
# /root/setup_bind_slave_amdir.sh
set -e
apt update
apt install -y bind9 bind9utils

# contoh IP Erendis dari soal = 10.70.3.3 (jika berbeda, ubah)
MASTER_IP="10.70.3.3"
ZONE="K13.com"

cat > /etc/bind/named.conf.local <<EOF
zone "${ZONE}" {
  type slave;
  masters { ${MASTER_IP}; };
  file "/var/cache/bind/db.${ZONE}";
};
EOF

systemctl restart bind9
sleep 1
systemctl status bind9 --no-pager

echo "Coba AXFR:"
dig @${MASTER_IP} ${ZONE} AXFR +noall +answer || echo "AXFR gagal - cek allow-transfer di master"
