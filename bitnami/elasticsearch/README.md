[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-elasticsearch/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-elasticsearch/tree/master)
[![Docker Hub Automated Build](http://container.checkforupdates.com/badges/bitnami/elasticsearch)](https://hub.docker.com/r/bitnami/elasticsearch/)
# What is Elasticsearch?

> Elasticsearch is a highly scalable open-source full-text search and analytics engine. It allows you to store, search, and analyze big volumes of data quickly and in near real time

[elastic.co/products/elasticsearch](https://www.elastic.co/products/elasticsearch)

# TLDR

```bash
docker run --name elasticsearch bitnami/elasticsearch:latest
```

## Docker Compose

```
elasticsearch:
  image: bitnami/elasticsearch:latest
```

# Get this image

The recommended way to get the Bitnami Elasticsearch Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/elasticsearch).

```bash
docker pull bitnami/elasticsearch:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/elasticsearch/tags/) in the Docker Hub Registry.

```bash
docker pull bitnami/elasticsearch:[TAG]
```

If you wish, you can also build the image yourself.

```bash
docker build -t bitnami/elasticsearch:latest https://github.com/bitnami/bitnami-docker-elasticsearch.git
```

# Persisting your application

If you remove every container and volume all your data will be lost, and the next time you run the image the application will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed. If you are using docker-compose your data will be persistent as long as you don't remove `elasticsearch_data` data volumes. If you have run the containers manually or you want to mount the folders with persistent data in your host follow the next steps:

> **Note!** If you have already started using your application, follow the steps on [backing](#backing-up-your-container) up to pull the data from your running container down to your host.

The image exposes a volume at `/bitnami/elasticsearch` for the Elasticsearch data and configurations. For persistence you can mount a directory at this location from your host. If the mounted directory is empty, it will be initialized on the first run.

```bash
docker run -v /path/to/elasticsearch-persistence:/bitnami/elasticsearch bitnami/elasticsearch:latest
```

or using Docker Compose:

```
elasticsearch:
  image: bitnami/elasticsearch:latest
  volumes:
    - /path/to/elasticsearch-persistence:/bitnami/elasticsearch
```

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a Elasticsearch server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

### Step 1: Create a network

```bash
$ docker network create app-tier --driver bridge
```

### Step 2: Launch the Elasticsearch server instance

Use the `--network app-tier` argument to the `docker run` command to attach the Elasticsearch container to the `app-tier` network.

```bash
$ docker run -d --name elasticsearch-server \
    --network app-tier \
    bitnami/elasticsearch:latest
```

### Step 3: Launch your application container

```bash
$ docker run -d --name myapp \
    --network app-tier \
    YOUR_APPLICATION_IMAGE
```

> **IMPORTANT**:
>
> 1. Please update the **YOUR_APPLICATION_IMAGE_** placeholder in the above snippet with your application image
> 2. In your application container, use the hostname `elasticsearch-server` to connect to the Elasticsearch server

## Using Docker Compose

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `app-tier`. In this example we assume that you want to connect to the Elasticsearch server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge

services:
  elasticsearch:
    image: 'bitnami/elasticsearch:latest'
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
> 2. In your application container, use the hostname `elasticsearch` to connect to the Elasticsearch server

Launch the containers using:

```bash
$ docker-compose up -d
```

# Configuration

## Environment variables
 When you start the elasticsearch image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the docker run command line. If you want to add a new environment variable:

 * For docker-compose add the variable name and value under the application section:
```yaml
elasticsearch:
  image: bitnami/elasticsearch:latest
  environment:
    - ELASTICSEARCH_PORT=9201
```

 * For manual execution add a `-e` option with each variable and value:

```
 $ docker run -d -e ELASTICSEARCH_PORT=9201 -p 9201:9201 --name elasticsearch -v /your/local/path/bitnami/elasticsearch:/bitnami/elasticsearch --network=elasticsearch_network bitnami/elasticsearch
```

Available variables:

 - `ELASTICSEARCH_PORT`: Elasticsearch port. Default: **9200**
 - `ELASTICSEARCH_NODEPORT`: Elasticsearch Node to Node port. Default: **9300**
 - `ELASTICSEARCH_CLUSTER_NAME`: The Elasticsearch Cluster Name. Default: **elasticsearch-cluster**
 - `ELASTICSEARCH_CLUSTER_HOSTS`: List of elasticsearch hosts to set the cluster. Available separatos are ' ', ',' and ';' .No defaults.
 - `ELASTICSEARCH_CLIENT_NODE`: Elasticsearch node to behave as a 'smart router' for Kibana app. Default: **false**
 - `ELASTICSEARCH_NODE_NAME`: Elasticsearch node name. No defaults.

## Setting up a cluster

A cluster can easily be setup with the Bitnami Elasticsearch Docker Image using the following environment variables

 - `ELASTICSEARCH_CLUSTER_NAME`: The Elasticsearch Cluster Name. Default: **elasticsearch-cluster**
 - `ELASTICSEARCH_CLUSTER_HOSTS`: List of elasticsearch hosts to set the cluster. Available separatos are ' ', ',' and ';' .No defaults.
 - `ELASTICSEARCH_CLIENT_NODE`: Elasticsearch node to behave as a 'smart router' for Kibana app. Default: **false**
 - `ELASTICSEARCH_NODE_NAME`: Elasticsearch node name. No defaults.

### Step 1: Create a new network.

```bash
docker network create elasticsearch_network
```

### Step 2: Create a first node.

```bash
docker run --name elasticsearch-node1 \
  --net=elasticsearch_network \
  -p 9200:9200 \
  -e ELASTICSEARCH_CLUSTER_NAME=elasticsearch-cluster \
  -e ELASTICSEARCH_CLUSTER_HOSTS=elasticsearch-node1,elasticsearch-node2 \
  -e ELASTICSEARCH_NODE_NAME=elastic-node1 \
  bitnami/elasticsearch:latest
```
In the above command the container is added to a cluster named `elasticsearch-cluster` using the `ELASTICSEARCH_CLUSTER_NAME`. The `ELASTICSEARCH_CLUSTER_HOSTS` parameter set the name of the nodes that set the cluster so we will need to launch other container for the second node. Finally the `ELASTICSEARCH_NODE_NAME` parameter allows to indicate a known name for the node, otherwise elasticsearch will generate a randon one.


### Step 3: Create a second node

```bash
docker run --name elasticsearch-node2 \
  --link elasticsearch-node1:elasticsearch-node1 \
  --net=elasticsearch_network \
  -e ELASTICSEARCH_CLUSTER_NAME=elasticsearch-cluster \
  -e ELASTICSEARCH_CLUSTER_HOSTS=elasticsearch-node1,elasticsearch-node2 \
  -e ELASTICSEARCH_NODE_NAME=elastic-node2 \
  bitnami/elasticsearch:latest
```

In the above command a new elasticsearch node is being added to the elasticsearch cluster indicated by `ELASTICSEARCH_CLUSTER_NAME`.

You now have a two node Elasticsearch cluster up and running which can be scaled by adding/removing nodes.

With Docker Compose the cluster configuration can be setup using:

```yaml
version: '2'
services:
  elasticsearch-node1:
    image: bitnami/elasticsearch:latest
    environment:
      - ELASTICSEARCH_CLUSTER_NAME=elasticsearch-cluster
      - ELASTICSEARCH_CLUSTER_HOSTS=elasticsearch-node1,elasticsearch-node2
      - ELASTICSEARCH_NODE_NAME=elastic-node1

  elasticsearch-node2:
    image: bitnami/elasticsearch:latest
    environment:
      - ELASTICSEARCH_CLUSTER_NAME=elasticsearch-cluster
      - ELASTICSEARCH_CLUSTER_HOSTS=elasticsearch-node1,elasticsearch-node2
      - ELASTICSEARCH_NODE_NAME=elastic-node2
```
## Configuration file

The image looks for configuration in the `conf/` directory of `/bitnami/elasticsearch`. As mentioned in [Persisting your database](#persisting-your-data) you can mount a volume at this location and copy your own configurations in the `conf/` directory. The default configuration will be copied to the `conf/` directory if it's empty.


# Logging

The Bitnami Elasticsearch Docker image sends the container logs to the `stdout`. To view the logs:

```bash
docker logs elasticsearch
```

or using Docker Compose:

```bash
docker-compose logs elasticsearch
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Backing up your container

To backup your data, configuration and logs, follow these simple steps:

### Step 1: Stop the currently running container

```bash
docker stop elasticsearch
```

or using Docker Compose:

```bash
docker-compose stop elasticsearch
```

### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```bash
docker run --rm -v /path/to/elasticsearch-backups:/backups --volumes-from elasticsearch busybox \
  cp -a /bitnami/elasticsearch:latest /backups/latest
```

or using Docker Compose:

```bash
docker run --rm -v /path/to/elasticsearch-backups:/backups --volumes-from `docker-compose ps -q elasticsearch` busybox \
  cp -a /bitnami/elasticsearch:latest /backups/latest
```

## Restoring a backup

Restoring a backup is as simple as mounting the backup as volumes in the container.

```bash
docker run -v /path/to/elasticsearch-backups/latest:/bitnami/elasticsearch bitnami/elasticsearch:latest
```

or using Docker Compose:

```
elasticsearch:
  image: bitnami/elasticsearch:latest
  volumes:
    - /path/to/elasticsearch-backups/latest:/bitnami/elasticsearch
```

## Upgrade this image

Bitnami provides up-to-date versions of Elasticsearch, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
docker pull bitnami/elasticsearch:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/elasticsearch:latest`.

### Step 2: Stop and backup the currently running container

Before continuing, you should backup your container's data, configuration and logs.

Follow the steps on [creating a backup](#backing-up-your-container).

### Step 3: Remove the currently running container

```bash
docker rm -v elasticsearch
```

or using Docker Compose:

```bash
docker-compose rm -v elasticsearch
```

### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if necessary.

```bash
docker run --name elasticsearch bitnami/elasticsearch:latest
```

or using Docker Compose:

```bash
docker-compose start elasticsearch
```
# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-elasticsearch/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-elasticsearch/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-elasticsearch/issues). For us to provide better support, be sure to include the following information in your issue:

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
