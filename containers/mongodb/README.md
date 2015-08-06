[![Build Status](http://bitnami-container-builds.bitnamiapp.com/jenkins/buildStatus/icon?job=docker-mongodb)](http://bitnami-container-builds.bitnamiapp.com/jenkins/job/docker-mongodb/)

# What is MongoDB?

> [MongoDB](https://www.mongodb.org/) is a cross-platform document-oriented database. Classified as a NoSQL database, MongoDB eschews the traditional table-based relational database structure in favor of JSON-like documents with dynamic schemas, making the integration of data in certain types of applications easier and faster.

# TLDR

```bash
docker run --name mongodb bitnami/mongodb
```

## Docker Compose

```
mongodb:
  image: bitnami/mongodb
```

# Get this image

The recommended way to get the Bitnami MongoDB Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/u/bitnami/mongodb).

```bash
docker pull bitnami/mongodb:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://registry.hub.docker.com/u/bitnami/mongodb/tags/manage/) in the Docker Hub Registry.

```bash
docker pull bitnami/mongodb:[TAG]
```

If you wish, you can also build the image yourself.

```bash
git clone https://github.com/bitnami/bitnami-docker-mongodb.git
cd bitnami-docker-mongodb
docker build -t bitnami/mongodb .
```

# Persisting your database

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

**Note!**
If you have already started using your database, follow the steps on [backing up](#backing-up-your-container) and [restoring](#restoring-a-backup) to pull the data from your running container down to your host.

The MongoDB image exposes a volume at `/bitnami/mongodb/data`, you can mount a directory from your host to serve as the data store. If the directory you mount is empty, the database will be initialized.

```bash
docker run -v /path/to/data:/bitnami/mongodb/data bitnami/mongodb
```

or using Docker Compose:

```
mongodb:
  image: bitnami/mongodb
  volumes:
    - /path/to/data:/bitnami/mongodb/data
```

# Linking

If you want to connect to your MongoDB server inside another container, you can use the linking system provided by Docker.

## Connecting a Mongo client container to the MongoDB server container

### Step 1: Run the MongoDB image with a specific name

The first step is to start our MongoDB server.

Docker's linking system uses container ids or names to reference containers. We can explicitly specify a name for our MongoDB server to make it easier to connect to other containers.

```bash
docker run --name mongodb bitnami/mongodb
```

### Step 2: Run MongoDB as a Mongo client and link to our server

Now that we have our MongoDB server running, we can create another container that links to it by giving Docker the `--link` option. This option takes the id or name of the container we want to link it to as well as a hostname to use inside the container, separated by a colon. For example, to have our MongoDB server accessible in another container with `server` as it's hostname we would pass `--link mongodb:server` to the Docker run command.

The Bitnami MongoDB Docker Image also ships with a Mongo client, but by default it will start a server. To start the client instead, we can override the default command Docker runs by stating a different command to run after the image name.

```bash
docker run --rm -it --link mongodb:server bitnami/mongodb mongo --host server
```

We started the Mongo client passing in the `--host` option that allows us to specify the hostname of the server, which we set to the hostname we created in the link.

**Note!**
You can also run the Mongo client in the same container the server is running in using the Docker [exec](https://docs.docker.com/reference/commandline/cli/#exec) command.

```bash
docker exec -it mongodb mongo
```

## Linking with Docker Compose

### Step 1: Add a MongoDB entry in your `docker-compose.yml`

Copy the snippet below into your `docker-compose.yml` to add MongoDB to your application.

```
mongodb:
  image: bitnami/mongodb
```

### Step 2: Link it to another container in your application

Update the definitions for containers you want to access your MongoDB server from to include a link to the `mongodb` entry you added in Step 1.

```
myapp:
  image: myapp
  links:
    - mongodb:mongodb
```

Inside `myapp`, use `mongodb` as the hostname for the MongoDB server.

# Configuration

## Setting the root password on first run

Passing the `MONGODB_PASSWORD` environment variable when running the image for the first time will set the password of the root user to the value of `MONGODB_PASSWORD`.

```bash
docker run --name mongodb -e MONGODB_PASSWORD=password123 bitnami/mongodb
```

or using Docker Compose:

```
mongodb:
  image: bitnami/mongodb
  environment:
    - MONGODB_PASSWORD=password123
```

The `root` user is configured to have full administrative access to the MongoDB server. When `MONGODB_PASSWORD` is not specified the server allows unauthenticated and unrestricted access.

**Note!**
The `MONGODB_PASSWORD` enables authentication on the MongoDB server at runtime. Ensure that this parameter is **always** specified to ensure that authentication is enabled each time the container is started.

## Creating a user and database on first run

You can create a user with restricted access to a database while starting the container for the first time. To do this, provide the `MONGODB_USER`, `MONGO_PASSWORD` and `MONGODB_DATABASE` environment variables.

**Warning!** In this case, a root user will not be created, and your restricted user will not have permissions to create a new database.

```bash
docker run --name mongodb -e MONGODB_USER=my_user -e MONGODB_PASSWORD=password123 -e MONGODB_DATABASE=my_database bitnami/mongodb
```

or using Docker Compose:

```
mongodb:
  image: bitnami/mongodb
  environment:
    - MONGODB_USER=my_user
    - MONGODB_PASSWORD=password123
    - MONGODB_DATABASE=my_database
```

**Note!**
When `MONGODB_PASSWORD` is specified along with `MONGODB_USER`, the value specified in `MONGODB_PASSWORD` is set as the password of the newly created user specified in `MONGODB_USER`.

## Command-line options

The simplest way to configure your MongoDB server is to pass custom command-line options when running the image.

```bash
docker run -it --rm bitnami/mongodb --maxConns=1000
```

or using Docker Compose:

```
mongodb:
  image: bitnami/mongodb
  command: --maxConns=1000
```

**Further Reading:**

  - [MongoDB Server Command Options](http://docs.mongodb.org/manual/reference/program/mongod/)
  - [MongoDB Server Parameters](http://docs.mongodb.org/manual/reference/parameters/#mongodb-server-parameters)
  - [Caveats](#caveats)

## Configuration file

This image looks for the configuration in `/bitnami/mongodb/conf`. You can mount a volume there with your own configuration, or the default configuration will be copied to your volume if it is empty.

### Step 1: Run the MongoDB image

Run the MongoDB image, mounting a directory from your host.

```bash
docker run --name mongodb -v /path/to/mongodb/conf:/bitnami/mongodb/conf bitnami/mongodb
```

or using Docker Compose:

```
mongodb:
  image: bitnami/mongodb
  volumes:
    - /path/to/mongodb/conf:/bitnami/mongodb/conf
```

### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```bash
vi /path/to/mongodb/conf/mongodb.conf
```

### Step 3: Restart MongoDB

After changing the configuration, restart your MongoDB container for changes to take effect.

```bash
docker restart mongodb
```

or using Docker Compose:

```bash
docker-compose restart mongodb
```

**Further Reading:**

  - [Configuration File Options](http://docs.mongodb.org/v2.4/reference/configuration-options/)
  - [Caveats](#caveats)

## Caveats

The following options should not be modified, to ensure that the image runs correctly.

```bash
--config /opt/bitnami/mongodb/conf/mongodb.conf
--dbpath /opt/bitnami/mongodb/data
```

# Logging

The Bitnami MongoDB Docker Image supports two different logging modes: logging to stdout, and logging to a file.

## Logging to stdout

The default behavior is to log to stdout, as Docker expects. These will be collected by Docker, converted to JSON and stored in the host, to be accessible via the `docker logs` command.

```bash
docker logs mongodb
```

or using Docker Compose:

```bash
docker-compose logs mongodb
```

This method of logging has the downside of not being easy to manage. Without an easy way to rotate logs, they could grow exponentially and take up large amounts of disk space on your host.

## Logging to file

To log to file, run the MongoDB image, mounting a directory from your host at `/bitnami/mongodb/logs`. This will instruct the container to send logs to a `mongodb.log` file in the mounted volume.

```bash
docker run --name mongodb -v /path/to/mongodb/logs:/bitnami/mongodb/logs bitnami/mongodb
```

or using Docker Compose:

```
mongodb:
  image: bitnami/mongodb
  volumes:
    - /path/to/mongodb/logs:/bitnami/mongodb/logs
```

To perform operations (e.g. logrotate) on the logs, mount the same directory in a container designed to operate on log files, such as logstash.

# Maintenance

## Backing up your container

To backup your data, configuration and logs, follow these simple steps:

### Step 1: Stop the currently running container

```bash
docker stop mongodb
```

or using Docker Compose:

```bash
docker-compose stop mongodb
```

### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```bash
docker run --rm -v /path/to/backups:/backups --volumes-from mongodb busybox \
  cp -a /bitnami/mongodb /backups/latest
```

or using Docker Compose:

```bash
docker run --rm -v /path/to/backups:/backups --volumes-from `docker-compose ps -q mongodb` busybox \
  cp -a /bitnami/mongodb /backups/latest
```

**Note!**
If you only need to backup database data, or configuration, you can change the first argument to `cp` to `/bitnami/mongodb/data` or `/bitnami/mongodb/conf` respectively.

## Restoring a backup

Restoring a backup is as simple as mounting the backup as volumes in the container.

```bash
docker run -v /path/to/backups/latest/data:/bitnami/mongodb/data \
  -v /path/to/backups/latest/conf:/bitnami/mongodb/conf \
  -v /path/to/backups/latest/logs:/bitnami/mongodb/logs \
  bitnami/mongodb
```

or using Docker Compose:

```
mongodb:
  image: bitnami/mongodb
  volumes:
    - /path/to/backups/latest/data:/bitnami/mongodb/data
    - /path/to/backups/latest/conf:/bitnami/mongodb/conf
    - /path/to/backups/latest/logs:/bitnami/mongodb/logs
```

## Upgrade this image

Bitnami provides up-to-date versions of MongoDB, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
docker pull bitnami/mongodb:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/mongodb:latest`.

### Step 2: Stop and backup the currently running container

Before continuing, you should backup your container's data, configuration and logs.

Follow the steps on [creating a backup](#backing-up-your-container).

### Step 3: Remove the currently running container

```bash
docker rm -v mongodb
```

or using Docker Compose:

```bash
docker-compose rm -v mongodb
```

### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if necessary.

```bash
docker run --name mongodb bitnami/mongodb:latest
```

or using Docker Compose:

```bash
docker-compose start mongodb
```

# Testing

This image is tested for expected runtime behavior, using the [Bats](https://github.com/sstephenson/bats) testing framework. You can run the tests on your machine using the `bats` command.

```
bats test.sh
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-mongodb/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-mongodb/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-mongodb/issues). For us to provide better support, be sure to include the following information in your issue:

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
