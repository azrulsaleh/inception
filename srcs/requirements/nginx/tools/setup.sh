#!/bin/bash
set -e

if [ ! -f /etc/nginx/ssl/inception.crt ]; then
    echo "Creating SSL certificates..."
    mkdir -p /etc/nginx/ssl
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt \
        -subj "/C=MY/ST=Kuala Lumpur/L=Kuala Lumpur/O=42/OU=Inception/CN=${DOMAIN_NAME}"
fi

echo "NGINX setup complete!" 
exec nginx -g 'daemon off;'