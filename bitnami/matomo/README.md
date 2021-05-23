
# What is Matomo?

> Matomo is a free and open source web analytics application written by a team of international developers that runs on a PHP/MySQL webserver. It tracks online visits to one or more websites and displays reports on these visits for analysis. As of September 2015, Matomo was used by nearly 900 thousand websites, or 1.3% of all websites, and has been translated to more than 45 languages. New versions are regularly released every few weeks.

https://www.matomo.org/

# TL;DR

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-matomo/master/docker-compose.yml > docker-compose.yml
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

> This [CVE scan report](https://quay.io/repository/bitnami/matomo?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`4`, `4-debian-10`, `4.3.0`, `4.3.0-debian-10-r5`, `latest` (4/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-matomo/blob/4.3.0-debian-10-r5/4/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/matomo GitHub repo](https://github.com/bitnami/bitnami-docker-matomo).

# Prerequisites

To run this application you need [Docker Engine](https://www.docker.com/products/docker-engine) >= `1.10.0`. [Docker Compose](https://www.docker.com/products/docker-compose) is recommended with a version `1.6.0` or later.

# How to get this image

The recommended way to get the Bitnami Matomo Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/matomo/).
To use a specific version, you can pull a versioned tag. Find the [list of available versions] (https://hub.docker.com/r/bitnami/matomo/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/matomo:[TAG]
```

If you wish, you can also build the image youself.

```console
docker build -t bitnami/matomo:latest 'https://github.com/bitnami/bitnami-docker-matomo.git#master:4/debian-10'
```

# How to use this image

Matomo requires access to a MySQL database or MariaDB database to store information. It uses our [MariaDB image] (https://github.com/bitnami/bitnami-docker-mariadb) for the database requirements.

## Run the application using Docker Compose

The main folder of this repository contains a functional [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-matomo/blob/master/docker-compose.yml) file. Run the application using it as shown below:

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-matomo/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

## Run the application using the Docker Command Line

If you want to run the application manually instead of using docker-compose, these are the basic steps you need to run:

1. Create a new network for the application and the database:

  ```console
  $ docker network create matomo_network
  ```

2. Create a volume for MariaDB persistence and create a MariaDB container

  ```console
  $ docker volume create --name mariadb_data
  $ docker run -d --name mariadb \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MARIADB_USER=bn_matomo \
    -e MARIADB_DATABASE=bitnami_matomo \
    --net matomo_network \
    --volume mariadb_data:/bitnami \
    bitnami/mariadb:latest
  ```

3. Create volumes for Matomo persistence and launch the container

  ```console
  $ docker volume create --name matomo_data
  $ docker run -d --name matomo -p 80:8080 -p 443:8443 \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MATOMO_DATABASE_USER=bn_matomo \
    -e MATOMO_DATABASE_NAME=bitnami_matomo \
    --net matomo_network \
    --volume matomo_data:/bitnami \
    bitnami/matomo:latest
  ```

Then you can access your application at http://your-ip/

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. Additionally you should mount a volume for [persistence of the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#persisting-your-database).

The above examples define docker volumes namely `mariadb_data` and `matomo_data`. The Matomo application state will persist as long as these volumes are not removed.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-matomo/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  mariadb:
  ...
    volumes:
      - '/path/to/mariadb-persistence:/bitnami'
  ...
  matomo:
  ...
    volumes:
      - '/path/to/matomo-persistence:/bitnami'
  ...
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

### Mount host directories as data volumes using the Docker command line

In this case you need to specify the directories to mount on the run command. The process is the same than the one previously shown:

1. Create a network (if it does not exist):

  ```console
  $ docker network create matomo_network
  ```

2. Create a MariaDB container with host volume:

  ```console
  $ docker run -d --name mariadb
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MARIADB_USER=bn_matomo \
    -e MARIADB_DATABASE=bitnami_matomo \
    --net matomo_network \
    --volume /path/to/mariadb-persistence:/bitnami \
    bitnami/mariadb:latest
  ```
   *Note:* You need to give the container a name in order to Matomo to resolve the host

3. Create the Matomo container with host volumes:

  ```console
  $ docker run -d --name matomo -p 80:80 -p 443:443 \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MATOMO_DATABASE_USER=bn_matomo \
    -e MATOMO_DATABASE_NAME=bitnami_matomo \
    --net matomo_network \
    --volume /path/to/matomo-persistence:/bitnami \
    bitnami/matomo:latest
  ```

## Backing up your container

To backup your data, configuration and logs, follow these simple steps:

### Step 1: Stop the currently running container

```console
$ docker stop matomo
```

Or using Docker Compose:

```console
$ docker-compose stop matomo
```

### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```console
$ docker run --rm -v /path/to/matomo-backups:/backups --volumes-from matomo busybox \
  cp -a /bitnami/matomo /backups/latest
```

## Restoring a backup

Restoring a backup is as simple as mounting the backup as volumes in the containers.

For the MariaDB database container:

```diff
 $ docker run -d --name mariadb \
   ...
-  --volume /path/to/mariadb-persistence:/bitnami/mariadb \
+  --volume /path/to/mariadb-backups/latest:/bitnami/mariadb \
   bitnami/mariadb:latest
```

For the Matomo container:

```diff
 $ docker run -d --name matomo \
   ...
-  --volume /path/to/matomo-persistence:/bitnami/matomo \
+  --volume /path/to/matomo-backups/latest:/bitnami/matomo \
   bitnami/matomo:latest
```


# Upgrading Matomo

Bitnami provides up-to-date versions of MariaDB and Matomo, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the Matomo container. For the MariaDB upgrade you can take a look at https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#upgrade-this-image

1. Get the updated images:

  ```console
  $ docker pull bitnami/matomo:latest
  ```

2. Stop your container

 * For docker-compose: `$ docker-compose stop matomo`
 * For manual execution: `$ docker stop matomo`

3. Take a snapshot of the application state

```console
$ rsync -a /path/to/matomo-persistence /path/to/matomo-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

Additionally, [snapshot the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#step-2-stop-and-backup-the-currently-running-container)

You can use these snapshots to restore the application state should the upgrade fail.

4. Remove the currently running container

 * For docker-compose: `$ docker-compose rm -v matomo`
 * For manual execution: `$ docker rm -v matomo`

5. Run the new image

 * For docker-compose: `$ docker-compose up matomo`
 * For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name matomo bitnami/matomo:latest`

# Configuration

## Environment variables

When you start the Matomo image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line.

### User and Site configuration

 - `APACHE_HTTP_PORT_NUMBER`: Port used by Apache for HTTP. Default: **8080**
 - `APACHE_HTTPS_PORT_NUMBER`: Port used by Apache for HTTPS. Default: **8443**
 - `MATOMO_USERNAME`: Matomo application username. Default: **User**
 - `MATOMO_HOST`: Matomo application host. Default: **127.0.0.1**
 - `MATOMO_PASSWORD`: Matomo application password. Default: **bitnami**
 - `MATOMO_EMAIL`: Matomo application email. Default: **user@example.com**
 - `MATOMO_WEBSITE_NAME`: Name of a website to track in Matomo. Default: **example**
 - `MATOMO_WEBSITE_HOST`: Website's host or domain to track in Matomo. Default: **https://example.org**
 - `MATOMO_ENABLE_PROXY_URI_HEADER`: Enable 'proxy_uri_header' in Matomo configuration file. Default: **no**
 - `MATOMO_SKIP_BOOTSTRAP`: Whether to perform initial bootstrapping for the application. Default: **no**
 - `MATOMO_ENABLE_DATABASE_SSL`: Whether to enable SSL for database connections in the Matomo configuration file. Default: **no**
 - `MATOMO_DATABASE_SSL_CA_FILE`: Path to the database server CA bundle file. No defaults.
 - `MATOMO_DATABASE_SSL_CERT_FILE`: Path to the database client certificate file. No defaults.
 - `MATOMO_DATABASE_SSL_KEY_FILE`: Path to the database client certificate key. No defaults.
 - `MATOMO_VERIFY_DATABASE_SSL`: Whether to verify the database SSL certificate when SSL is enabled. Default: **yes**
 - `BITNAMI_DEBUG`: Increase verbosity on initialization logs. Default **false**

### Use an existing database

- `MATOMO_DATABASE_HOST`: Hostname for MariaDB server. Default: **mariadb**
- `MATOMO_DATABASE_PORT_NUMBER`: Port used by MariaDB server. Default: **3306**
- `MATOMO_DATABASE_NAME`: Database name that Matomo will use to connect with the database. Default: **bitnami_matomo**
- `MATOMO_DATABASE_USER`: Database user that Matomo will use to connect with the database. Default: **bn_matomo**
- `MATOMO_DATABASE_PASSWORD`: Database password that Matomo will use to connect with the database. No defaults.
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

### Create a database for Matomo using mysql-client

- `MYSQL_CLIENT_FLAVOR`: SQL database flavor. Valid values: `mariadb` or `mysql`. Default: **mariadb**.
- `MYSQL_CLIENT_DATABASE_HOST`: Hostname for MariaDB server. Default: **mariadb**
- `MYSQL_CLIENT_DATABASE_PORT_NUMBER`: Port used by MariaDB server. Default: **3306**
- `MYSQL_CLIENT_DATABASE_ROOT_USER`: Database admin user. Default: **root**
- `MYSQL_CLIENT_DATABASE_ROOT_PASSWORD`: Database password for the database admin user. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_NAME`: New database to be created by the mysql client module. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_USER`: New database user to be created by the mysql client module. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_PASSWORD`: Database password for the `MYSQL_CLIENT_CREATE_DATABASE_USER` user. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_CHARACTER_SET`: Character set to use for the new database. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_COLLATE`: Database collation to use for the new database. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES`: Database privileges to grant for the user specified in `MYSQL_CLIENT_CREATE_DATABASE_USER` to the database specified in `MYSQL_CLIENT_CREATE_DATABASE_NAME`. No defaults.
- `MYSQL_CLIENT_ENABLE_SSL_WRAPPER`: Whether to force SSL connections to the database via the `mysql` CLI tool. Useful for applications that rely on the CLI instead of APIs. Default: **no**
- `MYSQL_CLIENT_ENABLE_SSL`: Whether to force SSL connections for the database. Default: **no**
- `MYSQL_CLIENT_SSL_CA_FILE`: Path to the SSL CA file for the new database. No defaults
- `MYSQL_CLIENT_SSL_CERT_FILE`: Path to the SSL CA file for the new database. No defaults
- `MYSQL_CLIENT_SSL_KEY_FILE`: Path to the SSL CA file for the new database. No defaults
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

##### SMTP Configuration

To configure Matomo to send email using SMTP you can set the following environment variables:

- `MATOMO_SMTP_HOST`: SMTP host.
- `MATOMO_SMTP_PORT`: SMTP port.
- `MATOMO_SMTP_USER`: SMTP account user.
- `MATOMO_SMTP_PASSWORD`: SMTP account password.
- `MATOMO_SMTP_PROTOCOL`: SMTP protocol.

##### Example

This would be an example of SMTP configuration using a Gmail account:

 * Modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-matomo/blob/master/docker-compose.yml) file present in this repository:

```yaml
  matomo:
    ...
    environment:
      - MATOMO_DATABASE_USER=bn_matomo
      - MATOMO_DATABASE_NAME=bitnami_matomo
      - ALLOW_EMPTY_PASSWORD=yes
      - MATOMO_SMTP_HOST=smtp.gmail.com
      - MATOMO_SMTP_PORT=587
      - MATOMO_SMTP_USER=your_email@gmail.com
      - MATOMO_SMTP_PASSWORD=your_password
  ...
```
 * For manual execution:

```console
  $ docker run -d --name matomo -p 80:8080 -p 443:8443 \
    --env MATOMO_DATABASE_USER=bn_matomo \
    --env MATOMO_DATABASE_NAME=bitnami_matomo \
    --env MATOMO_SMTP_HOST=smtp.gmail.com \
    --env MATOMO_SMTP_PORT=587 \
    --env MATOMO_SMTP_USER=your_email@gmail.com \
    --env MATOMO_SMTP_PASSWORD=your_password \
    --network matomo-tier \
    --volume /path/to/matomo-persistence:/bitnami \
    bitnami/matomo:latest
```

### PHP configuration

- `PHP_ENABLE_OPCACHE`: Enable OPcache for PHP scripts. No default.
- `PHP_EXPOSE_PHP`: Enables HTTP header with PHP version. No default.
- `PHP_MAX_EXECUTION_TIME`: Maximum execution time for PHP scripts. No default.
- `PHP_MAX_INPUT_TIME`: Maximum input time for PHP scripts. No default.
- `PHP_MAX_INPUT_VARS`: Maximum amount of input variables for PHP scripts. No default.
- `PHP_MEMORY_LIMIT`: Memory limit for PHP scripts. Default: **256M**
- `PHP_POST_MAX_SIZE`: Maximum size for PHP POST requests. No default.
- `PHP_UPLOAD_MAX_FILESIZE`: Maximum file size for PHP uploads. No default.

If you want to add a new environment variable:

 * For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-matomo/blob/master/docker-compose.yml) file present in this repository:

```yaml
application:
  ...
  environment:
    - MATOMO_PASSWORD=my_password
  ...
```

 * For manual execution add a `-e` option with each variable and value:

```console
 $ docker run -d -e MATOMO_PASSWORD=my_password -p 80:80 --name matomo -v /your/local/path/bitnami/matomo:/bitnami --net=matomo_network bitnami/matomo
```

### SMTP Configuration

To configure Matomo to send email using SMTP you can set the following environment variables:

 - `SMTP_HOST`: Matomo SMTP host.
 - `SMTP_PORT`: Matomo SMTP port.
 - `SMTP_USER`: Matomo SMTP account user.
 - `SMTP_PASSWORD`: Matomo SMTP account password.
 - `SMTP_PROTOCOL`: Matomo SMTP protocol to use. Available protocols are: "ssl", "tls". No default.
 - `SMTP_AUTH`: Matomo SMTP authentication mechanism to use. Available mechanisms are: "Plain", "Login", "Crammd5". Default: **Plain**.

This would be an example of SMTP configuration using a Gmail account:

 * Modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-matomo/blob/master/docker-compose.yml) file present in this repository:

```yaml
  application:
  ...
    environment:
      - SMTP_HOST=smtp.gmail.com
      - SMTP_USER=your_email@gmail.com
      - SMTP_PASSWORD=your_password
      - SMTP_PROTOCOL=tls
      - SMTP_AUTH=Plain
      - SMTP_PORT=587
  ...
```

 * For manual execution:

```console
 $ docker run -d --name matomo -p 80:80 -p 443:443 \
   --net matomo_network \
   -e MARIADB_HOST=mariadb \
   -e MARIADB_PORT_NUMBER=3306 \
   -e MATOMO_DATABASE_USER=bn_matomo \
   -e MATOMO_DATABASE_NAME=bitnami_matomo \
   -e SMTP_HOST=smtp.gmail.com \
   -e SMTP_PROTOCOL=TLS \
   -e SMTP_AUTH=Plain \
   -e SMTP_PORT=587 \
   -e SMTP_USER=your_email@gmail.com \
   -e SMTP_PASSWORD=your_password \
   -v /your/local/path/bitnami/matomo:/bitnami \
 bitnami/matomo:latest
```

# Customize this image

The Bitnami Matomo Docker image is designed to be extended so it can be used as the base image for your custom web applications.

## Extend this image

Before extending this image, please note there are certain configuration settings you can modify using the original image:

- Settings that can be adapted using environment variables. For instance, you can change the ports used by Apache for HTTP and HTTPS, by setting the environment variables `APACHE_HTTP_PORT_NUMBER` and `APACHE_HTTPS_PORT_NUMBER` respectively.
- [Adding custom virtual hosts](https://github.com/bitnami/bitnami-docker-apache#adding-custom-virtual-hosts).
- [Replacing the 'httpd.conf' file](https://github.com/bitnami/bitnami-docker-apache#full-configuration).
- [Using custom SSL certificates](https://github.com/bitnami/bitnami-docker-apache#using-custom-ssl-certificates).

If your desired customizations cannot be covered using the methods mentioned above, extend the image. To do so, create your own image using a Dockerfile with the format below:

```Dockerfile
FROM bitnami/matomo
## Put your customizations below
...
```

Here is an example of extending the image with the following modifications:

- Install the `vim` editor
- Modify the Apache configuration file
- Modify the ports used by Apache

```Dockerfile
FROM bitnami/matomo
LABEL maintainer "Bitnami <containers@bitnami.com>"

## Change user to perform privileged actions
USER 0

## Install 'vim'
RUN install_packages vim

## Enable mod_ratelimit module
RUN sed -i -r 's/#LoadModule ratelimit_module/LoadModule ratelimit_module/' /opt/bitnami/apache/conf/httpd.conf

## Revert to the original non-root user
USER 1001

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
      - MARIADB_USER=bn_matomo
      - MARIADB_DATABASE=bitnami_matomo
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - 'mariadb_data:/bitnami'
  matomo:
    build: .
    environment:
      - MARIADB_HOST=mariadb
      - MARIADB_PORT_NUMBER=3306
      - MATOMO_DATABASE_USER=bn_matomo
      - MATOMO_DATABASE_NAME=bitnami_matomo
      - ALLOW_EMPTY_PASSWORD=yes
    ports:
      - '80:8181'
      - '443:8143'
    depends_on:
      - mariadb
    volumes:
      - 'matomo_data:/bitnami'
volumes:
  mariadb_data:
    driver: local
  matomo_data:
    driver: local
```

# Notable Changes

## 3.14.1-debian-10-r79

- The size of the container image has been decreased.
- The configuration logic is now based on Bash scripts in the *rootfs/* folder.
- The Matomo container image has been migrated to a "non-root" user approach. Previously the container ran as the `root` user and the Apache daemon was started as the `daemon` user. From now on, both the container and the Apache daemon run as user `1001`. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile, or `user: root` in `docker-compose.yml`. Consequences:
  - The HTTP/HTTPS ports exposed by the container are now `8080/8443` instead of `80/443`.
  - Backwards compatibility is not guaranteed when data is persisted using docker or docker-compose. We highly recommend migrating the Matomo site by exporting its content, and importing it on a new Matomo container. Follow the steps in [Backing up your container](#backing-up-your-container) and [Restoring a backup](#restoring-a-backup) to migrate the data between the old and new container.

To upgrade a previous Bitnami Matomo container image, which did not support non-root, the easiest way is to start the new image as a root user and updating the port numbers. Modify your docker-compose.yml file as follows:

```diff
       - ALLOW_EMPTY_PASSWORD=yes
+    user: root
     ports:
-      - '80:80'
-      - '443:443'
+      - '80:8080'
+      - '443:8443'
     volumes:
```

## 3.9.1-debian-9-r51 and 3.9.1-ol-7-r62

- This image has been adapted so it's easier to customize. See the [Customize this image](#customize-this-image) section for more information.
- The Apache configuration volume (`/bitnami/apache`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the Apache configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom Apache configuration files are advised to mount a volume for the configuration at `/opt/bitnami/apache/conf`, or mount specific configuration files individually.
- The PHP configuration volume (`/bitnami/php`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the PHP configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom PHP configuration files are advised to mount a volume for the configuration at `/opt/bitnami/php/conf`, or mount specific configuration files individually.
- Enabling custom Apache certificates by placing them at `/opt/bitnami/apache/certs` has been deprecated, and support for this functionality will be dropped in the near future. Users wanting to enable custom certificates are advised to mount their certificate files on top of the preconfigured ones at `/certs`.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-matomo/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-matomo/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-matomo/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright 2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
