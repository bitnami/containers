# What is MySQL?

> MySQL is a fast, reliable, scalable, and easy to use open-source relational database system. MySQL Server is intended for mission-critical, heavy-load production systems as well as for embedding into mass-deployed software.

[https://mysql.com/](https://mysql.com/)

# TL;DR

```console
$ docker run --name mysql -e ALLOW_EMPTY_PASSWORD=yes bitnami/mysql:latest
```

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-mysql/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/mysql?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy MySQL in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami MySQL Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/mysql).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`8.0`, `8.0-debian-10`, `8.0.25`, `8.0.25-debian-10-r4`, `latest` (8.0/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-mysql/blob/8.0.25-debian-10-r4/8.0/debian-10/Dockerfile)
* [`5.7`, `5.7-debian-10`, `5.7.34`, `5.7.34-debian-10-r23` (5.7/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-mysql/blob/5.7.34-debian-10-r23/5.7/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/mysql GitHub repo](https://github.com/bitnami/bitnami-docker-mysql).

# Get this image

The recommended way to get the Bitnami MySQL Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/mysql).

```console
$ docker pull bitnami/mysql:latest
```

To use a specific version, you can pull a versioned tag. You can view the
[list of available versions](https://hub.docker.com/r/bitnami/mysql/tags/)
in the Docker Hub Registry.

```console
$ docker pull bitnami/mysql:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
$ git clone https://github.com/bitnami/bitnami-docker-mysql.git
$ cd bitnami-docker-mysql/VERSION/OPERATING-SYSTEM
$ docker build -t bitnami/mysql:latest .
```

# Persisting your database

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/mysql/data` path. If the mounted directory is empty, it will be initialized on the first run.

```console
$ docker run \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -v /path/to/mysql-persistence:/bitnami/mysql/data \
    bitnami/mysql:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-mysql/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  mysql:
  ...
    volumes:
      - /path/to/mysql-persistence:/bitnami/mysql/data
  ...
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a MySQL server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

In this example, we will create a MySQL client instance that will connect to the server instance that is running on the same docker network as the client.

### Step 1: Create a network

```console
$ docker network create app-tier --driver bridge
```

### Step 2: Launch the MySQL server instance

Use the `--network app-tier` argument to the `docker run` command to attach the MySQL container to the `app-tier` network.

```console
$ docker run -d --name mysql-server \
    -e ALLOW_EMPTY_PASSWORD=yes \
    --network app-tier \
    bitnami/mysql:latest
```

### Step 3: Launch your MySQL client instance

Finally we create a new container instance to launch the MySQL client and connect to the server created in the previous step:

```console
$ docker run -it --rm \
    --network app-tier \
    bitnami/mysql:latest mysql -h mysql-server -u root
```

## Using Docker Compose

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `app-tier`. In this example we assume that you want to connect to the MySQL server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge

services:
  mysql:
    image: 'bitnami/mysql:latest'
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    networks:
      - app-tier
  myapp:
    image: 'YOUR_APPLICATION_IMAGE'
    networks:
      - app-tier
```

> **IMPORTANT**:
>
> 1. Please update the `YOUR_APPLICATION_IMAGE` placeholder in the above snippet with your application image
> 2. In your application container, use the hostname `mysql` to connect to the MySQL server

Launch the containers using:

```console
$ docker-compose up -d
```

# Configuration

## Initializing a new instance

When the container is executed for the first time, it will execute the files with extensions `.sh`, `.sql` and `.sql.gz` located at `/docker-entrypoint-initdb.d`.

In order to have your custom files inside the docker image you can mount them as a volume.

Take into account those scripts are treated differently depending on the extension. While the `.sh` scripts are executed in all the nodes; the `.sql` and `.sql.gz` scripts are only executed in the master nodes. The reason behind this differentiation is that the `.sh` scripts allow adding conditions to determine what is the node running the script, while these conditions can't be set using `.sql` nor `sql.gz` files. This way it is possible to cover different use cases depending on their needs.

## Setting the root password on first run

The root user and password can easily be setup with the Bitnami MySQL Docker image using the following environment variables:

 - `MYSQL_ROOT_USER`: The database admin user. Defaults to `root`.
 - `MYSQL_ROOT_PASSWORD`: The database admin user password. No defaults.

Passing the `MYSQL_ROOT_PASSWORD` environment variable when running the image for the first time will set the password of the `MYSQL_ROOT_USER` user to the value of `MYSQL_ROOT_PASSWORD`.

```console
$ docker run --name mysql -e MYSQL_ROOT_PASSWORD=password123 bitnami/mysql:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-mysql/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  mysql:
  ...
    environment:
      - MYSQL_ROOT_PASSWORD=password123
  ...
```

**Warning** The `MYSQL_ROOT_USER` user is always created with remote access. It's suggested that the `MYSQL_ROOT_PASSWORD` env variable is always specified to set a password for the `MYSQL_ROOT_USER` user. In case you want to allow the `MYSQL_ROOT_USER` user to access the database without a password set the environment variable `ALLOW_EMPTY_PASSWORD=yes`. **This is recommended only for development**.

## Allowing empty passwords

By default the MySQL image expects all the available passwords to be set. In order to allow empty passwords, it is necessary to set the `ALLOW_EMPTY_PASSWORD=yes` env variable. This env variable is only recommended for testing or development purposes. We strongly recommend specifying the `MYSQL_ROOT_PASSWORD` for any other scenario.

```console
$ docker run --name mysql -e ALLOW_EMPTY_PASSWORD=yes bitnami/mysql:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-mysql/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  mysql:
  ...
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
  ...
```

## Setting character set and collation

It is possible to configure the character set and collation used by default by the database with the following environment variables:

- `MARIADB_CHARACTER_SET`: The default character set to use. Default: `utf8`
- `MARIADB_COLLATE`: The default collation to use. Default: `utf8_general_ci`

## Creating a database on first run

By passing the `MYSQL_DATABASE` environment variable when running the image for the first time, a database will be created. This is useful if your application requires that a database already exists, saving you from having to manually create the database using the MySQL client.

```console
$ docker run --name mysql \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MYSQL_DATABASE=my_database \
    bitnami/mysql:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-mysql/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  mysql:
  ...
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - MYSQL_DATABASE=my_database
  ...
```

## Creating a database user on first run

You can create a restricted database user that only has permissions for the database created with the [`MYSQL_DATABASE`](#creating-a-database-on-first-run) environment variable. To do this, provide the `MYSQL_USER` environment variable and to set a password for the database user provide the `MYSQL_PASSWORD` variable. MySQL supports different authentication mechanisms, such as `caching_sha2_password` or `mysql_native_password`. To set it, use the `MYSQL_AUTHENTICATION_PLUGIN` variable.

```console
$ docker run --name mysql \
  -e ALLOW_EMPTY_PASSWORD=yes \
  -e MYSQL_USER=my_user \
  -e MYSQL_PASSWORD=my_password \
  -e MYSQL_DATABASE=my_database \
  -e MYSQL_AUTHENTICATION_PLUGIN=mysql_native_password \
  bitnami/mysql:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-mysql/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  mysql:
  ...
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - MYSQL_USER=my_user
      - MYSQL_PASSWORD=my_password
      - MYSQL_DATABASE=my_database
  ...
```

**Note!** The `root` user will be created with remote access and without a password if `ALLOW_EMPTY_PASSWORD` is enabled. Please provide the `MYSQL_ROOT_PASSWORD` env variable instead if you want to set a password for the `root` user.

## Setting up a replication cluster

A **zero downtime** MySQL master-slave [replication](https://dev.mysql.com/doc/refman/5.7/en/server-option-variable-reference.html) cluster can easily be setup with the Bitnami MySQL Docker image using the following environment variables:

 - `MYSQL_REPLICATION_MODE`: The replication mode. Possible values `master`/`slave`. No defaults.
 - `MYSQL_REPLICATION_USER`: The replication user created on the master on first run. No defaults.
 - `MYSQL_REPLICATION_PASSWORD`: The replication users password. No defaults.
 - `MYSQL_MASTER_HOST`: Hostname/IP of replication master (slave parameter). No defaults.
 - `MYSQL_MASTER_PORT_NUMBER`: Server port of the replication master (slave parameter). Defaults to `3306`.
 - `MYSQL_MASTER_ROOT_USER`: User on replication master with access to `MYSQL_DATABASE` (slave parameter). Defaults to `root`
 - `MYSQL_MASTER_ROOT_PASSWORD`: Password of user on replication master with access to `MYSQL_DATABASE` (slave parameter). No defaults.

In a replication cluster you can have one master and zero or more slaves. When replication is enabled the master node is in read-write mode, while the slaves are in read-only mode. For best performance its advisable to limit the reads to the slaves.

### Step 1: Create the replication master

The first step is to start the MySQL master.

```console
$ docker run --name mysql-master \
  -e MYSQL_ROOT_PASSWORD=master_root_password \
  -e MYSQL_REPLICATION_MODE=master \
  -e MYSQL_REPLICATION_USER=my_repl_user \
  -e MYSQL_REPLICATION_PASSWORD=my_repl_password \
  -e MYSQL_USER=my_user \
  -e MYSQL_PASSWORD=my_password \
  -e MYSQL_DATABASE=my_database \
  bitnami/mysql:latest
```

In the above command the container is configured as the `master` using the `MYSQL_REPLICATION_MODE` parameter. A replication user is specified using the `MYSQL_REPLICATION_USER` and `MYSQL_REPLICATION_PASSWORD` parameters.

### Step 2: Create the replication slave

Next we start a MySQL slave container.

```console
$ docker run --name mysql-slave --link mysql-master:master \
  -e MYSQL_REPLICATION_MODE=slave \
  -e MYSQL_REPLICATION_USER=my_repl_user \
  -e MYSQL_REPLICATION_PASSWORD=my_repl_password \
  -e MYSQL_MASTER_HOST=master \
  -e MYSQL_MASTER_ROOT_PASSWORD=master_root_password \
  bitnami/mysql:latest
```

In the above command the container is configured as a `slave` using the `MYSQL_REPLICATION_MODE` parameter. The `MYSQL_MASTER_HOST`, `MYSQL_MASTER_ROOT_USER` and `MYSQL_MASTER_ROOT_PASSWORD` parameters are used by the slave to connect to the master. It also takes a dump of the existing data in the master server. The replication user credentials are specified using the `MYSQL_REPLICATION_USER` and `MYSQL_REPLICATION_PASSWORD` parameters and should be the same as the one specified on the master.

You now have a two node MySQL master/slave replication cluster up and running. You can scale the cluster by adding/removing slaves without incurring any downtime.

With Docker Compose the master/slave replication can be setup using:

```yaml
version: '2'

services:
  mysql-master:
    image: 'bitnami/mysql:latest'
    ports:
      - '3306'
    volumes:
      - /path/to/mysql-persistence:/bitnami/mysql/data
    environment:
      - MYSQL_REPLICATION_MODE=master
      - MYSQL_REPLICATION_USER=repl_user
      - MYSQL_REPLICATION_PASSWORD=repl_password
      - MYSQL_ROOT_PASSWORD=master_root_password
      - MYSQL_USER=my_user
      - MYSQL_PASSWORD=my_password
      - MYSQL_DATABASE=my_database
  mysql-slave:
    image: 'bitnami/mysql:latest'
    ports:
      - '3306'
    depends_on:
      - mysql-master
    environment:
      - MYSQL_REPLICATION_MODE=slave
      - MYSQL_REPLICATION_USER=repl_user
      - MYSQL_REPLICATION_PASSWORD=repl_password
      - MYSQL_MASTER_HOST=mysql-master
      - MYSQL_MASTER_PORT_NUMBER=3306
      - MYSQL_MASTER_ROOT_PASSWORD=master_root_password
```

Scale the number of slaves using:

```console
$ docker-compose up --detach --scale mysql-master=1 --scale mysql-slave=3
```

The above command scales up the number of slaves to `3`. You can scale down in the same manner.

> **Note**: You should not scale up/down the number of master nodes. Always have only one master node running.

## Configuration file

The image looks for user-defined configurations in `/opt/bitnami/mysql/conf/my_custom.cnf`. Create a file named `my_custom.cnf` and mount it at `/opt/bitnami/mysql/conf/my_custom.cnf`.

For example, in order to override the `max_allowed_packet` directive:

### Step 1: Write your `my_custom.cnf` file with the following content.

```config
[mysqld]
max_allowed_packet=32M
```

### Step 2: Run the MySQL image with the designed volume attached.

```console
$ docker run --name mysql \
    -p 3306:3306 \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -v /path/to/my_custom.cnf:/opt/bitnami/mysql/conf/my_custom.cnf:ro \
    -v /path/to/mysql-persistence:/bitnami/mysql/data \
    bitnami/mysql:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-mysql/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  mysql:
  ...
    volumes:
      - /path/to/mysql-persistence:/bitnami/mysql/data
      - /path/to/my_custom.cnf:/opt/bitnami/mysql/conf/my_custom.cnf:ro
  ...
```

After that, your changes will be taken into account in the server's behaviour.

Refer to the [MySQL server option and variable reference guide](https://dev.mysql.com/doc/refman/5.7/en/mysqld-option-tables.html) for the complete list of configuration options.

### Overwrite the main Configuration file

It is also possible to use your custom `my.cnf` and overwrite the main configuration file.

```console
$ docker run --name mysql -v /path/to/my.cnf:/opt/bitnami/mysql/conf/my.cnf:ro bitnami/mysql:latest
```

# Customize this image

The Bitnami MySQL Docker image is designed to be extended so it can be used as the base image for your custom configuration.

## Extend this image

Before extending this image, please note there are certain configuration settings you can modify using the original image:

- Settings that can be adapted using environment variables. For instance, you can change the ports used by MySQL, by setting the environment variables `MYSQL_PORT_NUMBER` or the character set using `MYSQL_CHARACTER_SET` respectively.

If your desired customizations cannot be covered using the methods mentioned above, extend the image. To do so, create your own image using a Dockerfile with the format below:

```Dockerfile
FROM bitnami/mysql
## Put your customizations below
...
```

Here is an example of extending the image with the following modifications:

- Install the `vim` editor
- Modify the MySQL configuration file
- Modify the ports used by MySQL
- Change the user that runs the container

```Dockerfile
FROM bitnami/mysql
LABEL maintainer "Bitnami <containers@bitnami.com>"

## Change user to perform privileged actions
USER 0
## Install 'vim'
RUN install_packages vim
## Revert to the original non-root user
USER 1001

## modify configuration file.
RUN ini-file set --section "mysqld" --key "collation-server" --value "utf8_general_ci" "/opt/bitnami/mysql/conf/my.cnf"

## Modify the ports used by MySQL by default
# It is also possible to change these environment variables at runtime
ENV MYSQL_PORT_NUMBER=3307
EXPOSE 3307

## Modify the default container user
USER 1002
```

Based on the extended image, you can use a Docker Compose file like the one below to add other features:

- Add a custom configuration

```yaml
version: '2'

services:
  mysql:
    build: .
    ports:
      - '3306:3307'
    volumes:
      - /path/to/my_custom.cnf:/opt/bitnami/mysql/conf/my_custom.cnf:ro
      - data:/bitnami/mysql/data
volumes:
  data:
    driver: local
```

# Logging

The Bitnami MySQL Docker image sends the container logs to the `stdout`. To view the logs:

```console
$ docker logs mysql
```

or using Docker Compose:

```console
$ docker-compose logs mysql
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Slow filesystems

In some platforms, the filesystem used for persistence could be slow. That could cause the database to take extra time to be ready. If that's the case, you can configure the `MYSQL_INIT_SLEEP_TIME` environment variable to make the initialization script to wait extra time (in seconds) before proceeding with the configuration operations.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of MySQL, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```console
$ docker pull bitnami/mysql:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/mysql:latest`.

### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
$ docker stop mysql
```

or using Docker Compose:

```console
$ docker-compose stop mysql
```

Next, take a snapshot of the persistent volume `/path/to/mysql-persistence` using:

```console
$ rsync -a /path/to/mysql-persistence /path/to/mysql-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

### Step 3: Remove the currently running container

```console
$ docker rm -v mysql
```

or using Docker Compose:

```console
$ docker-compose rm -v mysql
```

### Step 4: Run the new image

Re-create your container from the new image.

```console
$ docker run --name mysql bitnami/mysql:latest
```

or using Docker Compose:

```console
$ docker-compose up mysql
```

# Notable Changes

## 5.7.30-debian-10-r32 and 8.0.20-debian-10-r29

- This image has been adapted so it's easier to customize. See the [Customize this image](#customize-this-image) section for more information.

## 5.7.23-r52 and 8.0.12-r34

- Decrease the size of the container. It is not necessary Node.js anymore. MySQL configuration moved to bash scripts in the `rootfs/` folder.
- The recommended mount point to persist data changes to `/bitnami/mysql/data`.
- The MySQL configuration files are not persisted in a volume anymore. Now, they can be found at `/opt/bitnami/mysql/conf`.
- Backwards compatibility is not guaranteed when data is persisted using docker-compose. You can use the workaround below to overcome it:

```console
$ docker-compose down
# Change the mount point
sed -i -e 's#mysql_data:/bitnami#mysql_data:/bitnami/mysql/data#g' docker-compose.yml
# Pull the latest bitnami/mysql image
$ docker pull bitnami/mysql:latest
$ docker-compose up -d
```

## 5.7.22-r18 and 8.0.11-r16

- The MySQL container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the MySQL daemon was started as the `mysql` user. From now on, both the container and the MySQL daemon run as user `1001`. As a consequence, the data directory must be writable by that user. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

## 5.7.21-r6
- The MySQL conf file is not in a persistent volume by default.
- The user is able to specify a custom file in the default location '/opt/bitnami/mysql/conf/my.cnf'.

## 5.7.17-r4

- `MYSQL_MASTER_USER` has been renamed to `MYSQL_MASTER_ROOT_USER`
- `MYSQL_MASTER_PASSWORD` has been renamed to `MYSQL_MASTER_ROOT_PASSWORD`
- `MYSQL_ROOT_USER` has been added to the available env variables. It can be used to specify the admin user.
- `ALLOW_EMPTY_PASSWORD` has been added to the available env variables. It can be used to allow blank passwords for MySQL.
- By default the MySQL image requires a root password to start. You can specify it using the `MYSQL_ROOT_PASSWORD` env variable or disable this requirement by setting the `ALLOW_EMPTY_PASSWORD`  env variable to `yes` (testing or development scenarios).

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-mysql/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-mysql/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-mysql/issues/new). For us to provide better support, be sure to include the following information in your issue:

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
