# What is Kong?

> Kong is a scalable, open source API layer (aka API gateway or API middleware) that runs in front of any RESTful API. Extra functionalities beyond the core platform are extended through plugins. Kong is built on top of reliable technologies like NGINX and provides an easy-to-use RESTful API to operate and configure the system.

[https://github.com/kong/kong](https://github.com/kong/kong)

# TL;DR

```
$ docker run --name kong bitnami/kong:latest
```

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-kong/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.

> This [CVE scan report](https://quay.io/repository/bitnami/kong?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`2`, `2-debian-10`, `2.4.1`, `2.4.1-debian-10-r9`, `latest` (2/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-kong/blob/2.4.1-debian-10-r9/2/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/kong GitHub repo](https://github.com/bitnami/bitnami-docker-kong).

# Get this image

The recommended way to get the Bitnami Kong Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/kong).

```console
$ docker pull bitnami/kong:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/kong/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/kong:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/kong:latest 'https://github.com/bitnami/bitnami-docker-kong.git#master:2/debian-10'
```

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

### Step 1: Create a network

```console
$ docker network create kong-network --driver bridge
```

### Step 2: Launch the Kong container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `kong-network` network.

```console
$ docker run --name kong-node1 --network kong-network bitnami/kong:latest
```

### Step 3: Run another containers

We can launch another containers using the same flag (`--network NETWORK`) in the `docker run` command. If you also set a name to your container, you will be able to use it as hostname in your network.

# Configuration

The Bitnami Docker Kong can be easily setup with the following environment variables:

- `KONG_PROXY_LISTEN_ADDRESS`: Address to which Kong Proxy service is bound to. Default: **0.0.0.0**
- `KONG_PROXY_HTTP_PORT_NUMBER`: The port Kong Proxy is listening for HTTP requests. Default: **8000**
- `KONG_PROXY_HTTPS_PORT_NUMBER`: The port Kong Proxy is listening for HTTPS requests. Default: **8443**
- `KONG_ADMIN_LISTEN_ADDRESS`: Address to which Kong Admin service is bound to. Default: **127.0.0.1**
- `KONG_ADMIN_HTTP_PORT_NUMBER`: The port Kong Admin is listening for HTTP requests. Default: **8001**
- `KONG_ADMIN_HTTPS_PORT_NUMBER`: The port Kong Admin is listening for HTTPS requests. Default: **8444**
- `KONG_MIGRATE`: Whether to automatically run Kong migration scripts on this node. In a cluster, only one node should have this flag enabled. Default: **no**
- `KONG_EXIT_AFTER_MIGRATE`: Whether to exit after performing the migration (it will not launch the Kong daemon). This is useful using the container in Jobs and Cron Jobs. Default: **no**

This container also supports configuring Kong via environment values starting with `KONG_`. For instance, by setting the `KONG_LOG_LEVEL` environment variable, Kong will take into account this value rather than the property set in `kong.conf`. It is recommended to set the following environment variables:

- `KONG_DATABASE`: Database type used. Valid values: **postgres**, **cassandra** or **off**. Default: **postgres**
- For PostgreSQL database: `KONG_PG_HOST`, `KONG_PG_PORT`, `KONG_PG_TIMEOUT`, `KONG_PG_USER`, `KONG_PG_PASSWORD`.
- For Cassandra database: `KONG_CASSANDRA_CONTACT_POINTS`, `KONG_CASSANDRA_PORT`, `KONG_CASSANDRA_KEYSPACE`, `KONG_CASSANDRA_CONSISTENCY`, `KONG_CASSANDRA_USERNAME`, `KONG_CASSANDRA_PASSWORD`, `KONG_CASSANDRA_LB_POLICY`, `KONG_CASSANDRA_REPL_STRATEGY`, `KONG_CASSANDRA_REPL_FACTOR`, `KONG_CASSANDRA_DATA_CENTERS`.

Check the official [Kong Configuration Reference](https://docs.konghq.com/latest/configuration/#environment-variables) for the full list of configurable properties.

## Full configuration

The image looks for Kong the configuration file in `/opt/bitnami/kong/conf/kong.conf`, which you can overwrite using your own custom configuration file.

```console
$ docker run --name kong \
  -e KONG_DATABASE=off \
  -v /path/to/kong.conf:/opt/bitnami/kong/conf/kong.conf \
  bitnami/kong:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  kong:
    image: 'bitnami/kong:latest'
    ports:
      - '8000:8000'
      - '8443:8443'
    environment:
      # Assume we don't want data persistence for simplicity purposes
      - KONG_DATABASE=off
    volumes:
      - /path/to/kong.conf:/opt/bitnami/kong/conf/kong.conf
```

# Logging

The Bitnami Kong Docker image sends the container logs to `stdout`. To view the logs:

```console
$ docker logs kong
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Understand the structure of this image

The Bitnami Kong Docker image is built using a Dockerfile with the structure below:

```Dockerfile
FROM bitnami/minideb

ENV ...

# Install required system packages and dependencies
RUN install_packages xxx yyy zzz
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack && component_unpack "kong" "aa.bb.cc-dd"

COPY rootfs /
ENV ...

EXPOSE 8080 8443
ENTRYPOINT [ "/opt/bitnami/scripts/kong/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/kong/run.sh" ]
```

The Dockerfile has several sections related to:

- Components installation
- Components static configuration
- Environment variables
- Volumes
- Ports to be exposed
- Working directory and user
  - Note that once the user is set to 1001, unprivileged commands cannot be executed any longer.
- Entrypoint and command
  - Take into account that these actions are not executed until the container is started.

# Customize this image

The Bitnami Kong Docker image is designed to be extended so it can be used as the base image for your custom API service.

> Note: Read the [previous section](#understand-the-structure-of-this-image) to understand the Dockerfile structure before extending this image.

## Extend this image

Before extending this image, please note it is possible there are certain ways you can configure Kong using the original:

- [Configuring Kong via environment variables](#configuration).
- [Changing the 'kong.conf' file](#full-configuration).

If your desired customizations cannot be covered using the methods mentioned above, extend the image. To do so, create your own image using a Dockerfile with the format below:

```Dockerfile
FROM bitnami/kong
## Put your customizations below
...
```

Here is an example of extending the image with the following modifications:

- Install the `vim` editor
- Modify the Kong configuration file
- Modify the ports used by Kong
- Change the user that runs the container

```Dockerfile
FROM bitnami/kong
LABEL maintainer "Bitnami <containers@bitnami.com>"

## Change user to perform privileged actions
USER 0
## Install 'vim'
RUN install_packages vim
## Revert to the original non-root user
USER 1001

## Disable anonymous reports
# Keep in mind it is possible to do this by setting the KONG_ANONYMOUS_REPORTS=off environment variable
RUN sed -i -r 's/#anonymous_reports = on/anonymous_reports = off/' /opt/bitnami/kong/conf/kong.conf

## Modify the ports used by Kong by default
# It is also possible to change these environment variables at runtime
ENV KONG_PROXY_HTTP_PORT_NUMBER=8080
ENV KONG_ADMIN_HTTP_PORT_NUMBER=8081
EXPOSE 8080 8081 8443 8444

## Modify the default container user
USER 1002
```

Based on the extended image, you can use a Docker Compose file like the one below to add other features:

- Configure Kong via environment variables
- Override the entire `kong.conf` configuration file

```yaml
version: '2'
services:
  kong:
    build: .
    ports:
      - '80:8080'
      - '443:8443'
    volumes:
      - ./config/kong.conf:/opt/bitnami/kong/conf/kong.conf
    environment:
      # Assume we don't want data persistence for simplicity purposes
      - KONG_DATABASE=off
volumes:
  data:
    driver: local
```

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of Kong, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```console
$ docker pull bitnami/kong:latest
```

### Step 2: Stop the running container

Stop the currently running container using the command

```console
$ docker stop kong
```

### Step 3: Remove the currently running container

```console
$ docker rm -v kong
```

### Step 4: Run the new image

Re-create your container from the new image.

```console
$ docker run --name kong bitnami/kong:latest
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-kong/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-kong/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-kong/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container
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
