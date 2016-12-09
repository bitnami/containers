[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-cassandra/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-cassandra/tree/master)
[![Docker Hub Automated Build](http://container.checkforupdates.com/badges/bitnami/cassandra)](https://hub.docker.com/r/bitnami/cassandra/)
# What is Cassandra?

> [Apache Cassandra](http://cassandra.apache.org) is a free and open-source distributed database management system designed to handle large amounts of data across many commodity servers, providing high availability with no single point of failure. Cassandra offers robust support for clusters spanning multiple datacenters, with asynchronous masterless replication allowing low latency operations for all clients.

# TLDR

```bash
docker run --name cassandra bitnami/cassandra:latest
```

## Docker Compose

```
cassandra:
  image: bitnami/cassandra:latest
```

# Get this image

The recommended way to get the Bitnami Cassandra Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/cassandra).

```bash
docker pull bitnami/cassandra:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/cassandra/tags/) in the Docker Hub Registry.

```bash
docker pull bitnami/cassandra:[TAG]
```

If you wish, you can also build the image yourself.

```bash
docker build -t bitnami/cassandra:latest https://github.com/bitnami/bitnami-docker-cassandra.git
```

# Persisting your application

If you remove every container and volume all your data will be lost, and the next time you run the image the application will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed. If you are using docker-compose your data will be persistent as long as you don't remove `application_data` data volumes. If you have run the containers manually or you want to mount the folders with persistent data in your host follow the next steps:

> **Note!** If you have already started using your application, follow the steps on [backing](#backing-up-your-application) up to pull the data from your running container down to your host.

The image exposes a volume at `/bitnami/cassandra` for the Cassandra data and configurations. For persistence you can mount a directory at this location from your host. If the mounted directory is empty, it will be initialized on the first run.

```bash
docker run -v /path/to/cassandra-persistence:/bitnami/cassandra bitnami/cassandra:latest
```

or using Docker Compose:

```
cassandra:
  image: bitnami/cassandra:latest
  volumes:
    - /path/to/cassandra-persistence:/bitnami/cassandra
```

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a Cassandra server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

In this example, we will create a Cassandra client instance that will connect to the server instance that is running on the same docker network as the client.

### Step 1: Create a network

```bash
$ docker network create app-tier --driver bridge
```

### Step 2: Launch the Cassandra server instance

Use the `--network app-tier` argument to the `docker run` command to attach the Cassandra container to the `app-tier` network.

```bash
$ docker run -d --name cassandra-server \
    --network app-tier \
    bitnami/cassandra:latest
```

### Step 3: Launch your Cassandra client instance

Finally we create a new container instance to launch the Cassandra client and connect to the server created in the previous step:

```bash
$ docker run -it --rm \
    --network app-tier \
    bitnami/cassandra:latest cqlsh --username cassandra --password cassandra-server cassandra
```

## Using Docker Compose

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `app-tier`. In this example we assume that you want to connect to the Cassandra server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge

services:
  cassandra:
    image: 'bitnami/cassandra:latest'
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
> 2. In your application container, use the hostname `cassandra` to connect to the Cassandra server

Launch the containers using:

```bash
$ docker-compose up -d
```

# Configuration

## Environment variables
 When you start the cassandra image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the docker run command line. If you want to add a new environment variable:

 * For docker-compose add the variable name and value under the application section:
```yaml
application:
  image: bitnami/cassandra:latest
  environment:
    - CASSANDRA_TRANSPORT_PORT=7000
```

 * For manual execution add a `-e` option with each variable and value:

```
 $ docker run -d -e CASSANDRA_PORT=7000 -p 7000:7000 --name cassandra -v /your/local/path/bitnami/cassandra:/bitnami/cassandra --network=cassandra_network bitnami/cassandra
```

Available variables:

 - `CASSANDRA_TRANSPORT_PORT`: Inter-node cluster communication port. Default: **7000**
 - `CASSANDRA_SSL_TRANSPORT_PORT`: SSL inter-node cluster communication port. Default: **7001**
 - `CASSANDRA_JMX_PORT`: JMX connections port. Default: **7199**
 - `CASSANDRA_CQL_PORT`: Client port. Default: **9042**.
 - `CASSANDRA_RPC_PORT`: Thrift RPC service connection port. Default: **9160**
 - `CASSANDRA_USER`: Cassandra user name. Defaults: **cassandra**
 - `CASSANDRA_PASSWORD`: Cassandra user password. Default: **cassandra**
 - `CASSANDRA_HOST`: Hostname used to configure Cassandra. It can be either an IP or a domain. If left empty, it will be resolved to the machine IP.
 - `CASSANDRA_CLUSTER_NAME`: Cluster name to configure Cassandra.. Defaults: **My Cluster**
 - `CASSANDRA_SEEDS`: Hosts that will act as Cassandra seeds. No defaults.
 - `CASSANDRA_ENDPOINT_SNITCH`: Snitch name (which determines which data centers and racks nodes belong to). Default **SimpleSnitch**

## Setting the server password on first run

Passing the `CASSANDRA_PASSWORD` environment variable when running the image for the first time will set the Cassandra server password to the value of `CASSANDRA_PASSWORD`.

```bash
docker run --name cassandra -e CASSANDRA_PASSWORD=password123 bitnami/cassandra:latest
```

or using Docker Compose:

```
cassandra:
  image: bitnami/cassandra:latest
  environment:
    - CASSANDRA_PASSWORD=password123
```

## Setting up a cluster

A cluster can easily be setup with the Bitnami Cassandra Docker Image using the following environment variables

 - `CASSANDRA_HOST`: Hostname used to configure Cassandra. It can be either an IP or a domain. If left empty, it will be resolved to the machine IP.
 - `CASSANDRA_CLUSTER_NAME`: Cluster name to configure Cassandra.. Defaults: **My Cluster**
 - `CASSANDRA_SEEDS`: Hosts that will act as Cassandra seeds. No defaults.
 - `CASSANDRA_ENDPOINT_SNITCH`: Snitch name (which determines which data centers and racks nodes belong to). Default **SimpleSnitch**

### Step 1: Create a new network.

```bash
docker network create cassandra_network
```

### Step 2: Create a first node.

```bash
docker run --name cassandra-node1 \
  --net=cassandra_network \
  -p 9042:9042 \
  -e CASSANDRA_CLUSTER_NAME=cassandra-cluster \
  -e CASSANDRA_SEEDS=cassandra-node1,cassandra-node2 \
  bitnami/cassandra:latest
```
In the above command the container is added to a cluster named `cassandra-cluster` using the `CASSANDRA_CLUSTER_NAME`. The `CASSANDRA_CLUSTER_HOSTS` parameter set the name of the nodes that set the cluster so we will need to launch other container for the second node. Finally the `CASSANDRA_NODE_NAME` parameter allows to indicate a known name for the node, otherwise cassandra will generate a randon one.


### Step 3: Create a second node

```bash
docker run --name cassandra-node2 \
  --net=cassandra_network \
  -e CASSANDRA_CLUSTER_NAME=cassandra-cluster \
  -e CASSANDRA_SEEDS=cassandra-node1,cassandra-node2 \
  bitnami/cassandra:latest
```

In the above command a new cassandra node is being added to the cassandra cluster indicated by `CASSANDRA_CLUSTER_NAME`.

You now have a two node Cassandra cluster up and running which can be scaled by adding/removing nodes.

With Docker Compose the cluster configuration can be setup using:

```yaml
version: '2'
services:
  cassandra-node1:
    image: bitnami/cassandra:latest
    environment:
      - CASSANDRA_CLUSTER_NAME=cassandra-cluster
      - CASSANDRA_SEEDS=cassandra-node1,cassandra-node2

  cassandra-node2:
    image: bitnami/cassandra:latest
    environment:
      - CASSANDRA_CLUSTER_NAME=cassandra-cluster
      - CASSANDRA_SEEDS=cassandra-node1,cassandra-node2
```

## Configuration file

The image looks for configuration in the `conf/` directory of `/bitnami/cassandra`. As as mentioned in [Persisting your application](#persisting-your-application) you can mount a volume at this location and copy your own configurations in the `conf/` directory. The default configuration will be copied to the `conf/` directory if it's empty.

### Step 1: Run the Cassandra image

Run the Cassandra image, mounting a directory from your host.

```bash
docker run --name cassandra -v /path/to/cassandra-persistence:/bitnami/cassandra bitnami/cassandra:latest
```

or using Docker Compose:

```
cassandra:
  image: bitnami/cassandra:latest
  volumes:
    - /path/to/cassandra-persistence:/bitnami/cassandra
```

### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```bash
vi /path/to/cassandra-persistence/conf/cassandra.yaml
```

### Step 3: Restart Cassandra

After changing the configuration, restart your Cassandra container for changes to take effect.

```bash
docker restart cassandra
```

or using Docker Compose:

```bash
docker-compose restart cassandra
```

**Further Reading:**

  - [Cassandra Configuration Documentation](http://docs.datastax.com/en/cassandra/3.x/cassandra/configuration/configTOC.html)

# Logging

The Bitnami Cassandra Docker image sends the container logs to the `stdout`. To view the logs:

```bash
docker logs cassandra
```

or using Docker Compose:

```bash
docker-compose logs cassandra
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Backing up your container

To backup your data, configuration and logs, follow these simple steps:

### Step 1: Stop the currently running container

```bash
docker stop cassandra
```

or using Docker Compose:

```bash
docker-compose stop cassandra
```

### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```bash
docker run --rm -v /path/to/cassandra-backups:/backups --volumes-from cassandra busybox \
  cp -a /bitnami/cassandra:latest /backups/latest
```

or using Docker Compose:

```bash
docker run --rm -v /path/to/cassandra-backups:/backups --volumes-from `docker-compose ps -q cassandra` busybox \
  cp -a /bitnami/cassandra:latest /backups/latest
```

## Restoring a backup

Restoring a backup is as simple as mounting the backup as volumes in the container.

```bash
docker run -v /path/to/cassandra-backups/latest:/bitnami/cassandra bitnami/cassandra:latest
```

or using Docker Compose:

```
cassandra:
  image: bitnami/cassandra:latest
  volumes:
    - /path/to/cassandra-backups/latest:/bitnami/cassandra
```

## Upgrade this image

Bitnami provides up-to-date versions of Cassandra, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
docker pull bitnami/cassandra:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/cassandra:latest`.

### Step 2: Stop and backup the currently running container

Before continuing, you should backup your container's data, configuration and logs.

Follow the steps on [creating a backup](#backing-up-your-container).

### Step 3: Remove the currently running container

```bash
docker rm -v cassandra
```

or using Docker Compose:

```bash
docker-compose rm -v cassandra
```

### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if necessary.

```bash
docker run --name cassandra bitnami/cassandra:latest
```

or using Docker Compose:

```bash
docker-compose start cassandra
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-cassandra/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-cassandra/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-cassandra/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License
Copyright (c) 2016 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
