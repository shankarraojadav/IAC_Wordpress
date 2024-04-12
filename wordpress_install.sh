#!/bin/bash
sudo yum update -y
sudo yum install -y httpd php php-mysql
sudo systemctl start httpd
sudo systemctl enable httpd
sudo amazon-linux-extras install -y php7.4
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xzf latest.tar.gz -C /var/www/html/
sudo chown -R apache:apache /var/www/html/wordpress
sudo cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
sudo sed -i 's/database_name_here/your_database_name/g' /var/www/html/wordpress/wp-config.php
sudo sed -i 's/username_here/your_database_username/g' /var/www/html/wordpress/wp-config.php
sudo sed -i 's/password_here/your_database_password/g' /var/www/html/wordpress/wp-config.php
sudo systemctl restart httpd