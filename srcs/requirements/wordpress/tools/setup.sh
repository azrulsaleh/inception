#!/bin/bash
#exit immediately if any command fails - prevent half-configured database from running
set -e
echo "Setting up WordPress..."

#get docker secrets
CREDENTIAL_PASSWORD=$(cat /run/secrets/credentials)
WP_DB_PASSWORD=$(cat /run/secrets/db_password)

#wait until mariadb is ready to accept connections
#h = check host is "mariadb"
#u = check user is "wpuser"
#p = check password is "password42!"
#> /dev/null 2>&1 = supress stdout and stderror messages
until mariadb \
    -h${WP_DB_HOST} \
    -u${WP_DB_USER} \
    -p${WP_DB_PASSWORD} \
    -e "SHOW DATABASES;" > /dev/null 2>&1
do
    echo "Waiting for MariaDB..."
    sleep 1
done

#/run/php = directory for php-fpm to store unix socket file (.sock)
#/var/www/html = directory for wordpress source code files
mkdir -p /run/php
mkdir -p /var/www/html
cd /var/www/html

#check and copy files if volume is empty
if [ ! -f wp-load.php ]; then
    echo "Copying WordPress files..."
    cp -a /usr/src/wordpress/. ./
    chown -R www-data:www-data ./
fi

#check and configure wordpress is not yet configured
if [ ! -f wp-config.php ]; then
    #creates wp-config.php - links wordpress to mariadb
    #root = containers run scripts as root user and wp-cli blocks root execution by default for security
    echo "Creating WordPress configuration..."
    wp config create \
        --allow-root \
        --path=/var/www/html \
        --dbname=${WP_DB_NAME} \
        --dbuser=${WP_DB_USER} \
        --dbpass=${WP_DB_PASSWORD} \
        --dbhost=${WP_DB_HOST}

    #automatically "clicks" through the installation process via cli (create database tables, set up url and admin account)
    echo "Installing WordPress core..."
    wp core install \
        --allow-root \
        --path=/var/www/html \
        --url=${DOMAIN_NAME} \
        --title="Inception" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${CREDENTIAL_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL}

    #create a second non-admin user (role = author)
    wp user create \
        ${WP_USER} \
        ${WP_USER_EMAIL} \
        --role=author \
        --user_pass=${CREDENTIAL_PASSWORD} \
        --allow-root \
        --path=/var/www/html
fi

#ensure php-fpm/nginx can read/write to directory (upload media files / update plugins)
chown -R www-data:www-data /var/www/html

#exec = runs php-fpm in foreground (replace shell + become pid 1 in container)
#F = run php-fpm in foreground
echo "WordPress setup complete!"
exec php-fpm7.4 -F