#!/bin/bash

set -o allexport
source .env
set +o allexport

# Update the system
sudo apt-get update -y

# Install Docker
sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release -y
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

# Install Docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install Nginx
sudo apt-get install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

# Define list of services
declare -A services
services=(
    ["csdt_neo4j"]="7474"
    ["site-frontend"]="6900"
    ["routing-app"]="6901"
    ["eeio-api"]="7070"
    ["eco-social-api"]="8080"
    ["product-search-api"]="8181"
    ["address-scrape-api"]="6975"
    ["af-database"]="3306"
    ["phpmyadmin"]="6988"
    ["site-backend"]="6980"
)

# Create Nginx config files for each service
for container in "${!services[@]}"
do
    sudo bash -c "cat > /etc/nginx/sites-available/$container <<EOF
    server {
        listen 80;
        server_name $container.$DOMAIN;

        location / {
            proxy_pass http://localhost:${services[$container]};
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }
    }
EOF"

    # Enable the site
    sudo ln -s /etc/nginx/sites-available/$container /etc/nginx/sites-enabled/
done

# Restart Nginx
sudo systemctl restart nginx

# Install Certbot
sudo apt-get install certbot python3-certbot-nginx -y

# Set up SSL for each service
for container in "${!services[@]}"
do
    sudo certbot --nginx -d $container.$DOMAIN
done
