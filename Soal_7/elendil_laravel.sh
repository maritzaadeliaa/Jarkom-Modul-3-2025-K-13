#!/bin/bash
set -e

apt update
apt install -y ca-certificates lsb-release apt-transport-https curl gnupg git unzip software-properties-common

# Repo PHP 8.4 Sury
curl -fsSL https://packages.sury.org/php/apt.gpg | gpg --dearmor -o /usr/share/keyrings/sury.gpg
echo "deb [signed-by=/usr/share/keyrings/sury.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/sury-php.list

apt update
apt install -y php8.4 php8.4-fpm php8.4-cli php8.4-mbstring php8.4-xml php8.4-curl php8.4-zip php8.4-mysql nginx git unzip

# Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php --install-dir=/usr/local/bin --filename=composer
rm composer-setup.php

# Clone Laravel Resource
mkdir -p /var/www/laravel
cd /var/www/laravel
git clone https://github.com/elshiraphine/laravel-simple-rest-api
cd laravel-simple-rest-api

composer install
cp .env.example .env || true
php artisan key:generate || true

chown -R www-data:www-data /var/www/laravel/laravel-simple-rest-api
chmod -R 775 storage bootstrap/cache

# Nginx config
cat >/etc/nginx/sites-available/elendil.conf <<EOF
server {
    listen 80;
    server_name elendil.K13.com;

    root /var/www/laravel/laravel-simple-rest-api/public;
    index index.php index.html;

    error_log /var/log/nginx/error.log;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }
    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
    }
}
EOF

ln -sf /etc/nginx/sites-available/elendil.conf /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

systemctl restart php8.4-fpm nginx
