[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-postgresql/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-postgresql/tree/master)

# What is PostgreSQL?

> [PostgreSQL](http://www.postgresql.org) is an object-relational database management system (ORDBMS) with an emphasis on extensibility and on standards-compliance [[source]](https://en.wikipedia.org/wiki/PostgreSQL).

# TL;DR;

```bash
$ docker run --name postgresql bitnami/postgresql:latest
```

## Docker Compose

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-postgresql/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* Bitnami images are built on CircleCI and automatically pushed to the Docker Hub.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.

# Supported tags and respective `Dockerfile` links

> NOTE: Debian 8 images have been deprecated in favor of Debian 9 images. Bitnami will not longer publish new Docker images based on Debian 8.


* [`10-ol-7`, `10.4.0-ol-7-r41` (10/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-postgresql/blob/10.4.0-ol-7-r41/10/ol-7/Dockerfile)
* [`10-debian-9`, `10.4.0-debian-9-r30`, `10`, `10.4.0`, `10.4.0-r30`, `latest` (10/Dockerfile)](https://github.com/bitnami/bitnami-docker-postgresql/blob/10.4.0-debian-9-r30/10/Dockerfile)
* [`9.6-ol-7`, `9.6.9-ol-7-r39` (9.6/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-postgresql/blob/9.6.9-ol-7-r39/9.6/ol-7/Dockerfile)
* [`9.6-debian-9`, `9.6.9-debian-9-r30`, `9.6`, `9.6.9`, `9.6.9-r30` (9.6/Dockerfile)](https://github.com/bitnami/bitnami-docker-postgresql/blob/9.6.9-debian-9-r30/9.6/Dockerfile)

Subscribe to project updates by watching the [bitnami/postgresql GitHub repo](https://github.com/bitnami/bitnami-docker-postgresql).


# Get this image

The recommended way to get the Bitnami PostgreSQL Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/postgresql).

```bash
$ docker pull bitnami/postgresql:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/postgresql/tags/) in the Docker Hub Registry.

```bash
$ docker pull bitnami/postgresql:[TAG]
```

If you wish, you can also build the image yourself.

```bash
$ docker build -t bitnami/postgresql:latest https://github.com/bitnami/bitnami-docker-postgresql.git
```

# Persisting your database

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami` path. If the mounted directory is empty, it will be initialized on the first run.

```bash
$ docker run \
    -v /path/to/postgresql-persistence:/bitnami \
    bitnami/postgresql:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  postgresql:
    image: 'bitnami/postgresql:latest'
    ports:
      - '5432:5432'
    volumes:
      - /path/to/postgresql-persistence:/bitnami
```

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a PostgreSQL server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

In this example, we will create a PostgreSQL client instance that will connect to the server instance that is running on the same docker network as the client.

### Step 1: Create a network

```bash
$ docker network create app-tier --driver bridge
```

### Step 2: Launch the PostgreSQL server instance

Use the `--network app-tier` argument to the `docker run` command to attach the PostgreSQL container to the `app-tier` network.

```bash
$ docker run -d --name postgresql-server \
    --network app-tier \
    bitnami/postgresql:latest
```

### Step 3: Launch your PostgreSQL client instance

Finally we create a new container instance to launch the PostgreSQL client and connect to the server created in the previous step:

```bash
$ docker run -it --rm \
    --network app-tier \
    bitnami/postgresql:latest psql -h postgresql-server -U postgres
```

## Using Docker Compose

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `app-tier`. In this example we assume that you want to connect to the PostgreSQL server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge

services:
  postgresql:
    image: 'bitnami/postgresql:latest'
    networks:
      - app-tier
  myapp:
    image: 'YOUR_APPLICATION_IMAGE'
    networks:
      - app-tier
```

> **IMPORTANT**:
>
> 1. Please update the **YOUR_APPLICATION_IMAGE_** placeholder in the above snippet with your application image
> 2. In your application container, use the hostname `postgresql` to connect to the PostgreSQL server

Launch the containers using:

```bash
$ docker-compose up -d
```

# Configuration

## Initializing a new instance

When the container is executed for the first time, it will execute the files with extensions `.sh`, `.sql` and `.sql.gz` located at `/docker-entrypoint-initdb.d`.

In order to have your custom files inside the docker image you can mount them as a volume.

## Setting the root password on first run

In the above commands you may have noticed the use of the `POSTGRESQL_PASSWORD` environment variable. Passing the `POSTGRESQL_PASSWORD` environment variable when running the image for the first time will set the password of the `postgres` user to the value of `POSTGRESQL_PASSWORD`.

```bash
$ docker run --name postgresql -e POSTGRESQL_PASSWORD=password123 bitnami/postgresql:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  postgresql:
    image: 'bitnami/postgresql:latest'
    ports:
      - '5432:5432'
    environment:
      - POSTGRESQL_PASSWORD=password123
```

**Note!**
The `postgres` user is a superuser and has full administrative access to the PostgreSQL database.

## Creating a database on first run

By passing the `POSTGRESQL_DATABASE` environment variable when running the image for the first time, a database will be created. This is useful if your application requires that a database already exists, saving you from having to manually create the database using the PostgreSQL client.

```bash
$ docker run --name postgresql -e POSTGRESQL_DATABASE=my_database bitnami/postgresql:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  postgresql:
    image: 'bitnami/postgresql:latest'
    ports:
      - '5432:5432'
    environment:
      - POSTGRESQL_DATABASE=my_database
```

## Creating a database user on first run

You can also create a restricted database user that only has permissions for the database created with the [`POSTGRESQL_DATABASE`](#creating-a-database-on-first-run) environment variable. To do this, provide the `POSTGRESQL_USERNAME` environment variable.

```bash
$ docker run --name postgresql -e POSTGRESQL_USERNAME=my_user -e POSTGRESQL_PASSWORD=password123 -e POSTGRESQL_DATABASE=my_database bitnami/postgresql:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  postgresql:
    image: 'bitnami/postgresql:latest'
    ports:
      - '5432:5432'
    environment:
      - POSTGRESQL_USERNAME=my_user
      - POSTGRESQL_PASSWORD=password123
      - POSTGRESQL_DATABASE=my_database
```

**Note!**
When `POSTGRESQL_USERNAME` is specified, the `postgres` user is not assigned a password and as a result you cannot login remotely to the PostgreSQL server as the `postgres` user.

## Setting up a streaming replication

A [Streaming replication](http://www.postgresql.org/docs/9.4/static/warm-standby.html#STREAMING-REPLICATION) cluster can easily be setup with the Bitnami PostgreSQL Docker Image using the following environment variables:

 - `POSTGRESQL_REPLICATION_MODE`: Replication mode. Possible values `master`/`slave`. No defaults.
 - `POSTGRESQL_REPLICATION_USER`: The replication user created on the master on first run. No defaults.
 - `POSTGRESQL_REPLICATION_PASSWORD`: The replication users password. No defaults.
 - `POSTGRESQL_MASTER_HOST`: Hostname/IP of replication master (slave parameter). No defaults.
 - `POSTGRESQL_MASTER_PORT_NUMBER`: Server port of the replication master (slave parameter). Defaults to `5432`.

In a replication cluster you can have one master and zero or more slaves. When replication is enabled the master node is in read-write mode, while the slaves are in read-only mode. For best performance its advisable to limit the reads to the slaves.

### Step 1: Create the replication master

The first step is to start the master.

```bash
$ docker run --name postgresql-master \
  -e POSTGRESQL_REPLICATION_MODE=master \
  -e POSTGRESQL_USERNAME=my_user \
  -e POSTGRESQL_PASSWORD=password123 \
  -e POSTGRESQL_DATABASE=my_database \
  -e POSTGRESQL_REPLICATION_USER=my_repl_user \
  -e POSTGRESQL_REPLICATION_PASSWORD=my_repl_password \
  bitnami/postgresql:latest
```

In this command we are configuring the container as the master using the `POSTGRESQL_REPLICATION_MODE=master` parameter. A replication user is specified using the `POSTGRESQL_REPLICATION_USER` and `POSTGRESQL_REPLICATION_PASSWORD` parameters.

### Step 2: Create the replication slave

Next we start a replication slave container.

```bash
$ docker run --name postgresql-slave \
  --link postgresql-master:master \
  -e POSTGRESQL_REPLICATION_MODE=slave \
  -e POSTGRESQL_MASTER_HOST=master \
  -e POSTGRESQL_MASTER_PORT_NUMBER=5432 \
  -e POSTGRESQL_REPLICATION_USER=my_repl_user \
  -e POSTGRESQL_REPLICATION_PASSWORD=my_repl_password \
  bitnami/postgresql:latest
```

In the above command the container is configured as a `slave` using the `POSTGRESQL_REPLICATION_MODE` parameter. Before the replication slave is started, the `POSTGRESQL_MASTER_HOST` and `POSTGRESQL_MASTER_PORT_NUMBER` parameters are used by the slave container to connect to the master and replicate the initial database from the master. The `POSTGRESQL_REPLICATION_USER` and `POSTGRESQL_REPLICATION_PASSWORD` credentials are used to authenticate with the master.

With these two commands you now have a two node PostgreSQL master-slave streaming replication cluster up and running. You can scale the cluster by adding/removing slaves without incurring any downtime.

> **Note**: The cluster replicates the master in its entirety, which includes all users and databases.

If the master goes down you can reconfigure a slave to act as the master and begin accepting writes by creating the trigger file `/tmp/postgresql.trigger.5432`. For example the following command reconfigures `postgresql-slave` to act as the master:

```bash
$ docker exec postgresql-slave touch /tmp/postgresql.trigger.5432
```

> **Note**: The configuration of the other slaves in the cluster needs to be updated so that they are aware of the new master. This would require you to restart the other slaves with `--link postgresql-slave:master` as per our examples.

With Docker Compose the master-slave replication can be setup using:

```yaml
version: '2'

services:
  postgresql-master:
    image: 'bitnami/postgresql:latest'
    ports:
      - '5432'
    volumes:
      - 'postgresql_master_data:/bitnami'
    environment:
      - POSTGRESQL_REPLICATION_MODE=master
      - POSTGRESQL_REPLICATION_USER=repl_user
      - POSTGRESQL_REPLICATION_PASSWORD=repl_password
      - POSTGRESQL_USERNAME=my_user
      - POSTGRESQL_PASSWORD=my_password
      - POSTGRESQL_DATABASE=my_database
    volumes:
      - '/path/to/postgresql-persistence:/bitnami'
  postgresql-slave:
    image: 'bitnami/postgresql:latest'
    ports:
      - '5432'
    depends_on:
      - postgresql-master
    environment:
      - POSTGRESQL_REPLICATION_MODE=slave
      - POSTGRESQL_REPLICATION_USER=repl_user
      - POSTGRESQL_REPLICATION_PASSWORD=repl_password
      - POSTGRESQL_MASTER_HOST=postgresql-master
      - POSTGRESQL_MASTER_PORT_NUMBER=5432
```

Scale the number of slaves using:

```bash
$ docker-compose scale postgresql-master=1 postgresql-slave=3
```

The above command scales up the number of slaves to `3`. You can scale down in the same way.

> **Note**: You should not scale up/down the number of master nodes. Always have only one master node running.

## Configuration file

The image looks for configurations in `/opt/bitnami/postgresql/conf/`. You can mount a volume at `/opt/bitnami/postgresql/conf/` and copy/edit the configurations in the `/path/to/postgresql-persistence/conf/`. The default configurations will be populated to the `conf/` directory if it's empty.

### Step 1: Run the PostgreSQL image

Run the PostgreSQL image, mounting a directory from your host.

```bash
$ docker run --name postgresql \
    -v /path/to/postgresql-persistence/conf/:/opt/bitnami/postgresql/conf/ \
    bitnami/postgresql:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  postgresql:
    image: 'bitnami/postgresql:latest'
    ports:
      - '5432:5432'
    volumes:
      - /path/to/postgresql-persistence/conf/:/opt/bitnami/postresql/conf/
```

### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```bash
vi /path/to/postgresql-persistence/conf/postgresql.conf
```

### Step 3: Restart PostgreSQL

After changing the configuration, restart your PostgreSQL container for changes to take effect.

```bash
$ docker restart postgresql
```

or using Docker Compose:

```bash
$ docker-compose restart postgresql
```

Refer to the [server configuration](http://www.postgresql.org/docs/9.4/static/runtime-config.html) manual for the complete list of configuration options.

# Logging

The Bitnami PostgreSQL Docker image sends the container logs to the `stdout`. To view the logs:

```bash
$ docker logs postgresql
```

or using Docker Compose:

```bash
$ docker-compose logs postgresql
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of PostgreSQL, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
$ docker pull bitnami/postgresql:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/postgresql:latest`.

### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```bash
$ docker stop postgresql
```

or using Docker Compose:

```bash
$ docker-compose stop postgresql
```

Next, take a snapshot of the persistent volume `/path/to/postgresql-persistence` using:

```bash
$ rsync -a /path/to/postgresql-persistence /path/to/postgresql-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

### Step 3: Remove the currently running container

```bash
$ docker rm -v postgresql
```

or using Docker Compose:

```bash
$ docker-compose rm -v postgresql
```

### Step 4: Run the new image

Re-create your container from the new image.

```bash
$ docker run --name postgresql bitnami/postgresql:latest
```

or using Docker Compose:

```bash
$ docker-compose up postgresql
```

# Notable Changes

## 9.6.9-r19 and 10.4.0-r19

- The PostgreSQL container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the PostgreSQL daemon was started as the `postgres` user. From now on, both the container and the PostgreSQL daemon run as user `1001`. As a consequence, the data directory must be writable by that user. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

## 9.5.3-r5

- The `POSTGRES_` prefix on environment variables is now replaced by `POSTGRESQL_`
- `POSTGRES_USER` parameter has been renamed to `POSTGRESQL_USERNAME`.
- `POSTGRES_DB` parameter has been renamed to `POSTGRESQL_DATABASE`.
- `POSTGRES_MODE` parameter has been renamed to `POSTGRESQL_REPLICATION_MODE`.

## 9.5.3-r0

- All volumes have been merged at `/bitnami/postgresql`. Now you only need to mount a single volume at `/bitnami/postgresql` for persistence.
- The logs are always sent to the `stdout` and are no longer collected in the volume.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-postgresql/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-postgresql/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-postgresql/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright (c) 2015-2018 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
