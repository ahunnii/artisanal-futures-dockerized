# First, set up docker
. docker.sh

# Then, restart nginx 
sudo /opt/bitnami/ctlscript.sh restart nginx

# Then, copy over locations 
cp –R ./locations ~/stack/nginx/conf/bitnami

# Then trigger the certifications
sudo /opt/bitnami/bncert-tool

# Once that is done, build eco 
. eco.sh

# Then build up docker

cp ~/artisanal-futures-dockerized/locations/*.conf ~/stack/nginx/conf/server_blocks



dreamwalkercosplay.co forum.dreamwalkercosplay.co address-api.dreamwalkercosplay.co prod-api.dreamwalkercosplay.co eco-api.dreamwalkercosplay.co eeio-api.dreamwalkercosplay.co