# What is Redis(TM) packaged by Bitnami?

Disclaimer: REDIS(r) is a registered trademark of Redis Labs Ltd.Any rights therein are reserved to Redis Labs Ltd. Any use by Bitnami is for referential
purposes only and does not indicate any sponsorship, endorsement, or affiliation between Redis Labs Ltd.

> Redis(TM) is an advanced key-value cache and store. It is often referred to as a data structure server since keys can contain strings, hashes, lists, sets, sorted sets, bitmaps and hyperloglogs.

[redis.io](http://redis.io/)

# TL;DR

```console
$ docker run --name redis -e ALLOW_EMPTY_PASSWORD=yes bitnami/redis:latest
```

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-redis/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.

> This [CVE scan report](https://quay.io/repository/bitnami/redis?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy Redis(TM) in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Redis(TM) Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/redis).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`6.2`, `6.2-debian-10`, `6.2.3`, `6.2.3-debian-10-r15`, `latest` (6.2/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-redis/blob/6.2.3-debian-10-r15/6.2/debian-10/Dockerfile)
* [`6.0`, `6.0-debian-10`, `6.0.13`, `6.0.13-debian-10-r15` (6.0/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-redis/blob/6.0.13-debian-10-r15/6.0/debian-10/Dockerfile)
* [`5.0`, `5.0-debian-10`, `5.0.12`, `5.0.12-debian-10-r73` (5.0/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-redis/blob/5.0.12-debian-10-r73/5.0/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/redis GitHub repo](https://github.com/bitnami/bitnami-docker-redis).

# Get this image

The recommended way to get the Bitnami Redis(TM) Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/redis).

```console
$ docker pull bitnami/redis:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/redis/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/redis:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/redis:latest 'https://github.com/bitnami/bitnami-docker-redis.git#master:6.2/debian-10'
```

# Persisting your database

Redis(TM) provides a different range of [persistence options](https://redis.io/topics/persistence). This contanier uses *AOF persistence by default* but it is easy to overwrite that configuration in a `docker-compose.yaml` file with this entry `command: /opt/bitnami/scripts/redis/run.sh --appendonly no`. Alternatively, you may use the `REDIS_AOF_ENABLED` env variable as explained in [Disabling AOF persistence](https://github.com/bitnami/bitnami-docker-redis#disabling-aof-persistence).

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami` path. If the mounted directory is empty, it will be initialized on the first run.

```console
$ docker run \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -v /path/to/redis-persistence:/bitnami/redis/data \
    bitnami/redis:latest
```

You can also do this by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-redis/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  redis:
  ...
    volumes:
      - /path/to/redis-persistence:/bitnami/redis/data
  ...
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a Redis(TM) server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

In this example, we will create a Redis(TM) client instance that will connect to the server instance that is running on the same docker network as the client.

### Step 1: Create a network

```console
$ docker network create app-tier --driver bridge
```

### Step 2: Launch the Redis(TM) server instance

Use the `--network app-tier` argument to the `docker run` command to attach the Redis(TM) container to the `app-tier` network.

```console
$ docker run -d --name redis-server \
    -e ALLOW_EMPTY_PASSWORD=yes \
    --network app-tier \
    bitnami/redis:latest
```

### Step 3: Launch your Redis(TM) client instance

Finally we create a new container instance to launch the Redis(TM) client and connect to the server created in the previous step:

```console
$ docker run -it --rm \
    --network app-tier \
    bitnami/redis:latest redis-cli -h redis-server
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
  myapp:
    image: 'YOUR_APPLICATION_IMAGE'
    networks:
      - app-tier
```

> **IMPORTANT**:
>
> 1. Please update the **YOUR_APPLICATION_IMAGE_** placeholder in the above snippet with your application image
> 2. In your application container, use the hostname `redis` to connect to the Redis(TM) server

Launch the containers using:

```console
$ docker-compose up -d
```

# Configuration

## Disabling Redis(TM) commands

For security reasons, you may want to disable some commands. You can specify them by using the following environment variable on the first run:

- `REDIS_DISABLE_COMMANDS`: Comma-separated list of Redis(TM) commands to disable. Defaults to empty.

```console
$ docker run --name redis -e REDIS_DISABLE_COMMANDS=FLUSHDB,FLUSHALL,CONFIG bitnami/redis:latest
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-redis/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  redis:
  ...
    environment:
      - REDIS_DISABLE_COMMANDS=FLUSHDB,FLUSHALL,CONFIG
  ...
```

As specified in the docker-compose, `FLUSHDB` and `FLUSHALL` commands are disabled. Comment out or remove the
environment variable if you don't want to disable any commands:

```yaml
services:
  redis:
  ...
    environment:
      # - REDIS_DISABLE_COMMANDS=FLUSHDB,FLUSHALL
  ...
```

## Passing extra command-line flags to redis-server startup

Passing extra command-line flags to the redis service command is possible by adding them as arguments to *run.sh* script:

```console
$ docker run --name redis -e ALLOW_EMPTY_PASSWORD=yes bitnami/redis:latest /opt/bitnami/scripts/redis/run.sh --maxmemory 100mb
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-redis/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  redis:
  ...
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    command: /opt/bitnami/scripts/redis/run.sh --maxmemory 100mb
  ...
```

Refer to the [Redis(TM) documentation](https://redis.io/topics/config#passing-arguments-via-the-command-line) for the complete list of arguments.

## Setting the server password on first run

Passing the `REDIS_PASSWORD` environment variable when running the image for the first time will set the Redis(TM) server password to the value of `REDIS_PASSWORD` (or the content of the file specified in `REDIS_PASSWORD_FILE`).

```console
$ docker run --name redis -e REDIS_PASSWORD=password123 bitnami/redis:latest
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-redis/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  redis:
  ...
    environment:
      - REDIS_PASSWORD=password123
  ...
```

**NOTE**: The at sign (`@`) is not supported for `REDIS_PASSWORD`.

**Warning** The Redis(TM) database is always configured with remote access enabled. It's suggested that the `REDIS_PASSWORD` env variable is always specified to set a password. In case you want to access the database without a password set the environment variable `ALLOW_EMPTY_PASSWORD=yes`. **This is recommended only for development**.

## Allowing empty passwords

By default the Redis(TM) image expects all the available passwords to be set. In order to allow empty passwords, it is necessary to set the `ALLOW_EMPTY_PASSWORD=yes` env variable. This env variable is only recommended for testing or development purposes. We strongly recommend specifying the `REDIS_PASSWORD` for any other scenario.

```console
$ docker run --name redis -e ALLOW_EMPTY_PASSWORD=yes bitnami/redis:latest
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-redis/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  redis:
  ...
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
  ...
```

## Disabling AOF persistence

Redis(TM) offers different [options](https://redis.io/topics/persistence) when it comes to persistence. By default, this image is set up to use the AOF (Append Only File) approach. Should you need to change this behaviour, setting the `REDIS_AOF_ENABLED=no` env variable will disable this feature.

```console
$ docker run --name redis -e REDIS_AOF_ENABLED=no bitnami/redis:latest
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-redis/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  redis:
  ...
    environment:
      - REDIS_AOF_ENABLED=no
  ...
```

## Setting up replication

A [replication](http://redis.io/topics/replication) cluster can easily be setup with the Bitnami Redis(TM) Docker Image using the following environment variables:

 - `REDIS_REPLICATION_MODE`: The replication mode. Possible values `master`/`slave`. No defaults.
 - `REDIS_REPLICA_IP`: The replication announce ip. Defaults to `$(get_machine_ip)` which return the ip of the container.
 - `REDIS_REPLICA_PORT`: The replication announce port. Defaults to `REDIS_MASTER_PORT_NUMBER`.
 - `REDIS_MASTER_HOST`: Hostname/IP of replication master (replica node parameter). No defaults.
 - `REDIS_MASTER_PORT_NUMBER`: Server port of the replication master (replica node parameter). Defaults to `6379`.
 - `REDIS_MASTER_PASSWORD`: Password to authenticate with the master (replica node parameter). No defaults. As an alternative, you can mount a file with the password and set the `REDIS_MASTER_PASSWORD_FILE` variable.

In a replication cluster you can have one master and zero or more replicas. When replication is enabled the master node is in read-write mode, while the replicas are in read-only mode. For best performance its advisable to limit the reads to the replicas.

### Step 1: Create the replication master

The first step is to start the Redis(TM) master.

```console
$ docker run --name redis-master \
  -e REDIS_REPLICATION_MODE=master \
  -e REDIS_PASSWORD=masterpassword123 \
  bitnami/redis:latest
```

In the above command the container is configured as the `master` using the `REDIS_REPLICATION_MODE` parameter. The `REDIS_PASSWORD` parameter enables authentication on the Redis(TM) master.

### Step 2: Create the replica node

Next we start a Redis(TM) replica container.

```console
$ docker run --name redis-replica \
  --link redis-master:master \
  -e REDIS_REPLICATION_MODE=slave \
  -e REDIS_MASTER_HOST=master \
  -e REDIS_MASTER_PORT_NUMBER=6379 \
  -e REDIS_MASTER_PASSWORD=masterpassword123 \
  -e REDIS_PASSWORD=password123 \
  bitnami/redis:latest
```

In the above command the container is configured as a `slave` using the `REDIS_REPLICATION_MODE` parameter. The `REDIS_MASTER_HOST`, `REDIS_MASTER_PORT_NUMBER` and `REDIS_MASTER_PASSWORD ` parameters are used connect and authenticate with the Redis(TM) master. The `REDIS_PASSWORD` parameter enables authentication on the Redis(TM) replica.

You now have a two node Redis(TM) master/replica replication cluster up and running which can be scaled by adding/removing replicas.

If the Redis(TM) master goes down you can reconfigure a replica to become a master using:

```console
$ docker exec redis-replica redis-cli -a password123 SLAVEOF NO ONE
```

> **Note**: The configuration of the other replicas in the cluster needs to be updated so that they are aware of the new master. In our example, this would involve restarting the other replicas with `--link redis-replica:master`.

With Docker Compose the master/replica mode can be setup using:

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

  redis-replica:
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
      - REDIS_PASSWORD=my_replica_password
```

Scale the number of replicas using:

```console
$ docker-compose up --detach --scale redis-master=1 --scale redis-secondary=3
```

The above command scales up the number of replicas to `3`. You can scale down in the same way.

> **Note**: You should not scale up/down the number of master nodes. Always have only one master node running.

## Securing Redis(TM) traffic

Starting with version 6, Redis(TM) adds the support for SSL/TLS connections. Should you desire to enable this optional feature, you may use the following environment variables to configure the application:

 - `REDIS_TLS_ENABLED`: Whether to enable TLS for traffic or not. Defaults to `no`.
 - `REDIS_TLS_PORT`: Port used for TLS secure traffic. Defaults to `6379`.
 - `REDIS_TLS_CERT_FILE`: File containing the certificate file for the TSL traffic. No defaults.
 - `REDIS_TLS_KEY_FILE`: File containing the key for certificate. No defaults.
 - `REDIS_TLS_CA_FILE`: File containing the CA of the certificate. No defaults.
 - `REDIS_TLS_DH_PARAMS_FILE`: File containing DH params (in order to support DH based ciphers). No defaults.
 - `REDIS_TLS_AUTH_CLIENTS`: Whether to require clients to authenticate or not. Defaults to `yes`.

When enabling TLS, conventional standard traffic is disabled by default. However this new feature is not mutually exclusive, which means it is possible to listen to both TLS and non-TLS connection simultaneously. To enable non-TLS traffic, set `REDIS_TLS_PORT` to another port different than `0`.

1. Using `docker run`

    ```console
    $ docker run --name redis \
        -v /path/to/certs:/opt/bitnami/redis/certs \
        -v /path/to/redis-data-persistence:/bitnami/redis/data \
        -e ALLOW_EMPTY_PASSWORD=yes \
        -e REDIS_TLS_ENABLED=yes \
        -e REDIS_TLS_CERT_FILE=/opt/bitnami/redis/certs/redis.crt \
        -e REDIS_TLS_KEY_FILE=/opt/bitnami/redis/certs/redis.key \
        -e REDIS_TLS_CA_FILE=/opt/bitnami/redis/certs/redisCA.crt \
        bitnami/redis:latest
    ```

2. Modifying the `docker-compose.yml` file present in this repository:

    ```yaml
    services:
      redis:
      ...
        environment:
          ...
          - REDIS_TLS_ENABLED=yes
          - REDIS_TLS_CERT_FILE=/opt/bitnami/redis/certs/redis.crt
          - REDIS_TLS_KEY_FILE=/opt/bitnami/redis/certs/redis.key
          - REDIS_TLS_CA_FILE=/opt/bitnami/redis/certs/redisCA.crt
        ...
        volumes:
          - /path/to/certs:/opt/bitnami/redis/certs
          - /path/to/redis-persistence:/bitnami/redis/data
      ...
    ```

Alternatively, you may also provide with this configuration in your [custom](https://github.com/bitnami/bitnami-docker-redis#configuration-file) configuration file.

## Configuration file

The image looks for configurations in `/opt/bitnami/redis/mounted-etc/redis.conf`. You can overwrite the `redis.conf` file using your own custom configuration file.

```console
$ docker run --name redis \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -v /path/to/your_redis.conf:/opt/bitnami/redis/mounted-etc/redis.conf \
    -v /path/to/redis-data-persistence:/bitnami/redis/data \
    bitnami/redis:latest
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-redis/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  redis:
  ...
    volumes:
      - /path/to/your_redis.conf:/opt/bitnami/redis/mounted-etc/redis.conf
      - /path/to/redis-persistence:/bitnami/redis/data
  ...
```

Refer to the [Redis(TM) configuration](http://redis.io/topics/config) manual for the complete list of configuration options.

# Logging

The Bitnami Redis(TM) Docker image sends the container logs to the `stdout`. To view the logs:

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

Bitnami provides up-to-date versions of Redis(TM), including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```console
$ docker pull bitnami/redis:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/redis:latest`.

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
$ docker run --name redis bitnami/redis:latest
```

or using Docker Compose:

```console
$ docker-compose up redis
```

# Notable Changes

## 5.0.8-debian-10-r24

- The recommended mount point to use a custom `redis.conf` changes from `/opt/bitnami/redis/etc/ ` to `/opt/bitnami/redis/mounted-etc/`.

## 5.0.0-r0

- Starting with Redis(TM) 5.0 the command [REPLICAOF](https://redis.io/commands/replicaof) is available in favor of `SLAVEOF`. For backward compatibility with previous versions, `slave` replication mode is still supported. We encourage the use of the `REPLICAOF` command if you are using Redis(TM) 5.0.

## 4.0.1-r24

- Decrease the size of the container. It is not necessary Node.js anymore. Redis(TM) configuration moved to bash scripts in the `rootfs/` folder.
- The recommended mount point to persist data changes to `/bitnami/redis/data`.
- The main `redis.conf` file is not persisted in a volume. The path is `/opt/bitnami/redis/mounted-etc/redis.conf`.
- Backwards compatibility is not guaranteed when data is persisted using docker-compose. You can use the workaround below to overcome it:

```bash
docker-compose down
# Locate your volume and modify the file tree
VOLUME=$(docker volume ls | grep "redis_data" | awk '{print $2}')
docker run --rm -i -v=${VOLUME}:/tmp/redis busybox find /tmp/redis/data -maxdepth 1 -exec mv {} /tmp/redis \;
docker run --rm -i -v=${VOLUME}:/tmp/redis busybox rm -rf /tmp/redis/{data,conf,.initialized}
# Change the mount point
sed -i -e 's#redis_data:/bitnami/redis#redis_data:/bitnami/redis/data#g' docker-compose.yml
# Pull the latest bitnami/redis image
docker pull bitnami/redis:latest
docker-compose up -d
```

## 4.0.1-r1

- The redis container has been migrated to a non-root container approach. Previously the container run as `root` user and the redis daemon was started as `redis` user. From now own, both the container and the redis daemon run as user `1001`.
  As a consequence, the configuration files are writable by the user running the redis process.

## 3.2.0-r0

- All volumes have been merged at `/bitnami/redis`. Now you only need to mount a single volume at `/bitnami/redis` for persistence.
- The logs are always sent to the `stdout` and are no longer collected in the volume.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-redis/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-redis/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-redis/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License
Copyright (c) 2015-2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
