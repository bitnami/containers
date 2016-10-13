[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-mysql/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-mysql/tree/master)
[![Docker Hub Automated Build](http://container.checkforupdates.com/badges/bitnami/mysql)](https://hub.docker.com/r/bitnami/mysql/)

# What is MySQL?

> MySQL is a fast, reliable, scalable, and easy to use open-source relational database system. MySQL Server is intended for mission-critical, heavy-load production systems as well as for embedding into mass-deployed software.

[https://mysql.com/](https://mysql.com/)

# TLDR

```bash
docker run --name mysql bitnami/mysql:latest
```

## Docker Compose

```
mysql:
  image: bitnami/mysql:latest
```

# Get this image

The recommended way to get the Bitnami MySQL Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/mysql).

```bash
docker pull bitnami/mysql:latest
```

To use a specific version, you can pull a versioned tag. You can view the
[list of available versions](https://hub.docker.com/r/bitnami/mysql/tags/)
in the Docker Hub Registry.

```bash
docker pull bitnami/mysql:[TAG]
```

If you wish, you can also build the image yourself.

```bash
docker build -t bitnami/mysql:latest https://github.com/bitnami/bitnami-docker-mysql.git
```

# Persisting your database

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

**Note!**
If you have already started using your database, follow the steps on
[backing up](#backing-up-your-container) and [restoring](#restoring-a-backup) to pull the data from your running container down to your host.

The image exposes a volume at `/bitnami/mysql` for the MySQL data and configurations. For persistence you can mount a directory at this location from your host. If the mounted directory is empty, it will be initialized on the first run.

```bash
docker run -v /path/to/mysql-persistence:/bitnami/mysql bitnami/mysql:latest
```

or using Docker Compose:

```
mysql:
  image: bitnami/mysql:latest
  volumes:
    - /path/to/mysql-persistence:/bitnami/mysql
```

# Linking

If you want to connect to your MySQL server inside another container, you can use the linking system provided by Docker.

## Connecting a MySQL client container to the MySQL server container

### Step 1: Run the MySQL image with a specific name

The first step is to start our MySQL server.

Docker's linking system uses container ids or names to reference containers. We can explicitly specify a name for our MySQL server to make it easier to connect to other containers.

```bash
docker run --name mysql bitnami/mysql:latest
```

### Step 2: Run MySQL as a MySQL client and link to our server

Now that we have our MySQL server running, we can create another container that links to it by giving Docker the `--link` option. This option takes the id or name of the container we want to link it to as well as a hostname to use inside the container, separated by a colon. For example, to have our MySQL server accessible in another container with `server` as it's hostname we would pass `--link mysql:server` to the Docker run command.

The Bitnami MySQL Docker Image also ships with a MySQL client. To start the client, we can override the default command Docker runs by stating a different command to run after the image name.

```bash
docker run --rm -it --link mysql:server bitnami/mysql:latest mysql -h server -u root
```

We started the MySQL client passing in the `-h` option that allows us to specify the hostname of the server, which we set to the hostname we created in the link.

**Note!**
You can also run the MySQL client in the same container the server is running in using the Docker [exec](https://docs.docker.com/reference/commandline/cli/#exec) command.

```bash
docker exec -it mysql mysql -u root
```

## Linking with Docker Compose

### Step 1: Add a MySQL entry in your `docker-compose.yml`

Copy the snippet below into your `docker-compose.yml` to add MySQL to your application.

```
mysql:
  image: bitnami/mysql:latest
```

### Step 2: Link it to another container in your application

Update the definitions for containers you want to access your MySQL server from to include a link to the `mysql` entry you added in Step 1.

```
myapp:
  image: myapp
  links:
    - mysql:mysql
```

Inside `myapp`, use `mysql` as the hostname for the MySQL server.

# Configuration

## Setting the root password on first run

Passing the `MARIADB_ROOT_PASSWORD` environment variable when running the image for the first time will set the password of the root user to the value of `MARIADB_ROOT_PASSWORD`.

```bash
docker run --name mysql -e MARIADB_ROOT_PASSWORD=password123 bitnami/mysql:latest
```

or using Docker Compose:

```
mysql:
  image: bitnami/mysql:latest
  environment:
    - MARIADB_ROOT_PASSWORD=password123
```

**Warning** The `root` user is always created with remote access. It's suggested that the `MARIADB_ROOT_PASSWORD` env variable is always specified to set a password for the `root` user.

## Creating a database on first run

By passing the `MARIADB_DATABASE` environment variable when running the image for the first time, a database will be created. This is useful if your application requires that a database already exists, saving you from having to manually create the database using the MySQL client.

```bash
docker run --name mysql -e MARIADB_DATABASE=my_database bitnami/mysql:latest
```

or using Docker Compose:

```
mysql:
  image: bitnami/mysql:latest
  environment:
    - MARIADB_DATABASE=my_database
```

## Creating a database user on first run

You can create a restricted database user that only has permissions for the database created with the [`MARIADB_DATABASE`](#creating-a-database-on-first-run) environment variable. To do this, provide the `MARIADB_USER` environment variable and to set a password for the database user provide the `MARIADB_PASSWORD` variable.

```bash
docker run --name mysql \
  -e MARIADB_USER=my_user -e MARIADB_PASSWORD=my_password \
  -e MARIADB_DATABASE=my_database \
  bitnami/mysql:latest
```

or using Docker Compose:

```
mysql:
  image: bitnami/mysql:latest
  environment:
    - MARIADB_USER=my_user
    - MARIADB_PASSWORD=my_password
    - MARIADB_DATABASE=my_database
```

**Note!** The `root` user will still be created with remote access. Please ensure that you have specified a password for the `root` user using the `MARIADB_ROOT_PASSWORD` env variable.

## Setting up a replication cluster

A **zero downtime** MySQL master-slave [replication](https://dev.mysql.com/doc/refman/5.0/en/replication-howto.html) cluster can easily be setup with the Bitnami MySQL Docker image using the following environment variables:

 - `MARIADB_REPLICATION_MODE`: The replication mode. Possible values `master`/`slave`. No defaults.
 - `MARIADB_REPLICATION_USER`: The replication user created on the master on first run. No defaults.
 - `MARIADB_REPLICATION_PASSWORD`: The replication users password. No defaults.
 - `MARIADB_MASTER_HOST`: Hostname/IP of replication master (slave parameter). No defaults.
 - `MARIABD_MASTER_PORT`: Server port of the replication master (slave parameter). Defaults to `3306`.
 - `MARIADB_MASTER_USER`: User on replication master with access to `MARIADB_DATABASE` (slave parameter). Defaults to `root`
 - `MARIADB_MASTER_PASSWORD`: Password of user on replication master with access to `MARIADB_DATABASE` (slave parameter). No defaults.

In a replication cluster you can have one master and zero or more slaves. When replication is enabled the master node is in read-write mode, while the slaves are in read-only mode. For best performance its advisable to limit the reads to the slaves.

### Step 1: Create the replication master

The first step is to start the MySQL master.

```bash
docker run --name mysql-master \
  -e MARIADB_ROOT_PASSWORD=root_password \
  -e MARIADB_REPLICATION_MODE=master \
  -e MARIADB_REPLICATION_USER=my_repl_user \
  -e MARIADB_REPLICATION_PASSWORD=my_repl_password \
  -e MARIADB_USER=my_user \
  -e MARIADB_PASSWORD=my_password \
  -e MARIADB_DATABASE=my_database \
  bitnami/mysql:latest
```

In the above command the container is configured as the `master` using the `MARIADB_REPLICATION_MODE` parameter. A replication user is specified using the `MARIADB_REPLICATION_USER` and `MARIADB_REPLICATION_PASSWORD` parameters.

### Step 2: Create the replication slave

Next we start a MySQL slave container.

```bash
docker run --name mysql-slave --link mysql-master:master \
  -e MARIADB_ROOT_PASSWORD=root_password \
  -e MARIADB_REPLICATION_MODE=slave \
  -e MARIADB_REPLICATION_USER=my_repl_user \
  -e MARIADB_REPLICATION_PASSWORD=my_repl_password \
  -e MARIADB_MASTER_HOST=master \
  -e MARIADB_MASTER_USER=my_user \
  -e MARIADB_MASTER_PASSWORD=my_password \
  -e MARIADB_USER=my_user \
  -e MARIADB_PASSWORD=my_password \
  -e MARIADB_DATABASE=my_database \
  bitnami/mysql:latest
```

In the above command the container is configured as a `slave` using the `MARIADB_REPLICATION_MODE` parameter. The `MARIADB_MASTER_HOST`, `MARIADB_MASTER_USER` and `MARIADB_MASTER_PASSWORD` parameters are used by the slave to connect to the master and take a dump of the existing data in the database identified by `MARIADB_DATABASE`. The replication user credentials are specified using the `MARIADB_REPLICATION_USER` and `MARIADB_REPLICATION_PASSWORD` parameters and should be the same as the one specified on the master.

> **Note**! The cluster only replicates the database specified in the `MARIADB_DATABASE` parameter.

You now have a two node MySQL master/slave replication cluster up and running. You can scale the cluster by adding/removing slaves without incurring any downtime.

With Docker Compose the master/slave replication can be setup using:

```yaml
master:
  image: bitnami/mysql:latest
  environment:
    - MARIADB_ROOT_PASSWORD=root_password
    - MARIADB_REPLICATION_MODE=master
    - MARIADB_REPLICATION_USER=my_repl_user
    - MARIADB_REPLICATION_PASSWORD=my_repl_password
    - MARIADB_USER=my_user
    - MARIADB_PASSWORD=my_password
    - MARIADB_DATABASE=my_database

slave:
  image: bitnami/mysql:latest
  links:
    - master:master
  environment:
    - MARIADB_ROOT_PASSWORD=root_password
    - MARIADB_REPLICATION_MODE=slave
    - MARIADB_REPLICATION_USER=my_repl_user
    - MARIADB_REPLICATION_PASSWORD=my_repl_password
    - MARIADB_MASTER_HOST=master
    - MARIADB_MASTER_USER=my_user
    - MARIADB_MASTER_PASSWORD=my_password
    - MARIADB_USER=my_user
    - MARIADB_PASSWORD=my_password
    - MARIADB_DATABASE=my_database
```

Scale the number of slaves using:

```bash
docker-compose scale master=1 slave=3
```

The above command scales up the number of slaves to `3`. You can scale down in the same manner.

> **Note**: You should not scale up/down the number of master nodes. Always have only one master node running.

## Configuration file

The image looks for configuration in the `conf/` directory of `/bitnami/mysql`. As as mentioned in [Persisting your database](#persisting-your-data) you can mount a volume at this location and copy your own configurations in the `conf/` directory. The default configuration will be copied to the `conf/` directory if it's empty.

### Step 1: Run the MySQL image

Run the MySQL image, mounting a directory from your host.

```bash
docker run --name mysql -v /path/to/mysql-persistence:/bitnami/mysql bitnami/mysql:latest
```

or using Docker Compose:

```
mysql:
  image: bitnami/mysql:latest
  volumes:
    - /path/to/mysql-persistence:/bitnami/mysql
```

### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```bash
vi /path/to/mysql-persistence/conf/my.cnf
```

### Step 3: Restart MySQL

After changing the configuration, restart your MySQL container for changes to take effect.

```bash
docker restart mysql
```

or using Docker Compose:

```bash
docker-compose restart mysql
```

**Further Reading:**

  - [Server Option and Variable Reference](https://dev.mysql.com/doc/refman/5.1/en/mysqld-option-tables.html)

# Logging

The Bitnami MySQL Docker image sends the container logs to the `stdout`. To view the logs:

```bash
docker logs mysql
```

or using Docker Compose:

```bash
docker-compose logs mysql
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Backing up your container

To backup your data, configuration and logs, follow these simple steps:

### Step 1: Stop the currently running container

```bash
docker stop mysql
```

or using Docker Compose:

```bash
docker-compose stop mysql
```

### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```bash
docker run --rm -v /path/to/mysql-backups:/backups --volumes-from mysql busybox \
  cp -a /bitnami/mysql:latest /backups/latest
```

or using Docker Compose:

```bash
docker run --rm -v /path/to/mysql-backups:/backups --volumes-from `docker-compose ps -q mysql` busybox \
  cp -a /bitnami/mysql:latest /backups/latest
```

## Restoring a backup

Restoring a backup is as simple as mounting the backup as volumes in the container.

```bash
docker run -v /path/to/mysql-backups/latest:/bitnami/mysql bitnami/mysql:latest
```

or using Docker Compose:

```
mysql:
  image: bitnami/mysql:latest
  volumes:
    - /path/to/mysql-backups/latest:/bitnami/mysql
```

## Upgrade this image

Bitnami provides up-to-date versions of MySQL, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
docker pull bitnami/mysql:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/mysql:latest`.

### Step 2: Stop and backup the currently running container

Before continuing, you should backup your container's data, configuration and logs.

Follow the steps on [creating a backup](#backing-up-your-container).

### Step 3: Remove the currently running container

```bash
docker rm -v mysql
```

or using Docker Compose:

```bash
docker-compose rm -v mysql
```

### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if necessary.

```bash
docker run --name mysql bitnami/mysql:latest
```

or using Docker Compose:

```bash
docker-compose start mysql
```

# Testing

This image is tested for expected runtime behavior, using the [Bats](https://github.com/sstephenson/bats) testing framework. You can run the tests on your machine using the `bats` command.

```
bats test.sh
```

# Notable Changes

## 10.1.13-r0

- All volumes have been merged at `/bitnami/mysql`. Now you only need to mount a single volume at `/bitnami/mysql` for persistence.
- The logs are always sent to the `stdout` and are no longer collected in the volume.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-mysql/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-mysql/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-mysql/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright (c) 2015-2016 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
