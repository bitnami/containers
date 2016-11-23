[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-redmine/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-redmine/tree/master)
[![Docker Hub Automated Build](http://container.checkforupdates.com/badges/bitnami/redmine)](https://hub.docker.com/r/bitnami/redmine/)

# What is Redmine?

> Redmine is a flexible project management web application. Written using the Ruby on Rails framework, it is cross-platform and cross-database.

https://redmine.org/

# TL;DR;

```bash
$ curl -LO https://raw.githubusercontent.com/bitnami/bitnami-docker-redmine/master/docker-compose.yml
$ docker-compose up
```

# Prerequisites

To run this application you need Docker Engine 1.10.0. Docker Compose is recomended with a version 1.6.0 or later.

# How to use this image

## Run Redmine with a Database Container

Running Redmine with a database server is the recommended way. You can either use docker-compose or run the containers manually.

### Run the application using Docker Compose

This is the recommended way to run Redmine. You can use the following docker compose template:

```yaml
version: '2'

services:
  mariadb:
    image: 'bitnami/mariadb:latest'
    volumes:
      - 'mariadb_data:/bitnami/mariadb'
  application:
    image: 'bitnami/redmine:latest'
    ports:
      - '80:3000'
    volumes:
      - 'redmine_data:/bitnami/redmine'
    depends_on:
      - mariadb
volumes:
  mariadb_data:
    driver: local
  redmine_data:
    driver: local
```

### Run the application manually

If you want to run the application manually instead of using docker-compose, these are the basic steps you need to run:

1. Create a new network for the application and the database:

  ```
  $ docker network create redmine_network
  ```

2. Start a MariaDB database in the network generated:

  ```
  $ docker run -d --name mariadb --net=redmine_network bitnami/mariadb
  ```

  *Note:* You need to give the container a name in order to Redmine to resolve the host

3. Run the Redmine container:

  ```
  $ docker run -d -p 80:3000 --name redmine --net=redmine_network bitnami/redmine
  ```

Then you can access your application at http://your-ip/

## Persisting your application

If you remove every container and volume all your data will be lost, and the next time you run the image the application will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence of the Redmine deployment, the above examples define docker volumes namely `mariadb_data` and `redmine_data`. The Redmine application state will persist as long as these volumes are not removed.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

> **Note!** If you have already started using your application, follow the steps on [backing](#backing-up-your-application) up to pull the data from your running container down to your host.

### Mount host directories as data volumes with Docker Compose

The following `docker-compose.yml` template demonstrates the use of host directories as data volumes.

```yaml
version: '2'

  mariadb:
    image: 'bitnami/mariadb:latest'
    volumes:
      - '/path/to/mariadb-persistence:/bitnami/mariadb'
  redmine:
    image: bitnami/redmine:latest
    ports:
      - 80:3000
    volumes:
      - '/path/to/redmine-persistence:/bitnami/redmine'
```

### Mount host directories as data volumes using the Docker command line

1. Create a network (if it does not exist):

  ```
  $ docker network create redmine-tier
  ```

2. Create a MariaDB container with host volume:

  ```
  $ docker run -d --name mariadb \
    --net redmine-tier \
    --volume /path/to/mariadb-persistence:/bitnami/mariadb \
    bitnami/mariadb:latest
  ```

  *Note:* You need to give the container a name in order to Redmine to resolve the host

3. Run the Redmine container:

  ```
  $ docker run -d --name redmine -p 80:3000 \
    --net redmine-tier \
    --volume /path/to/redmine-persistence:/bitnami/redmine \
  bitnami/redmine:latest
  ```

# Upgrade this application

Bitnami provides up-to-date versions of MariaDB and Redmine, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the Redmine container. For the MariaDB upgrade see https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#upgrade-this-image

1. Get the updated images:

  ```
  $ docker pull bitnami/redmine:latest
  ```

2. Stop your container

 * For docker-compose: `$ docker-compose stop redmine`
 * For manual execution: `$ docker stop redmine`

3. (For non-compose execution only) Create a [backup](#backing-up-your-application) if you have not mounted the redmine folder in the host.

4. Remove the currently running container

 * For docker-compose: `$ docker-compose rm redmine`
 * For manual execution: `$ docker rm redmine`

5. Run the new image

 * For docker-compose: `$ docker-compose start redmine`
 * For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name redmine bitnami/redmine:latest`

# Configuration
## Environment variables
 When you start the redmine image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the docker run command line. If you want to add a new environment variable:

 * For docker-compose add the variable name and value under the application section:
```yaml
application:
  image: bitnami/redmine:latest
  ports:
    - 80:3000
  environment:
    - REDMINE_PASSWORD=my_password
  volumes:
    - 'redmine_data:/bitnami/redmine'
  depends_on:
    - mariadb
```

 * For manual execution add a `-e` option with each variable and value:

```
 $ docker run -d -e REDMINE_PASSWORD=my_password -p 80:3000 --name redmine -v /your/local/path/bitnami/redmine:/bitnami/redmine --network=redmine_network bitnami/redmine
```

Available variables:
 - `REDMINE_USERNAME`: Redmine application username. Default: **user**
 - `REDMINE_PASSWORD`: Redmine application password. Default: **bitnami**
 - `REDMINE_EMAIL`: Redmine application email. Default: **user@example.com**
 - `REDMINE_LANG`: Redmine application default language. Default: **en**
 - `MARIADB_USER`: Root user for the MariaDB database. Default: **root**
 - `MARIADB_PASSWORD`: Root password for the MariaDB.
 - `MARIADB_HOST`: Hostname for MariaDB server. Default: **mariadb**
 - `MARIADB_PORT`: Port used by MariaDB server. Default: **3306**

### SMTP Configuration

To configure Redmine to send email using SMTP you can set the following environment variables:
 - `SMTP_HOST`: SMTP host.
 - `SMTP_PORT`: SMTP port.
 - `SMTP_USER`: SMTP account user.
 - `SMTP_PASSWORD`: SMTP account password.
 - `SMTP_TLS`: Use TLS encription with SMTP. Default **true**

This would be an example of SMTP configuration using a GMail account:

 * docker-compose:

```yaml
  redmine:
    image: bitnami/redmine:latest
    ports:
      - 80:3000
    environment:
      - SMTP_HOST=smtp.gmail.com
      - SMTP_PORT=587
      - SMTP_USER=your_email@gmail.com
      - SMTP_PASSWORD=your_password
```

 * For manual execution:

```
 $ docker run -d -e SMTP_HOST=smtp.gmail.com -e SMTP_PORT=587 -e SMTP_USER=your_email@gmail.com -e SMTP_PASSWORD=your_password -p 80:3000 --name redmine -v /your/local/path/bitnami/redmine:/bitnami/redmine --network=redmine_network bitnami/redmine$ docker rm -v redmine
```

# Backing up your application

To backup your application data follow these steps:

1. Stop the running container:

  * For docker-compose: `$ docker-compose stop redmine`
  * For manual execution: `$ docker stop redmine`

2. Copy the Redmine data folder in the host:

  ```
  $ docker cp /your/local/path/bitnami:/bitnami/redmine
  ```

# Restoring a backup

To restore your application using backed up data simply mount the folder with Redmine data in the container. See [persisting your application](#persisting-your-application) section for more info.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an
[issue](https://github.com/bitnami/bitnami-docker-redmine/issues), or submit a
[pull request](https://github.com/bitnami/bitnami-docker-redmine/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an
[issue](https://github.com/bitnami/bitnami-docker-redmine/issues). For us to provide better support,
be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive
information)

# License

Copyright (c) 2015-2016 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
