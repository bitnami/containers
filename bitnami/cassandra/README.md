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

# Linking

If you want to connect to your Cassandra server inside another container, you can use the linking system provided by Docker.

## Connecting a Cassandra client container to the Cassandra server container

### Step 1: Run the Cassandra image with a specific name

The first step is to start our Cassandra server.

Docker's linking system uses container ids or names to reference containers. We can explicitly
specify a name for our Cassandra server to make it easier to connect to other containers.

```bash
docker run --name cassandra bitnami/cassandra:latest
```

### Step 2: Run Cassandra as a client and link to our server

Now that we have our Cassandra server running, we can create another container that links to it by
giving Docker the `--link` option. This option takes the id or name of the container we want to link
it to as well as a hostname to use inside the container, separated by a colon. For example, to have
our Cassandra server accessible in another container with `server` as it's hostname we would pass
`--link cassandra:server` to the Docker run command.

The Bitnami Cassandra Docker Image also ships with a Cassandra client, but by default it will start a
server. To start the client instead, we can override the default command Docker runs by stating a
different command to run after the image name.

```bash
docker run --rm -it --link cassandra:server bitnami/cassandra cqlsh server
```

We started the Cassandra client passing the hostname of the server, which we set to the hostname we
created in the link.

**Note!**
You can also run the Cassandra client in the same container the server is running in using the Docker
[exec](https://docs.docker.com/reference/commandline/cli/#exec) command.

```bash
docker exec -it cassandra-server cqlsh
```

## Linking with Docker Compose

### Step 1: Add a Cassandra entry in your `docker-compose.yml`

Copy the snippet below into your `docker-compose.yml` to add Cassandra to your application.

```
cassandra:
  image: bitnami/cassandra:latest
```

### Step 2: Link it to another container in your application

Update the definitions for containers you want to access your Cassandra server from to include a link to the `cassandra` entry you added in Step 1.

```
myapp:
  image: myapp
  links:
    - cassandra:cassandra
```

Inside `myapp`, use `cassandra` as the hostname for the Cassandra server.

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
