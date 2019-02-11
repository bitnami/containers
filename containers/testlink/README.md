# What is TestLink?

> TestLink is a web-based test management system that facilitates software quality assurance. It is developed and maintained by Teamtest. The platform offers support for test cases, test suites, test plans, test projects and user management, as well as various reports and statistics.

http://testlink.org/

# TL;DR;

## Docker Compose

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-testlink/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/testlink?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy TestLink in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami TestLink Chart GitHub repository](https://github.com/bitnami/charts/tree/master/upstreamed/testlink).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Supported tags and respective `Dockerfile` links

> NOTE: Debian 8 images have been deprecated in favor of Debian 9 images. Bitnami will not longer publish new Docker images based on Debian 8.

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/).


* [`1-ol-7`, `1.9.19-ol-7-r12` (1/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-testlink/blob/1.9.19-ol-7-r12/1/ol-7/Dockerfile)
* [`1-debian-9`, `1.9.19-debian-9-r12`, `1`, `1.9.19`, `1.9.19-r12`, `latest` (1/debian-9/Dockerfile)](https://github.com/bitnami/bitnami-docker-testlink/blob/1.9.19-debian-9-r12/1/debian-9/Dockerfile)

Subscribe to project updates by watching the [bitnami/testlink GitHub repo](https://github.com/bitnami/bitnami-docker-testlink).

# Prerequisites

To run this application you need Docker Engine 1.10.0. Docker Compose is recommended with a version 1.6.0 or later.

# How to use this image

## Run TestLink with a Database Container

Running TestLink with a database server is the recommended way. You can either use docker-compose or run the containers manually.

### Run the application using Docker Compose

This is the recommended way to run TestLink. You can use the following docker compose template:

```yaml
version: '2'

services:
  mariadb:
    image: 'bitnami/mariadb:latest'
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - MARIADB_USER=bn_testlink
      - MARIADB_DATABASE=bitnami_testlink
    volumes:
      - 'mariadb_data:/bitnami'
  testlink:
    image: 'bitnami/testlink:latest'
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - 'testlink_data:/bitnami'
    depends_on:
      - mariadb
    environment:
      - MARIADB_HOST=mariadb
      - MARIADB_PORT_NUMBER=3306
      - TESTLINK_DATABASE_USER=bn_testlink
      - TESTLINK_DATABASE_NAME=bitnami_testlink
      - ALLOW_EMPTY_PASSWORD=yes
      - TESTLINK_USERNAME=admin
      - TESTLINK_PASSWORD=verysecretadminpassword
      - TESTLINK_EMAIL=admin@example.com

volumes:
  mariadb_data:
    driver: local
  testlink_data:
    driver: local
```

### Run the application manually

If you want to run the application manually instead of using docker-compose, these are the basic steps you need to run:

1. Create a new network for the application and the database:

  ```bash
  $ docker network create testlink-tier
  ```

2. Create a volume for MariaDB persistence and create a MariaDB container

  ```bash
  $ docker volume create --name mariadb_data
  $ docker run -d --name mariadb \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MARIADB_USER=bn_testlink \
    -e MARIADB_DATABASE=bitnami_testlink \
    --net testlink-tier \
    --volume mariadb_data:/bitnami \
    bitnami/mariadb:latest
  ```

  *Note:* You need to give the container a name in order for TestLink to resolve the host

3. Create volumes for Testlink persistence and launch the container

  ```bash
  $ docker volume create --name testlink_data
  $ docker run -d --name testlink -p 80:80 -p 443:443 \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e TESTLINK_DATABASE_USER=bn_testlink \
    -e TESTLINK_DATABASE_NAME=bitnami_testlink \
    --net testlink-tier \
    --volume testlink_data:/bitnami \
    bitnami/testlink:latest
  ```

Then you can access your application at http://your-ip/

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. Additionally you should mount a volume for [persistence of the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#persisting-your-database).

The above examples define docker volumes namely `mariadb_data` and `testlink_data`. The TestLink application state will persist as long as these volumes are not removed.

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
      - MARIADB_USER=bn_testlink
      - MARIADB_DATABASE=bitnami_testlink
    volumes:
      - '/path/to/mariadb-persistence:/bitnami'
  testlink:
    image: 'bitnami/testlink:latest'
    environment:
      - TESTLINK_DATABASE_USER=bn_testlink
      - TESTLINK_DATABASE_NAME=bitnami_testlink
      - ALLOW_EMPTY_PASSWORD=yes
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - '/path/to/testlink-persistence:/bitnami'
    depends_on:
      - mariadb
```

### Mount host directories as data volumes using the Docker command line

In this case you need to specify the directories to mount on the run command. The process is the same than the one previously shown:

1. Create a network (if it does not exists):

  ```bash
  $ docker network create testlink-tier
  ```

2. Create a MariaDB container with host volume:

  ```bash
  $ docker run -d --name mariadb \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MARIADB_USER=bn_testlink \
    -e MARIADB_DATABASE=bitnami_testlink \
    --net testlink-tier \
    --volume /path/to/mariadb-persistence:/bitnami \
    bitnami/mariadb:latest
  ```

  *Note:* You need to give the container a name in order for TestLink to resolve the host

3. Run the TestLink container:

  ```bash
  $ docker run -d -p 80:80 -p 443:443 --name testlink \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e TESTLINK_DATABASE_USER=bn_testlink \
    -e TESTLINK_DATABASE_NAME=bitnami_testlink \
    --net testlink-tier \
    --volume /path/to/testlink-persistence:/bitnami \
    bitnami/testlink:latest
  ```

# Upgrade this application

Bitnami provides up-to-date versions of MariaDB and TestLink, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the TestLink container. For the MariaDB upgrade see https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#upgrade-this-image

1. Get the updated images:

  ```bash
  $ docker pull bitnami/testlink:latest
  ```

2. Stop your container

 * For docker-compose: `$ docker-compose stop testlink`
 * For manual execution: `$ docker stop testlink`

3. Take a snapshot of the application state

```bash
$ rsync -a /path/to/testlink-persistence /path/to/testlink-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

Additionally, [snapshot the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#step-2-stop-and-backup-the-currently-running-container)

You can use these snapshots to restore the application state should the upgrade fail.

4. Remove the stopped container

 * For docker-compose: `$ docker-compose rm testlink`
 * For manual execution: `$ docker rm testlink`

5. Run the new image

 * For docker-compose: `$ docker-compose up testlink`
 * For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name testlink bitnami/testlink:latest`

6. Execute upgrading steps
  In some cases you need to do some steps to finish the upgrading, please follow the [upgrading instructions from TestLink](https://github.com/TestLinkOpenSourceTRMS/testlink-code/#5-upgrade-and-migration). The TestLink install files are located at `/opt/bitnami/testlink_install`.

# Configuration

## Environment variables

When you start the testlink image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the docker run command line.

##### User and Site configuration

 - `TESTLINK_USERNAME`: TestLink admin username. Default: **user**
 - `TESTLINK_PASSWORD`: TestLink admin password. Default: **bitnami**
 - `TESTLINK_EMAIL`: TestLink admin email. Default: **user@example.com**
 - `TESTLINK_LANGUAGE`: TestLink default language. Default: **en_US**

##### Use an existing database

- `MARIADB_HOST`: Hostname for MariaDB server. Default: **mariadb**
- `MARIADB_PORT_NUMBER`: Port used by MariaDB server. Default: **3306**
- `TESTLINK_DATABASE_NAME`: Database name that TestLink will use to connect with the database. Default: **bitnami_testlink**
- `TESTLINK_DATABASE_USER`: Database user that TestLink will use to connect with the database. Default: **bn_testlink**
- `TESTLINK_DATABASE_PASSWORD`: Database password that TestLink will use to connect with the database. No defaults.
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

##### Create a database for TestLink using mysql-client

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
testlink:
  image: bitnami/testlink:latest
  ports:
    - '80:80'
    - '443:443'
  environment:
    - TESTLINK_PASSWORD=my_password
```

 * For manual execution add a `-e` option with each variable and value:

  ```bash
  $ docker run -d -p 80:80 -p 443:443 --name testlink
    -e TESTLINK_PASSWORD=my_password \
    --net testlink-tier \
    --volume /path/to/testlink-persistence:/bitnami/testlink \
    --volume /path/to/apache-persistence:/bitnami/apache \
    --volume /path/to/php-persistence:/bitnami/php \
    bitnami/testlink:latest
  ```

### SMTP Configuration

To configure TestLink to send email using SMTP you can set the following environment variables:

 - `SMTP_ENABLE`: Enable SMTP mail delivery.
 - `SMTP_HOST`: SMTP host.
 - `SMTP_PORT`: SMTP port.
 - `SMTP_USER`: SMTP account user.
 - `SMTP_PASSWORD`: SMTP account password.
 - `SMTP_CONNECTION_MODE`: SMTP connection mode, `ssl` or `tls`.

This would be an example of SMTP configuration using a GMail account:

 * docker-compose:

  ```yaml
  testlink:
    image: bitnami/testlink:latest
    ports:
      - '80:80'
      - '443:443'
    environment:
      - MARIADB_HOST=mariadb
      - MARIADB_PORT_NUMBER=3306
      - TESTLINK_DATABASE_USER=bn_testlink
      - TESTLINK_DATABASE_NAME=bitnami_testlink
      - SMTP_ENABLE=true
      - SMTP_HOST=smtp.gmail.com
      - SMTP_PORT=587
      - SMTP_USER=your_email@gmail.com
      - SMTP_PASSWORD=your_password
      - SMTP_CONNECTION_MODE=tls
  ```

 * For manual execution:

  ```bash
  $ docker run -d -p 80:80 -p 443:443 --name testlink \
    -e MARIADB_HOST=mariadb \
    -e MARIADB_PORT_NUMBER=3306 \
    -e TESTLINK_DATABASE_USER=bn_testlink \
    -e TESTLINK_DATABASE_NAME=bitnami_testlink \
    -e SMTP_ENABLE=true \
    -e SMTP_HOST=smtp.gmail.com -e SMTP_PORT=587 \
    -e SMTP_USER=your_email@gmail.com \
    -e SMTP_PASSWORD=your_password \
    -e SMTP_CONNECTION_MODE=tls \
    --net testlink-tier \
    --volume /path/to/testlink-persistence:/bitnami \
    bitnami/testlink:latest
  ```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-testlink/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-testlink/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-testlink/issues). For us to provide better support, be sure to include the following information in your issue:

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
