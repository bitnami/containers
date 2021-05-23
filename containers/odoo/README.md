# What is Odoo?

> Odoo is a suite of web based open source business apps. Odoo Apps can be used as stand-alone applications, but they also integrate seamlessly so you get a full-featured Open Source ERP when you install several Apps.

https://odoo.com/

# TL;DR

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-odoo/master/docker-compose.yml > docker-compose.yml
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


> This [CVE scan report](https://quay.io/repository/bitnami/odoo?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy Odoo in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Odoo Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/odoo).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`14`, `14-debian-10`, `14.0.20210510`, `14.0.20210510-debian-10-r1` (14/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-odoo/blob/14.0.20210510-debian-10-r1/14/debian-10/Dockerfile)
* [`13`, `13-debian-10`, `13.0.20210510`, `13.0.20210510-debian-10-r2`, `latest` (13/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-odoo/blob/13.0.20210510-debian-10-r2/13/debian-10/Dockerfile)
* [`12`, `12-debian-10`, `12.0.20210515`, `12.0.20210515-debian-10-r2` (12/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-odoo/blob/12.0.20210515-debian-10-r2/12/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/odoo GitHub repo](https://github.com/bitnami/bitnami-docker-odoo).

# Prerequisites

To run this application you need Docker Engine 1.10.0. Docker Compose is recomended with a version 1.6.0 or later.

# How to use this image

## Run Odoo with a Database Container

Running Odoo with a database server is the recommended way. You can either use docker-compose or run the containers manually.

### Run the application using Docker Compose

The main folder of this repository contains a functional [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-odoo/blob/master/docker-compose.yml) file. Run the application using it as shown below:

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-odoo/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

### Run the application manually

If you want to run the application manually instead of using docker-compose, these are the basic steps you need to run:

1. Create a new network for the application and the database:

  ```console
  $ docker network create odoo-tier
  ```

2. Start a PostgreSQL database in the network generated:

  ```console
  $ docker run -d --name postgresql --net odoo-tier bitnami/postgresql:latest
  ```

  *Note:* You need to give the container a name in order to Odoo to resolve the host

3. Run the Odoo container:

  ```console
  $ docker run -d -p 80:8069 -p 443:8071 --name odoo --net odoo-tier bitnami/odoo:latest
  ```

Then you can access your application at http://your-ip/

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the application will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. Additionally you should mount a volume for [persistence of the PostgreSQL data](https://github.com/bitnami/bitnami-docker-postgresql#persisting-your-database).

The above examples define docker volumes namely `postgresql_data` and `odoo_data`. The Odoo application state will persist as long as these volumes are not removed.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-odoo/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  postgresql:
  ...
    volumes:
      - '/path/to/postgresql_persistence:/bitnami'
  ...
  odoo:
  ...
    volumes:
      - '/path/to/odoo-persistence:/bitnami'
  ...
```

### Mount host directories as data volumes using the Docker command line

In this case you need to specify the directories to mount on the run command. The process is the same than the one previously shown:

1. Create a network (if it does not exist):

  ```console
  $ docker network create odoo-tier
  ```

2. Create a PostgreSQL container with host volume:

  ```console
  $ docker run -d --name postgresql \
    --net odoo-tier \
    --volume /path/to/postgresql-persistence:/bitnami \
    bitnami/postgresql:latest
  ```

  *Note:* You need to give the container a name in order to Odoo to resolve the host

3. Create the Odoo container with hist volumes:

  ```console
  $ docker run -d --name odoo -p 80:8069 -p 443:8071 \
    --net odoo-tier \
    --volume /path/to/odoo-persistence:/bitnami \
    bitnami/odoo:latest
  ```

# Upgrade this application

Bitnami provides up-to-date versions of PostgreSQL and Odoo, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the Odoo container. For the PostgreSQL upgrade see https://github.com/bitnami/bitnami-docker-postgresql/blob/master/README.md#upgrade-this-image

1. Get the updated images:

  ```console
  $ docker pull bitnami/odoo:latest
  ```

2. Stop your container

 * For docker-compose: `$ docker-compose stop odoo`
 * For manual execution: `$ docker stop odoo`

3. Take a snapshot of the application state

```console
$ rsync -a /path/to/odoo-persistence /path/to/odoo-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

Additionally, [snapshot the PostgreSQL data](https://github.com/bitnami/bitnami-docker-postgresql#step-2-stop-and-backup-the-currently-running-container)

You can use these snapshots to restore the application state should the upgrade fail.

4. Remove the stopped container

 * For docker-compose: `$ docker-compose rm odoo`
 * For manual execution: `$ docker rm odoo`

5. Run the new image

 * For docker-compose: `$ docker-compose up odoo`
 * For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name odoo bitnami/odoo:latest`

# Configuration

## Environment variables

When you start the Odoo image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. If you want to add a new environment variable:

 * For docker-compose add the variable name and value under the application section of the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-odoo/blob/master/docker-compose.yml) file present in this repository:

```yaml
odoo:
  ...
  environment:
    - ODOO_PASSWORD=my_password
  ...
```

 * For manual execution add a `-e` option with each variable and value:

  ```console
  $ docker run -d -p 80:8069 -p 443:8071 --name odoo \
    --env ODOO_PASSWORD=my_password  \
    --net odoo-tier \
    --volume /path/to/odoo-persistence:/bitnami \
    bitnami/odoo:latest
  ```

Available variables:
 - `ODOO_EMAIL`: Odoo application email. Default: **user@example.com**
 - `ODOO_PASSWORD`: Odoo application password. Default: **bitnami**
 - `POSTGRESQL_USER`: Root user for the PostgreSQL database. Default: **postgres**
 - `POSTGRESQL_PASSWORD`: Root password for the PostgreSQL.
 - `POSTGRESQL_HOST`: Hostname for PostgreSQL server. Default: **postgresql**
 - `POSTGRESQL_PORT_NUMBER`: Port used by PostgreSQL server. Default: **5432**
 - `WITHOUT_DEMO`: Disable loading demo data for modules to be installed (comma-separated or use 'all'). Default: **all**

### SMTP Configuration

To configure Odoo to send email using SMTP you can set the following environment variables:
 - `SMTP_HOST`: SMTP host.
 - `SMTP_PORT`: SMTP port.
 - `SMTP_USER`: SMTP account user.
 - `SMTP_PASSWORD`: SMTP account password.
 - `SMTP_PROTOCOL`: Secure connection protocol to use for SMTP [tls, ssl, none].

This would be an example of SMTP configuration using a GMail account:

 * Modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-odoo/blob/master/docker-compose.yml) file present in this repository:

```yaml
  odoo:
  ...
    environment:
      - SMTP_HOST=smtp.gmail.com
      - SMTP_PORT=587
      - SMTP_USER=your_email@gmail.com
      - SMTP_PASSWORD=your_password
      - SMTP_PROTOCOL=tls
  ...
```

 * For manual execution:

  ```console
  $ docker run -d -p 80:8069 -p 443:8071 --name odoo \
    --env SMTP_HOST=smtp.gmail.com \
    --env SMTP_PORT=587 \
    --env SMTP_USER=your_email@gmail.com \
    --env SMTP_PASSWORD=your_password \
    --env SMTP_PROTOCOL=tls \
    --net odoo-tier \
    --volume /path/to/odoo-persistence:/bitnami \
    bitnami/odoo:latest
  ```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-odoo/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-odoo/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-odoo/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`$ docker version`)
- Output of `$ docker info`
- Version of this container (`$ echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright 2016-2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
