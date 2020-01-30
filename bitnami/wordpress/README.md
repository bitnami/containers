# What is WordPress?

> WordPress is one of the most versatile open source content management systems on the market. WordPress is built for high performance and is scalable to many servers, has easy integration via REST, JSON, SOAP and other formats, and features a whopping 15,000 plugins to extend and customize the application for just about any type of website.

https://www.wordpress.org/

# TL;DR;

## Docker Compose

```bash
$ curl -LO https://raw.githubusercontent.com/bitnami/bitnami-docker-wordpress/master/docker-compose.yml
$ docker-compose up
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DTC)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/wordpress?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy WordPress in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami WordPress Chart GitHub repository](https://github.com/bitnami/charts/tree/master/upstreamed/wordpress).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Supported tags and respective `Dockerfile` links

> NOTE: Debian 8 images have been deprecated in favor of Debian 9 images. Bitnami will not longer publish new Docker images based on Debian 8

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/).


* [`5-ol-7`, `5.3.2-ol-7-r44` (5/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-wordpress/blob/5.3.2-ol-7-r44/5/ol-7/Dockerfile)
* [`5-debian-10`, `5.3.2-debian-10-r5`, `5`, `5.3.2`, `latest` (5/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-wordpress/blob/5.3.2-debian-10-r5/5/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/wordpress GitHub repo](https://github.com/bitnami/bitnami-docker-wordpress).

# Prerequisites

To run this application you need [Docker Engine](https://www.docker.com/products/docker-engine) >= `1.10.0`. [Docker Compose](https://www.docker.com/products/docker-compose) is recommended with a version `1.6.0` or later.

# How to use this image

WordPress requires access to a MySQL or MariaDB database to store information. We'll use our very own [MariaDB image](https://www.github.com/bitnami/bitnami-docker-mariadb) for the database requirements.

## Run the application using Docker Compose

The main folder of this repository contains a functional [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-wordpress/blob/master/docker-compose.yml) file. Run the application using it as shown below:

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-wordpress/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

## Using the Docker Command Line

If you want to run the application manually instead of using `docker-compose`, these are the basic steps you need to run:

1. Create a network

  ```bash
  $ docker network create wordpress-tier
  ```

2. Create a volume for MariaDB persistence and create a MariaDB container

  ```bash
  $ docker volume create --name mariadb_data
  $ docker run -d --name mariadb \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MARIADB_USER=bn_wordpress \
    -e MARIADB_DATABASE=bitnami_wordpress \
    --net wordpress-tier \
    --volume mariadb_data:/bitnami \
    bitnami/mariadb:latest
  ```

3. Create volumes for WordPress persistence and launch the container

  ```bash
  $ docker volume create --name wordpress_data
  $ docker run -d --name wordpress -p 80:80 -p 443:443 \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e WORDPRESS_DATABASE_USER=bn_wordpress \
    -e WORDPRESS_DATABASE_NAME=bitnami_wordpress \
    --net wordpress-tier \
    --volume wordpress_data:/bitnami \
    bitnami/wordpress:latest
  ```

Access your application at http://your-ip/

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. Additionally you should mount a volume for [persistence of the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#persisting-your-database).

The above examples define docker volumes namely `mariadb_data` and `wordpress_data`. The Wordpress application state will persist as long as these volumes are not removed.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-wordpress/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  mariadb:
  ...
    volumes:
      - /path/to/mariadb-persistence:/bitnami
  ...
  wordpress:
  ...
    volumes:
      - /path/to/wordpress-persistence:/bitnami
  ...
```

### Mount host directories as data volumes using the Docker command line

1. Create a network (if it does not exist)

  ```bash
  $ docker network create wordpress-tier
  ```

2. Create a MariaDB container with host volume

  ```bash
  $ docker run -d --name mariadb \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MARIADB_USER=bn_wordpress \
    -e MARIADB_DATABASE=bitnami_wordpress \
    --net wordpress-tier \
    --volume /path/to/mariadb-persistence:/bitnami \
    bitnami/mariadb:latest
  ```

3. Create the WordPress the container with host volumes

  ```bash
  $ docker run -d --name wordpress -p 80:80 -p 443:443 \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e WORDPRESS_DATABASE_USER=bn_wordpress \
    -e WORDPRESS_DATABASE_NAME=bitnami_wordpress \
    --net wordpress-tier \
    --volume /path/to/wordpress-persistence:/bitnami \
    bitnami/wordpress:latest
  ```

# Upgrading WordPress

Bitnami provides up-to-date versions of MariaDB and WordPress, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the WordPress container. For the MariaDB upgrade see https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#upgrade-this-image

The `bitnami/wordpress:latest` tag always points to the most recent release. To get the most recent release you can simple repull the `latest` tag from the Docker Hub with `docker pull bitnami/wordpress:latest`. However it is recommended to use [tagged versions](https://hub.docker.com/r/bitnami/wordpress/tags/).

1. Get the updated images:

  ```bash
  $ docker pull bitnami/wordpress:latest
  ```

2. Stop your container

 * For docker-compose: `$ docker-compose stop wordpress`
 * For manual execution: `$ docker stop wordpress`

3. Take a snapshot of the application state

```bash
$ rsync -a /path/to/wordpress-persistence /path/to/wordpress-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

Additionally, [snapshot the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#step-2-stop-and-backup-the-currently-running-container)

You can use these snapshots to restore the application state should the upgrade fail.

4. Remove the stopped container

 * For docker-compose: `$ docker-compose rm wordpress`
 * For manual execution: `$ docker rm wordpress`

5. Run the new image

 * For docker-compose: `$ docker-compose up wordpress`
 * For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name wordpress bitnami/wordpress:latest`

# Configuration

## Environment variables

The WordPress instance can be customized by specifying environment variables on the first run. The following environment values are provided to custom WordPress:

##### User and Site configuration

- `WORDPRESS_USERNAME`: WordPress application username. Default: **user**
- `WORDPRESS_PASSWORD`: WordPress application password. Default: **bitnami**
- `WORDPRESS_EMAIL`: WordPress application email. Default: **user@example.com**
- `WORDPRESS_FIRST_NAME`: WordPress user first name. Default: **FirstName**
- `WORDPRESS_LAST_NAME`: WordPress user last name. Default: **LastName**
- `WORDPRESS_BLOG_NAME`: WordPress blog name. Default: **User's blog**
- `WORDPRESS_SCHEME`: Scheme to generate application URLs. Default: **http**
- `WORDPRESS_HTACCESS_OVERRIDE_NONE`: Set the Apache `AllowOverride` variable to `None`. All the default directives will be loaded from `/opt/bitnami/wordpress/wordpress-htaccess.conf`. Default: **yes**.

##### Use an existing database

- `MARIADB_HOST`: Hostname for MariaDB server. Default: **mariadb**
- `MARIADB_PORT_NUMBER`: Port used by MariaDB server. Default: **3306**
- `WORDPRESS_DATABASE_NAME`: Database name that WordPress will use to connect with the database. Default: **bitnami_wordpress**
- `WORDPRESS_TABLE_PREFIX`: Table prefix to use in WordPress. Default: **wp_**
- `WORDPRESS_DATABASE_USER`: Database user that WordPress will use to connect with the database. Default: **bn_wordpress**
- `WORDPRESS_DATABASE_PASSWORD`: Database password that WordPress will use to connect with the database. No defaults.
- `WORDPRESS_SKIP_INSTALL`: Force the container to not execute the WordPress installation wizard. This is necessary in case you use a database that already has WordPress data. Default: **no**
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

##### Create a database for WordPress using mysql-client

- `MARIADB_HOST`: Hostname for MariaDB server. Default: **mariadb**
- `MARIADB_PORT_NUMBER`: Port used by MariaDB server. Default: **3306**
- `MARIADB_ROOT_USER`: Database admin user. Default: **root**
- `MARIADB_ROOT_PASSWORD`: Database password for the `MARIADB_ROOT_USER` user. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_NAME`: New database to be created by the mysql client module. No defaults.
- `WORDPRESS_TABLE_PREFIX`: Table prefix to use in WordPress. Default: **wp_**
- `MYSQL_CLIENT_CREATE_DATABASE_USER`: New database user to be created by the mysql client module. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_PASSWORD`: Database password for the `MYSQL_CLIENT_CREATE_DATABASE_USER` user. No defaults.
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

### Specifying Environment variables using Docker Compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-wordpress/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  mariadb:
  ...
    environment:
      - MARIADB_USER=bn_wordpress
      - MARIADB_DATABASE=bitnami_wordpress
      - ALLOW_EMPTY_PASSWORD=yes
  ...
  wordpress:
  ...
    environment:
      - MARIADB_HOST=mariadb
      - MARIADB_PORT_NUMBER=3306
      - WORDPRESS_DATABASE_USER=bn_wordpress
      - WORDPRESS_DATABASE_NAME=bitnami_wordpress
      - ALLOW_EMPTY_PASSWORD=yes
  ...
```

### Specifying Environment variables on the Docker command line

```bash
$ docker run -d --name wordpress -p 80:80 -p 443:443 \
  --net wordpress-tier \
  -e ALLOW_EMPTY_PASSWORD=yes \
  -e WORDPRESS_DATABASE_USER=bn_wordpress \
  -e WORDPRESS_DATABASE_NAME=bitnami_wordpress \
  -e WORDPRESS_PASSWORD=my_password \
  --volume wordpress_data:/bitnami \
  bitnami/wordpress:latest
```

### SMTP Configuration

To configure WordPress to send email using SMTP you can set the following environment variables:
- `SMTP_HOST`: Host for outgoing SMTP email. No defaults.
- `SMTP_PORT`: Port for outgoing SMTP email. No defaults.
- `SMTP_USER`: User of SMTP used for authentication (likely email). No defaults.
- `SMTP_PASSWORD`: Password for SMTP. No defaults.
- `SMTP_PROTOCOL`: Secure connection protocol to use for SMTP [tls, ssl, none]. No defaults.

This would be an example of SMTP configuration using a GMail account:

 * Modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-wordpress/blob/master/docker-compose.yml) file present in this repository:

```yaml
  wordpress:
    ...
    environment:
      - MARIADB_HOST=mariadb
      - MARIADB_PORT_NUMBER=3306
      - WORDPRESS_DATABASE_USER=bn_wordpress
      - WORDPRESS_DATABASE_NAME=bitnami_wordpress
      - SMTP_HOST=smtp.gmail.com
      - SMTP_PORT=587
      - SMTP_USER=your_email@gmail.com
      - SMTP_PASSWORD=your_password
      - SMTP_PROTOCOL=tls
    ...
```

* For manual execution:

```bash
$ docker run -d --name wordpress -p 80:80 -p 443:443 \
  --net wordpress-tier \
  --env SMTP_HOST=smtp.gmail.com --env SMTP_PORT=587 \
  --env SMTP_USER=your_email@gmail.com --env SMTP_PASSWORD=your_password \
  --env ALLOW_EMPTY_PASSWORD=yes --env WORDPRESS_DATABASE_USER=bn_wordpress \
  --env WORDPRESS_DATABASE_NAME=bitnami_wordpress \
  --volume wordpress_data:/bitnami/wordpress \
  bitnami/wordpress:latest
```

### Connect WordPress docker container to an existing database

The Bitnami WordPress container supports connecting the WordPress application to an external database. In order to configure it, you should set the following environment variables:
- `MARIADB_HOST`: Hostname for MariaDB server. Default: **mariadb**
- `MARIADB_PORT_NUMBER`: Port used by MariaDB server. Default: **3306**
- `WORDPRESS_DATABASE_NAME`: Database name that WordPress will use to connect with the database. Default: **bitnami_wordpress**
- `WORDPRESS_DATABASE_USER`: Database user that WordPress will use to connect with the database. Default: **bn_wordpress**
- `WORDPRESS_DATABASE_PASSWORD`: Database password that WordPress will use to connect with the database. No defaults.
- `WORDPRESS_DATABASE_SSL_CA_FILE`: Certificate to connect with the  database using SSL. No defaults.

This would be an example of using an external database for WordPress.

 * Modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-wordpress/blob/master/docker-compose.yml) file present in this repository:

```yaml
  wordpress:
    ...
    environment:
      - MARIADB_HOST=mariadb_host
      - MARIADB_PORT_NUMBER=3306
      - WORDPRESS_DATABASE_NAME=wordpress_db
      - WORDPRESS_DATABASE_USER=wordpress_user
      - WORDPRESS_DATABASE_PASSWORD=wordpress_password
    ...
```

* For manual execution:

```bash
$ docker run -d --name wordpress -p 80:80 -p 443:443 \
  --net wordpress-tier \
  --env MARIADB_HOST=mariadb_host \
  --env MARIADB_PORT_NUMBER=3306 \
  --env WORDPRESS_DATABASE_NAME=wordpress_db \
  --env WORDPRESS_DATABASE_USER=wordpress_user \
  --env WORDPRESS_DATABASE_PASSWORD=wordpress_password \
  --volume wordpress_data:/bitnami \
  bitnami/wordpress:latest
```

In case the database already contains data from a previous WordPress installation, you need to set the variable `WORDPRESS_SKIP_INSTALL` to `yes`. Otherwise, the container would execute the installation wizard and could modify the existing data in the database. Note that, when setting `WORDPRESS_SKIP_INSTALL` to `yes`, the values `WORDPRESS_USERNAME`, `WORDPRESS_PASSWORD`, `WORDPRESS_BLOG_NAME`, `WORDPRESS_EMAIL`, `WORDPRESS_BLOG_NAME` and `WORDPRESS_SMTP_*` variables will be ignored. Make sure that, in this imported database, the table prefix matches the one set in `WORDPRESS_TABLE_PREFIX`.

## WP-CLI tool

The Bitnami WordPress container includes the command line interface **wp-cli** that can help you to manage and interact with your WP sites. To run this tool, please note you need use the proper system user, **daemon**.

This would be an example of using **wp-cli** to display the help menu:

* Using `docker-compose` command:

```bash
$ docker-compose exec wordpress sudo -u daemon -- wp help
```

* Using `docker` command:

```bash
$ docker exec wordpress sudo -u daemon -- wp help
```

Find more information about parameters available in the tool in the [official documentation](https://make.wordpress.org/cli/handbook/config/).

# Customize this image

The Bitnami WordPress Docker image is designed to be extended so it can be used as the base image for your custom web applications.

## Extend this image

Before extending this image, please note there are certain configuration settings you can modify using the original image:

- Settings that can be adapted using environment variables. For instance, you can change the ports used by Apache for HTTP and HTTPS, by setting the environment variables `APACHE_HTTP_PORT_NUMBER` and `APACHE_HTTPS_PORT_NUMBER` respectively.
- [Adding custom virtual hosts](https://github.com/bitnami/bitnami-docker-apache#adding-custom-virtual-hosts).
- [Replacing the 'httpd.conf' file](https://github.com/bitnami/bitnami-docker-apache#full-configuration).
- [Using custom SSL certificates](https://github.com/bitnami/bitnami-docker-apache#using-custom-ssl-certificates).

If your desired customizations cannot be covered using the methods mentioned above, extend the image. To do so, create your own image using a Dockerfile with the format below:

```Dockerfile
FROM bitnami/wordpress
## Put your customizations below
...
```

Here is an example of extending the image with the following modifications:

- Install the `vim` editor
- Modify the Apache configuration file
- Modify the ports used by Apache

```Dockerfile
FROM bitnami/wordpress
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
    volumes:
      - 'mariadb_data:/bitnami'
    environment:
      - MARIADB_USER=bn_wordpress
      - MARIADB_DATABASE=bitnami_wordpress
      - ALLOW_EMPTY_PASSWORD=yes
  wordpress:
    build: .
    ports:
      - '80:8181'
      - '443:8143'
    volumes:
      - 'wordpress_data:/bitnami'
    depends_on:
      - mariadb
    environment:
      - MARIADB_HOST=mariadb
      - MARIADB_PORT_NUMBER=3306
      - WORDPRESS_DATABASE_USER=bn_wordpress
      - WORDPRESS_DATABASE_NAME=bitnami_wordpress
      - ALLOW_EMPTY_PASSWORD=yes
volumes:
  mariadb_data:
    driver: local
  wordpress_data:
    driver: local
```

# Notable Changes

## 5.2.1-debian-9-r9 and 5.2.1-ol-7-r9

- This image has been adapted so it's easier to customize. See the [Customize this image](#customize-this-image) section for more information.
- The Apache configuration volume (`/bitnami/apache`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the Apache configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom Apache configuration files are advised to mount a volume for the configuration at `/opt/bitnami/apache/conf`, or mount specific configuration files individually.
- The PHP configuration volume (`/bitnami/php`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the PHP configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom PHP configuration files are advised to mount a volume for the configuration at `/opt/bitnami/php/conf`, or mount specific configuration files individually.
- Enabling custom Apache certificates by placing them at `/opt/bitnami/apache/certs` has been deprecated, and support for this functionality will be dropped in the near future. Users wanting to enable custom certificates are advised to mount their certificate files on top of the preconfigured ones at `/certs`.

## 5.1.1-r28, 5.1.1-rhel-7-r31 and 5.1.1-ol-7-r30

- Users reported that they wanted to import their WordPress database from other installations, such as [this ticket](https://github.com/bitnami/bitnami-docker-wordpress/issues/157). Now, in order to cover this use case, the variable `WORDPRESS_SKIP_INSTALL` can be set to avoid the container launch the WordPress installation wizard.

## 5.0.3-r20

- For performance and security reasons, Apache will set the `AllowOverride` directive to `None` by default. This means that, instead of using `.htaccess` files, all the default directives will be moved to the `/opt/bitnami/wordpress/wordpress-htaccess.conf` file. The only downside of this is the compatibility with certain plugins, which would require changes in that file (you would need to mount a modified version of `wordpress-htaccess.conf` compatible with these plugins). If you want to have the default `.htaccess` behavior, set the `WORDPRESS_HTACCESS_OVERRIDE_NONE` env var to `no`.

## 5.0.0-r0

- **wp-cli** tool is included in the Docker image. Find it at **/opt/bitnami/wp-cli/bin/wp**.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-wordpress/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-wordpress/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-wordpress/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`$ docker version`)
- Output of `$ docker info`
- Version of this container (`$ echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright 2015-2020 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
