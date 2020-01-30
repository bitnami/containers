# What is ownCloud?

ownCloud is a file sharing server that puts the control and security of your own data back into your hands.

https://owncloud.org/

# TL;DR;

## Docker Compose

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-owncloud/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DTC)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/owncloud?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy ownCloud in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami ownCloud Chart GitHub repository](https://github.com/bitnami/charts/tree/master/upstreamed/owncloud).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Supported tags and respective `Dockerfile` links

> NOTE: Debian 9 images have been deprecated in favor of Debian 10 images. Bitnami will not longer publish new Docker images based on Debian 9.

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/).


* [`10-ol-7`, `10.3.2-ol-7-r51` (10/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-owncloud/blob/10.3.2-ol-7-r51/10/ol-7/Dockerfile)
* [`10-debian-10`, `10.3.2-debian-10-r6`, `10`, `10.3.2`, `latest` (10/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-owncloud/blob/10.3.2-debian-10-r6/10/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/owncloud GitHub repo](https://github.com/bitnami/bitnami-docker-owncloud).

# Prerequisites

To run this application you need Docker Engine 1.10.0. Docker Compose is recomended with a version 1.6.0 or later.

## Run ownCloud with a Database Container

Running ownCloud with a database server is the recommended way. You can either use docker-compose or run the containers manually.

### Run the application using Docker Compose

This is the recommended way to run ownCloud. You can use the following docker compose template:

```yaml
version: '2'
services:
  mariadb:
    image: 'bitnami/mariadb:latest'
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - MARIADB_USER=bn_owncloud
      - MARIADB_DATABASE=bitnami_owncloud
    volumes:
      - 'mariadb_data:/bitnami'
  owncloud:
    image: 'bitnami/owncloud:latest'
    environment:
      - MARIADB_HOST=mariadb
      - MARIADB_PORT_NUMBER=3306
      - OWNCLOUD_DATABASE_USER=bn_owncloud
      - OWNCLOUD_DATABASE_NAME=bitnami_owncloud
      - ALLOW_EMPTY_PASSWORD=yes
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - 'owncloud_data:/bitnami'
    depends_on:
      - mariadb
volumes:
  mariadb_data:
    driver: local
  owncloud_data:
    driver: local
```

### Run the application manually

If you want to run the application manually instead of using docker-compose, these are the basic steps you need to run:

1. Create a new network for the application and the database:

  ```bash
  $ docker network create owncloud-tier
  ```

2. Create a volume for MariaDB persistence and create a MariaDB container

  ```bash
  $ docker volume create --name mariadb_data
  $ docker run -d --name mariadb \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MARIADB_USER=bn_owncloud \
    -e MARIADB_DATABASE=bitnami_owncloud \
    --net owncloud-tier \
    --volume mariadb_data:/bitnami \
    bitnami/mariadb:latest
  ```

  *Note:* You need to give the container a name in order to OwnCloud to resolve the host

3. Create volumes for Owncloud persistence and launch the container

  ```bash
  $ docker volume create --name owncloud_data
  $ docker run -d --name owncloud -p 80:80 -p 443:443 \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e OWNCLOUD_DATABASE_USER=bn_owncloud \
    -e OWNCLOUD_DATABASE_NAME=bitnami_owncloud \
    --net owncloud-tier \
    --volume owncloud_data:/bitnami \
    bitnami/owncloud:latest
  ```

Then you can access your application at http://your-ip/

> *Note:* If you want to access your application from a public IP or hostname you need to configure as a Trusted Domain. You can handle it adjusting the configuration of the instance by setting the environment variable "OWNCLOUD_HOST" to your public IP or hostname.

> *Note:* If you persisted your application and you already run your container, you won't be able to configure the Trusted Domains using the previous environment variable. Trusted Domains will be set using the configuration that had been previously persisted. Therefore, you will need to connect you container and execute the command below:

  ````bash
  $ sudo -u daemon /opt/bitnami/php/bin/php /opt/bitnami/owncloud/occ config:system:set trusted_domains 2 --value=YOUR_HOSTNAME
  ````

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. Additionally you should mount a volume for [persistence of the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#persisting-your-database).

The above examples define docker volumes namely `mariadb_data` and `owncloud_data`. The ownCloud application state will persist as long as these volumes are not removed.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount persistent folders in the host using docker-compose

This requires a minor change to the `docker-compose.yml` template previously shown:

```yaml
version: '2'

services:
  mariadb:
    image: 'bitnami/mariadb:latest'
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - MARIADB_USER=bn_owncloud
      - MARIADB_DATABASE=bitnami_owncloud
    volumes:
      - '/path/to/mariadb-persistence:/bitnami'
  owncloud:
    image: 'bitnami/owncloud:latest'
    environment:
      - OWNCLOUD_DATABASE_USER=bn_owncloud
      - OWNCLOUD_DATABASE_NAME=bitnami_owncloud
      - ALLOW_EMPTY_PASSWORD=yes
    depends_on:
      - mariadb
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - '/path/to/owncloud-persistence:/bitnami'
```

### Mount host directories as data volumes using the Docker command line

In this case you need to specify the directories to mount on the run command. The process is the same than the one previously shown:

1. Create a network (if it does not exist):

  ```bash
  $ docker network create owncloud-tier
  ```

2. Create a MariaDB container with host volume:

  ```bash
  $ docker run -d --name mariadb \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MARIADB_USER=bn_owncloud \
    -e MARIADB_DATABASE=bitnami_owncloud \
    --net owncloud-tier \
    --volume /path/to/mariadb-persistence:/bitnami \
    bitnami/mariadb:latest
  ```

  *Note:* You need to give the container a name in order to OwnCloud to resolve the host

3. Create the ownCloud container with host volumes:

  ```bash
  $ docker run -d --name owncloud -p 80:80 -p 443:443 \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e OWNCLOUD_DATABASE_USER=bn_owncloud \
    -e OWNCLOUD_DATABASE_NAME=bitnami_owncloud \
    --net owncloud-tier \
    --volume /path/to/owncloud-persistence:/bitnami \
    bitnami/owncloud:latest
  ```

# Upgrade this application

Bitnami provides up-to-date versions of MariaDB and OwnCloud, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the OwnCloud container. For the MariaDB upgrade see https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#upgrade-this-image

1. Get the updated images:

  ```bash
  $ docker pull bitnami/owncloud:latest
  ```

2. Stop your container

  * For docker-compose: `$ docker-compose stop owncloud`
  * For manual execution: `$ docker stop owncloud`

3. Take a snapshot of the application state

```bash
$ rsync -a /path/to/owncloud-persistence /path/to/owncloud-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

Additionally, [snapshot the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#step-2-stop-and-backup-the-currently-running-container)

You can use these snapshots to restore the application state should the upgrade fail.

4. Remove the currently running container

  * For docker-compose: `$ docker-compose rm -v owncloud`
  * For manual execution: `$ docker rm -v owncloud`

5. Run the new image

  * For docker-compose: `$ docker-compose up owncloud`
  * For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name owncloud bitnami/owncloud:latest`

# Configuration

## Environment variables

When you start the owncloud image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the docker run command line.

##### User and Site configuration

 - `APACHE_HTTP_PORT_NUMBER`: Port used by Apache for HTTP. Default: **80**
 - `APACHE_HTTPS_PORT_NUMBER`: Port used by Apache for HTTPS. Default: **443**
 - `OWNCLOUD_USERNAME`: Owncloud application username. Default: **user**
 - `OWNCLOUD_PASSWORD`: Owncloud application password. Default: **bitnami**
 - `OWNCLOUD_EMAIL`: Owncloud application email. Default: **user@example.com**
 - `OWNCLOUD_HOST`: Owncloud Host Server.

##### Use an existing database

- `MARIADB_HOST`: Hostname for MariaDB server. Default: **mariadb**
- `MARIADB_PORT_NUMBER`: Port used by MariaDB server. Default: **3306**
- `OWNCLOUD_DATABASE_NAME`: Database name that ownCloud will use to connect with the database. Default: **bitnami_owncloud**
- `OWNCLOUD_DATABASE_USER`: Database user that ownCloud will use to connect with the database. Default: **bn_owncloud**
- `OWNCLOUD_DATABASE_PASSWORD`: Database password that ownCloud will use to connect with the database. No defaults.
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

##### Create a database for ownCloud using mysql-client

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
owncloud:
  image: bitnami/owncloud:latest
  ports:
    - 80:80
    - 443:443
  environment:
    - OWNCLOUD_HOST=your_host
  volumes:
      - owncloud_data:/bitnami
```

 * For manual execution add a `-e` option with each variable and value:

  ```bash
  $ docker run -d --name owncloud -p 80:80 -p 443:443 \
    -e OWNCLOUD_PASSWORD=my_password \
    --net owncloud-tier \
    --volume /path/to/owncloud-persistence:/bitnami \
    bitnami/owncloud:latest
  ```

# Customize this image

The Bitnami ownCloud Docker image is designed to be extended so it can be used as the base image for your custom web applications.

## Extend this image

Before extending this image, please note there are certain configuration settings you can modify using the original image:

- Settings that can be adapted using environment variables. For instance, you can change the ports used by Apache for HTTP and HTTPS, by setting the environment variables `APACHE_HTTP_PORT_NUMBER` and `APACHE_HTTPS_PORT_NUMBER` respectively.
- [Adding custom virtual hosts](https://github.com/bitnami/bitnami-docker-apache#adding-custom-virtual-hosts).
- [Replacing the 'httpd.conf' file](https://github.com/bitnami/bitnami-docker-apache#full-configuration).
- [Using custom SSL certificates](https://github.com/bitnami/bitnami-docker-apache#using-custom-ssl-certificates).

If your desired customizations cannot be covered using the methods mentioned above, extend the image. To do so, create your own image using a Dockerfile with the format below:

```Dockerfile
FROM bitnami/owncloud
## Put your customizations below
...
```

Here is an example of extending the image with the following modifications:

- Install the `vim` editor
- Modify the Apache configuration file
- Modify the ports used by Apache

```Dockerfile
FROM bitnami/owncloud
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
      - MARIADB_USER=bn_owncloud
      - MARIADB_DATABASE=bitnami_owncloud
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - 'mariadb_data:/bitnami'
  owncloud:
    build: .
    environment:
      - MARIADB_HOST=mariadb
      - MARIADB_PORT_NUMBER=3306
      - OWNCLOUD_DATABASE_USER=bn_owncloud
      - OWNCLOUD_DATABASE_NAME=bitnami_owncloud
      - ALLOW_EMPTY_PASSWORD=yes
      # Host for accessing OwnCloud
      # note: this setting will only be applied on the first run
      # ref: https://github.com/bitnami/bitnami-docker-owncloud#configuration
      - OWNCLOUD_HOST=localhost
    ports:
      - '80:8181'
      - '443:8143'
    volumes:
      - 'owncloud_data:/bitnami'
    depends_on:
      - mariadb
volumes:
  mariadb_data:
    driver: local
  owncloud_data:
    driver: local
```
  
# Notable Changes

## 10.2.0-debian-9-r8 and 10.2.0-ol-7-r8

- This image has been adapted so it's easier to customize. See the [Customize this image](#customize-this-image) section for more information.
- The Apache configuration volume (`/bitnami/apache`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the Apache configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom Apache configuration files are advised to mount a volume for the configuration at `/opt/bitnami/apache/conf`, or mount specific configuration files individually.
- The PHP configuration volume (`/bitnami/php`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the PHP configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom PHP configuration files are advised to mount a volume for the configuration at `/opt/bitnami/php/conf`, or mount specific configuration files individually.
- Enabling custom Apache certificates by placing them at `/opt/bitnami/apache/certs` has been deprecated, and support for this functionality will be dropped in the near future. Users wanting to enable custom certificates are advised to mount their certificate files on top of the preconfigured ones at `/certs`.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-owncloud/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-owncloud/pulls) with your contribution.

# Issues

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
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
