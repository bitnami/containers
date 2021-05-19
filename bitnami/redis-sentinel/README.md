
# What is Redis(TM) Sentinel packaged by Bitnami?

Disclaimer: REDIS(r) is a registered trademark of Redis Labs Ltd.Any rights therein are reserved to Redis Labs Ltd. Any use by Bitnami is for referential
purposes only and does not indicate any sponsorship, endorsement, or affiliation between Redis Labs Ltd.

> Redis(TM) Sentinel provides high availability for Redis. In practical terms this means that using Sentinel you can create a Redis deployment that resists without human intervention to certain kind of failures.
>
> Redis(TM) Sentinel also provides other collateral tasks such as monitoring, notifications and acts as a configuration provider for clients.


[redis.io](http://redis.io/)

# TL;DR

```console
$ docker run --name redis-sentinel -e REDIS_MASTER_HOST=redis bitnami/redis-sentinel:latest
```

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-redis-sentinel/master/docker-compose.yml > docker-compose.yml
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


> This [CVE scan report](https://quay.io/repository/bitnami/redis-sentinel?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`6.2`, `6.2-debian-10`, `6.2.3`, `6.2.3-debian-10-r14`, `latest` (6.2/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-redis-sentinel/blob/6.2.3-debian-10-r14/6.2/debian-10/Dockerfile)
* [`6.0`, `6.0-debian-10`, `6.0.13`, `6.0.13-debian-10-r14` (6.0/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-redis-sentinel/blob/6.0.13-debian-10-r14/6.0/debian-10/Dockerfile)
* [`5.0`, `5.0-debian-10`, `5.0.12`, `5.0.12-debian-10-r65` (5.0/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-redis-sentinel/blob/5.0.12-debian-10-r65/5.0/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/redis-sentinel GitHub repo](https://github.com/bitnami/bitnami-docker-redis-sentinel).

# Get this image

The recommended way to get the Bitnami Redis(TM) Sentinel Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/redis-sentinel).

```console
$ docker pull bitnami/redis-sentinel:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/redis-sentinel/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/redis-sentinel:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/redis-sentinel:latest 'https://github.com/bitnami/bitnami-docker-redis-sentinel.git#master:6.2/debian-10'
```

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a Redis(TM) server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

In this example, we will create a Redis(TM) Sentinel instance that will monitor a Redis(TM) instance that is running on the same docker network.

### Step 1: Create a network

```console
$ docker network create app-tier --driver bridge
```

### Step 2: Launch the Redis(TM) instance

Use the `--network app-tier` argument to the `docker run` command to attach the Redis(TM) container to the `app-tier` network.

```console
$ docker run -d --name redis-server \
    -e ALLOW_EMPTY_PASSWORD=yes \
    --network app-tier \
    bitnami/redis:latest
```

### Step 3: Launch your Redis(TM) Sentinel instance

Finally we create a new container instance to launch the Redis(TM) client and connect to the server created in the previous step:

```console
$ docker run -it --rm \
    -e REDIS_MASTER_HOST=redis-server \
    --network app-tier \
    bitnami/redis-sentinel:latest
```

## Using Docker Compose

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `app-tier`. In this example we assume that you want to connect to the Redis(TM) server from your own custom application image which is identified in the following snippet by the service name `myapp`.

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

```console
$ docker-compose up -d
```

### Using Master-Slave setups

When using Sentinel in Master-Slave setup, if you want to set the passwords for Master and Slave nodes, consider having the **same** `REDIS_PASSWORD` and `REDIS_MASTER_PASSWORD` for them ([#23](https://github.com/bitnami/bitnami-docker-redis-sentinel/issues/23)).

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge

services:
  redis:
    image: 'bitnami/redis:latest'
    environment:
      - REDIS_REPLICATION_MODE=master
      - REDIS_PASSWORD=str0ng_passw0rd
    networks:
      - app-tier
    ports:
      - '6379'
  redis-slave:
    image: 'bitnami/redis:latest'
    environment:
      - REDIS_REPLICATION_MODE=slave
      - REDIS_MASTER_HOST=redis
      - REDIS_MASTER_PASSWORD=str0ng_passw0rd
      - REDIS_PASSWORD=str0ng_passw0rd
    ports:
      - '6379'
    depends_on:
      - redis
    networks:
      - app-tier
  redis-sentinel:
    image: 'bitnami/redis-sentinel:latest'
    environment:
      - REDIS_MASTER_PASSWORD=str0ng_passw0rd
    depends_on:
      - redis
      - redis-slave
    ports:
      - '26379-26381:26379'
    networks:
      - app-tier
```

Launch the containers using:

```console
$ docker-compose up --scale redis-sentinel=3 -d
```

# Configuration

## Environment variables

The Redis(TM) Sentinel instance can be customized by specifying environment variables on the first run. The following environment values are provided to customize Redis(TM) Sentinel:

- `REDIS_MASTER_HOST`: Host of the Redis(TM) master to monitor. Default: **redis**.
- `REDIS_MASTER_PORT_NUMBER`: Port of the Redis(TM) master to monitor. Default: **6379**.
- `REDIS_MASTER_SET`: Name of the set of Redis(TM) instances to monitor. Default: **mymaster**.
- `REDIS_MASTER_PASSWORD`: Password to authenticate with the master. No defaults. As an alternative, you can mount a file with the password and set the `REDIS_MASTER_PASSWORD_FILE` variable.
- `REDIS_MASTER_USER`: Username to authenticate with when ACL is enabled for the master. No defaults. This is available only for Redis(TM) 6 or higher. If not specified, Redis(TM) Sentinel will try to authenticate with just the password (using `sentinel auth-pass <master-name> <password>`).
- `REDIS_SENTINEL_PORT_NUMBER`: Redis(TM) Sentinel port. Default: **26379**.
- `REDIS_SENTINEL_QUORUM`: Number of Sentinels that need to agree about the fact the master is not reachable. Default: **2**.
- `REDIS_SENTINEL_PASSWORD`: Password to authenticate with this sentinel and to authenticate to other sentinels. No defaults. Needs to be identical on all sentinels. As an alternative, you can mount a file with the password and set the `REDIS_SENTINEL_PASSWORD_FILE` variable.
- `REDIS_SENTINEL_DOWN_AFTER_MILLISECONDS`: Number of milliseconds before master is declared down. Default: **60000**.
- `REDIS_SENTINEL_FAILOVER_TIMEOUT`: Specifies the failover timeout in milliseconds. Default: **180000**.
- `REDIS_SENTINEL_RESOLVE_HOSTNAMES`: Enables sentinel hostnames support. This is available only for Redis(TM) 6.2 or higher.  Default: **no**.
- `REDIS_SENTINEL_TLS_ENABLED`: Whether to enable TLS for traffic or not. Default: **no**.
- `REDIS_SENTINEL_TLS_PORT_NUMBER`: Port used for TLS secure traffic. Default: **26379**.
- `REDIS_SENTINEL_TLS_CERT_FILE`: File containing the certificate file for the TSL traffic. No defaults.
- `REDIS_SENTINEL_TLS_KEY_FILE`: File containing the key for certificate. No defaults.
- `REDIS_SENTINEL_TLS_CA_FILE`: File containing the CA of the certificate. No defaults.
- `REDIS_SENTINEL_TLS_DH_PARAMS_FILE`: File containing DH params (in order to support DH based ciphers). No defaults.
- `REDIS_SENTINEL_TLS_AUTH_CLIENTS`: Whether to require clients to authenticate or not. Default: **yes**.
- `REDIS_SENTINEL_ANNOUNCE_IP`: Use the specified IP address in the HELLO messages used to gossip its presence. Default: **auto-detected local address**.
- `REDIS_SENTINEL_ANNOUNCE_PORT`: Use the specified port in the HELLO messages used to gossip its presence. Default: **port specified in `REDIS_SENTINEL_PORT_NUMBER`**.

## Securing Redis(TM) Sentinel traffic

Starting with version 6, Redis(TM) adds the support for SSL/TLS connections. Should you desire to enable this optional feature, you may use the aforementioned `REDIS_SENTINEL_TLS_*` environment variables to configure the application.

When enabling TLS, conventional standard traffic is disabled by default. However this new feature is not mutually exclusive, which means it is possible to listen to both TLS and non-TLS connection simultaneously. To enable non-TLS traffic, set `REDIS_SENTINEL_PORT_NUMBER` to another port different than `0`.

1. Using `docker run`

    ```console
    $ docker run --name redis-sentinel \
        -v /path/to/certs:/opt/bitnami/redis/certs \
        -v /path/to/redis-sentinel/persistence:/bitnami \
        -e REDIS_MASTER_HOST=redis \
        -e REDIS_SENTINEL_TLS_ENABLED=yes \
        -e REDIS_SENTINEL_TLS_CERT_FILE=/opt/bitnami/redis/certs/redis.crt \
        -e REDIS_SENTINEL_TLS_KEY_FILE=/opt/bitnami/redis/certs/redis.key \
        -e REDIS_SENTINEL_TLS_CA_FILE=/opt/bitnami/redis/certs/redisCA.crt \
        bitnami/redis-cluster:latest
        bitnami/redis-sentinel:latest
    ```

2. Modifying the `docker-compose.yml` file present in this repository:

    ```yaml
      redis-sentinel:
      ...
        environment:
          ...
          - REDIS_SENTINEL_TLS_ENABLED=yes
          - REDIS_SENTINEL_TLS_CERT_FILE=/opt/bitnami/redis/certs/redis.crt
          - REDIS_SENTINEL_TLS_KEY_FILE=/opt/bitnami/redis/certs/redis.key
          - REDIS_SENTINEL_TLS_CA_FILE=/opt/bitnami/redis/certs/redisCA.crt
        ...
        volumes:
          - /path/to/certs:/opt/bitnami/redis/certs
        ...
      ...
    ```
Alternatively, you may also provide with this configuration in your [custom](https://github.com/bitnami/bitnami-docker-redis-sentinel#configuration-file) configuration file.

## Configuration file

The image looks for configurations in `/bitnami/redis-sentinel/conf/`. You can mount a volume at `/bitnami` and copy/edit the configurations in the `/path/to/redis-persistence/redis-sentinel/conf/`. The default configurations will be populated to the `conf/` directory if it's empty.

### Step 1: Run the Redis(TM) Sentinel image

Run the Redis(TM) Sentinel image, mounting a directory from your host.

```console
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

```console
$ vi /path/to/redis-persistence/redis-sentinel/conf/redis.conf
```

### Step 3: Restart Redis(TM)

After changing the configuration, restart your Redis(TM) container for changes to take effect.

```console
$ docker restart redis
```

or using Docker Compose:

```console
$ docker-compose restart redis
```

Refer to the [Redis(TM) configuration](http://redis.io/topics/config) manual for the complete list of configuration options.

# Logging

The Bitnami Redis(TM) Sentinel Docker Image sends the container logs to the `stdout`. To view the logs:

```console
$ docker logs redis
```

or using Docker Compose:

```console
$ docker-compose logs redis
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of Redis(TM) Sentinel, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```console
$ docker pull bitnami/redis-sentinel:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/redis-sentinel:latest`.

### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
$ docker stop redis
```

or using Docker Compose:

```console
$ docker-compose stop redis
```

Next, take a snapshot of the persistent volume `/path/to/redis-persistence` using:

```console
$ rsync -a /path/to/redis-persistence /path/to/redis-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

### Step 3: Remove the currently running container

```console
$ docker rm -v redis
```

or using Docker Compose:

```console
$ docker-compose rm -v redis
```

### Step 4: Run the new image

Re-create your container from the new image.

```console
$ docker run --name redis bitnami/redis-sentinel:latest
```

or using Docker Compose:

```console
$ docker-compose up redis
```

# Notable Changes

## 4.0.14-debian-9-r201, 4.0.14-ol-7-r222, 5.0.5-debian-9-r169, 5.0.5-ol-7-r175

- Decrease the size of the container. The configuration logic is now based on Bash scripts in the `rootfs/` folder.

## 4.0.10-r25

- The Redis(TM) sentinel container has been migrated to a non-root container approach. Previously the container run as `root` user and the redis daemon was started as `redis` user. From now own, both the container and the redis daemon run as user `1001`. As a consequence, the configuration files are writable by the user running the redis process. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-redis-sentinel/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-redis-sentinel/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-redis-sentinel/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License
Copyright (c) 2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
