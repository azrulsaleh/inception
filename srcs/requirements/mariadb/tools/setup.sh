#!/bin/bash
set -e

#read secrets safely
MYSQL_PASSWORD=$(cat /run/secrets/db_password)
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

#ensure proper directories and permissions
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

#initialize database if it doesn't exist
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    #start temporary MariaDB daemon for configuration using the local socket
    mariadbd --user=mysql --skip-networking --socket=/run/mysqld/mysqld.sock &
    PID="$!"

    #wait for MariaDB to become responsive via the socket
    until mariadb-admin ping --socket=/run/mysqld/mysqld.sock --silent; do
        echo "Waiting for MariaDB to start..."
        sleep 1
    done

    #secure the root account and configure your databases/users
    mariadb --socket=/run/mysqld/mysqld.sock <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    #shutdown the temporary background instance cleanly
    mariadb-admin --socket=/run/mysqld/mysqld.sock shutdown
    wait "$PID"
    echo "MariaDB initialization complete!"
fi

#hand over execution to main container process
echo "MariaDB setup complete!"
exec mariadbd --user=mysql --bind-address=0.0.0.0