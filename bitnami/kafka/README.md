[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-kafka/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-kafka/tree/master)
[![Slack](http://slack.oss.bitnami.com/badge.svg)](http://slack.oss.bitnami.com)
[![Kubectl](https://img.shields.io/badge/kubectl-Available-green.svg)](https://raw.githubusercontent.com/bitnami/bitnami-docker-kafka/master/kubernetes.yml)

# What is Kafka?

> Apache Kafka is an open-source stream processing platform developed by the Apache Software Foundation written in Scala and Java. The project aims to provide a unified, high-throughput, low-latency platform for handling real-time data feeds. Its storage layer is essentially a "massively scalable pub/sub message queue architected as a distributed transaction log, making it highly valuable for enterprise infrastructures to process streaming data. Additionally, Kafka connects to external systems for data import/export


https://kafka.apache.org/

# TL;DR;

```bash
$ curl -LO https://raw.githubusercontent.com/bitnami/bitnami-docker-kafka/master/docker-compose.yml
$ docker-compose up
```

# Why use Bitnami Images ?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* Bitnami images are built on CircleCI and automatically pushed to the Docker Hub.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.

# Prerequisites

To run this application you need [Docker Engine](https://www.docker.com/products/docker-engine) >= `1.10.0`. [Docker Compose](https://www.docker.com/products/docker-compose) is recommended with a version `1.6.0` or later.

# How to use this image

Kafka requires access to a ZooKeeper service  to run. We'll use our very own [ZooKeeper image](https://www.github.com/bitnami/bitnami-docker-zookeeper).

## Using Docker Compose

The recommended way to run Kafka is using Docker Compose using the following `docker-compose.yml` template:

```yaml
version: '2'
services:
  zookeeper:
    image: 'bitnami/zookeeper:latest'
    volumes:
      - 'zookeeper_data:/var/zookeeper'
    ports:
      - '2181:2181'
  kafka:
    depends_on:
      - zookeeper
    image: 'bitnami/kafka:latest'
    volumes:
      - 'kafka_data:/bitnami/kafka'
    ports:
      - '9092:9092'
    environment:
      - KAFKA_PORT=9092
      - KAFKA_ADVERTISED_PORT=9092
      - KAFKA_ZOOKEEPER_CONNECT=zookeeper

volumes:
  zookeeper_data:
    driver: local
  kafka_data:
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
  $ docker network create kafka-tier
  ```

2. Create a volume for ZooKeeper persistence and create a ZooKeeper container

  ```bash
  $ docker volume create --name zookeeper_data
  $ docker run -d --name zookeeper - 2181:2181  \
    --net kafka-tier \
    --volume zookeeper_data:/bitnami/zookeeper \
    bitnami/zookeeper:latest
  ```

3. Create volumes for Kafka persistence and launch the container

  ```bash
  $ docker volume create --name kafka_data
  $ docker run -d --name kafka -p 9092:9092 \
    -e KAFKA_PORT=9092 \
    -e KAFKA_ADVERTISED_PORT=9092 \
    -e KAFKA_ZOOKEEPER_CONNECT=zookeeper \
    --net kafka-tier \
    --volume kafka_data:/bitnami/kafka \
    bitnami/kafka:latest
  ```

Access your application at your-ip:9092

## Persisting your application

For persistence of the Kafka deployment, the above examples define docker volume named `zookeeper_data`. The Kafka application state will persist as long as these volumes are not removed.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/userguide/containers/dockervolumes/#mount-a-host-directory-as-a-data-volume). Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

The following `docker-compose.yml` template demonstrates the use of host directories as data volumes.

```yaml
version: '2'

services:
  zookeeper:
    image: 'bitnami/zookeeper:latest'
    environment:
    ports:
      - '2181:2181'
    volumes:
      - /path/to/zookeeper-persistence:/bitnami/zookeeper
  kafka:
    image: bitnami/kafka:latest
    depends_on:
      - zookeeper
    ports:
      - '9092:9092'
    environment:
      - KAFKA_PORT=9092
      - KAFKA_ADVERTISED_PORT=9092
      - KAFKA_ZOOKEEPER_CONNECT=zookeeper
    volumes:
      - /path/to/kafka-persistence:/bitnami/kafka
```

### Mount host directories as data volumes using the Docker command line

1. Create a network (if it does not exist)
  ```bash
  $ docker network create kafka-tier
  ```

2. Create a ZooKeeper container with host volume
  ```bash
  $ docker run -d --name zookeeper \
    --net kafka-tier \
    --port 2181:2181 \
    --volume /path/to/zookeeper-persistence:/bitnami/zookeeper \
    bitnami/zookeeper:latest
  ```

3. Create the Kafka the container with host volumes
  ```bash
  $ docker run -d --name kafka -p 9092:9092 \
    -e KAFKA_PORT=9092 \
    -e KAFKA_ADVERTISED_PORT=9092 \
    -e KAFKA_ZOOKEEPER_CONNECT=zookeeper \
    --net kafka-tier \
    --volume /path/to/kafka-persistence:/bitnami/kafka \
    bitnami/kafka:latest
  ```

# Upgrading Kafka

Bitnami provides up-to-date versions of ZooKeeper and Kafka, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the Kafka container. For the ZooKeeper upgrade see https://github.com/bitnami/bitnami-docker-zookeeper/blob/master/README.md#upgrade-this-image

The `bitnami/kafka:latest` tag always points to the most recent release. To get the most recent release you can simple repull the `latest` tag from the Docker Hub with `docker pull bitnami/kafka:latest`. However it is recommended to use [tagged versions](https://hub.docker.com/r/bitnami/kafka/tags/).

Get the updated image:

```
$ docker pull bitnami/kafka:latest
```

## Using Docker Compose

1. Stop the running Kafka container
  ```bash
  $ docker-compose stop kafka
  ```

2. Remove the stopped container
  ```bash
  $ docker-compose rm kafka
  ```

3. Launch the updated Kafka image
  ```bash
  $ docker-compose start kafka
  ```

## Using Docker command line

1. Stop the running Kafka container
  ```bash
  $ docker stop kafka
  ```

2. Remove the stopped container
  ```bash
  $ docker rm kafka
  ```

3. Launch the updated Kafka image
  ```bash
  $ docker run -d --name kafka -p 9092:9092 \
    -e KAFKA_PORT=9092 \
    -e KAFKA_ADVERTISED_PORT=9092 \
    -e KAFKA_ZOOKEEPER_CONNECT=zookeeper \
    --net kafka-tier \
    --volume kafka_data:/bitnami/kafka \
    bitnami/kafka:latest
  ```

> **NOTE**:
>
> The above command assumes that local docker volumes are in use. Edit the command according to your usage.

# Configuration

## Environment variables

The Kafka instance can be customized by specifying environment variables on the first run. The environment values are 

##### User and Site configuration
- `WORDPRESS_USERNAME`: Kafka application username. Default: **user**
- `WORDPRESS_PASSWORD`: Kafka application password. Default: **bitnami**
- `WORDPRESS_EMAIL`: Kafka application email. Default: **user@example.com**
- `WORDPRESS_FIRST_NAME`: Kafka user first name. Default: **FirstName**
- `WORDPRESS_LAST_NAME`: Kafka user last name. Default: **LastName**
- `WORDPRESS_BLOG_NAME`: Kafka blog name. Default: **User's blog**

##### Use an existing database
- `MARIADB_HOST`: Hostname for ZooKeeper server. Default: **zookeeper**
- `MARIADB_PORT`: Port used by ZooKeeper server. Default: **3306**
- `WORDPRESS_DATABASE_NAME`: Database name that Kafka will use to connect with the database. Default: **bitnami_kafka**
- `WORDPRESS_DATABASE_USER`: Database user that Kafka will use to connect with the database. Default: **bn_kafka**
- `WORDPRESS_DATABASE_PASSWORD`: Database password that Kafka will use to connect with the database. No defaults.
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

##### Create a database for Kafka using mysql-client
- `MARIADB_HOST`: Hostname for ZooKeeper server. Default: **zookeeper**
- `MARIADB_PORT`: Port used by ZooKeeper server. Default: **3306**
- `MARIADB_ROOT_USER`: Database admin user. Default: **root**
- `MARIADB_ROOT_PASSWORD`: Database password for the `MARIADB_ROOT_USER` user. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_NAME`: New database to be created by the mysql client module. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_USER`: New database user to be created by the mysql client module. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_PASSWORD`: Database password for the `MYSQL_CLIENT_CREATE_DATABASE_USER` user. No defaults.
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

### Specifying Environment variables using Docker Compose

```yaml
version: '2'

services:
  zookeeper:
    image: 'bitnami/zookeeper:latest'
    environment:
      - MARIADB_USER=bn_kafka
      - MARIADB_DATABASE=bitnami_kafka
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - zookeeper_data:/bitnami/zookeeper
  kafka:
    image: bitnami/kafka:latest
    depends_on:
      - zookeeper
    ports:
      - '80:80'
      - '443:443'
    environment:
      - MARIADB_HOST=zookeeper
      - MARIADB_PORT=3306
      - WORDPRESS_DATABASE_USER=bn_kafka
      - WORDPRESS_DATABASE_NAME=bitnami_kafka
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - kafka_data:/bitnami/kafka
      - apache_data:/bitnami/apache
      - php_data:/bitnami/php

volumes:
  zookeeper_data:
    driver: local
  kafka_data:
    driver: local
  apache_data:
    driver: local
  php_data:
    driver: local
```

### Specifying Environment variables on the Docker command line

```bash
$ docker run -d --name kafka -p 9092:9092 \
  --net kafka-tier \
  -e ALLOW_EMPTY_PASSWORD=yes \
  -e WORDPRESS_DATABASE_USER=bn_kafka \
  -e WORDPRESS_DATABASE_NAME=bitnami_kafka \
  -e WORDPRESS_PASSWORD=my_password \
  --volume kafka_data:/bitnami/kafka \
  --volume apache_data:/bitnami/apache \
  --volume php_data:/bitnami/php \
  bitnami/kafka:latest
```

### SMTP Configuration

To configure Kafka to send email using SMTP you can set the following environment variables:
- `SMTP_HOST`: Host for outgoing SMTP email. No defaults.
- `SMTP_PORT`: Port for outgoing SMTP email. No defaults.
- `SMTP_USER`: User of SMTP used for authentication (likely email). No defaults.
- `SMTP_PASSWORD`: Password for SMTP. No defaults.
- `SMTP_PROTOCOL`: Secure connection protocol to use for SMTP [tls, ssl, none]. No defaults.

This would be an example of SMTP configuration using a GMail account:

 * docker-compose (application part):

```yaml
  kafka:
    image: bitnami/kafka:latest
    ports:
      - 80:80
      - 443:443
    environment:
      - MARIADB_HOST=zookeeper
      - MARIADB_PORT=3306
      - WORDPRESS_DATABASE_USER=bn_kafka
      - WORDPRESS_DATABASE_NAME=bitnami_kafka
      - SMTP_HOST=smtp.gmail.com
      - SMTP_PORT=587
      - SMTP_USER=your_email@gmail.com
      - SMTP_PASSWORD=your_password
      - SMTP_PROTOCOL=tls
    volumes:
      - kafka_data:/bitnami/kafka
```

* For manual execution:

```
$ docker run -d --name kafka -p 9092:9092 \
  --net kafka-tier \
  --env SMTP_HOST=smtp.gmail.com --env SMTP_PORT=587 \
  --env SMTP_USER=your_email@gmail.com --env SMTP_PASSWORD=your_password \
  --env ALLOW_EMPTY_PASSWORD=yes --env WORDPRESS_DATABASE_USER=bn_kafka \
  --env WORDPRESS_DATABASE_NAME=bitnami_kafka \
  --volume kafka_data:/bitnami/kafka \
  bitnami/kafka:latest
```

### Connect Kafka docker container to an existing database

The Bitnami Kafka container supports connecting the Kafka application to an external database. In order to configure it, you should set the following environment variables:
- `MARIADB_HOST`: Hostname for ZooKeeper server. Default: **zookeeper**
- `MARIADB_PORT`: Port used by ZooKeeper server. Default: **3306**
- `WORDPRESS_DATABASE_NAME`: Database name that Kafka will use to connect with the database. Default: **bitnami_kafka**
- `WORDPRESS_DATABASE_USER`: Database user that Kafka will use to connect with the database. Default: **bn_kafka**
- `WORDPRESS_DATABASE_PASSWORD`: Database password that Kafka will use to connect with the database. No defaults.

This would be an example of using an external database for Kafka.

 * docker-compose:

```yaml
  kafka:
    image: bitnami/kafka:latest
    ports:
      - 80:80
      - 443:443
    environment:
      - MARIADB_HOST=zookeeper_host
      - MARIADB_PORT=3306
      - WORDPRESS_DATABASE_NAME=kafka_db
      - WORDPRESS_DATABASE_USER=kafka_user
      - WORDPRESS_DATABASE_PASSWORD=kafka_password
    volumes:
      - kafka_data:/bitnami/kafka
      - apache_data:/bitnami/apache
      - php_data:/bitnami/php
```

* For manual execution:

```
$ docker run -d --name kafka -p 9092:9092 \
  --net kafka-tier \
  --env MARIADB_HOST=zookeeper_host \
  --env MARIADB_PORT=3306 \
  --env WORDPRESS_DATABASE_NAME=kafka_db \
  --env WORDPRESS_DATABASE_USER=kafka_user \
  --env WORDPRESS_DATABASE_PASSWORD=kafka_password \
  --volume kafka_data:/bitnami/kafka \
  --volume apache_data:/bitnami/apache \
  --volume php_data:/bitnami/php \
  bitnami/kafka:latest
```

# Backing up your application

To backup your application data follow these steps:

## Backing up using Docker Compose

1. Stop the Kafka container:
  ```bash
  $ docker-compose stop kafka
  ```

2. Copy the Kafka, PHP and Apache data
  ```bash
  $ docker cp $(docker-compose ps -q kafka):/bitnami/kafka/ /path/to/backups/kafka/latest/
  $ docker cp $(docker-compose ps -q kafka):/bitnami/apache/ /path/to/backups/apache/latest/
  $ docker cp $(docker-compose ps -q kafka):/bitnami/php/ /path/to/backups/php/latest/
  ```

3. Start the Kafka container
  ```bash
  $ docker-compose start kafka
  ```

## Backing up using the Docker command line

1. Stop the Kafka container:
  ```bash
  $ docker stop kafka
  ```

2. Copy the Kafka, PHP and Apache data
  ```bash
  $ docker cp kafka:/bitnami/kafka/ /path/to/backups/kafka/latest/
  $ docker cp kafka:/bitnami/apache/ /path/to/backups/apache/latest/
  $ docker cp kafka:/bitnami/php/ /path/to/backups/php/latest/
  ```

3. Start the Kafka container
  ```bash
  $ docker start kafka
  ```

# Restoring a backup

To restore your application using backed up data simply mount the folder with Kafka and Apache data in the container. See [persisting your application](#persisting-your-application) section for more info.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-kafka/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-kafka/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-kafka/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`$ docker version`)
- Output of `$ docker info`
- Version of this container (`$ echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# Community

Most real time communication happens in the `#containers` channel at [bitnami-oss.slack.com](http://bitnami-oss.slack.com); you can sign up at [slack.oss.bitnami.com](http://slack.oss.bitnami.com).

Discussions are archived at [bitnami-oss.slackarchive.io](https://bitnami-oss.slackarchive.io).

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
