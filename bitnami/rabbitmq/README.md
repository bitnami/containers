# What is RabbitMQ?

> RabbitMQ is an open source message broker software that implements the Advanced Message Queuing Protocol (AMQP).
> The RabbitMQ server is written in the Erlang programming language and is built on the Open Telecom Platform
> framework for clustering and failover. Client libraries to interface with the broker are available for all major
> programming languages.

[https://www.rabbitmq.com/](https://www.rabbitmq.com/)

# TL;DR;

```bash
$ docker run --name rabbitmq bitnami/rabbitmq:latest
```

## Docker Compose

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-rabbitmq/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/rabbitmq?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy RabbitMQ in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami RabbitMQ Chart GitHub repository](https://github.com/bitnami/charts/tree/master/upstreamed/rabbitmq).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/containers/how-to/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

> NOTE: Debian 8 images have been deprecated in favor of Debian 9 images. Bitnami will not longer publish new Docker images based on Debian 8.

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/).


* [`3.7-rhel-7`, `3.7.11-rhel-7-r3` (3.7/rhel-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-rabbitmq/blob/3.7.11-rhel-7-r3/3.7/rhel-7/Dockerfile)
* [`3.7-ol-7`, `3.7.11-ol-7-r3` (3.7/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-rabbitmq/blob/3.7.11-ol-7-r3/3.7/ol-7/Dockerfile)
* [`3.7-debian-9`, `3.7.11-debian-9-r2`, `3.7`, `3.7.11`, `3.7.11-r2`, `latest` (3.7/debian-9/Dockerfile)](https://github.com/bitnami/bitnami-docker-rabbitmq/blob/3.7.11-debian-9-r2/3.7/debian-9/Dockerfile)

Subscribe to project updates by watching the [bitnami/rabbitmq GitHub repo](https://github.com/bitnami/bitnami-docker-rabbitmq).

# Get this image

The recommended way to get the Bitnami RabbitMQ Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/rabbitmq).

```bash
$ docker pull bitnami/rabbitmq:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/rabbitmq/tags/) in the Docker Hub Registry.

```bash
$ docker pull bitnami/rabbitmq:[TAG]
```

If you wish, you can also build the image yourself.

```bash
$ docker build -t bitnami/rabbitmq:latest https://github.com/bitnami/bitnami-docker-rabbitmq.git
```

# Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami` path. If the mounted directory is empty, it will be initialized on the first run.

```bash
$ docker run \
    -v /path/to/rabbitmq-persistence:/bitnami \
    bitnami/rabbitmq:latest
```

or using Docker Compose:

```
rabbitmq:
  image: bitnami/rabbitmq:latest
  volumes:
    - /path/to/rabbitmq-persistence:/bitnami
```

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a RabbitMQ server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

In this example, we will create a RabbitMQ client instance that will connect to the server instance that is running on the same docker network as the client.

### Step 1: Create a network

```bash
$ docker network create app-tier --driver bridge
```

### Step 2: Launch the RabbitMQ server instance

Use the `--network app-tier` argument to the `docker run` command to attach the RabbitMQ container to the `app-tier` network.

```bash
$ docker run -d --name rabbitmq-server \
    --network app-tier \
    bitnami/rabbitmq:latest
```

### Step 3: Launch your RabbitMQ client instance

Finally we create a new container instance to launch the RabbitMQ client and connect to the server created in the previous step:

```bash
$ docker run -it --rm \
    --network app-tier \
    bitnami/rabbitmq:latest rabbitmqctl -n rabbit@rabbitmq-server status
```

## Using Docker Compose

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `app-tier`. In this example we assume that you want to connect to the RabbitMQ server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge

services:
  rabbitmq:
    image: 'bitnami/rabbitmq:latest'
    networks:
      - app-tier
  myapp:
    image: 'YOUR_APPLICATION_IMAGE'
    networks:
      - app-tier
```

> **IMPORTANT**:
>
> 1. Please update the **YOUR_APPLICATION_IMAGE** placeholder in the above snippet with your application image
> 2. In your application container, use the hostname `rabbitmq` to connect to the RabbitMQ server

Launch the containers using:

```bash
$ docker-compose up -d
```

# Configuration

## Environment variables

 When you start the rabbitmq image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the docker run command line. If you want to add a new environment variable:

* For docker-compose add the variable name and value under the application section:

```yaml
rabbitmq:
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
 - `RABBITMQ_HASHED_PASSWORD`: RabbitMQ application hasehd password.
 - `RABBITMQ_VHOST`: RabbitMQ application vhost. Default: **/**
 - `RABBITMQ_ERL_COOKIE`: Erlang cookie to determine whether different nodes are allowed to communicate with each other.
 - `RABBITMQ_NODE_TYPE`: Node Type. Valid values: *stats*, *queue-ram* or *queue-disc*. Default: **stats**
 - `RABBITMQ_NODE_NAME`: Node name and host. E.g.: *node@hostname* or *node* (localhost won't work in cluster topology). Default **rabbit@localhost**. If using this variable, ensure that you specify a valid host name as the container wil fail to start otherwise.
 - `RABBITMQ_NODE_PORT_NUMBER`: Node port. Default: **5672**
 - `RABBITMQ_CLUSTER_NODE_NAME`: Node name to cluster with. E.g.: **clusternode@hostname**
 - `RABBITMQ_CLUSTER_PARTITION_HANDLING`: Cluster partition recovery mechanism. Default: **ignore**
 - `RABBITMQ_MANAGER_PORT_NUMBER`: Manager port. Default: **15672**
 - `RABBITMQ_DISK_FREE_LIMIT`: Disk free space limit of the partition on which RabbitMQ is storing data. Default: **{mem_relative, 1.0}**
 - `RABBITMQ_ULIMIT_NOFILES`: Resources limits: maximum number of open file descriptors. Default: **65536**

## Setting up a cluster

### Docker Compose

This is the simplest way to run RabbitMQ with clustering configuration:

#### Step 1: Add a stats node in your `docker-compose.yml`

Copy the snippet below into your docker-compose.yml to add a RabbitMQ stats node to your cluster configuration.

```yaml
version: '2'

services:
  stats:
    image: bitnami/rabbitmq
    environment:
      - RABBITMQ_NODE_TYPE=stats
      - RABBITMQ_NODE_NAME=rabbit@stats
      - RABBITMQ_ERL_COOKIE=s3cr3tc00ki3
    ports:
      - '15672:15672'
    volumes:
      - 'rabbitmqstats_data:/bitnami'
```

> **Note:** The name of the service (**stats**) is important so that a node could resolve the hostname to cluster with. (Note that the node name is `rabbit@stats`)

#### Step 2: Add a queue node in your configuration

Update the definitions for nodes you want your RabbitMQ stats node cluster with.

```yaml
  queue-disc1:
    image: bitnami/rabbitmq
    environment:
      - RABBITMQ_NODE_TYPE=queue-disc
      - RABBITMQ_NODE_NAME=rabbit@queue-disc1
      - RABBITMQ_CLUSTER_NODE_NAME=rabbit@stats
      - RABBITMQ_ERL_COOKIE=s3cr3tc00ki3
    volumes:
      - 'rabbitmqdisc1_data:/bitnami'
```

> **Note:** Again, the name of the service (**queue-disc1**) is important so that each node could resolve the hostname of this one.

We are going to add a ram node too:

```yaml
  queue-ram1:
    image: bitnami/rabbitmq
    environment:
      - RABBITMQ_NODE_TYPE=queue-ram
      - RABBITMQ_NODE_NAME=rabbit@queue-ram1
      - RABBITMQ_CLUSTER_NODE_NAME=rabbit@stats
      - RABBITMQ_ERL_COOKIE=s3cr3tc00ki3
    volumes:
      - 'rabbitmqram1_data:/bitnami'
```

#### Step 3: Add the volume description

```yaml
volumes:
  rabbitmqstats_data:
    driver: local
  rabbitmqdisc1_data:
    driver: local
  rabbitmqram1_data:
    driver: local
```

The `docker-compose.yml` will look like this:

```yaml
version: '2'

services:
  stats:
    image: bitnami/rabbitmq
    environment:
      - RABBITMQ_NODE_TYPE=stats
      - RABBITMQ_NODE_NAME=rabbit@stats
      - RABBITMQ_ERL_COOKIE=s3cr3tc00ki3
    ports:
      - '15672:15672'
    volumes:
      - 'rabbitmqstats_data:/bitnami'
  queue-disc1:
    image: bitnami/rabbitmq
    environment:
      - RABBITMQ_NODE_TYPE=queue-disc
      - RABBITMQ_NODE_NAME=rabbit@queue-disc1
      - RABBITMQ_CLUSTER_NODE_NAME=rabbit@stats
      - RABBITMQ_ERL_COOKIE=s3cr3tc00ki3
    volumes:
      - 'rabbitmqdisc1_data:/bitnami'
  queue-ram1:
    image: bitnami/rabbitmq
    environment:
      - RABBITMQ_NODE_TYPE=queue-ram
      - RABBITMQ_NODE_NAME=rabbit@queue-ram1
      - RABBITMQ_CLUSTER_NODE_NAME=rabbit@stats
      - RABBITMQ_ERL_COOKIE=s3cr3tc00ki3
    volumes:
      - 'rabbitmqram1_data:/bitnami'

volumes:
  rabbitmqstats_data:
    driver: local
  rabbitmqdisc1_data:
    driver: local
  rabbitmqram1_data:
    driver: local
```

## Configuration file

The image looks for configurations in `/bitnami/rabbitmq/conf/`. As mentioned in [Persisting your application](#persisting-your-application) you can mount a volume at `/bitnami` and copy/edit the configurations in the `/path/to/rabbitmq-persistence/rabbitmq/conf/`. The default configurations will be populated to the `conf/` directory if it's empty.

### Step 1: Run the RabbitMQ image

Run the RabbitMQ image, mounting a directory from your host.

```bash
$ docker run --name rabbitmq -v /path/to/rabbitmq-persistence:/bitnami bitnami/rabbitmq:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  rabbitmq:
    image: 'bitnami/rabbitmq:latest'
    ports:
      - '15672:15672'
    volumes:
      - /path/to/rabbitmq-persistence:/bitnami
```

### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```bash
$ vi /path/to/rabbitmq-persistence/rabbitmq/conf/rabbitmq.config
```

### Step 3: Restart RabbitMQ

After changing the configuration, restart your RabbitMQ container for changes to take effect.

```bash
$ docker restart rabbitmq
```

or using Docker Compose:

```bash
$ docker-compose restart rabbitmq
```

# Logging

The Bitnami RabbitMQ Docker image sends the container logs to the `stdout`. To view the logs:

```bash
$ docker logs rabbitmq
```

or using Docker Compose:

```bash
$ docker-compose logs rabbitmq
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Upgrade this application

Bitnami provides up-to-date versions of RabbitMQ, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
$ docker pull bitnami/rabbitmq:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/rabbitmq:latest`.

### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```bash
$ docker stop rabbitmq
```

or using Docker Compose:

```bash
$ docker-compose stop rabbitmq
```

Next, take a snapshot of the persistent volume `/path/to/rabbitmq-persistence` using:

```bash
$ rsync -a /path/to/rabbitmq-persistence /path/to/rabbitmq-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

### Step 3: Remove the currently running container

```bash
$ docker rm -v rabbitmq
```

or using Docker Compose:

```bash
$ docker-compose rm -v rabbitmq
```

### Step 4: Run the new image

Re-create your container from the new image.

```bash
$ docker run --name rabbitmq bitnami/rabbitmq:latest
```

or using Docker Compose:

```bash
$ docker-compose up rabbitmq
```

# Notable changes

## 3.7.7-r35

- The RabbitMQ container includes a new environment variable `RABBITMQ_HASHED_PASSWORD` that allows setting password via SHA256 hash (consult [official documentation](https://www.rabbitmq.com/passwords.html) for more information about password hashes).
- Please note that password hashes must be generated following the [official algorithm](https://www.rabbitmq.com/passwords.html#computing-password-hash). You can use [this Python script](https://gist.githubusercontent.com/anapsix/4c3e8a8685ce5a3f0d7599c9902fd0d5/raw/1203a480fcec1982084b3528415c3cad26541b82/rmq_passwd_hash.py) to generate them.

## 3.7.7-r19

- The RabbitMQ container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the RabbitMQ daemon was started as the `rabbitmq` user. From now on, both the container and the RabbitMQ daemon run as user `1001`. As a consequence, the data directory must be writable by that user. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

## 3.6.5-r2

The following parameters have been renamed:

|            From            |              To              |
|----------------------------|------------------------------|
| `RABBITMQ_ERLANG_COOKIE`    | `RABBITMQ_ERL_COOKIE`     |

## 3.6.5-r2

The following parameters have been renamed:

|            From            |              To              |
|----------------------------|------------------------------|
| `RABBITMQ_ERLANGCOOKIE`    | `RABBITMQ_ERLANG_COOKIE`     |
| `RABBITMQ_NODETYPE`        | `RABBITMQ_NODE_TYPE`         |
| `RABBITMQ_NODEPORT`        | `RABBITMQ_NODE_PORT`         |
| `RABBITMQ_NODENAME`        | `RABBITMQ_NODE_NAME`         |
| `RABBITMQ_CLUSTERNODENAME` | `RABBITMQ_CLUSTER_NODE_NAME` |
| `RABBITMQ_MANAGERPORT`     | `RABBITMQ_MANAGER_PORT`      |

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an
[issue](https://github.com/bitnami/bitnami-docker-rabbitmq/issues), or submit a
[pull request](https://github.com/bitnami/bitnami-docker-rabbitmq/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an
[issue](https://github.com/bitnami/bitnami-docker-rabbitmq/issues). For us to provide better support,
be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive
information)

# License

Copyright (c) 2019 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
