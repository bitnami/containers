[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-redis/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-redis/tree/master)
[![Slack](http://slack.oss.bitnami.com/badge.svg)](http://slack.oss.bitnami.com)
[![Kubectl](https://img.shields.io/badge/kubectl-Available-green.svg)](https://raw.githubusercontent.com/bitnami/bitnami-docker-redis/master/kubernetes.yml)

# What is Redis?

> Redis is an advanced key-value cache and store. It is often referred to as a data structure server since keys can contain strings, hashes, lists, sets, sorted sets, bitmaps and hyperloglogs.

[redis.io](http://redis.io/)

# TL;DR;

```bash
docker run --name redis bitnami/redis:latest
```

## Docker Compose

```yaml
version: '2'

services:
  redis:
    image: 'bitnami/redis:latest'
    ports:
      - '6379:6379'
```

## Kubernetes

> **WARNING**: This is a beta configuration, currently unsupported.

Get the raw URL pointing to the kubernetes.yml manifest and use kubectl to create the resources on your Kubernetes cluster like so:

```bash
$ kubectl create -f https://raw.githubusercontent.com/bitnami/bitnami-docker-redis/master/kubernetes.yml
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* Bitnami images are built on CircleCI and automatically pushed to the Docker Hub.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.

# Get this image

The recommended way to get the Bitnami Redis Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/redis).

```bash
docker pull bitnami/redis:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/redis/tags/) in the Docker Hub Registry.

```bash
docker pull bitnami/redis:[TAG]
```

If you wish, you can also build the image yourself.

```bash
docker build -t bitnami/redis:latest https://github.com/bitnami/bitnami-docker-redis.git
```

# Persisting your database

If you remove the container all your data and configurations will be lost, and the next time you run the image the data and configurations will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

**Note!**
If you have already started using your database, follow the steps on [backing up](#backing-up-your-container) and [restoring](#restoring-a-backup) to pull the data from your running container down to your host.

The image exposes a volume at `/bitnami/redis` for the Redis data and configurations. For persistence you can mount a directory at this location from your host. If the mounted directory is empty, it will be initialized on the first run.

```bash
docker run -v /path/to/redis-persistence:/bitnami/redis bitnami/redis:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  redis:
    image: 'bitnami/redis:latest'
    ports:
      - '6379:6379'
    volumes:
      - /path/to/redis-persistence:/bitnami/redis
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

## Setting the server password on first run

Passing the `REDIS_PASSWORD` environment variable when running the image for the first time will set the Redis server password to the value of `REDIS_PASSWORD`.

```bash
docker run --name redis -e REDIS_PASSWORD=password123 bitnami/redis:latest
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

## Setting up a replication

A [replication](http://redis.io/topics/replication) cluster can easily be setup with the Bitnami Redis Docker Image using the following environment variables:

 - `REDIS_REPLICATION_MODE`: The replication mode. Possible values `master`/`slave`. No defaults.
 - `REDIS_MASTER_HOST`: Hostname/IP of replication master (slave parameter). No defaults.
 - `REDIS_MASTER_PORT`: Server port of the replication master (slave parameter). Defaults to `6379`.
 - `REDIS_MASTER_PASSWORD`: Password to authenticate with the master (slave parameter). No defaults.

In a replication cluster you can have one master and zero or more slaves. When replication is enabled the master node is in read-write mode, while the slaves are in read-only mode. For best performance its advisable to limit the reads to the slaves.

### Step 1: Create the replication master

The first step is to start the Redis master.

```bash
docker run --name redis-master \
  -e REDIS_REPLICATION_MODE=master \
  -e REDIS_PASSWORD=masterpassword123 \
  bitnami/redis:latest
```

In the above command the container is configured as the `master` using the `REDIS_REPLICATION_MODE` parameter. The `REDIS_PASSWORD` parameter enables authentication on the Redis master.

### Step 2: Create the replication slave

Next we start a Redis slave container.

```bash
docker run --name redis-slave \
  --link redis-master:master \
  -e REDIS_REPLICATION_MODE=slave \
  -e REDIS_MASTER_HOST=master \
  -e REDIS_MASTER_PORT=6379 \
  -e REDIS_MASTER_PASSWORD=masterpassword123 \
  -e REDIS_PASSWORD=password123 \
  bitnami/redis:latest
```

In the above command the container is configured as a `slave` using the `REDIS_REPLICATION_MODE` parameter. The `REDIS_MASTER_HOST`, `REDIS_MASTER_PORT` and `REDIS_MASTER_PASSWORD ` parameters are used connect and authenticate with the Redis master. The `REDIS_PASSWORD` parameter enables authentication on the Redis slave.

You now have a two node Redis master/slave replication cluster up and running which can be scaled by adding/removing slaves.

If the Redis master goes down you can reconfigure a slave to become a master using:

```bash
docker exec redis-slave redis-cli -a password123 SLAVEOF NO ONE
```

> **Note**: The configuration of the other slaves in the cluster needs to be updated so that they are aware of the new master. In our example, this would involve restarting the other slaves with `--link redis-slave:master`.

With Docker Compose the master/slave replication can be setup using:

```yaml
version: '2'

services:
  redis-primary:
    image: 'bitnami/redis:latest'
    ports:
      - '6379'
    environment:
      - REDIS_REPLICATION_MODE=master
      - REDIS_PASSWORD=my_password
    volumes:
      - '/path/to/redis-persistence:/bitnami/redis'

  redis-secondary:
    image: 'bitnami/redis:latest'
    ports:
      - '6379'
    depends_on:
      - redis-primary
    environment:
      - REDIS_REPLICATION_MODE=slave
      - REDIS_MASTER_HOST=redis-primary
      - REDIS_MASTER_PORT=6379
      - REDIS_MASTER_PASSWORD=my_password
      - REDIS_PASSWORD=my_password
```

Scale the number of slaves using:

```bash
docker-compose scale redis-primary=1 redis-secondary=3
```

The above command scales up the number of slaves to `3`. You can scale down in the same way.

> **Note**: You should not scale up/down the number of master nodes. Always have only one master node running.

## Configuration file

The image looks for configuration in the `conf/` directory of `/bitnami/redis`. As as mentioned in [Persisting your database](#persisting-your-data) you can mount a volume at this location and copy your own configurations in the `conf/` directory. The default configuration will be copied to the `conf/` directory if it's empty.

### Step 1: Run the Redis image

Run the Redis image, mounting a directory from your host.

```bash
docker run --name redis -v /path/to/redis-persistence:/bitnami/redis bitnami/redis:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  redis:
    image: 'bitnami/redis:latest'
    ports:
      - '6379:6379'
    volumes:
      - /path/to/redis-persistence:/bitnami/redis
```

### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```bash
vi /path/to/redis-persistence/conf/redis.conf
```

### Step 3: Restart Redis

After changing the configuration, restart your Redis container for changes to take effect.

```bash
docker restart redis
```

or using Docker Compose:

```bash
docker-compose restart redis
```

**Further Reading:**

  - [Redis Configuration Documentation](http://redis.io/topics/config)

# Logging

The Bitnami Redis Docker image sends the container logs to the `stdout`. To view the logs:

```bash
docker logs redis
```

or using Docker Compose:

```bash
docker-compose logs redis
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Backing up your container

To backup your data, configuration and logs, follow these simple steps:

### Step 1: Stop the currently running container

```bash
docker stop redis
```

or using Docker Compose:

```bash
docker-compose stop redis
```

### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```bash
docker run --rm -v /path/to/redis-backups:/backups --volumes-from redis busybox \
  cp -a /bitnami/redis:latest /backups/latest
```

or using Docker Compose:

```bash
docker run --rm -v /path/to/redis-backups:/backups --volumes-from `docker-compose ps -q redis` busybox \
  cp -a /bitnami/redis:latest /backups/latest
```

## Restoring a backup

Restoring a backup is as simple as mounting the backup as volumes in the container.

```bash
docker run -v /path/to/redis-backups/latest:/bitnami/redis bitnami/redis:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  redis:
    image: 'bitnami/redis:latest'
    ports:
      - '6379:6379'
    volumes:
      - /path/to/redis-backups/latest:/bitnami/redis
```

## Upgrade this image

Bitnami provides up-to-date versions of Redis, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
docker pull bitnami/redis:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/redis:latest`.

### Step 2: Stop and backup the currently running container

Before continuing, you should backup your container's data, configuration and logs.

Follow the steps on [creating a backup](#backing-up-your-container).

### Step 3: Remove the currently running container

```bash
docker rm -v redis
```

or using Docker Compose:

```bash
docker-compose rm -v redis
```

### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if necessary.

```bash
docker run --name redis bitnami/redis:latest
```

or using Docker Compose:

```bash
docker-compose start redis
```

# Notable Changes

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

# Community

Most real time communication happens in the `#containers` channel at [bitnami-oss.slack.com](http://bitnami-oss.slack.com); you can sign up at [slack.oss.bitnami.com](http://slack.oss.bitnami.com).

Discussions are archived at [bitnami-oss.slackarchive.io](https://bitnami-oss.slackarchive.io).

# License
Copyright (c) 2015-2016 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
