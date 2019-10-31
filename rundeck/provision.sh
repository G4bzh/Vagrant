#!/bin/sh
echo "Provisionning VM..."
sudo su -
apt-get update
apt-get install -y curl apt-transport-https ca-certificates wget dirmngr gnupg software-properties-common
echo "deb https://rundeck.bintray.com/rundeck-deb /" | sudo tee -a /etc/apt/sources.list.d/rundeck.list
wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public |  apt-key add -
curl 'https://bintray.com/user/downloadSubjectPublicKey?username=bintray' | apt-key add -
add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
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
apt-get install adoptopenjdk-8-hotspot -y
echo "RUN update-alternatives --config java"
echo "CHOOSE openjdk 8"
echo "THEN systemctl restart rundeckd.service"
