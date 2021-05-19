# What is Redmine?

> Redmine is a flexible project management web application. Written using the Ruby on Rails framework, it is cross-platform and cross-database.

https://redmine.org/

# TL;DR

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-redmine/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

You can find the default credentials and available configuration options in the [Environment Variables](#environment-variables) section.

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/redmine?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy Redmine in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Redmine Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/redmine).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`4`, `4-debian-10`, `4.2.1`, `4.2.1-debian-10-r20`, `latest` (4/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-redmine/blob/4.2.1-debian-10-r20/4/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/redmine GitHub repo](https://github.com/bitnami/bitnami-docker-redmine).

# Prerequisites

To run this application you need Docker Engine 1.10.0. Docker Compose is recomended with a version 1.6.0 or later.

# How to use this image

## Run Redmine with a Database Container

Running Redmine with a database server is the recommended way. You can either use docker-compose or run the containers manually.

### Run the application using Docker Compose

The main folder of this repository contains a functional [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-redmine/blob/master/docker-compose.yml) file. Run the application using it as shown below:

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-redmine/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

### Run the application manually

If you want to run the application manually instead of using docker-compose, these are the basic steps you need to run:

1. Create a new network for the application and the database:

  ```console
  $ docker network create redmine-tier
  ```

2. Create a volume for MariaDB persistence and create a MariaDB container
  ```console
  $ docker volume create --name mariadb_data
  $ docker run -d --name mariadb \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MARIADB_USER=bn_redmine \
    -e MARIADB_DATABASE=bitnami_redmine \
    --net redmine-tier \
    --volume mariadb_data:/bitnami \
    bitnami/mariadb:latest
  ```

3. Create volumes for Redmine persistence and launch the container

  ```console
  $ docker volume create --name redmine_data
  $ docker run -d --name redmine -p 80:3000 \
    -e REDMINE_DB_USERNAME=bn_redmine \
    -e REDMINE_DB_NAME=bitnami_redmine \
    --net redmine-tier \
    --volume redmine_data:/bitnami \
    bitnami/redmine:latest
  ```

Then you can access your application at http://your-ip/

### Run the application using PostgreSQL database

The Bitnami Redmine Docker Image supports both MariaDB and PostgreSQL databases. In order to use a PostgreSQL database you can run the following command:

  ```console
  $ docker-compose -f docker-compose-postgresql.yml up
  ```

or use the next docker-compose template:

```yaml
version: '2'
services:
  postgresql:
    image: 'bitnami/postgresql:11'
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - POSTGRESQL_USERNAME=bn_redmine
      - POSTGRESQL_DATABASE=bitnami_redmine
    volumes:
      - 'postgresql_data:/bitnami/postgresql'
  redmine:
    image: 'bitnami/redmine:4'
    ports:
      - '80:3000'
    environment:
      - REDMINE_DB_POSTGRES=postgresql
      - REDMINE_DB_USERNAME=bn_redmine
      - REDMINE_DB_NAME=bitnami_redmine
    volumes:
      - 'redmine_data:/bitnami'
    depends_on:
      - postgresql
volumes:
  postgresql_data:
    driver: local
  redmine_data:
    driver: local
```

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. Additionally you should mount a volume for [persistence of the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#persisting-your-database). As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

The above examples define docker volumes namely `mariadb_data` and `redmine_data`. The Redmine application state will persist as long as these volumes are not removed.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

The following `docker-compose.yml` template demonstrates the use of host directories as data volumes.

```yaml
  mariadb:
  ...
    volumes:
      - '/path/to/mariadb-persistence:/bitnami/mariadb'
  ...
  redmine:
  ...
    volumes:
      - '/path/to/redmine-persistence:/bitnami'
  ...
```

### Mount host directories as data volumes using the Docker command line

1. Create a network (if it does not exist):

  ```console
  $ docker network create redmine-tier
  ```

2. Create a MariaDB container with host volume:

  ```console
  $ docker run -d --name mariadb \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MARIADB_USER=bn_redmine \
    -e MARIADB_DATABASE=bitnami_redmine \
    --net redmine-tier \
    --volume /path/to/mariadb-persistence:/bitnami/mariadb \
    bitnami/mariadb:latest
  ```

  *Note:* You need to give the container a name in order to Redmine to resolve the host

3. Run the Redmine container:

  ```console
  $ docker run -d --name redmine -p 80:3000 \
    -e REDMINE_DB_USERNAME=bn_redmine \
    -e REDMINE_DB_NAME=bitnami_redmine \
    --net redmine-tier \
    --volume /path/to/redmine-persistence:/bitnami \
    bitnami/redmine:latest
  ```

## Deploying to a sub-URI

On certain occasions, you may need that Redmine is available under a specific sub-URI path rather than the root. A common scenario to this problem may arise if you plan to set up your Redmine container behind a reverse proxy. To deploy your Redmine container using a certain sub-URI you just need to follow these steps:

1. Create a new bash script file in your host system, `subUriInit.sh`, that will replace the default `init.sh`:

__subUriInit.sh__
```
#!/bin/bash

# Set default values depending on database variation
if [ -n "$REDMINE_DB_POSTGRES" ]; then
    export REDMINE_DB_PORT_NUMBER=${REDMINE_DB_PORT_NUMBER:-5432}
    export REDMINE_DB_USERNAME=${REDMINE_DB_USERNAME:-postgres}
elif [ -n "$REDMINE_DB_MYSQL" ]; then
    export REDMINE_DB_PORT_NUMBER=${REDMINE_DB_PORT_NUMBER:-3306}
    export REDMINE_DB_USERNAME=${REDMINE_DB_USERNAME:-root}
fi

# REPLACE WITH YOUR OWN SUB-URI
SUB_URI_PATH='/redmine'

#Config files where to apply changes
config1=/opt/bitnami/redmine/config.ru
config2=/opt/bitnami/redmine/config/environment.rb

if [[ ! -d /opt/bitnami/redmine/conf/ ]]; then
    sed -i '$ d' ${config1}
    echo 'map ActionController::Base.config.try(:relative_url_root) || "/" do' >> ${config1}
    echo 'run Rails.application' >> ${config1}
    echo 'end' >> ${config1}
    echo 'Redmine::Utils::relative_url_root = "'${SUB_URI_PATH}'"' >> ${config2}
fi

SUB_URI_PATH=$(echo ${SUB_URI_PATH} | sed -e 's|/|\\/|g')
sed -i -e "s/\(relative_url_root\ \=\ \"\).*\(\"\)/\1${SUB_URI_PATH}\2/" ${config2}
```

2. Make sure you replace the value of `SUB_URI_PATH` with your own sub-URI. e.g: '/redmine'. Do not forget to add the leading slash '/'.

3. Give execution permissions to `subUriInit.sh`:

    ```console
    $ chmod +x subUriInit.sh
    ```

4. Replace the default `init.sh` script in favour of our new created `subUriInit.sh`. You can mount this file as a volume in order to accomplish this task.

 * For docker-compose:

    ```yaml
    services:
      redmine:
      ...
        volumes:
          - '/path/to/subUriInit.sh:/init.sh'
      ...
    ```

 * For manual execution (see [Run the application manually](https://github.com/bitnami/bitnami-docker-redmine#run-the-application-manually)):

    ```console
    $ docker run -d --name redmine -p 80:3000 \
      -e REDMINE_DB_USERNAME=bn_redmine \
      -e REDMINE_DB_NAME=bitnami_redmine \
      --net redmine-tier \
      --volume redmine_data:/bitnami \
      --volume /path/to/subUriInit.sh:/init.sh \
      bitnami/redmine:latest
    ```

    Then you can access your application at http://your-ip/SUB_URI_PATH

# Upgrade this application

Bitnami provides up-to-date versions of MariaDB and Redmine, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the Redmine container. For the MariaDB upgrade see https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#upgrade-this-image

1. Get the updated images:

  ```console
  $ docker pull bitnami/redmine:latest
  ```

2. Stop your container

 * For docker-compose: `$ docker-compose stop redmine`
 * For manual execution: `$ docker stop redmine`

3. Take a snapshot of the application state

```console
$ rsync -a /path/to/redmine-persistence /path/to/redmine-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

Additionally, [snapshot the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#step-2-stop-and-backup-the-currently-running-container)

You can use these snapshots to restore the application state should the upgrade fail.

4. Remove the currently running container

 * For docker-compose: `$ docker-compose rm redmine`
 * For manual execution: `$ docker rm redmine`

5. Run the new image

 * For docker-compose: `$ docker-compose up redmine`
 * For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name redmine bitnami/redmine:latest`

# Configuration

## Environment variables

When you start the redmine image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. If you want to add a new environment variable:

 * For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-redmine/blob/master/docker-compose.yml) file present in this repository:

```yaml
redmine:
  ...
  environment:
    - REDMINE_PASSWORD=my_password
  ...
```

 * For manual execution add a `-e` option with each variable and value:

```console
 $ docker run -d --name redmine --network=redmine_network -p 80:3000 \
     -e REDMINE_PASSWORD=my_password \
     -v /your/local/path/bitnami/redmine:/bitnami \
     bitnami/redmine
```

Available variables:
 - `REDMINE_USERNAME`: Redmine application username. Default: **user**
 - `REDMINE_PASSWORD`: Redmine application password. Default: **bitnami1**
 - `REDMINE_EMAIL`: Redmine application email. Default: **user@example.com**
 - `REDMINE_LANGUAGE`: Redmine application default language. Default: **en**
 - `REDMINE_DB_USERNAME`: Database user the application will connect with. Default: **bn_redmine**
 - `REDMINE_DB_PASSWORD`: Password for the database user.
 - `REDMINE_DB_NAME`: Database the application will connect to. Default: **bitnami_redmine**
 - `REDMINE_DB_MYSQL`: Hostname for MySQL server. Default: **mariadb**
 - `REDMINE_DB_POSTGRES`: Hostname for PostgreSQL server. No defaults
 - `REDMINE_DB_PORT_NUMBER`: Port used by database server. Default: **3306**

### SMTP Configuration

To configure Redmine to send email using SMTP you can set the following environment variables:
 - `SMTP_HOST`: SMTP host.
 - `SMTP_PORT`: SMTP port.
 - `SMTP_USER`: SMTP account user. It can be empty.
 - `SMTP_PASSWORD`: SMTP account password. It can be empty.
 - `SMTP_TLS`: Use TLS encription with SMTP. Default **true**
 - `SMTP_DOMAIN` : Somain for SMTP configuration. Default **example.com**
 - `SMTP_AUTHENTICATION` : The authentication method for SMTP. Default **login**

This would be an example of SMTP configuration using a GMail account:

 * Modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-redmine/blob/master/docker-compose.yml) file present in this repository:

```yaml
  redmine:
  ...
    environment:
      - SMTP_HOST=smtp.gmail.com
      - SMTP_PORT=587
      - SMTP_USER=your_email@gmail.com
      - SMTP_PASSWORD=your_password
  ...
```

 * For manual execution:

```console
 $ docker run -d -p 80:3000 --name redmine --network=redmine_network \
    -e SMTP_HOST=smtp.gmail.com \
    -e SMTP_PORT=587 \
    -e SMTP_USER=your_email@gmail.com \
    -e SMTP_PASSWORD=your_password \
    -v /your/local/path/bitnami/redmine:/bitnami \
    bitnami/redmine
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-redmine/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-redmine/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-redmine/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright (c) 2015-2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
