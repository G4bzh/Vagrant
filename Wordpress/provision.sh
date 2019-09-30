#!/bin/bash

sudo su -
apt-get update -y
apt-get install -y  apache2 mariadb-server php libapache2-mod-php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip
mysql --user=root <<EOF
CREATE DATABASE wordpress;
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost' IDENTIFIED BY 'W0rdPr3sspA55w0r2';
FLUSH PRIVILEGES;
EOF
cat <<EOF > /etc/apache2/sites-available/wordpress.conf
<VirtualHost *:80>
     ServerAdmin admin@example.com
     DocumentRoot /var/www/html/wordpress/
     ServerName localhost
     ServerAlias localhost

     <Directory /var/www/html/wordpress/>
        Options +FollowSymlinks
        AllowOverride All
        Require all granted
     </Directory>

     ErrorLog ${APACHE_LOG_DIR}/error.log
     CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>
EOF
a2ensite wordpress.conf
a2enmod rewrite
systemctl restart apache2
wget -q https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
rm -f latest.tar.gz
touch wordpress/.htaccess
cp wordpress/wp-config-sample.php wordpress/wp-config.php
sed -i 's/database_name_here/wordpress/' wordpress/wp-config.php
sed -i 's/username_here/wordpress/' wordpress/wp-config.php
sed -i 's/password_here/W0rdPr3sspA55w0r2/' wordpress/wp-config.php
mkdir wordpress/wp-content/upgrade
cp -a wordpress/. /var/www/html/wordpress
find /var/www/html/wordpress/ -type d -exec chmod 750 {} \;
find /var/www/html/wordpress/ -type f -exec chmod 640 {} \;
chown -R www-data:www-data /var/www/html/wordpress
