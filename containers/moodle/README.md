[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-moodle/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-moodle/tree/master)
[![Slack](http://slack.oss.bitnami.com/badge.svg)](http://slack.oss.bitnami.com)
[![Kubectl](https://img.shields.io/badge/kubectl-Available-green.svg)](https://raw.githubusercontent.com/bitnami/bitnami-docker-moodle/master/kubernetes.yml)
# What is Moodle?

>Moodle is a very popular open source learning management solution (LMS) for the delivery of elearning courses and programs. It’s used not only by universities, but also by hundreds of corporations around the world who provide eLearning education for their employees. Moodle features a simple interface, drag-and-drop features, role-based permissions, deep reporting, many language translations, a well-documented API and more. With some of the biggest universities and organizations already using it, Moodle is ready to meet the needs of just about any size organization.

https://www.moodle.org/

# TL;DR;

```bash
$ curl -LO https://raw.githubusercontent.com/bitnami/bitnami-docker-moodle/master/docker-compose.yml
$ docker-compose up
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* Bitnami images are built on CircleCI and automatically pushed to the Docker Hub.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.

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
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - 'mariadb_data:/bitnami/mariadb'
  moodle:
    image: 'bitnami/moodle:latest'
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - 'moodle_data:/bitnami/moodle'
      - 'apache_data:/bitnami/apache'
      - 'php_data:/bitnami/php'
    depends_on:
      - mariadb

volumes:
  mariadb_data:
    driver: local
  moodle_data:
    driver: local
  apache_data:
    driver: local
```

### Run the application manually

If you want to run the application manually instead of using docker-compose, these are the basic steps you need to run:

1. Create a new network for the application and the database:

  ```bash
  $ docker network create moodle-tier
  ```

2. Start a MariaDB database in the network generated:

  ```bash
  $ docker run -d --name mariadb -e ALLOW_EMPTY_PASSWORD=yes --net moodle-tier bitnami/mariadb
  ```

  *Note:* You need to give the container a name in order to Moodle to resolve the host

3. Run the Moodle container:

  ```bash
  $ docker run -d -p 80:80 -p 443:443 --name moodle --net moodle-tier bitnami/moodle
  ```

Then you can access your application at http://your-ip/

## Persisting your application

If you remove every container all your data will be lost, and the next time you run the image the application will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed. If you are using docker-compose your data will be persistent as long as you don't remove `mariadb_data`, `apache_data`, `php_data` and `moodle_data` containers. Those are data volume containers (See https://docs.docker.com/engine/userguide/containers/dockervolumes/ for more information). If you have run the containers manually or you want to mount the folders with persistent data in your host follow the next steps:

> **Note!** If you have already started using your application, follow the steps on [backing](#backing-up-your-application) up to pull the data from your running container down to your host.

### Mount persistent folders in the host using docker-compose

This requires a sightly modification from the template previously shown:
```yaml
version: '2'

services:
  mariadb:
    image: 'bitnami/mariadb:latest'
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - '/path/to/mariadb-persistence:/bitnami/mariadb'
  moodle:
    image: 'bitnami/moodle:latest'
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - '/path/to/moodle-persistence:/bitnami/moodle'
      - '/path/to/apache-persistence:/bitnami/apache'
      - '/path/to/php-persistence:/bitnami/php'
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
  $ docker run -d --name mariadb -e ALLOW_EMPTY_PASSWORD=yes -v /path/to/mariadb-persistence:/bitnami/mariadb --net moodle-tier bitnami/mariadb:latest
  ```

  *Note:* You need to give the container a name in order to Moodle to resolve the host

3. Run the Moodle container:

  ```bash
  $ docker run -d -p 80:80 -p 443:443 --name moodle \
    --net moodle-tier \
    --volume /path/to/moodle-persistence:/bitnami/moodle \
    --volume /path/to/apache-persistence:/bitnami/moodle \
    --volume /path/to/php-persistence:/bitnami/moodle \
    bitnami/moodle:latest
  ```

# Upgrade this application

Bitnami provides up-to-date versions of MariaDB and Moodle, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the Moodle container. For the MariaDB upgrade see https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#upgrade-this-image

1. Get the updated images:

  ```bash
  $ docker pull bitnami/moodle:latest
  ```

2. Stop your container

 * For docker-compose: `$ docker-compose stop moodle`
 * For manual execution: `$ docker stop moodle`

3. (For non-compose execution only) Create a [backup](#backing-up-your-application) if you have not mounted the moodle folder in the host.

4. Remove the currently running container

 * For docker-compose: `$ docker-compose rm -v moodle`
 * For manual execution: `$ docker rm -v moodle`

5. Run the new image

 * For docker-compose: `$ docker-compose start moodle`
 * For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name moodle bitnami/moodle:latest`

  *Note:* If you upgrade you will have to reinstall all the plugins and themes you manually added.


# Configuration
## Environment variables
 When you start the moodle image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the docker run command line. If you want to add a new environment variable:

 * For docker-compose add the variable name and value under the application section:
```yaml
moodle:
  image: bitnami/moodle:latest
  ports:
    - 80:80
    - 443:443
  environment:
    - MOODLE_PASSWORD=my_password
  volumes_from:
    - moodle_data
    - apache_data
    - php_data
```

 * For manual execution add a `-e` option with each variable and value:

   ```bash
   $ docker run -d  -p 80:80 -p 443:443 --name moodle
     -e MOODLE_PASSWORD=my_password \
     --net moodle-tier \
     --volume /path/to/moodle-persistence:/bitnami/moodle \
     --volume /path/to/apache-persistence:/bitnami/moodle \
     --volume /path/to/php-persistence:/bitnami/moodle \
     bitnami/moodle:latest
   ```

Available variables:

 - `MOODLE_USERNAME`: Moodle application username. Default: **user**
 - `MOODLE_PASSWORD`: Moodle application password. Default: **bitnami**
 - `MOODLE_EMAIL`: Moodle application email. Default: **user@example.com**
 - `MARIADB_USER`: Root user for the MariaDB database. Default: **root**
 - `MARIADB_PASSWORD`: Root password for the MariaDB.
 - `MARIADB_HOST`: Hostname for MariaDB server. Default: **mariadb**
 - `MARIADB_PORT`: Port used by MariaDB server. Default: **3306**


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
      - SMTP_HOST=smtp.gmail.com
      - SMTP_PORT=587
      - SMTP_USER=your_email@gmail.com
      - SMTP_PASSWORD=your_password
      - SMTP_PROTOCOL=tls
    volumes_from:
      - moodle_data
      - apache_data
      - php_data
```

* For manual execution:

  ```bash
   $ docker run -d  -p 80:80 -p 443:443 --name moodle
     -e SMTP_HOST=smtp.gmail.com \
     -e SMTP_PORT=587 \
     -e SMTP_USER=your_email@gmail.com \
     -e SMTP_PASSWORD=your_password \
     --net moodle-tier \
     --volume /path/to/moodle-persistence:/bitnami/moodle \
     --volume /path/to/apache-persistence:/bitnami/moodle \
     --volume /path/to/php-persistence:/bitnami/moodle \
     bitnami/moodle:latest
   ```

# Backing up your application

To backup your application data follow these steps:

1. Stop the running container:

  * For docker-compose: `$ docker-compose stop moodle`
  * For manual execution: `$ docker stop moodle`

2. Copy the Moodle data folder in the host:

  ```bash
  $ docker cp /path/to/moodle-persistence:/bitnami/moodle
  $ docker cp /path/to/apache-persistence:/bitnami/apache
  $ docker cp /path/to/php-persistence:/bitnami/php
  ```

# Restoring a backup

To restore your application using backed up data simply mount the folder with Moodle data in the container. See [persisting your application](#persisting-your-application) section for more info.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an
[issue](https://github.com/bitnami/bitnami-docker-moodle/issues), or submit a
[pull request](https://github.com/bitnami/bitnami-docker-moodle/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an
[issue](https://github.com/bitnami/bitnami-docker-moodle/issues). For us to provide better support,
be sure to include the following information in your issue:

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

Copyright (c) 2017 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
