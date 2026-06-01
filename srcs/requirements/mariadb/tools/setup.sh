#!/bin/bash
#exit immediately if any command fails - prevent half-configured database from running
set -e

#get docker secrets
MYSQL_PASSWORD=$(cat /run/secrets/db_password)
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

#create directory to hold temp system files needed for mariadb process
#mariadb runs as user named "mysql" (cant be "root" for security reasons)
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

#initialize database if it doesn't exist
#check if wordpress database exist at "/var/lib/mysql"
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    echo "Initializing MariaDB data directory..."
    chown -R mysql:mysql /var/lib/mysql

    #install if system tables do not exist
    if [ ! -d "/var/lib/mysql/mysql" ]; then
        mariadb-install-db --user=mysql --datadir=/var/lib/mysql
    fi

    #skip-networking + socket = avoid wordpress from connecting during config + allow internal socket file only
    #& = runs server in background - so script can keep running
    #$! = get process if of temp server - so we can stop later
    echo "Starting MariaDB for configuration..."
    mariadbd --user=mysql --skip-networking --socket=/run/mysqld/mysqld.sock &
    PID="$!"

    #socket = needed as we turned off networking
    #silent = supress terminal error messages
    until mariadb-admin ping --socket=/run/mysqld/mysqld.sock --silent; do
        echo "Waiting for MariaDB to start..."
        sleep 1
    done

    #use heredoc to inject configuration sql queries
    #alter = set a secure password for the database root
    #% = can connect from any ip address
    #flush privileges = reload internal grant tables into memory immediately
    mariadb --socket=/run/mysqld/mysqld.sock <<EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    #shutdown mariadb and wait
    mariadb-admin --socket=/run/mysqld/mysqld.sock shutdown
    wait "$PID"
    echo "MariaDB initialization complete!"
fi

#exec = runs mariadbd in foreground (replace shell + become pid 1 in container)
#bind address = turn on networking - allow wordpress to connect
echo "MariaDB setup complete!"
exec mariadbd --user=mysql --bind-address=0.0.0.0