#!/bin/bash

sudo su -
apt-get update -y

apt-get install postgresql gnupg -y

wget -O - https://nightly.odoo.com/odoo.key | apt-key add -
echo "deb http://nightly.odoo.com/13.0/nightly/deb/ ./" >> /etc/apt/sources.list.d/odoo.list
apt-get update
apt-get install odoo -y

apt-get install -y python3-pip
pip3 install xlwt

wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.stretch_amd64.deb
apt-get install xfonts-75dpi xfonts-base -y
apt --fix-broken install -y
dpkg -i wkhtmltox_0.12.5-1.stretch_amd64.deb

systemctl restart odoo.service
# odoo@toto.com/admin
