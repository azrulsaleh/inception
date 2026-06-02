*This project has been created as part of the 42 curriculum by azsaleh.*

# Inception: User Documentation

<div style="background-color: #2a3036; padding: 50px">

# Services Provided

## NGINX

NGINX acts as:
- the public entrypoint
- the HTTPS server
- the reverse proxy

It listens on:
- port `443`

NGINX forwards PHP requests to the WordPress PHP-FPM container.

<br>

## WordPress + PHP-FPM

WordPress provides:
- the website frontend
- the administration dashboard
- content management features

PHP-FPM executes PHP scripts requested by NGINX.

<br>

## MariaDB

MariaDB stores:
- WordPress users
- posts
- settings
- comments
- uploaded content metadata

Database data persists across container restarts through Docker named volumes.

</div>
<br>
<div style="background-color: #362d2a; padding: 50px">

# Starting the Project

From the project root directory:

```bash
make
```

or:

```bash
make up
```

This command:
- builds Docker images
- creates containers
- starts the infrastructure

<br><br>

# Stopping the Project

Stop containers:

```bash
make stop
```

Stop and remove containers:

```bash
make down
```

<br><br>

# Restarting the Project

Restart all services:

```bash
make restart
```

</div>
<br>
<div style="background-color: #2a3631; padding: 50px">

# Accessing the Website

Open the following address in a browser:

```text
https://azsaleh.42.fr
```

A browser warning about a self-signed certificate is expected.

Accept the warning to continue.

<br><br>

# Accessing the WordPress Admin Panel

Open:

```text
https://azsaleh.42.fr/wp-admin
```

Log in using the administrator credentials configured in the project secrets.

</div>
<br>
<div style="background-color: #302a36; padding: 50px">

# Credentials Management

Sensitive credentials are stored inside the `secrets/` directory.

Example structure:

```text
secrets/
├── credentials.txt
├── db_password.txt
└── db_root_password.txt
```

Each file contains a single secret value.

Example:

```text
supersecretpassword
```

<br><br>

# Environment Variables

Non-sensitive configuration values are stored inside:

```text
srcs/.env
```

Examples:
- domain name
- database name
- usernames
- emails

</div>
<br>
<div style="background-color: #36332a; padding: 50px">

# View Running Containers

```bash
make ps
```

or:

```bash
docker ps
```

Expected containers:
- nginx
- wordpress
- mariadb

<br><br>

# Viewing Logs

View all service logs:

```bash
make logs
```

or individually:

```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

<br><br>

# Verifying HTTPS Access

Check HTTPS response:

```bash
curl -k https://azsaleh.42.fr
```

Expected result:
- HTML output from WordPress

<br><br>

# Checking Docker Volumes

List Docker volumes:

```bash
docker volume ls
```

Expected volumes:
- wordpress_data
- mariadb_data

<br><br>

# Verifying Database Connectivity

Enter the WordPress container:

```bash
docker exec -it wordpress bash
```

Test database connection:

```bash
mariadb -hmariadb -u<db_user> -p
```

<br><br>

# Full Cleanup

Remove:
- containers
- images
- volumes

```bash
make fclean
```

WARNING:  
This permanently deletes all persistent data.

<br><br>

# Website Not Reachable

Verify:
- containers are running
- VM IP/domain configuration is correct
- port 443 is exposed

Check:

```bash
docker ps
```

<br><br>

# Database Connection Errors

Check MariaDB logs:

```bash
docker logs mariadb
```

Verify:
- database credentials
- secret files
- Docker network connectivity

<br><br>

# WordPress Container Restart Loop

Check logs:

```bash
docker logs wordpress
```

Common causes:
- missing WordPress files
- invalid database credentials
- missing Docker volume data

<br><br>

# Host Configuration

The host machine should contain an `/etc/hosts` entry similar to:

```text
127.0.0.1 azsaleh.42.fr
```

Replace the IP address with the VM’s actual address if necessary.

<br><br>

# Security Notes

- Only NGINX exposes a public port (`443`)
- MariaDB and PHP-FPM remain internal
- Passwords are stored separately from source code
- HTTPS encryption is enabled
- Containers are isolated through Docker networking

</div>