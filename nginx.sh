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

# Create Nginx config files for each service
for container in "${!services[@]}"
do
    if [ "$container" == "site-frontend" ]
    then
        server_name="$DOMAIN"
    else
        server_name="$container.$DOMAIN"
    fi

    # Update this to redirect to correct nginx path based on server.
    sudo bash -c "cat > /opt/bitnami/nginx/conf/server_blocks/$container-server-block.conf <<EOF
    server {
        listen 80 default_server;
        server_name $server_name;
        root /opt/bitnami/$container;
        location / {
            proxy_pass http://localhost:${services[$container]};
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }

        include  "/opt/bitnami/nginx/conf/bitnami/*.conf";
    }
EOF"
done

# Restart Nginx
sudo /opt/bitnami/ctlscript.sh restart nginx