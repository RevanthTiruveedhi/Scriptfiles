#!/bin/bash

sudo su
cd
sudo apt update
sudo apt install apache2
sudo apache2 -version
sudo ufw enable
sudo ufw allow 'Apache'
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw reload
rm -r /var/www/html/index.html
echo "Hello world!" >> /var/www/html/index.html
sudo a2enmod ssl
sudo a2ensite default-ssl.conf
sudo systemctl restart apache2

sudo vgcreate LVGroupname /dev/sdc
sudo lvcreate -L 2G -n LVMvolumename LVGroupname
mkfs -t ext4 /dev/LVGroupname/LVMvolumename
e2label /dev/LVGroupname/LVMvolumename Volumelabelname
mkdir /mnt/LVMvolumename
sudo mount /dev/LVGroupname/LVMvolumename /mnt/LVMvolumename
echo "Hello world! we are at new location" >> /mnt/LVMvolumename/LVMvolumename/index.html
sudo sed -i 's/mnt\/LVMvolumename\/LVMvolumename/var\/www\/html/g' /etc/apache2/apache2.conf
sudo sed -i 's/mnt\/LVMvolumename\/LVMvolumename/var\/www\/html/g' /etc/apache2/sites-enabled/000-default.conf
sudo sed -i 's/mnt\/LVMvolumename\/LVMvolumename/var\/www\/html/g' /etc/apache2/sites-enabled/default-ssl.conf
sudo systemctl restart apache2


sudo apt install default-jre
sudo apt install default-jdk
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.11.1-linux-x86_64.tar.gz
tar -xf elasticsearch-7.11.1-linux-x86_64.tar.gz
cd elasticsearch-7.11.1/bin/
./elasticsearch &
sudo sed -i '/<\/VirtualHost>/i ProxyPass \/ http:\/\/localhost:9200\/' /etc/apache2/sites-available/default-ssl.conf
sudo a2enmod
