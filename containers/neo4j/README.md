# What is Neo4j?

> Neo4j is the world’s leading Graph Database. It is a high performance graph store with all the features expected of a mature and robust database, like a friendly query language and ACID transactions. The programmer works with a flexible network structure of nodes and relationships rather than static tables — yet enjoys all the benefits of enterprise-quality database. For many applications, Neo4j offers orders of magnitude performance benefits compared to relational DBs.


[https://neo4j.com](https://neo4j.com)

# TL;DR

```console
$ docker run --name neo4j bitnami/neo4j:latest
```

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-neo4j/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

You can find the default credentials and available configuration options in the [Environment Variables](#environment-variables) section.

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/neo4j?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`4`, `4-debian-10`, `4.2.2`, `4.2.2-debian-10-r37`, `latest` (4/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-neo4j/blob/4.2.2-debian-10-r37/4/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/neo4j GitHub repo](https://github.com/bitnami/bitnami-docker-neo4j).

# Get this image

The recommended way to get the Bitnami Neo4j Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/neo4j).

```console
$ docker pull bitnami/neo4j:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/neo4j/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/neo4j:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/neo4j:latest 'https://github.com/bitnami/bitnami-docker-neo4j.git#master:4/debian-10'
```

# Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. The above examples define a docker volume namely `neo4j_data`. The Neo4j application state will persist as long as this volume is not removed.

To avoid inadvertent removal of this volume you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

```console
$ docker run -v /path/to/neo4j-persistence:/bitnami bitnami/neo4j:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-neo4j/blob/master/docker-compose.yml) file present in this repository:

```yaml
neo4j:
  ...
  volumes:
    - /path/to/neo4j-persistence:/bitnami
  ...
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

### Step 1: Create a network

```console
$ docker network create neo4j-network --driver bridge
```

### Step 2: Launch the Neo4j container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `neo4j-network` network.

```console
$ docker run --name neo4j-node1 --network neo4j-network bitnami/neo4j:latest
```

### Step 3: Run another containers

We can launch another containers using the same flag (`--network NETWORK`) in the `docker run` command. If you also set a name to your container, you will be able to use it as hostname in your network.

## Using Docker Compose

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new bridge network named neo4j-network.

```yaml
version: '2'

networks:
  neo4j-network:
    driver: bridge

services:
  neo4j:
    image: bitnami/neo4j:latest
    networks:
      - neo4j-network
    ports:
      - '7474:7474'
      - '7473:7473'
      - '7687:7687'
```

Then, launch the containers using:

```console
$ docker-compose up -d
```

# Configuration

## Environment variables

When you start the neo4j image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. The following environment values are provided to custom Neo4j:

- `NEO4J_PASSWORD`: Password used by Neo4j server. Default: **bitnami**
- `NEO4J_HOST`: Hostname used to configure Neo4j advertised address. It can be either an IP or a domain. If left empty, it will be resolved to the machine IP. Default: **empty**
- `NEO4J_BOLT_PORT_NUMBER`: Port used by Neo4j https. Default: **7687**
- `NEO4J_HTTP_PORT_NUMBER`: Port used by Neo4j http. Default: **7474**
- `NEO4J_HTTPS_PORT_NUMBER`: Port used by Neo4j https. Default: **7473**

### Specifying Environment Variables using Docker Compose

Modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-neo4j/blob/master/docker-compose.yml) file present in this repository:

```yaml
neo4j:
  ...
  environment:
    - NEO4J_BOLT_PORT_NUMBER=7777
  ...
```

### Specifying Environment Variables on the Docker command line

```console
$ docker run -d -e NEO4J_BOLT_PORT_NUMBER=7777 --name neo4j bitnami/n3o4j:latest
```

## Using your Neo4j configuration files

In order to load your own configuration files, you will have to make them available to the container. You can do it mounting a [volume](https://docs.docker.com/engine/tutorials/dockervolumes/) in the desired location.

### Using Docker Compose

Modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-neo4j/blob/master/docker-compose.yml) file present in this repository:

```yaml
neo4j:
  ...
  volumes:
    - '/local/path/to/your/confDir:/container/path/to/your/confDir'
  ...
```

# Logging

The Bitnami neo4j Docker image sends the container logs to the `stdout`. To view the logs:

```console
$ docker logs neo4j
```

or using Docker Compose:

```console
$ docker-compose logs neo4j
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of neo4j, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```console
$ docker pull bitnami/neo4j:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/neo4j:latest`.

### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
$ docker stop neo4j
```

or using Docker Compose:

```console
$ docker-compose stop neo4j
```

Next, take a snapshot of the persistent volume `/path/to/neo4j-persistence` using:

```console
$ rsync -a /path/to/neo4j-persistence /path/to/neo4j-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

You can use this snapshot to restore the database state should the upgrade fail.

### Step 3: Remove the currently running container

```console
$ docker rm -v neo4j
```

or using Docker Compose:

```console
$ docker-compose rm -v neo4j
```

### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if necessary.

```console
$ docker run --name neo4j bitnami/neo4j:latest
```

or using Docker Compose:

```console
$ docker-compose up neo4j
```

# Notable Changes

## 3.4.3-r13

- The Neo4j container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the Neo4j daemon was started as the `neo4j` user. From now on, both the container and the Neo4j daemon run as user `1001`. As a consequence, the data directory must be writable by that user. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-neo4j/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-neo4j/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-neo4j/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License
Copyright 2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
