[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-phpmyadmin/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-phpmyadmin/tree/master)
[![Docker Hub Automated Build](http://container.checkforupdates.com/badges/bitnami/phpmyadmin)](https://hub.docker.com/r/bitnami/phpmyadmin/)

# What is phpMyAdmin?

> phpMyAdmin is a free software tool written in PHP, intended to handle the administration of MySQL over the Web. phpMyAdmin supports a wide range of operations on MySQL and MariaDB. Frequently used operations (managing databases, tables, columns, relations, indexes, users, permissions, etc) can be performed via the user interface, while you still have the ability to directly execute any SQL statement.

https://www.phpmyadmin.net/

# Prerequisites

To run this application you need [Docker Engine](https://www.docker.com/products/docker-engine) >= `1.10.0`. [Docker Compose](https://www.docker.com/products/docker-compose) is recommended with a version `1.6.0` or later.

# How to use this image

phpMyAdmin requires access to a MySQL database or MariaDB database to work. We'll use our very own [MariaDB image](https://www.github.com/bitnami/bitnami-docker-mariadb).

## Using Docker Compose

The recommended way to run phpMyAdmin is using Docker Compose using the following `docker-compose.yml` template:

```yaml
version: '2'

services:
  mariadb:
    image: bitnami/mariadb:latest
    volumes:
      - mariadb_data:/bitnami/mariadb
  phpmyadmin:
    image: bitnami/phpmyadmin:latest
    depends_on:
      - mariadb
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - phpmyadmin_data:/bitnami/phpmyadmin
      - apache_data:/bitnami/apache
      - php_data:/bitnami/php

volumes:
  mariadb_data:
    driver: local
  phpmyadmin_data:
    driver: local
  apache_data:
    driver: local
  php_data:
    driver: local
```

Launch the containers using:

```bash
$ docker-compose up -d
```

## Using the Docker Command Line

If you want to run the application manually instead of using `docker-compose`, these are the basic steps you need to run:

1. Create a network

```bash
$ docker network create phpmyadmin-tier
```

2. Create a volume for MariaDB persistence and create a MariaDB container

```bash
$ docker volume create --name mariadb_data
$ docker run -d --name mariadb \
  --net phpmyadmin-tier \
  --volume mariadb_data:/bitnami/mariadb \
  bitnami/mariadb:latest
```

3. Create volumes for phpMyAdmin persistence and launch the container

```bash
$ docker volume create --name phpmyadmin_data
$ docker volume create --name php_data
$ docker volume create --name apache_data
$ docker run -d --name phpmyadmin -p 80:80 -p 443:443 \
  --net phpmyadmin-tier \
  --volume phpmyadmin_data:/bitnami/phpmyadmin \
  --volume php_data:/bitnami/php \
  --volume apache_data:/bitnami/apache \
  bitnami/phpmyadmin:latest
```

Access your application at http://your-ip/

## Persisting your application

For persistence of the phpMyAdmin deployment, the above examples define docker volumes namely `mariadb_data`, `phpmyadmin_data`, `php_data` and `apache_data`. The phpMyAdmin application state will persist as long as these volumes are not removed.

If avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/userguide/containers/dockervolumes/#mount-a-host-directory-as-a-data-volume). Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

The following `docker-compose.yml` template demonstrates the use of host directories as data volumes.

```yaml
version: '2'

services:
  mariadb:
    image: bitnami/mariadb:latest
    volumes:
      - /path/to/mariadb-persistence:/bitnami/mariadb
  phpmyadmin:
    image: bitnami/phpmyadmin:latest
    depends_on:
      - mariadb
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - /path/to/phpmyadmin-persistence:/bitnami/phpmyadmin
      - /path/to/php-persistence:/bitnami/php
      - /path/to/apache-persistence:/bitnami/apache
```

### Mount host directories as data volumes using the Docker command line

1. Create a network (if it does not exist)

```bash
$ docker network create phpmyadmin-tier
```

2. Create a MariaDB container with host volume

```bash
$ docker run -d --name mariadb \
  --net phpmyadmin-tier \
  --volume /path/to/mariadb-persistence:/bitnami/mariadb \
  bitnami/mariadb:latest
```

3. Create the phpMyAdmin the container with host volumes

```bash
$ docker run -d --name phpmyadmin -p 80:80 -p 443:443 \
  --net phpmyadmin-tier \
  --volume /path/to/phpmyadmin-persistence:/bitnami/phpmyadmin \
  --volume /path/to/php-persistence:/bitnami/php \
  --volume /path/to/apache-persistence:/bitnami/apache \
  bitnami/phpmyadmin:latest
```

# Upgrading phpMyAdmin

Bitnami provides up-to-date versions of MariaDB and phpMyAdmin, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the phpMyAdmin container. For the MariaDB upgrade see https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#upgrade-this-image

The `bitnami/phpmyadmin:latest` tag always points to the most recent release. To get the most recent release you can simple repull the `latest` tag from the Docker Hub with `docker pull bitnami/phpmyadmin:latest`. However it is recommended to use [tagged versions](https://hub.docker.com/r/bitnami/phpmyadmin/tags/).

Get the updated image:

```
$ docker pull bitnami/phpmyadmin:latest
```

## Using Docker Compose

1. Stop the running phpMyAdmin container

```bash
$ docker-compose stop phpmyadmin
```

2. Remove the stopped container

```bash
$ docker-compose rm phpmyadmin
```

3. Launch the updated phpMyAdmin image

```bash
$ docker-compose start phpmyadmin
```

## Using Docker command line

1. Stop the running phpMyAdmin container

```bash
$ docker stop phpmyadmin
```

2. Remove the stopped container

```bash
$ docker rm phpmyadmin
```

3. Launch the updated phpMyAdmin image

```bash
$ docker run -d --name phpmyadmin -p 80:80 -p 443:443 \
  --net phpmyadmin-tier \
  --volume phpmyadmin_data:/bitnami/phpmyadmin \
  --volume php_data:/bitnami/php \
  --volume apache_data:/bitnami/apache \
  bitnami/phpmyadmin:latest
```

> **NOTE**:
>
> The above command assumes that local docker volumes are in use. Edit the command according to your usage.

# Configuration

## Environment variables

The phpMyAdmin instance can be customized by specifying environment variables on the first run. The following environment values are provided to custom phpMyAdmin:

- `PHPMYADMIN_ALLOW_ARBITRARY_SERVER`: Allows you to enter database server hostname on login form. Default: **false**
- `PHPMYADMIN_ALLOW_NO_PASSWORD`: Whether to allow logins without a password. Default: **true**
- `DATABASE_HOST`: Database server host. Default: **mariadb**
- `DATABASE_PORT`: Database server port. Default: **3306**
- `WEBSERVER_REQUIRE`: Tests whether an authenticated user is authorized by an authorization provider. Default: **all granted**

### Specifying Environment variables using Docker Compose

```yaml
version: '2'

services:
  mariadb:
    image: bitnami/mariadb:latest
    volumes:
      - mariadb_data:/bitnami/mariadb
  phpmyadmin:
    image: bitnami/phpmyadmin:latest
    depends_on:
      - mariadb
    ports:
      - '80:80'
      - '443:443'
    environment:
      - PHPMYADMIN_ALLOW_NO_PASSWORD=false
      - PHPMYADMIN_ALLOW_ARBITRARY_SERVER=true
    volumes:
      - phpmyadmin_data:/bitnami/phpmyadmin
      - php_data:/bitnami/php
      - apache_data:/bitnami/apache

volumes:
  mariadb_data:
    driver: local
  phpmyadmin_data:
    driver: local
  php_data:
    driver: local
  apache_data:
    driver: local
```

### Specifying Environment variables on the Docker command line

```bash
$ docker run -d --name phpmyadmin -p 80:80 -p 443:443 \
  --net phpmyadmin-tier \
  --env PHPMYADMIN_PASSWORD=my_password \
  --volume phpmyadmin_data:/bitnami/phpmyadmin \
  --volume php_data:/bitnami/php \
  --volume apache_data:/bitnami/apache \
  bitnami/phpmyadmin:latest
```

# Backing up your application

To backup your application data follow these steps:

## Backing up using Docker Compose

1. Stop the phpMyAdmin container:

```bash
$ docker-compose stop phpmyadmin
```

2. Copy the phpMyAdmin, PHP and Apache data

```bash
$ docker cp $(docker-compose ps -q phpmyadmin):/bitnami/phpmyadmin/ /path/to/backups/phpmyadmin/latest/
$ docker cp $(docker-compose ps -q php):/bitnami/php/ /path/to/backups/php/latest/
$ docker cp $(docker-compose ps -q phpmyadmin):/bitnami/apache/ /path/to/backups/apache/latest/
```

3. Start the phpMyAdmin container

```bash
$ docker-compose start phpmyadmin
```

## Backing up using the Docker command line

1. Stop the phpMyAdmin container:

```bash
$ docker stop phpmyadmin
```

2. Copy the phpMyAdmin, PHP and Apache data

```bash
$ docker cp phpmyadmin:/bitnami/phpmyadmin/ /path/to/backups/phpmyadmin/latest/
$ docker cp phpmyadmin:/bitnami/php/ /path/to/backups/php/latest/
$ docker cp phpmyadmin:/bitnami/apache/ /path/to/backups/apache/latest/
```

3. Start the phpMyAdmin container

```bash
$ docker start phpmyadmin
```

# Restoring a backup

To restore your application using backed up data simply mount the folder with phpMyAdmin and Apache data in the container. See [persisting your application](#persisting-your-application) section for more info.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/phpmyadmin/issues), or submit a [pull request](https://github.com/bitnami/phpmyadmin/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/phpmyadmin/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright (c) 2015-2016 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
