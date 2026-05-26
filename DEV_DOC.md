# DEV_DOC

# Developer Documentation

This document explains how to set up, build, run, and maintain the Inception infrastructure project.

The project uses Docker and Docker Compose to orchestrate a multi-container web stack composed of:
- NGINX
- WordPress + PHP-FPM
- MariaDB

---

# Prerequisites

The following software must be installed on the host system or VM:

## Required

- Docker
- Docker Compose
- Make
- Git

Recommended environment:
- Debian Linux VM

---

# Verify Installation

## Docker

```bash
docker --version
```

## Docker Compose

```bash
docker compose version
```

## Make

```bash
make --version
```

---

# Project Structure

```text
.
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
├── secrets/
│   ├── db_password.txt
│   ├── db_root_password.txt
│   ├── wp_admin_password.txt
│   └── wp_user_password.txt
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        ├── nginx/
        └── wordpress/
```

---

# Environment Configuration

## `.env`

The `.env` file is located at:

```text
srcs/.env
```

This file stores non-sensitive configuration values.

Example:

```env
MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser

WP_DB_NAME=wordpress
WP_DB_USER=wpuser
WP_DB_HOST=mariadb

WP_URL=azsaleh.42.fr

WP_ADMIN_USER=admin
WP_ADMIN_EMAIL=admin@test.com

WP_USER=user42
WP_USER_EMAIL=user42@test.com
```

---

# Secrets Configuration

Sensitive information is stored separately inside:

```text
secrets/
```

Each secret file contains a single line only.

Example:

## `secrets/db_password.txt`

```text
supersecretpassword
```

Required secret files:

```text
secrets/
├── db_password.txt
├── db_root_password.txt
├── wp_admin_password.txt
└── wp_user_password.txt
```

---

# Host Configuration

Add the VM IP and domain to the host machine’s `/etc/hosts` file.

Example:

```text
192.168.0.6 azsaleh.42.fr
```

Replace the IP address if necessary.

---

# Building the Project

From the repository root:

```bash
make
```

or:

```bash
make up
```

This command:
- builds all Docker images
- creates Docker containers
- creates Docker volumes
- starts the infrastructure

---

# Docker Compose

The infrastructure is orchestrated using:

```text
srcs/docker-compose.yml
```

Services:
- mariadb
- wordpress
- nginx

Named volumes:
- mariadb_data
- wordpress_data

---

# Makefile Commands

## Build and Start

```bash
make up
```

---

## Stop Containers

```bash
make stop
```

---

## Remove Containers

```bash
make down
```

---

## Restart Infrastructure

```bash
make restart
```

---

## View Logs

```bash
make logs
```

---

## View Running Containers

```bash
make ps
```

---

## Remove Containers and Images

```bash
make clean
```

---

## Full Cleanup

```bash
make fclean
```

This removes:
- containers
- images
- Docker volumes

WARNING:
Persistent project data will be deleted.

---

# Docker Commands

## List Containers

```bash
docker ps
```

---

## Enter Container Shell

### NGINX

```bash
docker exec -it nginx bash
```

### WordPress

```bash
docker exec -it wordpress bash
```

### MariaDB

```bash
docker exec -it mariadb bash
```

---

# Viewing Logs

## NGINX

```bash
docker logs nginx
```

## WordPress

```bash
docker logs wordpress
```

## MariaDB

```bash
docker logs mariadb
```

---

# Persistent Storage

The project uses Docker named volumes.

Defined in:

```text
srcs/docker-compose.yml
```

Example:

```yaml
volumes:
  mariadb_data:
  wordpress_data:
```

---

# Volume Usage

## `mariadb_data`

Mounted to:

```text
/var/lib/mysql
```

Stores:
- database tables
- users
- WordPress content data

---

## `wordpress_data`

Mounted to:

```text
/var/www/html
```

Stores:
- WordPress core files
- plugins
- uploads
- themes
- configuration

---

# Why Named Volumes

Docker named volumes were chosen because:
- they are required by the project subject
- they are managed directly by Docker
- they persist independently from containers
- they improve portability

---

# Persistence Verification

Create:
- a WordPress post
- a WordPress user

Then restart containers:

```bash
make down
make up
```

Verify:
- data still exists
- website remains functional

---

# Rebuilding Images

If Dockerfiles are modified:

```bash
docker compose -f srcs/docker-compose.yml build
```

or:

```bash
make restart
```

---

# Network Architecture

Containers communicate internally using Docker bridge networking.

Internal service names:
- `mariadb`
- `wordpress`
- `nginx`

Only NGINX exposes a public port:

```text
443
```

MariaDB and PHP-FPM remain internal.

---

# TLS Configuration

NGINX uses:
- TLSv1.2
- TLSv1.3

Certificates are generated during image build using OpenSSL.

Configuration file:

```text
srcs/requirements/nginx/conf/default.conf
```

---

# WordPress Initialization

WordPress initialization occurs inside:

```text
srcs/requirements/wordpress/tools/setup.sh
```

The script:
- waits for MariaDB
- copies WordPress files into the volume
- creates `wp-config.php`
- installs WordPress
- creates users
- launches PHP-FPM

---

# MariaDB Initialization

MariaDB initialization occurs inside:

```text
srcs/requirements/mariadb/tools/setup.sh
```

The script:
- initializes the database directory
- starts MariaDB
- creates the database
- creates database users
- grants privileges

---

# Common Development Tasks

## Restart Only One Service

Example:

```bash
docker restart wordpress
```

---

## Rebuild One Service

Example:

```bash
docker compose -f srcs/docker-compose.yml build wordpress
```

---

## Remove Unused Docker Resources

```bash
docker system prune -a
```

WARNING:
This removes unused Docker resources globally.

---

# Troubleshooting

## Containers Restarting Repeatedly

Check logs:

```bash
docker logs <container_name>
```

---

## WordPress Cannot Connect to Database

Verify:
- MariaDB container is running
- database credentials are correct
- secret files exist
- Docker network is functional

---

## HTTPS Not Reachable

Verify:
- port 443 is exposed
- NGINX container is running
- `/etc/hosts` is configured correctly

---

# Development Notes

This project follows:
- one process per container
- container isolation
- internal Docker networking
- persistent Docker-managed storage
- runtime initialization scripting

The infrastructure is intentionally modular to simplify:
- debugging
- maintenance
- service replacement
- future bonus extensions