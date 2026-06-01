#!/bin/bash
#exit immediately if any command fails - prevent half-configured database from running
set -e

#generate the ssl certificate (self-signed)
#x509 = create a self-signed certificate (rather than a certificate signing request [csr])
#nodes = "no des" (private key won't be encrypted with password - nginx starts up without prompt for password)
#days 365 = cert valid for 1 year
#newkey = create certificate and RSA 2048 private key simultaneously
#keyout = where private key is stored
#out = where certificate is stored
#subj = fill out certificate identity fields (country, state, organization, common name)
if [ ! -f /etc/nginx/ssl/inception.crt ]; then
    echo "Creating SSL certificates..."
    mkdir -p /etc/nginx/ssl
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt \
        -subj "/C=MY/ST=Kuala Lumpur/L=Kuala Lumpur/O=42/OU=Inception/CN=${DOMAIN_NAME}"
fi

#g = global (allow to pass config settings form command line [overriding the main nginx.conf file])
#daemon off = tells nginx to not run as background daemon (run in foreground)
echo "NGINX setup complete!" 
exec nginx -g 'daemon off;'