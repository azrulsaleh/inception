# USER_DOC

# Overview

This project deploys a small web infrastructure using Docker containers.  
The stack is composed of three main services:

| Service | Purpose |
|---|---|
| MariaDB | Database server used by WordPress |
| WordPress + PHP-FPM | Website application and PHP processing |
| NGINX | Reverse proxy and HTTPS web server |

All services run inside isolated Docker containers and communicate through an internal Docker network.

The infrastructure includes:
- HTTPS using TLSv1.2/TLSv1.3
- Persistent database storage
- Persistent WordPress storage
- Internal container networking
- Secret-based credential management

---

# Services Provided

## NGINX

NGINX acts as:
- the public entrypoint
- the HTTPS server
- the reverse proxy

It listens on:
- port `443`

NGINX forwards PHP requests to the WordPress PHP-FPM container.

---

## WordPress + PHP-FPM

WordPress provides:
- the website frontend
- the administration dashboard
- content management features

PHP-FPM executes PHP scripts requested by NGINX.

---

## MariaDB

MariaDB stores:
- WordPress users
- posts
- settings
- comments
- uploaded content metadata

Database data persists across container restarts through Docker named volumes.

---

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

---

# Stopping the Project

Stop containers:

```bash
make stop
```

Stop and remove containers:

```bash
make down
```

---

# Restarting the Project

Restart all services:

```bash
make restart
```

---

# Accessing the Website

Open the following address in a browser:

```text
https://azsaleh.42.fr
```

A browser warning about a self-signed certificate is expected.

Accept the warning to continue.

---

# Accessing the WordPress Admin Panel

Open:

```text
https://azsaleh.42.fr/wp-admin
```

Log in using the administrator credentials configured in the project secrets.

---

# Credentials Management

Sensitive credentials are stored inside the `secrets/` directory.

Example structure:

```text
secrets/
├── db_password.txt
├── db_root_password.txt
├── wp_admin_password.txt
└── wp_user_password.txt
```

Each file contains a single secret value.

Example:

```text
supersecretpassword
```

---

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

---

# Checking Running Services

## View Running Containers

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

---

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

---

# Verifying HTTPS Access

Check HTTPS response:

```bash
curl -k https://azsaleh.42.fr
```

Expected result:
- HTML output from WordPress

---

# Checking Docker Volumes

List Docker volumes:

```bash
docker volume ls
```

Expected volumes:
- wordpress_data
- mariadb_data

---

# Verifying Database Connectivity

Enter the WordPress container:

```bash
docker exec -it wordpress bash
```

Test database connection:

```bash
mariadb -hmariadb -u<db_user> -p
```

---

# Persistent Data

The project uses Docker named volumes to preserve:
- database contents
- uploaded files
- WordPress configuration

Data remains available after:
- container recreation
- service restart
- system reboot

---

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

---

# Common Issues

## Website Not Reachable

Verify:
- containers are running
- VM IP/domain configuration is correct
- port 443 is exposed

Check:

```bash
docker ps
```

---

## Database Connection Errors

Check MariaDB logs:

```bash
docker logs mariadb
```

Verify:
- database credentials
- secret files
- Docker network connectivity

---

## WordPress Container Restart Loop

Check logs:

```bash
docker logs wordpress
```

Common causes:
- missing WordPress files
- invalid database credentials
- missing Docker volume data

---

# Host Configuration

The host machine should contain an `/etc/hosts` entry similar to:

```text
192.168.0.6 azsaleh.42.fr
```

Replace the IP address with the VM’s actual address if necessary.

---

# Security Notes

- Only NGINX exposes a public port (`443`)
- MariaDB and PHP-FPM remain internal
- Passwords are stored separately from source code
- HTTPS encryption is enabled
- Containers are isolated through Docker networking