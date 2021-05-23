# Bitnami Docker Image for PrestaShop

## What is PrestaShop?

> PrestaShop is a popular open source e-commerce solution. Professional tools are easily accessible to increase online sales including instant guest checkout, abandoned cart reminders and automated Email marketing.

https://www.prestashop.com

## TL;DR

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-prestashop/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

You can find the default credentials and available configuration options in the [Environment Variables](#environment-variables) section.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.

> This [CVE scan report](https://quay.io/repository/bitnami/prestashop?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

## How to deploy PrestaShop in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami PrestaShop Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/prestashop).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`1.7`, `1.7-debian-10`, `1.7.7-4`, `1.7.7-4-debian-10-r18`, `latest` (1.7/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-prestashop/blob/1.7.7-4-debian-10-r18/1.7/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/prestashop GitHub repo](https://github.com/bitnami/bitnami-docker-prestashop).

## Get this image

The recommended way to get the Bitnami PrestaShop Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/prestashop).

```console
$ docker pull bitnami/prestashop:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/prestashop/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/prestashop:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/prestashop:latest 'https://github.com/bitnami/bitnami-docker-prestashop.git#master:1.7/debian-10'
```

## How to use this image

PrestaShop requires access to a MySQL or MariaDB database to store information. We'll use the [Bitnami Docker Image for MariaDB](https://www.github.com/bitnami/bitnami-docker-mariadb) for the database requirements.

### Run the application using Docker Compose

The main folder of this repository contains a functional [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-prestashop/blob/master/docker-compose.yml) file. Run the application using it as shown below:

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-prestashop/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

### Using the Docker Command Line

If you want to run the application manually instead of using `docker-compose`, these are the basic steps you need to run:

#### Step 1: Create a network

```console
$ docker network create prestashop-network
```

#### Step 2: Create a volume for MariaDB persistence and create a MariaDB container

```console
$ docker volume create --name mariadb_data
$ docker run -d --name mariadb \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MARIADB_USER=bn_prestashop \
  --env MARIADB_PASSWORD=bitnami \
  --env MARIADB_DATABASE=bitnami_prestashop \
  --network prestashop-network \
  --volume mariadb_data:/bitnami/mariadb \
  bitnami/mariadb:latest
```

#### Step 3: Create volumes for PrestaShop persistence and launch the container

```console
$ docker volume create --name prestashop_data
$ docker run -d --name prestashop \
  -p 8080:8080 -p 8443:8443 \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env PRESTASHOP_DATABASE_USER=bn_prestashop \
  --env PRESTASHOP_DATABASE_PASSWORD=bitnami \
  --env PRESTASHOP_DATABASE_NAME=bitnami_prestashop \
  --network prestashop-network \
  --volume prestashop_data:/bitnami/prestashop \
  bitnami/prestashop:latest
```

Access your application at *http://your-ip/*

> **Note:** If you want to access your application from a public IP or hostname you need to configure PrestaShop for it. You can handle it adjusting the configuration of the instance by setting the environment variable *PRESTASHOP_HOST* to your public IP or hostname.

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/prestashop` path. If the mounted directory is empty, it will be initialized on the first run. Additionally you should mount a volume for persistence of the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#persisting-your-database).

The above examples define the Docker volumes named mariadb_data and prestashop_data. The PrestaShop application state will persist as long as volumes are not removed.

To avoid inadvertent removal of volumes, you can mount host directories as data volumes. Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-prestashop/blob/master/docker-compose.yml) file present in this repository:

```diff
   mariadb:
     ...
     volumes:
-      - 'mariadb_data:/bitnami/mariadb'
+      - /path/to/mariadb-persistence:/bitnami/mariadb
   ...
   prestashop:
     ...
     volumes:
-      - 'prestashop_data:/bitnami/prestashop'
+      - /path/to/prestashop-persistence:/bitnami/prestashop
   ...
-volumes:
-  mariadb_data:
-    driver: local
-  prestashop_data:
-    driver: local
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

### Mount host directories as data volumes using the Docker command line

#### Step 1: Create a network (if it does not exist)

```console
$ docker network create prestashop-network
```

#### Step 2. Create a MariaDB container with host volume

```console
$ docker run -d --name mariadb \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MARIADB_USER=bn_prestashop \
  --env MARIADB_PASSWORD=bitnami \
  --env MARIADB_DATABASE=bitnami_prestashop \
  --network prestashop-network \
  --volume /path/to/mariadb-persistence:/bitnami/mariadb \
  bitnami/mariadb:latest
```

#### Step 3. Create the PrestaShop container with host volumes

```console
$ docker run -d --name prestashop \
  -p 8080:8080 -p 8443:8443 \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env PRESTASHOP_DATABASE_USER=bn_prestashop \
  --env PRESTASHOP_DATABASE_PASSWORD=bitnami \
  --env PRESTASHOP_DATABASE_NAME=bitnami_prestashop \
  --network prestashop-network \
  --volume /path/to/prestashop-persistence:/bitnami/prestashop \
  bitnami/prestashop:latest
```

## Configuration

## Environment variables

When you start the PrestaShop image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. If you want to add a new environment variable:

 * For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-prestashop/blob/master/docker-compose.yml) file present in this repository:

```yaml
prestashop:
  ...
  environment:
    - PRESTASHOP_PASSWORD=my_password
  ...
```

 * For manual execution add a `--env` option with each variable and value:

  ```console
  $ docker run -d --name prestashop -p 80:8080 -p 443:8443 \
    --env PRESTASHOP_PASSWORD=my_password \
    --network prestashop-tier \
    --volume /path/to/prestashop-persistence:/bitnami \
    bitnami/prestashop:latest
  ```

Available environment variables:

##### User and Site configuration

- `APACHE_HTTP_PORT_NUMBER`: Port used by Apache for HTTP. Default: **8080**
- `APACHE_HTTPS_PORT_NUMBER`: Port used by Apache for HTTPS. Default: **8443**
- `PRESTASHOP_FIRST_NAME`: PrestaShop application User's First Name. Default: **Bitnami**
- `PRESTASHOP_LAST_NAME`: PrestaShop application User's Last Name. Default: **User**
- `PRESTASHOP_PASSWORD`: PrestaShop application password. Default: **bitnami1**
- `PRESTASHOP_EMAIL`: PrestaShop application email. Default: **user@example.com**
- `PRESTASHOP_HOST`: PrestaShop server hostname/address.
- `PRESTASHOP_ENABLE_HTTPS`: Whether to use HTTPS by default. Default: **no**.
- `PRESTASHOP_EXTERNAL_HTTP_PORT_NUMBER`: Port to used by PrestaShop to generate URLs and links when accessing using HTTP. Default **80**.
- `PRESTASHOP_EXTERNAL_HTTPS_PORT_NUMBER`: Port to used by PrestaShop to generate URLs and links when accessing using HTTPS. Default **443**.
- `PRESTASHOP_COOKIE_CHECK_IP`: Whether to check the cookie's IP address or not. Default: **yes**. See the [Troubleshooting](#troubleshooting) section for more information.
- `PRESTASHOP_COUNTRY`: Default country of the store. Default: **us**.
- `PRESTASHOP_LANGUAGE`: Default language of the store (iso code). Default: **en**.
- `PRESTASHOP_SKIP_BOOTSTRAP`: Whether to perform initial bootstrapping for the application. Default: **no**

##### Use an existing database

- `PRESTASHOP_DATABASE_HOST`: Hostname for MariaDB server. Default: **mariadb**
- `PRESTASHOP_DATABASE_PORT_NUMBER`: Port used by MariaDB server. Default: **3306**
- `PRESTASHOP_DATABASE_NAME`: Database name that PrestaShop will use to connect with the database. Default: **bitnami_prestashop**
- `PRESTASHOP_DATABASE_USER`: Database user that PrestaShop will use to connect with the database. Default: **bn_prestashop**
- `PRESTASHOP_DATABASE_PASSWORD`: Database password that PrestaShop will use to connect with the database. No defaults.
- `PRESTASHOP_DATABASE_PREFIX`: Database table prefix that prestashop will use in the database. Default: **ps_**
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

##### Create a database for PrestaShop using mysql-client

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

To configure PrestaShop to send email using SMTP you can set the following environment variables:

- `PRESTASHOP_SMTP_HOST`: SMTP host.
- `PRESTASHOP_SMTP_PORT`: SMTP port.
- `PRESTASHOP_SMTP_USER`: SMTP account user.
- `PRESTASHOP_SMTP_PASSWORD`: SMTP account password.

##### PHP configuration

- `PHP_ENABLE_OPCACHE`: Enable OPcache for PHP scripts. No default.
- `PHP_EXPOSE_PHP`: Enables HTTP header with PHP version. No default.
- `PHP_MAX_EXECUTION_TIME`: Maximum execution time for PHP scripts. Default: **300**
- `PHP_MAX_INPUT_TIME`: Maximum input time for PHP scripts. Default: **-1**
- `PHP_MAX_INPUT_VARS`: Maximum amount of input variables for PHP scripts. Default: **10000**
- `PHP_MEMORY_LIMIT`: Memory limit for PHP scripts. Default: **256M**
- `PHP_POST_MAX_SIZE`: Maximum size for PHP POST requests. Default: **20M**
- `PHP_UPLOAD_MAX_FILESIZE`: Maximum file size for PHP uploads. Default: **25M**

##### Example

This would be an example of SMTP configuration using a Gmail account:

 * Modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-prestashop/blob/master/docker-compose.yml) file present in this repository:

```yaml
  prestashop:
    ...
    environment:
      - PRESTASHOP_DATABASE_USER=bn_prestashop
      - PRESTASHOP_DATABASE_NAME=bitnami_prestashop
      - ALLOW_EMPTY_PASSWORD=yes
      - PRESTASHOP_SMTP_HOST=smtp.gmail.com
      - PRESTASHOP_SMTP_PORT=587
      - PRESTASHOP_SMTP_USER=your_email@gmail.com
      - PRESTASHOP_SMTP_PASSWORD=your_password
  ...
```
 * For manual execution:

  ```console
  $ docker run -d --name prestashop -p 80:8080 -p 443:8443 \
    --env PRESTASHOP_DATABASE_USER=bn_prestashop \
    --env PRESTASHOP_DATABASE_NAME=bitnami_prestashop \
    --env PRESTASHOP_SMTP_HOST=smtp.gmail.com \
    --env PRESTASHOP_SMTP_PORT=587 \
    --env PRESTASHOP_SMTP_USER=your_email@gmail.com \
    --env PRESTASHOP_SMTP_PASSWORD=your_password \
    --network prestashop-tier \
    --volume /path/to/prestashop-persistence:/bitnami \
    bitnami/prestashop:latest
  ```

## Troubleshooting

* If you are automatically logged out from the administration panel, you can try to deploy PrestaShop with the environment variable `PRESTASHOP_COOKIE_CHECK_IP=no`

## Logging

The Bitnami PrestaShop Docker image sends the container logs to `stdout`. To view the logs:

```console
$ docker logs prestashop
```

Or using Docker Compose:

```console
$ docker-compose logs prestashop
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Backing up your container

To backup your data, configuration and logs, follow these simple steps:

#### Step 1: Stop the currently running container

```console
$ docker stop prestashop
```

Or using Docker Compose:

```console
$ docker-compose stop prestashop
```

#### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```console
$ docker run --rm -v /path/to/prestashop-backups:/backups --volumes-from prestashop busybox \
  cp -a /bitnami/prestashop /backups/latest
```

### Restoring a backup

Restoring a backup is as simple as mounting the backup as volumes in the containers.

For the MariaDB database container:

```diff
 $ docker run -d --name mariadb \
   ...
-  --volume /path/to/mariadb-persistence:/bitnami/mariadb \
+  --volume /path/to/mariadb-backups/latest:/bitnami/mariadb \
   bitnami/mariadb:latest
```

For the PrestaShop container:

```diff
 $ docker run -d --name prestashop \
   ...
-  --volume /path/to/prestashop-persistence:/bitnami/prestashop \
+  --volume /path/to/prestashop-backups/latest:/bitnami/prestashop \
   bitnami/prestashop:latest
```

### Upgrade this image

Bitnami provides up-to-date versions of MariaDB and PrestaShop, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the PrestaShop container. For the MariaDB upgrade see: https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#upgrade-this-image

#### Step 1: Get the updated image

```console
$ docker pull bitnami/prestashop:latest
```

#### Step 2: Stop the running container

Stop the currently running container using the command

```console
$ docker-compose stop prestashop
```

#### Step 3: Take a snapshot of the application state

Follow the steps in [Backing up your container](#backing-up-your-container) to take a snapshot of the current application state.

#### Step 4: Remove the currently running container

Remove the currently running container by executing the following command:

```console
docker-compose rm -v prestashop
```

#### Step 5: Run the new image

Update the image tag in `docker-compose.yml` and re-create your container with the new image:

```console
$ docker-compose up -d
```

## Customize this image

The Bitnami PrestaShop Docker image is designed to be extended so it can be used as the base image for your custom web applications.

### Extend this image

Before extending this image, please note there are certain configuration settings you can modify using the original image:

- Settings that can be adapted using environment variables. For instance, you can change the ports used by Apache for HTTP and HTTPS, by setting the environment variables `APACHE_HTTP_PORT_NUMBER` and `APACHE_HTTPS_PORT_NUMBER` respectively.
- [Adding custom virtual hosts](https://github.com/bitnami/bitnami-docker-apache#adding-custom-virtual-hosts).
- [Replacing the 'httpd.conf' file](https://github.com/bitnami/bitnami-docker-apache#full-configuration).
- [Using custom SSL certificates](https://github.com/bitnami/bitnami-docker-apache#using-custom-ssl-certificates).

If your desired customizations cannot be covered using the methods mentioned above, extend the image. To do so, create your own image using a Dockerfile with the format below:

```Dockerfile
FROM bitnami/prestashop
## Put your customizations below
...
```

Here is an example of extending the image with the following modifications:

- Install the `vim` editor
- Modify the Apache configuration file
- Modify the ports used by Apache

```Dockerfile
FROM bitnami/prestashop
LABEL maintainer "Bitnami <containers@bitnami.com>"

## Change user to perform privileged actions
USER 0
## Install 'vim'
RUN install_packages vim
## Revert to the original non-root user
USER 1001

## Enable mod_ratelimit module
RUN sed -i -r 's/#LoadModule ratelimit_module/LoadModule ratelimit_module/' /opt/bitnami/apache/conf/httpd.conf

## Modify the ports used by Apache by default
# It is also possible to change these environment variables at runtime
ENV APACHE_HTTP_PORT_NUMBER=8181
ENV APACHE_HTTPS_PORT_NUMBER=8143
EXPOSE 8181 8143
```

Based on the extended image, you can update the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-prestashop/blob/master/docker-compose.yml) file present in this repository to add other features:

```diff
   prestashop:
-    image: bitnami/prestashop:latest
+    build: .
     ports:
-      - '80:8080'
-      - '443:8443'
+      - '80:8181'
+      - '443:8143'
     environment:
+      - PHP_MEMORY_LIMIT=512m
     ...
```

## Notable Changes

### 1.7.6-8-debian-10-r1

- The size of the container image has been decreased.
- The configuration logic is now based on Bash scripts in the *rootfs/* folder.
- The PrestaShop container image has been migrated to a "non-root" user approach. Previously the container ran as the `root` user and the Apache daemon was started as the `daemon` user. From now on, both the container and the Apache daemon run as user `1001`. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile, or `user: root` in `docker-compose.yml`. Consequences:
  - The HTTP/HTTPS ports exposed by the container are now `8080/8443` instead of `80/443`.
  - Backwards compatibility is not guaranteed when data is persisted using docker or docker-compose. We highly recommend migrating the PrestaShop site by exporting its content, and importing it on a new PrestaShop container. Follow the steps in [Backing up your container](#backing-up-your-container) and [Restoring a backup](#restoring-a-backup) to migrate the data between the old and new container.

To upgrade a deployment with the previous Bitnami PrestaShop container image, which did not support non-root, the easiest way is to start the new image as a *root* user and updating the port numbers. Modify your `docker-compose.yml` file as follows:

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

### 1.7.5-2-debian-9-r12 and 1.7.5-2-ol-7-r18

- This image has been adapted so it's easier to customize. See the [Customize this image](#customize-this-image) section for more information.
- The Apache configuration volume (`/bitnami/apache`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the Apache configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom Apache configuration files are advised to mount a volume for the configuration at `/opt/bitnami/apache/conf`, or mount specific configuration files individually.
- The PHP configuration volume (`/bitnami/php`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the PHP configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom PHP configuration files are advised to mount a volume for the configuration at `/opt/bitnami/php/conf`, or mount specific configuration files individually.
- Enabling custom Apache certificates by placing them at `/opt/bitnami/apache/certs` has been deprecated, and support for this functionality will be dropped in the near future. Users wanting to enable custom certificates are advised to mount their certificate files on top of the preconfigured ones at `/certs`.

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-prestashop/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-prestashop/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-prestashop/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

## License

Copyright (c) 2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
