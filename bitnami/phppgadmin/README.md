# What is phpPgAdmin?

> phpPgAdmin is a web-based administration tool for PostgreSQL. It is perfect for PostgreSQL DBAs, newbies, and hosting services.

https://github.com/phppgadmin/phppgadmin

# TL;DR

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-phppgadmin/master/docker-compose.yml > docker-compose.yml
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

> This [CVE scan report](https://quay.io/repository/bitnami/phppgadmin?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`7`, `7-debian-10`, `7.13.0`, `7.13.0-debian-10-r182`, `latest` (7/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-phppgadmin/blob/7.13.0-debian-10-r182/7/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/phppgadmin GitHub repo](https://github.com/bitnami/bitnami-docker-phppgadmin).

# Prerequisites

To run this application you need [Docker Engine](https://www.docker.com/products/docker-engine) >= `1.10.0`. [Docker Compose](https://www.docker.com/products/docker-compose) is recommended with a version `1.6.0` or later.

# How to use this image

phpPgAdmin requires access to a PostgreSQL database to work. We'll use our very own [PostgreSQL image](https://www.github.com/bitnami/bitnami-docker-postgresql).

## Using Docker Compose

The main folder of this repository contains a functional [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-phppgadmin/blob/master/docker-compose.yml) file. Run the application using it as shown below:

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-phppgadmin/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

## Using the Docker Command Line

If you want to run the application manually instead of using `docker-compose`, these are the basic steps you need to run:

1. Create a network

```console
$ docker network create phppgadmin-tier
```

2. Create a volume for PostgreSQL persistence and create a PostgreSQL container

```console
$ docker volume create --name postgresql_data
$ docker run -d --name postgresql -e ALLOW_EMPTY_PASSWORD=yes \
  --net phppgadmin-tier \
  --volume postgresql_data:/bitnami \
  bitnami/postgresql:latest
```

3. Launch the phpPgAdmin container

```console
$ docker run -d --name phppgadmin -p 80:8080 -p 443:8443 \
  --net phppgadmin-tier \
  bitnami/phppgadmin:latest
```

Access your application at http://your-ip/

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. Additionally you should mount a volume for [persistence of the PostgreSQL data](https://github.com/bitnami/bitnami-docker-postgresql#persisting-your-database).

The above examples define a Docker volumes named `postgresql_data`. The application state will persist as long as this volume is not removed.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-phppgadmin/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  postgresql:
  ...
    volumes:
      - /path/to/postgresql-persistence:/bitnami
  ...
```

### Mount host directories as data volumes using the Docker command line

1. Create a network (if it does not exist)

```console
$ docker network create phppgadmin-tier
```

2. Create a PostgreSQL container with host volume

```console
$ docker run -d --name postgresql -e ALLOW_EMPTY_PASSWORD=yes \
  --net phppgadmin-tier \
  --volume /path/to/postgresql-persistence:/bitnami \
  bitnami/postgresql:latest
```

3. Launch the phpPgAdmin container

```console
$ docker run -d --name phppgadmin -p 80:8080 -p 443:8443 \
  --net phppgadmin-tier \
  bitnami/phppgadmin:latest
```

# Upgrading phpPgAdmin

Bitnami provides up-to-date versions of PostgreSQL and phpPgAdmin, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the phpPgAdmin container. For the PostgreSQL upgrade see https://github.com/bitnami/bitnami-docker-postgresql/blob/master/README.md#upgrade-this-image

The `bitnami/phppgadmin:latest` tag always points to the most recent release. To get the most recent release you can simple repull the `latest` tag from the Docker Hub with `docker pull bitnami/phppgadmin:latest`. However it is recommended to use [tagged versions](https://hub.docker.com/r/bitnami/phppgadmin/tags/).

1. Get the updated images:

  ```console
  $ docker pull bitnami/phppgadmin:latest
  ```

2. Stop your container

 * For docker-compose: `$ docker-compose stop phppgadmin`
 * For manual execution: `$ docker stop phppgadmin`

3. Remove the currently running container

 * For docker-compose: `$ docker-compose rm -v phppgadmin`
 * For manual execution: `$ docker rm -v phppgadmin`

4. Run the new image

 * For docker-compose: `$ docker-compose up phppgadmin`
 * For manual execution: `docker run --name phppgadmin bitnami/phppgadmin:latest`

# Configuration

## Environment variables

The phpPgAdmin instance can be customized by specifying environment variables on the first run. The following environment values are provided to custom phpPgAdmin:

- `DATABASE_ENABLE_EXTRA_LOGIN_SECURITY`: Whether to enable extra login security. When enabled, logins with no password or certain usernames (postgres, root, pgsql, administrator) will be denied. Default: **no**
- `DATABASE_HOST`: Database server host. Default: **postgresql**.
- `DATABASE_PORT_NUMBER`: Database server port. Default: **5432**
- `DATABASE_SSL_MODE`: Database SSL mode. Supported options are: disable, allow, prefer, require. No default.

### PHP configuration

- `PHP_ENABLE_OPCACHE`: Enable OPcache for PHP scripts. No default.
- `PHP_EXPOSE_PHP`: Enables HTTP header with PHP version. No default.
- `PHP_MAX_EXECUTION_TIME`: Maximum execution time for PHP scripts. No default.
- `PHP_MAX_INPUT_TIME`: Maximum input time for PHP scripts. No default.
- `PHP_MAX_INPUT_VARS`: Maximum amount of input variables for PHP scripts. No default.
- `PHP_MEMORY_LIMIT`: Memory limit for PHP scripts. Default: **256M**
- `PHP_POST_MAX_SIZE`: Maximum size for PHP POST requests. Default: **80M**
- `PHP_UPLOAD_MAX_FILESIZE`: Maximum file size for PHP upload. Default: **80M**

### Specifying Environment variables using Docker Compose

This requires a change to the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-phppgadmin/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  postgresql:
  ...
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
  ...
  phppgadmin:
  ...
    environment:
      - PHPPGADMIN_ENABLE_EXTRA_LOGIN_SECURITY=yes
  ...
```

### Specifying Environment variables on the Docker command line

```console
$ docker run -d --name phppgadmin -p 80:8080 -p 443:8443 \
  --net phppgadmin-tier \
  --env DATABASE_ENABLE_EXTRA_LOGIN_SECURITY=yes \
  --volume phppgadmin_data:/bitnami \
  bitnami/phppgadmin:latest
```

# Customize this image

The Bitnami phpPgAdmin Docker image is designed to be extended so it can be used as the base image for your custom web applications.

## Extend this image

Before extending this image, please note there are certain configuration settings you can modify using the original image:

- Settings that can be adapted using environment variables. For instance, you can change the ports used by Apache for HTTP and HTTPS, by setting the environment variables `APACHE_HTTP_PORT_NUMBER` and `APACHE_HTTPS_PORT_NUMBER` respectively.
- [Adding custom virtual hosts](https://github.com/bitnami/bitnami-docker-apache#adding-custom-virtual-hosts).
- [Replacing the 'httpd.conf' file](https://github.com/bitnami/bitnami-docker-apache#full-configuration).
- [Using custom SSL certificates](https://github.com/bitnami/bitnami-docker-apache#using-custom-ssl-certificates).

If your desired customizations cannot be covered using the methods mentioned above, extend the image. To do so, create your own image using a Dockerfile with the format below:

```Dockerfile
FROM bitnami/phppgadmin
## Put your customizations below
...
```

Here is an example of extending the image with the following modifications:

- Install the `vim` editor
- Modify the Apache configuration file
- Modify the ports used by Apache
- Modify the user running the container

```Dockerfile
FROM bitnami/phppgadmin
LABEL maintainer "Bitnami <containers@bitnami.com>"

## Change user to perform privileged actions
USER 0
## Install 'vim'
RUN install_packages vim
## Revert to the original non-root user
USER 1001

## Enable mod_ratelimit module
RUN sed -i -r 's/#LoadModule ratelimit_module/LoadModule ratelimit_module/' /opt/bitnami/apache/conf/httpd.conf

## Modify the ports used by Apache by default
# It is also possible to change these environment variables at runtime
ENV APACHE_HTTP_PORT_NUMBER=8181
ENV APACHE_HTTPS_PORT_NUMBER=8143
EXPOSE 8181 8143

## Modify the default container user
USER 1002
```

Based on the extended image, you can use a Docker Compose file like the one below to add other features:

```yaml
version: '2'
services:
  postgresql:
    image: 'bitnami/postgresql:11'
    environment:
      - POSTGRESQL_PASSWORD=bitnami
    volumes:
      - 'postgresql_data:/bitnami'
  phppgadmin:
    build: .
    ports:
      - '80:8181'
      - '443:8143'
    depends_on:
      - postgresql
volumes:
  postgresql_data:
    driver: local
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-phppgadmin/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-phppgadmin/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/phppgadmin/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright 2016-2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
