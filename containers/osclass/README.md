# What is Osclass?

> Osclass is a php script that allows you to quickly create and manage your own free classifieds site. Using this script, you can provide free advertising for items for sale, real estate, jobs, cars... Hundreds of free classified advertising sites are using Osclass. Visit our demo and post a free ad to see Osclass in action.

https://osclass.org/

# TL;DR

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-osclass/master/docker-compose.yml > docker-compose.yml
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


> This [CVE scan report](https://quay.io/repository/bitnami/osclass?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy Osclass in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Osclass Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/osclass).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`4`, `4-debian-10`, `4.4.0`, `4.4.0-debian-10-r15`, `latest` (4/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-osclass/blob/4.4.0-debian-10-r15/4/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/osclass GitHub repo](https://github.com/bitnami/bitnami-docker-osclass).

# Prerequisites

To run this application you need [Docker Engine](https://www.docker.com/products/docker-engine) >= `1.10.0`. [Docker Compose](https://www.docker.com/products/docker-compose) is recommended with a version `1.6.0` or later.

# How to use this image

Osclass requires access to a MySQL database or MariaDB database to store information. We'll use our very own [MariaDB image](https://www.github.com/bitnami/bitnami-docker-mariadb) for the database requirements.

## Using Docker Compose

The recommended way to run Osclass is using Docker Compose using the following `docker-compose.yml` template:

```yaml
version: '2'

services:
  mariadb:
    image: 'bitnami/mariadb:latest'
    environment:
      - MARIADB_USER=bn_osclass
      - MARIADB_DATABASE=bitnami_osclass
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - mariadb_data:/bitnami
  osclass:
    image: bitnami/osclass:latest
    environment:
      - MARIADB_HOST=mariadb
      - MARIADB_PORT_NUMBER=3306
      - OSCLASS_DATABASE_USER=bn_osclass
      - OSCLASS_DATABASE_NAME=bitnami_osclass
      - ALLOW_EMPTY_PASSWORD=yes
    depends_on:
      - mariadb
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - osclass_data:/bitnami
volumes:
  mariadb_data:
    driver: local
  osclass_data:
    driver: local
```

Launch the containers using:

```console
$ docker-compose up -d
```

## Using the Docker Command Line

If you want to run the application manually instead of using `docker-compose`, these are the basic steps you need to run:

1. Create a network

  ```console
  $ docker network create osclass-tier
  ```

2. Create a volume for MariaDB persistence and create a MariaDB container

  ```console
  $ docker volume create --name mariadb_data
  $ docker run -d --name mariadb \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MARIADB_USER=bn_osclass \
    -e MARIADB_DATABASE=bitnami_osclass \
    --net osclass-tier \
    --volume mariadb_data:/bitnami \
    bitnami/mariadb:latest
  ```

3. Create volumes for Osclass persistence and launch the container

  ```console
  $ docker volume create --name osclass_data
  $ docker run -d --name osclass -p 80:80 -p 443:443 \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e OSCLASS_DATABASE_USER=bn_osclass \
    -e OSCLASS_DATABASE_NAME=bitnami_osclass \
    --net osclass-tier \
    --volume osclass_data:/bitnami \
    bitnami/osclass:latest
  ```

Access your application at [http://your-ip/](http://your-ip/)

> **NOTE**:
>
> To login to your Osclass Administration panel, go to [http://your-ip/oc-admin/](http://your-ip/oc-admin/).

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. Additionally you should mount a volume for [persistence of the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#persisting-your-database).

The above examples define docker volumes namely `mariadb_data` and `osclass_data`. The Osclass application state will persist as long as these volumes are not removed.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

The following `docker-compose.yml` template demonstrates the use of host directories as data volumes.

```yaml
version: '2'

services:
  mariadb:
    image: 'bitnami/mariadb:latest'
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - MARIADB_USER=bn_osclass
      - MARIADB_DATABASE=bitnami_osclass
    volumes:
      - /path/to/mariadb-persistence:/bitnami
  osclass:
    image: bitnami/osclass:latest
    environment:
      - OSCLASS_DATABASE_USER=bn_osclass
      - OSCLASS_DATABASE_NAME=bitnami_osclass
      - ALLOW_EMPTY_PASSWORD=yes
    depends_on:
      - mariadb
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - /path/to/osclass-persistence:/bitnami
```

### Mount host directories as data volumes using the Docker command line

1. Create a network (if it does not exist)

  ```console
  $ docker network create osclass-tier
  ```

2. Create a MariaDB container with host volume

  ```console
  $ docker run -d --name mariadb \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MARIADB_USER=bn_osclass \
    -e MARIADB_DATABASE=bitnami_osclass \
    --net osclass-tier \
    --volume /path/to/mariadb-persistence:/bitnami \
    bitnami/mariadb:latest
  ```

3. Create the Osclass container with host volumes

  ```console
  $ docker run -d --name osclass -p 80:80 -p 443:443 \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e OSCLASS_DATABASE_USER=bn_osclass \
    -e OSCLASS_DATABASE_NAME=bitnami_osclass \
    --net osclass-tier \
    --volume /path/to/osclass-persistence:/bitnami \
    bitnami/osclass:latest
  ```

# Upgrading Osclass

Bitnami provides up-to-date versions of MariaDB and Osclass, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the Osclass container. For the MariaDB upgrade see https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#upgrade-this-image

1. Get the updated images:

  ```console
  $ docker pull bitnami/osclass:latest
  ```

2. Stop your container

 * For docker-compose: `$ docker-compose stop osclass`
 * For manual execution: `$ docker stop osclass`

3. Take a snapshot of the application state

```console
$ rsync -a /path/to/osclass-persistence /path/to/osclass-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

Additionally, [snapshot the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#step-2-stop-and-backup-the-currently-running-container)

You can use these snapshots to restore the application state should the upgrade fail.

4. Remove the stopped container

 * For docker-compose: `$ docker-compose rm osclass`
 * For manual execution: `$ docker rm osclass`

5. Run the new image

 * For docker-compose: `$ docker-compose up osclass`
 * For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name osclass bitnami/osclass:latest`

# Configuration

## Environment variables

The Osclass instance can be customized by specifying environment variables on the first run. The following environment values are provided to custom Osclass:

##### User and Site configuration

- `OSCLASS_USERNAME`: Osclass application username. Default: **user**
- `OSCLASS_PASSWORD`: Osclass application password. Default: **bitnami1**
- `OSCLASS_EMAIL`: Osclass application email. Default: **user@example.com**
- `OSCLASS_WEB_TITLE`: Osclass application title. Default: **Sample Web Page**
- `OSCLASS_HOST`: Osclass application IP or domain. Default: **127.0.0.1**
- `OSCLASS_PING_ENGINES`: Allow site to appear in search engines. Default: **1**
- `OSCLASS_SAVE_STATS`: Automatically send usage statistics and crash reports to Osclass. Default: **1**

##### Use an existing database

- `MARIADB_HOST`: Hostname for MariaDB server. Default: **mariadb**
- `MARIADB_PORT_NUMBER`: Port used by MariaDB server. Default: **3306**
- `OSCLASS_DATABASE_NAME`: Database name that Osclass will use to connect with the database. Default: **bitnami_osclass**
- `OSCLASS_DATABASE_USER`: Database user that Osclass will use to connect with the database. Default: **bn_osclass**
- `OSCLASS_DATABASE_PASSWORD`: Database password that Osclass will use to connect with the database. No defaults.
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

##### Create a database for Osclass using mysql-client

- `MARIADB_HOST`: Hostname for MariaDB server. Default: **mariadb**
- `MARIADB_PORT_NUMBER`: Port used by MariaDB server. Default: **3306**
- `MARIADB_ROOT_USER`: Database admin user. Default: **root**
- `MARIADB_ROOT_PASSWORD`: Database password for the `MARIADB_ROOT_USER` user. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_NAME`: New database to be created by the mysql client module. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_USER`: New database user to be created by the mysql client module. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_PASSWORD`: Database password for the `MYSQL_CLIENT_CREATE_DATABASE_USER` user. No defaults.
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

##### PHP configuration

- `PHP_MEMORY_LIMIT`: Memory limit for PHP scripts. Default: **256M**

If you want to add a new environment variable:

### Specifying Environment variables using Docker Compose

```yaml
version: '2'

services:
  mariadb:
    image: 'bitnami/mariadb:latest'
    environment:
      - MARIADB_USER=bn_osclass
      - MARIADB_DATABASE=bitnami_osclass
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - mariadb_data:/bitnami
  osclass:
    image: bitnami/osclass:latest
    depends_on:
      - mariadb
    ports:
      - '80:80'
      - '443:443'
    environment:
      - OSCLASS_PASSWORD=my_password
      - MARIADB_HOST=mariadb
      - MARIADB_PORT_NUMBER=3306
      - OSCLASS_DATABASE_USER=bn_osclass
      - OSCLASS_DATABASE_NAME=bitnami_osclass
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - osclass_data:/bitnami
volumes:
  mariadb_data:
    driver: local
  osclass_data:
    driver: local
```

### Specifying Environment variables on the Docker command line

```console
$ docker run -d --name osclass -p 80:80 -p 443:443 \
  --net osclass-tier \
  --env OSCLASS_PASSWORD=my_password \
  -e ALLOW_EMPTY_PASSWORD=yes \
  -e OSCLASS_DATABASE_USER=bn_osclass \
  -e OSCLASS_DATABASE_NAME=bitnami_osclass \
  -e OSCLASS_PASSWORD=my_password \
  --volume osclass_data:/bitnami \
  bitnami/osclass:latest
```

### SMTP Configuration

To configure Osclass to send email using SMTP you can set the following environment variables:
- `SMTP_HOST`: Host for outgoing SMTP email.
- `SMTP_PORT`: Port for outgoing SMTP email.
- `SMTP_USER`: User of SMTP used for authentication (likely email).
- `SMTP_PASSWORD`: Password for SMTP.
- `SMTP_PROTOCOL`: Secure connection protocol to use for SMTP [tls, ssl, none].

This would be an example of SMTP configuration using a GMail account:

 * docker-compose (application part):

```yaml
  osclass:
    image: bitnami/osclass:latest
    ports:
      - 80:80
    environment:
      - MARIADB_HOST=mariadb
      - MARIADB_PORT_NUMBER=3306
      - OSCLASS_DATABASE_USER=bn_osclass
      - OSCLASS_DATABASE_NAME=bitnami_osclass
      - SMTP_HOST=smtp.gmail.com
      - SMTP_PORT=587
      - SMTP_USER=your_email@gmail.com
      - SMTP_PASSWORD=your_password
      - SMTP_PROTOCOL=tls
    volumes:
      - osclass_data:/bitnami
```

* For manual execution:

  ```console
  $ docker run -d --name osclass -p 80:80 -p 443:443 \
    --net osclass-tier \
    -e MARIADB_HOST=mariadb \
    -e MARIADB_PORT_NUMBER=3306 \
    -e OSCLASS_DATABASE_USER=bn_osclass \
    -e OSCLASS_DATABASE_NAME=bitnami_osclass \
    -e SMTP_HOST=smtp.gmail.com \
    -e SMTP_PORT=587 \
    -e SMTP_PROTOCOL=tls \
    -e SMTP_USER=your_email@gmail.com \
    -e SMTP_PASSWORD=your_password \
    --volume osclass_data:/bitnami \
    bitnami/osclass:latest
  ```

# Customize this image

The Bitnami Osclass Docker image is designed to be extended so it can be used as the base image for your custom web applications.

## Extend this image

Before extending this image, please note there are certain configuration settings you can modify using the original image:

- Settings that can be adapted using environment variables. For instance, you can change the ports used by Apache for HTTP and HTTPS, by setting the environment variables `APACHE_HTTP_PORT_NUMBER` and `APACHE_HTTPS_PORT_NUMBER` respectively.
- [Adding custom virtual hosts](https://github.com/bitnami/bitnami-docker-apache#adding-custom-virtual-hosts).
- [Replacing the 'httpd.conf' file](https://github.com/bitnami/bitnami-docker-apache#full-configuration).
- [Using custom SSL certificates](https://github.com/bitnami/bitnami-docker-apache#using-custom-ssl-certificates).

If your desired customizations cannot be covered using the methods mentioned above, extend the image. To do so, create your own image using a Dockerfile with the format below:

```Dockerfile
FROM bitnami/osclass
## Put your customizations below
...
```

Here is an example of extending the image with the following modifications:

- Install the `vim` editor
- Modify the Apache configuration file
- Modify the ports used by Apache

```Dockerfile
FROM bitnami/osclass
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
      - MARIADB_USER=bn_osclass
      - MARIADB_DATABASE=bitnami_osclass
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - 'mariadb_data:/bitnami'
  osclass:
    build: .
    environment:
      - MARIADB_HOST=mariadb
      - MARIADB_PORT_NUMBER=3306
      - OSCLASS_HOST=localhost
      - OSCLASS_DATABASE_USER=bn_osclass
      - OSCLASS_DATABASE_NAME=bitnami_osclass
      - ALLOW_EMPTY_PASSWORD=yes
    ports:
      - '80:8181'
      - '443:8143'
    depends_on:
      - mariadb
    volumes:
      - 'osclass_data:/bitnami'
volumes:
  mariadb_data:
    driver: local
  osclass_data:
    driver: local
```

# Notable Changes

## 3.7.4-debian-9-r254 and 3.7.4-ol-7-r322

- This image has been adapted so it's easier to customize. See the [Customize this image](#customize-this-image) section for more information.
- The Apache configuration volume (`/bitnami/apache`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the Apache configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom Apache configuration files are advised to mount a volume for the configuration at `/opt/bitnami/apache/conf`, or mount specific configuration files individually.
- The PHP configuration volume (`/bitnami/php`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the PHP configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom PHP configuration files are advised to mount a volume for the configuration at `/opt/bitnami/php/conf`, or mount specific configuration files individually.
- Enabling custom Apache certificates by placing them at `/opt/bitnami/apache/certs` has been deprecated, and support for this functionality will be dropped in the near future. Users wanting to enable custom certificates are advised to mount their certificate files on top of the preconfigured ones at `/certs`.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-osclass/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-osclass/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-osclass/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`$ docker version`)
- Output of `$ docker info`
- Version of this container (`$ echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright 2016-2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

 <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
