#!/bin/bash
set -e

CREDENTIAL_PASSWORD=$(cat /run/secrets/credentials)
WP_DB_PASSWORD=$(cat /run/secrets/db_password)

echo "Setting up WordPress..."
mkdir -p /run/php
mkdir -p /var/www/html
until mariadb \
    -h${WP_DB_HOST} \
    -u${WP_DB_USER} \
    -p${WP_DB_PASSWORD} \
    -e "SHOW DATABASES;" > /dev/null 2>&1
do
    echo "Waiting for MariaDB..."
    sleep 1
done

if [ ! -f /var/www/html/wp-load.php ]; then
    echo "Copying WordPress files..."
    cp -a /usr/src/wordpress/. /var/www/html/
    chown -R www-data:www-data /var/www/html
fi
cd /var/www/html

# if [ ! -f "/var/www/html/wp-config.php" ]; then
if [ ! -f wp-config.php ]; then
    echo "Creating WordPress configuration..."
    wp config create \
        --allow-root \
        --path=/var/www/html \
        --dbname=${WP_DB_NAME} \
        --dbuser=${WP_DB_USER} \
        --dbpass=${WP_DB_PASSWORD} \
        --dbhost=${WP_DB_HOST}

    echo "Installing WordPress core..."
    wp core install \
        --allow-root \
        --path=/var/www/html \
        --url=${DOMAIN_NAME} \
        --title="Inception" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${CREDENTIAL_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL}

    wp user create \
        ${WP_USER} \
        ${WP_USER_EMAIL} \
        --role=author \
        --user_pass=${CREDENTIAL_PASSWORD} \
        --allow-root \
        --path=/var/www/html
fi

exec php-fpm8.2 -F