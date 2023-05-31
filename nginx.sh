#!/bin/bash

set -o allexport
source .env
set +o allexport

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

# Create Nginx config files for each service
for container in "${!services[@]}"
do
    if [ "$container" == "site-frontend" ]
    then
        server_name="$DOMAIN"
    else
        server_name="$container.$DOMAIN"
    fi

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