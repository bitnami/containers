[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-piwik/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-piwik/tree/master)
[![Slack](https://img.shields.io/badge/slack-join%20chat%20%E2%86%92-e01563.svg)](http://slack.oss.bitnami.com)
[![Kubectl](https://img.shields.io/badge/kubectl-Available-green.svg)](https://raw.githubusercontent.com/bitnami/bitnami-docker-piwik/master/kubernetes.yml)

# What is Piwik?

> Piwik is a free and open source web analytics application written by a team of international developers that runs on a PHP/MySQL webserver. It tracks online visits to one or more websites and displays reports on these visits for analysis. As of September 2015, Piwik was used by nearly 900 thousand websites, or 1.3% of all websites, and has been translated to more than 45 languages. New versions are regularly released every few weeks.

https://www.piwik.org/

# TL;DR;

## Docker Compose

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-piwik/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

## Kubernetes

> **WARNING:** This is a beta configuration, currently unsupported.

Get the raw URL pointing to the `kubernetes.yml` manifest and use `kubectl` to create the resources on your Kubernetes cluster like so:

```bash
$ kubectl create -f https://raw.githubusercontent.com/bitnami/bitnami-docker-piwik/master/kubernetes.yml
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* Bitnami images are built on CircleCI and automatically pushed to the Docker Hub.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.

# Prerequisites

To run this application you need [Docker Engine](https://www.docker.com/products/docker-engine) >= `1.10.0`. [Docker Compose](https://www.docker.com/products/docker-compose) is recommended with a version `1.6.0` or later.

# How to get this image

The recommended way to get the Bitnami Piwik Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/piwik/).
To use a specific version, you can pull a versioned tag. Find the [list of available versions] (https://hub.docker.com/r/bitnami/piwik/tags/) in the Docker Hub Registry.

```bash
docker pull bitnami/piwik:[TAG]
```

If you wish, you can also build the image youself.

```bash
docker build -t bitnami/piwik:latest https://github.com/bitnami/bitnami-docker-piwik.git
```

# How to use this image

Piwik requires access to a MySQL database or MariaDB database to store information. It uses our [MariaDB image] (https://github.com/bitnami/bitnami-docker-mariadb) for the database requirements.

## Run the Piwik image using Docker Compose

This is the recommended way to run Piwik. You can use the following docker compose template:

```yaml
version: '2'

services:
  mariadb:
    image: 'bitnami/mariadb:latest'
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - 'mariadb_data:/bitnami'
  application:
    image: 'bitnami/piwik:latest'
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - 'piwik_data:/bitnami'
    depends_on:
      - mariadb

volumes:
  mariadb_data:
    driver: local
  piwik_data:
    driver: local
```

## Run the Piwik image using the Docker Command Line

If you want to run the application manually instead of using docker-compose, these are the basic steps you need to run:

1. Create a new network for the application and the database:

  ```bash
  $ docker network create piwik_network
  ```

2. Start a MariaDB database in the network generated:

  ```
   $ docker run -d --name mariadb -e ALLOW_EMPTY_PASSWORD=yes --net=piwik_network bitnami/mariadb
  ```

  *Note:* You need to give the container a name in order to Piwik to resolve the host

3. Run the Piwik container:

  ```bash
  $ docker run -d -p 80:80 --name piwik --net=piwik_network bitnami/piwik
  ```

Then you can access your application at http://your-ip/

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. Additionally you should mount a volume for [persistence of the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#persisting-your-database).

The above examples define docker volumes namely `mariadb_data` and `piwik_data`. The Piwik application state will persist as long as these volumes are not removed.

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
  piwik:
    image: 'bitnami/piwik:latest'
    depends_on:
      - mariadb
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - '/path/to/piwik-persistence:/bitnami'
```

### Mount host directories as data volumes using the Docker command line

In this case you need to specify the directories to mount on the run command. The process is the same than the one previously shown:

1. Create a network (if it does not exist):

  ```bash
  $ docker network create piwik-tier
  ```

2. Create a MariaDB container with host volume:

  ```bash
  $ docker run -d --name mariadb -e ALLOW_EMPTY_PASSWORD=yes \
    --net piwik-tier \
    --volume /path/to/mariadb-persistence:/bitnami \
    bitnami/mariadb:latest
  ```
   *Note:* You need to give the container a name in order to Piwik to resolve the host

3. Create the Piwik container with host volumes:

  ```bash
  $ docker run -d --name piwik -p 80:80 -p 443:443 \
    --net piwik-tier \
    --volume /path/to/piwik-persistence:/bitnami \
    bitnami/piwik:latest
  ```

# Upgrading Piwik

Bitnami provides up-to-date versions of MariaDB and Piwik, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the Piwik container. For the MariaDB upgrade you can take a look at https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#upgrade-this-image

1. Get the updated images:

  ```bash
  $ docker pull bitnami/piwik:latest
  ```

2. Stop your container

 * For docker-compose: `$ docker-compose stop piwik`
 * For manual execution: `$ docker stop piwik`

3. Take a snapshot of the application state

```bash
$ rsync -a /path/to/piwik-persistence /path/to/piwik-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

Additionally, [snapshot the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#step-2-stop-and-backup-the-currently-running-container)

You can use these snapshots to restore the application state should the upgrade fail.

4. Remove the currently running container

 * For docker-compose: `$ docker-compose rm -v piwik`
 * For manual execution: `$ docker rm -v piwik`

5. Run the new image

 * For docker-compose: `$ docker-compose start piwik`
 * For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name piwik bitnami/piwik:latest`

# Configuration

## Environment variables

When you start the Piwik image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the docker run command line. If you want to add a new environment variable:

 * For docker-compose add the variable name and value under the application section:

```yaml
application:
  image: bitnami/piwik:latest
  ports:
    - 80:80
  environment:
    - PIWIK_PASSWORD=my_password
```

 * For manual execution add a `-e` option with each variable and value:

```bash
 $ docker run -d -e PIWIK_PASSWORD=my_password -p 80:80 --name piwik -v /your/local/path/bitnami/piwik:/bitnami --net=piwik_network bitnami/piwik
```

Available variables:

 - `PIWIK_USERNAME`: Piwik application username. Default: **User**
 - `PIWIK_HOST`: Piwik application host. Default: **127.0.0.1**
 - `PIWIK_PASSWORD`: Piwik application password. Default: **bitnami**
 - `PIWIK_EMAIL`: Piwik application email. Default: **user@example.com**
 - `PIWIK_WEBSITE_NAME`: Name of a website to track in Piwik. Default: **example**
 - `PIWIK_WEBSITE_HOST`: Website's host or domain to track in Piwik. Default: **https://example.org**
 - `MARIADB_USER`: Root user for the MariaDB database. Default: **root**
 - `MARIADB_PASSWORD`: Root password for the MariaDB.
 - `MARIADB_HOST`: Hostname for MariaDB server. Default: **mariadb**
 - `MARIADB_PORT_NUMBER`: Port used by MariaDB server. Default: **3306**

### SMTP Configuration

To configure Piwik to send email using SMTP you can set the following environment variables:

 - `SMTP_HOST`: Piwik SMTP host.
 - `SMTP_PORT`: Piwik SMTP port.
 - `SMTP_USER`: Piwik SMTP account user.
 - `SMTP_PASSWORD`: Piwik SMTP account password.
 - `SMTP_PROTOCOL`: Piwik SMTP protocol to use.

This would be an example of SMTP configuration using a Gmail account:

 * docker-compose:

```yaml
  application:
    image: bitnami/piwik:latest
    ports:
      - 80:80
    environment:
      - SMTP_HOST=smtp.gmail.com
      - SMTP_USER=your_email@gmail.com
      - SMTP_PASSWORD=your_password
      - SMTP_PROTOCOL=tls
      - SMTP_PORT=587
```

 * For manual execution:

```bash
 $ docker run -d -e SMTP_HOST=smtp.gmail.com -e SMTP_PROTOCOL=TLS -e SMTP_PORT=587 -e SMTP_USER=your_email@gmail.com -e \
 SMTP_PASSWORD=your_password -p 80:80 --name piwik -v /your/local/path/bitnami/piwik:/bitnami bitnami/piwik
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-piwik/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-piwik/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-piwik/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# Community

Most real time communication happens in the `#containers` channel at [bitnami-oss.slack.com](http://bitnami-oss.slack.com); you can sign up at [slack.oss.bitnami.com](http://slack.oss.bitnami.com).

Discussions are archived at [bitnami-oss.slackarchive.io](https://bitnami-oss.slackarchive.io).

# License

Copyright 2017 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
