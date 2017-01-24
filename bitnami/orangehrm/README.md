[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-orangehrm/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-orangehrm/tree/master)
[![Docker Hub Automated Build](http://container.checkforupdates.com/badges/bitnami/orangehrm)](https://hub.docker.com/r/bitnami/orangehrm/)

# What is OrangeHRM?

> OrangeHRM Open Source is a free HR management system that offers a wealth of modules to suit the needs of your business. This widely-used system is feature-rich, intuitive and provides an essential HR management platform along with free documentation and access to a broad community of users.

<https://www.orangehrm.com/>

# TL;DR;

```bash
$ curl -LO https://raw.githubusercontent.com/bitnami/bitnami-docker-orangehrm/master/docker-compose.yml
$ docker-compose up
```

# Prerequisites

To run this application you need [Docker Engine](https://www.docker.com/products/docker-engine) >= `1.10.0`. [Docker Compose](https://www.docker.com/products/docker-compose) is recommended with a version `1.6.0` or later.

OrangeHRM requires access to a MySQL database or MariaDB database to store information.

# How to use this image
Running OrangeHRM with a database server is the recommended way. You can either use docker-compose or run the containers manually. We'll use our very own [MariaDB image](https://www.github.com/bitnami/bitnami-docker-mariadb) for the database requirements.

## Using Docker Compose

The recommended way to run OrangeHRM is using Docker Compose using the following `docker-compose.yml` template:

```yaml
version: '2'
services:
  mariadb:
    build: mariadb
    volumes:
      - 'mariadb_data:/bitnami/mariadb'
  orangehrm:
    build: .
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - 'orangehrm_data:/bitnami/orangehrm'
      - 'apache_data:/bitnami/apache'
      - 'php_data:/bitnami/php'
    depends_on:
      - mariadb
volumes:
  mariadb_data:
    driver: local
  orangehrm_data:
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
  $ docker network create orangehrm-tier
  ```

2. Create a volume for MariaDB persistence and create a MariaDB container

  ```bash
  $ docker volume create --name mariadb_data
  $ docker run -d --name mariadb \
    --net orangehrm-tier \
    --volume mariadb_data:/bitnami/mariadb \
    bitnami/mariadb:latest
  ```

3. Create volumes for OrangeHRM persistence and launch the container

  ```bash
  $ docker volume create --name orangehrm_data
  $ docker volume create --name apache_data
  $ docker volume create --name php_data
  $ docker run -d --name orangehrm -p 80:80 -p 443:443 \
    --net orangehrm-tier \
    --volume orangehrm_data:/bitnami/orangehrm \
    --volume apache_data:/bitnami/apache \
    --volume php_data:/bitnami/php \
    bitnami/orangehrm:latest
  ```

Access your application at <http://your-ip/>

## Persisting your application

For persistence of the OrangeHRM deployment, the above examples define docker volumes namely `mariadb_data`, `orangehrm_data`, `php_data` and `apache_data`. The OrangeHRM application state will persist as long as these volumes are not removed.

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
  orangehrm:
    image: bitnami/orangehrm:latest
    depends_on:
      - mariadb
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - /path/to/orangehrm-persistence:/bitnami/orangehrm
      - /path/to/apache-persistence:/bitnami/apache
      - /path/to/php-persistence:/bitnami/php
```

### Mount host directories as data volumes using the Docker command line

1. Create a network (if it does not exist)
  ```bash
  $ docker network create orangehrm-tier
  ```

2. Create a MariaDB container with host volume
  ```bash
  $ docker run -d --name mariadb \
    --net orangehrm-tier \
    --volume /path/to/mariadb-persistence:/bitnami/mariadb \
    bitnami/mariadb:latest
  ```

3. Create the OrangeHRM the container with host volumes
  ```bash
  $ docker run -d --name orangehrm -p 80:80 -p 443:443 \
    --net orangehrm-tier \
    --volume /path/to/orangehrm-persistence:/bitnami/orangehrm \
    --volume /path/to/apache-persistence:/bitnami/apache \
    --volume /path/to/php-persistence:/bitnami/php \
    bitnami/orangehrm:latest
  ```

# Upgrading OrangeHRM

Bitnami provides up-to-date versions of MariaDB and OrangeHRM, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the OrangeHRM container. For the MariaDB upgrade see https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#upgrade-this-image

The `bitnami/orangehrm:latest` tag always points to the most recent release. To get the most recent release you can simple repull the `latest` tag from the Docker Hub with `docker pull bitnami/orangehrm:latest`. However it is recommended to use [tagged versions](https://hub.docker.com/r/bitnami/orangehrm/tags/).

Get the updated image:

```
$ docker pull bitnami/orangehrm:latest
```

## Using Docker Compose

1. Stop the running OrangeHRM container
  ```bash
  $ docker-compose stop orangehrm
  ```

2. Remove the stopped container
  ```bash
  $ docker-compose rm orangehrm
  ```

3. Launch the updated OrangeHRM image
  ```bash
  $ docker-compose start orangehrm
  ```

## Using Docker command line

1. Stop the running OrangeHRM container
  ```bash
  $ docker stop orangehrm
  ```

2. Remove the stopped container
  ```bash
  $ docker rm orangehrm
  ```

3. Launch the updated OrangeHRM image
  ```bash
  $ docker run -d --name orangehrm -p 80:80 -p 443:443 \
    --net orangehrm-tier \
    --volume orangehrm_data:/bitnami/orangehrm \
    --volume apache_data:/bitnami/apache \
    --volume php_data:/bitnami/php \
    bitnami/orangehrm:latest
  ```

> **NOTE**:
>
> The above command assumes that local docker volumes are in use. Edit the command according to your usage.

# Configuration

## Environment variables

The OrangeHRM instance can be customized by specifying environment variables on the first run. The following environment values are provided to custom OrangeHRM:

- `ORANGEHRM_USERNAME`: OrangeHRM application username. Default: **admin**
- `ORANGEHRM_PASSWORD`: OrangeHRM application password. Default: **bitnami**
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
  orangehrm:
    image: bitnami/orangehrm:latest
    depends_on:
      - mariadb
    ports:
      - '80:80'
      - '443:443'
    environment:
      - ORANGEHRM_PASSWORD=my_password
    volumes:
      - orangehrm_data:/bitnami/orangehrm
      - apache_data:/bitnami/apache
      - php_data:/bitnami/php
volumes:
  mariadb_data:
    driver: local
  orangehrm_data:
    driver: local
  apache_data:
    driver: local
  php_data:
    driver: local
```

### Specifying Environment variables on the Docker command line

```bash
$ docker run -d --name orangehrm -p 80:80 -p 443:443 \
  --net orangehrm-tier \
  --env ORANGEHRM_PASSWORD=my_password \
  --volume orangehrm_data:/bitnami/orangehrm \
  --volume apache_data:/bitnami/apache \
  --volume php_data:/bitnami/php \
  bitnami/orangehrm:latest
```

### SMTP Configuration

To configure OrangeHRM to send email using SMTP you can set the following environment variables:
- `SMTP_HOST`: Host for outgoing SMTP email.
- `SMTP_PORT`: Port for outgoing SMTP email.
- `SMTP_USER`: User of SMTP used for authentication.
- `SMTP_PASSWORD`: Password for SMTP.
- `SMTP_PROTOCOL`: Secure connection protocol to use for SMTP [ssl or none].

This would be an example of SMTP configuration using a GMail account:

 * docker-compose (application part):

```yaml
  orangehrm:
    image: bitnami/orangehrm:latest
    depends_on:
      - mariadb
    ports:
      - 80:80
      - 443:443
    environment:
      - SMTP_HOST=smtp.gmail.com
      - SMTP_PORT=465
      - SMTP_USER=your_email@gmail.com
      - SMTP_PASSWORD=your_password
      - SMTP_PROTOCOL=ssl
    volumes:
      - orangehrm_data:/bitnami/orangehrm
      - apache_data:/bitnami/apache
      - php_data:/bitnami/php
```

* For manual execution:

```bash
 $ docker run -d --name orangehrm -p 80:80 -p 443:443 \
   --net orangehrm-tier \
   --env SMTP_HOST=smtp.gmail.com \
   --env SMTP_PORT=465 --env SMTP_PROTOCOL=ssl \
   --env SMTP_USER=your_email@gmail.com \
   --env SMTP_PASSWORD=your_password \
   --volume orangehrm_data:/bitnami/orangehrm \
   --volume apache_data:/bitnami/apache \
   --volume php_data:/bitnami/php \
   bitnami/orangehrm:latest
```

# Backing up your application

To backup your application data follow these steps:

## Backing up using Docker Compose

1. Stop the OrangeHRM container:
  ```bash
  $ docker-compose stop orangehrm
  ```

2. Copy the OrangeHRM, php and Apache data
  ```bash
  $ docker cp $(docker-compose ps -q orangehrm):/bitnami/orangehrm/ /path/to/backups/orangehrm/latest/
  $ docker cp $(docker-compose ps -q orangehrm):/bitnami/apache/ /path/to/backups/apache/latest/
  $ docker cp $(docker-compose ps -q orangehrm):/bitnami/php/ /path/to/backups/php/latest/
  ```

3. Start the OrangeHRM container
  ```bash
  $ docker-compose start orangehrm
  ```

## Backing up using the Docker command line

1. Stop the OrangeHRM container:
  ```bash
  $ docker stop orangehrm
  ```

2. Copy the OrangeHRM, php and Apache data
  ```bash
  $ docker cp orangehrm:/bitnami/orangehrm/ /path/to/backups/orangehrm/latest/
  $ docker cp orangehrm:/bitnami/apache/ /path/to/backups/apache/latest/
  $ docker cp orangehrm:/bitnami/php/ /path/to/backups/php/latest/
  ```

3. Start the OrangeHRM container
  ```bash
  $ docker start orangehrm
  ```

# Restoring a backup

To restore your application using backed up data simply mount the folder with OrangeHRM and Apache data in the container. See [persisting your application](#persisting-your-application) section for more info.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-orangehrm/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-orangehrm/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-orangehrm/issues). For us to provide better support, be sure to include the following information in your issue:

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
