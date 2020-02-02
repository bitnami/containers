
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
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DTC)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/redis-sentinel?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/containers/how-to/work-with-non-root-containers/).

# How to deploy Redis Sentinel in Kubernetes?

You can find an example for testing in the file `test.yaml`. To launch this sample file run:

```bash
$ kubectl apply -f test.yaml
```

> NOTE: If you are pulling from a private containers registry, replace the image name with the full URL to the docker image. E.g.
>
> - image: 'your-registry/image-name:your-version'

# Supported tags and respective `Dockerfile` links

> NOTE: Debian 9 images have been deprecated in favor of Debian 10 images. Bitnami will not longer publish new Docker images based on Debian 9.

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/).


* [`5.0-ol-7`, `5.0.7-ol-7-r74` (5.0/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-redis-sentinel/blob/5.0.7-ol-7-r74/5.0/ol-7/Dockerfile)
* [`5.0-debian-10`, `5.0.7-debian-10-r8`, `5.0`, `5.0.7`, `latest` (5.0/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-redis-sentinel/blob/5.0.7-debian-10-r8/5.0/debian-10/Dockerfile)
* [`4.0-ol-7`, `4.0.14-ol-7-r319` (4.0/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-redis-sentinel/blob/4.0.14-ol-7-r319/4.0/ol-7/Dockerfile)
* [`4.0-debian-10`, `4.0.14-debian-10-r8`, `4.0`, `4.0.14` (4.0/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-redis-sentinel/blob/4.0.14-debian-10-r8/4.0/debian-10/Dockerfile)

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
$ docker build -t bitnami/redis-sentinel:latest 'https://github.com/bitnami/bitnami-docker-redis-sentinel.git#master:5.0/debian-10'
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

## Environment variables

The Redis Sentinel instance can be customized by specifying environment variables on the first run. The following environment values are provided to customize Redis Sentinel:

- `REDIS_MASTER_HOST`: Host of the Redis master to monitor. Default: **redis**.
- `REDIS_MASTER_PORT_NUMBER`: Port of the Redis master to monitor. Default: **6379**.
- `REDIS_MASTER_SET`: Name of the set of Redis instances to monitor. Default: **mymaster**.
- `REDIS_MASTER_PASSWORD`: Password to authenticate with the master. No defaults. As an alternative, you can mount a file with the password and set the `REDIS_MASTER_PASSWORD_FILE` variable.
- `REDIS_SENTINEL_PORT_NUMBER`: Redis Sentinel port. Default: **26379**.
- `REDIS_SENTINEL_QUORUM`: Number of Sentinels that need to agree about the fact the master is not reachable. Default: **2**.
- `REDIS_SENTINEL_PASSWORD`: Password to authenticate with this sentinel and to authenticate to other sentinels. No defaults. Needs to be identical on all sentinels. As an alternative, you can mount a file with the password and set the `REDIS_SENTINEL_PASSWORD_FILE` variable.
- `REDIS_SENTINEL_DOWN_AFTER_MILLISECONDS`: Number of milliseconds before master is declared down. Default: **60000**.
- `REDIS_SENTINEL_FAILOVER_TIMEOUT`: Specifies the failover timeout in milliseconds. Default: **180000**.

## Configuration file

The image looks for configurations in `/bitnami/redis-sentinel/conf/`. You can mount a volume at `/bitnami` and copy/edit the configurations in the `/path/to/redis-persistence/redis-sentinel/conf/`. The default configurations will be populated to the `conf/` directory if it's empty.

### Step 1: Run the Redis Sentinel image

Run the Redis Sentinel image, mounting a directory from your host.

```bash
$ docker run --name redis-sentinel \
    -e REDIS_MASTER_HOST=redis \
    -v /path/to/redis-sentinel/persistence:/bitnami \
    bitnami/redis-sentinel:latest
```

You can also modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-redis-sentinel/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  redis-sentinel:
  ...
    volumes:
      - /path/to/redis-persistence:/bitnami
  ...
```

### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```bash
$ vi /path/to/redis-persistence/redis-sentinel/conf/redis.conf
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

## 4.0.14-debian-9-r201, 4.0.14-ol-7-r222, 5.0.5-debian-9-r169, 5.0.5-ol-7-r175

- Decrease the size of the container. The configuration logic is now based on Bash scripts in the `rootfs/` folder.

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
Copyright (c) 2020 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
