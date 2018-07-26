[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-mongodb/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-mongodb/tree/master)

# What is MongoDB?

> [MongoDB](https://www.mongodb.org/) is a cross-platform document-oriented database. Classified as a NoSQL database, MongoDB eschews the traditional table-based relational database structure in favor of JSON-like documents with dynamic schemas, making the integration of data in certain types of applications easier and faster.

# TL;DR;

```bash
$ docker run --name mongodb bitnami/mongodb:latest
```

## Docker Compose

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-mongodb/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* Bitnami images are built on CircleCI and automatically pushed to the Docker Hub.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.

# Supported tags and respective `Dockerfile` links

> NOTE: Debian 8 images have been deprecated in favor of Debian 9 images. Bitnami will not longer publish new Docker images based on Debian 8.


* [`4-ol-7`, `4.1.1-ol-7-r10` (4/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-mongodb/blob/4.1.1-ol-7-r10/4/ol-7/Dockerfile)
* [`4-debian-9`, `4.1.1-debian-9-r11`, `4`, `4.1.1`, `4.1.1-r11` (4/Dockerfile)](https://github.com/bitnami/bitnami-docker-mongodb/blob/4.1.1-debian-9-r11/4/Dockerfile)
* [`3.6-ol-7`, `3.6.6-ol-7-r16` (3.6/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-mongodb/blob/3.6.6-ol-7-r16/3.6/ol-7/Dockerfile)
* [`3.6-debian-9`, `3.6.6-debian-9-r18`, `3.6`, `3.6.6`, `3.6.6-r18`, `latest` (3.6/Dockerfile)](https://github.com/bitnami/bitnami-docker-mongodb/blob/3.6.6-debian-9-r18/3.6/Dockerfile)

Subscribe to project updates by watching the [bitnami/redis GitHub repo](https://github.com/bitnami/bitnami-docker-redis).

# Get this image

The recommended way to get the Bitnami MongoDB Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/mongodb).

```bash
$ docker pull bitnami/mongodb:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/mongodb/tags/) in the Docker Hub Registry.

```bash
$ docker pull bitnami/mongodb:[TAG]
```

If you wish, you can also build the image yourself.

```bash
$ docker build -t bitnami/mongodb:latest https://github.com/bitnami/bitnami-docker-mongodb.git
```

# Persisting your database

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami` path. If the mounted directory is empty, it will be initialized on the first run.

```bash
$ docker run \
    -v /path/to/mongodb-persistence:/bitnami \
    bitnami/mongodb:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  mongodb:
    image: 'bitnami/mongodb:latest'
    ports:
      - "27017:27017"
    volumes:
      - /path/to/mongodb-persistence:/bitnami
```

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a MongoDB server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

In this example, we will create a MongoDB client instance that will connect to the server instance that is running on the same docker network as the client.

### Step 1: Create a network

```bash
$ docker network create app-tier --driver bridge
```

### Step 2: Launch the MongoDB server instance

Use the `--network app-tier` argument to the `docker run` command to attach the MongoDB container to the `app-tier` network.

```bash
$ docker run -d --name mongodb-server \
    --network app-tier \
    bitnami/mongodb:latest
```

### Step 3: Launch your MongoDB client instance

Finally we create a new container instance to launch the MongoDB client and connect to the server created in the previous step:

```bash
$ docker run -it --rm \
    --network app-tier \
    bitnami/mongodb:latest mongo --host mongodb-server
```

## Using Docker Compose

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `app-tier`. In this example we assume that you want to connect to the MongoDB server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge

services:
  mongodb:
    image: 'bitnami/mongodb:latest'
    networks:
      - app-tier
  myapp:
    image: 'YOUR_APPLICATION_IMAGE'
    networks:
      - app-tier
```

> **IMPORTANT**:
>
> 1. Please update the **YOUR_APPLICATION_IMAGE_** placeholder in the above snippet with your application image
> 2. In your application container, use the hostname `mongodb` to connect to the MongoDB server

Launch the containers using:

```bash
$ docker-compose up -d
```

# Configuration

## Passing extra command-line flags to mongod startup

Passing extra command-line flags to the mongod service command is possible through the following env var:

- `MONGODB_EXTRA_FLAGS`: Flags to be appended to the startup command. No defaults

```bash
$ docker run --name mongodb -e ALLOW_EMPTY_PASSWORD=yes -e MONGODB_EXTRA_FLAGS='--wiredTigerCacheSizeGB=2' bitnami/mongodb:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  mongodb:
    image: 'bitnami/mongodb:latest'
    ports:
      - "27017:27017"
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - MONGODB_EXTRA_FLAGS=--wiredTigerCacheSizeGB=2
```

## Setting the root password on first run

Passing the `MONGODB_ROOT_PASSWORD` environment variable when running the image for the first time will set the password of the `root` user to the value of `MONGODB_ROOT_PASSWORD` and enabled authentication on the MongoDB server.

```bash
$ docker run --name mongodb \
  -e MONGODB_ROOT_PASSWORD=password123 bitnami/mongodb:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  mongodb:
    image: 'bitnami/mongodb:latest'
    ports:
      - "27017:27017"
    environment:
      - MONGODB_ROOT_PASSWORD=password123
```

The `root` user is configured to have full administrative access to the MongoDB server. When `MONGODB_ROOT_PASSWORD` is not specified the server allows unauthenticated and unrestricted access.

## Creating a user and database on first run

You can create a user with restricted access to a database while starting the container for the first time. To do this, provide the `MONGODB_USERNAME`, `MONGO_PASSWORD` and `MONGODB_DATABASE` environment variables.

```bash
$ docker run --name mongodb \
  -e MONGODB_USERNAME=my_user -e MONGODB_PASSWORD=password123 \
  -e MONGODB_DATABASE=my_database bitnami/mongodb:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  mongodb:
    image: 'bitnami/mongodb:latest'
    ports:
      - "27017:27017"
    environment:
      - MONGODB_USERNAME=my_user
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
 - `MONGODB_PRIMARY_PORT_NUMBER`: MongoDB primary port. Default: **27017**
 - `MONGODB_ADVERTISED_HOSTNAME`: MongoDB advertised hostname. No defaults. It is recommended to pass this environment variable if you experience issues with ephemeral IPs. Setting this env var makes the nodes of the replica set to be configured with a hostname instead of the machine IP.

Only for authentication:
 - `MONGODB_REPLICA_SET_KEY`: MongoDB replica set key. Length should be greater than 5 characters and should not contain any special characters. Required for all nodes. No default.
 - `MONGODB_ROOT_PASSWORD`: MongoDB root password. No defaults. Only for primary node.
 - `MONGODB_PRIMARY_ROOT_PASSWORD`: MongoDB primary root password. No defaults. Only for secondaries and aribters nodes.

In a replication cluster you can have one primary node, zero or more secondary nodes and zero or one arbiter node.

> **Note**: The total number of nodes on a replica set sceneraio cannot be higher than 8 (1 primary, 6 secondaries and 1 arbiter)

### Step 1: Create the replication primary

The first step is to start the MongoDB primary.

```bash
$ docker run --name mongodb-primary \
  -e MONGODB_REPLICA_SET_MODE=primary \
   bitnami/mongodb:latest
```

In the above command the container is configured as the `primary` using the `MONGODB_REPLICA_SET_MODE` parameter.

### Step 2: Create the replication secondary node

Next we start a MongoDB secondary container.

```bash
$ docker run --name mongodb-secondary \
  --link mongodb-primary:primary \
  -e MONGODB_REPLICA_SET_MODE=secondary \
  -e MONGODB_PRIMARY_HOST=primary \
  -e MONGODB_PRIMARY_PORT_NUMBER=27017 \
  bitnami/mongodb:latest
```

In the above command the container is configured as a `secondary` using the `MONGODB_REPLICA_SET_MODE` parameter. The `MONGODB_PRIMARY_HOST` and `MONGODB_PRIMARY_PORT_NUMBER` parameters are used connect and with the MongoDB primary.

### Step 3: Create a replication arbiter node

Finally we start a MongoDB arbiter container.

```bash
$ docker run --name mongodb-arbiter \
  --link mongodb-primary:primary \
  -e MONGODB_REPLICA_SET_MODE=arbiter \
  -e MONGODB_PRIMARY_HOST=primary \
  -e MONGODB_PRIMARY_PORT_NUMBER=27017 \
  bitnami/mongodb:latest
```

In the above command the container is configured as a `arbiter` using the `MONGODB_REPLICA_SET_MODE` parameter. The `MONGODB_PRIMARY_HOST` and `MONGODB_PRIMARY_PORT_NUMBER` parameters are used connect and with the MongoDB primary.

You now have a three node MongoDB replication cluster up and running which can be scaled by adding/removing secondarys.

With Docker Compose the replicaset can be setup using:

```yaml
version: '2'

services:
  mongodb-primary:
    image: 'bitnami/mongodb:latest'
    environment:
      - MONGODB_REPLICA_SET_MODE=primary
    volumes:
      - 'mongodb_master_data:/bitnami'

  mongodb-secondary:
    image: 'bitnami/mongodb:latest'
    depends_on:
      - mongodb-primary
    environment:
      - MONGODB_REPLICA_SET_MODE=secondary
      - MONGODB_PRIMARY_HOST=mongodb-primary
      - MONGODB_PRIMARY_PORT_NUMBER=27017

  mongodb-arbiter:
    image: 'bitnami/mongodb:latest'
    depends_on:
      - mongodb-primary
    environment:
      - MONGODB_REPLICA_SET_MODE=arbiter
      - MONGODB_PRIMARY_HOST=mongodb-primary
      - MONGODB_PRIMARY_PORT_NUMBER=27017

volumes:
  mongodb_master_data:
    driver: local
```

Or in case you want to set up the replicaset with authentication you can use the following file:

```yaml
version: '2'

services:
  mongodb-primary:
    image: 'bitnami/mongodb:latest'
    environment:
      - MONGODB_REPLICA_SET_MODE=primary
      - MONGODB_ROOT_PASSWORD=password123
      - MONGODB_REPLICA_SET_KEY=replicasetkey123
    volumes:
      - 'mongodb_master_data:/bitnami'

  mongodb-secondary:
    image: 'bitnami/mongodb:latest'
    depends_on:
      - mongodb-primary
    environment:
      - MONGODB_REPLICA_SET_MODE=secondary
      - MONGODB_PRIMARY_HOST=mongodb-primary
      - MONGODB_PRIMARY_PORT_NUMBER=27017
      - MONGODB_PRIMARY_ROOT_PASSWORD=password123
      - MONGODB_REPLICA_SET_KEY=replicasetkey123

  mongodb-arbiter:
    image: 'bitnami/mongodb:latest'
    depends_on:
      - mongodb-primary
    environment:
      - MONGODB_REPLICA_SET_MODE=arbiter
      - MONGODB_PRIMARY_HOST=mongodb-primary
      - MONGODB_PRIMARY_PORT_NUMBER=27017
      - MONGODB_PRIMARY_ROOT_PASSWORD=password123
      - MONGODB_REPLICA_SET_KEY=replicasetkey123

volumes:
  mongodb_master_data:
    driver: local
```

Scale the number of secondary nodes using:

```bash
$ docker-compose scale mongodb-primary=1 mongodb-secondary=3 mongodb-arbiter=1
```

The above command scales up the number of secondary nodes to `3`. You can scale down in the same way.

> **Note**: You should not scale up/down the number of primary nodes. Always have only one primary node running.


### How is a replica set configured?

There are three different roles in a replica set configuration (primary, secondary or arbiter). Each one of these roles are configured in a different way:

**Primary node configuration:**

The replica set is started with the `rs.initiate()` command and some configuration options to force the primary to be the primary. Basically, the priority is increased from the default (1) to 5.
To verify the primary is actually the primary we validate it with the `db.isMaster().ismaster` command.

The primary node has a volume attached so the data is preserved between deployments as long as the volume exists.

In addition, the primary node initialization script will check for the existence of a `.initialized` file in the `/bitnami/mongodb` folder to discern whether it should create a new replica set or on the contrary a replica set has already been initialized.

If the primary got killed and the volume is deleted, in order to start it again in the same replica set it is important to launch the container with the original IP so other members of the replica set already knows about it.

**Secondary node configuration:**

Once the primary node is up and running we can start adding secondary nodes (and arbiter). For that, the secondary node connects to the primary node and add itself as a secondary node with the command `rs.add(SECONDARY_NODE_HOST)`.

After adding the secondary nodes we verified they have been successfully added by executing `rs.status().members` to see if they appear in the list.

**Arbiter node configuration:**

Finally, the arbiters follows the same procedure than secondary nodes with the exception that the command to add it to the replica set is `rs.addArb(ARBITER_NODE_HOST)`. An arbiter should be added when the sum of primary nodes plus secondaries nodes is even.

## Configuration file

The image looks for configurations in `/opt/bitnami/mongodb/conf/`. You can mount a volume at `/opt/bitnami/mongodb/conf/` and copy/edit the configurations in the `/path/to/mongodb-configuration-persistence/`. The default configurations will be populated to the `conf/` directory if it's empty.

### Step 1: Run the MongoDB image

Run the MongoDB image, mounting a directory from your host.

```bash
$ docker run --name mongodb -v /path/to/mongodb-configuration-persistence:/opt/bitnami/mongodb/conf bitnami/mongodb:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  mongodb:
    image: 'bitnami/mongodb:latest'
    ports:
      - "27017:27017"
    volumes:
      - /path/to/mongodb-configuration-persistence:/opt/bitnami/mongodb/conf
```

### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```bash
$ vi /path/to/mongodb-configuration-persistence/mongodb.conf
```

### Step 3: Restart MongoDB

After changing the configuration, restart your MongoDB container for changes to take effect.

```bash
$ docker restart mongodb
```

or using Docker Compose:

```bash
$ docker-compose restart mongodb
```

Refer to the [configuration file options](http://docs.mongodb.org/v2.4/reference/configuration-options/) manual for the complete list of MongoDB configuration options.

# Logging

The Bitnami MongoDB Docker image sends the container logs to the `stdout`. To view the logs:

```bash
$ docker logs mongodb
```

or using Docker Compose:

```bash
$ docker-compose logs mongodb
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of MongoDB, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
$ docker pull bitnami/mongodb:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/mongodb:latest`.

### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```bash
$ docker stop mongodb
```

or using Docker Compose:

```bash
$ docker-compose stop mongodb
```

Next, take a snapshot of the persistent volume `/path/to/mongodb-persistence` using:

```bash
$ rsync -a /path/to/mongodb-persistence /path/to/mongodb-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

You can use this snapshot to restore the database state should the upgrade fail.

### Step 3: Remove the currently running container

```bash
$ docker rm -v mongodb
```

or using Docker Compose:

```bash
$ docker-compose rm -v mongodb
```

### Step 4: Run the new image

Re-create your container from the new image.

```bash
$ docker run --name mongodb bitnami/mongodb:latest
```

or using Docker Compose:

```bash
$ docker-compose up mongodb
```

# Notable Changes

## 3.2.7-r5

- `MONGODB_USER` parameter has been renamed to `MONGODB_USERNAME`.

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
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright (c) 2015-2018 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
