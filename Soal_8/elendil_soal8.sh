#!/bin/bash
set -e

cd /var/www/laravel/laravel-simple-rest-api

# Tambah konfigurasi DB ke .env
echo "" >> .env
echo "# SOAL 8 DB Palantir" >> .env
echo "DB_CONNECTION=mysql" >> .env
echo "DB_HOST=palantir.K13.com" >> .env
echo "DB_PORT=3306" >> .env
echo "DB_DATABASE=laravel" >> .env
echo "DB_USERNAME=laravel" >> .env
echo "DB_PASSWORD=laravel123" >> .env

# Ubah port Nginx jadi 8001
sed -i 's/listen 80;/listen 8001;/' /etc/nginx/sites-available/elendil.conf

# Blok akses langsung via IP
cat >/etc/nginx/sites-available/deny_ip_elendil.conf <<EOF
server {
    listen 8001 default_server;
    server_name _;
    return 444;
}
EOF

ln -sf /etc/nginx/sites-available/deny_ip_elendil.conf /etc/nginx/sites-enabled/deny_ip_elendil.conf

nginx -t
systemctl restart nginx

# Migrate & seed
php artisan migrate --force
php artisan db:seed --force
