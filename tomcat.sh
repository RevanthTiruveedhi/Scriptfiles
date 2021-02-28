#!/bin/bash

#Change user to root directory and root folder
sudo su
cd

#Update Ubuntu resources
sudo apt update

#Install Apache
sudo apt install apache2
sudo apache2 -version

#Add firewall rules for HTTPS, SSH, Elasticsearch
sudo ufw enable
sudo ufw allow 'Apache'
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 9200/tcp
sudo ufw reload

#Create tomcat root directory to verify connection
rm -r /var/www/html/index.html
echo "Hello world!" >> /var/www/html/index.html

#configure and enable default SSL
sudo a2enmod ssl
sudo a2ensite default-ssl.conf
sudo systemctl restart apache2

#Create Logical volume and mount the disk
sudo vgcreate LVGroupname /dev/sdc
sudo lvcreate -L 2G -n LVMvolumename LVGroupname
mkfs -t ext4 /dev/LVGroupname/LVMvolumename
e2label /dev/LVGroupname/LVMvolumename Volumelabelname
mkdir /mnt/LVMvolumename
sudo mount /dev/LVGroupname/LVMvolumename /mnt/LVMvolumename

#Redirect the root file of Tomcat to new directory and do the configuration changes to the LV created
echo "Hello world! we are at new location" >> /mnt/LVMvolumename/LVMvolumename/index.html
sudo sed -i 's/mnt\/LVMvolumename\/LVMvolumename/var\/www\/html/g' /etc/apache2/apache2.conf
sudo sed -i 's/mnt\/LVMvolumename\/LVMvolumename/var\/www\/html/g' /etc/apache2/sites-enabled/000-default.conf
sudo sed -i 's/mnt\/LVMvolumename\/LVMvolumename/var\/www\/html/g' /etc/apache2/sites-enabled/default-ssl.conf
sudo systemctl restart apache2

#Install Elasticsearch and configure
sudo apt install default-jre
sudo apt install default-jdk
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.11.1-linux-x86_64.tar.gz
tar -xf elasticsearch-7.11.1-linux-x86_64.tar.gz
cd elasticsearch-7.11.1/bin/
./elasticsearch &


sudo sed -i '/<\/VirtualHost>/i ProxyPass \/ http:\/\/localhost:9200\/' /etc/apache2/sites-available/default-ssl.conf
sudo a2enmod
