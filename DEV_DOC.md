*This project has been created as part of the 42 curriculum by azsaleh.*

# Inception: Developer Documentation

<div style="background-color: #2a3036; padding: 50px">

# Prerequisites

The following software must be installed on the host system or VM:
- Docker
- Docker Compose
- Make
- Git

Recommended environment:
- Debian Linux VM

<br><br>

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

<br><br>

# Project Structure

```text
.
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
├── secrets/
│   ├── credentials.txt
│   ├── db_password.txt
│   └── db_root_password.txt
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        ├── nginx/
        └── wordpress/
```

<br><br>

# Environment Configuration

## .env

The .env file is located at:

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

<br><br>

# Secrets Configuration

Sensitive information is stored separately inside:

```text
secrets/
```

Each secret file contains a single line only.

Example:

## secrets/db_password.txt

```text
supersecretpassword
```

Required secret files:

```text
secrets/
├── credentials.txt
├── db_password.txt
└── db_root_password.txt
```

<br><br>

# Host Configuration

Add the VM IP and domain to the host machine’s `/etc/hosts` file.

Example:

```text
127.0.0.1 azsaleh.42.fr
```

Replace the IP address if necessary.

</div>
<br>
<div style="background-color: #362a2a; padding: 50px">

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

<br><br>

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

<br><br>

# Makefile Commands

## Build and Start

```bash
make up
```

## Stop Containers

```bash
make stop
```

## Remove Containers

```bash
make down
```

## Restart Infrastructure

```bash
make restart
```

## View Logs

```bash
make logs
```

## View Running Containers

```bash
make ps
```

## Remove Containers and Images

```bash
make clean
```

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

</div>
<br>
<div style="background-color: #332a36; padding: 50px">

# Docker Commands

## List Containers

```bash
docker ps
```

<br><br>

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

<br><br>

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

## Restart Only One Service

Example:

```bash
docker restart wordpress
```

## Rebuild One Service

Example:

```bash
docker compose -f srcs/docker-compose.yml build wordpress
```

## Remove Unused Docker Resources

```bash
docker system prune -a
```

WARNING:
This removes unused Docker resources globally.

## Rebuilding Images

If Dockerfiles are modified:

```bash
docker compose -f srcs/docker-compose.yml build
```

or:

```bash
make restart
```

</div>
<br>
<div style="background-color: #36332a; padding: 50px">

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

<br><br>

# Volume Usage

## mariadb_data

Mounted to:

```text
/var/lib/mysql
```

Stores:
- database tables
- users
- WordPress content data

## wordpress_data

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

<br><br>

# Why Named Volumes

Docker named volumes were chosen because:
- they are required by the project subject
- they are managed directly by Docker
- they persist independently from containers
- they improve portability

<br><br>

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

</div>