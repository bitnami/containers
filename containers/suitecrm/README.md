[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-suitecrm/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-suitecrm/tree/master)

# What is SuiteCRM?

> SuiteCRM is a completely open source enterprise-grade Customer Relationship Management (CRM) application. SuiteCRM is a software fork of the popular customer relationship management (CRM) system SugarCRM.

https://www.suitecrm.com/

# TL;DR;

## Docker Compose

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-suitecrm/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* Bitnami images are built on CircleCI and automatically pushed to the Docker Hub.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.

# Supported tags and respective `Dockerfile` links

> NOTE: Debian 8 images have been deprecated in favor of Debian 9 images. Bitnami will not longer publish new Docker images based on Debian 8.


* [`7-ol-7`, `7.10.7-ol-7-r38` (7/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-suitecrm/blob/7.10.7-ol-7-r38/7/ol-7/Dockerfile)
* [`7-debian-9`, `7.10.7-debian-9-r25`, `7`, `7.10.7`, `7.10.7-r25`, `latest` (7/Dockerfile)](https://github.com/bitnami/bitnami-docker-suitecrm/blob/7.10.7-debian-9-r25/7/Dockerfile)

Subscribe to project updates by watching the [bitnami/suitecrm GitHub repo](https://github.com/bitnami/bitnami-docker-suitecrm).

# Prerequisites

To run this application you need [Docker Engine](https://www.docker.com/products/docker-engine) >= `1.10.0`. [Docker Compose](https://www.docker.com/products/docker-compose) is recommended with a version `1.6.0` or later.

# How to use this image

## Run SuiteCRM with a Database Container

Running SuiteCRM with a database server is the recommended way. You can either use docker-compose or run the container manually.

### Run the application using Docker Compose

This is the recommended way to run SuiteCRM. You can use the following docker compose template:

```yaml
version: '2'

services:
  mariadb:
    image: 'bitnami/mariadb:latest'
    environment:
      - MARIADB_USER=bn_suitecrm
      - MARIADB_DATABASE=bitnami_suitecrm
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - 'mariadb_data:/bitnami'
  suitecrm:
    image: 'bitnami/suitecrm:latest'
    environment:
      - MARIADB_HOST=mariadb
      - MARIADB_PORT_NUMBER=3306
      - SUITECRM_DATABASE_USER=bn_suitecrm
      - SUITECRM_DATABASE_NAME=bitnami_suitecrm
      - ALLOW_EMPTY_PASSWORD=yes
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - 'suitecrm_data:/bitnami'
    depends_on:
      - mariadb

volumes:
  mariadb_data:
    driver: local
  suitecrm_data:
    driver: local
```

### Run the application manually

If you want to run the application manually instead of using docker-compose, these are the basic steps you need to run:

1. Create a new network for the application and the database:

  ```bash
  $ docker network create suitecrm-tier
  ```

2. Create a volume for MariaDB persistence and create a MariaDB container

  ```bash
  $ docker volume create --name mariadb_data
  $ docker run -d --name mariadb \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MARIADB_USER=bn_suitecrm \
    -e MARIADB_DATABASE=bitnami_suitecrm \
    --net suitecrm-tier \
    --volume mariadb_data:/bitnami \
    bitnami/mariadb:latest
  ```

  *Note:* You need to give the container a name in order to SuiteCRM to resolve the host

3. Create volumes for Suitecrm persistence and launch the container

  ```bash
  $ docker volume create --name suitecrm_data
  $ docker run -d --name suitecrm -p 80:80 -p 443:443 \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e SUITECRM_DATABASE_USER=bn_suitecrm \
    -e SUITECRM_DATABASE_NAME=bitnami_suitecrm \
    --net suitecrm-tier \
    --volume suitecrm_data:/bitnami \
    bitnami/suitecrm:latest
  ```

Then you can access your application at http://your-ip/

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. Additionally you should mount a volume for [persistence of the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#persisting-your-database).

The above examples define docker volumes namely `mariadb_data` and `suitecrm_data`. The SuiteCRM application state will persist as long as these volumes are not removed.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

This requires a minor change to the `docker-compose.yml` template previously shown:

```yaml
version: '2'

services:
  mariadb:
    image: 'bitnami/mariadb:latest'
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - MARIADB_USER=bn_suitecrm
      - MARIADB_DATABASE=bitnami_suitecrm
    volumes:
      - '/path/to/mariadb-persistence:/bitnami'
  suitecrm:
    environment:
      - SUITECRM_DATABASE_USER=bn_suitecrm
      - SUITECRM_DATABASE_NAME=bitnami_suitecrm
      - ALLOW_EMPTY_PASSWORD=yes
    image: 'bitnami/suitecrm:latest'
    depends_on:
      - mariadb
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - '/path/to/suitecrm-persistence:/bitnami'
```

### Mount host directories as data volumes using the Docker command line

In this case you need to specify the directories to mount on the run command. The process is the same than the one previously shown:

1. Create a network (if it does not exist):

  ```bash
  $ docker network create suitecrm-tier
  ```

2. Create a MariaDB container with host volume:

  ```bash
  $ docker run -d --name mariadb \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MARIADB_USER=bn_suitecrm \
    -e MARIADB_DATABASE=bitnami_suitecrm \
    --net suitecrm-tier \
    --volume /path/to/mariadb-persistence:/bitnami \
    bitnami/mariadb:latest
  ```
   *Note:* You need to give the container a name in order to SuiteCRM to resolve the host

3. Create the SuiteCRM container with host volumes:

  ```bash
  $ docker run -d --name suitecrm -p 80:80 -p 443:443 \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e SUITECRM_DATABASE_USER=bn_suitecrm \
    -e SUITECRM_DATABASE_NAME=bitnami_suitecrm \
    --net suitecrm-tier \
    --volume /path/to/suitecrm-persistence:/bitnami \
    bitnami/suitecrm:latest
  ```

# Upgrade this application

Bitnami provides up-to-date versions of MariaDB and SuiteCRM, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the SuiteCRM container. For the MariaDB upgrade you can take a look at https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#upgrade-this-image

1. Get the updated images:

  ```bash
  $ docker pull bitnami/suitecrm:latest
  ```

2. Stop your container

 * For docker-compose: `$ docker-compose stop suitecrm`
 * For manual execution: `$ docker stop suitecrm`

3. Take a snapshot of the application state

```bash
$ rsync -a /path/to/suitecrm-persistence /path/to/suitecrm-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

Additionally, [snapshot the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#step-2-stop-and-backup-the-currently-running-container)

You can use these snapshots to restore the application state should the upgrade fail.

4. Remove the currently running container

 * For docker-compose: `$ docker-compose rm -v suitecrm`
 * For manual execution: `$ docker rm -v suitecrm`

5. Run the new image

 * For docker-compose: `$ docker-compose up suitecrm`
 * For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name suitecrm bitnami/suitecrm:latest`

# Configuration

## Environment variables

When you start the SuiteCRM image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the docker run command line.

##### User and Site configuration

 - `SUITECRM_USERNAME`: SuiteCRM application username. Default: **User**
 - `SUITECRM_PASSWORD`: SuiteCRM application password. Default: **bitnami**
 - `SUITECRM_EMAIL`: SuiteCRM application email. Default: **user@example.com**
 - `SUITECRM_LASTNAME`: SuiteCRM application last name. Default: **Name**
 - `SUITECRM_HOST`: Host domain or IP.
 - `SUITECRM_HTTP_TIMEOUT`: Timeout in seconds used on http requests during wizard installation. Default: **120**

##### Use an existing database

- `MARIADB_HOST`: Hostname for MariaDB server. Default: **mariadb**
- `MARIADB_PORT_NUMBER`: Port used by MariaDB server. Default: **3306**
- `SUITECRM_DATABASE_NAME`: Database name that SuiteCRM will use to connect with the database. Default: **bitnami_suitecrm**
- `SUITECRM_DATABASE_USER`: Database user that SuiteCRM will use to connect with the database. Default: **bn_suitecrm**
- `SUITECRM_DATABASE_PASSWORD`: Database password that SuiteCRM will use to connect with the database. No defaults.
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

##### Create a database for SuiteCRM using mysql-client

- `MARIADB_HOST`: Hostname for MariaDB server. Default: **mariadb**
- `MARIADB_PORT_NUMBER`: Port used by MariaDB server. Default: **3306**
- `MARIADB_ROOT_USER`: Database admin user. Default: **root**
- `MARIADB_ROOT_PASSWORD`: Database password for the `MARIADB_ROOT_USER` user. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_NAME`: New database to be created by the mysql client module. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_USER`: New database user to be created by the mysql client module. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_PASSWORD`: Database password for the `MYSQL_CLIENT_CREATE_DATABASE_USER` user. No defaults.
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

If you want to add a new environment variable:

 * For docker-compose add the variable name and value under the application section:

```yaml
suitecrm:
  image: bitnami/suitecrm:latest
  ports:
    - 80:80
  environment:
    - SUITECRM_PASSWORD=my_password
```

 * For manual execution add a `-e` option with each variable and value:

  ```bash
  $ docker run -d -p 80:80 -p 443:443 --name suitecrm  \
    -e SUITECRM_PASSWORD=my_password \
    --net suitecrm-tier \
    --volume /path/to/suitecrm-persistence:/bitnami \
    bitnami/suitecrm:latest
  ```

### SMTP Configuration

To configure SugarCMR to send email using SMTP you can set the following environment variables:

 - `SUITECRM_SMTP_HOST`: SugarCRM SMTP host.
 - `SUITECRM_SMTP_PORT`: SugarCRM SMTP port.
 - `SUITECRM_SMTP_USER`: SugarCRM SMTP account user.
 - `SUITECRM_SMTP_PASSWORD`: SugarCRM SMTP account password.
 - `SUITECRM_SMTP_PROTOCOL`: SugarCRM SMTP protocol to use.

This would be an example of SMTP configuration using a Gmail account:

 * docker-compose:

```yaml
  suitecrm:
    image: bitnami/suitecrm:latest
    ports:
      - 80:80
    environment:
      - MARIADB_HOST=mariadb
      - MARIADB_PORT_NUMBER=3306
      - SUITECRM_DATABASE_USER=bn_suitecrm
      - SUITECRM_DATABASE_NAME=bitnami_suitecrm
      - SUITECRM_SMTP_HOST=smtp.gmail.com
      - SUITECRM_SMTP_USER=your_email@gmail.com
      - SUITECRM_SMTP_PASSWORD=your_password
      - SUITECRM_SMTP_PROTOCOL=TLS
      - SUITECRM_SMTP_PORT=587
```

 * For manual execution:

  ```bash
  $ docker run -d -p 80:80 -p 443:443 --name suitecrm  \
    -e MARIADB_HOST=mariadb \
    -e MARIADB_PORT_NUMBER=3306 \
    -e SUITECRM_DATABASE_USER=bn_suitecrm \
    -e SUITECRM_DATABASE_NAME=bitnami_suitecrm \
    -e SUITECRM_SMTP_HOST=smtp.gmail.com \
    -e SUITECRM_SMTP_PROTOCOL=TLS \
    -e SUITECRM_SMTP_PORT=587 \
    -e SUITECRM_SMTP_USER=your_email@gmail.com \
    -e SUITECRM_SMTP_PASSWORD=your_password
    --net suitecrm-tier \
    --volume /path/to/suitecrm-persistence:/bitnami \
    bitnami/suitecrm:latest
  ```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-suitecrm/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-suitecrm/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-suitecrm/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`$ docker version`)
- Output of `$ docker info`
- Version of this container (`$ echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright 2016-2018 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

 <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
