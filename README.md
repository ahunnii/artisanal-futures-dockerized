# Server Setup Instructions

For starters, this guide is for an AWS Nginx lightsail instance. Slight modifications on where nginx is and restart commands may differ.

1. Create an AWS server instance
2. SSH into instance and clone repository
3. CD into the repository and run docker.sh
4. Once that is finished, run eco.sh
5. Once that is done, copy over the conf files from the repository into their respective nginx folders
   1. cp ~/artisanal-futures-dockerized/locations/\*.conf ~/stack/nginx/conf/bitnami
   2. cp ~/artisanal-futures-dockerized/servers/\*.conf ~/stack/nginx/conf/server_blocks
6. Next, fire up an SSL certificate tool of choice. For me, bitnami has their own certification tool
   1. sudo /opt/bitnami/bncert-tool
   2. You will need to make sure all of these subdomains are added via A references with the domain: artisanalfutures.org forum.artisanalfutures.org loc-api.artisanalfutures.org prod-api.artisanalfutures.org eco-api.artisanalfutures.org eeio-api.artisanalfutures.org
7. Verify in the server_blocks that the artisanalfutures cert and key took over the default bitnami cert and ket
8. Restart nginx
   1. sudo /opt/bitnami/ctlscript.sh restart nginx
9. Now docker-compose build the repository and docker-compose up -d to run and detach from the terminal
10. Verify that the domain and subdomains point to the correct app and that everything works.

Notes:

Make sure to BACK UP WordPress. UpdraftPlus is a great free plugin. WordPress content is within a volume, but this is just a precaution.

For AWS Nginx, you can debug issues with nginx using their diagnostics tool: sudo /opt/bitnami/bndiagnostic-tool

Before you start, make sure that the subdomains are in the DNS for artisanalfutures.org (currently hosted with PorkBun)

For the product api, you will need to populate it with the CSV file located in the product_search data folder in its repo.

You will need to create an .env file. Follow the example env file as reference.
