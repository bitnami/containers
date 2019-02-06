# What is phpMyAdmin?

> phpMyAdmin is a free software tool written in PHP, intended to handle the administration of MySQL over the Web. phpMyAdmin supports a wide range of operations on MySQL and MariaDB. Frequently used operations (managing databases, tables, columns, relations, indexes, users, permissions, etc) can be performed via the user interface, while you still have the ability to directly execute any SQL statement.

https://www.phpmyadmin.net/

# TL;DR;

## Docker Compose

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-phpmyadmin/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/phpmyadmin?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy phpMyAdmin in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami phpMyAdmin Chart GitHub repository](https://github.com/bitnami/charts/tree/master/upstreamed/phpmyadmin).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Supported tags and respective `Dockerfile` links

> NOTE: Debian 8 images have been deprecated in favor of Debian 9 images. Bitnami will not longer publish new Docker images based on Debian 8.

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/).


* [`4-ol-7`, `4.8.5-ol-7-r6` (4/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-phpmyadmin/blob/4.8.5-ol-7-r6/4/ol-7/Dockerfile)
* [`4-debian-9`, `4.8.5-debian-9-r4`, `4`, `4.8.5`, `4.8.5-r4`, `latest` (4/debian-9/Dockerfile)](https://github.com/bitnami/bitnami-docker-phpmyadmin/blob/4.8.5-debian-9-r4/4/debian-9/Dockerfile)

Subscribe to project updates by watching the [bitnami/phpmyadmin GitHub repo](https://github.com/bitnami/bitnami-docker-phpmyadmin).

# Prerequisites

To run this application you need [Docker Engine](https://www.docker.com/products/docker-engine) >= `1.10.0`. [Docker Compose](https://www.docker.com/products/docker-compose) is recommended with a version `1.6.0` or later.

# How to use this image

phpMyAdmin requires access to a MySQL database or MariaDB database to work. We'll use our very own [MariaDB image](https://www.github.com/bitnami/bitnami-docker-mariadb).

## Using Docker Compose

The recommended way to run phpMyAdmin is using Docker Compose using the following `docker-compose.yml` template:

```yaml
version: '2'

services:
  mariadb:
    image: 'bitnami/mariadb:latest'
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - mariadb_data:/bitnami
  phpmyadmin:
    image: bitnami/phpmyadmin:latest
    depends_on:
      - mariadb
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - phpmyadmin_data:/bitnami

volumes:
  mariadb_data:
    driver: local
  phpmyadmin_data:
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
$ docker network create phpmyadmin-tier
```

2. Create a volume for MariaDB persistence and create a MariaDB container

```bash
$ docker volume create --name mariadb_data
$ docker run -d --name mariadb -e ALLOW_EMPTY_PASSWORD=yes \
  --net phpmyadmin-tier \
  --volume mariadb_data:/bitnami \
  bitnami/mariadb:latest
```

3. Create volumes for phpMyAdmin persistence and launch the container

```bash
$ docker volume create --name phpmyadmin_data
$ docker run -d --name phpmyadmin -p 80:80 -p 443:443 \
  --net phpmyadmin-tier \
  --volume phpmyadmin_data:/bitnami \
  bitnami/phpmyadmin:latest
```

Access your application at http://your-ip/

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. Additionally you should mount a volume for [persistence of the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#persisting-your-database).

The above examples define docker volumes namely `mariadb_data` and `phpmyadmin_data`. The phpMyAdmin application state will persist as long as these volumes are not removed.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

The following `docker-compose.yml` template demonstrates the use of host directories as data volumes.

```yaml
version: '2'

services:
  mariadb:
    image: 'bitnami/mariadb:latest'
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - /path/to/mariadb-persistence:/bitnami
  phpmyadmin:
    image: bitnami/phpmyadmin:latest
    depends_on:
      - mariadb
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - /path/to/phpmyadmin-persistence:/bitnami
```

### Mount host directories as data volumes using the Docker command line

1. Create a network (if it does not exist)

```bash
$ docker network create phpmyadmin-tier
```

2. Create a MariaDB container with host volume

```bash
$ docker run -d --name mariadb -e ALLOW_EMPTY_PASSWORD=yes \
  --net phpmyadmin-tier \
  --volume /path/to/mariadb-persistence:/bitnami \
  bitnami/mariadb:latest
```

3. Create the phpMyAdmin the container with host volumes

```bash
$ docker run -d --name phpmyadmin -p 80:80 -p 443:443 \
  --net phpmyadmin-tier \
  --volume /path/to/phpmyadmin-persistence:/bitnami \
  bitnami/phpmyadmin:latest
```

# Upgrading phpMyAdmin

Bitnami provides up-to-date versions of MariaDB and phpMyAdmin, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the phpMyAdmin container. For the MariaDB upgrade see https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#upgrade-this-image

The `bitnami/phpmyadmin:latest` tag always points to the most recent release. To get the most recent release you can simple repull the `latest` tag from the Docker Hub with `docker pull bitnami/phpmyadmin:latest`. However it is recommended to use [tagged versions](https://hub.docker.com/r/bitnami/phpmyadmin/tags/).

1. Get the updated images:

  ```bash
  $ docker pull bitnami/phpmyadmin:latest
  ```

2. Stop your container

 * For docker-compose: `$ docker-compose stop phpmyadmin`
 * For manual execution: `$ docker stop phpmyadmin`

3. Take a snapshot of the application state

```bash
$ rsync -a /path/to/phpmyadmin-persistence /path/to/phpmyadmin-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

Additionally, [snapshot the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#step-2-stop-and-backup-the-currently-running-container)

You can use these snapshots to restore the application state should the upgrade fail.

4. Remove the currently running container

 * For docker-compose: `$ docker-compose rm -v phpmyadmin`
 * For manual execution: `$ docker rm -v phpmyadmin`

5. Run the new image

 * For docker-compose: `$ docker-compose up phpmyadmin`
 * For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name phpmyadmin bitnami/phpmyadmin:latest`

# Configuration

## Environment variables

The phpMyAdmin instance can be customized by specifying environment variables on the first run. The following environment values are provided to custom phpMyAdmin:

- `PHPMYADMIN_ALLOW_ARBITRARY_SERVER`: Allows you to enter database server hostname on login form. Default: **false**
- `PHPMYADMIN_ALLOW_NO_PASSWORD`: Whether to allow logins without a password. Default: **true**
- `DATABASE_HOST`: Database server host. Default: **mariadb**
- `DATABASE_PORT_NUMBER`: Database server port. Default: **3306**
- `WEBSERVER_REQUIRE`: Tests whether an authenticated user is authorized by an authorization provider. Default: **all granted**

### Specifying Environment variables using Docker Compose

```yaml
version: '2'

services:
  mariadb:
    image: 'bitnami/mariadb:latest'
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - mariadb_data:/bitnami
  phpmyadmin:
    image: bitnami/phpmyadmin:latest
    depends_on:
      - mariadb
    ports:
      - '80:80'
      - '443:443'
    environment:
      - PHPMYADMIN_ALLOW_NO_PASSWORD=false
      - PHPMYADMIN_ALLOW_ARBITRARY_SERVER=true
    volumes:
      - phpmyadmin_data:/bitnami

volumes:
  mariadb_data:
    driver: local
  phpmyadmin_data:
    driver: local
```

### Specifying Environment variables on the Docker command line

```bash
$ docker run -d --name phpmyadmin -p 80:80 -p 443:443 \
  --net phpmyadmin-tier \
  --env PHPMYADMIN_PASSWORD=my_password \
  --volume phpmyadmin_data:/bitnami \
  bitnami/phpmyadmin:latest
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-phpmyadmin/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-phpmyadmin/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/phpmyadmin/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright 2016-2019 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
