#!/bin/bash
set -e

cd /var/www/laravel/laravel-simple-rest-api

echo "" >> .env
echo "# SOAL 8 DB Palantir" >> .env
echo "DB_CONNECTION=mysql" >> .env
echo "DB_HOST=palantir.K13.com" >> .env
echo "DB_PORT=3306" >> .env
echo "DB_DATABASE=laravel" >> .env
echo "DB_USERNAME=laravel" >> .env
echo "DB_PASSWORD=laravel123" >> .env

sed -i 's/listen 80;/listen 8003;/' /etc/nginx/sites-available/anarion.conf

cat >/etc/nginx/sites-available/deny_ip_anarion.conf <<EOF
server {
    listen 8003 default_server;
    server_name _;
    return 444;
}
EOF

ln -sf /etc/nginx/sites-available/deny_ip_anarion.conf /etc/nginx/sites-enabled/deny_ip_anarion.conf

nginx -t
systemctl restart nginx
