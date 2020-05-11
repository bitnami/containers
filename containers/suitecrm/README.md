# What is SuiteCRM?

> SuiteCRM is a completely open source enterprise-grade Customer Relationship Management (CRM) application. SuiteCRM is a software fork of the popular customer relationship management (CRM) system SugarCRM.

https://www.suitecrm.com/

# TL;DR;

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-suitecrm/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DTC)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/suitecrm?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy SuiteCRM in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami SuiteCRM Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/suitecrm).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`7-debian-10`, `7.11.13-debian-10-r45`, `7`, `7.11.13`, `latest` (7/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-suitecrm/blob/7.11.13-debian-10-r45/7/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/suitecrm GitHub repo](https://github.com/bitnami/bitnami-docker-suitecrm).

# Prerequisites

To run this application you need [Docker Engine](https://www.docker.com/products/docker-engine) >= `1.10.0`. [Docker Compose](https://www.docker.com/products/docker-compose) is recommended with a version `1.6.0` or later.

# How to use this image

## Run SuiteCRM with a Database Container

Running SuiteCRM with a database server is the recommended way. You can either use docker-compose or run the container manually.

### Run the application using Docker Compose

The main folder of this repository contains a functional [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-suitecrm/blob/master/docker-compose.yml) file. Run the application using it as shown below:

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-suitecrm/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

### Run the application manually

If you want to run the application manually instead of using docker-compose, these are the basic steps you need to run:

1. Create a new network for the application and the database:

  ```console
  $ docker network create suitecrm-tier
  ```

2. Create a volume for MariaDB persistence and create a MariaDB container

  ```console
  $ docker volume create --name mariadb_data
  $ docker run -d --name mariadb \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MARIADB_USER=bn_suitecrm \
    -e MARIADB_DATABASE=bitnami_suitecrm \
    --net suitecrm-tier \
    --volume mariadb_data:/bitnami \
    bitnami/mariadb:latest
  ```

  *Note:* You need to give the container a name in order to SuiteCRM to resolve the host

3. Create volumes for Suitecrm persistence and launch the container

  ```console
  $ docker volume create --name suitecrm_data
  $ docker run -d --name suitecrm -p 80:80 -p 443:443 \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e SUITECRM_DATABASE_USER=bn_suitecrm \
    -e SUITECRM_DATABASE_NAME=bitnami_suitecrm \
    --net suitecrm-tier \
    --volume suitecrm_data:/bitnami \
    bitnami/suitecrm:latest
  ```

Then you can access your application at http://your-ip/

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. Additionally you should mount a volume for [persistence of the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#persisting-your-database).

The above examples define docker volumes namely `mariadb_data` and `suitecrm_data`. The SuiteCRM application state will persist as long as these volumes are not removed.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-suitecrm/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  mariadb:
  ...
    volumes:
      - '/path/to/mariadb-persistence:/bitnami'
  ...
  suitecrm:
  ...
    volumes:
      - '/path/to/suitecrm-persistence:/bitnami'
  ...
```

### Mount host directories as data volumes using the Docker command line

In this case you need to specify the directories to mount on the run command. The process is the same than the one previously shown:

1. Create a network (if it does not exist):

  ```console
  $ docker network create suitecrm-tier
  ```

2. Create a MariaDB container with host volume:

  ```console
  $ docker run -d --name mariadb \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MARIADB_USER=bn_suitecrm \
    -e MARIADB_DATABASE=bitnami_suitecrm \
    --net suitecrm-tier \
    --volume /path/to/mariadb-persistence:/bitnami \
    bitnami/mariadb:latest
  ```
   *Note:* You need to give the container a name in order to SuiteCRM to resolve the host

3. Create the SuiteCRM container with host volumes:

  ```console
  $ docker run -d --name suitecrm -p 80:80 -p 443:443 \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e SUITECRM_DATABASE_USER=bn_suitecrm \
    -e SUITECRM_DATABASE_NAME=bitnami_suitecrm \
    --net suitecrm-tier \
    --volume /path/to/suitecrm-persistence:/bitnami \
    bitnami/suitecrm:latest
  ```

# Upgrade this application

Bitnami provides up-to-date versions of MariaDB and SuiteCRM, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the SuiteCRM container. For the MariaDB upgrade you can take a look at https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#upgrade-this-image

1. Create snapshots, which you can use to restore the application state should the upgrade fail:

    - Take a snapshot of the application state

        ```console
        $ rsync -a /path/to/suitecrm-persistence /path/to/suitecrm-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
        ```

   - Create a [snapshot with the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#step-2-stop-and-backup-the-currently-running-container).

3. Upgrade SuiteCRM by following the official [SuiteCRM upgrade instructions using the upgrade wizard](https://docs.suitecrm.com/admin/installation-guide/using-the-upgrade-wizard/).

# Configuration

## Environment variables

When you start the SuiteCRM image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line.

##### User and Site configuration

 - `SUITECRM_USERNAME`: SuiteCRM application username. Default: **user**
 - `SUITECRM_PASSWORD`: SuiteCRM application password. Default: **bitnami**
 - `SUITECRM_EMAIL`: SuiteCRM application email. Default: **user@example.com**
 - `SUITECRM_LAST_NAME`: SuiteCRM application last name. Default: **Name**
 - `SUITECRM_HOST`: Host domain or IP.
 - `SUITECRM_HTTP_TIMEOUT`: Timeout in seconds used on http requests during wizard installation. Default: **120**
 - `SUITECRM_VALIDATE_USER_IP`: Whether to validate the user IP address or not. Default: **yes**. See [Troubleshooting](#troubleshooting) section.

##### Use an existing database

- `MARIADB_HOST`: Hostname for MariaDB server. Default: **mariadb**
- `MARIADB_PORT_NUMBER`: Port used by MariaDB server. Default: **3306**
- `SUITECRM_DATABASE_NAME`: Database name that SuiteCRM will use to connect with the database. Default: **bitnami_suitecrm**
- `SUITECRM_DATABASE_USER`: Database user that SuiteCRM will use to connect with the database. Default: **bn_suitecrm**
- `SUITECRM_DATABASE_PASSWORD`: Database password that SuiteCRM will use to connect with the database. No defaults.
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

##### Create a database for SuiteCRM using mysql-client

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

 * For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-suitecrm/blob/master/docker-compose.yml) file present in this repository:

```yaml
suitecrm:
  ...
  environment:
    - SUITECRM_PASSWORD=my_password
  ...
```

 * For manual execution add a `-e` option with each variable and value:

  ```console
  $ docker run -d -p 80:80 -p 443:443 --name suitecrm  \
    -e SUITECRM_PASSWORD=my_password \
    --net suitecrm-tier \
    --volume /path/to/suitecrm-persistence:/bitnami \
    bitnami/suitecrm:latest
  ```

### SMTP Configuration

To configure SugarCMR to send email using SMTP you can set the following environment variables:

 - `SUITECRM_SMTP_HOST`: SugarCRM SMTP host.
 - `SUITECRM_SMTP_PORT`: SugarCRM SMTP port.
 - `SUITECRM_SMTP_USER`: SugarCRM SMTP account user.
 - `SUITECRM_SMTP_PASSWORD`: SugarCRM SMTP account password.
 - `SUITECRM_SMTP_PROTOCOL`: SugarCRM SMTP protocol to use.

This would be an example of SMTP configuration using a Gmail account:

 * For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-suitecrm/blob/master/docker-compose.yml) file present in this repository:

```yaml
  suitecrm:
    ...
    environment:
      - MARIADB_HOST=mariadb
      - MARIADB_PORT_NUMBER=3306
      - SUITECRM_DATABASE_USER=bn_suitecrm
      - SUITECRM_DATABASE_NAME=bitnami_suitecrm
      - SUITECRM_SMTP_HOST=smtp.gmail.com
      - SUITECRM_SMTP_USER=your_email@gmail.com
      - SUITECRM_SMTP_PASSWORD=your_password
      - SUITECRM_SMTP_PROTOCOL=TLS
      - SUITECRM_SMTP_PORT=587
    ...
```

 * For manual execution:

  ```console
  $ docker run -d -p 80:80 -p 443:443 --name suitecrm  \
    -e MARIADB_HOST=mariadb \
    -e MARIADB_PORT_NUMBER=3306 \
    -e SUITECRM_DATABASE_USER=bn_suitecrm \
    -e SUITECRM_DATABASE_NAME=bitnami_suitecrm \
    -e SUITECRM_SMTP_HOST=smtp.gmail.com \
    -e SUITECRM_SMTP_PROTOCOL=TLS \
    -e SUITECRM_SMTP_PORT=587 \
    -e SUITECRM_SMTP_USER=your_email@gmail.com \
    -e SUITECRM_SMTP_PASSWORD=your_password
    --net suitecrm-tier \
    --volume /path/to/suitecrm-persistence:/bitnami \
    bitnami/suitecrm:latest
  ```

# Customize this image

The Bitnami SuiteCRM Docker image is designed to be extended so it can be used as the base image for your custom web applications.

## Extend this image

Before extending this image, please note there are certain configuration settings you can modify using the original image:

- Settings that can be adapted using environment variables. For instance, you can change the ports used by Apache for HTTP and HTTPS, by setting the environment variables `APACHE_HTTP_PORT_NUMBER` and `APACHE_HTTPS_PORT_NUMBER` respectively.
- [Adding custom virtual hosts](https://github.com/bitnami/bitnami-docker-apache#adding-custom-virtual-hosts).
- [Replacing the 'httpd.conf' file](https://github.com/bitnami/bitnami-docker-apache#full-configuration).
- [Using custom SSL certificates](https://github.com/bitnami/bitnami-docker-apache#using-custom-ssl-certificates).

If your desired customizations cannot be covered using the methods mentioned above, extend the image. To do so, create your own image using a Dockerfile with the format below:

```Dockerfile
FROM bitnami/suitecrm
## Put your customizations below
...
```

Here is an example of extending the image with the following modifications:

- Install the `vim` editor
- Modify the Apache configuration file
- Modify the ports used by Apache

```Dockerfile
FROM bitnami/suitecrm
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
    image: 'bitnami/mariadb:10.3'
    environment:
      - MARIADB_USER=bn_suitecrm
      - MARIADB_DATABASE=bitnami_suitecrm
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - 'mariadb_data:/bitnami'
  suitecrm:
    build: .
    environment:
      - MARIADB_HOST=mariadb
      - MARIADB_PORT_NUMBER=3306
      - SUITECRM_DATABASE_USER=bn_suitecrm
      - SUITECRM_DATABASE_NAME=bitnami_suitecrm
      - ALLOW_EMPTY_PASSWORD=yes
    ports:
      - '80:8181'
      - '443:8143'
    volumes:
      - 'suitecrm_data:/bitnami'
    depends_on:
      - mariadb
volumes:
  mariadb_data:
    driver: local
  suitecrm_data:
    driver: local
```

# Notable Changes

## 7.11.4-debian-9-r21 and 7.11.4-ol-7-r32

- This image has been adapted so it's easier to customize. See the [Customize this image](#customize-this-image) section for more information.
- The Apache configuration volume (`/bitnami/apache`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the Apache configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom Apache configuration files are advised to mount a volume for the configuration at `/opt/bitnami/apache/conf`, or mount specific configuration files individually.
- The PHP configuration volume (`/bitnami/php`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the PHP configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom PHP configuration files are advised to mount a volume for the configuration at `/opt/bitnami/php/conf`, or mount specific configuration files individually.
- Enabling custom Apache certificates by placing them at `/opt/bitnami/apache/certs` has been deprecated, and support for this functionality will be dropped in the near future. Users wanting to enable custom certificates are advised to mount their certificate files on top of the preconfigured ones at `/certs`.

## 7.10.10-debian-9-r18 and 7.10.10-ol-7-r24

- Due to several broken SuiteCRM features and plugins, the entire `htdocs` directory is now being persisted (instead of a select number of files and directories). Because of this, upgrades will not work and a full migration needs to be performed. Upgrade instructions have been updated to reflect these changes.

# Troubleshooting

* If you are automatically logged out from the administration panel, you can try deploying SuiteCRM with the environment variable `SUITECRM_VALIDATE_USER_IP=no`
* If you get a timeout error during the initial setup similar to:
  > Error executing 'postInstallation': Timeout: did not get to load all resources on this page

  You can try to increase the value of the `SUITECRM_HTTP_TIMEOUT` environment variable mentioned above.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-suitecrm/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-suitecrm/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-suitecrm/issues/new). For us to provide better support, be sure to include the following information in your issue:

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
