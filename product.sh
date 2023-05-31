#!bin/bash

set -o allexport
source .env
set +o allexport

git clone -b dockerization https://$GITLAB_USERNAME:$GITLAB_TOKEN@gitlab.si.umich.edu/csdts-umich/csdt-misc/product-search.git

docker build -t product-search-api -f ./product-search/Dockerfile.web ./product-search


