
# What is SonarQube?

> SonarQube is an open source quality management platform, dedicated to continuously analyze and measure technical quality, from project portfolio to method.

https://www.sonarqube.org/

# TL;DR;

## Docker Compose

```bash
$ curl -LO https://raw.githubusercontent.com/bitnami/bitnami-docker-sonarqube/master/docker-compose.yml
$ docker-compose up
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/sonarqube?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy SonarQube in Kubernetes?

You can find an example for testing in the file `test.yaml`. To launch this sample file run:

```bash
$ kubectl apply -f test.yaml
```

> NOTE: If you are pulling from a private containers registry, replace the image name with the full URL to the docker image. E.g.
>
> - image: 'your-registry/image-name:your-version'

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/).


* [`7-ol-7`, `7.6.0-ol-7-r1` (7/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-sonarqube/blob/7.6.0-ol-7-r1/7/ol-7/Dockerfile)
* [`7-debian-9`, `7.5.0-debian-9-r43`, `7`, `7.5.0`, `7.5.0-r43`, `latest` (7/debian-9/Dockerfile)](https://github.com/bitnami/bitnami-docker-sonarqube/blob/7.5.0-debian-9-r43/7/debian-9/Dockerfile)

Subscribe to project updates by watching the [bitnami/sonarqube GitHub repo](https://github.com/bitnami/bitnami-docker-sonarqube).

# Prerequisites

To run this application you need [Docker Engine](https://www.docker.com/products/docker-engine) >= `1.10.0`. [Docker Compose](https://www.docker.com/products/docker-compose) is recommended with a version `1.6.0` or later.

# How to use this image

SonarQube requires access to a PostgreSQL database to store information. We'll use our very own [PostgreSQL image](https://www.github.com/bitnami/bitnami-docker-postgresql) for the database requirements.

## Using Docker Compose

The recommended way to run SonarQube is using Docker Compose using the following `docker-compose.yml` template:

```yaml
version: '2'

services:
  postgresql:
    image: 'bitnami/postgresql:10'
    environment:
      - POSTGRESQL_USERNAME=bn_sonarqube
      - POSTGRESQL_DATABASE=bitnami_sonarqube
      - POSTGRESQL_PASSWORD=bitnami1234
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - 'postgresql_data:/bitnami'
  sonarqube:
    image: bitnami/sonarqube:latest
    ports:
      - '80:9000'
    environment:
      - POSTGRESQL_HOST=postgresql
      - SONARQUBE_DATABASE_NAME=bitnami_sonarqube
      - SONARQUBE_DATABASE_USER=bn_sonarqube
      - SONARQUBE_DATABASE_PASSWORD=bitnami1234
    volumes:
      - sonarqube_data:/bitnami
volumes:
  sonarqube_data:
    driver: local
  postgresql_data:
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
  $ docker network create sonarqube-tier
  ```

2. Create a volume for PostgreSQL persistence and create a PostgreSQL container

  ```bash
  $ docker volume create --name postgresql_data
  $ docker run -d --name postgresql \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e POSTGRESQL_USERNAME=bn_sonarqube \
    -e POSTGRESQL_DATABASE=bitnami_sonarqube \
    -e POSTGRESQL_PASSWORD=bitnami1234 \
    --net sonarqube-tier \
    --volume postgresql_data:/bitnami \
    bitnami/postgresql:latest
  ```

3. Create volumes for SonarQube persistence and launch the container

  ```bash
  $ docker volume create --name sonarqube_data
  $ docker run -d --name sonarqube -p 80:9000 \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e SONARQUBE_DATABASE_USER=bn_sonarqube \
    -e SONARQUBE_DATABASE_NAME=bitnami_sonarqube \
    -e SONARQUBE_DATABASE_PASSWORD=bitnami1234 \
    --net sonarqube-tier \
    --volume sonarqube_data:/bitnami \
    bitnami/sonarqube:latest
  ```

Access your application at http://your-ip:9000

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. Additionally you should mount a volume for [persistence of the PostgreSQL data](https://github.com/bitnami/bitnami-docker-postgresql#persisting-your-database).

The above examples define docker volumes namely `postgresql_data` and `sonarqube_data`. The Sonarqube application state will persist as long as these volumes are not removed.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

The following `docker-compose.yml` template demonstrates the use of host directories as data volumes.

```yaml
version: '2'

services:
  postgresql:
    image: 'bitnami/postgresql:latest'
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - POSTGRESQL_USER=bn_sonarqube
      - POSTGRESQL_DATABASE=bitnami_sonarqube
      - POSTGRESQL_PASSWORD=bitnami1234
    volumes:
      - /path/to/postgresql-persistence:/bitnami
  sonarqube:
    image: bitnami/sonarqube:latest
    depends_on:
      - postgresql
    ports:
      - '80:9000'
    environment:
      - SONARQUBE_DATABASE_USER=bn_sonarqube
      - SONARQUBE_DATABASE_NAME=bitnami_sonarqube
      - SONARQUBE_DATABASE_PASSWORD=bitnami1234
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - /path/to/sonarqube-persistence:/bitnami
```

### Mount host directories as data volumes using the Docker command line

1. Create a network (if it does not exist)

  ```bash
  $ docker network create sonarqube-tier
  ```

2. Create a PostgreSQL container with host volume

  ```bash
  $ docker run -d --name postgresql \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e POSTGRESQL_USERNAME=bn_sonarqube \
    -e POSTGRESQL_DATABASE=bitnami_sonarqube \
    -e POSTGRESQL_PASSWORD=bitnami1234 \
    --net sonarqube-tier \
    --volume /path/to/postgresql-persistence:/bitnami \
    bitnami/postgresql:latest
  ```

3. Create the SonarQube the container with host volumes

  ```bash
  $ docker run -d --name sonarqube -p 80:9000 \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e SONARQUBE_DATABASE_USER=bn_sonarqube \
    -e SONARQUBE_DATABASE_NAME=bitnami_sonarqube \
    -e SONARQUBE_DATABASE_PASSWORD=bitnami1234 \
    --net sonarqube-tier \
    --volume /path/to/sonarqube-persistence:/bitnami \
    bitnami/sonarqube:latest
  ```

# Upgrading SonarQube

Bitnami provides up-to-date versions of PostgreSQL and SonarQube, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the SonarQube container. For the PostgreSQL upgrade see https://github.com/bitnami/bitnami-docker-postgresql/blob/master/README.md#upgrade-this-image

The `bitnami/sonarqube:latest` tag always points to the most recent release. To get the most recent release you can simple repull the `latest` tag from the Docker Hub with `docker pull bitnami/sonarqube:latest`. However it is recommended to use [tagged versions](https://hub.docker.com/r/bitnami/sonarqube/tags/).

1. Get the updated images:

  ```bash
  $ docker pull bitnami/sonarqube:latest
  ```

2. Stop your container

 * For docker-compose: `$ docker-compose stop sonarqube`
 * For manual execution: `$ docker stop sonarqube`

3. Take a snapshot of the application state

```bash
$ rsync -a /path/to/sonarqube-persistence /path/to/sonarqube-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

Additionally, [snapshot the PostgreSQL data](https://github.com/bitnami/bitnami-docker-postgresql#step-2-stop-and-backup-the-currently-running-container)

You can use these snapshots to restore the application state should the upgrade fail.

4. Remove the stopped container

 * For docker-compose: `$ docker-compose rm sonarqube`
 * For manual execution: `$ docker rm sonarqube`

5. Run the new image

 * For docker-compose: `$ docker-compose up sonarqube`
 * For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name sonarqube bitnami/sonarqube:latest`

# Configuration

## Environment variables

The SonarQube instance can be customized by specifying environment variables on the first run. The following environment values are provided to custom SonarQube:

##### User and Site configuration

- `SONARQUBE_USERNAME`: SonarQube application username. Default: **admin**
- `SONARQUBE_PASSWORD`: SonarQube application password. Default: **bitnami**
- `SONARQUBE_PORT_NUMBER`: SonarQube Web application port. Default: **9000**
- `SONARQUBE_ELASTICSEARCH_PORT_NUMBER`: SonarQube Elasticsearch application port. Default: **9001**
- `SONARQUBE_ENABLE_DEMO_DATA`: It can be used to import a sample project and install a sample plugin. Default: **no**

##### Use an existing database

- `POSTGRESQL_HOST`: Hostname for PostgreSQL server. Default: **postgresql**
- `POSTGRESQL_PORT_NUMBER`: Port used by PostgreSQL server. Default: **5432**
- `SONARQUBE_DATABASE_NAME`: Database name that SonarQube will use to connect with the database. Default: **bitnami_sonarqube**
- `SONARQUBE_DATABASE_USER`: Database user that SonarQube will use to connect with the database. Default: **bn_sonarqube**
- `SONARQUBE_DATABASE_PASSWORD`: Database password that SonarQube will use to connect with the database. No defaults.
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

##### Create a database for SonarQube using postgresql-client

- `POSTGRESQL_HOST`: Hostname for PostgreSQL server. Default: **postgresql**
- `POSTGRESQL_PORT_NUMBER`: Port used by PostgreSQL server. Default: **5432**
- `POSTGRESQL_ROOT_USER`: Database admin user. Default: **root**
- `POSTGRESQL_ROOT_PASSWORD`: Database password for the `POSTGRESQL_ROOT_USER` user. No defaults.
- `POSTGRESQL_CLIENT_CREATE_DATABASE_NAME`: New database to be created by the postgresql client module. No defaults.
- `POSTGRESQL_CLIENT_CREATE_DATABASE_USER`: New database user to be created by the postgresql client module. No defaults.
- `POSTGRESQL_CLIENT_CREATE_DATABASE_PASSWORD`: Database password for the `POSTGRESQL_CLIENT_CREATE_DATABASE_USER` user. No defaults.
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

### Specifying Environment variables using Docker Compose

```yaml
version: '2'

services:
  postgresql:
    image: 'bitnami/postgresql:latest'
    environment:
      - POSTGRESQL_USER=bn_sonarqube
      - POSTGRESQL_DATABASE=bitnami_sonarqube
      - POSTGRESQL_PASSWORD=bitnami1234
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - postgresql_data:/bitnami
  sonarqube:
    image: bitnami/sonarqube:latest
    depends_on:
      - postgresql
    ports:
      - '80:9000'
    environment:
      - POSTGRESQL_HOST=postgresql
      - POSTGRESQL_PORT_NUMBER=5432
      - SONARQUBE_DATABASE_USER=bn_sonarqube
      - SONARQUBE_DATABASE_NAME=bitnami_sonarqube
      - SONARQUBE_DATABASE_PASSWORD=bitnami1234
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - sonarqube_data:/bitnami

volumes:
  postgresql_data:
    driver: local
  sonarqube_data:
    driver: local
```

### Specifying Environment variables on the Docker command line

```bash
$ docker run -d --name sonarqube -p 80:9000 \
  --net sonarqube-tier \
  -e ALLOW_EMPTY_PASSWORD=yes \
  -e SONARQUBE_DATABASE_USER=bn_sonarqube \
  -e SONARQUBE_DATABASE_NAME=bitnami_sonarqube \
  -e SONARQUBE_PASSWORD=my_password \
  --volume sonarqube_data:/bitnami \
  bitnami/sonarqube:latest
```

### SMTP Configuration

To configure SonarQube to send email using SMTP you can set the following environment variables:
- `SMTP_HOST`: Host for outgoing SMTP email. No defaults.
- `SMTP_PORT`: Port for outgoing SMTP email. No defaults.
- `SMTP_USER`: User of SMTP used for authentication (likely email). No defaults.
- `SMTP_PASSWORD`: Password for SMTP. No defaults.
- `SMTP_PROTOCOL`: Secure connection protocol to use for SMTP [tls, ssl, none]. No defaults.

This would be an example of SMTP configuration using a GMail account:

 * docker-compose (application part):

```yaml
  sonarqube:
    image: bitnami/sonarqube:latest
    ports:
      - 80:9000
    environment:
      - POSTGRESQL_HOST=postgresql
      - POSTGRESQL_PORT_NUMBER=5432
      - SONARQUBE_DATABASE_USER=bn_sonarqube
      - SONARQUBE_DATABASE_NAME=bitnami_sonarqube
      - SONARQUBE_DATABASE_PASSWORD=bitnami1234
      - SMTP_HOST=smtp.gmail.com
      - SMTP_PORT=587
      - SMTP_USER=your_email@gmail.com
      - SMTP_PASSWORD=your_password
      - SMTP_PROTOCOL=tls
    volumes:
      - sonarqube_data:/bitnami/sonarqube
```

* For manual execution:

```
$ docker run -d --name sonarqube -p 80:9000 \
  --net sonarqube-tier \
  --env SMTP_HOST=smtp.gmail.com --env SMTP_PORT=587 \
  --env SMTP_USER=your_email@gmail.com --env SMTP_PASSWORD=your_password \
  --env ALLOW_EMPTY_PASSWORD=yes --env SONARQUBE_DATABASE_USER=bn_sonarqube \
  --env SONARQUBE_DATABASE_NAME=bitnami_sonarqube \
  --volume sonarqube_data:/bitnami/sonarqube \
  bitnami/sonarqube:latest
```

### Connect SonarQube docker container to an existing database

The Bitnami SonarQube container supports connecting the SonarQube application to an external database. In order to configure it, you should set the following environment variables:
- `POSTGRESQL_HOST`: Hostname for PostgreSQL server. Default: **postgresql**
- `POSTGRESQL_PORT_NUMBER`: Port used by PostgreSQL server. Default: **5432**
- `SONARQUBE_DATABASE_NAME`: Database name that SonarQube will use to connect with the database. Default: **bitnami_sonarqube**
- `SONARQUBE_DATABASE_USER`: Database user that SonarQube will use to connect with the database. Default: **bn_sonarqube**
- `SONARQUBE_DATABASE_PASSWORD`: Database password that SonarQube will use to connect with the database. No defaults.

This would be an example of using an external database for SonarQube.

 * docker-compose:

```yaml
  sonarqube:
    image: bitnami/sonarqube:latest
    ports:
      - 80:9000
    environment:
      - POSTGRESQL_HOST=postgresql_host
      - POSTGRESQL_ROOT_USER=postgresql_root_user
      - POSTGRESQL_ROOT_PASSWORD=postgresql_root_password
      - POSTGRESQL_PORT_NUMBER=5432
      - SONARQUBE_DATABASE_NAME=sonarqube_db
      - SONARQUBE_DATABASE_USER=sonarqube_user
      - SONARQUBE_DATABASE_PASSWORD=sonarqube_password
    volumes:
      - sonarqube_data:/bitnami
```

* For manual execution:

```
$ docker run -d --name sonarqube -p 80:9000 \
  --net sonarqube-tier \
  --env POSTGRESQL_HOST=postgresql_host \
  --env POSTGRESQL_PORT_NUMBER=5432 \
  --env POSTGRESQL_ROOT_USER=postgresql_root_user \
  --env POSTGRESQL_ROOT_PASSWORD=postgresql_root_password \
  --env SONARQUBE_DATABASE_NAME=sonarqube_db \
  --env SONARQUBE_DATABASE_USER=sonarqube_user \
  --env SONARQUBE_DATABASE_PASSWORD=sonarqube_password \
  --volume sonarqube_data:/bitnami \
  bitnami/sonarqube:latest
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-sonarqube/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-sonarqube/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-sonarqube/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`$ docker version`)
- Output of `$ docker info`
- Version of this container (`$ echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

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
