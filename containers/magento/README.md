# What is Magento?

> Magento is a feature-rich flexible e-commerce solution. It includes transaction options, multi-store functionality, loyalty programs, product categorization and shopper filtering, promotion rules, and more.

https://magento.com/

# TL;DR;

## Docker Compose

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-magento/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DTC)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/magento?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy Magento in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Magento Chart GitHub repository](https://github.com/bitnami/charts/tree/master/upstreamed/magento).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Supported tags and respective `Dockerfile` links

> NOTE: Debian 9 images have been deprecated in favor of Debian 10 images. Bitnami will not longer publish new Docker images based on Debian 9.

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/).


* [`2-ol-7`, `2.3.4-ol-7-r2` (2/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-magento/blob/2.3.4-ol-7-r2/2/ol-7/Dockerfile)
* [`2-debian-10`, `2.3.4-debian-10-r0`, `2`, `2.3.4`, `latest` (2/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-magento/blob/2.3.4-debian-10-r0/2/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/magento GitHub repo](https://github.com/bitnami/bitnami-docker-magento).

# Prerequisites

To run this application you need Docker Engine 1.10.0. Docker Compose is recomended with a version 1.6.0 or later.

# How to use this image

## Run Magento with a Database Container

Running Magento with a database server is the recommended way. You can either use docker-compose or run the containers manually.

### Run the application using Docker Compose

The main folder of this repository contains a functional [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-magento/blob/master/docker-compose.yml) file. Run the application using it as shown below:

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-magento/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
``` 

### Run the application manually

If you want to run the application manually instead of using docker-compose, these are the basic steps you need to run:

1. Create a new network for the application and the database:

  ```bash
  $ docker network create magento-tier
  ```

2. Create a volume for MariaDB persistence and create a MariaDB container

  ```bash
  $ docker volume create --name mariadb_data
  $ docker run -d --name mariadb \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MARIADB_USER=bn_magento \
    -e MARIADB_PASSWORD=your_password \
    -e MARIADB_DATABASE=bitnami_magento \
    --net magento-tier \
    --volume mariadb_data:/bitnami \
    bitnami/mariadb:latest
  ```

  *Note:* You need to give the container a name in order for Magento to resolve the host

3. Create volumes for Magento persistence and launch the container

  ```bash
  $ docker volume create --name magento_data
  $ docker run -d --name magento -p 80:80 -p 443:443 \
    -e MAGENTO_DATABASE_USER=bn_magento \
    -e MAGENTO_DATABASE_PASSWORD=your_password \
    -e MAGENTO_DATABASE_NAME=bitnami_magento \
    --net magento-tier \
    --volume magento_data:/bitnami \
    bitnami/magento:latest
  ```

Then you can access your application at http://your-ip/

*Note:* If you want to access your application from a public IP or hostname you need to configure the application domain. You can handle it adjusting the configuration of the instance by setting the environment variable "MAGENTO_HOST" to your public IP or hostname.

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. Additionally you should mount a volume for [persistence of the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#persisting-your-database).

The above examples define docker volumes namely `mariadb_data` and `magento_data`. The Magento application state will persist as long as these volumes are not removed.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-magento/blob/master/docker-compose.yml) file present in this repository: 

```yaml
services:
  mariadb:
  ...
    volumes:
      - /path/to/mariadb-persistence:/bitnami
  ...
  magento:
  ...
    volumes:
      - '/path/to/magento-persistence:/bitnami'
  ...
```

### Mount host directories as data volumes using the Docker command line

In this case you need to specify the directories to mount on the run command. The process is the same than the one previously shown:

1. Create a network (if it does not exist):

  ```bash
  $ docker network create magento-tier
  ```

2. Create a MariaDB container with host volume:

  ```bash
  $ docker run -d --name mariadb
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MARIADB_USER=bn_magento \
    -e MARIADB_PASSWORD=your_password \
    -e MARIADB_DATABASE=bitnami_magento \
    --net magento-tier \
    --volume /path/to/mariadb-persistence:/bitnami \
    bitnami/mariadb:latest
  ```

  *Note:* You need to give the container a name in order to Magento to resolve the host

3. Create the Magento container with host volumes:

  ```bash
  $ docker run -d --name magento -p 80:80 -p 443:443 \
    -e MAGENTO_DATABASE_USER=bn_magento \
    -e MAGENTO_DATABASE_PASSWORD=your_password \
    -e MAGENTO_DATABASE_NAME=bitnami_magento \
    --net magento-tier \
    --volume /path/to/magento-persistence:/bitnami \
    bitnami/magento:latest
  ```

# Upgrade this application

Bitnami provides up-to-date versions of MariaDB and Magento, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the Magento container. For the MariaDB upgrade see https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#upgrade-this-image

1. Get the updated images:

  ```bash
  $ docker pull bitnami/magento:latest
  ```

2. Stop your container

 * For docker-compose: `$ docker-compose stop magento`
 * For manual execution: `$ docker stop magento`

3. Take a snapshot of the application state

```bash
$ rsync -a /path/to/magento-persistence /path/to/magento-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

Additionally, [snapshot the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#step-2-stop-and-backup-the-currently-running-container)

You can use these snapshots to restore the application state should the upgrade fail.

4. Remove the currently running container

 * For docker-compose: `$ docker-compose rm -v magento`
 * For manual execution: `$ docker rm -v magento`

5. Run the new image

 * For docker-compose: `$ docker-compose up magento`
 * For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name magento bitnami/magento:latest`

# Configuration

## Environment variables

When you start the magento image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the docker run command line. If you want to add a new environment variable:

 * For docker-compose, add the variable to the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-magento/blob/master/docker-compose.yml) file present in this repository:
 
```yaml
magento:
  ...
  environment:
    - MAGENTO_PASSWORD=my_password1234
  ...
```

 * For manual execution add a `-e` option with each variable and value:

  ```bash
  $ docker run -d --name magento -p 80:80 -p 443:443 \
    -e MAGENTO_PASSWORD=my_password1234 \
    --net magento-tier \
    --volume /path/to/magento-persistence:/bitnami \
    bitnami/magento:latest
  ```

Available variables:

#### User and Site configuration

- `MAGENTO_USERNAME`: Magento application username. Default: **user**
- `MAGENTO_PASSWORD`: Magento application password. Default: **bitnami1**
- `MAGENTO_EMAIL`: Magento application email. Default: **user@example.com**
- `MAGENTO_ADMINURI`: Prefix to access the Magento Admin. Default: **admin**
- `MAGENTO_FIRSTNAME`: Magento application first name. Default: **FirstName**
- `MAGENTO_LASTNAME`: Magento application last name. Default: **LastName**
- `MAGENTO_HOST`: Host domain or IP.
- `EXTERNAL_HTTP_PORT_NUMBER`: Port to access Magento from outside of the container using HTTP. Used to configure Magento's internal routes. Default: **80**
- `EXTERNAL_HTTPS_PORT_NUMBER`: Port to access Magento from outside of the container using HTTPS. Used to configure Magento's internal routes. Default: **443**
- `MAGENTO_MODE`: Magento mode. Valid values: **default**, **production**, **developer**. Default: **default**

#### Search configuration

Elasticsearch is now the default search engine in Magento 2.3. To configure it, use the following environment variables. If not specified, MySQL search will be used, but please note that it's been deprecated.

- `ELASTICSEARCH_HOST`: Hostname for the Elasticsearch server.
- `ELASTICSEARCH_PORT_NUMBER`: Port used by the Elasticsearch server.

#### Database configuration

There are two options to configure the Magento database. You can either use an existing database or create a new one from the Magento container using the mysql client.
Below you can see the available environment variables for each option:

##### Use an existing database

- `MARIADB_HOST`: Hostname for MariaDB server. Default: **mariadb**
- `MARIADB_PORT_NUMBER`: Port used by MariaDB server. Default: **3306**
- `MAGENTO_DATABASE_NAME`: Database name that Magento will use to connect with the database. Default: **bitnami_magento**
- `MAGENTO_DATABASE_USER`: Database user that Magento will use to connect with the database. Default: **bn_magento**
- `MAGENTO_DATABASE_PASSWORD`: Database password that Magento will use to connect with the database. No defaults. Required.
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

##### Create a database for Magento using mysql-client

- `MARIADB_HOST`: Hostname for MariaDB server. Default: **mariadb**
- `MARIADB_PORT_NUMBER`: Port used by MariaDB server. Default: **3306**
- `MARIADB_ROOT_USER`: Database admin user. Default: **root**
- `MARIADB_ROOT_PASSWORD`: Database password for the `MARIADB_ROOT_USER` user. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_NAME`: New database to be created by the mysql client module. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_USER`: New database user to be created by the mysql client module. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_PASSWORD`: Database password for the `MYSQL_CLIENT_CREATE_DATABASE_USER` user. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES`: Comma-separated list of privileges to grant to the database user. Default: **ALL**
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

# Customize this image

The Bitnami Magento Docker image is designed to be extended so it can be used as the base image for your custom web applications.

## Extend this image

Before extending this image, please note there are certain configuration settings you can modify using the original image:

- Settings that can be adapted using environment variables. For instance, you can change the ports used by Apache for HTTP and HTTPS, by setting the environment variables `APACHE_HTTP_PORT_NUMBER` and `APACHE_HTTPS_PORT_NUMBER` respectively.
- [Adding custom virtual hosts](https://github.com/bitnami/bitnami-docker-apache#adding-custom-virtual-hosts).
- [Replacing the 'httpd.conf' file](https://github.com/bitnami/bitnami-docker-apache#full-configuration).
- [Using custom SSL certificates](https://github.com/bitnami/bitnami-docker-apache#using-custom-ssl-certificates).

If your desired customizations cannot be covered using the methods mentioned above, extend the image. To do so, create your own image using a Dockerfile with the format below:

```Dockerfile
FROM bitnami/magento
## Put your customizations below
...
```

Here is an example of extending the image with the following modifications:

- Install the `vim` editor
- Modify the Apache configuration file
- Modify the ports used by Apache

```Dockerfile
FROM bitnami/magento
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
    image: 'bitnami/mariadb:10.2'
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - MARIADB_USER=bn_magento
      - MARIADB_PASSWORD=magento_db_password
      - MARIADB_DATABASE=bitnami_magento
    volumes:
      - 'mariadb_data:/bitnami'
  magento:
    build: .
    environment:
      - MARIADB_HOST=mariadb
      - MARIADB_PORT_NUMBER=3306
      - MAGENTO_DATABASE_USER=bn_magento
      - MAGENTO_DATABASE_PASSWORD=magento_db_password
      - MAGENTO_DATABASE_NAME=bitnami_magento
      - ELASTICSEARCH_HOST=elasticsearch
      - ELASTICSEARCH_PORT_NUMBER=9200
    ports:
      - '80:8181'
      - '443:8143'
    volumes:
      - 'magento_data:/bitnami'
    depends_on:
      - mariadb
      - elasticsearch
  elasticsearch:
    image: 'bitnami/elasticsearch:6'
    volumes:
      - 'elasticsearch_data:/bitnami/elasticsearch/data'
volumes:
  elasticsearch_data:
    driver: local
  mariadb_data:
    driver: local
  magento_data:
    driver: local
```

# Notable Changes

## 2.3.1-debian-9-r44 and 2.3.1-ol-7-r53

- This image has been adapted so it's easier to customize. See the [Customize this image](#customize-this-image) section for more information.
- The Apache configuration volume (`/bitnami/apache`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the Apache configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom Apache configuration files are advised to mount a volume for the configuration at `/opt/bitnami/apache/conf`, or mount specific configuration files individually.
- The PHP configuration volume (`/bitnami/php`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the PHP configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom PHP configuration files are advised to mount a volume for the configuration at `/opt/bitnami/php/conf`, or mount specific configuration files individually.
- Enabling custom Apache certificates by placing them at `/opt/bitnami/apache/certs` has been deprecated, and support for this functionality will be dropped in the near future. Users wanting to enable custom certificates are advised to mount their certificate files on top of the preconfigured ones at `/certs`.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-magento/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-magento/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-magento/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`$ docker version`)
- Output of `$ docker info`
- Version of this container (`# echo $BITNAMI_IMAGE_VERSION` inside the container)
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
