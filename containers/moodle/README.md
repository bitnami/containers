# What is Moodle?

>Moodle is a very popular open source learning management solution (LMS) for the delivery of elearning courses and programs. It’s used not only by universities, but also by hundreds of corporations around the world who provide eLearning education for their employees. Moodle features a simple interface, drag-and-drop features, role-based permissions, deep reporting, many language translations, a well-documented API and more. With some of the biggest universities and organizations already using it, Moodle is ready to meet the needs of just about any size organization.

https://moodle.org/

# TL;DR;

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-moodle/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/moodle?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy Moodle in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Moodle Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/moodle).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/).


* [`3-debian-10`, `3.8.2-debian-10-r36`, `3`, `3.8.2`, `latest` (3/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-moodle/blob/3.8.2-debian-10-r36/3/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/moodle GitHub repo](https://github.com/bitnami/bitnami-docker-moodle).

# Prerequisites

To run this application you need Docker Engine 1.10.0. Docker Compose is recomended with a version 1.6.0 or later.

# How to use this image

## Run Moodle with a Database Container

Running Moodle with a database server is the recommended way. You can either use docker-compose or run the containers manually.

### Run the application using Docker Compose

The main folder of this repository contains a functional [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-moodle/blob/master/docker-compose.yml) file. Run the application using it as shown below:

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-moodle/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

### Run the application manually

If you want to run the application manually instead of using docker-compose, these are the basic steps you need to run:

1. Create a new network for the application and the database:

  ```console
  $ docker network create moodle-tier
  ```

2. Create a volume for MariaDB persistence and create a MariaDB container

  ```console
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

  ```console
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

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-moodle/blob/master/docker-compose.yml) file present in this repository: 

```yaml
services:
  mariadb:
  ...
    volumes:
      - '/path/to/mariadb-persistence:/bitnami'
  ...
  moodle:
  ...
    depends_on:
      - mariadb
  ...
```

### Mount persistent folders manually

In this case you need to specify the directories to mount on the run command. The process is the same than the one previously shown:

1. If you haven't done this before, create a new network for the application and the database:

  ```console
  $ docker network create moodle-tier
  ```

2. Start a MariaDB database in the previous network:

  ```console
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

  ```console
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

  ```console
  $ docker pull bitnami/moodle:latest
  ```

2. Stop your container

 * For docker-compose: `$ docker-compose stop moodle`
 * For manual execution: `$ docker stop moodle`

3. Take a snapshot of the application state

```console
$ rsync -a /path/to/moodle-persistence /path/to/moodle-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

Additionally, [snapshot the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#step-2-stop-and-backup-the-currently-running-container)

You can use these snapshots to restore the application state should the upgrade fail.

4. Remove the currently running container

 * For docker-compose: `$ docker-compose rm -v moodle`
 * For manual execution: `$ docker rm -v moodle`

5. Remove the persisted data. This is needed from 3.4.0-r1 since the whole installation is persisted and otherwise the new docker image will use an old application code.

    * Get the volume containing the persisted data

    ```console
    $ docker volume ls
    ```

    * Remove the volume

    ```console
    $ docker volume rm YOUR_VOLUME
    ```

6. Run the new image

 * For docker-compose: `$ docker-compose up moodle`
 * For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name moodle bitnami/moodle:latest`

# Configuration

## Environment variables

When you start the moodle image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line.

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
- `MOODLE_SKIP_INSTALL`: Do not run the Moodle installation wizard. This is necessary in case you use a database that already has Moodle data. Default: **no**

##### Create a database for Moodle using mysql-client

- `MARIADB_HOST`: Hostname for MariaDB server. Default: **mariadb**
- `MARIADB_PORT_NUMBER`: Port used by MariaDB server. Default: **3306**
- `MARIADB_ROOT_USER`: Database admin user. Default: **root**
- `MARIADB_ROOT_PASSWORD`: Database password for the `MARIADB_ROOT_USER` user. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_NAME`: New database to be created by the mysql client module. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_USER`: New database user to be created by the mysql client module. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_PASSWORD`: Database password for the `MYSQL_CLIENT_CREATE_DATABASE_USER` user. No defaults.
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

##### PHP configuration

- `PHP_MEMORY_LIMIT`: Memory limit for PHP. Default: **256M**

If you want to add a new environment variable:

 * For docker-compose add the variable name and value under the application section, modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-moodle/blob/master/docker-compose.yml) file present in this repository:

```yaml
moodle:
  ...
  environment:
    - MOODLE_PASSWORD=my_password
  ...
```

 * For manual execution add a `-e` option with each variable and value:

   ```console
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

 * Modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-moodle/blob/master/docker-compose.yml) file present in this repository: 

  ```yaml
  moodle:
  ...
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
  ...
  ```

* For manual execution:

  ```console
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

# Customize this image

The Bitnami Moodle Docker image is designed to be extended so it can be used as the base image for your custom web applications.

## Extend this image

Before extending this image, please note there are certain configuration settings you can modify using the original image:

- Settings that can be adapted using environment variables. For instance, you can change the ports used by Apache for HTTP and HTTPS, by setting the environment variables `APACHE_HTTP_PORT_NUMBER` and `APACHE_HTTPS_PORT_NUMBER` respectively.
- [Adding custom virtual hosts](https://github.com/bitnami/bitnami-docker-apache#adding-custom-virtual-hosts).
- [Replacing the 'httpd.conf' file](https://github.com/bitnami/bitnami-docker-apache#full-configuration).
- [Using custom SSL certificates](https://github.com/bitnami/bitnami-docker-apache#using-custom-ssl-certificates).

If your desired customizations cannot be covered using the methods mentioned above, extend the image. To do so, create your own image using a Dockerfile with the format below:

```Dockerfile
FROM bitnami/moodle
## Put your customizations below
...
```

Here is an example of extending the image with the following modifications:

- Install the `vim` editor
- Modify the Apache configuration file
- Modify the ports used by Apache

```Dockerfile
FROM bitnami/moodle
LABEL maintainer "Bitnami <containers@bitnami.com>"

## Install 'vim'
RUN install_packages vim

## Enable mod_ratelimit module
RUN sed -i -r 's/#LoadModule ratelimit_module/LoadModule ratelimit_module/' /opt/bitnami/apache/conf/httpd.conf

## Modify the ports used by Apache by default
# It is also possible to change these environment variables at runtime
ENV APACHE_HTTP_PORT_NUMBER=8181 
ENV APACHE_HTTPS_PORT_NUMBER=8143
EXPOSE 8181 8143
```

Based on the extended image, you can use a Docker Compose file like the one below to add other features:

```yaml
version: '2'
services:
  mariadb:
    image: 'bitnami/mariadb:10.1'
    environment:
      - MARIADB_USER=bn_moodle
      - MARIADB_DATABASE=bitnami_moodle
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - 'mariadb_data:/bitnami'
  moodle:
    build: .
    environment:
      - MARIADB_HOST=mariadb
      - MARIADB_PORT_NUMBER=3306
      - MOODLE_DATABASE_USER=bn_moodle
      - MOODLE_DATABASE_NAME=bitnami_moodle
      - ALLOW_EMPTY_PASSWORD=yes
    ports:
      - '80:8181'
      - '443:8143'
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
  
# Notable Changes

## 3.7.1-debian-9-r38 and 3.7.1-ol-7-r40

- It is now possible to use existing Moodle databases from other installations, as requested in [#95](https://github.com/bitnami/bitnami-docker-moodle/issues/95). In order to do this, use the environment variable `MOODLE_SKIP_INSTALL`, which forces the container not to run the initial Moodle setup wizard.

## 3.7.0-debian-9-r12 and 3.7.0-ol-7-r13

- This image has been adapted so it's easier to customize. See the [Customize this image](#customize-this-image) section for more information.
- The Apache configuration volume (`/bitnami/apache`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the Apache configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom Apache configuration files are advised to mount a volume for the configuration at `/opt/bitnami/apache/conf`, or mount specific configuration files individually.
- The PHP configuration volume (`/bitnami/php`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the PHP configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom PHP configuration files are advised to mount a volume for the configuration at `/opt/bitnami/php/conf`, or mount specific configuration files individually.
- Enabling custom Apache certificates by placing them at `/opt/bitnami/apache/certs` has been deprecated, and support for this functionality will be dropped in the near future. Users wanting to enable custom certificates are advised to mount their certificate files on top of the preconfigured ones at `/certs`.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-moodle/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-moodle/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-moodle/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`$ docker version`)
- Output of `$ docker info`
- Version of this container (`$ echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright 2016-2020 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
