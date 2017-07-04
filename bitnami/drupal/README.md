[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-drupal/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-drupal/tree/master)
[![Slack](https://img.shields.io/badge/slack-join%20chat%20%E2%86%92-e01563.svg)](http://slack.oss.bitnami.com)
[![Kubectl](https://img.shields.io/badge/kubectl-Available-green.svg)](https://raw.githubusercontent.com/bitnami/bitnami-docker-drupal/master/kubernetes.yml)

# What is Drupal?

> Drupal is one of the most versatile open source content management systems on the market. Drupal is built for high performance and is scalable to many servers, has easy integration via REST, JSON, SOAP and other formats, and features a whopping 15,000 plugins to extend and customize the application for just about any type of website.

https://www.drupal.org/

# TL;DR;

## Docker Compose

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-drupal/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

## Kubernetes

> **WARNING:** This is a beta configuration, currently unsupported.

Get the raw URL pointing to the `kubernetes.yml` manifest and use `kubectl` to create the resources on your Kubernetes cluster like so:

```bash
$ kubectl create -f https://raw.githubusercontent.com/bitnami/bitnami-docker-drupal/master/kubernetes.yml
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* Bitnami images are built on CircleCI and automatically pushed to the Docker Hub.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.

# Prerequisites

To run this application you need Docker Engine 1.10.0. Docker Compose is recommended with a version 1.6.0 or later.

# How to use this image

## Run Drupal with a Database Container

Running Drupal with a database server is the recommended way. You can either use docker-compose or run the containers manually.

### Run the application using Docker Compose

This is the recommended way to run Drupal. You can use the following `docker-compose.yml` template:

```yaml
version: '2'

services:
  mariadb:
    image: 'bitnami/mariadb:latest'
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - 'mariadb_data:/bitnami'

  drupal:
    image: 'bitnami/drupal:latest'
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - 'drupal_data:/bitnami'
    depends_on:
      - mariadb

volumes:
  mariadb_data:
    driver: local
  drupal_data:
    driver: local
```

### Run the application manually

If you want to run the application manually instead of using docker-compose, these are the basic steps you need to run:

1. Create a new network for the application and the database:

  ```bash
  $ docker network create drupal-tier
  ```

2. Start a MariaDB database in the network generated:

  ```bash
  $ docker run -d --name mariadb -e ALLOW_EMPTY_PASSWORD=yes --net drupal-tier bitnami/mariadb:latest
  ```

  *Note:* You need to give the container a name in order to Drupal to resolve the host

3. Run the Drupal container:

  ```bash
  $ docker run -d -p 80:80 -p 443:443 --name drupal --net drupal-tier bitnami/drupal:latest
  ```

Then you can access your application at http://your-ip/

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. Additionally you should mount a volume for [persistence of the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#persisting-your-database).

The above examples define docker volumes namely `mariadb_data` and `drupal_data`. The Drupal application state will persist as long as these volumes are not removed.

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
    volumes:
      - '/path/to/mariadb-persistence:/bitnami'
  drupal:
    image: 'bitnami/drupal:latest'
    depends_on:
      - mariadb
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - '/path/to/drupal-persistence:/bitnami'
```

### Mount host directories as data volumes using the Docker command line

1. Create a network (if it does not exist):

  ```bash
  $ docker network create drupal-tier
  ```

2. Create a MariaDB container with host volume:

  ```bash
  $ docker run -d --name mariadb -e ALLOW_EMPTY_PASSWORD=yes \
    --net drupal-tier \
    --volume /path/to/mariadb-persistence:/bitnami \
    bitnami/mariadb:latest
  ```

  *Note:* You need to give the container a name in order to Drupal to resolve the host

3. Create the Drupal container with host volumes:

  ```bash
  $ docker run -d --name drupal -p 80:80 -p 443:443 \
    --net drupal-tier \
    --volume /path/to/drupal-persistence:/bitnami \
    bitnami/drupal:latest
  ```

# Upgrade this application

Bitnami provides up-to-date versions of MariaDB and Drupal, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the Drupal container. For the MariaDB upgrade see https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#upgrade-this-image

1. Get the updated images:

  ```bash
  $ docker pull bitnami/drupal:latest
  ```

2. Stop your container

 * For docker-compose: `$ docker-compose stop drupal`
 * For manual execution: `$ docker stop drupal`

3. Take a snapshot of the application state

```bash
$ rsync -a /path/to/drupal-persistence /path/to/drupal-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

Additionally, [snapshot the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#step-2-stop-and-backup-the-currently-running-container)

You can use these snapshots to restore the application state should the upgrade fail.

4. Remove the stopped container

 * For docker-compose: `$ docker-compose rm drupal`
 * For manual execution: `$ docker rm drupal`

5. Run the new image

 * For docker-compose: `$ docker-compose start drupal`
 * For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name drupal bitnami/drupal:latest`

# Configuration

## Environment variables

When you start the drupal image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the docker run command line. If you want to add a new environment variable:

 * For docker-compose add the variable name and value under the application section:

```yaml
drupal:
  image: bitnami/drupal:latest
  ports:
    - 80:80
    - 443:443
  environment:
    - DRUPAL_PASSWORD=my_password
```

 * For manual execution add a `-e` option with each variable and value:

  ```bash
  $ docker run -d --name drupal -p 80:80 -p 443:443 \
    -e DRUPAL_PASSWORD=my_password \
    --net drupal-tier \
    --volume /path/to/drupal-persistence:/bitnami \
    bitnami/drupal:latest
  ```

Available variables:

 - `DRUPAL_USERNAME`: Drupal application username. Default: **user**
 - `DRUPAL_PASSWORD`: Drupal application password. Default: **bitnami**
 - `DRUPAL_EMAIL`: Drupal application email. Default: **user@example.com**
 - `MARIADB_USER`: Root user for the MariaDB database. Default: **root**
 - `MARIADB_PASSWORD`: Root password for the MariaDB.
 - `MARIADB_HOST`: Hostname for MariaDB server. Default: **mariadb**
 - `MARIADB_PORT_NUMBER`: Port used by MariaDB server. Default: **3306**

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-drupal/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-drupal/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-drupal/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`$ docker version`)
- Output of `$ docker info`
- Version of this container (`$ echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive
information)

# Community

Most real time communication happens in the `#containers` channel at [bitnami-oss.slack.com](http://bitnami-oss.slack.com); you can sign up at [slack.oss.bitnami.com](http://slack.oss.bitnami.com).

Discussions are archived at [bitnami-oss.slackarchive.io](https://bitnami-oss.slackarchive.io).

# License

Copyright 2015-2017 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
