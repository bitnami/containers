[![Build Status](http://bitnami-container-builds.bitnamiapp.com/jenkins/buildStatus/icon?job=docker-mariadb)](http://bitnami-container-builds.bitnamiapp.com/jenkins/job/docker-mariadb/)

# What is MariaDB?

> MariaDB is a fast, reliable, scalable, and easy to use open-source relational database system.
> MariaDB Server is intended for mission-critical, heavy-load production systems as well as for
> embedding into mass-deployed software.

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
git clone https://github.com/bitnami/bitnami-docker-mariadb.git
cd bitnami-docker-mariadb
docker build -t bitnami/mariadb .
```

# Persisting your database

If you remove the container all your data will be lost, and the next time you run the image the
database will be reinitialized. To avoid this loss of data, you should mount a volume that will
persist even after the container is removed.

**Note!**
If you have already started using your database, follow the steps on
[backing up](#backing-up-your-container) and [restoring](#restoring-a-backup) to pull the data from
your running container down to your host.

The MariaDB image exposes a volume at `/bitnami/mariadb/data`, you can mount a directory from your host to serve as the data store. If the directory you mount is empty, the database will be initialized.

> **Note**
>
> Persistent volumes cannot be shared across container instances.

```bash
docker run -v /path/to/data:/bitnami/mariadb/data bitnami/mariadb
```

or using Docker Compose:

```
mariadb:
  image: bitnami/mariadb
  volumes:
    - /path/to/data:/bitnami/mariadb/data
```

# Linking

If you want to connect to your MariaDB server inside another container, you can use the linking
system provided by Docker.

## Connecting a MySQL client container to the MariaDB server container

### Step 1: Run the MariaDB image with a specific name

The first step is to start our MariaDB server.

Docker's linking system uses container ids or names to reference containers. We can explicitly
specify a name for our MariaDB server to make it easier to connect to other containers.

```bash
docker run --name mariadb bitnami/mariadb
```

### Step 2: Run MariaDB as a MySQL client and link to our server

Now that we have our MariaDB server running, we can create another container that links to it by
giving Docker the `--link` option. This option takes the id or name of the container we want to link
it to as well as a hostname to use inside the container, separated by a colon. For example, to have
our MariaDB server accessible in another container with `server` as it's hostname we would pass
`--link mariadb:server` to the Docker run command.

The Bitnami MariaDB Docker Image also ships with a MySQL client, but by default it will start a
server. To start the client instead, we can override the default command Docker runs by stating a
different command to run after the image name.

```bash
docker run --rm -it --link mariadb:server bitnami/mariadb mysql -h server -u root
```

We started the MySQL client passing in the `-h` option that allows us to specify the hostname of the
server, which we set to the hostname we created in the link.

**Note!**
You can also run the MySQL client in the same container the server is running in using the Docker
[exec](https://docs.docker.com/reference/commandline/cli/#exec) command.

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

Update the definitions for containers you want to access your MariaDB server from to include a link
to the `mariadb` entry you added in Step 1.

```
myapp:
  image: myapp
  links:
    - mariadb:mariadb
```

Inside `myapp`, use `mariadb` as the hostname for the MariaDB server.

# Configuration

## Setting the root password on first run

Passing the `MARIADB_PASSWORD` environment variable when running the image for the first time will
set the password of the root user to the value of `MARIADB_PASSWORD`.

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

## Creating a database on first run

By passing the `MARIADB_DATABASE` environment variable when running the image for the first time, a
database will be created. This is useful if your application requires that a database already
exists, saving you from having to manually create the database using the MySQL client.

```bash
docker run --name mariadb -e MARIADB_DATABASE=my_database bitnami/mariadb
```

or using Docker Compose:

```
mariadb:
  image: bitnami/mariadb
  environment:
    - MARIADB_DATABASE=my_database
```

## Creating a database user on first run

You can create a restricted database user that only has permissions for the database created with
the [`MARIADB_DATABASE`](#creating-a-database-on-first-run) environment variable. To do this,
provide the `MARIADB_USER` environment variable.

**Warning!** In this case, a root user will not be created, and your restricted user will not have
permissions to create a new database.

```bash
docker run --name mariadb -e MARIADB_USER=my_user -e MARIADB_DATABASE=my_database bitnami/mariadb
```

or using Docker Compose:

```
mariadb:
  image: bitnami/mariadb
  environment:
    - MARIADB_USER=my_user
    - MARIADB_DATABASE=my_database
```

**Note!**
When `MARIADB_PASSWORD` is specified along with `MARIADB_USER`, the value specified in `MARIADB_PASSWORD` is set as the password of the newly created user specified in `MARIADB_USER`.

## Setting up a replication cluster

A **zero downtime** MariaDB master-slave [replication](https://dev.mysql.com/doc/refman/5.0/en/replication-howto.html) cluster can easily be setup with the Bitnami MariaDB Docker Image using the following environment variables:

 - `MARIADB_SERVER_ID`: Unique server identifier (default: random number)
 - `MARIADB_REPLICATION_MODE`: Replication mode. Possible values `master`/`slave` (default: none).
 - `MARIADB_REPLICATION_USER`: Replication user. User is created on master on the first boot (default: none).
 - `MARIADB_REPLICATION_PASSWORD`: Replication users password. Password is set for `MARIADB_REPLICATION_USER` on master on the first boot (default: none).
 - `MARIADB_MASTER_HOST`: Hostname/IP of replication master (parameter available only on slave).
 - `MARIADB_MASTER_USER`: User on replication master with access to `MARIADB_DATABASE` (parameter available only on slave).
 - `MARIADB_MASTER_PASSWORD`: Password of user on replication master with access to `MARIADB_DATABASE` (parameter available only on slave).

In a replication cluster you can have one master and zero or more slaves. With replication writes can occur only on the master while reads can take place on both the master or slaves. For best performance you should limit the reads to the slaves and use the master only for the writes.

### Step 1: Create the replication master

The first step is to start the MariaDB master.

```bash
docker run --name mariadb-master \
  -e MARIADB_SERVER_ID=1 \
  -e MARIADB_USER=my_user \
  -e MARIADB_PASSWORD=my_password \
  -e MARIADB_DATABASE=my_database \
  -e MARIADB_REPLICATION_MODE=master \
  -e MARIADB_REPLICATION_USER=my_repl_user \
  -e MARIADB_REPLICATION_PASSWORD=my_repl_password \
  bitnami/mariadb
```

In this command we are configuring the container as the master using the `MARIADB_REPLICATION_MODE=master` parameter. Using the `MARIADB_REPLICATION_USER` and `MARIADB_REPLICATION_PASSWORD` parameters we are creating a replication user that will be used by the slaves to connect to the master and perform the replication.

### Step 2: Create the replication slave

Next we start a MariaDB slave container.

```bash
docker run --name mariadb-slave --link mariadb-master:master \
  -e MARIADB_SERVER_ID=2 \
  -e MARIADB_USER=my_user \
  -e MARIADB_PASSWORD=my_password \
  -e MARIADB_DATABASE=my_database \
  -e MARIADB_REPLICATION_MODE=slave \
  -e MARIADB_REPLICATION_USER=my_repl_user \
  -e MARIADB_REPLICATION_PASSWORD=my_repl_password \
  -e MARIADB_MASTER_HOST=mariadb-master -e MARIADB_MASTER_USER=my_user -e MARIADB_MASTER_PASSWORD=my_password \
  bitnami/mariadb
```

In this command we are configuring the container as a slave using the `MARIADB_REPLICATION_MODE=slave` parameter. Before the replication slave is started, the `MARIADB_MASTER_HOST`, `MARIADB_MASTER_USER` and `MARIADB_MASTER_PASSWORD` parameters are used by the slave container to connect to the master and take a dump of the existing data in the database identified by the `MARIADB_DATABASE` paramater. The `MARIADB_REPLICATION_USER` and `MARIADB_REPLICATION_PASSWORD` credentials are used to read the binary replication logs from the master.

Using the `master` docker link alias, the Bitnami MariaDB Docker image automatically fetches the replication paramaters from the master container, namely:

 - `MARIADB_REPLICATION_USER`
 - `MARIADB_REPLICATION_PASSWORD`
 - `MARIADB_MASTER_HOST`
 - `MARIADB_MASTER_USER`
 - `MARIADB_MASTER_PASSWORD`

Additionally, the following parameters are also fetched in the slave container:

 - `MARIADB_USER`
 - `MARIADB_PASSWORD`
 - `MARIADB_DATABASE`

As a result you can drop all of these parameters from the slave. Since `MARIADB_SERVER_ID` is assigned a random identifier we can drop it as well:

```bash
docker run --name mariadb-slave --link mariadb-master:master \
  -e MARIADB_REPLICATION_MODE=slave \
  bitnami/mariadb
```

With these two commands you now have a two node MariaDB master-slave replication cluster up and running. When required you can add more slaves to the cluster without any downtime allowing you to scale the cluster horizontally.

> **Note**:
>
>  The cluster only replicates the database specified in the `MARIADB_DATABASE` parameter.

With Docker Compose the master-slave replication can be setup using:

```yaml
master:
  image: bitnami/mariadb
  environment:
    - MARIADB_USER=my_user
    - MARIADB_PASSWORD=my_password
    - MARIADB_DATABASE=my_database
    - MARIADB_REPLICATION_MODE=master
    - MARIADB_REPLICATION_USER=my_repl_user
    - MARIADB_REPLICATION_PASSWORD=my_repl_password

slave:
  image: bitnami/mariadb
  links:
    - master:master
  environment:
    - MARIADB_REPLICATION_MODE=slave
```

Scale the number of slaves using:

```bash
docker-compose scale master=1 slave=3
```

The above command scales up the number of slaves to `3`. You can scale down in the same way.

> **Note**: You should not scale up/down the number of master nodes. Always have only one master node running.

## Command-line options

The simplest way to configure your MariaDB server is to pass custom command-line options when
running the image.

```bash
docker run bitnami/mariadb --open-files-limit=2
```

or using Docker Compose:

```
mariadb:
  image: bitnami/mariadb
  command: --open-files-limit=2
```

**Further Reading:**

  - [MySQL Server Command Options](https://dev.mysql.com/doc/refman/5.1/en/server-options.html)
  - [Caveats](#caveats)

## Configuration file

This image looks for configuration in `/bitnami/mariadb/conf`. You can mount a volume there with
your own configuration, or the default configuration will be copied to your volume if it is empty.

### Step 1: Run the MariaDB image

Run the MariaDB image, mounting a directory from your host.

```bash
docker run --name mariadb -v /path/to/mariadb/conf:/bitnami/mariadb/conf bitnami/mariadb
```

or using Docker Compose:

```
mariadb:
  image: bitnami/mariadb
  volumes:
    - /path/to/mariadb/conf:/bitnami/mariadb/conf
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
  - [Caveats](#caveats)

## Caveats

The following options cannot be modified, to ensure that the image runs correctly.

```bash
--defaults-file=/opt/bitnami/mysql/my.cnf
--log-error=/opt/bitnami/mysql/logs/mysqld.log
--basedir=/opt/bitnami/mysql
--datadir=/opt/bitnami/mysql/data
--plugin-dir=/opt/bitnami/mysql/lib/plugin
--user=mysql
--socket=/opt/bitnami/mysql/tmp/mysql.sock
```

# Logging

The Bitnami MariaDB Docker Image supports two different logging modes: logging to stdout, and
logging to a file.

## Logging to stdout

The default behavior is to log to stdout, as Docker expects. These will be collected by Docker,
converted to JSON and stored in the host, to be accessible via the `docker logs` command.

```bash
docker logs mariadb
```

or using Docker Compose:

```bash
docker-compose logs mariadb
```

This method of logging has the downside of not being easy to manage. Without an easy way to rotate
logs, they could grow exponentially and take up large amounts of disk space on your host.

## Logging to file

To log to file, run the MariaDB image, mounting a directory from your host at
`/bitnami/mariadb/logs`. This will instruct the container to send logs to a `mysqld.log` file in the
mounted volume.

```bash
docker run --name mariadb -v /path/to/mariadb/logs:/bitnami/mariadb/logs bitnami/mariadb
```

or using Docker Compose:

```
mariadb:
  image: bitnami/mariadb
  volumes:
    - /path/to/mariadb/logs:/bitnami/mariadb/logs
```

To perform operations (e.g. logrotate) on the logs, mount the same directory in a container designed
to operate on log files, such as logstash.

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

We need to mount two volumes in a container we will use to create the backup: a directory on your
host to store the backup in, and the volumes from the container we just stopped so we can access the
data.

```bash
docker run --rm -v /path/to/backups:/backups --volumes-from mariadb busybox \
  cp -a /bitnami/mariadb /backups/latest
```

or using Docker Compose:

```bash
docker run --rm -v /path/to/backups:/backups --volumes-from `docker-compose ps -q mariadb` busybox \
  cp -a /bitnami/mariadb /backups/latest
```

**Note!**
If you only need to backup database data, or configuration, you can change the first argument to
`cp` to `/bitnami/mariadb/data` or `/bitnami/mariadb/conf` respectively.

## Restoring a backup

Restoring a backup is as simple as mounting the backup as volumes in the container.

```bash
docker run -v /path/to/backups/latest/data:/bitnami/mariadb/data \
  -v /path/to/backups/latest/conf:/bitnami/mariadb/conf \
  -v /path/to/backups/latest/logs:/bitnami/mariadb/logs \
  bitnami/mariadb
```

or using Docker Compose:

```
mariadb:
  image: bitnami/mariadb
  volumes:
    - /path/to/backups/latest/data:/bitnami/mariadb/data
    - /path/to/backups/latest/conf:/bitnami/mariadb/conf
    - /path/to/backups/latest/logs:/bitnami/mariadb/logs
```

## Upgrade this image

Bitnami provides up-to-date versions of MariaDB, including security patches, soon after they are
made upstream. We recommend that you follow these steps to upgrade your container.

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

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if
necessary.

```bash
docker run --name mariadb bitnami/mariadb:latest
```

or using Docker Compose:

```bash
docker-compose start mariadb
```

# Testing

This image is tested for expected runtime behavior, using the
[Bats](https://github.com/sstephenson/bats) testing framework. You can run the tests on your machine
using the `bats` command.

```
bats test.sh
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an
[issue](https://github.com/bitnami/bitnami-docker-mariadb/issues), or submit a
[pull request](https://github.com/bitnami/bitnami-docker-mariadb/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an
[issue](https://github.com/bitnami/bitnami-docker-mariadb/issues). For us to provide better support,
be sure to include the following information in your issue:

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
