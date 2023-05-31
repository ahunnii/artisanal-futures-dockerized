#!bin/bash

set -o allexport
source .env
set +o allexport

sh docker.sh
sh eco.sh

docker-compose build
