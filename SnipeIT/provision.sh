#!/bin/bash

sudo su -
apt-get update -y

# Requirements
apt-get install nginx-full git php-fpm php-mbstring php-curl php-mysql php-ldap php-zip php-bcmath php-xml php-imagick php-gd curl -y
apt-get install mariadb-server -y

# Donwloading
cd /var/www
git clone https://github.com/snipe/snipe-it

# Configuration
mysql -u root <<EOF
create database snipeit;
create user snipe_user;
grant all on snipeit.* to 'snipe_user'@'localhost' identified by 'YOUR_DB_PASSWORD_HERE';
flush privileges;
EOF

cat >/var/www/snipe-it/.env <<EOF
# --------------------------------------------
# REQUIRED: BASIC APP SETTINGS
# --------------------------------------------
APP_ENV=production
APP_DEBUG=false
APP_KEY=ChangeMe
APP_URL=http://localhost
APP_TIMEZONE='UTC'
APP_LOCALE=fr
MAX_RESULTS=500

# --------------------------------------------
# REQUIRED: DATABASE SETTINGS
# --------------------------------------------
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_DATABASE=snipeit
DB_USERNAME=snipe_user
DB_PASSWORD=YOUR_DB_PASSWORD_HERE
DB_PREFIX=null
DB_DUMP_PATH='/usr/bin'
DB_CHARSET=utf8mb4
DB_COLLATION=utf8mb4_unicode_ci

# --------------------------------------------
# OPTIONAL: SSL DATABASE SETTINGS
# --------------------------------------------
DB_SSL=false
DB_SSL_IS_PAAS=false
DB_SSL_KEY_PATH=null
DB_SSL_CERT_PATH=null
DB_SSL_CA_PATH=null
DB_SSL_CIPHER=null

# --------------------------------------------
# REQUIRED: OUTGOING MAIL SERVER SETTINGS
# --------------------------------------------
MAIL_DRIVER=smtp
MAIL_HOST=email-smtp.us-west-2.amazonaws.com
MAIL_PORT=587
MAIL_USERNAME=YOURUSERNAME
MAIL_PASSWORD=YOURPASSWORD
MAIL_ENCRYPTION=null
MAIL_FROM_ADDR=you@example.com
MAIL_FROM_NAME='Snipe-IT'
MAIL_REPLYTO_ADDR=you@example.com
MAIL_REPLYTO_NAME='Snipe-IT'
MAIL_BACKUP_NOTIFICATION_ADDRESS=you@example.com

# --------------------------------------------
# REQUIRED: IMAGE LIBRARY
# This should be gd or imagick
# --------------------------------------------
IMAGE_LIB=imagick

# --------------------------------------------
# OPTIONAL: SESSION SETTINGS
# --------------------------------------------
SESSION_LIFETIME=12000
EXPIRE_ON_CLOSE=false
ENCRYPT=false
COOKIE_NAME=snipeit_session
COOKIE_DOMAIN=null
SECURE_COOKIES=false

# --------------------------------------------
# OPTIONAL: SECURITY HEADER SETTINGS
# --------------------------------------------
APP_TRUSTED_PROXIES=192.168.1.1,10.0.0.1
ALLOW_IFRAMING=false
REFERRER_POLICY=same-origin
ENABLE_CSP=false
CORS_ALLOWED_ORIGINS=null

# --------------------------------------------
# OPTIONAL: CACHE SETTINGS
# --------------------------------------------
CACHE_DRIVER=file
SESSION_DRIVER=file
QUEUE_DRIVER=sync
CACHE_PREFIX=snipeit

# --------------------------------------------
# OPTIONAL: REDIS SETTINGS
# --------------------------------------------
REDIS_HOST=null
REDIS_PASSWORD=null
REDIS_PORT=null

# --------------------------------------------
# OPTIONAL: MEMCACHED SETTINGS
# --------------------------------------------
MEMCACHED_HOST=null
MEMCACHED_PORT=null

# --------------------------------------------
# OPTIONAL: AWS S3 SETTINGS
# --------------------------------------------
AWS_SECRET=null
AWS_KEY=null
AWS_REGION=null
AWS_BUCKET=null

# --------------------------------------------
# OPTIONAL: LOGIN THROTTLING
# --------------------------------------------
LOGIN_MAX_ATTEMPTS=5
LOGIN_LOCKOUT_DURATION=60

# --------------------------------------------
# OPTIONAL: MISC
# --------------------------------------------
APP_LOG=single
APP_LOG_MAX_FILES=10
APP_LOCKED=false
FILESYSTEM_DISK=local
APP_CIPHER=AES-256-CBC
GOOGLE_MAPS_API=
BACKUP_ENV=true
LDAP_MEM_LIM=500M
LDAP_TIME_LIM=600
EOF

chown -R www-data /var/www/snipe-it/public/uploads/
chown -R www-data /var/www/snipe-it/storage/
chmod -R 755 /var/www/snipe-it/public/uploads/
chmod -R 755  /var/www/snipe-it/storage/

# Dependencies
cd /var/www/snipe-it
curl -sS https://getcomposer.org/installer | php
php composer.phar install --no-dev --prefer-source

# Generate App Key
php artisan key:generate --force

# Configure Nginx
cat >/etc/nginx/sites-available/snipe-it << EOF
server {
    listen 80;
    server_name localhost;

    root /var/www/snipe-it/public/;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php\$is_args\$args;
    }

    location ~ \.php\$ {
        try_files \$uri \$uri/ =404;
        fastcgi_pass unix:/var/run/php/php7.3-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }
}
EOF
ln -s /etc/nginx/sites-available/snipe-it /etc/nginx/sites-enabled/snipe-it
systemctl restart nginx
systemctl restart php7.3-fpm.service
