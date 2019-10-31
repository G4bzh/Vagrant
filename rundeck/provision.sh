#!/bin/sh
echo "Provisionning VM..."
sudo su -
apt-get update
apt-get install -y curl
echo "deb https://rundeck.bintray.com/rundeck-deb /" | sudo tee -a /etc/apt/sources.list.d/rundeck.list
curl 'https://bintray.com/user/downloadSubjectPublicKey?username=bintray' | su do apt-key add -
apt-get update
apt-get install rundeck -y
apt-get install mariadb-server -y
mysql --user=root <<EOF
CREATE DATABASE rundeck;
GRANT ALL PRIVILEGES ON rundeck.* TO 'rundeck'@'localhost' IDENTIFIED BY 'rundeck';
FLUSH PRIVILEGES;
EOF
sed -i 's/^dataSource/\#dataSource/g' /etc/rundeck/rundeck-config.properties
echo "dataSource.url = jdbc:mysql://localhost/rundeck?autoReconnect=true&useSSL=false" >> /etc/rundeck/rundeck-config.properties
echo "dataSource.username=rundeck" >> /etc/rundeck/rundeck-config.properties
echo "dataSource.password=rundeck" >> /etc/rundeck/rundeck-config.properties
echo "dataSource.driverClassName=com.mysql.jdbc.Driver" >> /etc/rundeck/rundeck-config.properties
systemctl restart rundeckd.service
