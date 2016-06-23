# What is RabbitMQ?

> RabbitMQ is an open source message broker software that implements the Advanced Message Queuing Protocol (AMQP).
> The RabbitMQ server is written in the Erlang programming language and is built on the Open Telecom Platform
> framework for clustering and failover. Client libraries to interface with the broker are available for all major
> programming languages.

[https://www.rabbitmq.com/](https://www.rabbitmq.com/)

# TLDR

```bash
docker run --name rabbitmq bitnami/rabbitmq:latest
```

## Docker Compose

```
rabbitmq:
  image: bitnami/rabbitmq:latest
```

# Get this image

The recommended way to get the Bitnami RabbitMQ Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/rabbitmq).

```bash
docker pull bitnami/rabbitmq:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/rabbitmq/tags/) in the Docker Hub Registry.

```bash
docker pull bitnami/rabbitmq:[TAG]
```

If you wish, you can also build the image yourself.

```bash
docker build -t bitnami/rabbitmq:latest https://github.com/bitnami/bitnami-docker-rabbitmq.git
```

# Persisting your application

If you remove every container and volume all your data will be lost, and the next time you run the image the application will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed. If you are using docker-compose your data will be persistent as long as you don't remove `rabbitmq*_data` data volumes. If you have run the containers manually or you want to mount the folders with persistent data in your host follow the next steps:

> **Note:** If you have already started using your application, follow the steps on [backing](#backing-up-your-application) up to pull the data from your running container down to your host.

The image exposes a volume at /bitnami/rabbitmq for the RabbitMQ data and configurations. For persistence you can mount a directory at this location from your host. If the mounted directory is empty, it will be initialized on the first run.

```bash
docker run -v /path/to/rabbitmq-persistence:/bitnami/rabbitmq bitnami/rabbitmq:latest
```

or using Docker Compose:

```
rabbitmq:
  image: bitnami/rabbitmq:latest
  volumes:
    - /path/to/rabbitmq-persistence:/bitnami/rabbitmq
```

# Linking

If you want to connect to your RabbitMQ server inside another container, you can use the linking system provided by Docker.

## Connecting a RabbitMQ node to a stats node

### Step 1: Create a new network for the application:

```
$ docker network create rabbitmq_network
```

### Step 2: Run the RabbitMQ stats node:

```
$ docker run -d -p 15672:15672 --name rabbitmq-stats --net=rabbitmq_network -e RABBITMQ_NODENAME=rabbit@rabbitmq-stats -e RABBITMQ_ERLANGCOOKIE=s3cr3tc00ki3 bitnami/rabbitmq
```

*Note:* You need to give the container a name in order to RabbitMQ nodes to resolve the host

### Step 3: Run the RabbitMQ queue nodes:

```
$ docker run -d --name rabbitmq-queue-disc1 --link rabbitmq-stats --net=rabbitmq_network -e RABBITMQ_NODETYPE=queue-disc -e RABBITMQ_NODENAME=rabbit@rabibitmq-queue-disc1 -e RABBITMQ_CLUSTERNODENAME=rabbit@rabbitmq-stats -e RABBITMQ_ERLANGCOOKIE=s3cr3tc00ki3 bitnami/rabbitmq
```

*Note:* You can use a **ram** node by setting `RABBITMQ_NODETYPE=queue-ram` and `--name rabbitmq-queue-ramX`

## Linking with Docker Compose

### Step 1: Add a RabbitMQ entry in your `docker-compose.yml`

Copy the snippet below into your `docker-compose.yml` to add RabbitMQ to your application.

```
rabbitmq:
  image: bitnami/rabbitmq:latest
```

### Step 2: Link it to another container in your application

Update the definitions for containers you want to access your RabbitMQ server from to include a link to the `rabbitmq` entry you added in Step 1.

```
myapp:
  image: myapp
  links:
    - rabbitmq:rabbitmq
```

Inside `myapp`, use `rabbitmq` as the hostname for the RabbitMQ server.

# Configuration

## Environment variables

 When you start the rabbitmq image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the docker run command line. If you want to add a new environment variable:

* For docker-compose add the variable name and value under the application section:

```
application:
  image: bitnami/rabbitmq:latest
  ports:
    - 15672:15672
  environment:
    - RABBITMQ_PASSWORD=my_password
```

 * For manual execution add a `-e` option with each variable and value.

Available variables:

 - `RABBITMQ_USERNAME`: RabbitMQ application username. Default: **user**
 - `RABBITMQ_PASSWORD`: RabbitMQ application password. Default: **bitnami**
 - `RABBITMQ_VHOST`: RabbitMQ application vhost. Default: **/**
 - `RABBITMQ_ERLANGCOOKIE`: Erlang cookie to determine whether different nodes are allowed to communicate with each other.
 - `RABBITMQ_NODETYPE`: Node Type. Valid values: *stats*, **queue-ram* or *queue-disc*. Default: **stats**
 - `RABBITMQ_NODENAME`: Node name. E.g.: *node@hostname* or *node* (If you don't specify the hostname, the env variables will be used.). Default **rabbit**
 - `RABBITMQ_NODEPORT`: Node port. Default: **5672**
 - `RABBITMQ_CLUSTERNODENAME`: Node name to cluster with. E.g.: **clusternode@hostname**
 - `RABBITMQ_MANAGERPORT`: Manager port. Default: **15672**
 - `RABBITMQ_MANAGERBINDIP`: Manager bind ip. Default: **0.0.0.0**

## Setting up a cluster

### Docker Compose

This is the simplest way to run RabbitMQ with clustering configuration:

#### Step 1: Add a stats node in your `docker-compose.yml`

Copy the snippet below into your docker-compose.yml to add a RabbitMQ stats node to your cluster configuration.

```
version: '2'

services:
  stats:
    image: bitnami/rabbitmq
    environment:
      - RABBITMQ_NODETYPE=stats
      - RABBITMQ_NODENAME=rabbit@stats
      - RABBITMQ_ERLANGCOOKIE=s3cr3tc00ki3
    ports:
      - '15672:15672'
    volumes:
      - 'rabbitmqstats_data:/bitnami/rabbitmq'
```

> **Note:** The name of the service (**stats**) is important so that a node could resolve the hostname to cluster with. (Note that the node name is `rabbit@stats`)

#### Step 2: Add a queue node in your configuration

Update the definitions for nodes you want your RabbitMQ stats node cluster with.

```
    queue-disc1:
    image: bitnami/rabbitmq
    environment:
      - RABBITMQ_NODETYPE=queue-disc
      - RABBITMQ_NODENAME=rabbit@queue-disc1
      - RABBITMQ_CLUSTERNODENAME=rabbit@stats
      - RABBITMQ_ERLANGCOOKIE=s3cr3tc00ki3
    volumes:
      - 'rabbitmqdisc1_data:/bitnami/rabbitmq'
```

> **Note:** Again, the name of the service (**queue-disc1**) is important so that each node could resolve the hostname of this one.

We are going to add a ram node too:

```
  queue-ram1:
    image: bitnami/rabbitmq
    environment:
      - RABBITMQ_NODETYPE=queue-ram
      - RABBITMQ_NODENAME=rabbit@queue-ram1
      - RABBITMQ_CLUSTERNODENAME=rabbit@stats
      - RABBITMQ_ERLANGCOOKIE=s3cr3tc00ki3
  volumes:
    - 'rabbitmqram1_data:/bitnami/rabbitmq'
```

#### Step 3: Add the volume description

```
volumes:
  rabbitmqstats_data:
    driver: local
  rabbitmqdisc1_data:
    driver: local
  rabbitmqram1_data:
    driver: local
```

The `docker-compose.yml` will look like this:

```
version: '2'

services:
  stats:
    image: bitnami/rabbitmq
    environment:
      - RABBITMQ_NODETYPE=stats
      - RABBITMQ_NODENAME=rabbit@stats
      - RABBITMQ_ERLANGCOOKIE=s3cr3tc00ki3
    ports:
      - '15672:15672'
    volumes:
      - 'rabbitmqstats_data:/bitnami/rabbitmq'
  queue-disc1:
    image: bitnami/rabbitmq
    environment:
      - RABBITMQ_NODETYPE=queue-disc
      - RABBITMQ_NODENAME=rabbit@queue-disc1
      - RABBITMQ_CLUSTERNODENAME=rabbit@stats
      - RABBITMQ_ERLANGCOOKIE=s3cr3tc00ki3
  volumes:
    - 'rabbitmqdisc1_data:/bitnami/rabbitmq'
  queue-ram1:
    image: bitnami/rabbitmq
    environment:
      - RABBITMQ_NODETYPE=queue-ram
      - RABBITMQ_NODENAME=rabbit@queue-ram1
      - RABBITMQ_CLUSTERNODENAME=rabbit@stats
      - RABBITMQ_ERLANGCOOKIE=s3cr3tc00ki3
  volumes:
    - 'rabbitmqram1_data:/bitnami/rabbitmq'

volumes:
  rabbitmqstats_data:
    driver: local
  rabbitmqdisc1_data:
    driver: local
  rabbitmqram1_data:
    driver: local
```

## Configuration file

The image looks for configuration in the `conf/` directory of `/bitnami/rabbitmq`. As mentioned in [Persisting your application](#persisting-your-application) you can mount a volume at this location and copy your own configurations in the `conf/` directory. The default configuration will be copied to the `conf/` directory if it's empty.

# Logging

The Bitnami RabbitMQ Docker image sends the container logs to the `stdout`. To view the logs:

```bash
docker logs rabbitmq
```

or using Docker Compose:

```bash
docker-compose logs rabbitmq
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Backing up your application

To backup your data, configuration and logs, follow these simple steps:

### Step 1: Stop the currently running container

```bash
docker stop rabbitmq
```

or using Docker Compose:

```bash
docker-compose stop rabbitmq
```

### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```bash
docker run --rm -v /path/to/rabbitmq-backups:/backups --volumes-from rabbitmq busybox \
  cp -a /bitnami/rabbitmq:latest /backups/latest
```

or using Docker Compose:

```bash
docker run --rm -v /path/to/rabbitmq-backups:/backups --volumes-from `docker-compose ps -q rabbitmq` busybox \
  cp -a /bitnami/rabbitmq:latest /backups/latest
```

## Restoring a backup

Restoring a backup is as simple as mounting the backup as volumes in the container.

```bash
docker run -v /path/to/rabbitmq-backups/latest:/bitnami/rabbitmq bitnami/rabbitmq:latest
```

or using Docker Compose:

```
rabbitmq:
  image: bitnami/rabbitmq:latest
  volumes:
    - /path/to/rabbitmq-backups/latest:/bitnami/rabbitmq
```

## Upgrade this application

Bitnami provides up-to-date versions of RabbitMQ, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
docker pull bitnami/rabbitmq:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/rabbitmq:latest`.

### Step 2: Stop and backup the currently running container

Before continuing, you should backup your container's data, configuration and logs.

Follow the steps on [creating a backup](#backing-up-your-container).

### Step 3: Remove the currently running container

```bash
docker rm -v rabbitmq
```

or using Docker Compose:

```bash
docker-compose rm -v rabbitmq
```

### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if necessary.

```bash
docker run --name rabbitmq bitnami/rabbitmq:latest
```

or using Docker Compose:

```bash
docker-compose start rabbitmq
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an
[issue](https://github.com/bitnami/rabbitmq/issues), or submit a
[pull request](https://github.com/bitnami/rabbitmq/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an
[issue](https://github.com/bitnami/rabbitmq/issues). For us to provide better support,
be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_APP_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive
information)
