#!/bin/bash

set -o allexport
source .env
set +o allexport

# Define list of services
declare -A services
services=(
    ["neo4j"]="7474"
    ["site-frontend"]="6900"
    ["routing"]="6901"
    ["eeio-api"]="7070"
    ["eco-social-api"]="8080"
    ["product-api"]="8181"
    ["address-api"]="6975"
    ["db"]="3306"
    ["admin"]="6988"
    ["forum"]="6980"
)

# Install Certbot
sudo apt-get install certbot python3-certbot-nginx -y

# Set up SSL for each service
for container in "${!services[@]}"
do
    if [ "$container" == "site-frontend" ]
    then
        server_name="$DOMAIN"
    else
        server_name="$container.$DOMAIN"
    fi

    sudo certbot --nginx -d $server_name --non-interactive --agree-tos --email your-email@domain.com
done

# Automatically renew the SSL certificates
echo "0 12 * * * root certbot renew --quiet" | sudo tee -a /etc/crontab > /dev/null
