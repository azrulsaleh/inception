*This project has been created as part of the 42 curriculum by azsaleh.*

# Inception: Read Me

<div style="background-color: #36332a; padding: 50px">

# Description

Inception is a system administration and infrastructure project focused on containerization using Docker. The goal of the project is to build and orchestrate a small web infrastructure composed of multiple isolated services communicating through Docker networks.

The infrastructure is built entirely using custom Docker images based on Debian and managed through Docker Compose. Each service runs inside its own dedicated container following the principle of separation of concerns.

The project includes:
- NGINX with TLSv1.2/TLSv1.3
- WordPress with PHP-FPM
- MariaDB database server
- Docker named volumes for persistent storage
- Docker networks for inter-container communication
- Environment variables and Docker-style secrets management

The infrastructure is designed to persist data across container restarts and system reboots while remaining modular and reproducible.

```text
Browser
   │
HTTPS (443)
   │
NGINX
   │
FastCGI (9000)
   │
WordPress + PHP-FPM
   │
MariaDB
```

Each service runs in its own dedicated Docker container:
- NGINX acts as the reverse proxy and HTTPS entrypoint.
- WordPress + PHP-FPM handles PHP application execution.
- MariaDB stores WordPress data persistently.

</div>
<br>
<div style="background-color: #2a3036; padding: 50px">

# Instructions

## Setup

Clone the repository:

```bash
git clone <repository_url>
cd inception
```

Create secret files inside the `secrets/` directory:

```text
secrets/credentials.txt
secrets/db_password.txt
secrets/db_root_password.txt
```

Populate each file with a single line containing the corresponding secret value.

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

<br>

## Requirements

- Linux Virtual Machine (UTM on Mac ARM64)
- Docker
- Docker Compose
- Make

<br>

## Domain Configuration

Add the following entry to your host machine’s `/etc/hosts` file:

```text
127.0.0.1 azsaleh.42.fr
```

replace "azsaleh" with your login id

<br>

## Build and Run

Start the infrastructure:

```bash
make
```

or:

```bash
make up
```

<br>

## Available Make Commands

```bash
make up        # Build and start containers
make down      # Stop containers
make start     # Start existing containers
make stop      # Stop running containers
make restart   # Restart infrastructure
make logs      # Show container logs
make ps        # Show running containers
make clean     # Remove containers and images
make fclean    # Full cleanup including volumes
make ls        # List multiple docker related info for eval
make reset     # Reset docker completely - clean slate
```

<br>

## Access

Open:

```text
https://azsaleh.42.fr
```

A self-signed certificate warning is expected.

</div>
<br>
<div style="background-color: #362a2a; padding: 50px">

# Resources

## Docker
- https://docs.docker.com/
- https://docs.docker.com/compose/
- https://docs.docker.com/storage/volumes/

## NGINX
- https://nginx.org/en/docs/

## MariaDB
- https://mariadb.org/documentation/

## WordPress
- https://developer.wordpress.org/
- https://wp-cli.org/

## PHP-FPM
- https://www.php.net/manual/en/install.fpm.php

## AI Usage
AI tools were used during development primarily for:
- conceptual clarification
- Docker architecture explanations
- debugging guidance
- shell scripting refinement
- understanding Docker volumes and networking
- improving infrastructure organization
- README formatting assistance

All implementation decisions, debugging, integration, testing, and final validation were performed manually.

</div>
<br>
<div style="background-color: #2c2a36; padding: 50px">

# Docker

Docker was used to isolate each service into its own lightweight container. This approach improves:
- modularity
- portability
- reproducibility
- dependency isolation

Each service has its own:
- Dockerfile
- configuration
- runtime process

<br><br>

# Persistent Storage

The project uses Docker named volumes:
- `mariadb_data`
- `wordpress_data`

This ensures that:
- WordPress data
- database contents
- uploaded files
- users
- posts

persist even after container recreation.

<br><br>

# Security

The infrastructure includes:
- TLSv1.2/TLSv1.3 encryption
- isolated containers
- internal Docker networking
- secret-based password management
- limited exposed ports

Only NGINX exposes a public port:
- `443`

MariaDB and PHP-FPM remain internal to the Docker network.

<br><br>

# Virtual Machines vs Docker

## Virtual Machines
Virtual Machines emulate full operating systems with their own kernels. They are heavier in terms of:
- disk usage
- RAM consumption
- boot time

VMs provide stronger isolation but require significantly more resources.

## Docker Containers
Docker containers share the host kernel and isolate applications at the process level. Containers are:
- lightweight
- faster to start
- easier to deploy
- more resource efficient

For this project, Docker allows rapid deployment of multiple interconnected services while maintaining separation between them.

<br><br>

# Secrets vs Environment Variables

## Environment Variables
Environment variables are useful for non-sensitive configuration such as:
- database names
- usernames
- domain names
- hostnames

## Secrets
Sensitive information such as passwords should not be stored directly inside environment variables or source code. Instead, this project stores confidential values inside dedicated secret files mounted into containers at runtime.

This improves:
- separation of concerns
- security
- credential management

<br><br>

# Docker Network vs Host Network

## Host Network
Using host networking removes network isolation between containers and the host system. Containers directly share the host network stack.

This approach reduces isolation and is discouraged for this project.

## Docker Bridge Network
This project uses Docker’s default bridge networking. Containers communicate internally through dedicated service names such as:
- `wordpress`
- `mariadb`

Only the NGINX container exposes a public port (`443`) to the host system.

This improves:
- security
- modularity
- network isolation

<br><br>

# Docker Volumes vs Bind Mounts

## Bind Mounts
Bind mounts directly map host filesystem paths into containers. They provide direct host access but can introduce:
- permission issues
- portability problems
- host dependency

## Docker Named Volumes
Docker named volumes are managed directly by Docker and provide persistent storage independently from container lifecycles.

This project uses Docker named volumes for:
- MariaDB database storage
- WordPress website files

Named volumes were chosen because they are explicitly required by the project subject and provide cleaner container-managed persistence.

</div>