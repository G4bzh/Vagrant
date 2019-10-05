#!/bin/bash

sudo su -
apt-get update -y
apt-get install -y  apache2 mariadb-server php libapache2-mod-php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip
mysql --user=root <<EOF
CREATE DATABASE wordpress;
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost' IDENTIFIED BY 'W0rdPr3sspA55w0r2';
FLUSH PRIVILEGES;
EOF
cat <<EOF > /etc/ssl/certs/veryfrog.crt
-----BEGIN CERTIFICATE-----
MIID1TCCAr2gAwIBAgIUNzkacGoGPR/iDmDa5Eyr60+o/G8wDQYJKoZIhvcNAQEL
BQAwejELMAkGA1UEBhMCRlIxDDAKBgNVBAgMA0JaSDEPMA0GA1UEBwwGUkVOTkVT
MREwDwYDVQQKDAhWRVJZRlJPRzEZMBcGA1UEAwwQd3d3LnZlcnlmcm9nLmNvbTEe
MBwGCSqGSIb3DQEJARYPYWRtaW5AYWRtaW4ubmV0MB4XDTE5MTAwNTA5MzAyN1oX
DTI5MTAwMjA5MzAyN1owejELMAkGA1UEBhMCRlIxDDAKBgNVBAgMA0JaSDEPMA0G
A1UEBwwGUkVOTkVTMREwDwYDVQQKDAhWRVJZRlJPRzEZMBcGA1UEAwwQd3d3LnZl
cnlmcm9nLmNvbTEeMBwGCSqGSIb3DQEJARYPYWRtaW5AYWRtaW4ubmV0MIIBIjAN
BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyUVVC3gq8hIZw242g5vgjkc0naf5
Lhc/CQ3pecKQPhRnQ18Bq3q8tYpIq2ic96a5BLaB5DOmYgmmF6iBfIODquNiCaCv
Da1Q4k5hAFfbU9BxoiyQVIGDmK2DK8YhpO2gI8HIvWF/924P3J4D0o1NBhkQEwI+
y/TonyVCesm+joxLZgbOjl+P9W4ngO9fAeiXJQnutoUb1RKbtyD8EGGGBukaNEtB
QCHJ6YadwFf3MESPIQMIsonq5Q9gzkTc8yLmirKmxeInctB31XCzXgQYzOgFbjkh
JcJ4MiVdMZfto6kPbichBQuWbUaK9+oS0O+uSjhEFEvpIWuKCULymU+ZTQIDAQAB
o1MwUTAdBgNVHQ4EFgQUiNT1kxwT/dhDGuxS+EZuJ7V9aRgwHwYDVR0jBBgwFoAU
iNT1kxwT/dhDGuxS+EZuJ7V9aRgwDwYDVR0TAQH/BAUwAwEB/zANBgkqhkiG9w0B
AQsFAAOCAQEAFkS/rs7e493HZQvykLv2wnBLogzs4E5Q1cUUmQ4Rb93UEFPU/Lud
y1ibvb0gRkT8S3JckNsHhgzA1JLZZkfkevTYYhnA42MWbMgYVaYLE2vs8hxW0Mg8
RkHJcUxoyOUfyD/wgQRP3uH0fFgCBPbaEK5os6iARXJhgOfjqTkmnIJbooYTiYwu
98p44ILCCHxTgnnI+phVGJxN5eDK06U4mnqVqHAe4MDqntLrIevGeQF9I9B3JFsH
yQaLtytWoq22O13Y9ibXvQTfGQQV3vKIppkrPWNNGpn1ip6jc3F63XmMMxQfLUuq
a0IWy4sPT9g8q6S00JSl1Yi+L0Qhde4r0g==
-----END CERTIFICATE-----
EOF
cat <<EOF > /etc/ssl/private/veryfrog.key
-----BEGIN PRIVATE KEY-----
MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDJRVULeCryEhnD
bjaDm+CORzSdp/kuFz8JDel5wpA+FGdDXwGrery1ikiraJz3prkEtoHkM6ZiCaYX
qIF8g4Oq42IJoK8NrVDiTmEAV9tT0HGiLJBUgYOYrYMrxiGk7aAjwci9YX/3bg/c
ngPSjU0GGRATAj7L9OifJUJ6yb6OjEtmBs6OX4/1bieA718B6JclCe62hRvVEpu3
IPwQYYYG6Ro0S0FAIcnphp3AV/cwRI8hAwiyierlD2DORNzzIuaKsqbF4idy0HfV
cLNeBBjM6AVuOSElwngyJV0xl+2jqQ9uJyEFC5ZtRor36hLQ765KOEQUS+kha4oJ
QvKZT5lNAgMBAAECggEAEIT7RPS4+aNYr/ykxsqNdMANZn856XmI9/JHXnIEqsO7
8gCjP3LUeEYATulIMN9jQirEoHlIx7UpB7oR3qlgri75hfbFR2cZQ2nRdli/rLJo
ETp9IiJ7LZXYNUiOzF2gji7CjiCpgyJqdN4XTDnCv6Rg+F5vzwer7Bv/x9o1JLfj
sugfd9oOU5GdRHJkqSnEM4v3c7BRr09GzQzYILGIO6xeehZQrctPELbqy7HgQMdy
tuU/IDX0rrgfU+TJIFSFJIY/W8KgIbOlDbLkoUJm36mPOWs5y5tYEzoX146zz7m4
oEJYHG6Wkur+g+IRm+l5u9WyYoS6iV0TDCArM1+6QQKBgQD4UNf7RBRk5etcZxdo
yvZkxEbrq3swLh+wvcO3I66hVizcm3mwi51dk/iKOYbKgRsNvRB74mB9reEr5iE1
fNLV4N5m3da8Fu7zzC55kSmz4ULjEH74XkrtkU4QxTurZpVjxfkZhISiKU3moV8Y
eh98xlmpb5aAmPaqkzePcdyo0QKBgQDPf8xvD8cLAEi9ArrUfh/F5liMLGl37MTX
04uRea8W5ALohwdnS2LUXsnsYGDDeUEKTDNeuMo/KVciTCAtz2w3o7f8OsLYkW7g
iiRGQx5x9TDGqAuUcPwaC3zemLDQI5bp9NpL5zLPc9J/74Zitdn3fC/JUkXlgatY
w8ziAoVHvQKBgDjOveqE06mVk/equgdGT4IUCSmHLIKEOsnDUBAIwL22KkM56mgC
OLkczgJJUNXpHVhSRYAh9PMroVTarARBjzZQ4HBmFecn0/jAYG19US4Ova+WqYWG
hNu+nz5k8NawfEK8GtXEpFc43dKCXnAKGEQCWKbTmXnIBL5XOaG+ab3RAoGAMjyz
xzPfsecotTJC/41lrek+CPn7swBNDB/4i4kVfgpINfnzLewPinFEnAkdhFYIDDE0
wrskpDQjF3es1sqAXdwygEvNvtc/K/fmHmjDpz2AyKgI3bCZKMkdO1tme44STKRu
cbARGi7liPn55E447nVPsINNzuodDQmiwhlwIVUCgYBaC5yxXOR/CLTCeIUDQAsD
2jucvKJq38R1GnO4nR/GAHqmsw23UQETPgNqAOiVQ/fudft+z8y7oV9cNsNV9Aiz
FaWnoD6eLsyQuhZvvUYnqeLYJMDU/M3dK1TVUGJevnMuXq5K/qXhkNKCDtzus9ki
710hkJ8sCU9jXxeWxCmq3w==
-----END PRIVATE KEY-----
EOF
cat <<EOF > /etc/apache2/sites-available/wordpress.conf
<VirtualHost *:443>
     ServerAdmin admin@example.com
     DocumentRoot /var/www/html/wordpress/
     ServerName www.veryfrog.com
     ServerAlias www.veryfrog.com

     SSLEngine on
     SSLCertificateFile    /etc/ssl/certs/veryfrog.crt
     SSLCertificateKeyFile /etc/ssl/private/veryfrog.key

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
a2enmod ssl
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
# Cert generated via
# openssl req -newkey rsa:2048 -nodes -keyout veryfrog.key -x509 -days 3650 -out veryfrog.crt
