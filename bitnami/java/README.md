[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-java/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-java/tree/master)

# What is Java?

> Java is a general-purpose computer programming language that is concurrent, class-based, object-oriented, and specifically designed to have as few implementation dependencies as possible.

```bash
$ docker run -it --name java bitnami/java
```

## Docker Compose

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-java/master/docker-compose.yml > docker-compose.yml
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


 - [`1.8`, `1.8.181-ol-7-r4` (1.8/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/1.8.181-ol-7-r4/1.8/Dockerfile), [`1.8-prod`, `1.8.181-ol-7-r4-prod` (1.8/prod/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/1.8.181-ol-7-r4/1.8/prod/Dockerfile)
 - [`1.8`, `1.8.181-debian-9-r10` (1.8/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/1.8.181-debian-9-r10/1.8/Dockerfile), [`1.8-prod`, `1.8.181-debian-9-r10-prod` (1.8/prod/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/1.8.181-debian-9-r10/1.8/prod/Dockerfile)

Subscribe to project updates by watching the [bitnami/java GitHub repo](https://github.com/bitnami/bitnami-docker-java).

# Get this image

The recommended way to get the Bitnami Java Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/java).

```bash
$ docker pull bitnami/java:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/java/tags/) in the Docker Hub Registry.

```bash
$ docker pull bitnami/java:[TAG]
```

If you wish, you can also build the image yourself.

```bash
$ docker build -t bitnami/java https://github.com/bitnami/bitnami-docker-java.git
```

# Configuration

## Running your Java jar or war

The default work directory for the Java image is `/app`. You can mount a folder from your host here that includes your Java jar or war, and run it normally using the `java` command.

```bash
$ docker run -it --name java -v /path/to/app:/app bitnami/java:latest \
  java -jar package.jar
```

or using Docker Compose:

```
java:
  image: bitnami/java:latest
  command: "java -jar package.jar"
  volumes:
    - .:/app
```

**Further Reading:**

  - [Java SE Documentation](https://docs.oracle.com/javase/8/docs/api/)

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of Java, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
$ docker pull bitnami/java:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/java:latest`.

### Step 2: Remove the currently running container

```bash
$ docker rm -v java
```

or using Docker Compose:

```bash
$ docker-compose rm -v java
```

### Step 3: Run the new image

Re-create your container from the new image.

```bash
$ docker run --name java bitnami/java:latest
```

or using Docker Compose:

```bash
$ docker-compose up java
```

# Contributing

We'd love for you to contribute to this Docker image. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-java/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-java/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-java/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive
information)

# License

Copyright (c) 2018 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
