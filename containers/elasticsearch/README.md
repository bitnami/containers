[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-elasticsearch/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-elasticsearch/tree/master)

# What is Elasticsearch?

> Elasticsearch is a highly scalable open-source full-text search and analytics engine. It allows you to store, search, and analyze big volumes of data quickly and in near real time

[elastic.co/products/elasticsearch](https://www.elastic.co/products/elasticsearch)

# TL;DR

```bash
$ docker run --name elasticsearch bitnami/elasticsearch:latest
```

## Docker Compose

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-elasticsearch/master/docker-compose.yml > docker-compose.yml
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


* [`6-ol-7`, `6.3.2-ol-7-r1` (6/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-elasticsearch/blob/6.3.2-ol-7-r1/6/ol-7/Dockerfile)
* [`6-debian-9`, `6.3.2-debian-9-r2`, `6`, `6.3.2`, `6.3.2-r2`, `latest` (6/Dockerfile)](https://github.com/bitnami/bitnami-docker-elasticsearch/blob/6.3.2-debian-9-r2/6/Dockerfile)
* [`5-ol-7`, `5.6.4-ol-7-r22` (5/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-elasticsearch/blob/5.6.4-ol-7-r22/5/ol-7/Dockerfile)
* [`5-debian-9`, `5.6.4-debian-9-r12`, `5`, `5.6.4`, `5.6.4-r12` (5/Dockerfile)](https://github.com/bitnami/bitnami-docker-elasticsearch/blob/5.6.4-debian-9-r12/5/Dockerfile)

Subscribe to project updates by watching the [bitnami/elasticsearch GitHub repo](https://github.com/bitnami/bitnami-docker-elasticsearch).
# Get this image

The recommended way to get the Bitnami Elasticsearch Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/elasticsearch).

```bash
$ docker pull bitnami/elasticsearch:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/elasticsearch/tags/) in the Docker Hub Registry.

```bash
$ docker pull bitnami/elasticsearch:[TAG]
```

If you wish, you can also build the image yourself.

```bash
$ docker build -t bitnami/elasticsearch:latest https://github.com/bitnami/bitnami-docker-elasticsearch.git
```

# Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the application will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami` path. If the mounted directory is empty, it will be initialized on the first run.

```bash
$ docker run \
    -v /path/to/elasticsearch-persistence:/bitnami/elasticsearch \
    bitnami/elasticsearch:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  mariadb:
    image: bitnami/elasticsearch:latest
    volumes:
      - /path/to/mariadb-persistence:/bitnami
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
    - ELASTICSEARCH_PORT_NUMBER=9201
```

 * For manual execution add a `-e` option with each variable and value:

```bash
 $ docker run -d --name elasticsearch \
    -p 9201:9201 --network=elasticsearch_network \
    -e ELASTICSEARCH_PORT_NUMBER=9201 \
    -v /your/local/path/bitnami/elasticsearch:/bitnami/elasticsearch \
    bitnami/elasticsearch
```

Available variables:

 - `ELASTICSEARCH_CLUSTER_NAME`: The Elasticsearch Cluster Name. Default: **elasticsearch-cluster**
 - `ELASTICSEARCH_CLUSTER_HOSTS`: List of elasticsearch hosts to set the cluster. Available separatos are ' ', ',' and ';'. No defaults.
 - `ELASTICSEARCH_IS_DEDICATED_NODE`: Elasticsearch node to behave as a 'dedicated node'. Default: **no**
 - `ELASTICSEARCH_NODE_TYPE`: Elasticsearch node type when behaving as a 'dedicated node'. Valid values: *master*, *data*, *coordinating* or *ingest*.
 - `ELASTICSEARCH_NODE_NAME`: Elasticsearch node name. No defaults.
 - `ELASTICSEARCH_BIND_ADDRESS`: Address/interface to bind by Elasticsearch. Default: **0.0.0.0**
 - `ELASTICSEARCH_PORT_NUMBER`: Elasticsearch port. Default: **9200**
 - `ELASTICSEARCH_NODE_PORT_NUMBER`: Elasticsearch Node to Node port. Default: **9300**
 - `ELASTICSEARCH_PLUGINS`: Comma, semi-colon or space separated list of plugins to install at initialization. No defaults.
 - `ELASTICSEARCH_HEAP_SIZE`: Memory used for the Xmx and Xms java heap values. Defaults to half of the host RAM.

## Setting up a cluster

A cluster can easily be setup with the Bitnami Elasticsearch Docker Image using the following environment variables:

 - `ELASTICSEARCH_CLUSTER_NAME`: The Elasticsearch Cluster Name. Default: **elasticsearch-cluster**
 - `ELASTICSEARCH_CLUSTER_HOSTS`: List of elasticsearch hosts to set the cluster. Available separatos are ' ', ',' and ';' .No defaults.
 - `ELASTICSEARCH_CLIENT_NODE`: Elasticsearch node to behave as a 'smart router' for Kibana app. Default: **false**
 - `ELASTICSEARCH_NODE_NAME`: Elasticsearch node name. No defaults.

For larger cluster, you can setup 'dedicated nodes' using the following environment variables:

 - `ELASTICSEARCH_IS_DEDICATED_NODE`: Elasticsearch node to behave as a 'dedicated node'. Default: **no**
 - `ELASTICSEARCH_NODE_TYPE`: Elasticsearch node type when behaving as a 'dedicated node'. Valid values: *master*, *data*, *coordinating* or *ingest*.

Find more information about 'dedicated nodes' in the [official documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-node.html).

### Step 1: Create a new network.

```bash
$ docker network create elasticsearch_network
```

### Step 2: Create a first node.

```bash
$ docker run --name elasticsearch-node1 \
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
$ docker run --name elasticsearch-node2 \
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

The image looks for user-defined configurations in `/bitnami/elasticsearch/conf/elasticsearch_custom.yml`. Create a file named `elasticsearch_custom.yml`  and mount it at `/bitnami/elasticsearch/conf/elasticsearch_custom.yml` to extend the default configuration.

# Logging

The Bitnami Elasticsearch Docker image sends the container logs to the `stdout`. To view the logs:

```bash
$ docker logs elasticsearch
```

or using Docker Compose:

```bash
$ docker-compose logs elasticsearch
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of Elasticsearch, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
$ docker pull bitnami/elasticsearch:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/elasticsearch:latest`.

### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```bash
$ docker stop elasticsearch
```

or using Docker Compose:

```bash
$ docker-compose stop elasticsearch
```

Next, take a snapshot of the persistent volume `/path/to/elasticsearch-persistence` using:

```bash
$ rsync -a /path/to/elasticsearch-persistence /path/to/elasticsearch-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

You can use this snapshot to restore the application state should the upgrade fail.

### Step 3: Remove the currently running container

```bash
$ docker rm -v elasticsearch
```

or using Docker Compose:

```bash
$ docker-compose rm -v elasticsearch
```

### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if necessary.

```bash
$ docker run --name elasticsearch bitnami/elasticsearch:latest
```

or using Docker Compose:

```bash
$ docker-compose up elasticsearch
```

# Notable Changes

## 6.2.3-r2 & 5.6.4-r6

- Elasticsearch container can be configured as a dedicated node with 4 different types: *master*, *data*, *coordinating* or *ingest*.
  Previously it was only achievable by using a custom `elasticsearch_custom.yml` file. From now on, you can use the environment variables `ELASTICSEARCH_IS_DEDICATED_NODE` & `ELASTICSEARCH_NODE_TYPE` to configure it.

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
Copyright 2016-2018 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
