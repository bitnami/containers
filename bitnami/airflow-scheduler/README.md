# Apache Airflow Scheduler packaged by Bitnami

## What is Apache Airflow Scheduler?

> Apache Airflow is a tool to express and execute workflows as directed acyclic graphs (DAGs). The Airflow scheduler triggers tasks and provides tools to monitor task progress.

[Overview of Apache Airflow Scheduler](https://airflow.apache.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

### Docker Compose

```console
$ curl -LO https://raw.githubusercontent.com/bitnami/containers/main/bitnami/airflow-scheduler/docker-compose.yml
$ docker-compose up
```

You can find the default credentials and available configuration options in the [Environment Variables](#environment-variables) section.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Prerequisites

To run this application you need [Docker Engine](https://www.docker.com/products/docker-engine) >= `1.10.0`. [Docker Compose](https://docs.docker.com/compose/) is recommended with a version `1.6.0` or later.

## How to use this image

Apache Airflow Scheduler is a component of an Airflow solution configuring with the `CeleryExecutor`. Hence, you will need to rest of Airflow components for this image to work.
You will need an [Airflow Webserver](https://github.com/bitnami/containers/tree/main/bitnami/airflow), one or more [Airflow Workers](https://github.com/bitnami/containers/tree/main/bitnami/airflow-worker), a [PostgreSQL database](https://github.com/bitnami/containers/tree/main/bitnami/postgresql) and a [Redis(R) server](https://github.com/bitnami/containers/tree/main/bitnami/redis).

### Using Docker Compose

The main folder of this repository contains a functional [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/airflow-scheduler/docker-compose.yml) file. Run the application using it as shown below:

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/containers/main/bitnami/airflow-scheduler/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

### Using the Docker Command Line

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

3. Create a volume for Redis(R) persistence and create a Redis(R) container

  ```console
  $ docker volume create --name redis_data
  $ docker run -d --name redis \
    -e ALLOW_EMPTY_PASSWORD=yes \
    --net airflow-tier \
    --volume redis_data:/bitnami \
    bitnami/redis:latest
  ```

4. Launch the Apache Airflow Scheduler web container

  ```console
  $ docker run -d --name airflow -p 8080:8080 \
    -e AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho= \
    -e AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08= \
    -e AIRFLOW_EXECUTOR=CeleryExecutor \
    -e AIRFLOW_DATABASE_NAME=bitnami_airflow \
    -e AIRFLOW_DATABASE_USERNAME=bn_airflow \
    -e AIRFLOW_DATABASE_PASSWORD=bitnami1 \
    -e AIRFLOW_LOAD_EXAMPLES=yes \
    -e AIRFLOW_PASSWORD=bitnami123 \
    -e AIRFLOW_USERNAME=user \
    -e AIRFLOW_EMAIL=user@example.com \
    --net airflow-tier \
    bitnami/airflow:latest
  ```

5. Launch the Apache Airflow Scheduler scheduler container

  ```console
  $ docker run -d --name airflow-scheduler \
    -e AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho= \
    -e AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08= \
    -e AIRFLOW_EXECUTOR=CeleryExecutor \
    -e AIRFLOW_DATABASE_NAME=bitnami_airflow \
    -e AIRFLOW_DATABASE_USERNAME=bn_airflow \
    -e AIRFLOW_DATABASE_PASSWORD=bitnami1 \
    -e AIRFLOW_LOAD_EXAMPLES=yes \
    --net airflow-tier \
    bitnami/airflow-scheduler:latest
  ```

6. Launch the Apache Airflow Scheduler worker container

  ```console
  $ docker run -d --name airflow-worker \
    -e AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho= \
    -e AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08= \
    -e AIRFLOW_EXECUTOR=CeleryExecutor \
    -e AIRFLOW_DATABASE_NAME=bitnami_airflow \
    -e AIRFLOW_DATABASE_USERNAME=bn_airflow \
    -e AIRFLOW_DATABASE_PASSWORD=bitnami1 \
    --net airflow-tier \
    bitnami/airflow-worker:latest
  ```

Access your application at `http://your-ip:8080`

### Persisting your application

The Bitnami Airflow container relies on the PostgreSQL database & Redis to persist the data. This means that Airflow does not persist anything. To avoid loss of data, you should mount volumes for persistence of [PostgreSQL data](https://github.com/bitnami/containers/blob/main/bitnami/mariadb#persisting-your-database) and [Redis(R) data](https://github.com/bitnami/containers/blob/main/bitnami/redis#persisting-your-database)

The above examples define docker volumes namely `postgresql_data`, and `redis_data`. The Airflow application state will persist as long as these volumes are not removed.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

#### Mount host directories as data volumes with Docker Compose

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
      - /path/to/postgresql-persistence:/bitnami
  redis:
    image: 'bitnami/redis:latest'
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - /path/to/redis-persistence:/bitnami
  airflow-worker:
    image: bitnami/airflow-worker:latest
    environment:
      - AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho=
      - AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08=
      - AIRFLOW_EXECUTOR=CeleryExecutor
      - AIRFLOW_DATABASE_NAME=bitnami_airflow
      - AIRFLOW_DATABASE_USERNAME=bn_airflow
      - AIRFLOW_DATABASE_PASSWORD=bitnami1
      - AIRFLOW_LOAD_EXAMPLES=yes
  airflow-scheduler:
    image: bitnami/airflow-scheduler:latest
    environment:
      - AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho=
      - AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08=
      - AIRFLOW_EXECUTOR=CeleryExecutor
      - AIRFLOW_DATABASE_NAME=bitnami_airflow
      - AIRFLOW_DATABASE_USERNAME=bn_airflow
      - AIRFLOW_DATABASE_PASSWORD=bitnami1
      - AIRFLOW_LOAD_EXAMPLES=yes
  airflow:
    image: bitnami/airflow:latest
    environment:
      - AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho=
      - AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08=
      - AIRFLOW_EXECUTOR=CeleryExecutor
      - AIRFLOW_DATABASE_NAME=bitnami_airflow
      - AIRFLOW_DATABASE_USERNAME=bn_airflow
      - AIRFLOW_DATABASE_PASSWORD=bitnami1
      - AIRFLOW_PASSWORD=bitnami123
      - AIRFLOW_USERNAME=user
      - AIRFLOW_EMAIL=user@example.com
    ports:
      - '8080:8080'
```

#### Mount host directories as data volumes using the Docker command line

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

3. Create the Redis(R) container with host volumes

  ```console
  $ docker run -d --name redis \
    -e ALLOW_EMPTY_PASSWORD=yes \
    --net airflow-tier \
    --volume /path/to/redis-persistence:/bitnami \
    bitnami/redis:latest
  ```

4. Create the Airflow container

  ```console
  $ docker run -d --name airflow -p 8080:8080 \
    -e AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho= \
    -e AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08= \
    -e AIRFLOW_EXECUTOR=CeleryExecutor \
    -e AIRFLOW_DATABASE_NAME=bitnami_airflow \
    -e AIRFLOW_DATABASE_USERNAME=bn_airflow \
    -e AIRFLOW_DATABASE_PASSWORD=bitnami1 \
    -e AIRFLOW_LOAD_EXAMPLES=yes \
    -e AIRFLOW_PASSWORD=bitnami123 \
    -e AIRFLOW_USERNAME=user \
    -e AIRFLOW_EMAIL=user@example.com \
    --net airflow-tier \
    bitnami/airflow:latest
  ```

5. Create the Apache Airflow Scheduler container

  ```console
  $ docker run -d --name airflow-scheduler \
    -e AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho= \
    -e AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08= \
    -e AIRFLOW_EXECUTOR=CeleryExecutor \
    -e AIRFLOW_DATABASE_NAME=bitnami_airflow \
    -e AIRFLOW_DATABASE_USERNAME=bn_airflow \
    -e AIRFLOW_DATABASE_PASSWORD=bitnami1 \
    -e AIRFLOW_LOAD_EXAMPLES=yes \
    --net airflow-tier \
    bitnami/airflow-scheduler:latest
  ```

6. Create the Airflow Worker container

  ```console
  $ docker run -d --name airflow-worker \
    -e AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho= \
    -e AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08= \
    -e AIRFLOW_EXECUTOR=CeleryExecutor \
    -e AIRFLOW_DATABASE_NAME=bitnami_airflow \
    -e AIRFLOW_DATABASE_USERNAME=bn_airflow \
    -e AIRFLOW_DATABASE_PASSWORD=bitnami1 \
    --net airflow-tier \
    bitnami/airflow-worker:latest
  ```

## Configuration

### Installing additional python modules

This container supports the installation of additional python modules at start-up time. In order to do that, you can mount a `requirements.txt` file with your specific needs under the path `/bitnami/python/requirements.txt`.

### Environment variables

The Apache Airflow Scheduler instance can be customized by specifying environment variables on the first run. The following environment values are provided to customize Apache Airflow Scheduler:

###### Apache Airflow Scheduler configuration

- `AIRFLOW_EXECUTOR`: Apache Airflow Scheduler executor. Default: **SequentialExecutor**
- `AIRFLOW_FERNET_KEY`: Apache Airflow Scheduler Fernet key. No defaults.
- `AIRFLOW_SECRET_KEY`: Apache Airflow Scheduler Secret key. No defaults.
- `AIRFLOW_WEBSERVER_HOST`: Apache Airflow Scheduler webserver host. Default: **airflow**
- `AIRFLOW_WEBSERVER_PORT_NUMBER`: Apache Airflow Scheduler webserver port. Default: **8080**
- `AIRFLOW_LOAD_EXAMPLES`: To load example tasks into the application. Default: **yes**
- `AIRFLOW_HOSTNAME_CALLABLE`: Method to obtain the hostname. No defaults.

###### Use an existing database

- `AIRFLOW_DATABASE_HOST`: Hostname for PostgreSQL server. Default: **postgresql**
- `AIRFLOW_DATABASE_PORT_NUMBER`: Port used by PostgreSQL server. Default: **5432**
- `AIRFLOW_DATABASE_NAME`: Database name that Apache Airflow Scheduler will use to connect with the database. Default: **bitnami_airflow**
- `AIRFLOW_DATABASE_USERNAME`: Database user that Apache Airflow Scheduler will use to connect with the database. Default: **bn_airflow**
- `AIRFLOW_DATABASE_PASSWORD`: Database password that Apache Airflow Scheduler will use to connect with the database. No defaults.
- `AIRFLOW_DATABASE_USE_SSL`: Set to yes if the database uses SSL. Default: **no**
- `AIRFLOW_REDIS_USE_SSL`: Set to yes if Redis(R) uses SSL. Default: **no**
- `REDIS_HOST`: Hostname for Redis(R) server. Default: **redis**
- `REDIS_PORT_NUMBER`: Port used by Redis(R) server. Default: **6379**
- `REDIS_USER`: USER that Apache Airflow Scheduler will use to connect with Redis(R). No defaults.
- `REDIS_PASSWORD`: Password that Apache Airflow Scheduler will use to connect with Redis(R). No defaults.
- `REDIS_DATABASE`: Database number for Redis(R) server. Default: **1**

> In addition to the previous environment variables, all the parameters from the configuration file can be overwritten by using environment variables with this format: `AIRFLOW__{SECTION}__{KEY}`. Note the double underscores.

#### Specifying Environment variables using Docker Compose

```yaml
version: '2'

services:
  airflow:
    image: bitnami/airflow:1
    environment:
      - AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho=
      - AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08=
      - AIRFLOW_EXECUTOR=CeleryExecutor
      - AIRFLOW_DATABASE_NAME=bitnami_airflow
      - AIRFLOW_DATABASE_USERNAME=bn_airflow
      - AIRFLOW_DATABASE_PASSWORD=bitnami1
      - AIRFLOW_PASSWORD=bitnami123
      - AIRFLOW_USERNAME=user
      - AIRFLOW_EMAIL=user@example.com
```

#### Specifying Environment variables on the Docker command line

```console
$ docker run -d --name airflow -p 8080:8080 \
    -e AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho= \
    -e AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08= \
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

## Notable Changes

### 1.10.15-debian-10-r18 and 2.0.1-debian-10-r52

- The size of the container image has been decreased.
- The configuration logic is now based on Bash scripts in the *rootfs/* folder.

## Contributing

We'd love for you to contribute to this Docker image. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/containers/issues/new/choose). For us to provide better support, be sure to fill the issue template.

## License

Copyright &copy; 2023 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
