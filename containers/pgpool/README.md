# What is Pgpool-II?

> [Pgpool-II](http://pgpool.net) is a PostgreSQL proxy. It stands between PostgreSQL servers and their clients providing connection pooling, load balancing, automated failover, and replication.

# TL;DR;

```bash
$ docker run --name pgpool bitnami/pgpool:latest
```

## Docker Compose

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-pgpool/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DTC)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.

> This [CVE scan report](https://quay.io/repository/bitnami/pgpool?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy Pgpool-II in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami PostgreSQL HA Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/postgresql-ha).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Supported tags and respective `Dockerfile` links

> NOTE: Debian 9 images have been deprecated in favor of Debian 10 images. Bitnami will not longer publish new Docker images based on Debian 9.

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/).


* [`4-ol-7`, `4.1.0-ol-7-r87` (4/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-pgpool/blob/4.1.0-ol-7-r87/4/ol-7/Dockerfile)
* [`4-debian-10`, `4.1.0-debian-10-r5`, `4`, `4.1.0`, `latest` (4/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-pgpool/blob/4.1.0-debian-10-r5/4/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/pgpool GitHub repo](https://github.com/bitnami/bitnami-docker-pgpool).

# Get this image

The recommended way to get the Bitnami Pgpool-II Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/pgpool).

```bash
$ docker pull bitnami/pgpool:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/pgpool/tags/) in the Docker Hub Registry.

```bash
$ docker pull bitnami/pgpool:[TAG]
```

If you wish, you can also build the image yourself.

```bash
$ docker build -t bitnami/pgpool:latest 'https://github.com/bitnami/bitnami-docker-pgpool.git#master:4/debian-10'
```

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

In this example, we will create a PostgreSQL client instance that will connect to the pgpool instance that is running on the same docker network as the client.

### Step 1: Create a network

```bash
$ docker network create my-network --driver bridge
```

### Step 2: Launch 2 postgresql-repmgr containers to be used as backend within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `my-network` network.

```bash
$ docker run --detach --rm --name pg-0 \
  --network my-network \
  --env REPMGR_PARTNER_NODES=g-0,pg-1 \
  --env REPMGR_NODE_NAME=pg-0 \
  --env REPMGR_NODE_NETWORK_NAME=pg-0 \
  --env REPMGR_PRIMARY_HOST=pg-0 \
  --env REPMGR_PASSWORD=repmgrpass \
  --env POSTGRESQL_POSTGRES_PASSWORD=adminpassword \
  --env POSTGRESQL_USERNAME=customuser \
  --env POSTGRESQL_PASSWORD=custompassword \
  --env POSTGRESQL_DATABASE=customdatabase \
  bitnami/postgresql-repmgr:latest
$ docker run --detach --rm --name pg-1 \
  --network my-network \
  --env REPMGR_PARTNER_NODES=pg-0,pg-1 \
  --env REPMGR_NODE_NAME=pg-1 \
  --env REPMGR_NODE_NETWORK_NAME=pg-1 \
  --env REPMGR_PRIMARY_HOST=pg-0 \
  --env REPMGR_PASSWORD=repmgrpass \
  --env POSTGRESQL_POSTGRES_PASSWORD=adminpassword \
  --env POSTGRESQL_USERNAME=customuser \
  --env POSTGRESQL_PASSWORD=custompassword \
  --env POSTGRESQL_DATABASE=customdatabase \
  bitnami/postgresql-repmgr:latest
```

### Step 3: Launch the pgpool container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `my-network` network.

```bash
$ docker run --detach --rm --name pgpool \
  --network my-network \
  --env PGPOOL_BACKEND_NODES=0:pg-0:5432,1:pg-1:5432 \
  --env PGPOOL_SR_CHECK_USER=customuser \
  --env PGPOOL_SR_CHECK_PASSWORD=custompassword \
  --env PGPOOL_ENABLE_LDAP=no \
  --env PGPOOL_POSTGRES_USERNAME=postgres \
  --env PGPOOL_POSTGRES_PASSWORD=adminpassword \
  --env PGPOOL_ADMIN_USERNAME=admin \
  --env PGPOOL_ADMIN_PASSWORD=adminpassword \
  bitnami/pgpool:latest
```

### Step 4: Launch your PostgreSQL client instance

Finally we create a new container instance to launch the PostgreSQL client and connect to the server created in the previous step:

```bash
$ docker run -it --rm \
  --network my-network \
  bitnami/postgresql:10 \
  psql -h pgpool -U customuser -d customdatabase
```

## Using Docker Compose

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `my-network`. In this example we assume that you want to connect to the Pgpool server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  my-network:
    driver: bridge
services:
  pg-0:
    image: bitnami/postgresql-repmgr:11
    ports:
      - 5432
    volumes:
      - pg_0_data:/bitnami/postgresql
    environment:
      - POSTGRESQL_POSTGRES_PASSWORD=adminpassword
      - POSTGRESQL_USERNAME=customuser
      - POSTGRESQL_PASSWORD=custompassword
      - POSTGRESQL_DATABASE=customdatabase
      - REPMGR_PASSWORD=repmgrpassword
      - REPMGR_PRIMARY_HOST=pg-0
      - REPMGR_PARTNER_NODES=pg-0,pg-1
      - REPMGR_NODE_NAME=pg-0
      - REPMGR_NODE_NETWORK_NAME=pg-0
  pg-1:
    image: bitnami/postgresql-repmgr:11
    ports:
      - 5432
    volumes:
      - pg_1_data:/bitnami/postgresql
    environment:
      - POSTGRESQL_POSTGRES_PASSWORD=adminpassword
      - POSTGRESQL_USERNAME=customuser
      - POSTGRESQL_PASSWORD=custompassword
      - POSTGRESQL_DATABASE=customdatabase
      - REPMGR_PASSWORD=repmgrpassword
      - REPMGR_PRIMARY_HOST=pg-0
      - REPMGR_PARTNER_NODES=pg-0,pg-1
      - REPMGR_NODE_NAME=pg-1
      - REPMGR_NODE_NETWORK_NAME=pg-1
  pgpool:
    image: bitnami/pgpool:4
    ports:
      - 5432:5432
    environment:
      - PGPOOL_BACKEND_NODES=0:pg-0:5432,1:pg-1:5432
      - PGPOOL_SR_CHECK_USER=customuser
      - PGPOOL_SR_CHECK_PASSWORD=custompassword
      - PGPOOL_ENABLE_LDAP=no
      - PGPOOL_POSTGRES_USERNAME=postgres
      - PGPOOL_POSTGRES_PASSWORD=adminpassword
      - PGPOOL_ADMIN_USERNAME=admin
      - PGPOOL_ADMIN_PASSWORD=adminpassword
  myapp:
    image: 'YOUR_APPLICATION_IMAGE'
    networks:
      - my-network
volumes:
  pg_0_data:
    driver: local
  pg_1_data:
    driver: local
```

> **IMPORTANT**:
>
> 1. Please update the **YOUR_APPLICATION_IMAGE_** placeholder in the above snippet with your application image
> 2. In your application container, use the hostname `pgpool` to connect to the PostgreSQL server

Launch the containers using:

```bash
$ docker-compose up -d
```

# Configuration

## Setting up a HA PostgreSQL cluster with pgpool, streaming replication and repmgr

A HA PostgreSQL cluster with Pgpool, [Streaming replication](https://www.postgresql.org/docs/10/warm-standby.html#STREAMING-REPLICATION) and [repmgr](https://repmgr.org) can easily be setup with the Bitnami PostgreSQL with Replication Manager and Pgpool Docker Images using the following environment variables:

Pgpool:

- `PGPOOL_PASSWORD_FILE`: Path to a file that contains the password for the custom user set in the `PGPOOL_USERNAME` environment variable. This will override the value specified in `PGPOOL_PASSWORD`. No defaults.
- `PGPOOL_SR_CHECK_USER`: Username to use to perform streaming checks. No defaults.
- `PGPOOL_SR_CHECK_PASSWORD`: Password to use to perform streaming checks. No defaults.
- `PGPOOL_SR_CHECK_PASSWORD_FILE`: Path to a file that contains the password to use to perform streaming checks. This will override the value specified in `PGPOOL_SR_CHECK_PASSWORD`. No defaults.
- `PGPOOL_BACKEND_NODES`: Comma separated list of backend nodes in the cluster.  No defaults.
- `PGPOOL_ENABLE_LDAP`: Whether to enable LDAP authentication. Defaults to `no`.
- `PGPOOL_ENABLE_LOAD_BALANCING`: Whether to enable Load-Balancing mode. Defaults to `yes`.
- `PGPOOL_POSTGRES_USERNAME`: Postgres administrator user name, this will be use to allow postgres admin authentication through Pgpool.
- `PGPOOL_POSTGRES_PASSWORD`: Password for the user set in `PGPOOL_POSTGRES_USERNAME` environment variable. No defaults.
- `PGPOOL_ADMIN_USERNAME`: Username for the pgpool administrator. No defaults.
- `PGPOOL_ADMIN_PASSWORD`: Password for the user set in `PGPOOL_ADMIN_USERNAME` environment variable. No defaults.


PostgreSQL with Replication Manager:

- `POSTGRESQL_POSTGRES_PASSWORD`: Password for `postgres` user. No defaults.
- `POSTGRESQL_POSTGRES_PASSWORD_FILE`: Path to a file that contains the `postgres` user password. This will override the value specified in `POSTGRESQL_POSTGRES_PASSWORD`. No defaults.
- `POSTGRESQL_USERNAME`: Custom user to access the database. No defaults.
- `POSTGRESQL_DATABASE`: Custom database to be created on first run. No defaults.
- `POSTGRESQL_PASSWORD`: Password for the custom user set in the `POSTGRESQL_USERNAME` environment variable. No defaults.
- `POSTGRESQL_PASSWORD_FILE`: Path to a file that contains the password for the custom user set in the `POSTGRESQL_USERNAME` environment variable. This will override the value specified in `POSTGRESQL_PASSWORD`. No defaults.
- `REPMGR_USERNAME`: Username for `repmgr` user. Defaults to `repmgr`.
- `REPMGR_PASSWORD_FILE`: Path to a file that contains the `repmgr` user password. This will override the value specified in `REPMGR_PASSWORD`. No defaults.
- `REPMGR_PASSWORD`: Password for `repmgr` user. No defaults.
- `REPMGR_PRIMARY_HOST`: Hostname of the initial primary node. No defaults.
- `REPMGR_PARTNER_NODES`: Comma separated list of partner nodes in the cluster.  No defaults.
- `REPMGR_NODE_NAME`: Node name. No defaults.
- `REPMGR_NODE_NETWORK_NAME`: Node hostname. No defaults.

In a HA PostgreSQL cluster you can have one primary and zero or more standby nodes. The primary node is in read-write mode, while the standby nodes are in read-only mode. For best performance its advisable to limit the reads to the standby nodes.

### Step 1: Create a network

```bash
$ docker network create my-network --driver bridge
```

### Step 2: Create the initial primary node

The first step is to start the initial primary node:

```bash
$ docker run --detach --name pg-0 \
  --network my-network \
  --env REPMGR_PARTNER_NODES=pg-0,pg-1 \
  --env REPMGR_NODE_NAME=pg-0 \
  --env REPMGR_NODE_NETWORK_NAME=pg-0 \
  --env REPMGR_PRIMARY_HOST=pg-0 \
  --env REPMGR_PASSWORD=repmgrpass \
  --env POSTGRESQL_POSTGRES_PASSWORD=adminpassword \
  --env POSTGRESQL_USERNAME=customuser \
  --env POSTGRESQL_PASSWORD=custompassword \
  --env POSTGRESQL_DATABASE=customdatabase \
  bitnami/postgresql-repmgr:latest
```

### Step 3: Create a standby node

Next we start a standby node:

```bash
$ docker run --detach --name pg-1 \
  --network my-network \
  --env REPMGR_PARTNER_NODES=pg-0,pg-1 \
  --env REPMGR_NODE_NAME=pg-1 \
  --env REPMGR_NODE_NETWORK_NAME=pg-1 \
  --env REPMGR_PRIMARY_HOST=pg-0 \
  --env REPMGR_PASSWORD=repmgrpass \
  --env REPMGR_PASSWORD=repmgrpass \
  --env POSTGRESQL_POSTGRES_PASSWORD=adminpassword \
  --env POSTGRESQL_USERNAME=customuser \
  --env POSTGRESQL_PASSWORD=custompassword \
  --env POSTGRESQL_DATABASE=customdatabase \
  bitnami/postgresql-repmgr:latest
```

### Step 4: Create the pgpool instance

```bash
$ docker run --detach --rm --name pgpool \
  --network my-network \
  --env PGPOOL_BACKEND_NODES=0:pg-0:5432,1:pg-1:5432 \
  --env PGPOOL_SR_CHECK_USER=postgres \
  --env PGPOOL_SR_CHECK_PASSWORD=adminpassword \
  --env PGPOOL_ENABLE_LDAP=no \
  --env PGPOOL_USERNAME=customuser \
  --env PGPOOL_PASSWORD=custompassword \
  bitnami/pgpool:latest
```

With these three commands you now have a two node PostgreSQL primary-standby streaming replication cluster using Pgpool as proxy up and running. You can scale the cluster by adding/removing standby nodes without incurring any downtime.

> **Note**: The cluster replicates the primary in its entirety, which includes all users and databases.

If the master goes down, **repmgr** will ensure any of the standby nodes takes the primary role, guaranteeing high availability.

> **Note**: The configuration of the other nodes in the cluster needs to be updated so that they are aware of them. This would require you to restart the old nodes adapting the `REPMGR_PARTNER_NODES` environment variable. You also need to restart the Pgpoll instance adapting the `PGPOOL_BACKEND_NODES` environment variable.

With Docker Compose the HA PostgreSQL cluster can be setup using the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-pgpool/blob/master/docker-compose.yml) file present in this repository:

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-pgpool/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

## Initializing with custom scripts

**Everytime the container is started**, it will execute the files with extension `.sh` located at `/docker-entrypoint-initdb.d` after initializing Pgpool.

In order to have your custom files inside the docker image you can mount them as a volume.

```bash
$ docker run --name pgpool \
  -v /path/to/init-scripts:/docker-entrypoint-initdb.d \
  bitnami/pgpool:latest
```

Or with docker-compose:

```yaml
pgpool:
  image: bitnami/pgpool:latest
  volumes:
    - /path/to/init-scripts:/docker-entrypoint-initdb.d
```

## Configuration file

The image looks for a `pgpool.conf` file in `/opt/bitnami/pgpool/conf/`. You can mount a volume at `/opt/bitnami/pgpool/conf/` and copy/edit the `pgpool.conf` file in the `/path/to/pgpool-persistence/conf/`. The default configurations will be populated to the `conf/` directory if it's empty.

```
/path/to/pgpool-persistence/conf/
└── pgpool.conf

0 directories, 1 file
```

### Step 1: Run the Pgpool image

Run the Pgpool image, mounting a directory from your host.

```bash
$ docker run --name pgpool \
    -v /path/to/pgpool-persistence/conf/:/opt/bitnami/pgpool/conf/ \
    bitnami/pgpool:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  pgpool:
    image: bitnami/pgpool:latest
    ports:
      - '5432:5432'
    volumes:
      - /path/to/pgpool-persistence/conf/:/opt/bitnami/pgpool/conf/
```

### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```bash
vi /path/to/pgpool-persistence/conf/postgresql.conf
```

### Step 3: Restart Pgpool

After changing the configuration, restart your Pgpool container for changes to take effect.

```bash
$ docker restart pgpool
```

or using Docker Compose:

```bash
$ docker-compose restart pgpool
```

Refer to the [server configuration](http://www.pgpool.net/docs/latest/en/html/runtime-config.html) manual for the complete list of configuration options.

## Environment variables

Please see the list of environment variables available in the Bitnami Pgpool container in the next table:

| Environment Variable                 | Default value                      |
| :----------------------------------- | :--------------------------------- |
| PGPOOL_BACKEND_NODES                 | `nil`                              |
| PGPOOL_PORT_NUMBER                   | `5432`                             |
| PGPOOL_SR_CHECK_USER                 | `nil`                              |
| PGPOOL_SR_CHECK_PASSWORD             | `nil`                              |
| PGPOOL_SR_CHECK_PASSWORD_FILE        | `nil`                              |
| PGPOOL_POSTGRES_USERNAME             | `nil`                              |
| PGPOOL_POSTGRES_PASSWORD             | `nil`                              |
| PGPOOL_PASSWORD_FILE                 | `nil`                              |
| PGPOOL_TIMEOUT                       | `360`                              |
| PGPOOL_ENABLE_LDAP                   | `no`                               |
| PGPOOL_ADMIN_USERNAME=admin          | `nil`                              |
| PGPOOL_ADMIN_PASSWORD=adminpassword  | `nil`                              |
| PGPOOL_ENABLE_LOAD_BALANCING         | `yes`                              |

# Logging

The Bitnami Pgpool-II Docker image sends the container logs to `stdout`. To view the logs:

```bash
$ docker logs pgpool
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of Pgpool-II, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
$ docker pull bitnami/pgpool:latest
```

### Step 2: Stop the running container

Stop the currently running container using the command

```bash
$ docker stop pgpool
```

### Step 3: Remove the currently running container

```bash
$ docker rm -v pgpool
```

### Step 4: Run the new image

Re-create your container from the new image.

```bash
$ docker run --name pgpool bitnami/pgpool:latest
```

# Notable Changes

## 4.1.0-centos-7-r8

- `4.1.0-centos-7-r8` is considered the latest image based on CentOS.
- Standard supported distros: Debian & OEL.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-pgpool/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-pgpool/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-pgpool/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright 2020 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
