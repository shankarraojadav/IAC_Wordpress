#!/bin/bash

# Update packages and install Apache
sudo apt update -y
sudo apt install -y apache2

# Enable Apache to start on boot
sudo systemctl enable apache2

# Start Apache
sudo systemctl start apache2

# Install PHP
sudo apt install -y php libapache2-mod-php php-mysql

# Install MySQL client (if needed)
# sudo apt install -y mysql-client

# Download and extract WordPress
sudo wget -c https://wordpress.org/latest.tar.gz -O /tmp/latest.tar.gz
sudo tar -xzvf /tmp/latest.tar.gz -C /var/www/html/

# Configure permissions
sudo chown -R www-data:www-data /var/www/html/wordpress

# Configure WordPress
sudo mv /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
sudo sed -i "s/database_name_here/${db_name}/g" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/username_here/${db_username}/g" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/password_here/${db_password}/g" /var/www/html/wordpress/wp-config.php


# Restart Apache
sudo systemctl restart apache2
