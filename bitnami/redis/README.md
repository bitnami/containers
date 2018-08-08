[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-redis/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-redis/tree/master)

# What is Redis?

> Redis is an advanced key-value cache and store. It is often referred to as a data structure server since keys can contain strings, hashes, lists, sets, sorted sets, bitmaps and hyperloglogs.

[redis.io](http://redis.io/)

# TL;DR;

```bash
$ docker run --name redis -e ALLOW_EMPTY_PASSWORD=yes bitnami/redis:latest
```

## Docker Compose

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-redis/master/docker-compose.yml > docker-compose.yml
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


* [`4.0-ol-7`, `4.0.11-ol-7-r1` (4.0/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-redis/blob/4.0.11-ol-7-r1/4.0/ol-7/Dockerfile)
* [`4.0-debian-9`, `4.0.11-debian-9-r2`, `4.0`, `4.0.11`, `4.0.11-r2`, `latest` (4.0/Dockerfile)](https://github.com/bitnami/bitnami-docker-redis/blob/4.0.11-debian-9-r2/4.0/Dockerfile)

Subscribe to project updates by watching the [bitnami/redis GitHub repo](https://github.com/bitnami/bitnami-docker-redis).

# Get this image

The recommended way to get the Bitnami Redis Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/redis).

```bash
$ docker pull bitnami/redis:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/redis/tags/) in the Docker Hub Registry.

```bash
$ docker pull bitnami/redis:[TAG]
```

If you wish, you can also build the image yourself.

```bash
$ docker build -t bitnami/redis:latest https://github.com/bitnami/bitnami-docker-redis.git
```

# Persisting your database

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami` path. If the mounted directory is empty, it will be initialized on the first run.


```bash
$ docker run \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -v /path/to/redis-persistence:/bitnami \
    bitnami/redis:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  redis:
    image: 'bitnami/redis:latest'
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    ports:
      - '6379:6379'
    volumes:
      - /path/to/redis-persistence:/bitnami
```

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a Redis server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

In this example, we will create a Redis client instance that will connect to the server instance that is running on the same docker network as the client.

### Step 1: Create a network

```bash
$ docker network create app-tier --driver bridge
```

### Step 2: Launch the Redis server instance

Use the `--network app-tier` argument to the `docker run` command to attach the Redis container to the `app-tier` network.

```bash
$ docker run -d --name redis-server \
    -e ALLOW_EMPTY_PASSWORD=yes \
    --network app-tier \
    bitnami/redis:latest
```

### Step 3: Launch your Redis client instance

Finally we create a new container instance to launch the Redis client and connect to the server created in the previous step:

```bash
$ docker run -it --rm \
    --network app-tier \
    bitnami/redis:latest redis-cli -h redis-server
```

## Using Docker Compose

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `app-tier`. In this example we assume that you want to connect to the Redis server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge

services:
  redis:
    image: 'bitnami/redis:latest'
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
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
> 2. In your application container, use the hostname `redis` to connect to the Redis server

Launch the containers using:

```bash
$ docker-compose up -d
```

# Configuration

## Disabling Redis commands

For security reasons, you may want to disable some commands. You can specify them by using the following environment
variable on the first run:

- `DISABLE_COMMANDS`: Comma-separated list of Redis commands to disable. Defaults to empty.

```bash
$ docker run --name redis -e DISABLE_COMMANDS=FLUSHDB,FLUSHALL,CONFIG bitnami/redis:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  redis:
    image: 'bitnami/redis:latest'
    ports:
      - '6379:6379'
    environment:
      - DISABLE_COMMANDS=FLUSHDB,FLUSHALL,CONFIG
```

As specified in the docker-compose, `FLUSHDB` and `FLUSHALL` commands are disabled. Comment out or remove the
environment variable if you don't want to disable any commands:

```yaml
version: '2'

services:
  redis:
    image: 'bitnami/redis:latest'
    environment:
      # - DISABLE_COMMANDS=FLUSHDB,FLUSHALL
```

## Passing extra command-line flags to redis-server startup

Passing extra command-line flags to the redis service command is possible through the following env var:

- `REDIS_EXTRA_FLAGS`: Flags to be appended to the startup command. No defaults

```bash
$ docker run --name redis -e ALLOW_EMPTY_PASSWORD=yes -e REDIS_EXTRA_FLAGS='--maxmemory 100mb' bitnami/redis:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  redis:
    image: 'bitnami/redis:latest'
    ports:
      - '6379:6379'
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - REDIS_EXTRA_FLAGS=--maxmemory 100mb
```

## Setting the server password on first run

Passing the `REDIS_PASSWORD` environment variable when running the image for the first time will set the Redis server password to the value of `REDIS_PASSWORD`.

```bash
$ docker run --name redis -e REDIS_PASSWORD=password123 bitnami/redis:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  redis:
    image: 'bitnami/redis:latest'
    ports:
      - '6379:6379'
    environment:
      - REDIS_PASSWORD=password123
```

**Warning** The Redis database is always configured with remote access enabled. It's suggested that the `REDIS_PASSWORD` env variable is always specified to set a password. In case you want to access the database without a password set the environment variable `ALLOW_EMPTY_PASSWORD=yes`. **This is recommended only for development**.

## Allowing empty passwords

By default the Redis image expects all the available passwords to be set. In order to allow empty passwords, it is necessary to set the `ALLOW_EMPTY_PASSWORD=yes` env variable. This env variable is only recommended for testing or development purposes. We strongly recommend specifying the `REDIS_PASSWORD` for any other scenario.

```bash
$ docker run --name redis -e ALLOW_EMPTY_PASSWORD=yes bitnami/redis:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  redis:
    image: 'bitnami/redis:latest'
    ports:
      - '6379:6379'
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
```

## Setting up a replication

A [replication](http://redis.io/topics/replication) cluster can easily be setup with the Bitnami Redis Docker Image using the following environment variables:

 - `REDIS_REPLICATION_MODE`: The replication mode. Possible values `master`/`slave`. No defaults.
 - `REDIS_MASTER_HOST`: Hostname/IP of replication master (slave parameter). No defaults.
 - `REDIS_MASTER_PORT_NUMBER`: Server port of the replication master (slave parameter). Defaults to `6379`.
 - `REDIS_MASTER_PASSWORD`: Password to authenticate with the master (slave parameter). No defaults.

In a replication cluster you can have one master and zero or more slaves. When replication is enabled the master node is in read-write mode, while the slaves are in read-only mode. For best performance its advisable to limit the reads to the slaves.

### Step 1: Create the replication master

The first step is to start the Redis master.

```bash
$ docker run --name redis-master \
  -e REDIS_REPLICATION_MODE=master \
  -e REDIS_PASSWORD=masterpassword123 \
  bitnami/redis:latest
```

In the above command the container is configured as the `master` using the `REDIS_REPLICATION_MODE` parameter. The `REDIS_PASSWORD` parameter enables authentication on the Redis master.

### Step 2: Create the replication slave

Next we start a Redis slave container.

```bash
$ docker run --name redis-slave \
  --link redis-master:master \
  -e REDIS_REPLICATION_MODE=slave \
  -e REDIS_MASTER_HOST=master \
  -e REDIS_MASTER_PORT_NUMBER=6379 \
  -e REDIS_MASTER_PASSWORD=masterpassword123 \
  -e REDIS_PASSWORD=password123 \
  bitnami/redis:latest
```

In the above command the container is configured as a `slave` using the `REDIS_REPLICATION_MODE` parameter. The `REDIS_MASTER_HOST`, `REDIS_MASTER_PORT_NUMBER` and `REDIS_MASTER_PASSWORD ` parameters are used connect and authenticate with the Redis master. The `REDIS_PASSWORD` parameter enables authentication on the Redis slave.

You now have a two node Redis master/slave replication cluster up and running which can be scaled by adding/removing slaves.

If the Redis master goes down you can reconfigure a slave to become a master using:

```bash
$ docker exec redis-slave redis-cli -a password123 SLAVEOF NO ONE
```

> **Note**: The configuration of the other slaves in the cluster needs to be updated so that they are aware of the new master. In our example, this would involve restarting the other slaves with `--link redis-slave:master`.

With Docker Compose the master/slave replication can be setup using:

```yaml
version: '2'

services:
  redis-master:
    image: 'bitnami/redis:latest'
    ports:
      - '6379'
    environment:
      - REDIS_REPLICATION_MODE=master
      - REDIS_PASSWORD=my_master_password
    volumes:
      - '/path/to/redis-persistence:/bitnami'

  redis-slave:
    image: 'bitnami/redis:latest'
    ports:
      - '6379'
    depends_on:
      - redis-master
    environment:
      - REDIS_REPLICATION_MODE=slave
      - REDIS_MASTER_HOST=redis-master
      - REDIS_MASTER_PORT_NUMBER=6379
      - REDIS_MASTER_PASSWORD=my_master_password
      - REDIS_PASSWORD=my_slave_password
```

Scale the number of slaves using:

```bash
$ docker-compose scale redis-master=1 redis-secondary=3
```

The above command scales up the number of slaves to `3`. You can scale down in the same way.

> **Note**: You should not scale up/down the number of master nodes. Always have only one master node running.

## Configuration file

The image looks for configurations in `/bitnami/redis/conf/`. As mentioned in [Persisting your database](#persisting-your-database) you can mount a volume at `/bitnami` and copy/edit the configurations in the `/path/to/redis-persistence/redis/conf/`. The default configurations will be populated to the `conf/` directory if it's empty.

### Step 1: Run the Redis image

Run the Redis image, mounting a directory from your host.

```bash
$ docker run --name redis \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -v /path/to/redis-persistence:/bitnami \
    bitnami/redis:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  redis:
    image: 'bitnami/redis:latest'
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    ports:
      - '6379:6379'
    volumes:
      - /path/to/redis-persistence:/bitnami
```

### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```bash
$ vi /path/to/redis-persistence/redis/conf/redis.conf
```

### Step 3: Restart Redis

After changing the configuration, restart your Redis container for changes to take effect.

```bash
$ docker restart redis
```

or using Docker Compose:

```bash
$ docker-compose restart redis
```

Refer to the [Redis configuration](http://redis.io/topics/config) manual for the complete list of configuration options.

# Logging

The Bitnami Redis Docker image sends the container logs to the `stdout`. To view the logs:

```bash
$ docker logs redis
```

or using Docker Compose:

```bash
$ docker-compose logs redis
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of Redis, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
$ docker pull bitnami/redis:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/redis:latest`.

### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```bash
$ docker stop redis
```

or using Docker Compose:

```bash
$ docker-compose stop redis
```

Next, take a snapshot of the persistent volume `/path/to/redis-persistence` using:

```bash
$ rsync -a /path/to/redis-persistence /path/to/redis-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

### Step 3: Remove the currently running container

```bash
$ docker rm -v redis
```

or using Docker Compose:

```bash
$ docker-compose rm -v redis
```

### Step 4: Run the new image

Re-create your container from the new image.

```bash
$ docker run --name redis bitnami/redis:latest
```

or using Docker Compose:

```bash
$ docker-compose up redis
```

# Notable Changes

## 4.0.1-r1

- The redis container has been migrated to a non-root container approach. Previously the container run as `root` user and the redis daemon was started as `redis` user. From now own, both the container and the redis daemon run as user `1001`.
  As a consequence, the configuration files are writable by the user running the redis process.

## 3.2.0-r0

- All volumes have been merged at `/bitnami/redis`. Now you only need to mount a single volume at `/bitnami/redis` for persistence.
- The logs are always sent to the `stdout` and are no longer collected in the volume.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-redis/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-redis/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-redis/issues). For us to provide better support, be sure to include the following information in your issue:

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
