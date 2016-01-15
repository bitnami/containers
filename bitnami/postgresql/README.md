[![Build Status](http://bitnami-container-builds.bitnamiapp.com/jenkins/buildStatus/icon?job=docker-postgresql)](http://bitnami-container-builds.bitnamiapp.com/jenkins/job/docker-postgresql/)

# What is PostgreSQL?

> [PostgreSQL](http://www.postgresql.org) is an object-relational database management system (ORDBMS) with an emphasis on extensibility and on standards-compliance [[source]](https://en.wikipedia.org/wiki/PostgreSQL).

# TLDR

```bash
docker run --name postgresql -e POSTGRES_PASSWORD=password123 bitnami/postgresql
```

## Docker Compose

```
postgresql:
  image: bitnami/postgresql
  environment:
    - POSTGRES_PASSWORD=password123
```

# Get this image

The recommended way to get the Bitnami PostgreSQL Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/postgresql).

```bash
docker pull bitnami/postgresql:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/postgresql/tags/) in the Docker Hub Registry.

```bash
docker pull bitnami/postgresql:[TAG]
```

If you wish, you can also build the image yourself.

```bash
git clone https://github.com/bitnami/bitnami-docker-postgresql.git
cd bitnami-docker-postgresql
docker build -t bitnami/postgresql .
```

# Persisting your database

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

**Note!**
If you have already started using your database, follow the steps on [backing up](#backing-up-your-container) and [restoring](#restoring-a-backup) to pull the data from your running container down to your host.

The PostgreSQL image exposes a volume at `/bitnami/postgresql/data`, you can mount a directory from your host to serve as the data store. If the directory you mount is empty, the database will be initialized.

```bash
docker run -v /path/to/data:/bitnami/postgresql/data bitnami/postgresql
```

or using Docker Compose:

```
postgresql:
  image: bitnami/postgresql
  volumes:
    - /path/to/data:/bitnami/postgresql/data
```

# Linking

If you want to connect to your PostgreSQL server inside another container, you can use the linking system provided by Docker.

## Connecting a PostgreSQL client container to the PostgreSQL server container

### Step 1: Run the PostgreSQL image with a specific name

The first step is to start our PostgreSQL server.

Docker's linking system uses container ids or names to reference containers. We can explicitly specify a name for our PostgreSQL server to make it easier to connect to other containers.

```bash
docker run --name postgresql -e POSTGRES_PASSWORD=password123 bitnami/postgresql
```

### Step 2: Run PostgreSQL image as a client and link to our server

Now that we have our PostgreSQL server running, we can create another container that links to it by giving Docker the `--link` option. This option takes the id or name of the container we want to link it to as well as a hostname to use inside the container, separated by a colon. For example, to have our PostgreSQL server accessible in another container with `server` as it's hostname we would pass `--link postgresql:server` to the Docker run command.

The Bitnami PostgreSQL Docker Image also ships with a PostgreSQL client, but by default it will start a server. To start the client instead, we can override the default command Docker runs by stating a different command to run after the image name.

```bash
docker run --rm -it --link postgresql:server bitnami/postgresql psql -h server -U postgres
```

We started the PostgreSQL client passing in the `-h` option that allows us to specify the hostname of the server, which we set to the hostname we created in the link.

**Note!**
You can also run the PostgreSQL client in the same container the server is running in using the Docker [exec](https://docs.docker.com/reference/commandline/cli/#exec) command.

```bash
docker exec -it postgresql psql -U postgres
```

## Linking with Docker Compose

### Step 1: Add a PostgreSQL entry in your `docker-compose.yml`

Copy the snippet below into your `docker-compose.yml` to add PostgreSQL to your application.

```
postgresql:
  image: bitnami/postgresql
  environment:
    - POSTGRES_PASSWORD=password123
```

### Step 2: Link it to another container in your application

Update the definitions for containers you want to access your PostgreSQL server from to include a link to the `postgresql` entry you added in Step 1.

```
myapp:
  image: myapp
  links:
    - postgresql:postgresql
```

Inside `myapp`, use `postgresql` as the hostname for the PostgreSQL server.

# Configuration

## Setting the root password on first run

In the above commands you may have noticed the use of the `POSTGRES_PASSWORD` environment variable. Passing the `POSTGRES_PASSWORD` environment variable when running the image for the first time will set the password of the `postgres` user to the value of `POSTGRES_PASSWORD`.

```bash
docker run --name postgresql -e POSTGRES_PASSWORD=password123 bitnami/postgresql
```

or using Docker Compose:

```
postgresql:
  image: bitnami/postgresql
  environment:
    - POSTGRES_PASSWORD=password123
```

**Note!**
The `postgres` user is a superuser and has full administrative access to the PostgreSQL database.

## Creating a database on first run

By passing the `POSTGRES_DB` environment variable when running the image for the first time, a database will be created. This is useful if your application requires that a database already exists, saving you from having to manually create the database using the PostgreSQL client.

```bash
docker run --name postgresql -e POSTGRES_DB=my_database bitnami/postgresql
```

or using Docker Compose:

```
postgresql:
  image: bitnami/postgresql
  environment:
    - POSTGRES_DB=my_database
```

## Creating a database user on first run

You can also create a restricted database user that only has permissions for the database created with the [`POSTGRES_DB`](#creating-a-database-on-first-run) environment variable. To do this, provide the `POSTGRES_USER` environment variable.

```bash
docker run --name postgresql -e POSTGRES_USER=my_user -e POSTGRES_PASSWORD=password123 -e POSTGRES_DB=my_database bitnami/postgresql
```

or using Docker Compose:

```
postgresql:
  image: bitnami/postgresql
  environment:
    - POSTGRES_USER=my_user
    - POSTGRES_PASSWORD=password123
    - POSTGRES_DB=my_database
```

**Note!**
When `POSTGRES_USER` is specified, the `postgres` user is not assigned a password and as a result you cannot login remotely to the PostgreSQL server as the `postgres` user.

## Setting up a streaming replication

A [Streaming replication](http://www.postgresql.org/docs/9.4/static/warm-standby.html#STREAMING-REPLICATION) cluster can easily be setup with the Bitnami PostgreSQL Docker Image using the following environment variables:

 - `POSTGRES_MODE`: Replication mode. Possible values `master`/`slave` (default: master).
 - `POSTGRES_REPLICATION_USER`: Replication user. User is created on the master at first boot (default: none).
 - `POSTGRES_REPLICATION_PASSWORD`: Replication users password. Password is set for `POSTGRES_REPLICATION_USER` on master on the first boot (default: none).
 - `POSTGRES_MASTER_HOST`: Hostname/IP of replication master (parameter available only on slave).
 - `POSTGRES_MASTER_PORT`: Port of replication master, defaults to `5432` (parameter available only on slave).

In a replication cluster you can have one master and zero or more slaves. Our default configuration allows a maximum of 16 slaves, you can change it in `postgresql.conf` if required.

When replication is enabled writes can occur only on the master while reads can take place on both the master or slaves. For best performance you should limit the reads to the slaves and use the master only for the writes.

### Step 1: Create the replication master

The first step is to start the master.

```bash
docker run --name postgresql-master \
  -e POSTGRES_MODE=master \
  -e POSTGRES_USER=my_user \
  -e POSTGRES_PASSWORD=password123 \
  -e POSTGRES_DB=my_database \
  -e POSTGRES_REPLICATION_USER=my_repl_user \
  -e POSTGRES_REPLICATION_PASSWORD=my_repl_password \
  bitnami/postgresql
```

In this command we are configuring the container as the master using the `POSTGRES_MODE=master` parameter. Using the `POSTGRES_REPLICATION_USER` and `POSTGRES_REPLICATION_PASSWORD` parameters we are creating a replication user that will be used by the slaves to connect to the master and perform streaming replication.

By default a container is configured as a `master`. As a result you can drop the `POSTGRES_MODE=master` from the above command.

### Step 2: Create the replication slave

Next we start a replication slave container.

```bash
docker run --name postgresql-slave \
  --link postgresql-master:master \
  -e POSTGRES_MODE=slave \
  -e POSTGRES_MASTER_HOST=master \
  -e POSTGRES_MASTER_PORT=5432 \
  -e POSTGRES_REPLICATION_USER=my_repl_user \
  -e POSTGRES_REPLICATION_PASSWORD=my_repl_password \
  bitnami/postgresql
```

In this command we are configuring the container as a slave using the `POSTGRES_MODE=slave` parameter. Before the replication slave is started, the `POSTGRES_MASTER_HOST` and `POSTGRES_MASTER_PORT` parameters are used by the slave container to connect to the master and replicate the initial database from the master. The `POSTGRES_REPLICATION_USER` and `POSTGRES_REPLICATION_PASSWORD` credentials are used to authenticate with the master.

Using the `master` docker link alias, the Bitnami PostgreSQL Docker image automatically fetches the replication paramaters from the master container, namely:

 - `POSTGRES_MASTER_HOST`
 - `POSTGRES_MASTER_PORT`
 - `POSTGRES_REPLICATION_USER`
 - `POSTGRES_REPLICATION_PASSWORD`

As a result you can drop all of these parameters from the slave.

```bash
docker run --name postgresql-slave \
  --link postgresql-master:master \
  -e POSTGRES_MODE=slave \
  bitnami/postgresql
```

With these two commands you now have a two node PostgreSQL master-slave streaming replication cluster up and running. When required you can add more slaves to the cluster without any downtime allowing you to scale the cluster horizontally.

> **Note**: The cluster replicates the master in its entirety, which includes all users and databases.

If the master goes down you can reconfigure a slave to act as the master and begin accepting writes by creating the trigger file `/tmp/postgresql.trigger.5432`. For example the following command reconfigures `postgresql-slave` to act as the master:

```bash
docker exec postgresql-slave touch /tmp/postgresql.trigger.5432
```

> **Note**: The configuration of the other slaves in the cluster needs to be updated so that they are aware of the new master. This would require you to restart the other slaves with `--link postgresql-slave:master` as per our examples.

With Docker Compose the master-slave replication can be setup using:

```yaml
master:
  image: bitnami/postgresql
  environment:
    - POSTGRES_MODE=master
    - POSTGRES_USER=my_user
    - POSTGRES_PASSWORD=password123
    - POSTGRES_DB=my_database
    - POSTGRES_REPLICATION_USER=my_repl_user
    - POSTGRES_REPLICATION_PASSWORD=my_repl_password

slave:
  image: bitnami/postgresql
  links:
    - master:master
  environment:
    - POSTGRES_MODE=slave
```

Scale the number of slaves using:

```bash
docker-compose scale master=1 slave=3
```

The above command scales up the number of slaves to `3`. You can scale down in the same way.

> **Note**: You should not scale up/down the number of master nodes. Always have only one master node running.

## Command-line options

The simplest way to configure your PostgreSQL server is to pass custom command-line options when running the image.

```bash
docker run bitnami/postgresql -N 1000
```

or using Docker Compose:

```
postgresql:
  image: bitnami/postgresql
  command: -N 1000
```

**Further Reading:**

  - [Server Command Options](http://www.postgresql.org/docs/9.4/static/app-postgres.html)
  - [Caveats](#caveats)

## Configuration file

This image looks for configuration in `/bitnami/postgresql/conf`. You can mount a volume there with your own configuration, or the default configuration will be copied to your volume if it is empty.

### Step 1: Run the PostgreSQL image

Run the PostgreSQL image, mounting a directory from your host.

```bash
docker run --name postgresql -v /path/to/postgresql/conf:/bitnami/postgresql/conf bitnami/postgresql
```

or using Docker Compose:

```
postgresql:
  image: bitnami/postgresql
  volumes:
    - /path/to/postgresql/conf:/bitnami/postgresql/conf
```

### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```bash
vi /path/to/postgresql/conf/my.cnf
```

### Step 3: Restart PostgreSQL

After changing the configuration, restart your PostgreSQL container for changes to take effect.

```bash
docker restart postgresql
```

or using Docker Compose:

```bash
docker-compose restart postgresql
```

**Further Reading:**

  - [Server Configuration](http://www.postgresql.org/docs/9.4/static/runtime-config.html)
  - [Caveats](#caveats)

## Caveats

The following options cannot be modified, to ensure that the image runs correctly.

```bash
-D /opt/bitnami/postgresql/data
--config_file=/opt/bitnami/postgresql/conf/postgresql.conf
--hba_file=/opt/bitnami/postgresql/conf/pg_hba.conf
--ident_file=/opt/bitnami/postgresql/conf/pg_ident.conf
```

# Logging

The Bitnami PostgreSQL Docker Image supports two different logging modes: logging to stdout, and logging to a file.

## Logging to stdout

The default behavior is to log to stdout, as Docker expects. These will be collected by Docker, converted to JSON and stored in the host, to be accessible via the `docker logs` command.

```bash
docker logs postgresql
```

or using Docker Compose:

```bash
docker-compose logs postgresql
```

This method of logging has the downside of not being easy to manage. Without an easy way to rotate logs, they could grow exponentially and take up large amounts of disk space on your host.

## Logging to file

To log to file, run the PostgreSQL image, mounting a directory from your host at `/bitnami/postgresql/logs`. This will instruct the container to send logs to a `postgresql.log` file in the mounted volume.

```bash
docker run --name postgresql -v /path/to/postgresql/logs:/bitnami/postgresql/logs bitnami/postgresql
```

or using Docker Compose:

```
postgresql:
  image: bitnami/postgresql
  volumes:
    - /path/to/postgresql/logs:/bitnami/postgresql/logs
```

To perform operations (e.g. logrotate) on the logs, mount the same directory in a container designed to operate on log files, such as logstash.

# Maintenance

## Backing up your container

To backup your data, configuration and logs, follow these simple steps:

### Step 1: Stop the currently running container

```bash
docker stop postgresql
```

or using Docker Compose:

```bash
docker-compose stop postgresql
```

### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```bash
docker run --rm -v /path/to/backups:/backups --volumes-from postgresql busybox \
  cp -a /bitnami/postgresql /backups/latest
```

or using Docker Compose:

```bash
docker run --rm -v /path/to/backups:/backups --volumes-from `docker-compose ps -q postgresql` busybox \
  cp -a /bitnami/postgresql /backups/latest
```

**Note!**
If you only need to backup database data, or configuration, you can change the first argument to `cp` to `/bitnami/postgresql/data` or `/bitnami/postgresql/conf` respectively.

## Restoring a backup

Restoring a backup is as simple as mounting the backup as volumes in the container.

```bash
docker run -v /path/to/backups/latest/data:/bitnami/postgresql/data \
  -v /path/to/backups/latest/conf:/bitnami/postgresql/conf \
  -v /path/to/backups/latest/logs:/bitnami/postgresql/logs \
  bitnami/postgresql
```

or using Docker Compose:

```
postgresql:
  image: bitnami/postgresql
  volumes:
    - /path/to/backups/latest/data:/bitnami/postgresql/data
    - /path/to/backups/latest/conf:/bitnami/postgresql/conf
    - /path/to/backups/latest/logs:/bitnami/postgresql/logs
```

## Upgrade this image

Bitnami provides up-to-date versions of PostgreSQL, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
docker pull bitnami/postgresql:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/postgresql:latest`.

### Step 2: Stop and backup the currently running container

Before continuing, you should backup your container's data, configuration and logs.

Follow the steps on [creating a backup](#backing-up-your-container).

### Step 3: Remove the currently running container

```bash
docker rm -v postgresql
```

or using Docker Compose:

```bash
docker-compose rm -v postgresql
```

### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if necessary.

```bash
docker run --name postgresql bitnami/postgresql:latest
```

or using Docker Compose:

```bash
docker-compose start postgresql
```

# Testing

This image is tested for expected runtime behavior, using the [BATS](https://github.com/sstephenson/bats) testing framework. You can run the tests on your machine using the `bats` command.

```bash
bats test.sh
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-postgresql/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-postgresql/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-postgresql/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_APP_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive
information)

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
