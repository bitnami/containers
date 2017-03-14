[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-dreamfactory/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-dreamfactory/tree/master)
[![Docker Hub Automated Build](http://container.checkforupdates.com/badges/bitnami/dreamfactory)](https://hub.docker.com/r/bitnami/dreamfactory/)

# What is DreamFactory?

> DreamFactory is an open source REST API for mobile enterprise application developers. Add a REST API to any backend system. Services include SQL, NoSQL, BLOB, email, users, roles, security, and integration. Whether you’re building a native or web-based app, DreamFactory developers can focus on creating great front-ends to their apps, then leaving all the backend work to DreamFactory.

https://www.dreamfactory.com/

# TL;DR;

```bash
$ curl -LO https://raw.githubusercontent.com/bitnami/bitnami-docker-dreamfactory/master/docker-compose.yml
$ docker-compose up
```

# Prerequisites

To run this application you need [Docker Engine](https://www.docker.com/products/docker-engine) >= `1.10.0`. [Docker Compose](https://www.docker.com/products/docker-compose) is recommended with a version `1.6.0` or later.

# How to use this image

DreamFactory requires access to a MySQL database or MariaDB database to store information. We'll use our very own [MariaDB image](https://www.github.com/bitnami/bitnami-docker-mariadb) for the database requirements. It also uses our [MongoDB image] (https://www.github.com/bitnami/bitnami-docker-mongodb) and [Redis image] (https://www.github.com/bitnami/bitnami-docker-redis).

## Using Docker Compose

The recommended way to run DreamFactory is using Docker Compose using the following `docker-compose.yml` template:

```yaml
version: '2'

services:
  mariadb:
    image: bitnami/mariadb:latest
    volumes:
      - mariadb_data:/bitnami/mariadb
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
  mongodb:
    image: 'bitnami/mongodb:latest'
    volumes:
      - 'mongodb_data:/bitnami/mongodb'
  redis:
    image: 'bitnami/redis:latest'
    volumes:
      - 'redis_data:/bitnami/redis'
  dreamfactory:
    image: bitnami/dreamfactory:latest
    depends_on:
      - mariadb
      - mongodb
      - redis
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - dreamfactory_data:/bitnami/dreamfactory
      - apache_data:/bitnami/apache
      - php_data:/bitnami/php

volumes:
  mariadb_data:
    driver: local
  mongodb_data:
    driver: local
  redis_data:
    driver: local
  dreamfactory_data:
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
$ docker network create dreamfactory-tier
```

2. Create a volume for MariaDB persistence and create a MariaDB container

```bash
$ docker volume create --name mariadb_data
$ docker run -d --name mariadb -e ALLOW_EMPTY_PASSWORD=yes\
  --net dreamfactory-tier \
  --volume mariadb_data:/bitnami/mariadb \
  bitnami/mariadb:latest
```

3. Create a volume for MongoDB persistence and create a MongoDB container

```bash
$ docker volume create --name mongodb_data
$ docker run -d --name mongodb \
  --net dreamfactory-tier \
  --volume mongodb_data:/bitnami/mongodb \
  bitnami/mongodb:latest
```

4. Create a volume for Redis persistence and create a Redis container

```bash
$ docker volume create --name redis_data
$ docker run -d --name redis \
  --net dreamfactory-tier \
  --volume redis_data:/bitnami/redis \
  bitnami/redis:latest
```

5. Create volumes for DreamFactory persistence and launch the container

```bash
$ docker volume create --name dreamfactory_data
$ docker volume create --name apache_data
$ docker volume create --name php_data
$ docker run -d --name dreamfactory -p 80:80 -p 443:443 \
  --net dreamfactory-tier \
  --volume dreamfactory_data:/bitnami/dreamfactory \
  --volume apache_data:/bitnami/apache \
  --volume php_data:/bitnami/php \
  bitnami/dreamfactory:latest
```

Access your application at http://your-ip/

## Persisting your application

For persistence of the DreamFactory deployment, the above examples define docker volumes namely `mariadb_data`, `mongodb_data`, `redis_data`, `dreamfactory_data`, `apache_data` and `php_data`. The DreamFactory application state will persist as long as these volumes are not removed.

If avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/userguide/containers/dockervolumes/#mount-a-host-directory-as-a-data-volume). Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

The following `docker-compose.yml` template demonstrates the use of host directories as data volumes.

```yaml
version: '2'

services:
  mariadb:
    image: bitnami/mariadb:latest
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - /path/to/mariadb-persistence:/bitnami/mariadb
  mongodb:
    image: 'bitnami/mongodb:latest'
    volumes:
      - '/path/to/your/local/mongodb_data:/bitnami/mongodb'
  redis:
    image: 'bitnami/redis:latest'
    volumes:
      - '/path/to/your/local/redis_data:/bitnami/redis'
  dreamfactory:
    image: bitnami/dreamfactory:latest
    depends_on:
      - mariadb
      - mongodb
      - redis
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - /path/to/dreamfactory-persistence:/bitnami/dreamfactory
      - /path/to/apache-persistence:/bitnami/apache
      - /path/to/php-persistence:/bitnami/php
```

### Mount host directories as data volumes using the Docker command line

1. Create a network (if it does not exist)

```bash
$ docker network create dreamfactory-tier
```

2. Create a MariaDB container with host volume

```bash
$ docker run -d --name mariadb -e ALLOW_EMPTY_PASSWORD=yes \
  --net dreamfactory-tier \
  --volume /path/to/mariadb-persistence:/bitnami/mariadb \
  bitnami/mariadb:latest
```

3. Create a MongoDB container with host volume

```bash
$ docker run -d --name mongodb \
  --net dreamfactory-tier \
  --volume /path/to/mongodb-persistence:/bitnami/mongodb \
  bitnami/mongodb:latest
```


4. Create a Redis container with host volume

```bash
$ docker run -d --name redis \
  --net dreamfactory-tier \
  --volume /path/to/redis-persistence:/bitnami/redis \
  bitnami/redis:latest
```

5. Create the DreamFactory the container with host volumes

```bash
$ docker run -d --name dreamfactory -p 80:80 -p 443:443 \
  --net dreamfactory-tier \
  --volume /path/to/dreamfactory-persistence:/bitnami/dreamfactory \
  --volume /path/to/apache-persistence:/bitnami/apache \
  --volume /path/to/php-persistence:/bitnami/php \
  bitnami/dreamfactory:latest
```

# Upgrading DreamFactory

Bitnami provides up-to-date versions of MariaDB, MongoDB, Redis and DreamFactory, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the DreamFactory container. For the MariaDB upgrade see https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#upgrade-this-image. For the MongoDB upgrade see https://github.com/bitnami/bitnami-docker-mongodb/blob/master/README.md#upgrade-this-image. For the Redis upgrade see https://github.com/bitnami/bitnami-docker-redis/blob/master/README.md#upgrade-this-image

The `bitnami/dreamfactory:latest` tag always points to the most recent release. To get the most recent release you can simple repull the `latest` tag from the Docker Hub with `docker pull bitnami/dreamfactory:latest`. However it is recommended to use [tagged versions](https://hub.docker.com/r/bitnami/dreamfactory/tags/).

Get the updated image:

```
$ docker pull bitnami/dreamfactory:latest
```

## Using Docker Compose

1. Stop the running DreamFactory container

```bash
$ docker-compose stop dreamfactory
```

2. Remove the stopped container

```bash
$ docker-compose rm dreamfactory
```

3. Launch the updated DreamFactory image

```bash
$ docker-compose start dreamfactory
```

## Using Docker command line

1. Stop the running DreamFactory container

```bash
$ docker stop dreamfactory
```

2. Remove the stopped container

```bash
$ docker rm dreamfactory
```

3. Launch the updated DreamFactory image

```bash
$ docker run -d --name dreamfactory -p 80:80 -p 443:443 \
  --net dreamfactory-tier \
  --volume dreamfactory_data:/bitnami/dreamfactory \
  --volume apache_data:/bitnami/apache \
  --volume php_data:/bitnami/php \
  bitnami/dreamfactory:latest
```

> **NOTE**:
>
> The above command assumes that local docker volumes are in use. Edit the command according to your usage.

# Configuration

## Environment variables

The DreamFactory instance can be customized by specifying environment variables on the first run. The following environment values are provided to custom DreamFactory:

- `MARIADB_USER`: Root user for the MariaDB database. Default: **root**
- `MARIADB_PASSWORD`: Root password for the MariaDB.
- `MARIADB_HOST`: Hostname for MariaDB server. Default: **mariadb**
- `MARIADB_PORT`: Port used by MariaDB server. Default: **3306**
- `MONGODB_HOST`: Hostname for Mongodb server. Default: **mongodb**
- `MONGODB_PORT`: Port used by Mongodb server. Default: **27017**
- `REDIS_HOST`: Hostname for Redis. Default: **redis**
- `REDIS_PORT`: Port used by Redis. Default: **6379**
- `REDIS_PASSWORD`: Password for Redis.
- `SMTP_HOST`: Hostname for the SMTP server (necessary for sending e-mails from the application).
- `SMTP_PORT`: Port for the SMTP server.
- `SMTP_USER`: Username for the SMTP server.
- `SMTP_PASSWORD`: SMTP account password.

### Specifying Environment variables using Docker Compose

```yaml
version: '2'

services:
  mariadb:
    image: bitnami/mariadb:latest
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - mariadb_data:/bitnami/mariadb
  mongodb:
    image: bitnami/mongodb:latest
    volumes:
      - mongodb_data:/bitnami/mongodb
  redis:
    image: bitnami/redis:latest
    volumes:
      - redis_data:/bitnami/mariadb
  dreamfactory:
    image: bitnami/dreamfactory:latest
    depends_on:
      - mariadb
      - mongodb
      - redis
    ports:
      - '80:80'
      - '443:443'
    environment:
      - DREAMFACTORY_PASSWORD=my_password
    volumes:
      - dreamfactory_data:/bitnami/dreamfactory
      - apache_data:/bitnami/apache
      - php_data:/bitnami/php

volumes:
  mariadb_data:
    driver: local
  mongodb_data:
    driver: local
  redis_data:
    driver: local
  dreamfactory_data:
    driver: local
  apache_data:
    driver: local
  php_data:
    driver: local
```

### Specifying Environment variables on the Docker command line

```bash
$ docker run -d --name dreamfactory -p 80:80 -p 443:443 \
  --net dreamfactory-tier \
  --env DREAMFACTORY_PASSWORD=my_password \
  --volume dreamfactory_data:/bitnami/dreamfactory \
  --volume apache_data:/bitnami/apache \
  --volume php_data:/bitnami/php \
  bitnami/dreamfactory:latest
```

# Backing up your application

To backup your application data follow these steps:

## Backing up using Docker Compose

1. Stop the DreamFactory container:

```bash
$ docker-compose stop dreamfactory
```

2. Copy the DreamFactory, Apache and PHP data

```bash
$ docker cp $(docker-compose ps -q dreamfactory):/bitnami/dreamfactory/ /path/to/backups/dreamfactory/latest/
$ docker cp $(docker-compose ps -q dreamfactory):/bitnami/apache/ /path/to/backups/apache/latest/
$ docker cp $(docker-compose ps -q dreamfactory):/bitnami/php/ /path/to/backups/php/latest/
```

3. Start the DreamFactory container

```bash
$ docker-compose start dreamfactory
```

## Backing up using the Docker command line

1. Stop the DreamFactory container:

```bash
$ docker stop dreamfactory
```

2. Copy the DreamFactory, Apache and PHP data

```bash
$ docker cp dreamfactory:/bitnami/dreamfactory/ /path/to/backups/dreamfactory/latest/
$ docker cp dreamfactory:/bitnami/apache/ /path/to/backups/apache/latest/
$ docker cp dreamfactory:/bitnami/php/ /path/to/backups/php/latest/
```

3. Start the DreamFactory container

```bash
$ docker start dreamfactory
```

# Restoring a backup

To restore your application using backed up data simply mount the folder with DreamFactory, Apache and PHP data in the container. See [persisting your application](#persisting-your-application) section for more info.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-dreamfactory/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-dreamfactory/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-dreamfactory/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright 2015-2016 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
