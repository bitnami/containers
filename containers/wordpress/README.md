[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-wordpress/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-wordpress/tree/master)
[![Docker Hub Automated Build](http://container.checkforupdates.com/badges/bitnami/wordpress)](https://hub.docker.com/r/bitnami/wordpress/)

# What is WordPress?

> WordPress is one of the most versatile open source content management systems on the market. WordPress is built for high performance and is scalable to many servers, has easy integration via REST, JSON, SOAP and other formats, and features a whopping 15,000 plugins to extend and customize the application for just about any type of website.

https://www.wordpress.org/

# TL;DR;

```bash
$ curl -LO https://raw.githubusercontent.com/bitnami/bitnami-docker-wordpress/master/docker-compose.yml
$ docker-compose up
```

# Prerequisites

To run this application you need [Docker Engine](https://www.docker.com/products/docker-engine) >= `1.10.0`. [Docker Compose](https://www.docker.com/products/docker-compose) is recommended with a version `1.6.0` or later.

# How to use this image

WordPress requires access to a MySQL database or MariaDB database to store information. We'll use our very own [MariaDB image](https://www.github.com/bitnami/bitnami-docker-mariadb) for the database requirements.

## Using Docker Compose

The recommended way to run WordPress is using Docker Compose using the following `docker-compose.yml` template:

```yaml
version: '2'

services:
  mariadb:
    image: bitnami/mariadb:latest
    volumes:
      - mariadb_data:/bitnami/mariadb
  wordpress:
    image: bitnami/wordpress:latest
    depends_on:
      - mariadb
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - wordpress_data:/bitnami/wordpress
      - apache_data:/bitnami/apache
      - php_data:/bitnami/php

volumes:
  mariadb_data:
    driver: local
  wordpress_data:
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
  $ docker network create wordpress-tier
  ```

2. Create a volume for MariaDB persistence and create a MariaDB container

  ```bash
  $ docker volume create --name mariadb_data
  $ docker run -d --name mariadb \
    --net wordpress-tier \
    --volume mariadb_data:/bitnami/mariadb \
    bitnami/mariadb:latest
  ```

3. Create volumes for WordPress persistence and launch the container

  ```bash
  $ docker volume create --name wordpress_data
  $ docker volume create --name apache_data
  $ docker volume create --name php_data
  $ docker run -d --name wordpress -p 80:80 -p 443:443 \
    --net wordpress-tier \
    --volume wordpress_data:/bitnami/wordpress \
    --volume apache_data:/bitnami/apache \
    --volume php_data:/bitnami/php \
    bitnami/wordpress:latest
    ```

Access your application at http://your-ip/

## Persisting your application

For persistence of the WordPress deployment, the above examples define docker volumes namely `mariadb_data`, `wordpress_data`, `apache_data` and `php_data`. The WordPress application state will persist as long as these volumes are not removed.

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
  wordpress:
    image: bitnami/wordpress:latest
    depends_on:
      - mariadb
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - /path/to/wordpress-persistence:/bitnami/wordpress
      - /path/to/apache-persistence:/bitnami/apache
      - /path/to/php-persistence:/bitnami/php
```

### Mount host directories as data volumes using the Docker command line

1. Create a network (if it does not exist)
  ```bash
  $ docker network create wordpress-tier
  ```

2. Create a MariaDB container with host volume
  ```bash
  $ docker run -d --name mariadb \
    --net wordpress-tier \
    --volume /path/to/mariadb-persistence:/bitnami/mariadb \
    bitnami/mariadb:latest
  ```

3. Create the WordPress the container with host volumes
  ```bash
  $ docker run -d --name wordpress -p 80:80 -p 443:443 \
    --net wordpress-tier \
    --volume /path/to/wordpress-persistence:/bitnami/wordpress \
    --volume /path/to/apache-persistence:/bitnami/apache \
    --volume /path/to/php-persistence:/bitnami/php \
    bitnami/wordpress:latest
  ```

# Upgrading WordPress

Bitnami provides up-to-date versions of MariaDB and WordPress, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the WordPress container. For the MariaDB upgrade see https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#upgrade-this-image

The `bitnami/wordpress:latest` tag always points to the most recent release. To get the most recent release you can simple repull the `latest` tag from the Docker Hub with `docker pull bitnami/wordpress:latest`. However it is recommended to use [tagged versions](https://hub.docker.com/r/bitnami/wordpress/tags/).

Get the updated image:

```
$ docker pull bitnami/wordpress:latest
```

## Using Docker Compose

1. Stop the running WordPress container
  ```bash
  $ docker-compose stop wordpress
  ```

2. Remove the stopped container
  ```bash
  $ docker-compose rm wordpress
  ```

3. Launch the updated WordPress image
  ```bash
  $ docker-compose start wordpress
  ```

## Using Docker command line

1. Stop the running WordPress container
  ```bash
  $ docker stop wordpress
  ```

2. Remove the stopped container
  ```bash
  $ docker rm wordpress
  ```

3. Launch the updated WordPress image
  ```bash
  $ docker run -d --name wordpress -p 80:80 -p 443:443 \
    --net wordpress-tier \
    --volume wordpress_data:/bitnami/wordpress \
    --volume apache_data:/bitnami/apache \
    --volume php_data:/bitnami/php \
    bitnami/wordpress:latest
  ```

> **NOTE**:
>
> The above command assumes that local docker volumes are in use. Edit the command according to your usage.

# Configuration

## Environment variables

The WordPress instance can be customized by specifying environment variables on the first run. The following environment values are provided to custom WordPress:

- `WORDPRESS_USERNAME`: WordPress application username. Default: **user**
- `WORDPRESS_PASSWORD`: WordPress application password. Default: **bitnami**
- `WORDPRESS_EMAIL`: WordPress application email. Default: **user@example.com**
- `WORDPRESS_FIRST_NAME`: WordPress user first name. Default: **FirstName**
- `WORDPRESS_LAST_NAME`: WordPress user last name. Default: **LastName**
- `WORDPRESS_BLOG_NAME`: WordPress blog name. Default: **User's blog**
- `MARIADB_USER`: Root user for the MariaDB database. Default: **root**
- `MARIADB_PASSWORD`: Root password for the MariaDB.
- `MARIADB_HOST`: Hostname for MariaDB server. Default: **mariadb**
- `MARIADB_PORT`: Port used by MariaDB server. Default: **3306**

### Specifying Environment variables using Docker Compose

```yaml
version: '2'

services:
  mariadb:
    image: bitnami/mariadb:latest
    volumes:
      - mariadb_data:/bitnami/mariadb
  wordpress:
    image: bitnami/wordpress:latest
    depends_on:
      - mariadb
    ports:
      - '80:80'
      - '443:443'
    environment:
      - WORDPRESS_PASSWORD=my_password
    volumes:
      - wordpress_data:/bitnami/wordpress
      - apache_data:/bitnami/apache
      - php_data:/bitnami/php

volumes:
  mariadb_data:
    driver: local
  wordpress_data:
    driver: local
  apache_data:
    driver: local
  php_data:
    driver: local
```

### Specifying Environment variables on the Docker command line

```bash
$ docker run -d --name wordpress -p 80:80 -p 443:443 \
  --net wordpress-tier \
  --env WORDPRESS_PASSWORD=my_password \
  --volume wordpress_data:/bitnami/wordpress \
  --volume apache_data:/bitnami/apache \
  --volume php_data:/bitnami/php \
  bitnami/wordpress:latest
```

### SMTP Configuration

To configure WordPress to send email using SMTP you can set the following environment variables:
- `SMTP_HOST`: Host for outgoing SMTP email.
- `SMTP_PORT`: Port for outgoing SMTP email.
- `SMTP_USER`: User of SMTP used for authentication (likely email).
- `SMTP_PASSWORD`: Password for SMTP.
- `SMTP_PROTOCOL`: Secure connection protocol to use for SMTP [tls, ssl, none].

This would be an example of SMTP configuration using a GMail account:

 * docker-compose (application part):

```yaml
  wordpress:
    image: bitnami/wordpress:latest
    ports:
      - 80:80
      - 443:443
    environment:
      - SMTP_HOST=smtp.gmail.com
      - SMTP_PORT=587
      - SMTP_USER=your_email@gmail.com
      - SMTP_PASSWORD=your_password
      - SMTP_PROTOCOL=tls
    volumes:
      - wordpress_data:/bitnami/wordpress
```

* For manual execution:

```
$ docker run -d --name wordpress -p 80:80 -p 443:443 \
  --net wordpress-tier \
  --env SMTP_HOST=smtp.gmail.com --env SMTP_PORT=587 \
  --env SMTP_USER=your_email@gmail.com --env SMTP_PASSWORD=your_password \
  --volume wordpress_data:/bitnami/wordpress \
  bitnami/wordpress:latest
```

# Backing up your application

To backup your application data follow these steps:

## Backing up using Docker Compose

1. Stop the WordPress container:
  ```bash
  $ docker-compose stop wordpress
  ```

2. Copy the WordPress, PHP and Apache data
  ```bash
  $ docker cp $(docker-compose ps -q wordpress):/bitnami/wordpress/ /path/to/backups/wordpress/latest/
  $ docker cp $(docker-compose ps -q wordpress):/bitnami/apache/ /path/to/backups/apache/latest/
  $ docker cp $(docker-compose ps -q wordpress):/bitnami/php/ /path/to/backups/php/latest/
  ```

3. Start the WordPress container
  ```bash
  $ docker-compose start wordpress
  ```

## Backing up using the Docker command line

1. Stop the WordPress container:
  ```bash
  $ docker stop wordpress
  ```

2. Copy the WordPress, PHP and Apache data
  ```bash
  $ docker cp wordpress:/bitnami/wordpress/ /path/to/backups/wordpress/latest/
  $ docker cp wordpress:/bitnami/apache/ /path/to/backups/apache/latest/
  $ docker cp wordpress:/bitnami/php/ /path/to/backups/php/latest/
  ```

3. Start the WordPress container
  ```bash
  $ docker start wordpress
  ```

# Restoring a backup

To restore your application using backed up data simply mount the folder with WordPress and Apache data in the container. See [persisting your application](#persisting-your-application) section for more info.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-wordpress/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-wordpress/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-wordpress/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`$ docker version`)
- Output of `$ docker info`
- Version of this container (`$ echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright (c) 2017 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
