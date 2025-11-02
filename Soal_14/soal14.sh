#!/bin/bash
# /root/setup_laravel_worker.sh <APP_NAME> <APP_PORT>
set -e
APP_NAME=${1:-elendil}
APP_PORT=${2:-8001}

apt update
apt install -y nginx php8.4-fpm php8.4-mysql php8.4-xml php8.4-mbstring git unzip curl
# composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# simple example app folder
mkdir -p /var/www/${APP_NAME}
chown -R www-data:www-data /var/www/${APP_NAME}

# buat simple nginx conf listening di port APP_PORT
cat > /etc/nginx/sites-available/${APP_NAME} <<EOF
server {
    listen ${APP_PORT};
    server_name ${APP_NAME}.K13.com;

    root /var/www/${APP_NAME}/public;
    index index.php index.html;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }
}
EOF

ln -sf /etc/nginx/sites-available/${APP_NAME} /etc/nginx/sites-enabled/${APP_NAME}
nginx -t && systemctl reload nginx

echo "Worker ${APP_NAME} ready on port ${APP_PORT} (dokumen kosong, isi aplikasi Laravel secara manual)"
