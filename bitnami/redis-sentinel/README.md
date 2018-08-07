[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-redis-sentinel/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-redis-sentinel/tree/master)

# What is Redis Sentinel?

> Redis Sentinel provides high availability for Redis. In practical terms this means that using Sentinel you can create a Redis deployment that resists without human intervention to certain kind of failures.
> 
> Redis Sentinel also provides other collateral tasks such as monitoring, notifications and acts as a configuration provider for clients.


[redis.io](http://redis.io/)

# TL;DR;

```bash
$ docker run --name redis-sentinel -e REDIS_MASTER_HOST=redis bitnami/redis-sentinel:latest
```

## Docker Compose

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-redis-sentinel/master/docker-compose.yml > docker-compose.yml
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


* [`4.0-ol-7`, `4.0.11-ol-7-r0` (4.0/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-redis-sentinel/blob/4.0.11-ol-7-r0/4.0/ol-7/Dockerfile)
* [`4.0-debian-9`, `4.0.11-debian-9-r0`, `4.0`, `4.0.11`, `4.0.11-r0`, `latest` (4.0/Dockerfile)](https://github.com/bitnami/bitnami-docker-redis-sentinel/blob/4.0.11-debian-9-r0/4.0/Dockerfile)

Subscribe to project updates by watching the [bitnami/redis-sentinel GitHub repo](https://github.com/bitnami/bitnami-docker-redis-sentinel).

# Get this image

The recommended way to get the Bitnami Redis Sentinel Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/redis-sentinel).

```bash
$ docker pull bitnami/redis-sentinel:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/redis-sentinel/tags/) in the Docker Hub Registry.

```bash
$ docker pull bitnami/redis-sentinel:[TAG]
```

If you wish, you can also build the image yourself.

```bash
$ docker build -t bitnami/redis-sentinel:latest https://github.com/bitnami/bitnami-docker-redis-sentinel.git
```

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a Redis server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

In this example, we will create a Redis Sentinel instance that will monitor a Redis instance that is running on the same docker network.

### Step 1: Create a network

```bash
$ docker network create app-tier --driver bridge
```

### Step 2: Launch the Redis instance

Use the `--network app-tier` argument to the `docker run` command to attach the Redis container to the `app-tier` network.

```bash
$ docker run -d --name redis-server \
    -e ALLOW_EMPTY_PASSWORD=yes \
    --network app-tier \
    bitnami/redis:latest
```

### Step 3: Launch your Redis Sentinel instance

Finally we create a new container instance to launch the Redis client and connect to the server created in the previous step:

```bash
$ docker run -it --rm \
    -e REDIS_MASTER_HOST=redis \
    --network app-tier \
    bitnami/redis-sentinel:latest
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
  redis-sentinel:
    image: 'bitnami/redis-sentinel:latest'
    environment:
      - REDIS_MASTER_HOST=redis
    ports:
      - '26379:26379'
    networks:
      - app-tier
```

Launch the containers using:

```bash
$ docker-compose up -d
```

# Configuration

## Configuration file

The image looks for configurations in `/bitnami/redis-sentinel/conf/`. You can mount a volume at `/bitnami` and copy/edit the configurations in the `/path/to/redis-persistence/redis/conf/`. The default configurations will be populated to the `conf/` directory if it's empty.

### Step 1: Run the Redis Sentinel image

Run the Redis Sentinel image, mounting a directory from your host.

```bash
$ docker run --name redis-sentinel \
    -e REDIS_MASTER_HOST=redis \
    -v /path/to/redis-sentinel/persistence:/bitnami \
    bitnami/redis-sentinel:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  redis-sentinel:
    image: 'bitnami/redis-sentinel:latest'
    environment:
      - REDIS_MASTER_HOST=redis
    ports:
      - '26379:26379'
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

The Bitnami Redis Sentinel Docker Image sends the container logs to the `stdout`. To view the logs:

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

Bitnami provides up-to-date versions of Redis Sentinel, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
$ docker pull bitnami/redis-sentinel:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/redis-sentinel:latest`.

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
$ docker run --name redis bitnami/redis-sentinel:latest
```

or using Docker Compose:

```bash
$ docker-compose up redis
```

# Notable Changes

## 4.0.10-r25

- The Redis sentinel container has been migrated to a non-root container approach. Previously the container run as `root` user and the redis daemon was started as `redis` user. From now own, both the container and the redis daemon run as user `1001`. As a consequence, the configuration files are writable by the user running the redis process. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-redis-sentinel/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-redis-sentinel/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-redis-sentinel/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License
Copyright (c) 2018 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
