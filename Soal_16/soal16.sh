#!/bin/bash
# /root/setup_php_worker.sh <NAME> <PORT>
set -e
NAME=${1:-galadriel}
PORT=${2:-8004}

apt update
apt install -y nginx php8.4-fpm apache2-utils

mkdir -p /var/www/${NAME}
cat > /var/www/${NAME}/index.php <<'PHP'
<?php
echo "Hostname: ".gethostname()."\n";
$real = $_SERVER['HTTP_X_REAL_IP'] ?? $_SERVER['REMOTE_ADDR'];
echo "Your IP: ".$real."\n";
PHP
chown -R www-data:www-data /var/www/${NAME}

htpasswd -b -c /etc/nginx/.htpasswd noldor silvan || true

cat > /etc/nginx/sites-available/${NAME} <<EOF
server {
    listen ${PORT};
    server_name ${NAME}.K13.com;

    root /var/www/${NAME};
    index index.php;

    auth_basic "Restricted";
    auth_basic_user_file /etc/nginx/.htpasswd;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param HTTP_X_REAL_IP \$remote_addr;
        include fastcgi_params;
    }
}
EOF

ln -sf /etc/nginx/sites-available/${NAME} /etc/nginx/sites-enabled/${NAME}
nginx -t && systemctl reload nginx
echo "${NAME} ready on port ${PORT}"
