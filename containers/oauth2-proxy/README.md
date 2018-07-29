[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-oauth2-proxy/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-oauth2-proxy/tree/master)

# What is OAuth2 Proxy ?

A reverse proxy and static file server that provides authentication
using Providers (Google, GitHub, and others) to validate accounts by
email, domain or group.

[https://github.com/bitly/oauth2_proxy]

# TL;DR;

```bash
$ docker run --name oauth2-proxy bitnami/oauth2-proxy:latest
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* Bitnami images are built on CircleCI and automatically pushed to the Docker Hub.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.

# Supported tags and respective `Dockerfile` links

> NOTE: Debian 8 images have been deprecated in favor of Debian 9 images. Bitnami will not longer publish new Docker images based on Debian 8.


* [`2-ol-7`, `2.2.0-ol-7-r34` (2/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-oauth2-proxy/blob/2.2.0-ol-7-r34/2/ol-7/Dockerfile)
* [`2-debian-9`, `2.2.0-debian-9-r21`, `2`, `2.2.0`, `2.2.0-r21`, `latest` (2/Dockerfile)](https://github.com/bitnami/bitnami-docker-oauth2-proxy/blob/2.2.0-debian-9-r21/2/Dockerfile)

Subscribe to project updates by watching the [bitnami/oauth2-proxy GitHub repo](https://github.com/bitnami/bitnami-docker-oauth2-proxy).

# Get this image

The recommended way to get the Bitnami oauth2-proxy Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/oauth2-proxy).

```bash
$ docker pull bitnami/oauth2-proxy:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/oauth2-proxy/tags/) in the Docker Hub Registry.

```bash
$ docker pull bitnami/oauth2-proxy:[TAG]
```

If you wish, you can also build the image yourself.

```bash
$ docker build -t bitnami/oauth2-proxy:latest https://github.com/bitnami/bitnami-docker-oauth2-proxy.git
```

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

### Step 1: Create a network

```bash
$ docker network create oauth2-proxy-network --driver bridge
```

### Step 2: Launch the Blacbox_exporter container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `oauth2-proxy-network` network.

```bash
$ docker run --name oauth2-proxy-node1 --network oauth2-proxy-network bitnami/oauth2-proxy:latest
```

### Step 3: Run another containers

We can launch another containers using the same flag (`--network NETWORK`) in the `docker run` command. If you also set a name to your container, you will be able to use it as hostname in your network.


# Configuration

There is varying support for collectors on each operating system.

Collectors are enabled by providing a --collector.<name> flag. Collectors that are enabled by default can be disabled by providing a --no-collector.<name> flag.
[Further information](https://prometheus.io/docs/introduction/overview/)

# Logging

The Bitnami oauth2-proxy Docker image sends the container logs to the `stdout`. To view the logs:

```bash
$ docker logs oauth2-proxy
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of oauth2-proxy, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
$ docker pull bitnami/oauth2-proxy:latest
```

### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```bash
$ docker stop oauth2-proxy
```

Next, take a snapshot of the persistent volume `/path/to/oauth2-proxy-persistence` using:

```bash
$ rsync -a /path/to/oauth2-proxy-persistence /path/to/oauth2-proxy-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

You can use this snapshot to restore the database state should the upgrade fail.

### Step 3: Remove the currently running container

```bash
$ docker rm -v oauth2-proxy
```

### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if necessary.

```bash
$ docker run --name oauth2-proxy bitnami/oauth2-proxy:latest
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-oauth2-proxy/issues), or submit a [pull
request](https://github.com/bitnami/bitnami-docker-oauth2-proxy/pulls) with your contribution.

# Issues

<!-- If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-oauth2-proxy/issues). For us to provide better support, be sure to include the following information in your issue: -->

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License
Copyright 2018 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
