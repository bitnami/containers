[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-owncloud/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-owncloud/tree/master)
[![Slack](https://img.shields.io/badge/slack-join%20chat%20%E2%86%92-e01563.svg)](http://slack.oss.bitnami.com)
[![Kubectl](https://img.shields.io/badge/kubectl-Available-green.svg)](https://raw.githubusercontent.com/bitnami/bitnami-docker-owncloud/master/kubernetes.yml)

# What is ownCloud?

ownCloud is a file sharing server that puts the control and security of your own data back into your hands.

https://owncloud.org/

# TL;DR;

## Docker Compose

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-owncloud/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

## Kubernetes

> **WARNING:** This is a beta configuration, currently unsupported.

Get the raw URL pointing to the `kubernetes.yml` manifest and use `kubectl` to create the resources on your Kubernetes cluster like so:

```bash
$ kubectl create -f https://raw.githubusercontent.com/bitnami/bitnami-docker-owncloud/master/kubernetes.yml
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* Bitnami images are built on CircleCI and automatically pushed to the Docker Hub.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.

# Prerequisites

To run this application you need Docker Engine 1.10.0. Docker Compose is recomended with a version 1.6.0 or later.

## Run ownCloud with a Database Container

Running ownCloud with a database server is the recommended way. You can either use docker-compose or run the containers manually.

### Run the application using Docker Compose

This is the recommended way to run ownCloud. You can use the following docker compose template:

```yaml
version: '2'
services:
  mariadb:
    image: 'bitnami/mariadb:latest'
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - 'mariadb_data:/bitnami'
  owncloud:
    image: 'bitnami/owncloud:latest'
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - 'owncloud_data:/bitnami'
    depends_on:
      - mariadb
volumes:
  mariadb_data:
    driver: local
  owncloud_data:
    driver: local
```

### Run the application manually

If you want to run the application manually instead of using docker-compose, these are the basic steps you need to run:

1. Create a new network for the application and the database:

  ```bash
  $ docker network create owncloud-tier
  ```

2. Start a MariaDB database in the network generated:

  ```bash
  $ docker run -d --name mariadb -e ALLOW_EMPTY_PASSWORD=yes --net=owncloud-tier bitnami/mariadb
  ```

  *Note:* You need to give the container a name in order to OwnCloud to resolve the host

3. Run the OwnCloud container:

  ```bash
  $ docker run -d -p 80:80 --name owncloud --net=owncloud-tier bitnami/owncloud
  ```

Then you can access your application at http://your-ip/

> *Note:* If you want to access your application from a public IP or hostname you need to configure as a Trusted Domain. You can handle it adjusting the configuration of the instance by setting the environment variable "OWNCLOUD_HOST" to your public IP or hostname.

> *Note:* If you persisted your application and you already run your container, you won't be able to configure the Trusted Domains using the previous environment variable. Trusted Domains will be set using the configuration that had been previously persisted. Therefore, you will need to connect you container and execute the command below:

  ````bash
  $ sudo -u daemon /opt/bitnami/php/bin/php /opt/bitnami/owncloud/occ config:system:set trusted_domains 2 --value=YOUR_HOSTNAME
  ````

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. Additionally you should mount a volume for [persistence of the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#persisting-your-database).

The above examples define docker volumes namely `mariadb_data` and `owncloud_data`. The ownCloud application state will persist as long as these volumes are not removed.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount persistent folders in the host using docker-compose

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
  owncloud:
    image: 'bitnami/owncloud:latest'
    depends_on:
      - mariadb
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - '/path/to/owncloud-persistence:/bitnami'
```

### Mount host directories as data volumes using the Docker command line

In this case you need to specify the directories to mount on the run command. The process is the same than the one previously shown:

1. Create a network (if it does not exist):

  ```bash
  $ docker network create owncloud-tier
  ```

2. Create a MariaDB container with host volume:

  ```bash
  $ docker run -d --name mariadb -e ALLOW_EMPTY_PASSWORD=yes \
    --net owncloud-tier \
    --volume /path/to/mariadb-persistence:/bitnami \
    bitnami/mariadb:latest
  ```

  *Note:* You need to give the container a name in order to OwnCloud to resolve the host

3. Create the ownCloud container with host volumes:

  ```bash
  $ docker run -d --name owncloud -p 80:80 -p 443:443 \
    --net owncloud-tier \
    --volume /path/to/owncloud-persistence:/bitnami \
    bitnami/owncloud:latest
  ```

# Upgrade this application

Bitnami provides up-to-date versions of MariaDB and OwnCloud, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the OwnCloud container. For the MariaDB upgrade see https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#upgrade-this-image

1. Get the updated images:

  ```bash
  $ docker pull bitnami/owncloud:latest
  ```

2. Stop your container

  * For docker-compose: `$ docker-compose stop owncloud`
  * For manual execution: `$ docker stop owncloud`

3. Take a snapshot of the application state

```bash
$ rsync -a /path/to/owncloud-persistence /path/to/owncloud-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

Additionally, [snapshot the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#step-2-stop-and-backup-the-currently-running-container)

You can use these snapshots to restore the application state should the upgrade fail.

4. Remove the currently running container

  * For docker-compose: `$ docker-compose rm -v owncloud`
  * For manual execution: `$ docker rm -v owncloud`

5. Run the new image

  * For docker-compose: `$ docker-compose start owncloud`
  * For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name owncloud bitnami/owncloud:latest`

# Configuration

## Environment variables

When you start the owncloud image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the docker run command line. If you want to add a new environment variable:

 * For docker-compose add the variable name and value under the application section:

```yaml
owncloud:
  image: bitnami/owncloud:latest
  ports:
    - 80:80
    - 443:443
  environment:
    - OWNCLOUD_HOST=your_host
  volumes:
      - owncloud_data:/bitnami
```

 * For manual execution add a `-e` option with each variable and value:

  ```bash
  $ docker run -d --name owncloud -p 80:80 -p 443:443 \
    -e OWNCLOUD_PASSWORD=my_password \
    --net owncloud-tier \
    --volume /path/to/owncloud-persistence:/bitnami \
    bitnami/owncloud:latest
  ```

Available variables:

 - `APACHE_HTTP_PORT_NUMBER`: Port used by Apache for HTTP. Default: **80**
 - `APACHE_HTTPS_PORT_NUMBER`: Port used by Apache for HTTPS. Default: **443**
 - `OWNCLOUD_USERNAME`: Owncloud application username. Default: **user**
 - `OWNCLOUD_PASSWORD`: Owncloud application password. Default: **bitnami**
 - `OWNCLOUD_EMAIL`: Owncloud application email. Default: **user@example.com**
 - `OWNCLOUD_WEB_SERVER_HOST`: Owncloud Host Server.
 - `MARIADB_PASSWORD`: Root password for the MariaDB.
 - `MARIADB_HOST`: Hostname for MariaDB server. Default: **mariadb**
 - `MARIADB_PORT_NUMBER`: Port used by MariaDB server. Default: **3306**

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-owncloud/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-owncloud/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-owncloud/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# Community

Most real time communication happens in the `#containers` channel at [bitnami-oss.slack.com](http://bitnami-oss.slack.com); you can sign up at [slack.oss.bitnami.com](http://slack.oss.bitnami.com).

Discussions are archived at [bitnami-oss.slackarchive.io](https://bitnami-oss.slackarchive.io).

# License

Copyright 2016-2017 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
