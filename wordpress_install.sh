#!/bin/bash
sudo su
# Install Docker
echo "Installing Docker..."
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo usermod -aG docker $USER
sudo apt update


sudo apt install -y docker-ce

# Install Docker Compose
echo "Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Create a directory for the WordPress project
mkdir wordpress_project
cd wordpress_project

# Create a Docker Compose file
cat <<EOT >> docker-compose.yml
version: '3'

services:
  db:
    image: mysql:5.7
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: example_root_password
      MYSQL_DATABASE: example_db
      MYSQL_USER: example_user
      MYSQL_PASSWORD: example_password

  wordpress:
    depends_on:
      - db
    image: wordpress:latest
    ports:
      - "8000:80"
    restart: always
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: example_user
      WORDPRESS_DB_PASSWORD: example_password
      WORDPRESS_DB_NAME: example_db
volumes:
  db_data:
EOT

# Start the containers
echo "Starting WordPress containers..."
docker-compose up -d

echo "WordPress setup complete. You can access WordPress at http://localhost:8000"
exit