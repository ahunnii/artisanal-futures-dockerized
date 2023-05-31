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

# Set up SSL for each service
for container in "${!services[@]}"
do
    if [ "$container" == "site-frontend" ]
    then
        server_name="$DOMAIN"
    else
        server_name="$container.$DOMAIN"
    fi

    sudo certbot --nginx -d $container.$DOMAIN
done
