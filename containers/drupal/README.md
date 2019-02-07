# What is Drupal?

> Drupal is one of the most versatile open source content management systems on the market. Drupal is built for high performance and is scalable to many servers, has easy integration via REST, JSON, SOAP and other formats, and features a whopping 15,000 plugins to extend and customize the application for just about any type of website.

https://www.drupal.org/

# TL;DR;

## Docker Compose

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-drupal/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/drupal?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy Drupal in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Drupal Chart GitHub repository](https://github.com/bitnami/charts/tree/master/upstreamed/drupal).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Supported tags and respective `Dockerfile` links

> NOTE: Debian 8 images have been deprecated in favor of Debian 9 images. Bitnami will not longer publish new Docker images based on Debian 8.
> NOTE: RHEL images are not available in any public registry. You can build them on your side on top of RHEL as described on this [doc](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux_atomic_host/7/html-single/getting_started_with_containers/index#creating_docker_images).

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/).


* [`8-rhel-7`, `8.6.8-rhel-7-r0` (8/rhel-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-drupal/blob/8.6.8-rhel-7-r0/8/rhel-7/Dockerfile)
* [`8-php5-rhel-7`, `8.6.8-php5-rhel-7-r0` (8-php5/rhel-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-drupal/blob/8.6.8-php5-rhel-7-r0/8-php5/rhel-7/Dockerfile)
* [`8-ol-7`, `8.6.8-ol-7-r0` (8/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-drupal/blob/8.6.8-ol-7-r0/8/ol-7/Dockerfile)
* [`8-debian-9`, `8.6.8-debian-9-r1`, `8`, `8.6.8`, `8.6.8-r1`, `latest` (8/debian-9/Dockerfile)](https://github.com/bitnami/bitnami-docker-drupal/blob/8.6.8-debian-9-r1/8/debian-9/Dockerfile)

Subscribe to project updates by watching the [bitnami/drupal GitHub repo](https://github.com/bitnami/bitnami-docker-drupal).

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
      - MARIADB_USER=bn_drupal
      - MARIADB_DATABASE=bitnami_drupal
    volumes:
      - 'mariadb_data:/bitnami'
  drupal:
    image: 'bitnami/drupal:8'
    labels:
      kompose.service.type: nodeport
    environment:
      - MARIADB_HOST=mariadb
      - MARIADB_PORT_NUMBER=3306
      - DRUPAL_DATABASE_USER=bn_drupal
      - DRUPAL_DATABASE_NAME=bitnami_drupal
      - ALLOW_EMPTY_PASSWORD=yes
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

2. Create a volume for MariaDB persistence and create a MariaDB container

  ```bash
  $ docker volume create --name mariadb_data
  $ docker run -d --name mariadb \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MARIADB_USER=bn_drupal \
    -e MARIADB_DATABASE=bitnami_drupal \
    --net drupal-tier \
    --volume mariadb_data:/bitnami \
    bitnami/mariadb:latest
  ```

3. Create volumes for Drupal persistence and launch the container

  ```bash
  $ docker volume create --name drupal_data
  $ docker run -d --name drupal -p 80:80 -p 443:443 \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e DRUPAL_DATABASE_USER=bn_drupal \
    -e DRUPAL_DATABASE_NAME=bitnami_drupal \
    --net drupal-tier \
    --volume drupal_data:/bitnami \
    bitnami/drupal:latest
  ```

Access your application at http://your-ip/

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
      - MARIADB_USER=bn_drupal
      - MARIADB_DATABASE=bitnami_drupal
    volumes:
      - '/path/to/mariadb-persistence:/bitnami'
  drupal:
    image: 'bitnami/drupal:latest'
    depends_on:
      - mariadb
    ports:
      - '80:80'
      - '443:443'
    environment:
      - DRUPAL_DATABASE_USER=bn_drupal
      - DRUPAL_DATABASE_NAME=bitnami_drupal
      - ALLOW_EMPTY_PASSWORD=yes
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
  $ docker run -d --name mariadb \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MARIADB_USER=bn_drupal \
    -e MARIADB_DATABASE=bitnami_drupal \
    --net drupal-tier \
    --volume /path/to/mariadb-persistence:/bitnami \
    bitnami/mariadb:latest
  ```

  *Note:* You need to give the container a name in order to Drupal to resolve the host

3. Create the Drupal container with host volumes:

  ```bash
  $ docker run -d --name drupal -p 80:80 -p 443:443 \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e DRUPAL_DATABASE_USER=bn_drupal \
    -e DRUPAL_DATABASE_NAME=bitnami_drupal \
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

 * For docker-compose: `$ docker-compose up drupal`
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

##### User and Site configuration

 - `DRUPAL_PROFILE`: Drupal installation profile. Default: **standard**
 - `DRUPAL_USERNAME`: Drupal application username. Default: **user**
 - `DRUPAL_PASSWORD`: Drupal application password. Default: **bitnami**
 - `DRUPAL_EMAIL`: Drupal application email. Default: **user@example.com**

##### Use an existing database

- `MARIADB_HOST`: Hostname for MariaDB server. Default: **mariadb**
- `MARIADB_PORT_NUMBER`: Port used by MariaDB server. Default: **3306**
- `DRUPAL_DATABASE_NAME`: Database name that Drupal will use to connect with the database. Default: **bitnami_drupal**
- `DRUPAL_DATABASE_USER`: Database user that Drupal will use to connect with the database. Default: **bn_drupal**
- `DRUPAL_DATABASE_PASSWORD`: Database password that Drupal will use to connect with the database. No defaults.
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

##### Create a database for Drupal using mysql-client

- `MARIADB_HOST`: Hostname for MariaDB server. Default: **mariadb**
- `MARIADB_PORT_NUMBER`: Port used by MariaDB server. Default: **3306**
- `MARIADB_ROOT_USER`: Database admin user. Default: **root**
- `MARIADB_ROOT_PASSWORD`: Database password for the `MARIADB_ROOT_USER` user. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_NAME`: New database to be created by the mysql client module. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_USER`: New database user to be created by the mysql client module. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_PASSWORD`: Database password for the `MYSQL_CLIENT_CREATE_DATABASE_USER` user. No defaults.
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

# Notable Changes

## 8.5.3-r1

- The drupal container now uses drush to install and update the Drupal application.

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

# License

Copyright 2015-2019 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
