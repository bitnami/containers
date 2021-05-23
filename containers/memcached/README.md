# What is Memcached?

> Memcached is an in-memory key-value store for small chunks of arbitrary data (strings, objects) from results of database calls, API calls, or page rendering.

[memcached.org](http://memcached.org/)

# TL;DR

```console
$ docker run --name memcached bitnami/memcached:latest
```

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-memcached/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/memcached?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy Memcached in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Memcached Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/memcached).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`1`, `1-debian-10`, `1.6.9`, `1.6.9-debian-10-r165`, `latest` (1/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-memcached/blob/1.6.9-debian-10-r165/1/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/memcached GitHub repo](https://github.com/bitnami/bitnami-docker-memcached).

# Get this image

The recommended way to get the Bitnami Memcached Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com).

```console
$ docker pull bitnami/memcached:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/memcached/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/memcached:[TAG]
```

If you wish, you can also build the image yourself.

```console
docker build -t bitnami/memcached:latest 'https://github.com/bitnami/bitnami-docker-memcached.git#master:1/debian-10'
```

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a Memcached server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

### Step 1: Create a network

```console
$ docker network create app-tier --driver bridge
```

### Step 2: Launch the Memcached server instance

Use the `--network app-tier` argument to the `docker run` command to attach the Memcached container to the `app-tier` network.

```console
$ docker run -d --name memcached-server \
    --network app-tier \
    bitnami/memcached:latest
```

### Step 3: Launch your application container

```console
$ docker run -d --name myapp \
    --network app-tier \
    YOUR_APPLICATION_IMAGE
```

> **IMPORTANT**:
>
> 1. Please update the **YOUR_APPLICATION_IMAGE_** placeholder in the above snippet with your application image
> 2. In your application container, use the hostname `memcached-server` to connect to the Memcached server

## Using Docker Compose

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `app-tier`. In this example we assume that you want to connect to the Memcached server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge

services:
  memcached:
    image: 'bitnami/memcached:latest'
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
> 2. In your application container, use the hostname `memcached` to connect to the Memcached server

Launch the containers using:

```console
$ docker-compose up -d
```

# Configuration

## Specify the cache size

By default, the Bitnami Memcached container will not specify any cache size and will start with Memcached defaults (64MB). You can specify a different value with the `MEMCACHED_CACHE_SIZE` environment variable (in MB).

```console
$ docker run --name memcached -e MEMCACHED_CACHE_SIZE=128 bitnami/memcached:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-memcached/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  memcached:
  ...
    environment:
      - MEMCACHED_CACHE_SIZE=128
  ...
```

## Specify maximum number of concurrent connections

By default, the Bitnami Memcached container will not specify any maximum number of concurrent connections and will start with Memcached defaults (1024 concurrent connections). You can specify a different value with the `MEMCACHED_MAX_CONNECTIONS` environment variable.

```console
$ docker run --name memcached -e MEMCACHED_MAX_CONNECTIONS=2000 bitnami/memcached:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-memcached/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  memcached:
  ...
    environment:
      - MEMCACHED_MAX_CONNECTIONS=2000
  ...
```

## Specify number of threads to process requests

By default, the Bitnami Memcached container will not specify the amount of threads for which to process requests for and will start with Memcached defaults (4 threads). You can specify a different value with the `MEMCACHED_THREADS` environment variable.

```console
$ docker run --name memcached -e MEMCACHED_THREADS=4 bitnami/memcached:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-memcached/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  memcached:
  ...
    environment:
      - MEMCACHED_THREADS=4
  ...
```

## Creating the Memcached admin user

Authentication on the Memcached server is disabled by default. To enable authentication, specify the password for the Memcached admin user using the `MEMCACHED_PASSWORD` environment variable (or in the content of the file specified in `MEMCACHED_PASSWORD_FILE`).

To customize the username of the Memcached admin user, which defaults to `root`, the `MEMCACHED_USERNAME` variable should be specified.

```console
$ docker run --name memcached \
  -e MEMCACHED_USERNAME=my_user \
  -e MEMCACHED_PASSWORD=my_password \
  bitnami/memcached:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-memcached/blob/master/docker-compose.yml) file present in this repository:

```yaml
version: '2'

services:
  memcached:
  ...
    environment:
      - MEMCACHED_USERNAME=my_user
      - MEMCACHED_PASSWORD=my_password
  ...
```

> The default value of the `MEMCACHED_USERNAME` is `root`.

## Passing extra command-line flags to memcached

Passing extra command-line flags to the Memcached service command is possible by adding them as arguments to *run.sh* script:

```console
$ docker run --name memcached bitnami/memcached:latest /opt/bitnami/scripts/memcached/run.sh -vvv
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-memcached/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  memcached:
  ...
    command: /opt/bitnami/scripts/memcached/run.sh -vvv
  ...
```

Refer to the [Memcached man page](https://www.unix.com/man-page/linux/1/memcached/) for the complete list of arguments.

## Using custom SASL configuration

In order to load your own SASL configuration file, you will have to make them available to the container. You can do it doing the following:

- Mounting a volume with your custom configuration
- Adding custom configuration via environment variable.

By default, when authentication is enabled the SASL configuration of Memcached is written to `/opt/bitnami/memcached/sasl2/memcached.conf` file with the following content:

```config
mech_list: plain
sasldb_path: /opt/bitnami/memcached/conf/memcachedsasldb
```

The `/opt/bitnami/memcached/conf/memcachedsasldb` is the path to the sasldb file that contains the list of Memcached users.

# Logging

The Bitnami Memcached Docker image sends the container logs to the `stdout`. To view the logs:

```console
$ docker logs memcached
```

or using Docker Compose:

```console
$ docker-compose logs memcached
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of Memcached, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```console
$ docker pull bitnami/memcached:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/memcached:latest`.

### Step 2: Remove the currently running container

```console
$ docker rm -v memcached
```

or using Docker Compose:

```console
$ docker-compose rm -v memcached
```

### Step 3: Run the new image

Re-create your container from the new image.

```console
$ docker run --name memcached bitnami/memcached:latest
```

or using Docker Compose:

```console
$ docker-compose up memcached
```

# Notable Changes

## 1.5.18-debian-9-r13 and 1.5.19-ol-7-r1

- Fixes regression in Memcached Authentication introduced in release `1.5.18-debian-9-r6` and `1.5.18-ol-7-r7` (#62).

## 1.5.18-debian-9-r6 and 1.5.18-ol-7-r7

- Decrease the size of the container. The configuration logic is now based on Bash scripts in the `rootfs/ folder.
- Custom SASL configuration should be mounted at `/opt/bitnami/memcached/conf/sasl2/` instead of `/bitnami/memcached/conf/`.
- Password for Memcached admin user can be specified in the content of the file specified in `MEMCACHED_PASSWORD_FILE`.

## 1.5.0-r1

- The memcached container has been migrated to a non-root container approach. Previously the container run as `root` user and the memcached daemon was started as `memcached` user. From now own, both the container and the memcached daemon run as user `1001`.
  As a consequence, the configuration files are writable by the user running the memcached process.

## 1.4.25-r4

- `MEMCACHED_USER` parameter has been renamed to `MEMCACHED_USERNAME`.

## 1.4.25-r0

- The logs are always sent to the `stdout` and are no longer collected in the volume.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-memcached/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-memcached/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-memcached/issues/new). For us to provide better support, be sure to include the following information in your issue:

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
