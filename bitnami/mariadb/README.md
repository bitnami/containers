[![Build Status](http://bitnami-container-builds.bitnamiapp.com/jenkins/buildStatus/icon?job=docker-mariadb)](http://bitnami-container-builds.bitnamiapp.com/jenkins/job/docker-mariadb/)

# What is MariaDB?

> MariaDB is a fast, reliable, scalable, and easy to use open-source relational database system. MariaDB Server is intended for mission-critical, heavy-load production systems as well as for embedding into mass-deployed software.

[https://mariadb.com/](https://mariadb.com/)

# TLDR

```bash
docker run --name mariadb bitnami/mariadb
```

## Docker Compose

```
mariadb:
  image: bitnami/mariadb
```

# Get this image

The recommended way to get the Bitnami MariaDB Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/mariadb).

```bash
docker pull bitnami/mariadb:latest
```

To use a specific version, you can pull a versioned tag. You can view the
[list of available versions](https://hub.docker.com/r/bitnami/mariadb/tags/)
in the Docker Hub Registry.

```bash
docker pull bitnami/mariadb:[TAG]
```

If you wish, you can also build the image yourself.

```bash
docker build -t bitnami/mariadb https://github.com/bitnami/bitnami-docker-mariadb.git
```

# Persisting your database

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

**Note!**
If you have already started using your database, follow the steps on
[backing up](#backing-up-your-container) and [restoring](#restoring-a-backup) to pull the data from your running container down to your host.

The image exposes a volume at `/bitnami/mariadb` for the MariaDB data and configurations. For persistence you can mount a directory at this location from your host. If the mounted directory is empty, it will be initialized on the first run.

```bash
docker run -v /path/to/persistent/storage:/bitnami/mariadb bitnami/mariadb
```

or using Docker Compose:

```
mariadb:
  image: bitnami/mariadb
  volumes:
    - /path/to/persistent/storage:/bitnami/mariadb
```

# Linking

If you want to connect to your MariaDB server inside another container, you can use the linking system provided by Docker.

## Connecting a MySQL client container to the MariaDB server container

### Step 1: Run the MariaDB image with a specific name

The first step is to start our MariaDB server.

Docker's linking system uses container ids or names to reference containers. We can explicitly specify a name for our MariaDB server to make it easier to connect to other containers.

```bash
docker run --name mariadb bitnami/mariadb
```

### Step 2: Run MariaDB as a MySQL client and link to our server

Now that we have our MariaDB server running, we can create another container that links to it by giving Docker the `--link` option. This option takes the id or name of the container we want to link it to as well as a hostname to use inside the container, separated by a colon. For example, to have our MariaDB server accessible in another container with `server` as it's hostname we would pass `--link mariadb:server` to the Docker run command.

The Bitnami MariaDB Docker Image also ships with a MySQL client. To start the client, we can override the default command Docker runs by stating a different command to run after the image name.

```bash
docker run --rm -it --link mariadb:server bitnami/mariadb mysql -h server -u root
```

We started the MySQL client passing in the `-h` option that allows us to specify the hostname of the server, which we set to the hostname we created in the link.

**Note!**
You can also run the MySQL client in the same container the server is running in using the Docker [exec](https://docs.docker.com/reference/commandline/cli/#exec) command.

```bash
docker exec -it mariadb mysql -u root
```

## Linking with Docker Compose

### Step 1: Add a MariaDB entry in your `docker-compose.yml`

Copy the snippet below into your `docker-compose.yml` to add MariaDB to your application.

```
mariadb:
  image: bitnami/mariadb
```

### Step 2: Link it to another container in your application

Update the definitions for containers you want to access your MariaDB server from to include a link to the `mariadb` entry you added in Step 1.

```
myapp:
  image: myapp
  links:
    - mariadb:mariadb
```

Inside `myapp`, use `mariadb` as the hostname for the MariaDB server.

# Configuration

## Setting the root password on first run

Passing the `MARIADB_PASSWORD` environment variable when running the image for the first time will set the password of the root user to the value of `MARIADB_PASSWORD`.

```bash
docker run --name mariadb -e MARIADB_PASSWORD=password123 bitnami/mariadb
```

or using Docker Compose:

```
mariadb:
  image: bitnami/mariadb
  environment:
    - MARIADB_PASSWORD=password123
```

## Configuration file

The image looks for configuration in the `conf/` directory of `/bitnami/mariadb`. As as mentioned in [Persisting your database](#persisting-your-data) you can mount a volume at this location and copy your own configurations in the `conf/` directory. The default configuration will be copied to the `conf/` directory if it's empty.

### Step 1: Run the MariaDB image

Run the MariaDB image, mounting a directory from your host.

```bash
docker run --name mariadb -v /path/to/mariadb:/bitnami/mariadb bitnami/mariadb
```

or using Docker Compose:

```
mariadb:
  image: bitnami/mariadb
  volumes:
    - /path/to/mariadb:/bitnami/mariadb
```

### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```bash
vi /path/to/mariadb/conf/my.cnf
```

### Step 3: Restart MariaDB

After changing the configuration, restart your MariaDB container for changes to take effect.

```bash
docker restart mariadb
```

or using Docker Compose:

```bash
docker-compose restart mariadb
```

**Further Reading:**

  - [Server Option and Variable Reference](https://dev.mysql.com/doc/refman/5.1/en/mysqld-option-tables.html)

# Logging

The Bitnami MariaDB Docker Image sends the container logs to the `stdout`. You can configure the containers [logging driver](https://docs.docker.com/engine/reference/run/#logging-drivers-log-driver) using the `--log-driver` option. In the default configuration docker uses the `json-file` driver.

To view the logs:

```bash
docker logs mariadb
```

or using Docker Compose:

```bash
docker-compose logs mariadb
```

*The `docker logs` command is only available if the `json-file` or `journald` logging driver is in use.*

# Maintenance

## Backing up your container

To backup your data, configuration and logs, follow these simple steps:

### Step 1: Stop the currently running container

```bash
docker stop mariadb
```

or using Docker Compose:

```bash
docker-compose stop mariadb
```

### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```bash
docker run --rm -v /path/to/backups:/backups --volumes-from mariadb busybox \
  cp -a /bitnami/mariadb /backups/latest
```

or using Docker Compose:

```bash
docker run --rm -v /path/to/backups:/backups --volumes-from `docker-compose ps -q mariadb` busybox \
  cp -a /bitnami/mariadb /backups/latest
```

## Restoring a backup

Restoring a backup is as simple as mounting the backup as volumes in the container.

```bash
docker run -v /path/to/backups/latest:/bitnami/mariadb bitnami/mariadb
```

or using Docker Compose:

```
mariadb:
  image: bitnami/mariadb
  volumes:
    - /path/to/backups/latest:/bitnami/mariadb
```

## Upgrade this image

Bitnami provides up-to-date versions of MariaDB, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
docker pull bitnami/mariadb:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/mariadb:latest`.

### Step 2: Stop and backup the currently running container

Before continuing, you should backup your container's data, configuration and logs.

Follow the steps on [creating a backup](#backing-up-your-container).

### Step 3: Remove the currently running container

```bash
docker rm -v mariadb
```

or using Docker Compose:

```bash
docker-compose rm -v mariadb
```

### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if necessary.

```bash
docker run --name mariadb bitnami/mariadb:latest
```

or using Docker Compose:

```bash
docker-compose start mariadb
```

# Testing

This image is tested for expected runtime behavior, using the [Bats](https://github.com/sstephenson/bats) testing framework. You can run the tests on your machine using the `bats` command.

```
bats test.sh
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-mariadb/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-mariadb/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-mariadb/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_APP_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright 2015 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
