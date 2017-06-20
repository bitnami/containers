[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-kafka/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-kafka/tree/master)
[![Docker Hub Automated Build](http://container.checkforupdates.com/badges/bitnami/kafka)](https://hub.docker.com/r/bitnami/kafka/)
[![Slack](http://slack.oss.bitnami.com/badge.svg)](http://slack.oss.bitnami.com)

# What is kafka?
Apache Kafka is a distributed streaming platform used for building real-time data pipelines and
streaming apps. It is horizontally scalable, fault-tolerant, wicked fast, and runs in production in
thousands of companies. Kafka requires a connection to a Zookeeper service.


[https://kafka.apache.org/](https://kafka.apache.org/)


# TL;DR;

## Docker Compose

```yaml
version: '2'

services:
  zookeeper:
    image: 'bitnami/zookeeper:latest'
    ports:
      - '2181:2181'
    volumes:
      - 'zookeeper_data:/bitnami/zookeeper'
  kafka:
    image: 'bitnami/kafka:0'
    ports:
      - '9092:9092'
    volumes:
      - 'kafka_data:/bitnami/kafka'
    environment:
      - KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181

volumes:
  zookeeper_data:
    driver: local
  kafka_data:
    driver: local
```

## Kubernetes

> **WARNING:** This is a beta configuration, currently unsupported.

Get the raw URL pointing to the kubernetes.yml manifest and use kubectl to create the resources on your Kubernetes cluster like so:

```bash
$ kubectl create -f https://raw.githubusercontent.com/bitnami/bitnami-docker-kafka/master/kubernetes.yml
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* Bitnami images are built on CircleCI and automatically pushed to the Docker Hub.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.

# Get this image

The recommended way to get the Bitnami Kafka Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/kafka).

```bash
docker pull bitnami/kafka:latest
```

To use a specific version, you can pull a versioned tag. You can view the
[list of available versions](https://hub.docker.com/r/bitnami/kafka/tags/)
in the Docker Hub Registry.

```bash
docker pull bitnami/kafka:[TAG]
```

If you wish, you can also build the image yourself.

```bash
docker build -t bitnami/kafka:latest https://github.com/bitnami/bitnami-docker-kafka.git
```

# Persisting your data

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

**Note!**
If you have already started using your database, follow the steps on
[backing up](#backing-up-your-container) and [restoring](#restoring-a-backup) to pull the data from your running container down to your host.

The image exposes a volume at `/bitnami/kafka` for the Kafka data and configurations. For persistence you can mount a directory at this location from your host. If the mounted directory is empty, it will be initialized on the first run.

Using Docker Compose:

```yaml
version: '2'

services:
  zookeeper:
    image: 'bitnami/zookeeper:latest'
    ports:
      - '2181:2181'
  kafka:
    image: 'bitnami/kafka:latest'
    ports:
      - '9092:9092'
    volumes:
      - /path/to/kafka-persistence:/bitnami/kafka
```

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a Kafka server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

In this example, we will create a Kafka client instance that will connect to the server instance that is running on the same docker network as the client.

### Step 1: Create a network

```bash
$ docker network create app-tier --driver bridge
```

### Step 2: Launch the Zookeeper server instance

Use the `--network app-tier` argument to the `docker run` command to attach the Zookeeper container to the `app-tier` network.

```bash
$ docker run -d --name zookeeker-server \
    --network app-tier \
    bitnami/zookeeper:latest
```

### Step 2: Launch the Kafka server instance

Use the `--network app-tier` argument to the `docker run` command to attach the Kafka container to the `app-tier` network.

```bash
$ docker run -d --name kafka-server \
    --network app-tier \
    -e KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181 \
    bitnami/kafka:latest
```

### Step 3: Launch your Kafka client instance

Finally we create a new container instance to launch the Kafka client and connect to the server created in the previous step:

```bash
$ docker run -it --rm \
    --network app-tier \
    -e KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181 \
    bitnami/kafka:latest kafka-topics.sh --list  --zookeeper zookeeper-server:2181
```

## Using Docker Compose

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `app-tier`. In this example we assume that you want to connect to the Kafka server from your own custom application image which is identified in the following snippet by the service name `myapp`.

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
  kafka:
    image: 'bitnami/kafka:latest'
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
> 2. In your application container, use the hostname `kafka` to connect to the Kafka server

Launch the containers using:

```bash
$ docker-compose up -d
```

# Configuration


The configuration can easily be setup with the Bitnami Kafka Docker image using the following environment variables:

- `KAFKA_PORT_NUMBER`: Kafka port.
- `KAFKA_BROKER_ID`: ID of the Kafka node.
- `KAFKA_NUM_NETWORK_THREADS`: The number of threads handling network requests.
- `KAFKA_NUM_IO_THREADS`: The number of threads doing disk I/O.
- `KAFKA_SOCKET_SEND_BUFFER_BYTES`: The send buffer (SO_SNDBUF) used by the socket server.
- `KAFKA_SOCKET_RECEIVE_BUFFER_BYTES`: The receive buffer (SO_RCVBUF) used by the socket server.
- `KAFKA_SOCKET_REQUEST_MAX_BYTES`: The maximum size of a request that the socket server will accept (protection against OOM).
- `KAFKA_LOGS_DIRS`: A comma separated list of directories under which to store log files.
- `KAFKA_DELETE_TOPIC_ENABLE`: Switch to enable topic deletion or not, default value is false.
- `KAFKA_LISTENERS`: The address the socket server listens on.
- `KAFKA_ADVERTISED_LISTENERS`: Hostname and port the broker will advertise to producers and consumers.
- `KAFKA_ADVERTISED_PORT`: Kafka port for advertising.
- `KAFKA_ADVERTISED_HOST_NAME`: Kafka hostname for advertising.
- `KAFKA_NUM_PARTITIONS`: The default number of log partitions per topic..
- `KAFKA_NUM_RECOVERY_THREADS_PER_DATA_DIR` The number of threads per data directory to be used for log recovery at startup and flushing at shutdown.
- `KAFKA_LOG_FLUSH_INTERVAL_MESSAGES`: The number of messages to accept before forcing a flush of data to disk..
- `KAFKA_LOG_FLUSH_INTERVAL_MS`: The maximum amount of time a message can sit in a log before we force a flush.
- `KAFKA_LOG_RETENTION_HOURS`: The minimum age of a log file to be eligible for deletion due to age.
- `KAFKA_LOG_RETENTION_BYTES`: A size-based retention policy for logs.
- `KAFKA_SEGMENT_BYTES`: The maximum size of a log segment file. When this size is reached a new log segment will be created.
- `KAFKA_LOG_RETENTION_CHECK_INTERVALS_MS`: The interval at which log segments are checked to see if they can be deleted.
- `KAFKA_ZOOKEEPER_CONNECT`: Comma separated host:port pairs, each corresponding to a Zookeeper Server.
- `KAFKA_ZOOKEEPER_CONNECT_TIMEOUT_MS`: Timeout in ms for connecting to zookeeper.


```bash
docker run --name kafka -e KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181 bitnami/kafka:latest
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
      - 'zookeeper_data:/bitnami/zookeeper'
  kafka:
    image: 'bitnami/kafka:0'
    ports:
      - '9092:9092'
    volumes:
      - 'kafka_data:/bitnami/kafka'
    environment:
      - KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181

volumes:
  zookeeper_data:
    driver: local
  kafka_data:
    driver: local
```

## Setting up a Kafka Cluster

A Kafka cluster can easily be setup with the Bitnami Kafka Docker image using the following environment variables:

 - `KAFKA_ZOOKEEPER_CONNECT`: Comma separated host:port pairs, each corresponding to a Zookeeper Server.


### Step 1: Create the first node for Zookeeper

The first step is to create one Zookeeper instance.

```bash
docker run --name zookeeper --link kafka1:kafka1  --link kafka2:kafka2 --link kafka3:kafka3 \
  -p 2181:2181 \
  bitnami/zookeeper:latest
```

### Step 2: Create the first node for Kafka

The first step is to create one Kafka instance.

```bash
docker run --name kafka1 --link kafka2:kafka2 --link kafka3:kafka3 \
  -e KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181 \
  -p 9092:9092 \
  bitnami/kafka:latest
```

### Step 2: Create the second node

Next we start a new Kafka container.

```bash
docker run --name kafka2 --link kafka1:kafka1 --link kafka3:kafka3 \
  -e KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181 \
  -p 9092:9092 \
  bitnami/kafka:latest
```

### Step 3: Create the third node

Next we start another new Kafka container.

```bash
docker run --name kafka3 --link kafka1:kafka1 --link kafka2:kafka2 \
  -e KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181 \
  -p 9092:9092 \
  bitnami/kafka:latest
```
You now have a Kafka cluster up and running. You can scale the cluster by adding/removing slaves without incurring any downtime.

With Docker Compose the e replication can be setup using:

```yaml
version: '2'

services:
  zookeeper:
    image: 'bitnami/zookeeper:latest'
    ports:
     - '2181:2181'
  kafka1:
    image: 'bitnami/kafka:latest'
    ports:
      - '9092'
    volumes:
      - /path/to/kafka-persistence:/bitnami/kafka
    environment:
      - KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181
  kafka2:
    image: 'bitnami/kafka:latest'
    ports:
      - '9092'
    volumes:
      - /path/to/kafka-persistence:/bitnami/kafka
    environment:
      - KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181
  kafka3:
    image: 'bitnami/kafka:latest'
    ports:
      - '9092'
    volumes:
      - /path/to/kafka-persistence:/bitnami/kafka
    environment:
      - KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181
```

## Configuration
The image looks for configuration in the `config/` directory of `/bitnami/kafka`.

```
docker run --name kafka -v /path/to/my_custom_conf_directory:/bitnami/kafka bitnami/kafka:latest
```
After that, your changes will be taken into account in the server's behaviour.

### Step 1: Run the Kafka image

Run the Kafka image, mounting a directory from your host.

Using Docker Compose:

```yaml
version: '2'

services:
  kafka:
    image: 'bitnami/kafka:latest'
    ports:
      - '9092:9092'
    volumes:
      - /path/to/kafka-persistence:/bitnami/kafka
```

### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```bash
vi /path/to/kafka-persistence/config/server.properties
```

### Step 3: Restart Kafka

After changing the configuration, restart your Kafka container for changes to take effect.

```bash
docker restart kafka
```

or using Docker Compose:

```bash
docker-compose restart kafka
```


# Logging

The Bitnami Kafka Docker image sends the container logs to the `stdout`. To view the logs:

```bash
docker logs kafka
```

or using Docker Compose:

```bash
docker-compose logs kafka
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Backing up your container

To backup your data, configuration and logs, follow these simple steps:

### Step 1: Stop the currently running container

```bash
docker stop kafka
```

or using Docker Compose:

```bash
docker-compose stop kafka
```

### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```bash
docker run --rm -v /path/to/kafka-backups:/backups --volumes-from kafka busybox \
  cp -a /bitnami/kafka:latest /backups/latest
```

or using Docker Compose:

```bash
docker run --rm -v /path/to/kafka-backups:/backups --volumes-from `docker-compose ps -q kafka` busybox \
  cp -a /bitnami/kafka:latest /backups/latest
```

## Restoring a backup

Restoring a backup is as simple as mounting the backup as volumes in the container.

```bash
docker run -v /path/to/kafka-backups/latest:/bitnami/kafka bitnami/kafka:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  kafka:
    image: 'bitnami/kafka:latest'
    ports:
      - '9092:9092'
    volumes:
      - /path/to/kafka-backups/latest:/bitnami/kafka
```

## Upgrade this image

Bitnami provides up-to-date versions of Kafka, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
docker pull bitnami/kafka:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/kafka:latest`.

### Step 2: Stop and backup the currently running container

Before continuing, you should backup your container's data, configuration and logs.

Follow the steps on [creating a backup](#backing-up-your-container).

### Step 3: Remove the currently running container

```bash
docker rm -v kafka
```

or using Docker Compose:


```bash
docker-compose rm -v kafka
```

### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if necessary.

```bash
docker run --name kafka bitnami/kafka:latest
```

or using Docker Compose:

```bash
docker-compose start kafka
```

# Notable Changes
## 0.10.2.1

- New Bitnami release


# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-kafka/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-kafka/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-kafka/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# Community

Most real time communication happens in the `#containers` channel at [bitnami-oss.slack.com](http://bitnami-oss.slack.com); you can sign up at [slack.oss.bitnami.com](http://slack.oss.bitnami.com).

Discussions are archived at [bitnami-oss.slackarchive.io](https://bitnami-oss.slackarchive.io).

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

