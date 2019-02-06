# What is Moodle?

>Moodle is a very popular open source learning management solution (LMS) for the delivery of elearning courses and programs. It’s used not only by universities, but also by hundreds of corporations around the world who provide eLearning education for their employees. Moodle features a simple interface, drag-and-drop features, role-based permissions, deep reporting, many language translations, a well-documented API and more. With some of the biggest universities and organizations already using it, Moodle is ready to meet the needs of just about any size organization.

https://moodle.org/

# TL;DR;

## Docker Compose

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-moodle/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/moodle?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy Moodle in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Moodle Chart GitHub repository](https://github.com/bitnami/charts/tree/master/upstreamed/moodle).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Supported tags and respective `Dockerfile` links

> NOTE: Debian 8 images have been deprecated in favor of Debian 9 images. Bitnami will not longer publish new Docker images based on Debian 8.

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/).


* [`3-ol-7`, `3.6.2-ol-7-r23` (3/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-moodle/blob/3.6.2-ol-7-r23/3/ol-7/Dockerfile)
* [`3-debian-9`, `3.6.2-debian-9-r20`, `3`, `3.6.2`, `3.6.2-r20`, `latest` (3/debian-9/Dockerfile)](https://github.com/bitnami/bitnami-docker-moodle/blob/3.6.2-debian-9-r20/3/debian-9/Dockerfile)

Subscribe to project updates by watching the [bitnami/moodle GitHub repo](https://github.com/bitnami/bitnami-docker-moodle).

# Prerequisites

To run this application you need Docker Engine 1.10.0. Docker Compose is recomended with a version 1.6.0 or later.

# How to use this image

## Run Moodle with a Database Container

Running Moodle with a database server is the recommended way. You can either use docker-compose or run the containers manually.

### Run the application using Docker Compose

This is the recommended way to run Moodle. You can use the following docker compose template:

```yaml
version: '2'

services:
  mariadb:
    image: 'bitnami/mariadb:latest'
    environment:
      - MARIADB_USER=bn_moodle
      - MARIADB_DATABASE=bitnami_moodle
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - 'mariadb_data:/bitnami'
  moodle:
    image: 'bitnami/moodle:latest'
    environment:
      - MARIADB_HOST=mariadb
      - MARIADB_PORT_NUMBER=3306
      - MOODLE_DATABASE_USER=bn_moodle
      - MOODLE_DATABASE_NAME=bitnami_moodle
      - ALLOW_EMPTY_PASSWORD=yes
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - 'moodle_data:/bitnami'
    depends_on:
      - mariadb

volumes:
  mariadb_data:
    driver: local
  moodle_data:
    driver: local
```

### Run the application manually

If you want to run the application manually instead of using docker-compose, these are the basic steps you need to run:

1. Create a new network for the application and the database:

  ```bash
  $ docker network create moodle-tier
  ```

2. Create a volume for MariaDB persistence and create a MariaDB container

  ```bash
  $ docker volume create --name mariadb_data
  $ docker run -d --name mariadb \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MARIADB_USER=bn_moodle \
    -e MARIADB_DATABASE=bitnami_moodle \
    --net moodle-tier \
    --volume mariadb_data:/bitnami \
    bitnami/mariadb:latest
  ```

  *Note:* You need to give the container a name in order to Moodle to resolve the host

3. Create volumes for Moodle persistence and launch the container

  ```bash
  $ docker volume create --name moodle_data
  $ docker run -d --name moodle -p 80:80 -p 443:443 \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MOODLE_DATABASE_USER=bn_moodle \
    -e MOODLE_DATABASE_NAME=bitnami_moodle \
    --net moodle-tier \
    --volume moodle_data:/bitnami \
    bitnami/moodle:latest
  ```

Then you can access your application at http://your-ip/

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. Additionally you should mount a volume for [persistence of the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#persisting-your-database).

The above examples define docker volumes namely `mariadb_data` and `moodle_data`. The Moodle application state will persist as long as these volumes are not removed.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount persistent folders in the host using docker-compose

This requires a sightly modification from the template previously shown:

```yaml
version: '2'

services:
  mariadb:
    image: 'bitnami/mariadb:latest'
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - MARIADB_USER=bn_moodle
      - MARIADB_DATABASE=bitnami_moodle
    volumes:
      - '/path/to/mariadb-persistence:/bitnami'
  moodle:
    image: 'bitnami/moodle:latest'
    environment:
      - MOODLE_DATABASE_USER=bn_moodle
      - MOODLE_DATABASE_NAME=bitnami_moodle
      - ALLOW_EMPTY_PASSWORD=yes
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - '/path/to/moodle-persistence:/bitnami'
    depends_on:
      - mariadb
```

### Mount persistent folders manually

In this case you need to specify the directories to mount on the run command. The process is the same than the one previously shown:

1. If you haven't done this before, create a new network for the application and the database:

  ```bash
  $ docker network create moodle-tier
  ```

2. Start a MariaDB database in the previous network:

  ```bash
  $ docker run -d --name mariadb \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MARIADB_USER=bn_moodle \
    -e MARIADB_DATABASE=bitnami_moodle \
    -v /path/to/mariadb-persistence:/bitnami \
    --net moodle-tier \
    bitnami/mariadb:latest
  ```

  *Note:* You need to give the container a name in order to Moodle to resolve the host

3. Run the Moodle container:

  ```bash
  $ docker run -d -p 80:80 -p 443:443 --name moodle \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MOODLE_DATABASE_USER=bn_moodle \
    -e MOODLE_DATABASE_NAME=bitnami_moodle \
    --net moodle-tier \
    --volume /path/to/moodle-persistence:/bitnami \
    bitnami/moodle:latest
  ```

# Upgrade this application

> **NOTE:** Since Moodle 3.4.0-r1, the application upgrades should be done manually inside the docker container following the [official documentation](https://docs.moodle.org/34/en/Upgrading).

> As an alternative, you can try upgrading using an updated docker image but any data from the Moodle container will be lost and you will have to reinstall all the plugins and themes you manually added.

Bitnami provides up-to-date versions of MariaDB and Moodle, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the Moodle container. For the MariaDB upgrade see https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#upgrade-this-image

1. Get the updated images:

  ```bash
  $ docker pull bitnami/moodle:latest
  ```

2. Stop your container

 * For docker-compose: `$ docker-compose stop moodle`
 * For manual execution: `$ docker stop moodle`

3. Take a snapshot of the application state

```bash
$ rsync -a /path/to/moodle-persistence /path/to/moodle-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

Additionally, [snapshot the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#step-2-stop-and-backup-the-currently-running-container)

You can use these snapshots to restore the application state should the upgrade fail.

4. Remove the currently running container

 * For docker-compose: `$ docker-compose rm -v moodle`
 * For manual execution: `$ docker rm -v moodle`

5. Remove the persisted data. This is needed from 3.4.0-r1 since the whole installation is persisted and otherwise the new docker image will use an old application code.

    * Get the volume containing the persisted data

    ```bash
    $ docker volume ls
    ```

    * Remove the volume

    ```bash
    $ docker volume rm YOUR_VOLUME
    ```

6. Run the new image

 * For docker-compose: `$ docker-compose up moodle`
 * For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name moodle bitnami/moodle:latest`

# Configuration

## Environment variables

When you start the moodle image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the docker run command line.

##### User and Site configuration

 - `MOODLE_USERNAME`: Moodle application username. Default: **user**
 - `MOODLE_PASSWORD`: Moodle application password. Default: **bitnami**
 - `MOODLE_EMAIL`: Moodle application email. Default: **user@example.com**

##### Use an existing database

- `MARIADB_HOST`: Hostname for MariaDB server. Default: **mariadb**
- `MARIADB_PORT_NUMBER`: Port used by MariaDB server. Default: **3306**
- `MOODLE_DATABASE_NAME`: Database name that Moodle will use to connect with the database. Default: **bitnami_moodle**
- `MOODLE_DATABASE_USER`: Database user that Moodle will use to connect with the database. Default: **bn_moodle**
- `MOODLE_DATABASE_PASSWORD`: Database password that Moodle will use to connect with the database. No defaults.
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

##### Create a database for Moodle using mysql-client

- `MARIADB_HOST`: Hostname for MariaDB server. Default: **mariadb**
- `MARIADB_PORT_NUMBER`: Port used by MariaDB server. Default: **3306**
- `MARIADB_ROOT_USER`: Database admin user. Default: **root**
- `MARIADB_ROOT_PASSWORD`: Database password for the `MARIADB_ROOT_USER` user. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_NAME`: New database to be created by the mysql client module. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_USER`: New database user to be created by the mysql client module. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_PASSWORD`: Database password for the `MYSQL_CLIENT_CREATE_DATABASE_USER` user. No defaults.
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

If you want to add a new environment variable:

 * For docker-compose add the variable name and value under the application section:

```yaml
moodle:
  image: bitnami/moodle:latest
  ports:
    - 80:80
    - 443:443
  environment:
    - MOODLE_PASSWORD=my_password
```

 * For manual execution add a `-e` option with each variable and value:

   ```bash
   $ docker run -d  -p 80:80 -p 443:443 --name moodle
     -e MOODLE_PASSWORD=my_password \
     --net moodle-tier \
     --volume /path/to/moodle-persistence:/bitnami \
     bitnami/moodle:latest
   ```

### SMTP Configuration

To configure Moodle to send email using SMTP you can set the following environment variables:

 - `SMTP_HOST`: SMTP host.
 - `SMTP_PORT`: SMTP port.
 - `SMTP_USER`: SMTP account user.
 - `SMTP_PASSWORD`: SMTP account password.
 - `SMTP_PROTOCOL`: SMTP protocol.

This would be an example of SMTP configuration using a GMail account:

 * docker-compose:

  ```yaml
  moodle:
    image: bitnami/moodle:latest
    ports:
      - 80:80
      - 443:443
    environment:
      - MARIADB_HOST=mariadb
      - MARIADB_PORT_NUMBER=3306
      - MOODLE_DATABASE_USER=bn_moodle
      - MOODLE_DATABASE_NAME=bitnami_moodle
      - SMTP_HOST=smtp.gmail.com
      - SMTP_PORT=587
      - SMTP_USER=your_email@gmail.com
      - SMTP_PASSWORD=your_password
      - SMTP_PROTOCOL=tls
  ```

* For manual execution:

  ```bash
  $ docker run -d  -p 80:80 -p 443:443 --name moodle
    -e MARIADB_HOST=mariadb \
    -e MARIADB_PORT_NUMBER=3306 \
    -e MOODLE_DATABASE_USER=bn_moodle \
    -e MOODLE_DATABASE_NAME=bitnami_moodle \
    -e SMTP_HOST=smtp.gmail.com \
    -e SMTP_PORT=587 \
    -e SMTP_USER=your_email@gmail.com \
    -e SMTP_PASSWORD=your_password \
    --net moodle-tier \
    --volume /path/to/moodle-persistence:/bitnami \
    bitnami/moodle:latest
  ```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-moodle/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-moodle/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-moodle/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`$ docker version`)
- Output of `$ docker info`
- Version of this container (`$ echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright 2016-2019 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
