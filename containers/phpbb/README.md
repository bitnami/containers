# What is phpBB?

> If you need to build a community forum, try phpBB. First released in 2000, phpBB is a bulletin board solution that allows you to create forums and subforums. phpBB supports the notion of users and groups, file attachments, full-text search, notifications and more. Hundreds of modifications are available including themes, communications add-ons, spam management and more.

https://www.phpbb.com/

# TL;DR;

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-phpbb/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DTC)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/phpbb?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy phpBB in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami phpBB Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/phpbb).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`3-debian-10`, `3.3.0-debian-10-r103`, `3`, `3.3.0`, `latest` (3/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-phpbb/blob/3.3.0-debian-10-r103/3/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/phpbb GitHub repo](https://github.com/bitnami/bitnami-docker-phpbb).

# Prerequisites

To run this application you need Docker Engine 1.10.0. Docker Compose is recomended with a version 1.6.0 or later.

# How to use this image

## Run phpBB with a Database Container

Running phpBB with a database server is the recommended way. You can either use docker-compose or run the containers manually.

## Run the application using Docker Compose

The main folder of this repository contains a functional [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-phpbb/blob/master/docker-compose.yml) file. Run the application using it as shown below:

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-phpbb/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

### Run the application manually

If you want to run the application manually instead of using docker-compose, these are the basic steps you need to run:

1. Create a new network for the application and the database:

  ```console
  $ docker network create phpbb_network
  ```

2. Create a volume for MariaDB persistence and create a MariaDB container

  ```console
  $ docker volume create --name mariadb_data
  $ docker run -d --name mariadb \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MARIADB_USER=bn_phpbb \
    -e MARIADB_DATABASE=bitnami_phpbb \
    --net phpbb-tier \
    --volume mariadb_data:/bitnami \
    bitnami/mariadb:latest
  ```

  *Note:* You need to give the container a name in order to phpBB to resolve the host

3. Create volumes for phpBB persistence and launch the container

  ```console
  $ docker volume create --name phpbb_data
  $ docker run -d --name phpbb -p 80:80 -p 443:443 \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e PHPBB_DATABASE_USER=bn_phpbb \
    -e PHPBB_DATABASE_NAME=bitnami_phpbb \
    --net phpbb-tier \
    --volume phpbb_data:/bitnami \
    bitnami/phpbb:latest
  ```

Access your application at http://your-ip/

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. Additionally you should mount a volume for [persistence of the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#persisting-your-database).

The above examples define docker volumes namely `mariadb_data` and `phpbb_data`. The phpBB application state will persist as long as these volumes are not removed.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-phpbb/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  mariadb:
  ...
    volumes:
      - '/path/to/your/local/mariadb_data:/bitnami'
  ...
  phpbb:
  ...
    volumes:
      - '/path/to/phpbb-persistence:/bitnami'
  ...
```

### Mount host directories as data volumes using the Docker command line

In this case you need to specify the directories to mount on the run command. The process is the same than the one previously shown:

1. Create a network (if it does not exist):

  ```console
  $ docker network create phpbb-tier
  ```

2. Create a MariaDB container with host volume:

  ```console
  $ docker run -d --name mariadb \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MARIADB_USER=bn_phpbb \
    -e MARIADB_DATABASE=bitnami_phpbb \
    --net phpbb-tier \
    --volume /path/to/mariadb-persistence:/bitnami \
    bitnami/mariadb:latest
  ```

  *Note:* You need to give the container a name in order to phpBB to resolve the host

3. Create the phpBB container with host volumes:

  ```console
  $ docker run -d --name phpbb -p 80:80 -p 443:443 \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e PHPBB_DATABASE_USER=bn_phpbb \
    -e PHPBB_DATABASE_NAME=bitnami_phpbb \
    --net phpbb-tier \
    --volume /path/to/phpbb-persistence:/bitnami \
    bitnami/phpbb:latest
  ```

# Upgrade this application

Bitnami provides up-to-date versions of MariaDB and phpBB, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the phpBB container. For the MariaDB upgrade see https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#upgrade-this-image

1. Get the updated images:

  ```console
  $ docker pull bitnami/phpbb:latest
  ```

2. Stop your container

 * For docker-compose: `$ docker-compose stop phpbb`
 * For manual execution: `$ docker stop phpbb`

3. Take a snapshot of the application state

```console
$ rsync -a /path/to/phpbb-persistence /path/to/phpbb-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

Additionally, [snapshot the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#step-2-stop-and-backup-the-currently-running-container)

You can use these snapshots to restore the application state should the upgrade fail.

4. Remove the currently running container

 * For docker-compose: `$ docker-compose rm -v phpbb`
 * For manual execution: `$ docker rm -v phpbb`

5. Run the new image

 * For docker-compose: `$ docker-compose up phpbb`
 * For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name phpbb bitnami/phpbb:latest`

# Configuration

## Environment variables

When you start the phpbb image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. If you want to add a new environment variable:

 * For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-phpbb/blob/master/docker-compose.yml) file present in this repository: :

  ```yaml
  phpbb:
  ...
    environment:
      - PHPBB_PASSWORD=my_password
  ...
  ```

 * For manual execution add a `-e` option with each variable and value:

  ```console
   $ docker run -d -p 80:80 -p 443:443 --name phpbb \
    -e PHPBB_PASSWORD=my_password \
    --net phpbb-tier \
    --volume /path/to/phpbb-persistence:/bitnami \
    bitnami/phpbb:latest
  ```

Available variables:

##### User and Site configuration

- `PHPBB_USERNAME`: phpBB application username. Default: **user**
- `PHPBB_PASSWORD`: phpBB application password. Default: **bitnami**
- `PHPBB_FIRST_NAME`: First name of the user of the application. Default: **User**
- `PHPBB_LAST_NAME`: Last name of the user of the application. Default: **Name**
- `PHPBB_FORUM_NAME`: Forum Name. Default: **My forum**
- `PHPBB_FORUM_DESCRIPTION`: Forum Description. Default: **A little text to describe your forum**
- `PHPBB_EMAIL`: phpBB application email. Default: **user@example.com**
- `PHPBB_HOST`: phpBB application host. No defaults.

##### Use an existing database

- `MARIADB_HOST`: Hostname for MariaDB server. Default: **mariadb**
- `MARIADB_PORT_NUMBER`: Port used by MariaDB server. Default: **3306**
- `PHPBB_DATABASE_NAME`: Database name that phpBB will use to connect with the database. Default: **bitnami_phpbb**
- `PHPBB_DATABASE_USER`: Database user that phpBB will use to connect with the database. Default: **bn_phpbb**
- `PHPBB_DATABASE_PASSWORD`: Database password that Phpbb will use to connect with the database. No defaults.
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

##### Create a database for phpBB using mysql-client

- `MARIADB_HOST`: Hostname for MariaDB server. Default: **mariadb**
- `MARIADB_PORT_NUMBER`: Port used by MariaDB server. Default: **3306**
- `MARIADB_ROOT_USER`: Database admin user. Default: **root**
- `MARIADB_ROOT_PASSWORD`: Database password for the `MARIADB_ROOT_USER` user. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_NAME`: New database to be created by the mysql client module. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_USER`: New database user to be created by the mysql client module. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_PASSWORD`: Database password for the `MYSQL_CLIENT_CREATE_DATABASE_USER` user. No defaults.
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

##### SMTP Configuration

To configure phpBB to send email using SMTP you can set the following environment variables:

- `SMTP_HOST`: SMTP host.
- `SMTP_PORT`: SMTP port.
- `SMTP_USER`: SMTP account user.
- `SMTP_PASSWORD`: SMTP account password.
- `SMTP_PROTOCOL`: SMTP protocol.

##### PHP configuration

- `PHP_MEMORY_LIMIT`: Memory limit for PHP. Default: **256M**

This would be an example of SMTP configuration using a GMail account:

 * Modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-phpbb/blob/master/docker-compose.yml) file present in this repository:

```yaml
  phpbb:
  ...
    environment:
      - PHPBB_DATABASE_USER=bn_phpbb
      - PHPBB_DATABASE_NAME=bitnami_phpbb
      - SMTP_HOST=smtp.gmail.com
      - SMTP_PORT=587
      - SMTP_USER=your_email@gmail.com
      - SMTP_PASSWORD=your_password
  ...
```

 * For manual execution:

  ```console
  $ docker run -d  -p 80:80 -p 443:443 --name phpbb \
    -e PHPBB_DATABASE_USER=bn_phpbb \
    -e PHPBB_DATABASE_NAME=bitnami_phpbb \
    -e SMTP_HOST=smtp.gmail.com \
    -e SMTP_PORT=587 \
    -e SMTP_USER=your_email@gmail.com \
    -e SMTP_PASSWORD=your_password
    --net phpbb-tier \
    --volume /path/to/phpbb-persistence:/bitnami \
    bitnami/phpbb:latest
  ```

# Customize this image

The Bitnami phpBB Docker image is designed to be extended so it can be used as the base image for your custom web applications.

## Extend this image

Before extending this image, please note there are certain configuration settings you can modify using the original image:

- Settings that can be adapted using environment variables. For instance, you can change the ports used by Apache for HTTP and HTTPS, by setting the environment variables `APACHE_HTTP_PORT_NUMBER` and `APACHE_HTTPS_PORT_NUMBER` respectively.
- [Adding custom virtual hosts](https://github.com/bitnami/bitnami-docker-apache#adding-custom-virtual-hosts).
- [Replacing the 'httpd.conf' file](https://github.com/bitnami/bitnami-docker-apache#full-configuration).
- [Using custom SSL certificates](https://github.com/bitnami/bitnami-docker-apache#using-custom-ssl-certificates).

If your desired customizations cannot be covered using the methods mentioned above, extend the image. To do so, create your own image using a Dockerfile with the format below:

```Dockerfile
FROM bitnami/phpbb
## Put your customizations below
...
```

Here is an example of extending the image with the following modifications:

- Install the `vim` editor
- Modify the Apache configuration file
- Modify the ports used by Apache

```Dockerfile
FROM bitnami/phpbb
LABEL maintainer "Bitnami <containers@bitnami.com>"

## Install 'vim'
RUN install_packages vim

## Enable mod_ratelimit module
RUN sed -i -r 's/#LoadModule ratelimit_module/LoadModule ratelimit_module/' /opt/bitnami/apache/conf/httpd.conf

## Modify the ports used by Apache by default
# It is also possible to change these environment variables at runtime
ENV APACHE_HTTP_PORT_NUMBER=8181
ENV APACHE_HTTPS_PORT_NUMBER=8143
EXPOSE 8181 8143
```

Based on the extended image, you can use a Docker Compose file like the one below to add other features:

```yaml
version: '2'
services:
  mariadb:
    image: 'bitnami/mariadb:10.3'
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - MARIADB_USER=bn_phpbb
      - MARIADB_DATABASE=bitnami_phpbb
    volumes:
      - 'mariadb_data:/bitnami'
  phpbb:
    build: .
    environment:
      - MARIADB_HOST=mariadb
      - MARIADB_PORT_NUMBER=3306
      - PHPBB_DATABASE_USER=bn_phpbb
      - PHPBB_DATABASE_NAME=bitnami_phpbb
      - ALLOW_EMPTY_PASSWORD=yes
    ports:
      - '80:8181'
      - '443:8143'
    volumes:
      - 'phpbb_data:/bitnami'
    depends_on:
      - mariadb
volumes:
  mariadb_data:
    driver: local
  phpbb_data:
    driver: local
```

# Notable Changes

## 3.2.7-debian-9-r19 and 3.2.7-ol-7-r30

- This image has been adapted so it's easier to customize. See the [Customize this image](#customize-this-image) section for more information.
- The Apache configuration volume (`/bitnami/apache`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the Apache configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom Apache configuration files are advised to mount a volume for the configuration at `/opt/bitnami/apache/conf`, or mount specific configuration files individually.
- The PHP configuration volume (`/bitnami/php`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the PHP configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom PHP configuration files are advised to mount a volume for the configuration at `/opt/bitnami/php/conf`, or mount specific configuration files individually.
- Enabling custom Apache certificates by placing them at `/opt/bitnami/apache/certs` has been deprecated, and support for this functionality will be dropped in the near future. Users wanting to enable custom certificates are advised to mount their certificate files on top of the preconfigured ones at `/certs`.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-phpbb/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-phpbb/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-phpbb/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`$ docker version`)
- Output of `$ docker info`
- Version of this container (`$ echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright 2016-2020 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
