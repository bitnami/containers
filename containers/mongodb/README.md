[![Build Status](http://bitnami-container-builds.bitnamiapp.com/jenkins/buildStatus/icon?job=docker-mongodb)](http://bitnami-container-builds.bitnamiapp.com/jenkins/job/docker-mongodb/)
[![Docker Hub Automated Build](http://container.checkforupdates.com/badges/bitnami/mongodb)](https://hub.docker.com/r/bitnami/mongodb/)

# What is MongoDB?

> [MongoDB](https://www.mongodb.org/) is a cross-platform document-oriented database. Classified as a NoSQL database, MongoDB eschews the traditional table-based relational database structure in favor of JSON-like documents with dynamic schemas, making the integration of data in certain types of applications easier and faster.

# TLDR

```bash
docker run --name mongodb bitnami/mongodb:latest
```

## Docker Compose

```yaml
mongodb:
  image: bitnami/mongodb:latest
```

# Get this image

The recommended way to get the Bitnami MongoDB Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/mongodb).

```bash
docker pull bitnami/mongodb:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/mongodb/tags/) in the Docker Hub Registry.

```bash
docker pull bitnami/mongodb:[TAG]
```

If you wish, you can also build the image yourself.

```bash
docker build -t bitnami/mongodb:latest https://github.com/bitnami/bitnami-docker-mongodb.git
```

# Persisting your database

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

**Note!**
If you have already started using your database, follow the steps on
[backing up](#backing-up-your-container) and [restoring](#restoring-a-backup) to pull the data from your running container down to your host.

The image exposes a volume at `/bitnami/mongodb` for the MongoDB data and configurations. For persistence you can mount a directory at this location from your host. If the mounted directory is empty, it will be initialized on the first run.

```bash
docker run -v /path/to/mongodb-persistence:/bitnami/mongodb bitnami/mongodb:latest
```

or using Docker Compose:

```yaml
mongodb:
  image: bitnami/mongodb:latest
  volumes:
    - /path/to/mongodb-persistence:/bitnami/mongodb
```

# Linking

If you want to connect to your MongoDB server inside another container, you can use the linking system provided by Docker.

## Connecting a Mongo client container to the MongoDB server container

### Step 1: Run the MongoDB image with a specific name

The first step is to start our MongoDB server.

Docker's linking system uses container ids or names to reference containers. We can explicitly specify a name for our MongoDB server to make it easier to connect to other containers.

```bash
docker run --name mongodb bitnami/mongodb:latest
```

### Step 2: Run MongoDB as a Mongo client and link to our server

Now that we have our MongoDB server running, we can create another container that links to it by giving Docker the `--link` option. This option takes the id or name of the container we want to link it to as well as a hostname to use inside the container, separated by a colon. For example, to have our MongoDB server accessible in another container with `server` as it's hostname we would pass `--link mongodb:server` to the Docker run command.

The Bitnami MongoDB Docker Image also ships with a Mongo client, but by default it will start a server. To start the client instead, we can override the default command Docker runs by stating a different command to run after the image name.

```bash
docker run --rm -it --link mongodb:server bitnami/mongodb:latest mongo --host server
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

```yaml
mongodb:
  image: bitnami/mongodb:latest
```

### Step 2: Link it to another container in your application

Update the definitions for containers you want to access your MongoDB server from to include a link to the `mongodb` entry you added in Step 1.

```yaml
myapp:
  image: myapp
  links:
    - mongodb:mongodb
```

Inside `myapp`, use `mongodb` as the hostname for the MongoDB server.

# Configuration

## Setting the root password on first run

Passing the `MONGODB_ROOT_PASSWORD` environment variable when running the image for the first time will set the password of the root user to the value of `MONGODB_ROOT_PASSWORD` and enabled authentication on the MongoDB server.

```bash
docker run --name mongodb \
  -e MONGODB_ROOT_PASSWORD=password123 bitnami/mongodb:latest
```

or using Docker Compose:

```yaml
mongodb:
  image: bitnami/mongodb:latest
  environment:
    - MONGODB_ROOT_PASSWORD=password123
```

The `root` user is configured to have full administrative access to the MongoDB server. When `MONGODB_ROOT_PASSWORD` is not specified the server allows unauthenticated and unrestricted access.

## Creating a user and database on first run

You can create a user with restricted access to a database while starting the container for the first time. To do this, provide the `MONGODB_USER`, `MONGO_PASSWORD` and `MONGODB_DATABASE` environment variables.

```bash
docker run --name mongodb \
  -e MONGODB_USER=my_user -e MONGODB_PASSWORD=password123 \
  -e MONGODB_DATABASE=my_database bitnami/mongodb:latest
```

or using Docker Compose:

```yaml
mongodb:
  image: bitnami/mongodb:latest
  environment:
    - MONGODB_USER=my_user
    - MONGODB_PASSWORD=password123
    - MONGODB_DATABASE=my_database
```

**Note!**
Creation of a user enables authentication on the MongoDB server and as a result unauthenticated access by *any* user is not permitted.

## Setting up a replication

A [replication](https://docs.mongodb.com/manual/replication/) cluster can easily be setup with the Bitnami MongoDB Docker Image using the following environment variables:

 - `MONGODB_REPLICA_SET_MODE`: The replication mode. Possible values `primary`/`secondary`/`arbiter`. No defaults.
 - `MONGODB_REPLICA_SET_NAME`: MongoDB replica set name. Default: **replicaset**
 - `MONGODB_PRIMARY_HOST`: MongoDB primary host. No defaults.
 - `MONGODB_PRIMARY_PORT`: MongoDB primary port. No defaults.

In a replication cluster you can have one primary node, zero or more secondary nodes and zero or one arbiter node.

> **Note**: The total number of nodes on a replica set sceneraio cannot be higher than 8 (1 primary, 6 secondaries and 1 arbiter)

### Step 1: Create the replication primary

The first step is to start the MongoDB primary.

```bash
docker run --name mongodb-primary \
  -e MONGODB_REPLICA_SET_MODE=primary \
   bitnami/mongodb:latest
```

In the above command the container is configured as the `primary` using the `MONGODB_REPLICA_SET_MODE` parameter.

### Step 2: Create the replication secondary node

Next we start a MongoDB secondary container.

```bash
docker run --name mongodb-secondary \
  --link mongodb-primary:primary \
  -e MONGODB_REPLICA_SET_MODE=secondary \
  -e MONGODB_PRIMARY_HOST=primary \
  -e MONGODB_PRIMARY_PORT=27017 \
  bitnami/mongodb:latest
```

In the above command the container is configured as a `secondary` using the `MONGODB_REPLICA_SET_MODE` parameter. The `MONGODB_PRIMARY_HOST` and `MONGODB_PRIMARY_PORT` parameters are used connect and with the MongoDB primary.

### Step 3: Create a replication arbiter node

Finally we start a MongoDB arbiter container.

```bash
docker run --name mongodb-arbiter \
  --link mongodb-primary:primary \
  -e MONGODB_REPLICA_SET_MODE=arbiter \
  -e MONGODB_PRIMARY_HOST=primary \
  -e MONGODB_PRIMARY_PORT=27017 \
  bitnami/mongodb:latest
```

In the above command the container is configured as a `arbiter` using the `MONGODB_REPLICA_SET_MODE` parameter. The `MONGODB_PRIMARY_HOST` and `MONGODB_PRIMARY_PORT` parameters are used connect and with the MongoDB primary.

You now have a three node MongoDB replication cluster up and running which can be scaled by adding/removing secondarys.

With Docker Compose the primary/secondary/arbiter replication can be setup using:

```yaml
primary:
  image: bitnami/mongodb:latest
  environment:
    - MONGODB_REPLICA_SET_MODE=primary

secondary:
  image: bitnami/mongodb:latest
  links:
    - primary:primary
  environment:
    - MONGODB_REPLICA_SET_MODE=secondary
    - MONGODB_PRIMARY_HOST=primary
    - MONGODB_PRIMARY_PORT=27017

arbiter:
  image: bitnami/mongodb:latest
  links:
    - primary:primary
  environment:
    - MONGODB_REPLICA_SET_MODE=arbiter
    - MONGODB_PRIMARY_HOST=primary
    - MONGODB_PRIMARY_PORT=27017
```

Scale the number of secondary nodes using:

```bash
docker-compose scale primary=1 secondary=3 arbiter=1
```

The above command scales up the number of secondary nodes to `3`. You can scale down in the same way.

> **Note**: You should not scale up/down the number of primary nodes. Always have only one primary node running.

## Configuration file

The image looks for configuration in the `conf/` directory of `/bitnami/mongodb`. As as mentioned in [Persisting your database](#persisting-your-data) you can mount a volume at this location and copy your own configurations in the `conf/` directory. The default configuration will be copied to the `conf/` directory if it's empty.

### Step 1: Run the MongoDB image

Run the MongoDB image, mounting a directory from your host.

```bash
docker run --name mongodb -v /path/to/mongodb-persistence:/bitnami/mongodb bitnami/mongodb:latest
```

or using Docker Compose:

```yaml
mongodb:
  image: bitnami/mongodb:latest
  volumes:
    - /path/to/mongodb-persistence:/bitnami/mongodb
```

### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```bash
vi /path/to/mongodb-persistence/conf/mongodb.conf
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

# Logging

The Bitnami MongoDB Docker image sends the container logs to the `stdout`. To view the logs:

```bash
docker logs mongodb
```

or using Docker Compose:

```bash
docker-compose logs mongodb
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

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
docker run --rm \
  -v /path/to/mongodb-backups:/backups \
  --volumes-from mongodb busybox \
    cp -a /bitnami/mongodb:latest /backups/latest
```

or using Docker Compose:

```bash
docker run --rm \
  -v /path/to/mongodb-backups:/backups \
  --volumes-from `docker-compose ps -q mongodb` busybox \
    cp -a /bitnami/mongodb:latest /backups/latest
```

## Restoring a backup

Restoring a backup is as simple as mounting the backup as volumes in the container.

```bash
docker run \
  -v /path/to/mongodb-backups/latest:/bitnami/mongodb bitnami/mongodb:latest
```

or using Docker Compose:

```yaml
mongodb:
  image: bitnami/mongodb:latest
  volumes:
    - /path/to/mongodb-backups/latest:/bitnami/mongodb
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

```bash
bats test.sh
```

# Notable Changes

## 3.2.6-r0

- All volumes have been merged at `/bitnami/mongodb`. Now you only need to mount a single volume at `/bitnami/mongodb` for persistence.
- The logs are always sent to the `stdout` and are no longer collected in the volume.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-mongodb/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-mongodb/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-mongodb/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_APP_VERSION` inside the container)
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
