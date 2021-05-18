# What is Apache Airflow?

> Airflow is a platform to programmatically author, schedule and monitor workflows.

https://airflow.apache.org/

# TL;DR

## Docker Compose

```console
$ curl -LO https://raw.githubusercontent.com/bitnami/bitnami-docker-airflow/master/docker-compose.yml
$ docker-compose up
```

You can find the default credentials and available configuration options in the [Environment Variables](#environment-variables) section.

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/airflow?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.


# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`2`, `2-debian-10`, `2.0.2`, `2.0.2-debian-10-r13`, `latest` (2/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-airflow/blob/2.0.2-debian-10-r13/2/debian-10/Dockerfile)
* [`1`, `1-debian-10`, `1.10.15`, `1.10.15-debian-10-r42` (1/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-airflow/blob/1.10.15-debian-10-r42/1/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/airflow GitHub repo](https://github.com/bitnami/bitnami-docker-airflow).

# Prerequisites

To run this application you need [Docker Engine](https://www.docker.com/products/docker-engine) >= `1.10.0`. [Docker Compose](https://www.docker.com/products/docker-compose) is recommended with a version `1.6.0` or later.

# How to use this image

Airflow requires access to a PostgreSQL database to store information. We will use our very own [PostgreSQL image](https://www.github.com/bitnami/bitnami-docker-postgresql) for the database requirements. Additionally, if you pretend to use the `CeleryExecutor`, you will also need an [Airflow Scheduler](https://www.github.com/bitnami/bitnami-docker-airflow-scheduler), one or more [Airflow Workers](https://www.github.com/bitnami/bitnami-docker-airflow-worker) and a [Redis(TM) server](https://www.github.com/bitnami/bitnami-docker-redis).

## Using Docker Compose

The main folder of this repository contains a functional [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-airflow/blob/master/docker-compose.yml) file. Run the application using it as shown below:

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-airflow/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

## Using the Docker Command Line

If you want to run the application manually instead of using `docker-compose`, these are the basic steps you need to run:

1. Create a network

  ```console
  $ docker network create airflow-tier
  ```

2. Create a volume for PostgreSQL persistence and create a PostgreSQL container

  ```console
  $ docker volume create --name postgresql_data
  $ docker run -d --name postgresql \
    -e POSTGRESQL_USERNAME=bn_airflow \
    -e POSTGRESQL_PASSWORD=bitnami1 \
    -e POSTGRESQL_DATABASE=bitnami_airflow \
    --net airflow-tier \
    --volume postgresql_data:/bitnami/postgresql \
    bitnami/postgresql:latest
  ```

3. Create a volume for Redis(TM) persistence and create a Redis(TM) container

  ```console
  $ docker volume create --name redis_data
  $ docker run -d --name redis \
    -e ALLOW_EMPTY_PASSWORD=yes \
    --net airflow-tier \
    --volume redis_data:/bitnami \
    bitnami/redis:latest
  ```

4. Create volumes for Airflow persistence and launch the container

  ```console
  $ docker volume create --name airflow_data
  $ docker run -d --name airflow -p 8080:8080 \
    -e AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho= \
    -e AIRFLOW_EXECUTOR=CeleryExecutor \
    -e AIRFLOW_DATABASE_NAME=bitnami_airflow \
    -e AIRFLOW_DATABASE_USERNAME=bn_airflow \
    -e AIRFLOW_DATABASE_PASSWORD=bitnami1 \
    -e AIRFLOW_LOAD_EXAMPLES=yes \
    -e AIRFLOW_PASSWORD=bitnami123 \
    -e AIRFLOW_USERNAME=user \
    -e AIRFLOW_EMAIL=user@example.com \
    --net airflow-tier \
    --volume airflow_data:/bitnami \
    bitnami/airflow:latest
  ```

5. Create volumes for Airflow Scheduler persistence and launch the container

  ```console
  $ docker volume create --name airflow_scheduler_data
  $ docker run -d --name airflow-scheduler \
    -e AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho= \
    -e AIRFLOW_EXECUTOR=CeleryExecutor \
    -e AIRFLOW_DATABASE_NAME=bitnami_airflow \
    -e AIRFLOW_DATABASE_USERNAME=bn_airflow \
    -e AIRFLOW_DATABASE_PASSWORD=bitnami1 \
    -e AIRFLOW_LOAD_EXAMPLES=yes \
    --net airflow-tier \
    --volume airflow_scheduler_data:/bitnami \
    bitnami/airflow-scheduler:latest
  ```

6. Create volumes for Airflow Worker persistence and launch the container

  ```console
  $ docker volume create --name airflow_worker_data
  $ docker run -d --name airflow-worker \
    -e AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho= \
    -e AIRFLOW_EXECUTOR=CeleryExecutor \
    -e AIRFLOW_DATABASE_NAME=bitnami_airflow \
    -e AIRFLOW_DATABASE_USERNAME=bn_airflow \
    -e AIRFLOW_DATABASE_PASSWORD=bitnami1 \
    --net airflow-tier \
    --volume airflow_worker_data:/bitnami \
    bitnami/airflow-worker:latest
  ```

Access your application at http://your-ip:8080

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. Additionally you should mount volumes for persistence of [PostgreSQL data](https://github.com/bitnami/bitnami-docker-mariadb#persisting-your-database) and [Redis(TM) data](https://github.com/bitnami/bitnami-docker-mariadb#persisting-your-database)

The above examples define docker volumes namely `postgresql_data`, `redis_data`, `airflow_data`, `airflow_scheduler_data` and `airflow_worker_data`. The Airflow application state will persist as long as these volumes are not removed.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

The following `docker-compose.yml` template demonstrates the use of host directories as data volumes.

```yaml
version: '2'
services:
  postgresql:
    image: 'bitnami/postgresql:latest'
    environment:
      - POSTGRESQL_DATABASE=bitnami_airflow
      - POSTGRESQL_USERNAME=bn_airflow
      - POSTGRESQL_PASSWORD=bitnami1
    volumes:
      - /path/to/airflow-persistence:/bitnami/postgresql
  redis:
    image: 'bitnami/redis:latest'
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - /path/to/airflow-persistence:/bitnami
  airflow-worker:
    image: bitnami/airflow-worker:latest
    environment:
      - AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho=
      - AIRFLOW_EXECUTOR=CeleryExecutor
      - AIRFLOW_DATABASE_NAME=bitnami_airflow
      - AIRFLOW_DATABASE_USERNAME=bn_airflow
      - AIRFLOW_DATABASE_PASSWORD=bitnami1
      - AIRFLOW_LOAD_EXAMPLES=yes
    volumes:
      - /path/to/airflow-persistence:/bitnami
  airflow-scheduler:
    image: bitnami/airflow-scheduler:latest
    environment:
      - AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho=
      - AIRFLOW_EXECUTOR=CeleryExecutor
      - AIRFLOW_DATABASE_NAME=bitnami_airflow
      - AIRFLOW_DATABASE_USERNAME=bn_airflow
      - AIRFLOW_DATABASE_PASSWORD=bitnami1
      - AIRFLOW_LOAD_EXAMPLES=yes
    volumes:
      - /path/to/airflow-persistence:/bitnami
  airflow:
    image: bitnami/airflow:latest
    environment:
      - AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho=
      - AIRFLOW_EXECUTOR=CeleryExecutor
      - AIRFLOW_DATABASE_NAME=bitnami_airflow
      - AIRFLOW_DATABASE_USERNAME=bn_airflow
      - AIRFLOW_DATABASE_PASSWORD=bitnami1
      - AIRFLOW_PASSWORD=bitnami123
      - AIRFLOW_USERNAME=user
      - AIRFLOW_EMAIL=user@example.com
    ports:
      - '8080:8080'
    volumes:
      - /path/to/airflow-persistence:/bitnami
```

### Mount host directories as data volumes using the Docker command line

1. Create a network (if it does not exist)

  ```console
  $ docker network create airflow-tier
  ```

2. Create the PostgreSQL container with host volumes

  ```console
  $ docker run -d --name postgresql \
    -e POSTGRESQL_USERNAME=bn_airflow \
    -e POSTGRESQL_PASSWORD=bitnami1 \
    -e POSTGRESQL_DATABASE=bitnami_airflow \
    --net airflow-tier \
    --volume /path/to/postgresql-persistence:/bitnami \
    bitnami/postgresql:latest
  ```

3. Create the Redis(TM) container with host volumes

  ```console
  $ docker run -d --name redis \
    -e ALLOW_EMPTY_PASSWORD=yes \
    --net airflow-tier \
    --volume /path/to/redis-persistence:/bitnami \
    bitnami/redis:latest
  ```

4. Create the Airflow container with host volumes

  ```console
  $ docker run -d --name airflow -p 8080:8080 \
    -e AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho= \
    -e AIRFLOW_EXECUTOR=CeleryExecutor \
    -e AIRFLOW_DATABASE_NAME=bitnami_airflow \
    -e AIRFLOW_DATABASE_USERNAME=bn_airflow \
    -e AIRFLOW_DATABASE_PASSWORD=bitnami1 \
    -e AIRFLOW_LOAD_EXAMPLES=yes \
    -e AIRFLOW_PASSWORD=bitnami123 \
    -e AIRFLOW_USERNAME=user \
    -e AIRFLOW_EMAIL=user@example.com \
    --net airflow-tier \
    --volume /path/to/airflow-persistence:/bitnami \
    bitnami/airflow:latest
  ```

5. Create the Airflow Scheduler container with host volumes

  ```console
  $ docker run -d --name airflow-scheduler \
    -e AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho= \
    -e AIRFLOW_EXECUTOR=CeleryExecutor \
    -e AIRFLOW_DATABASE_NAME=bitnami_airflow \
    -e AIRFLOW_DATABASE_USERNAME=bn_airflow \
    -e AIRFLOW_DATABASE_PASSWORD=bitnami1 \
    -e AIRFLOW_LOAD_EXAMPLES=yes \
    --net airflow-tier \
    --volume /path/to/airflow-scheduler-persistence:/bitnami \
    bitnami/airflow-scheduler:latest
  ```

6. Create the Airflow Worker container with host volumes

  ```console
  $ docker run -d --name airflow-worker \
    -e AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho= \
    -e AIRFLOW_EXECUTOR=CeleryExecutor \
    -e AIRFLOW_DATABASE_NAME=bitnami_airflow \
    -e AIRFLOW_DATABASE_USERNAME=bn_airflow \
    -e AIRFLOW_DATABASE_PASSWORD=bitnami1 \
    --net airflow-tier \
    --volume /path/to/airflow-worker-persistence:/bitnami \
    bitnami/airflow-worker:latest
  ```

# Configuration

## Load DAG files

Custom DAG files can be mounted to `/opt/bitnami/airflow/dags`.

## Installing additional python modules

This container supports the installation of additional python modules at start-up time. In order to do that, you can mount a `requirements.txt` file with your specific needs under the path `/bitnami/python/requirements.txt`.

## Environment variables

The Airflow instance can be customized by specifying environment variables on the first run. The following environment values are provided to customize Airflow:

##### User configuration

- `AIRFLOW_USERNAME`: Airflow application username. Default: **user**
- `AIRFLOW_PASSWORD`: Airflow application password. Default: **bitnami**
- `AIRFLOW_EMAIL`: Airflow application email. Default: **user@example.com**

##### Airflow configuration

- `AIRFLOW_EXECUTOR`: Airflow executor. Default: **SequentialExecutor**
- `AIRFLOW_FERNET_KEY`: Airflow Fernet key. No defaults.
- `AIRFLOW_WEBSERVER_HOST`: Airflow webserver host. Default: **127.0.0.1**
- `AIRFLOW_WEBSERVER_PORT_NUMBER`: Airflow webserver port. Default: **8080**
- `AIRFLOW_LOAD_EXAMPLES`: To load example tasks into the application. Default: **yes**
- `AIRFLOW_BASE_URL`: Airflow webserver base URL. No defaults.
- `AIRFLOW_HOSTNAME_CALLABLE`: Method to obtain the hostname. No defaults.
- `AIRFLOW_POOL_NAME`: Pool name. No defaults.
- `AIRFLOW_POOL_SIZE`: Pool size, required with `AIRFLOW_POOL_NAME`. No defaults.
- `AIRFLOW_POOL_DESC`: Pool description, required with `AIRFLOW_POOL_NAME`. No defaults.

##### Use an existing database

- `AIRFLOW_DATABASE_HOST`: Hostname for PostgreSQL server. Default: **postgresql**
- `AIRFLOW_DATABASE_PORT_NUMBER`: Port used by PostgreSQL server. Default: **5432**
- `AIRFLOW_DATABASE_NAME`: Database name that Airflow will use to connect with the database. Default: **bitnami_airflow**
- `AIRFLOW_DATABASE_USERNAME`: Database user that Airflow will use to connect with the database. Default: **bn_airflow**
- `AIRFLOW_DATABASE_PASSWORD`: Database password that Airflow will use to connect with the database. No defaults.
- `AIRFLOW_DATABASE_USE_SSL`: Set to yes if the database is using SSL. Default: **no**
- `AIRFLOW_REDIS_USE_SSL`: Set to yes if Redis(TM) uses SSL. Default: **no**
- `REDIS_HOST`: Hostname for Redis(TM) server. Default: **redis**
- `REDIS_PORT_NUMBER`: Port used by Redis(TM) server. Default: **6379**
- `REDIS_USER`: User that Airflow will use to connect with Redis(TM). No defaults.
- `REDIS_PASSWORD`: Password that Airflow will use to connect with Redis(TM). No defaults.

##### Airflow LDAP authentication

- `AIRFLOW_LDAP_ENABLE`: Enable LDAP authentication. Default: **no**
- `AIRFLOW_LDAP_URI`: LDAP server URI. No defaults.
- `AIRFLOW_LDAP_SEARCH`: LDAP search base. No defaults.
- `AIRFLOW_LDAP_BIND_USER`: LDAP user name. No defaults.
- `AIRFLOW_LDAP_BIND_PASSWORD`: LDAP user password. No defaults.
- `AIRFLOW_LDAP_UID_FIELD`: LDAP field used for uid. Default: **uid**.
- `AIRFLOW_LDAP_USE_TLS`: Use LDAP SSL. Defaults: **False**.
- `AIRFLOW_LDAP_ALLOW_SELF_SIGNED`: Allow self signed certicates in LDAP ssl. Default: **True**.
- `AIRFLOW_LDAP_TLS_CA_CERTIFICATE`: File that store the CA for LDAP ssl. No defaults.
- `AIRFLOW_USER_REGISTRATION_ROLE`: Role for the created user. Default: **Public**

> In addition to the previous environment variables, all the parameters from the configuration file can be overwritten by using environment variables with this format: `AIRFLOW__{SECTION}__{KEY}`. Note the double underscores.

### Specifying Environment variables using Docker Compose

```yaml
version: '2'

services:
  airflow:
    image: bitnami/airflow:latest
    environment:
      - AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho=
      - AIRFLOW_EXECUTOR=CeleryExecutor
      - AIRFLOW_DATABASE_NAME=bitnami_airflow
      - AIRFLOW_DATABASE_USERNAME=bn_airflow
      - AIRFLOW_DATABASE_PASSWORD=bitnami1
      - AIRFLOW_PASSWORD=bitnami123
      - AIRFLOW_USERNAME=user
      - AIRFLOW_EMAIL=user@example.com
```

### Specifying Environment variables on the Docker command line

```console
$ docker run -d --name airflow -p 8080:8080 \
    -e AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho= \
    -e AIRFLOW_EXECUTOR=CeleryExecutor \
    -e AIRFLOW_DATABASE_NAME=bitnami_airflow \
    -e AIRFLOW_DATABASE_USERNAME=bn_airflow \
    -e AIRFLOW_DATABASE_PASSWORD=bitnami1 \
    -e AIRFLOW_PASSWORD=bitnami123 \
    -e AIRFLOW_USERNAME=user \
    -e AIRFLOW_EMAIL=user@example.com \
    --volume airflow_data:/bitnami \
    bitnami/airflow:latest
```

### SMTP Configuration

To configure Airflow to send email using SMTP you can set the following environment variables:

- `AIRFLOW__SMTP__SMTP_HOST`: Host for outgoing SMTP email. Default: **localhost**
- `AIRFLOW__SMTP__SMTP_PORT`: Port for outgoing SMTP email. Default: **25**
- `AIRFLOW__SMTP__SMTP_STARTTLS`: To use TLS communication. Default: **True**
- `AIRFLOW__SMTP__SMTP_SSL`: To use SSL communication. Default: **False**
- `AIRFLOW__SMTP__SMTP_USER`: User of SMTP used for authentication (likely email). No defaults.
- `AIRFLOW__SMTP__SMTP_PASSWORD`: Password for SMTP. No defaults.
- `AIRFLOW__SMTP__SMTP_MAIL_FROM`: To modify the "from email address". Default: **airflow@example.com**

This would be an example of SMTP configuration using a GMail account:

 * docker-compose (application part):

```yaml
  airflow:
    image: bitnami/airflow:latest
    environment:
      - AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho=
      - AIRFLOW_EXECUTOR=CeleryExecutor
      - AIRFLOW_DATABASE_NAME=bitnami_airflow
      - AIRFLOW_DATABASE_USERNAME=bn_airflow
      - AIRFLOW_DATABASE_PASSWORD=bitnami1
      - AIRFLOW_PASSWORD=bitnami
      - AIRFLOW_USERNAME=user
      - AIRFLOW_EMAIL=user@email.com
      - AIRFLOW__SMTP__SMTP_HOST=smtp@gmail.com
      - AIRFLOW__SMTP__SMTP_USER=your_email@gmail.com
      - AIRFLOW__SMTP__SMTP_PASSWORD=your_password
      - AIRFLOW__SMTP__SMTP_PORT=587
    ports:
      - '8080:8080'
    volumes:
      - airflow_data:/bitnami
```

* For manual execution:

```console
$ docker run -d --name airflow -p 8080:8080 \
    -e AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho= \
    -e AIRFLOW_EXECUTOR=CeleryExecutor \
    -e AIRFLOW_DATABASE_NAME=bitnami_airflow \
    -e AIRFLOW_DATABASE_USERNAME=bn_airflow \
    -e AIRFLOW_DATABASE_PASSWORD=bitnami1 \
    -e AIRFLOW_PASSWORD=bitnami123 \
    -e AIRFLOW_USERNAME=user \
    -e AIRFLOW_EMAIL=user@example.com \
    -e AIRFLOW__SMTP__SMTP_HOST=smtp@gmail.com \
    -e AIRFLOW__SMTP__SMTP_USER=your_email@gmail.com \
    -e AIRFLOW__SMTP__SMTP_PASSWORD=your_password \
    -e AIRFLOW__SMTP__SMTP_PORT=587 \
    --volume airflow_data:/bitnami \
    bitnami/airflow:latest
```

# Notable Changes

## 1.10.15-debian-10-r17 and 2.0.1-debian-10-r50

- The size of the container image has been decreased.
- The configuration logic is now based on Bash scripts in the *rootfs/* folder.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-airflow/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-airflow/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-airflow/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`$ docker version`)
- Output of `$ docker info`
- Version of this container (`$ echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright 2015-2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
