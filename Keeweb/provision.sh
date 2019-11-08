#!/bin/bash

sudo su -
apt-get update -y
apt-get install nginx-full apache2-utils git -y
cd /var/www/html/
git clone -b gh-pages https://github.com/keeweb/keeweb.git
chown -R www-data: /var/www/html/keeweb
cat <<EOF > /etc/nginx/sites-available/keeweb.conf
server {
    listen 80 default_server;
    server_name localhost;

    root /var/www/html/keeweb;

    index index.html;

    charset utf-8;

    location / {
      auth_basic "Restricted";
      auth_basic_user_file "/etc/nginx/htpasswd";

      dav_methods PUT DELETE MKCOL COPY MOVE;
      dav_ext_methods PROPFIND OPTIONS;
      dav_access group:rw all:r;

      add_header 'Access-Control-Allow-Origin' '*' always;
      add_header 'Access-Control-Allow-Credentials' 'true' always;
      add_header 'Access-Control-Allow-Methods' 'GET, HEAD, POST, PUT, OPTIONS, MOVE, DELETE, COPY, LOCK, UNLOCK' always;
      add_header 'Access-Control-Allow-Headers' 'Authorization,DNT,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,X-Accept-Charset,X-Accept,origin,accept,if-match,destination,overwrite' always;
      add_header 'Access-Control-Expose-Headers' 'ETag' always;
      add_header 'Access-Control-Max-Age' 1728000 always;
      if (\$request_method = 'OPTIONS') {
        add_header 'Content-Type' 'text/plain charset=UTF-8';
        add_header 'Content-Length' 0;
        add_header 'Access-Control-Allow-Origin' '*';
        add_header 'Access-Control-Allow-Credentials' 'true';
        add_header 'Access-Control-Allow-Methods' 'GET, HEAD, POST, PUT, OPTIONS, MOVE, DELETE, COPY, LOCK, UNLOCK';
        add_header 'Access-Control-Allow-Headers' 'Authorization,DNT,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,X-Accept-Charset,X-Accept,origin,accept,if-match,destination,overwrite';
        add_header 'Access-Control-Expose-Headers' 'ETag';
        add_header 'Access-Control-Max-Age' 1728000;
        return 204;
      }
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    access_log  /var/log/nginx/keeweb.access.log;
    error_log   /var/log/nginx/keeweb.error.log;

    sendfile off;

    location ~ /\.ht {
        deny all;
    }


}
EOF
rm -f /etc/nginx/sites-enabled/*
ln -s /etc/nginx/sites-available/keeweb.conf  /etc/nginx/sites-enabled/keeweb.conf
service nginx restart
echo "certbot --nginx -d <DomainName>"
echo "htpasswd -c /etc/nginx/htpasswd <user>"
