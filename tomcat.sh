#!/bin/bash

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
sudo systemctl restart apache2