[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-osclass/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-osclass/tree/master)
[![Docker Hub Automated Build](http://container.checkforupdates.com/badges/bitnami/osclass)](https://hub.docker.com/r/bitnami/osclass/)

# What is Osclass?

> Osclass is a php script that allows you to quickly create and manage your own free classifieds site. Using this script, you can provide free advertising for items for sale, real estate, jobs, cars... Hundreds of free classified advertising sites are using Osclass. Visit our demo and post a free ad to see Osclass in action.

https://osclass.org/

# TLDR

```bash
$ docker-compose up -d
```

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
    image: bitnami/mariadb:latest
    volumes:
      - mariadb_data:/bitnami/mariadb
  osclass:
    image: bitnami/osclass:latest
    depends_on:
      - mariadb
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - osclass_data:/bitnami/osclass
      - apache_data:/bitnami/apache

volumes:
  mariadb_data:
    driver: local
  osclass_data:
    driver: local
  apache_data:
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
  $ docker network create osclass-tier
  ```

2. Create a volume for MariaDB persistence and create a MariaDB container

  ```bash
  $ docker volume create --name mariadb_data
  $ docker run -d --name mariadb \
    --net osclass-tier \
    --volume mariadb_data:/bitnami/mariadb \
    bitnami/mariadb:latest
  ```

3. Create volumes for Osclass persistence and launch the container

  ```bash
  $ docker volume create --name osclass_data
  $ docker volume create --name apache_data
  $ docker run -d --name osclass -p 80:80 -p 443:443 \
    --net osclass-tier \
    --volume osclass_data:/bitnami/osclass \
    --volume apache_data:/bitnami/apache \
    bitnami/osclass:latest
  ```

Access your application at http://your-ip/

## Persisting your application

For persistence of the Osclass deployment, the above examples define docker volumes namely `mariadb_data`, `osclass_data` and `apache_data`. The Osclass application state will persist as long as these volumes are not removed.

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
  osclass:
    image: bitnami/osclass:latest
    depends_on:
      - mariadb
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - /path/to/osclass-persistence:/bitnami/osclass
      - /path/to/apache-persistence:/bitnami/apache
```

### Mount host directories as data volumes using the Docker command line

1. Create a network (if it does not exist)
  ```bash
  $ docker network create osclass-tier
  ```

2. Create a MariaDB container with host volume
  ```bash
  $ docker run -d --name mariadb \
    --net osclass-tier \
    --volume /path/to/mariadb-persistence:/bitnami/mariadb \
    bitnami/mariadb:latest
  ```

3. Create the Osclass the container with host volumes
  ```bash
  $ docker run -d --name osclass -p 80:80 -p 443:443 \
    --net osclass-tier \
    --volume /path/to/osclass-persistence:/bitnami/osclass \
    --volume /path/to/apache-persistence:/bitnami/apache \
    bitnami/osclass:latest
  ```

# Upgrading Osclass

Bitnami provides up-to-date versions of MariaDB and Osclass, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the Osclass container. For the MariaDB upgrade see https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#upgrade-this-image

The `bitnami/osclass:latest` tag always points to the most recent release. To get the most recent release you can simple repull the `latest` tag from the Docker Hub with `docker pull bitnami/osclass:latest`. However it is recommended to use [tagged versions](https://hub.docker.com/r/bitnami/osclass/tags/).

Get the updated image:

```
$ docker pull bitnami/osclass:latest
```

## Using Docker Compose

1. Stop the running Osclass container
  ```bash
  $ docker-compose stop osclass
  ```

2. Remove the stopped container
  ```bash
  $ docker-compose rm osclass
  ```

3. Launch the updated Osclass image
  ```bash
  $ docker-compose start osclass
  ```

## Using Docker command line

1. Stop the running Osclass container
  ```bash
  $ docker stop osclass
  ```

2. Remove the stopped container
  ```bash
  $ docker rm osclass
  ```

3. Launch the updated Osclass image
  ```bash
  $ docker run -d --name osclass -p 80:80 -p 443:443 \
    --net osclass-tier \
    --volume osclass_data:/bitnami/osclass \
    --volume apache_data:/bitnami/apache \
    bitnami/osclass:latest
  ```

> **NOTE**:
>
> The above command assumes that local docker volumes are in use. Edit the command according to your usage.

# Configuration

## Environment variables

The Osclass instance can be customized by specifying environment variables on the first run. The following environment values are provided to custom Osclass:

- `OSCLASS_USERNAME`: Osclass application username. Default: **user**
- `OSCLASS_PASSWORD`: Osclass application password. Default: **bitnami1**
- `OSCLASS_EMAIL`: Osclass application email. Default: **user@example.com**
- `OSCLASS_WEB_TITLE`: Osclass application title. Default: **Sample Web Page**
- `OSCLASS_HOST`: Osclass application IP or domain. Default: **127.0.0.1**
- `OSCLASS_PING_ENGINES`: Allow site to appear in search engines. Default: **1**
- `OSCLASS_SAVE_STATS`: Automatically send usage statistics and crash reports to Osclass. Default: **1**
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
  osclass:
    image: bitnami/osclass:latest
    depends_on:
      - mariadb
    ports:
      - '80:80'
      - '443:443'
    environment:
      - OSCLASS_PASSWORD=my_password
    volumes:
      - osclass_data:/bitnami/osclass
      - apache_data:/bitnami/apache

volumes:
  mariadb_data:
    driver: local
  osclass_data:
    driver: local
  apache_data:
    driver: local
```

### Specifying Environment variables on the Docker command line

```bash
$ docker run -d --name osclass -p 80:80 -p 443:443 \
  --net osclass-tier \
  --env OSCLASS_PASSWORD=my_password \
  --volume osclass_data:/bitnami/osclass \
  --volume apache_data:/bitnami/apache \
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

```
  osclass:
    image: bitnami/osclass:latest
    ports:
      - 80:80
    environment:
      - SMTP_HOST=smtp.gmail.com
      - SMTP_PORT=587
      - SMTP_USER=your_email@gmail.com
      - SMTP_PASSWORD=your_password
      - SMTP_PROTOCOL=tls
    volumes:
      - osclass_data:/bitnami/osclass
```

* For manual execution:

```
$ docker run -d --name osclass -p 80:80 -p 443:443 \
  --net osclass-tier \
  --env SMTP_HOST=smtp.gmail.com --env SMTP_PORT=587 --env SMTP_PROTOCOL=tls \
  --env SMTP_USER=your_email@gmail.com --env SMTP_PASSWORD=your_password \
  --volume osclass_data:/bitnami/osclass \
  bitnami/osclass:latest
```


# Backing up your application

To backup your application data follow these steps:

## Backing up using Docker Compose

1. Stop the Osclass container:
  ```bash
  $ docker-compose stop osclass
  ```

2. Copy the Osclass and Apache data
  ```bash
  $ docker cp $(docker-compose ps -q osclass):/bitnami/osclass/ /path/to/backups/osclass/latest/
  $ docker cp $(docker-compose ps -q osclass):/bitnami/apache/ /path/to/backups/apache/latest/
  ```

3. Start the Osclass container
  ```bash
  $ docker-compose start osclass
  ```

## Backing up using the Docker command line

1. Stop the Osclass container:
  ```bash
  $ docker stop osclass
  ```

2. Copy the Osclass and Apache data
  ```bash
  $ docker cp osclass:/bitnami/osclass/ /path/to/backups/osclass/latest/
  $ docker cp osclass:/bitnami/apache/ /path/to/backups/apache/latest/
  ```

3. Start the Osclass container
  ```bash
  $ docker start osclass
  ```

# Restoring a backup

To restore your application using backed up data simply mount the folder with Osclass and Apache data in the container. See [persisting your application](#persisting-your-application) section for more info.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-osclass/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-osclass/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-osclass/issues). For us to provide better support, be sure to include the following information in your issue:

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
