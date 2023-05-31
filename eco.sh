#!bin/bash

set -o allexport
source .env
set +o allexport

git clone -b main https://$GITLAB_USERNAME:$ACCESS_TOKEN_ECO@gitlab.si.umich.edu/csdts-umich/artisanalfutures-eco-social-calc.git
cd artisanalfutures-eco-social-calc/data/USEEIO && git lfs install && git lfs pull
cd ../../

docker build -t eeio-api -f Dockerfile.eeio-api .
docker build -t eco-social-api -f Dockerfile.eco-social-api .

cd ../
rm -rf artisanalfutures-eco-social-calc
