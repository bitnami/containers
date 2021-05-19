# What is phpMyAdmin?

> phpMyAdmin is a free software tool written in PHP, intended to handle the administration of MySQL over the Web. phpMyAdmin supports a wide range of operations on MySQL and MariaDB. Frequently used operations (managing databases, tables, columns, relations, indexes, users, permissions, etc) can be performed via the user interface, while you still have the ability to directly execute any SQL statement.

https://www.phpmyadmin.net/

# TL;DR

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-phpmyadmin/master/docker-compose.yml > docker-compose.yml
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


> This [CVE scan report](https://quay.io/repository/bitnami/phpmyadmin?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy phpMyAdmin in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami phpMyAdmin Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/phpmyadmin).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`5`, `5-debian-10`, `5.1.0`, `5.1.0-debian-10-r70`, `latest` (5/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-phpmyadmin/blob/5.1.0-debian-10-r70/5/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/phpmyadmin GitHub repo](https://github.com/bitnami/bitnami-docker-phpmyadmin).

# Prerequisites

To run this application you need [Docker Engine](https://www.docker.com/products/docker-engine) >= `1.10.0`. [Docker Compose](https://www.docker.com/products/docker-compose) is recommended with a version `1.6.0` or later.

# How to use this image

phpMyAdmin requires access to a MySQL database or MariaDB database to work. We'll use our very own [MariaDB image](https://www.github.com/bitnami/bitnami-docker-mariadb).

## Using Docker Compose

The main folder of this repository contains a functional [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-phpmyadmin/blob/master/docker-compose.yml) file. Run the application using it as shown below:

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-phpmyadmin/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

## Using the Docker Command Line

If you want to run the application manually instead of using `docker-compose`, these are the basic steps you need to run:

1. Create a network

```console
$ docker network create phpmyadmin-tier
```

2. Create a volume for MariaDB persistence and create a MariaDB container

```console
$ docker volume create --name mariadb_data
$ docker run -d --name mariadb -e ALLOW_EMPTY_PASSWORD=yes \
  --net phpmyadmin-tier \
  --volume mariadb_data:/bitnami/mariadb \
  bitnami/mariadb:latest
```

3. Launch the phpMyAdmin container

```console
$ docker run -d --name phpmyadmin -p 80:8080 -p 443:8443 \
  --net phpmyadmin-tier \
  bitnami/phpmyadmin:latest
```

Access your application at http://your-ip/

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. Additionally you should mount a volume for [persistence of the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#persisting-your-database).

The above examples define a Docker volume named `mariadb_data`. The application state will persist as long as this volume is not removed.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-phpmyadmin/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  mariadb:
  ...
    volumes:
      - /path/to/mariadb-persistence:/bitnami/mariadb
  ...
```

### Mount host directories as data volumes using the Docker command line

1. Create a network (if it does not exist)

```console
$ docker network create phpmyadmin-tier
```

2. Create a MariaDB container with host volume

```console
$ docker run -d --name mariadb -e ALLOW_EMPTY_PASSWORD=yes \
  --net phpmyadmin-tier \
  --volume /path/to/mariadb-persistence:/bitnami/mariadb \
  bitnami/mariadb:latest
```

3. Launch the phpMyAdmin container

```console
$ docker run -d --name phpmyadmin -p 80:8080 -p 443:8443 \
  --net phpmyadmin-tier \
  bitnami/phpmyadmin:latest
```

# Upgrading phpMyAdmin

Bitnami provides up-to-date versions of MariaDB and phpMyAdmin, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the phpMyAdmin container. For the MariaDB upgrade see https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#upgrade-this-image

The `bitnami/phpmyadmin:latest` tag always points to the most recent release. To get the most recent release you can simple repull the `latest` tag from the Docker Hub with `docker pull bitnami/phpmyadmin:latest`. However it is recommended to use [tagged versions](https://hub.docker.com/r/bitnami/phpmyadmin/tags/).

1. Get the updated images:

  ```console
  $ docker pull bitnami/phpmyadmin:latest
  ```

2. Stop your container

 * For docker-compose: `$ docker-compose stop phpmyadmin`
 * For manual execution: `$ docker stop phpmyadmin`

3. Remove the currently running container

 * For docker-compose: `$ docker-compose rm -v phpmyadmin`
 * For manual execution: `$ docker rm -v phpmyadmin`

4. Run the new image

 * For docker-compose: `$ docker-compose up phpmyadmin`
 * For manual execution: `docker run --name phpmyadmin bitnami/phpmyadmin:latest`

# Configuration

## Environment variables

The phpMyAdmin instance can be customized by specifying environment variables on the first run. The following environment values are provided to custom phpMyAdmin:

- `PHPMYADMIN_ALLOW_ARBITRARY_SERVER`: Allows you to enter database server hostname on login form. Default: **false**
- `PHPMYADMIN_ALLOW_REMOTE_CONNECTIONS`: Whether to allow access from any source. When disabled, only connections from 127.0.0.1 will be allowed. Default: **yes**
- `PHPMYADMIN_ABSOLUTE_URI`: If specified, absolute URL to phpMyAdmin when generating links. No defaults
- `DATABASE_ALLOW_NO_PASSWORD`: Whether to allow logins without a password. Default: **yes**
- `DATABASE_HOST`: Database server host. Default: **mariadb**
- `DATABASE_PORT_NUMBER`: Database server port. Default: **3306**
- `DATABASE_ENABLE_SSL`: Whether to enable SSL for the connection between phpMyAdmin and the MySQL server to secure the connection. Default: **no**
- `DATABASE_SSL_KEY`: Path to the client key file when using SSL. Default: **no**
- `DATABASE_SSL_CERT`: Path to the client certificate file when using SSL.
- `DATABASE_SSL_CA`: Path to the CA file when using SSL.
- `DATABASE_SSL_CA_PATH`: Directory containing trusted SSL CA certificates in PEM format.
- `DATABASE_SSL_CIPHERS`: List of allowable ciphers for connections when using SSL.
- `DATABASE_SSL_VERIFY`: Enable SSL certificate validation. Default: **yes**

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

This requires a change to the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-phpmyadmin/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  mariadb:
  ...
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
  ...
  phpmyadmin:
  ...
    environment:
      - DATABASE_ALLOW_NO_PASSWORD=false
      - PHPMYADMIN_ALLOW_ARBITRARY_SERVER=yes
  ...
```

### Specifying Environment variables on the Docker command line

```console
$ docker run -d --name phpmyadmin -p 80:8080 -p 443:8443 \
  --net phpmyadmin-tier \
  --env PHPMYADMIN_PASSWORD=my_password \
  bitnami/phpmyadmin:latest
```

# Customize this image

The Bitnami phpMyAdmin Docker image is designed to be extended so it can be used as the base image for your custom web applications.

## Extend this image

Before extending this image, please note there are certain configuration settings you can modify using the original image:

- Settings that can be adapted using environment variables. For instance, you can change the ports used by Apache for HTTP and HTTPS, by setting the environment variables `APACHE_HTTP_PORT_NUMBER` and `APACHE_HTTPS_PORT_NUMBER` respectively.
- [Adding custom virtual hosts](https://github.com/bitnami/bitnami-docker-apache#adding-custom-virtual-hosts).
- [Replacing the 'httpd.conf' file](https://github.com/bitnami/bitnami-docker-apache#full-configuration).
- [Using custom SSL certificates](https://github.com/bitnami/bitnami-docker-apache#using-custom-ssl-certificates).

If your desired customizations cannot be covered using the methods mentioned above, extend the image. To do so, create your own image using a Dockerfile with the format below:

```Dockerfile
FROM bitnami/phpmyadmin
## Put your customizations below
...
```

Here is an example of extending the image with the following modifications:

- Install the `vim` editor
- Modify the Apache configuration file
- Modify the ports used by Apache
- Modify the default container user

```Dockerfile
FROM bitnami/phpmyadmin
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
  mariadb:
    image: 'bitnami/mariadb:10.3'
    environment:
      - MARIADB_ROOT_PASSWORD=bitnami
    volumes:
      - 'mariadb_data:/bitnami/mariadb'
  phpmyadmin:
    build: .
    ports:
      - '80:8181'
      - '443:8143'
    depends_on:
      - mariadb
    volumes:
      - 'phpmyadmin_data:/bitnami/mariadb'
volumes:
  mariadb_data:
    driver: local
  phpmyadmin_data:
    driver: local
```

# Notable Changes

## 5.0.2-debian-10-r73

- Decrease the size of the container. The configuration logic is now based on Bash scripts in the `rootfs/` folder.
- The `PHPMYADMIN_ALLOW_NO_PASSWORD` environment variable has been deprecated in favor of `DATABASE_ALLOW_NO_PASSWORD`.
- New environment variables have been added to support configuring extra PHP options: `PHP_UPLOAD_MAX_FILESIZE` for `upload_max_filesize`, and `PHP_POST_MAX_SIZE` for `post_max_size`.

## 4.8.5-debian-9-r96 and 4.8.5-ol-7-r111

- This image has been adapted so it's easier to customize. See the [Customize this image](#customize-this-image) section for more information.
- The Apache configuration volume (`/bitnami/apache`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the Apache configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom Apache configuration files are advised to mount a volume for the configuration at `/opt/bitnami/apache/conf`, or mount specific configuration files individually.
- The PHP configuration volume (`/bitnami/php`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the PHP configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom PHP configuration files are advised to mount a volume for the configuration at `/opt/bitnami/php/conf`, or mount specific configuration files individually.
- Enabling custom Apache certificates by placing them at `/opt/bitnami/apache/certs` has been deprecated, and support for this functionality will be dropped in the near future. Users wanting to enable custom certificates are advised to mount their certificate files on top of the preconfigured ones at `/certs`.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-phpmyadmin/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-phpmyadmin/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/phpmyadmin/issues/new). For us to provide better support, be sure to include the following information in your issue:

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
