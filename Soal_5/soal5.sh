
# ERENDIS

nano /etc/bind/zones/db.K13.com

Tambah di bagian bawah file zona db.K13.com:

; Alias www
www     IN  CNAME   K13.com.

; TXT Records (pesan rahasia)
cincin-sauron       IN  TXT  "Cincin Sauron -> elros.K13.com"
aliansi-terakhir    IN  TXT  "Aliansi Terakhir -> pharazon.K13.com"

nano /etc/bind/named.conf.local

zone "70.10.in-addr.arpa" {
    type master;
    file "/etc/bind/zones/db.10.70";
    allow-transfer { 10.70.4.22; };   // ke ns2
};

nano /etc/bind/zones/db.10.70

$TTL 604800
@   IN  SOA ns1.K13.com. root.K13.com. (
        2025103102 ;
        3600
        1800
        604800
        86400 )

@       IN  NS    ns1.K13.com.
@       IN  NS    ns2.K13.com.

21      IN  PTR   ns1.K13.com.
22      IN  PTR   ns2.K13.com.

pkill named
named -g -c /etc/bind/named.conf &

Testing di client (atau Minastir)
dig www.K13.com +short

dig cincin-sauron.K13.com TXT +short
dig aliansi-terakhir.K13.com TXT +short

"Cincin Sauron -> elros.K13.com"
"Aliansi Terakhir -> pharazon.K13.com"

dig -x 10.70.4.21 +short
dig -x 10.70.4.22 +short

ns1.K13.com.
ns2.K13.com.




