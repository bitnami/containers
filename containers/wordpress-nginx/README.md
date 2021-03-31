
# What is WordPress with NGINX?

> WordPress with NGINX combines the most popular blogging application with the power of the NGINX web server.

[https://www.wordpress.org/](https://www.wordpress.org/)
[https://nginx.org/](https://nginx.org/)

# TL;DR

## Docker Compose

```console
$ curl -LO https://raw.githubusercontent.com/bitnami/bitnami-docker-wordpress-nginx/master/docker-compose.yml
$ curl -LO https://raw.githubusercontent.com/bitnami/bitnami-docker-wordpress-nginx/master/wordpress-server-block.conf
$ docker-compose up
```

You can find the default credentials and available configuration options in the [Environment Variables](#environment-variables) section.

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.

> This [CVE scan report](https://quay.io/repository/bitnami/wordpress-nginx?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`5`, `5-debian-10`, `5.7.0`, `5.7.0-debian-10-r19`, `latest` (5/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-wordpress-nginx/blob/5.7.0-debian-10-r19/5/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/wordpress-nginx GitHub repo](https://github.com/bitnami/bitnami-docker-wordpress-nginx).

# Prerequisites

To run this application you need [Docker Engine](https://www.docker.com/products/docker-engine) >= `1.10.0`. [Docker Compose](https://www.docker.com/products/docker-compose) is recommended with a version `1.6.0` or later.

# How to use this image

WordPress requires access to a MySQL or MariaDB database to store information. We'll use our very own [MariaDB image](https://www.github.com/bitnami/bitnami-docker-mariadb) for the database requirements.

## Using Docker Compose

The main folder of this repository contains a functional [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-wordpress-nginx/blob/master/docker-compose.yml) file. Run the application using it as shown below:

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-wordpress-nginx/master/docker-compose.yml > docker-compose.yml
$ curl -LO https://raw.githubusercontent.com/bitnami/bitnami-docker-wordpress-nginx/master/wordpress-server-block.conf
$ docker-compose up -d
```

> NOTE: If you are pulling from a private containers registry, replace the image name with the full URL to the docker image. E.g.
>
> wordpress:
>  image: 'your-registry/wordpress:your-version'

## Using the Docker Command Line

If you want to run the application manually instead of using `docker-compose`, these are the basic steps you need to run:

### Step 1: Create a network

```console
$ docker network create wordpress-network
```

### Step 2: Create a volume for MariaDB persistence and create a MariaDB container

```console
$ docker volume create --name mariadb_data
$ docker run -d --name mariadb \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MARIADB_USER=bn_wordpress \
  --env MARIADB_DATABASE=bitnami_wordpress \
  --network wordpress-network \
  --volume mariadb_data:/bitnami/mariadb \
  bitnami/mariadb:latest
```

### Step 3: Create volumes for WordPress persistence and launch the container

```console
$ docker volume create --name wordpress_data
$ docker run -d --name wordpress \
  -p 8080:8080 -p 8443:8443 \
  -e ALLOW_EMPTY_PASSWORD=yes \
  -e WORDPRESS_DATABASE_USER=bn_wordpress \
  -e WORDPRESS_DATABASE_NAME=bitnami_wordpress \
  --network wordpress-network \
  --volume wordpress_data:/bitnami/wordpress \
  --volume ./wordpress-server-block.conf:/opt/bitnami/nginx/conf/server_blocks/wordpress-server-block.conf \
  bitnami/wordpress-nginx:latest
```

Access your application at http://your-ip/

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami/wordpress` path. Additionally you should mount a volume for [persistence of the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#persisting-your-database).

The above examples define docker volumes namely `mariadb_data` and `wordpress_data`. The Wordpress application state will persist as long as these volumes are not removed.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-wordpress-nginx/blob/master/docker-compose.yml) file present in this repository:

```diff
 ...
 services:
   mariadb:
     ...
     volumes:
-      - 'mariadb_data:/bitnami/mariadb'
+      - /path/to/mariadb-persistence:/bitnami/mariadb
   ...
   wordpress:
      ...
     volumes:
-      - 'wordpress_data:/bitnami/wordpress
+      - /path/to/wordpress-persistence:/bitnami/wordpress
       - ./wordpress-server-block.conf:/opt/bitnami/nginx/conf/server_blocks/wordpress-server-block.conf
   ...
-volumes:
-  mariadb_data:
-    driver: local
-  wordpress_data:
-    driver: local
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

### Mount host directories as data volumes using the Docker command line

#### Step 1: Create a network (if it does not exist)

```console
$ docker network create wordpress-network
```

#### Step 2. Create a MariaDB container with host volume

```console
$ docker run -d --name mariadb \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MARIADB_USER=bn_wordpress \
  --env MARIADB_DATABASE=bitnami_wordpress \
  --network wordpress-network \
  --volume /path/to/mariadb-persistence:/bitnami/mariadb \
  bitnami/mariadb:latest
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

#### Step 3. Create the WordPress container with host volumes

```console
$ docker run -d --name wordpress \
  -p 8080:8080 -p 8443:8443 \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env WORDPRESS_DATABASE_USER=bn_wordpress \
  --env WORDPRESS_DATABASE_NAME=bitnami_wordpress \
  --network wordpress-network \
  --volume /path/to/wordpress-persistence:/bitnami/wordpress \
  --volume ./wordpress-server-block.conf:/opt/bitnami/nginx/conf/server_blocks/wordpress-server-block.conf \
  bitnami/wordpress-nginx:latest
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

# Upgrading WordPress

Bitnami provides up-to-date versions of MariaDB and WordPress, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the WordPress container. For the MariaDB upgrade see https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#upgrade-this-image

The `bitnami/wordpress-nginx:latest` tag always points to the most recent release. To get the most recent release you can simple repull the `latest` tag from the Docker Hub with `docker pull bitnami/wordpress-nginx:latest`. However it is recommended to use [tagged versions](https://hub.docker.com/r/bitnami/wordpress-nginx/tags/).

## Step 1. Get the updated images:

```console
$ docker pull bitnami/wordpress-nginx:latest
```

## Step 2. Stop your container

* For docker-compose: `$ docker-compose stop wordpress`
* For manual execution: `$ docker stop wordpress`

## Step 3. Take a snapshot of the application state

```console
$ rsync -a /path/to/wordpress-persistence /path/to/wordpress-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

Additionally, [snapshot the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#step-2-stop-and-backup-the-currently-running-container)

You can use these snapshots to restore the application state should the upgrade fail.

## Step 4. Remove the stopped container

* For docker-compose: `$ docker-compose rm wordpress`
* For manual execution: `$ docker rm wordpress`

## Step 5. Run the new image

* For docker-compose: `$ docker-compose start wordpress`
* For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name wordpress bitnami/wordpress-nginx:latest`

# Configuration

## Environment variables

The WordPress instance can be customized by specifying environment variables on the first run. The following environment values are provided to custom WordPress:

##### User and Site configuration

* `WORDPRESS_USERNAME`: WordPress application username. Default: **user**
* `WORDPRESS_PASSWORD`: WordPress application password. Default: **bitnami**
* `WORDPRESS_EMAIL`: WordPress application email. Default: **user@example.com**
* `WORDPRESS_FIRST_NAME`: WordPress user first name. Default: **FirstName**
* `WORDPRESS_LAST_NAME`: WordPress user last name. Default: **LastName**
* `WORDPRESS_BLOG_NAME`: WordPress blog name. Default: **User's blog**
* `WORDPRESS_SCHEME`: Scheme to generate application URLs. Default: **http**
* `WORDPRESS_RESET_DATA_PERMISSIONS`: Force reseting ownership/permissions on persisted data when restarting WordPress, otherwise it assumes the ownership/permissions are correct. Ignored when running WP as non-root. Default: **no**

##### Use an existing database

* `MARIADB_HOST`: Hostname for MariaDB server. Default: **mariadb**
* `MARIADB_PORT_NUMBER`: Port used by MariaDB server. Default: **3306**
* `WORDPRESS_DATABASE_NAME`: Database name that WordPress will use to connect with the database. Default: **bitnami_wordpress**
* `WORDPRESS_TABLE_PREFIX`: Table prefix to use in WordPress. Default: **wp_**
* `WORDPRESS_DATABASE_USER`: Database user that WordPress will use to connect with the database. Default: **bn_wordpress**
* `WORDPRESS_DATABASE_PASSWORD`: Database password that WordPress will use to connect with the database. No defaults.
* `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

##### Create a database for WordPress using mysql-client

* `MARIADB_HOST`: Hostname for MariaDB server. Default: **mariadb**
* `MARIADB_PORT_NUMBER`: Port used by MariaDB server. Default: **3306**
* `MARIADB_ROOT_USER`: Database admin user. Default: **root**
* `MARIADB_ROOT_PASSWORD`: Database password for the `MARIADB_ROOT_USER` user. No defaults.
* `MYSQL_CLIENT_CREATE_DATABASE_NAME`: New database to be created by the mysql client module. No defaults.
* `WORDPRESS_TABLE_PREFIX`: Table prefix to use in WordPress. Default: **wp_**
* `MYSQL_CLIENT_CREATE_DATABASE_USER`: New database user to be created by the mysql client module. No defaults.
* `MYSQL_CLIENT_CREATE_DATABASE_PASSWORD`: Database password for the `MYSQL_CLIENT_CREATE_DATABASE_USER` user. No defaults.
* `WORDPRESS_DATABASE_SSL_CA_FILE`: Certificate to connect with the  database using SSL. No defaults.
* `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

### SMTP Configuration

To configure WordPress to send email using SMTP you can set the following environment variables:

* `SMTP_HOST`: Host for outgoing SMTP email. No defaults.
* `SMTP_PORT`: Port for outgoing SMTP email. No defaults.
* `SMTP_USER`: User of SMTP used for authentication (likely email). No defaults.
* `SMTP_PASSWORD`: Password for SMTP. No defaults.
* `SMTP_PROTOCOL`: Secure connection protocol to use for SMTP [tls, ssl, none]. No defaults.

This would be an example of SMTP configuration using a GMail account:

* Modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-wordpress-nginx/blob/master/docker-compose.yml) file present in this repository:

```diff
   wordpress:
     ...
     environment:
       - MARIADB_HOST=mariadb
       - MARIADB_PORT_NUMBER=3306
       - WORDPRESS_DATABASE_USER=bn_wordpress
       - WORDPRESS_DATABASE_NAME=bitnami_wordpress
       - ALLOW_EMPTY_PASSWORD=yes
+      - SMTP_HOST=smtp.gmail.com
+      - SMTP_PORT=587
+      - SMTP_USER=your_email@gmail.com
+      - SMTP_PASSWORD=your_password
+      - SMTP_PROTOCOL=tls
    ...
```

* For manual execution:

```console
$ docker run -d --name wordpress \
  -p 8080:8080 -p 8443:8443 \
  --network wordpress-network \
  --env SMTP_HOST=smtp.gmail.com --env SMTP_PORT=587 \
  --env SMTP_USER=your_email@gmail.com --env SMTP_PASSWORD=your_password \
  --env ALLOW_EMPTY_PASSWORD=yes --env WORDPRESS_DATABASE_USER=bn_wordpress \
  --env WORDPRESS_DATABASE_NAME=bitnami_wordpress \
  --volume wordpress_data:/bitnami/wordpress-nginx \
  --volume ./wordpress-server-block.conf:/opt/bitnami/nginx/conf/server_blocks/wordpress-server-block.conf \
  bitnami/wordpress-nginx:latest
```

### Connect WordPress docker container to an existing database

The Bitnami WordPress container supports connecting the WordPress application to an external database. In order to configure it, you should set the following environment variables:
- `MARIADB_HOST`: Hostname for MariaDB server. Default: **mariadb**
- `MARIADB_PORT_NUMBER`: Port used by MariaDB server. Default: **3306**
- `WORDPRESS_DATABASE_NAME`: Database name that WordPress will use to connect with the database. Default: **bitnami_wordpress**
- `WORDPRESS_DATABASE_USER`: Database user that WordPress will use to connect with the database. Default: **bn_wordpress**
- `WORDPRESS_DATABASE_PASSWORD`: Database password that WordPress will use to connect with the database. No defaults.

This would be an example of using an external database for WordPress.

* Modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-wordpress-nginx/blob/master/docker-compose.yml) file present in this repository:

```diff
   wordpress:
     ...
     environment:
-      - MARIADB_HOST=mariadb
+      - MARIADB_HOST=mariadb_host
       - MARIADB_PORT_NUMBER=3306
       - WORDPRESS_DATABASE_NAME=wordpress_db
       - WORDPRESS_DATABASE_USER=wordpress_user
-      - ALLOW_EMPTY_PASSWORD=yes
+      - WORDPRESS_DATABASE_PASSWORD=wordpress_password
     ...
```

* For manual execution:

```console
$ docker run -d --name wordpress \
  -p 8080:8080 -p 8443:8443 \
  --network wordpress-network \
  --env MARIADB_HOST=mariadb_host \
  --env MARIADB_PORT_NUMBER=3306 \
  --env WORDPRESS_DATABASE_NAME=wordpress_db \
  --env WORDPRESS_DATABASE_USER=wordpress_user \
  --env WORDPRESS_DATABASE_PASSWORD=wordpress_password \
  --volume wordpress_data:/bitnami/wordpress \
  --volume ./wordpress-server-block.conf:/opt/bitnami/nginx/conf/server_blocks/wordpress-server-block.conf \
  bitnami/wordpress-nginx:latest
```

## WP-CLI tool

The Bitnami WordPress with NGINX container includes the command line interface **wp-cli** that can help you to manage and interact with your WP sites.

This would be an example of using **wp-cli** to display the help menu:

* Using `docker-compose` command:

```console
$ docker-compose exec wordpress wp help
```

* Using `docker` command:

```console
$ docker exec wordpress wp help
```

Find more information about parameters available in the tool in the [official documentation](https://make.wordpress.org/cli/handbook/config/).

# Customize this image

The Bitnami WordPress with NGINX Docker image is designed to be extended so it can be used as the base image for your custom web applications.

## Extend this image

Before extending this image, please note there are certain configuration settings you can modify using the original image:

- Settings that can be adapted using environment variables. For instance, you can change the ports used by Nginx for HTTP and HTTPS, by setting the environment variables `NGINX_HTTP_PORT_NUMBER` and `NGINX_HTTPS_PORT_NUMBER` respectively.
- [Adding custom server blcoks](https://github.com/bitnami/bitnami-docker-nginx#adding-custom-server-blocks)
- [Replacing the 'nginx.conf' file](https://github.com/bitnami/bitnami-docker-nginx#full-configuration).
- [Using custom SSL certificates](https://github.com/bitnami/bitnami-docker-nginx#using-custom-ssl-certificates).

If your desired customizations cannot be covered using the methods mentioned above, extend the image. To do so, create your own image using a Dockerfile with the format below:

```Dockerfile
FROM bitnami/wordpress-nginx
## Put your customizations below
...
```

Here is an example of extending the image with the following modifications:

- Install the `vim` editor
- Modify the NGINX configuration file
- Modify the ports used by NGINX

```Dockerfile
FROM bitnami/wordpress-nginx
LABEL maintainer "Bitnami <containers@bitnami.com>"

## Change user to perform privileged actions
USER 0
## Install 'vim'
RUN install_packages vim
## Revert to the original non-root user
USER 1001

## Modify 'worker_connections' on NGINX config file to '512'
RUN sed -i -r "s#(\s+worker_connections\s+)[0-9]+;#\1512;#" /opt/bitnami/nginx/conf/nginx.conf

## Modify the ports used by NGINX by default
# It is also possible to change these environment variables at runtime
ENV NGINX_HTTP_PORT_NUMBER=8181
ENV NGINX_HTTPS_PORT_NUMBER=8143
EXPOSE 8181 8143
```

Based on the extended image, you can use a Docker Compose file like the one below to add other features:

```yaml
version: '2'
services:
  mariadb:
    image: 'bitnami/mariadb:10.3'
    volumes:
      - 'mariadb_data:/bitnami/mariadb'
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
      - 'wordpress_data:/bitnami/wordpress'
      - './wordpress-server-block.conf:/opt/bitnami/nginx/conf/server_blocks/wordpress-server-block.conf'
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

## 5.3.2-debian-10-r30

- The WordPress with NGINX container has been migrated to a "non-root" user approach. Previously the container ran as the `root` user and the NGINX daemon was started as the `daemon` user. From now on, both the container and the NGINX daemon run as user `1001`. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.
- Consequences:
  - The HTTP/HTTPS ports exposed by the container are now `8080/8443` instead of `80/443`.
  - Backwards compatibility is not guaranteed when data is persisted using docker or docker-compose. We highly recommend migrating the WP site by exporting its content, and importing it on a new WordPress container. In the links below you'll find some alternatives:
    - [Migrate WordPress using All-in-One WP Migration plugin](https://docs.bitnami.com/general/how-to/migrate-wordpress/)
    - [Migrate WordPress using VaultPress](https://vaultpress.com/)
  - No writing permissions will be granted on `wp-config.php` by default.

## 5.2.1-debian-9-r8 and 5.2.1-ol-7-r8

- This image has been adapted so it's easier to customize. See the [Customize this image](#customize-this-image) section for more information.
- The PHP configuration volume (`/bitnami/php`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the PHP configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom PHP configuration files are advised to mount a volume for the configuration at `/opt/bitnami/php/conf`, or mount specific configuration files individually.
- Enabling custom NGINX certificates by placing them at `/opt/bitnami/nginx/certs` has been deprecated, and support for this functionality will be dropped in the near future. Users wanting to enable custom certificates are advised to mount their certificate files on top of the preconfigured ones at `/certs`.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-wordpress-nginx/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-wordpress-nginx/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-wordpress-nginx/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`$ docker version`)
- Output of `$ docker info`
- Version of this container (`$ echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright 2015-2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
