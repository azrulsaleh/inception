#!/bin/bash
set -e

MYSQL_PASSWORD=$(cat /run/secrets/db_password)
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    echo "Initializing MariaDB data directory..."
    chown -R mysql:mysql /var/lib/mysql

    if [ ! -d "/var/lib/mysql/mysql" ]; then
        mariadb-install-db --user=mysql --datadir=/var/lib/mysql
    fi

    echo "Starting MariaDB for configuration..."
    mariadbd --user=mysql --skip-networking --socket=/run/mysqld/mysqld.sock &
    PID="$!"

    until mariadb-admin ping --socket=/run/mysqld/mysqld.sock --silent; do
        echo "Waiting for MariaDB to start..."
        sleep 1
    done

    mariadb --socket=/run/mysqld/mysqld.sock <<EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    mariadb-admin --socket=/run/mysqld/mysqld.sock shutdown
    wait "$PID"
    echo "MariaDB initialization complete!"
fi

echo "MariaDB setup complete!"
exec mariadbd --user=mysql --bind-address=0.0.0.0