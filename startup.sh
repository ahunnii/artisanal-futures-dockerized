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

