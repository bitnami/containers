# What is PostgreSQL with Replication Manager?

> [PostgreSQL](https://www.postgresql.org) is an open source object-relational database known for its reliability and data integrity. This solution includes [repmgr](https://repmgr.org), an open-source tool for managing replication and failover on PostgreSQL clusters.

# TL;DR

```console
$ docker run --name postgresql-repmgr bitnami/postgresql-repmgr:latest
```

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-postgresql-repmgr/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

You can find the default credentials and available configuration options in the [Environment Variables](#environment-variables) section.

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.

> This [CVE scan report](https://quay.io/repository/bitnami/postgresql-repmgr?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# How to deploy Postgresql-repmgr in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami PostgreSQL HA Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/postgresql-ha).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`13`, `13-debian-10`, `13.3.0`, `13.3.0-debian-10-r1` (13/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-postgresql-repmgr/blob/13.3.0-debian-10-r1/13/debian-10/Dockerfile)
* [`12`, `12-debian-10`, `12.7.0`, `12.7.0-debian-10-r2` (12/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-postgresql-repmgr/blob/12.7.0-debian-10-r2/12/debian-10/Dockerfile)
* [`11`, `11-debian-10`, `11.12.0`, `11.12.0-debian-10-r2`, `latest` (11/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-postgresql-repmgr/blob/11.12.0-debian-10-r2/11/debian-10/Dockerfile)
* [`10`, `10-debian-10`, `10.17.0`, `10.17.0-debian-10-r2` (10/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-postgresql-repmgr/blob/10.17.0-debian-10-r2/10/debian-10/Dockerfile)
* [`9.6`, `9.6-debian-10`, `9.6.22`, `9.6.22-debian-10-r2` (9.6/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-postgresql-repmgr/blob/9.6.22-debian-10-r2/9.6/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/postgresql-repmgr GitHub repo](https://github.com/bitnami/bitnami-docker-postgresql-repmgr).

# Get this image

The recommended way to get the Bitnami PostgreSQL with Replication Manager Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/postgresql-repmgr).

```console
$ docker pull bitnami/postgresql-repmgr:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/postgresql-repmgr/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/postgresql-repmgr:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/postgresql-repmgr:latest 'https://github.com/bitnami/bitnami-docker-postgresql-repmgr.git#master:11/debian-10'
```

# Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/postgresql` path. If the mounted directory is empty, it will be initialized on the first run.

```console
$ docker run \
    -v /path/to/postgresql-repmgr-persistence:/bitnami/postgresql \
    bitnami/postgresql-repmgr:latest
```

The [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-postgresql/blob/master/docker-compose.yml) file present in this repository already configures persistence.

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a PostgreSQL server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

In this example, we will create a PostgreSQL client instance that will connect to the server instance that is running on the same docker network as the client.

### Step 1: Create a network

```console
$ docker network create my-network --driver bridge
```

### Step 2: Launch the postgresql-repmgr container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `my-network` network.

```console
$ docker run --detach --rm --name pg-0 \
  --network my-network \
  --env REPMGR_PARTNER_NODES=pg-0 \
  --env REPMGR_NODE_NAME=pg-0 \
  --env REPMGR_NODE_NETWORK_NAME=pg-0 \
  --env REPMGR_PRIMARY_HOST=pg-0 \
  --env REPMGR_PASSWORD=repmgrpass \
  --env POSTGRESQL_PASSWORD=secretpass \
  bitnami/postgresql-repmgr:latest
```

### Step 3: Launch your PostgreSQL client instance

Finally we create a new container instance to launch the PostgreSQL client and connect to the server created in the previous step:

```console
$ docker run -it --rm \
  --network my-network \
  bitnami/postgresql:10 \
  psql -h pg-0 -U postgres
```

## Using Docker Compose

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `my-network`. In this example we assume that you want to connect to the PostgreSQL server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  my-network:
    driver: bridge

services:
  pg-0:
    image: 'bitnami/postgresql-repmgr:latest'
    networks:
      - my-network
    environment:
      - POSTGRESQL_PASSWORD=custompassword
      - REPMGR_PASSWORD=repmgrpassword
      - REPMGR_PRIMARY_HOST=pg-0
      - REPMGR_NODE_NETWORK_NAME=pg-0
      - REPMGR_NODE_NAME=pg-0
      - REPMGR_PARTNER_NODES=pg-0
  myapp:
    image: 'YOUR_APPLICATION_IMAGE'
    networks:
      - my-network
```

> **IMPORTANT**:
>
> 1. Please update the **YOUR_APPLICATION_IMAGE_** placeholder in the above snippet with your application image
> 2. In your application container, use the hostname `pg-0` to connect to the PostgreSQL server

Launch the containers using:

```console
$ docker-compose up -d
```

# Configuration

## Initializing a new instance

When the container is executed for the first time, it will execute the files with extensions `.sh`, `.sql` and `.sql.gz` located at `/docker-entrypoint-initdb.d`.

In order to have your custom files inside the docker image you can mount them as a volume.

## Setting the root and repmgr passwords on first run

In the above commands you may have noticed the use of the `POSTGRESQL_PASSWORD` and `REPMGR_PASSWORD` environment variables. Passing the `POSTGRESQL_PASSWORD` environment variable when running the image for the first time will set the password of the `postgres` user to the value of `POSTGRESQL_PASSWORD` (or the content of the file specified in `POSTGRESQL_PASSWORD_FILE`). In the same way, passing the `REPMGR_PASSWORD` environment variable sets the password of the `repmgr` user to the value of `REPMGR_PASSWORD` (or the content of the file specified in `REPMGR_PASSWORD_FILE`).

```console
$ docker run --name pg-0 --env REPMGR_PASSWORD=repmgrpass --env POSTGRESQL_PASSWORD=secretpass bitnami/postgresql-repmgr:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-postgresql-repmgr/blob/master/docker-compose.yml) file present in this repository:

```diff
...
services:
  pg-0:
  ...
    environment:
-      - POSTGRESQL_PASSWORD=adminpassword
+      - POSTGRESQL_PASSWORD=password123
-      - REPMGR_PASSWORD=repmgrpassword
+      - REPMGR_PASSWORD=password123
  ...
  pg-1:
  ...
  environment:
-      - POSTGRESQL_PASSWORD=adminpassword
+      - POSTGRESQL_PASSWORD=password123
-      - REPMGR_PASSWORD=repmgrpassword
+      - REPMGR_PASSWORD=password123
...
```

**Note!**
Both `postgres` and `repmgr` users are superusers and have full administrative access to the PostgreSQL database.

Refer to [Creating a database user on first run](#creating-a-database-user-on-first-run) if you want to set an unprivileged user and a password for the `postgres` user.

## Creating a database on first run

By passing the `POSTGRESQL_DATABASE` environment variable when running the image for the first time, a database will be created. This is useful if your application requires that a database already exists, saving you from having to manually create the database using the PostgreSQL client.

```console
$ docker run --name pg-0 --env POSTGRESQL_DATABASE=my_database bitnami/postgresql-repmgr:latest
```

## Creating a database user on first run

You can also create a restricted database user that only has permissions for the database created with the [`POSTGRESQL_DATABASE`](#creating-a-database-on-first-run) environment variable. To do this, provide the `POSTGRESQL_USERNAME` environment variable.

```console
$ docker run --name pg-0 --env POSTGRESQL_USERNAME=my_user --env POSTGRESQL_PASSWORD=password123 --env POSTGRESQL_DATABASE=my_database bitnami/postgresql-repmgr:latest
```

The [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-postgresql/blob/master/docker-compose.yml) file present in this repository already configures this setup.

**Note!**
When `POSTGRESQL_USERNAME` is specified, the `postgres` user is not assigned a password and as a result you cannot login remotely to the PostgreSQL server as the `postgres` user. If you still want to have access with the user `postgres`, please set the `POSTGRESQL_POSTGRES_PASSWORD` environment variable (or the content of the file specified in `POSTGRESQL_POSTGRES_PASSWORD_FILE`).

## Setting up a HA PostgreSQL cluster with streaming replication and repmgr

A HA PostgreSQL cluster with [Streaming replication](https://www.postgresql.org/docs/10/warm-standby.html#STREAMING-REPLICATION) and [repmgr](https://repmgr.org) can easily be setup with the Bitnami PostgreSQL with Replication Manager Docker Image using the following environment variables:

- `POSTGRESQL_PASSWORD`: Password for `postgres` user. No defaults.
- `POSTGRESQL_PASSWORD_FILE`: Path to a file that contains the `postgres` user password. This will override the value specified in `POSTGRESQL_PASSWORD`. No defaults.
- `REPMGR_USERNAME`: Username for `repmgr` user. Defaults to `repmgr`.
- `REPMGR_PASSWORD_FILE`: Path to a file that contains the `repmgr` user password. This will override the value specified in `REPMGR_PASSWORD`. No defaults.
- `REPMGR_PASSWORD`: Password for `repmgr` user. No defaults.
- `REPMGR_USE_PASSFILE`: Configure repmgr to use `passfile` and `PGPASSFILE` instead of plain-text password in its configuration.
- `REPMGR_PASSFILE_PATH`: Location of the passfile, if it doesn't exist it will be created using REPMGR credentials.
- `REPMGR_PRIMARY_HOST`: Hostname of the initial primary node. No defaults.
- `REPMGR_PARTNER_NODES`: Comma separated list of partner nodes in the cluster.  No defaults.
- `REPMGR_NODE_NAME`: Node name. No defaults.
- `REPMGR_NODE_NETWORK_NAME`: Node hostname. No defaults.
- `REPMGR_PGHBA_TRUST_ALL`: This will set the auth-method in the generated pg_hba.conf. Set it to `yes` only if you are using pgpool with LDAP authentication. Default to `no`.

In a HA PostgreSQL cluster you can have one primary and zero or more standby nodes. The primary node is in read-write mode, while the standby nodes are in read-only mode. For best performance its advisable to limit the reads to the standby nodes.

> NOTE: REPMGR_USE_PASSFILE and REPMGR_PASSFILE_PATH will be ignored for Postgresql prior to version 9.6.
>
> When mounting an external passfile using REPMGR_PASSFILE_PATH, it is necessary to also configure REPMGR_PASSWORD and REPMGR_USERNAME accordingly.

### Step 1: Create a network

```console
$ docker network create my-network --driver bridge
```

### Step 2: Create the initial primary node

The first step is to start the initial primary node:

```console
$ docker run --detach --name pg-0 \
  --network my-network \
  --env REPMGR_PARTNER_NODES=pg-0,pg-1 \
  --env REPMGR_NODE_NAME=pg-0 \
  --env REPMGR_NODE_NETWORK_NAME=pg-0 \
  --env REPMGR_PRIMARY_HOST=pg-0 \
  --env REPMGR_PASSWORD=repmgrpass \
  --env POSTGRESQL_PASSWORD=secretpass \
  bitnami/postgresql-repmgr:latest
```

### Step 3: Create a standby node

Next we start a standby node:

```console
$ docker run --detach --name pg-1 \
  --network my-network \
  --env REPMGR_PARTNER_NODES=pg-0,pg-1 \
  --env REPMGR_NODE_NAME=pg-1 \
  --env REPMGR_NODE_NETWORK_NAME=pg-1 \
  --env REPMGR_PRIMARY_HOST=pg-0 \
  --env REPMGR_PASSWORD=repmgrpass \
  --env POSTGRESQL_PASSWORD=secretpass \
  bitnami/postgresql-repmgr:latest
```

With these three commands you now have a two node PostgreSQL primary-standby streaming replication cluster up and running. You can scale the cluster by adding/removing standby nodes without incurring any downtime.

> **Note**: The cluster replicates the primary in its entirety, which includes all users and databases.

If the master goes down, **repmgr** will ensure any of the standby nodes takes the primary role, guaranteeing high availability.

> **Note**: The configuration of the other nodes in the cluster needs to be updated so that they are aware of them. This would require you to restart the old nodes adapting the `REPMGR_PARTNER_NODES` environment variable.

With Docker Compose the HA PostgreSQL cluster can be setup using the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-postgresql-repmgr/blob/master/docker-compose.yml) file present in this repository:

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-postgresql-repmgr/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

## Securing PostgreSQL traffic

PostgreSQL supports the encryption of connections using the SSL/TLS protocol. Should you desire to enable this optional feature, you may use the following environment variables to configure the application:

 - `POSTGRESQL_ENABLE_TLS`: Whether to enable TLS for traffic or not. Defaults to `no`.
 - `POSTGRESQL_TLS_CERT_FILE`: File containing the certificate file for the TLS traffic. No defaults.
 - `POSTGRESQL_TLS_KEY_FILE`: File containing the key for certificate. No defaults.
 - `POSTGRESQL_TLS_CA_FILE`: File containing the CA of the certificate. If provided, PostgreSQL will authenticate TLS/SSL clients by requesting them a certificate (see [ref](https://www.postgresql.org/docs/9.6/auth-methods.html)). No defaults.
 - `POSTGRESQL_TLS_CRL_FILE`: File containing a Certificate Revocation List. No defaults.
 - `POSTGRESQL_TLS_PREFER_SERVER_CIPHERS`: Whether to use the server's TLS cipher preferences rather than the client's. Defaults to `yes`.

When enabling TLS, PostgreSQL will support both standard and encrypted traffic by default, but prefer the latter. Below there are some examples on how to quickly set up TLS traffic:

1. Using `docker run`

    ```console
    $ docker run \
        -v /path/to/certs:/opt/bitnami/postgresql/certs \
        -e POSTGRESQL_ENABLE_TLS=yes \
        -e POSTGRESQL_TLS_CERT_FILE=/opt/bitnami/postgresql/certs/postgres.crt \
        -e POSTGRESQL_TLS_KEY_FILE=/opt/bitnami/postgresql/certs/postgres.key \
        bitnami/postgresql-repmgr:latest
    ```

2. Modifying the `docker-compose.yml` file present in this repository:

    ```yaml
    services:
      pg-0:
      ...
        environment:
          ...
          - POSTGRESQL_ENABLE_TLS=yes
          - POSTGRESQL_TLS_CERT_FILE=/opt/bitnami/postgresql/certs/postgres.crt
          - POSTGRESQL_TLS_KEY_FILE=/opt/bitnami/postgresql/certs/postgres.key
        ...
        volumes:
          ...
          - /path/to/certs:/opt/bitnami/postgresql/certs
      ...
    ```

Alternatively, you may also provide this configuration in your [custom](https://github.com/bitnami/bitnami-docker-postgresql-repmgr) configuration file.

## Configuration file

The image looks for the `repmgr.conf`, `postgresql.conf` and `pg_hba.conf` files in `/opt/bitnami/repmgr/conf/` and `/opt/bitnami/postgresql/conf/`. You can mount a volume at `/bitnami/repmgr/conf/` and copy/edit the configuration files in the `/path/to/custom-conf/`. The default configurations will be populated to the `conf/` directories if `/bitnami/repmgr/conf/` is empty.

```console
/path/to/custom-conf/
└── postgresql.conf
```

As the PostgreSQL with Replication manager image is non-root, you need to set the proper permissions to the mounted directory in your host:

```console
$ sudo chgrp -R root /path/to/custom-conf/
$ sudo chmod -R g+rwX /path/to/custom-conf/
```

### Step 1: Run the PostgreSQL image

Run the PostgreSQL image, mounting a directory from your host.

```console
$ docker run --name pg-0 \
    -v /path/to/custom-conf/:/bitnami/repmgr/conf/ \
    bitnami/postgresql-repmgr:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  pg-0:
    image: bitnami/postgresql-repmgr:latest
    ports:
      - '5432:5432'
    volumes:
      - /path/to/custom-conf/:/bitnami/repmgr/conf/
  pg-1:
    image: bitnami/postgresql-repmgr:latest
    ports:
      - '5432:5432'
    volumes:
      - /path/to/custom-conf/:/bitnami/repmgr/conf/
```

### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```console
vi /path/to/custom-conf/postgresql.conf
```

### Step 3: Restart PostgreSQL

After changing the configuration, restart your PostgreSQL container for changes to take effect.

```console
$ docker restart pg-0
```

or using Docker Compose:

```console
$ docker-compose restart pg-0
$ docker-compose restart pg-1
```

Refer to the [server configuration](http://www.postgresql.org/docs/10/static/runtime-config.html) manual for the complete list of configuration options.

### Allow settings to be loaded from files other than the default `postgresql.conf`

Apart of using a custom `repmgr.conf`, `postgresql.conf` or `pg_hba.conf`, you can include files ending in `.conf` from the `conf.d` directory in the volume at `/bitnami/postgresql/conf/`.
For this purpose, the default `postgresql.conf` contains the following section:

```config
#------------------------------------------------------------------------------
# CONFIG FILE INCLUDES
#------------------------------------------------------------------------------

# These options allow settings to be loaded from files other than the
# default postgresql.conf.

include_dir = 'conf.d'  # Include files ending in '.conf' from directory 'conf.d'
```

If you are using your custom `postgresql.conf`, you should create (or uncomment) the above section in your config file, in this case the structure should be something like

```console
/path/to/custom-conf/
└── postgresql.conf
/path/to/extra-custom-conf/
└── extended.conf
```

Remember to set the proper permissions to the mounted directory in your host:

```console
$ sudo chgrp -R root /path/to/extra-custom-conf/
$ sudo chmod -R g+rwX /path/to/extra-custom-conf/
```

### Step 1: Run the PostgreSQL image

Run the PostgreSQL image, mounting a directory from your host.

```console
$ docker run --name pg-0 \
    -v /path/to/extra-custom-conf/:/bitnami/postgresql/conf/conf.d/ \
    -v /path/to/custom-conf/:/bitnami/repmgr/conf/ \
    bitnami/postgresql-repmgr:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  pg-0:
    image: bitnami/postgresql-repmgr:latest
    ports:
      - '5432:5432'
    volumes:
      - /path/to/extra-custom-conf/:/bitnami/postgresql/conf/conf.d/
      - /path/to/custom-conf/:/bitnami/repmgr/conf/
  pg-1:
    image: bitnami/postgresql-repmgr:latest
    ports:
      - '5432:5432'
    volumes:
      - /path/to/extra-custom-conf/:/bitnami/postgresql/conf/conf.d/
      - /path/to/custom-conf/:/bitnami/repmgr/conf/
```

### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```console
vi /path/to/extra-custom-conf/extended.conf
```

### Step 3: Restart PostgreSQL

After changing the configuration, restart your PostgreSQL container for changes to take effect.

```console
$ docker restart pg-0
```

or using Docker Compose:

```console
$ docker-compose restart pg-0
$ docker-compose restart pg-1
```

## Environment variables

Please see the list of environment variables available in the Bitnami PostgreSQL with Replication Manager container in the next table:

| Environment Variable                 | Default value |
|:-------------------------------------|:--------------|
| REPMGR_NODE_ID                       | `nil`         |
| REPMGR_NODE_NAME                     | `nil`         |
| REPMGR_NODE_NETWORK_NAME             | `nil`         |
| REPMGR_NODE_PRIORITY                 | `100`         |
| REPMGR_PARTNER_NODES                 | `nil`         |
| REPMGR_PRIMARY_HOST                  | `nil`         |
| REPMGR_NODE_LOCATION                 | `default`     |
| REPMGR_PRIMARY_PORT                  | `5432`        |
| REPMGR_NODE_ID                       | `nil`         |
| REPMGR_PORT_NUMBER                   | `5432`        |
| REPMGR_LOG_LEVEL                     | `NOTICE`      |
| REPMGR_START_OPTIONS                 | `nil`         |
| REPMGR_CONNECT_TIMEOUT               | `5`           |
| REPMGR_RECONNECT_ATTEMPTS            | `3`           |
| REPMGR_RECONNECT_INTERVAL            | `5`           |
| REPMGR_USE_REPLICATION_SLOTS         | `1`           |
| REPMGR_MASTER_RESPONSE_TIMEOUT       | `20`          |
| REPMGR_DEGRADED_MONITORING_TIMEOUT   | `5`           |
| REPMGR_USERNAME                      | `repmgr`      |
| REPMGR_DATABASE                      | `repmgr`      |
| REPMGR_PASSWORD                      | `nil`         |
| REPMGR_PASSWORD_FILE                 | `nil`         |
| REPMGR_USE_PASSFILE                  | `nil`         |
| POSTGRESQL_USERNAME                  | `postgres`    |
| POSTGRESQL_DATABASE                  | `nil`         |
| POSTGRESQL_PASSWORD                  | `nil`         |
| POSTGRESQL_PASSWORD_FILE             | `nil`         |
| POSTGRESQL_POSTGRES_PASSWORD         | `nil`         |
| POSTGRESQL_POSTGRES_PASSWORD_FILE    | `nil`         |
| POSTGRESQL_PORT_NUMBER               | `5432`        |
| POSTGRESQL_INITDB_ARGS               | `nil`         |
| POSTGRESQL_PGCTLTIMEOUT              | `60`          |
| POSTGRESQL_SHUTDOWN_MODE             | `fast`        |
| POSTGRESQL_ENABLE_TLS                | `no`          |
| POSTGRESQL_TLS_CERT_FILE             | `nil`         |
| POSTGRESQL_TLS_KEY_FILE              | `nil`         |
| POSTGRESQL_TLS_CA_FILE               | `nil`         |
| POSTGRESQL_TLS_CRL_FILE              | `nil`         |
| POSTGRESQL_TLS_PREFER_SERVER_CIPHERS | `yes`         |

# Logging

The Bitnami PostgreSQL with Replication Manager Docker image sends the container logs to `stdout`. To view the logs:

```console
$ docker logs pg-0
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of PostgreSQL with Replication Manager, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```console
$ docker pull bitnami/postgresql-repmgr:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/postgresql-repmgr:latest`.

### Step 2: Stop the running container

Stop the currently running container using the command

```console
$ docker stop pg-0
```

or using Docker Compose:

```console
$ docker-compose stop pg-0
$ docker-compose stop pg-1
```

Next, take a snapshot of the persistent volume `/path/to/postgresql-persistence` using:

```console
$ rsync -a /path/to/postgresql-persistence /path/to/postgresql-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

### Step 3: Remove the currently running container

```console
$ docker rm -v pg-0
```

or using Docker Compose:

```console
$ docker-compose rm -v pg-0
$ docker-compose rm -v pg-1
```

### Step 4: Run the new image

Re-create your container from the new image.

```console
$ docker run --name pg-0 bitnami/postgresql-repmgr:latest
```

or using Docker Compose:

```console
$ docker-compose up pg-0
$ docker-compose up pg-1
```

# Notable Changes

## 9.6.16-centos-7-r71, 10.11.0-centos-7-r71, 11.6.0-centos-7-r67, and 12.1.0-centos-7-r67

- `9.6.16-centos-7-r71`, `10.11.0-centos-7-r71`, `11.6.0-centos-7-r67`, and `12.1.0-centos-7-r67` are considered the latest images based on CentOS.
- Standard supported distros: Debian & OEL.

## 9.6.15-r18, 9.6.15-ol-7-r23, 9.6.15-centos-7-r23, 10.10.0-r18, 10.10.0-ol-7-r23, 10.10.0-centos-7-r23, 11.5.0-r19, 11.5.0-centos-7-r23, 11.5.0-ol-7-r23

- Adds Postgis extension to postgresql, version 2.3.x to Postgresiql 9.6 and version 2.5 to 10, 11 and 12.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-postgresql-repmgr/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-postgresql-repmgr/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-postgresql-repmgr/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright 2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
