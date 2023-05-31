#!/usr/bin/expect -f
#!/bin/bash

set -o allexport
source .env
set +o allexport

# launch the bncert-tool
spawn sudo /opt/bitnami/bncert-tool

# when asked for domains, provide them
expect "domains"
send -- "www.$DOMAIN $DOMAIN neo4j.$DOMAIN routing.$DOMAIN eeio-api.$DOMAIN eco-social-api.$DOMAIN product-api.$DOMAIN address-api.$DOMAIN db.$DOMAIN admin.$DOMAIN forum.$DOMAIN \r"

# when asked for changes to perform, confirm them
expect "changes"
send -- "y\r"

# when asked for email address, provide it
expect "email"
send -- "your-email@test.com\r"

# when asked to agree to Let's Encrypt terms of service, agree
expect "agree"
send -- "y\r"

# when asked to share email with EFF, decline (or agree if you prefer)
expect "share"
send -- "n\r"

# when asked to configure HTTP to HTTPS redirection, agree
expect "redirect"
send -- "y\r"

# when asked to proceed, confirm
expect "proceed"
send -- "y\r"

expect eof
