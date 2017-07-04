[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-zookeeper/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-zookeeper/tree/master)
[![Slack](https://img.shields.io/badge/slack-join%20chat%20%E2%86%92-e01563.svg)](http://slack.oss.bitnami.com)

# What is zookeeper?

>ZooKeeper is a centralized service for maintaining configuration information, naming, providing distributed synchronization, and providing group services. All of these kinds of services are used in some form or other by distributed applications.

[https://zookeeper.apache.org/](https://zookeeper.apache.org/)

# TL;DR;

```bash
$ docker run --name zookeeper bitnami/zookeeper:latest
```

## Docker Compose

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-zookeeper/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

## Kubernetes

> **WARNING:** This is a beta configuration, currently unsupported.

Get the raw URL pointing to the `kubernetes.yml` manifest and use `kubectl` to create the resources on your Kubernetes cluster like so:

```bash
$ kubectl create -f https://raw.githubusercontent.com/bitnami/bitnami-docker-zookeeper/master/kubernetes.yml
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* Bitnami images are built on CircleCI and automatically pushed to the Docker Hub.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.

# Get this image

The recommended way to get the Bitnami Zookeeper Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/zookeeper).

```bash
$ docker pull bitnami/zookeeper:latest
```

To use a specific version, you can pull a versioned tag. You can view the
[list of available versions](https://hub.docker.com/r/bitnami/zookeeper/tags/)
in the Docker Hub Registry.

```bash
$ docker pull bitnami/zookeeper:[TAG]
```

If you wish, you can also build the image yourself.

```bash
$ docker build -t bitnami/zookeeper:latest https://github.com/bitnami/bitnami-docker-zookeeper.git
```

# Persisting your data

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami` path. If the mounted directory is empty, it will be initialized on the first run.

```bash
$ docker run \
  -v /path/to/zookeeper-persistence:/bitnami \
  bitnami/zookeeper:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  zookeeper:
    image: 'bitnami/zookeeper:latest'
    ports:
      - '2181:2181'
    volumes:
      - /path/to/zookeeper-persistence:/bitnami
```

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a Zookeeper server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

In this example, we will create a Zookeeper client instance that will connect to the server instance that is running on the same docker network as the client.

### Step 1: Create a network

```bash
$ docker network create app-tier --driver bridge
```

### Step 2: Launch the Zookeeper server instance

Use the `--network app-tier` argument to the `docker run` command to attach the Zookeeper container to the `app-tier` network.

```bash
$ docker run -d --name zookeeper-server \
    --network app-tier \
    bitnami/zookeeper:latest
```

### Step 3: Launch your Zookeeper client instance

Finally we create a new container instance to launch the Zookeeper client and connect to the server created in the previous step:

```bash
$ docker run -it --rm \
    --network app-tier \
    bitnami/zookeeper:latest zkCli.sh -server zookeeper-server:2181  get /
```

## Using Docker Compose

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `app-tier`. In this example we assume that you want to connect to the Zookeeper server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge

services:
  zookeeper:
    image: 'bitnami/zookeeper:latest'
    networks:
      - app-tier
  myapp:
    image: 'YOUR_APPLICATION_IMAGE'
    networks:
      - app-tier
```

> **IMPORTANT**:
>
> 1. Please update the `YOUR_APPLICATION_IMAGE` placeholder in the above snippet with your application image
> 2. In your application container, use the hostname `zookeeper` to connect to the Zookeeper server

Launch the containers using:

```bash
$ docker-compose up -d
```

# Configuration

The configuration can easily be setup with the Bitnami Zookeeper Docker image using the following environment variables:

 - `ZOO_PORT_NUMBER`: Zookeeper client port. Default: 2181
 - `ZOO_SERVER_ID`: ID of the server in the ensemble. Default: 1
 - `ZOO_TICK_TIME`: Basic time unit in milliseconds used by ZooKeeper for heartbeats. Default: 2000
 - `ZOO_INIT_LIMIT`: ZooKeeper uses to limit the length of time the ZooKeeper servers in quorum have to connect to a leader. Default: 10
 - `ZOO_SYNC_LIMIT`: How far out of date a server can be from a leader. Default: 5
 - `ZOO_SERVERS`: Comma, space or colon separated list of servers. Example: server.1=zoo1:2888:3888,server.2=zoo2:2888:3888. No defaults.

```bash
$ docker run --name zookeeper -e ZOO_SERVER_ID=1 bitnami/zookeeper:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  zookeeper:
    image: 'bitnami/zookeeper:latest'
    ports:
      - '2181:2181'
    environment:
      - ZOO_SERVER_ID=1
```

## Configuration file

The image looks for configurations in `/bitnami/zookeeper/conf/`. As mentioned in [Persisting your data](#persisting-your-data) you can mount a volume at `/bitnami` and copy/edit the configurations in the `/path/to/zookeeper-persistence/zookeeper/conf/`. The default configurations will be populated to the `conf/` directory if it's empty.

```bash
$ docker run --name zookeeper \
    -v /path/to/my_custom_conf_directory:/bitnami \
    bitnami/zookeeper:latest
```

After that, your changes will be taken into account in the server's behaviour.

### Step 1: Run the Zookeeper image

Run the Zookeeper image, mounting a directory from your host.

```bash
$ docker run --name zookeeper \
    -v /path/to/zookeeper-persistence:/bitnami \
    bitnami/zookeeper:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  zookeeper:
    image: 'bitnami/zookeeper:latest'
    ports:
      - '2181:2181'
    volumes:
      - /path/to/zookeeper-persistence:/bitnami
```

### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```bash
$ vi /path/to/zookeeper-persistence/conf/zoo.cfg
```

### Step 3: Restart Zookeeper

After changing the configuration, restart your Zookeeper container for changes to take effect.

```bash
$ docker restart zookeeper
```

or using Docker Compose:

```bash
$ docker-compose restart zookeeper
```


# Logging

The Bitnami Zookeeper Docker image sends the container logs to the `stdout`. To view the logs:

```bash
$ docker logs zookeeper
```

or using Docker Compose:

```bash
$ docker-compose logs zookeeper
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of Zookeeper, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
$ docker pull bitnami/zookeeper:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/zookeeper:latest`.

### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```bash
$ docker stop zookeeper
```

or using Docker Compose:

```bash
$ docker-compose stop zookeeper
```

Next, take a snapshot of the persistent volume `/path/to/zookeeper-persistence` using:

```bash
$ rsync -a /path/to/zookeeper-persistence /path/to/zookeeper-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

You can use this snapshot to restore the database state should the upgrade fail.

### Step 3: Remove the currently running container

```bash
$ docker rm -v zookeeper
```

or using Docker Compose:

```bash
$ docker-compose rm -v zookeeper
```

### Step 4: Run the new image

Re-create your container from the new image.

```bash
$ docker run --name zookeeper bitnami/zookeeper:latest
```

or using Docker Compose:

```bash
$ docker-compose start zookeeper
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-zookeeper/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-zookeeper/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-zookeeper/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# Community

Most real time communication happens in the `#containers` channel at [bitnami-oss.slack.com](http://bitnami-oss.slack.com); you can sign up at [slack.oss.bitnami.com](http://slack.oss.bitnami.com).

Discussions are archived at [bitnami-oss.slackarchive.io](https://bitnami-oss.slackarchive.io).

# License

Copyright 2017 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

