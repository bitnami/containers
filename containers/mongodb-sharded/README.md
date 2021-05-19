# What is MongoDB&reg; Sharded packaged by Bitnami?

> [MongoDB&reg;](https://www.mongodb.org/) is a cross-platform document-oriented database. Classified as a NoSQL database, MongoDB&reg; eschews the traditional table-based relational database structure in favor of JSON-like documents with dynamic schemas, making the integration of data in certain types of applications easier and faster.

This container flavor uses the [sharding method](https://docs.mongodb.com/manual/sharding/) for distributing data across multiple machines. This is meant for deployments with very large data sets and high throughput operations.

All MongoDB&reg; versions released after October 16, 2018 (3.6.9 or later, 4.0.4 or later or 4.1.5 or later) are licensed under the [Server Side Public License](https://www.mongodb.com/licensing/server-side-public-license) that is not currently accepted as a Open Source license by the Open Source Iniciative (OSI).

Disclaimer: The respective trademarks mentioned in the offering are owned by the respective companies. We do not provide a commercial license for any of these products. This listing has an open-source license. MongoDB&reg; is run and maintained by MongoDB, which is a completely separate project from Bitnami.

# TL;DR

```console
$ docker run --name mongodb bitnami/mongodb-sharded:latest
```

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-mongodb-sharded/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/mongodb?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy MongoDB&reg; Sharded in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami MongoDB&reg; Sharded Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/mongodb-sharded).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`4.4`, `4.4-debian-10`, `4.4.6`, `4.4.6-debian-10-r10`, `latest` (4.4/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-mongodb/blob/4.4.6-debian-10-r10/4.4/debian-10/Dockerfile)
* [`4.2`, `4.2-debian-10`, `4.2.14`, `4.2.14-debian-10-r14` (4.2/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-mongodb/blob/4.2.14-debian-10-r14/4.2/debian-10/Dockerfile)
* [`4.0`, `4.0-debian-9`, `4.0.24`, `4.0.24-debian-9-r31` (4.0/debian-9/Dockerfile)](https://github.com/bitnami/bitnami-docker-mongodb/blob/4.0.24-debian-9-r31/4.0/debian-9/Dockerfile)
* [`3.6`, `3.6-debian-9`, `3.6.23`, `3.6.23-debian-9-r59` (3.6/debian-9/Dockerfile)](https://github.com/bitnami/bitnami-docker-mongodb/blob/3.6.23-debian-9-r59/3.6/debian-9/Dockerfile)

Subscribe to project updates by watching the [bitnami/mongodb GitHub repo](https://github.com/bitnami/bitnami-docker-mongodb).

# Get this image

The recommended way to get the Bitnami MongoDB&reg; Sharded Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/mongodb-sharded).

```console
$ docker pull bitnami/mongodb-sharded:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/mongodb-sharded/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/mongodb-sharded:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/mongodb-sharded:latest 'https://github.com/bitnami/bitnami-docker-mongodb-sharded.git#master:4.4/debian-10'
```

# Persisting your database

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/mongodb` path. If the mounted directory is empty, it will be initialized on the first run.

```console
$ docker run \
    -v /path/to/mongodb-persistence:/bitnami/mongodb \
    bitnami/mongodb-sharded:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-mongodb-sharded/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  mongodb-sharded:
  ...
    volumes:
      - /path/to/mongodb-persistence:/bitnami
  ...
```

# Configuration

## Setting up a sharded cluster

In a sharded cluster, there are [three components](https://docs.mongodb.com/manual/sharding/#sharded-cluster):

- Mongos: Interface between the applications and the sharded database.
- Config Servers: Stores metadata and configuration settings for the sharded database.
- Shards: Contains a subset of the data.

A [sharded cluster](https://docs.mongodb.com/manual/sharding/#sharded-cluster) can easily be setup with the Bitnami MongoDB&reg; Sharded Docker Image using the following environment variables:

 - `MONGODB_SHARDING_MODE`: The sharding mode. Possible values: `mongos`/`configsvr`/`shardsvr`. No defaults.
 - `MONGODB_REPLICA_SET_NAME`: MongoDB&reg; replica set name. In a sharded cluster we will have multiple replica sets. Default: **replicaset**
 - `MONGODB_MONGOS_HOST`: MongoDB&reg; mongos instance host. No defaults.
 - `MONGODB_CFG_REPLICA_SET_NAME`: MongoDB&reg; config server replica set name. In a sharded cluster we will have multiple replica sets. Default: **replicaset**
 - `MONGODB_CFG_PRIMARY_HOST`: MongoDB&reg; config server primary host. No defaults.
 - `MONGODB_ADVERTISED_HOSTNAME`: MongoDB&reg; advertised hostname. No defaults. It is recommended to pass this environment variable if you experience issues with ephemeral IPs. Setting this env var makes the nodes of the replica set to be configured with a hostname instead of the machine IP.
 - `MONGODB_REPLICA_SET_KEY`: MongoDB&reg; replica set key. Length should be greater than 5 characters and should not contain any special characters. Required for all nodes in the sharded cluster. No default.
 - `MONGODB_ROOT_PASSWORD`: MongoDB&reg; root password. No defaults.
 - `MONGODB_REPLICA_SET_MODE`: The replication mode. Possible values `primary`/`secondary`/`arbiter`. No defaults.

### Step 1: Create the config server replica set

The first step is to start the MongoDB&reg; primary config server.

```console
$ docker run --name mongodb-configsvr-primary \
  -e MONGODB_SHARDING_MODE=configsvr \
  -e MONGODB_REPLICA_SET_MODE=primary \
  -e MONGODB_ROOT_PASSWORD=password123 \
  -e MONGODB_REPLICA_SET_KEY=replicasetkey123 \
  -e MONGODB_REPLICA_SET_NAME=config-replicaset \
   bitnami/mongodb-sharded:latest
```

In the above command the container is configured as Config server using the `MONGODB_SHARDING_MODE` parameter and as `primary` using the `MONGODB_REPLICA_SET_MODE` parameter. You can configure secondary nodes by following the [Bitnami MongoDB&reg; container replication guide](https://github.com/bitnami/bitnami-docker-mongodb#setting-up-replication).

### Step 2: Create the mongos instance

Next we start a MongoDB&reg; mongos server and connect it to the config server replica set.

```console
$ docker run --name mongos \
  --link mongodb-configsvr-primary:cfg-primary \
  -e MONGODB_SHARDING_MODE=mongos \
  -e MONGODB_CFG_PRIMARY_HOST=cfg-primary \
  -e MONGODB_CFG_REPLICA_SET_NAME=config-replicaset \
  -e MONGODB_REPLICA_SET_KEY=replicasetkey123 \
  -e MONGODB_ROOT_PASSWORD=password123 \
  bitnami/mongodb-sharded:latest
```

In the above command the container is configured as a `mongos` using the `MONGODB_SHARDING_MODE` parameter. The `MONGODB_CFG_PRIMARY_HOST`, `MONGODB_REPLICA_SET_KEY`, `MONGODB_CFG_REPLICA_SET_NAME` and `MONGODB_ROOT_PASSWORD` parameters are used connect and with the MongoDB&reg; primary config server.

### Step 3: Create a shard

Finally we start a MongoDB&reg; data shard container.

```console
$ docker run --name mongodb-shard0-primary \
  --link mongodb-configsvr-primary:cfg-primary \
  --link mongos:mongos \
  -e MONGODB_SHARDING_MODE=shardsvr \
  -e MONGODB_MONGOS_HOST=mongos \
  -e MONGODB_ROOT_PASSWORD=password123 \
  -e MONGODB_REPLICA_SET_MODE=primary \
  -e MONGODB_REPLICA_SET_KEY=replicasetkey123 \
  -e MONGODB_REPLICA_SET_NAME=shard0 \
  bitnami/mongodb-sharded:latest
```

In the above command the container is configured as a data shard using the `MONGODB_SHARDING_MODE` parameter. The `MONGODB_MONGOS_HOST`,  `MONGODB_ROOT_PASSWORD` and `MONGODB_REPLICA_SET_KEY` parameters are used connect and with the Mongos instance. You can configure secondary nodes by following the [Bitnami MongoDB&reg; container replication guide](https://github.com/bitnami/bitnami-docker-mongodb#setting-up-replication).

You now have a sharded MongoDB&reg; cluster up and running. You can add more shards by repeating step 3. Make sure you set a different `MONGODB_REPLICA_SET_NAME` value. You can also add more mongos instances by repeating step 2.

With Docker Compose the sharded cluster can be setup using:

```yaml
version: '2'

services:
  mongos:
    image: 'bitnami/mongodb-sharded:latest'
    environment:
      - MONGODB_SHARDING_MODE=mongos
      - MONGODB_CFG_PRIMARY_HOST=mongodb-cfg
      - MONGODB_CFG_REPLICA_SET_NAME=cfgreplicaset
      - MONGODB_REPLICA_SET_KEY=replicasetkey123
      - MONGODB_ROOT_PASSWORD=password123
    ports:
      - "27017:27017"

  mongodb-shard0-primary:
    image: 'bitnami/mongodb-sharded:latest'
    environment:
      - MONGODB_SHARDING_MODE=shardsvr
      - MONGODB_MONGOS_HOST=mongos
      - MONGODB_ROOT_PASSWORD=password123
      - MONGODB_REPLICA_SET_MODE=primary
      - MONGODB_REPLICA_SET_KEY=replicasetkey123
      - MONGODB_REPLICA_SET_NAME=shard0
    volumes:
      - 'shard0_data:/bitnami'

  mongodb-configsvr-primary:
    image: 'bitnami/mongodb-sharded:latest'
    environment:
      - MONGODB_SHARDING_MODE=configsvr
      - MONGODB_ROOT_PASSWORD=password123
      - MONGODB_REPLICA_SET_MODE=primary
      - MONGODB_REPLICA_SET_KEY=replicasetkey123
      - MONGODB_REPLICA_SET_NAME=config-replicaset
    volumes:
      - 'cfg_data:/bitnami'

volumes:
  shard0_data:
    driver: local
  cfg_data:
    driver: local
```

## More MongoDB&reg; configuration settings
The Bitnami MongoDB&reg; Sharded image contains the [same configuration features than the Bitnami MongoDB&reg; image](https://github.com/bitnami/bitnami-docker-mongodb#configuration).

# Logging

The Bitnami MongoDB&reg; Sharded Docker image sends the container logs to the `stdout`. To view the logs:

```console
$ docker logs mongodb-sharded
```

or using Docker Compose:

```console
$ docker-compose logs mongodb-sharded
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of MongoDB&reg;, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```console
$ docker pull bitnami/mongodb-sharded:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/mongodb-sharded:latest`.

### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
$ docker stop mongodb-sharded
```

or using Docker Compose:

```console
$ docker-compose stop mongodb-sharded
```

Next, take a snapshot of the persistent volume `/path/to/mongodb-persistence` using:

```console
$ rsync -a /path/to/mongodb-persistence /path/to/mongodb-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

You can use this snapshot to restore the database state should the upgrade fail.

### Step 3: Remove the currently running container

```console
$ docker rm -v mongodb-sharded
```

or using Docker Compose:

```console
$ docker-compose rm -v mongodb-sharded
```

### Step 4: Run the new image

Re-create your container from the new image.

```console
$ docker run --name mongodb bitnami/mongodb-sharded:latest
```

or using Docker Compose:

```console
$ docker-compose up mongodb-sharded
```

# Notable Changes

## 3.6.16-centos-7-r49, 4.0.14-centos-7-r29, and 4.2.2-centos-7-r41

- `3.6.16-centos-7-r49`, `4.0.14-centos-7-r29`, and `4.2.2-centos-7-r41` are considered the latest images based on CentOS.
- Standard supported distros: Debian & OEL.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-mongodb-sharded/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-mongodb-sharded/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-mongodb-sharded/issues/new). For us to provide better support, be sure to include the following information in your issue:

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
