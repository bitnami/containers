[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-tensorflow-serving/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-tensorflow-serving/tree/master)
[![Slack](http://slack.oss.bitnami.com/badge.svg)](http://slack.oss.bitnami.com)
[![Kubectl](https://img.shields.io/badge/kubectl-Available-green.svg)](https://raw.githubusercontent.com/bitnami/bitnami-docker-tensorflow-serving/master/kubernetes.yml)

# What is Tensorflow Serving?

> TensorFlow Serving is a flexible, high-performance serving system for machine learning models, designed for production environments. TensorFlow Serving makes it easy to deploy new algorithms and experiments, while keeping the same server architecture and APIs. TensorFlow Serving provides out-of-the-box integration with TensorFlow models, but can be easily extended to serve other types of models and data.

> With the Bitnami Docker TensorFlow Serving image it is easy to server models like inception or MNIST. For a functional example you can check the [TensorFlow Inception repository.](https://github.com/bitnami/bitnami-docker-tensorflow-inception)

[tensorflow.github.io/serving/](https://tensorflow.github.io/serving/)

# TL;DR;

```bash
docker run --name tensorflow-serving bitnami/tensorflow-serving:latest
```

## Docker Compose

```yaml
version: '2'

services:
  tensorflow-serving:
    image: 'bitnami/tensorflow-serving:latest'
    ports:
      - '9000:9000'
```

## Kubernetes

> **WARNING:** This is a beta configuration, currently unsupported.

Get the raw URL pointing to the kubernetes.yml manifest and use kubectl to create the resources on your Kubernetes cluster like so:

```bash
$ kubectl create -f https://raw.githubusercontent.com/bitnami/bitnami-docker-tensorflow-serving/master/kubernetes.yml
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* Bitnami images are built on CircleCI and automatically pushed to the Docker Hub.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.

# Get this image

The recommended way to get the Bitnami TensorFlow Serving Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/tensorflow-serving).

```bash
docker pull bitnami/tensorflow-serving:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/tensorflow-serving/tags/) in the Docker Hub Registry.

```bash
docker pull bitnami/tensorflow-serving:[TAG]
```

If you wish, you can also build the image yourself.

```bash
docker build -t bitnami/tensorflow-serving:latest https://github.com/bitnami/bitnami-docker-tensorflow-serving.git
```

# Persisting your configuration

If you remove the container all your data and configurations will be lost, and the next time you run the image the data and configurations will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

The image exposes a volume at `/bitnami/tensorflow-serving` for the TensorFlow Serving data and configurations. For persistence you can mount a directory at this location from your host. If the mounted directory is empty, it will be initialized on the first run.

```bash
docker run -v /path/to/tensorflow-serving-persistence:/bitnami/tensorflow-serving bitnami/tensorflow-serving:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  tensorflow-serving:
    image: 'bitnami/tensorflow-serving:latest'
    ports:
      - '9000:9000'
    volumes:
      - /path/to/tensorflow-serving-persistence:/bitnami/tensorflow-serving
```

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a TensorFlow Serving server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

In this example, we will create a TensorFlow Inception client instance that will connect to the server instance that is running on the same docker network as the client. The Inception client will export an already trained data so the server can read it and you will be able to query the server with an image to get it categorized.

### Step 1: Download the Inception trained data

```bash
$ mkdir /tmp/model-data
$ curl -o '/tmp/model-data/inception-v3-2016-03-01.tar.gz' 'http://download.tensorflow.org/models/image/imagenet/inception-v3-2016-03-01.tar.gz'
$ cd /tmp/model-data
$ tar xzf inception-v3-2016-03-01.tar.gz
```

### Step 2: Create a network

```bash
$ docker network create app-tier --driver bridge
```

### Step 3: Launch the TensorFlow Serving server instance

Use the `--network app-tier` argument to the `docker run` command to attach the TensorFlow Serving container to the `app-tier` network.

```bash
$ docker run -d --name tensorflow-serving \
    --volume /tmp/model-data:/bitnami/model-data
    --network app-tier \
    bitnami/tensorflow-serving:latest
```

### Step 4: Launch your TensorFlow Inception client instance

Finally we create a new container instance to launch the TensorFlow Serving client and connect to the server created in the previous step:

```bash
$ docker run -it --rm \
    --volume /tmp/model-data:/bitnami/model-data
    --network app-tier \
    bitnami/tensorflow-inception:latest inception_client --server:tensorflow-serving --image=path/to/image.jpg
```

## Using Docker Compose

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `app-tier`. In this example we assume that you want to connect to the TensorFlow Serving server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge

services:
  tensorflow-serving:
    image: 'bitnami/tensorflow-serving:latest'
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
> 2. In your application container, use the hostname `tensorflow-serving` to connect to the TensorFlow Serving server

Launch the containers using:

```bash
$ docker-compose up -d
```

# Configuration

## Configuration file

The image looks for configuration in the `conf/` directory of `/bitnami/tensorflow-serving`. As as mentioned in [Persisting your configuration](##persisting-your-configuration) you can mount a volume at this location and copy your own configurations in the `conf/` directory. The default configuration will be copied to the `conf/` directory if it's empty.

### Step 1: Run the TensorFlow Serving image

Run the TensorFlow Serving image, mounting a directory from your host.

```bash
docker run --name tensorflow-serving -v /path/to/tensorflow-serving-persistence:/bitnami/tensorflow-serving bitnami/tensorflow-serving:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  tensorflow-serving:
    image: 'bitnami/tensorflow-serving:latest'
    ports:
      - '9000:9000'
    volumes:
      - /path/to/tensorflow-serving-persistence:/bitnami/tensorflow-serving
```

### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```bash
vi /path/to/tensorflow-serving-persistence/conf/tensorflow-serving.conf
```

### Step 3: Restart TensorFlow Serving

After changing the configuration, restart your TensorFlow Serving container for changes to take effect.

```bash
docker restart tensorflow-serving
```

or using Docker Compose:

```bash
docker-compose restart tensorflow-serving
```

# Logging

The Bitnami TensorFlow Serving Docker image sends the container logs to the `stdout`. To view the logs:

```bash
docker logs tensorflow-serving
```

or using Docker Compose:

```bash
docker-compose logs tensorflow-serving
```

The logs are also stored inside the container in the /opt/bitnami/tensorflow-serving/logs/tensorflow-serving.log file.

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Backing up your container

To backup your data, configuration and logs, follow these simple steps:

### Step 1: Stop the currently running container

```bash
docker stop tensorflow-serving
```

or using Docker Compose:

```bash
docker-compose stop tensorflow-serving
```

### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```bash
docker run --rm -v /path/to/tensorflow-serving-backups:/backups --volumes-from tensorflow-serving busybox \
  cp -a /bitnami/tensorflow-serving:latest /backups/latest
```

or using Docker Compose:

```bash
docker run --rm -v /path/to/tensorflow-serving-backups:/backups --volumes-from `docker-compose ps -q tensorflow-serving` busybox \
  cp -a /bitnami/tensorflow-serving:latest /backups/latest
```

## Restoring a backup

Restoring a backup is as simple as mounting the backup as volumes in the container.

```bash
docker run -v /path/to/tensorflow-serving-backups/latest:/bitnami/tensorflow-serving bitnami/tensorflow-serving:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  tensorflow-serving:
    image: 'bitnami/tensorflow-serving:latest'
    ports:
      - '9000:9000'
    volumes:
      - /path/to/tensorflow-serving-backups/latest:/bitnami/tensorflow-serving
```

## Upgrade this image

Bitnami provides up-to-date versions of TensorFlow Serving, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
docker pull bitnami/tensorflow-serving:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/tensorflow-serving:latest`.

### Step 2: Stop and backup the currently running container

Before continuing, you should backup your container's data, configuration and logs.

Follow the steps on [creating a backup](#backing-up-your-container).

### Step 3: Remove the currently running container

```bash
docker rm -v tensorflow-serving
```

or using Docker Compose:

```bash
docker-compose rm -v tensorflow-serving
```

### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if necessary.

```bash
docker run --name tensorflow-serving bitnami/tensorflow-serving:latest
```

or using Docker Compose:

```bash
docker-compose start tensorflow-serving
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-tensorflow-serving/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-tensorflow-serving/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-tensorflow-serving/issues). For us to provide better support, be sure to include the following information in your issue:

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
