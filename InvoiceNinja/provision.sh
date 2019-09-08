#!/bin/bash

sudo su -
apt-get update -y
apt-get install nginx php-fpm mysql-server php-cli php-common php-curl php-gd php-mysql php-xml php-mcrypt php-mbstring unzip -y
mysql --user=root <<EOF
CREATE DATABASE ninja;
GRANT ALL PRIVILEGES ON ninja.* TO 'ninja'@'localhost' IDENTIFIED BY 'N!njApA55w0r2';
FLUSH PRIVILEGES;
EOF
# mysql_secure_installation equivalent
myql --user=root <<EOF
UPDATE mysql.user SET Password=PASSWORD('R00tpA55w0r2') WHERE User='root';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
EOF
unzip /vagrant/ninja.zip -d /var/www/html/
chown -R www-data: /var/www/html/ninja
cat <<EOF > /etc/nginx/sites-available/ninja.conf
server {
    listen 80 default_server;
    server_name localhost;

    root /var/www/html/ninja/public;

    index index.php;

    charset utf-8;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    access_log  /var/log/nginx/ninja.access.log;
    error_log   /var/log/nginx/ninja.error.log;

    sendfile off;

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php/php7.0-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF
rm -f /etc/nginx/sites-enabled/*
ln -s /etc/nginx/sites-available/ninja.conf  /etc/nginx/sites-enabled/ninja.conf
service nginx restart
# admin@admin.net/admin@admin.net
