#!/bin/bash
set -e
echo "Setting up WordPress..."

CREDENTIAL_PASSWORD=$(cat /run/secrets/credentials)
WP_DB_PASSWORD=$(cat /run/secrets/db_password)

until mariadb \
    -h${WP_DB_HOST} \
    -u${WP_DB_USER} \
    -p${WP_DB_PASSWORD} \
    -e "SHOW DATABASES;" > /dev/null 2>&1
do
    echo "Waiting for MariaDB..."
    sleep 1
done

mkdir -p /run/php
mkdir -p /var/www/html
cd /var/www/html

if [ ! -f wp-load.php ]; then
    echo "Copying WordPress files..."
    cp -a /usr/src/wordpress/. ./
    chown -R www-data:www-data ./
fi

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

    echo "Configuring dynamic URLs for custom ports..."
    cat << EOF >> /var/www/html/wp-config.php
define('WP_HOME', 'https://' . \$_SERVER['HTTP_HOST']);
define('WP_SITEURL', 'https://' . \$_SERVER['HTTP_HOST']);
EOF
fi

chown -R www-data:www-data /var/www/html

echo "WordPress setup complete!"
exec php-fpm7.4 -F