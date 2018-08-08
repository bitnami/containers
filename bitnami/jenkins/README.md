[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-jenkins/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-jenkins/tree/master)

# What is Jenkins?

> Jenkins is widely recognized as the most feature-rich CI available with easy configuration, continuous delivery and continuous integration support, easily test, build and stage your app, and more. It supports multiple SCM tools including CVS, Subversion and Git. It can execute Apache Ant and Apache Maven-based projects as well as arbitrary scripts.

https://jenkins.io

# TL;DR;

## Docker Compose

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-jenkins/master/docker-compose.yml > docker-compose.yml
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


* [`2-ol-7`, `2.121.2-ol-7-r15` (2/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-jenkins/blob/2.121.2-ol-7-r15/2/ol-7/Dockerfile)
* [`2-debian-9`, `2.121.2-debian-9-r20`, `2`, `2.121.2`, `2.121.2-r20`, `latest` (2/Dockerfile)](https://github.com/bitnami/bitnami-docker-jenkins/blob/2.121.2-debian-9-r20/2/Dockerfile)

Subscribe to project updates by watching the [bitnami/jenkins GitHub repo](https://github.com/bitnami/bitnami-docker-jenkins).

# Prerequisites

To run this application you need [Docker Engine](https://www.docker.com/products/docker-engine) >= `1.10.0`. [Docker Compose](https://www.docker.com/products/docker-compose) is recommended with a version `1.6.0` or later.

# How to use this image

## Using Docker Compose

The recommended way to run Jenkins is using Docker Compose using the following `docker-compose.yml` template:

```yaml
version: '2'
services:
  jenkins:
    image: 'bitnami/jenkins:latest'
    ports:
      - '80:8080'
      - '443:8443'
    volumes:
      - 'jenkins_data:/bitnami'
volumes:
  jenkins_data:
    driver: local
```

Launch the containers using:

```bash
$ docker-compose up -d
```

## Using the Docker Command Line

If you want to run the application manually instead of using `docker-compose`, these are the basic steps you need to run:

1. Create a network

  ```bash
  $ docker network create jenkins-tier
  ```

2. Create volumes for Jenkins persistence and launch the container

  ```bash
  $ docker volume create --name jenkins_data
  $ docker run -d --name jenkins -p 80:8080 -p 443:8443 \
    --net jenkins-tier \
    --volume jenkins_data:/bitnami \
    bitnami/jenkins:latest
  ```

Access your application at http://your-ip/

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. The above examples define a docker volume namely `jenkins_data`. The Jenkins application state will persist as long as this volume is not removed.

To avoid inadvertent removal of this volume you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

The following `docker-compose.yml` template demonstrates the use of host directories as data volumes.

```yaml
version: '2'

services:
  jenkins:
    image: bitnami/jenkins:latest
    ports:
      - '80:8080'
      - '443:8443'
    volumes:
      - /path/to/jenkins-persistence:/bitnami
```

### Mount host directories as data volumes using the Docker command line

1. Create a network (if it does not exist)

  ```bash
  $ docker network create jenkins-tier
  ```

2. Create the Jenkins the container with host volumes

  ```bash
  $ docker run -d --name jenkins -p 80:8080 -p 443:8443 \
    --net jenkins-tier \
    --volume /path/to/jenkins-persistence:/bitnami \
    bitnami/jenkins:latest
  ```

# Upgrading Jenkins

Bitnami provides up-to-date versions of Jenkins, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the Jenkins container.

1. Get the updated images:

```bash
$ docker pull bitnami/jenkins:latest
```

2. Stop your container

 * For docker-compose: `$ docker-compose stop jenkins`
 * For manual execution: `$ docker stop jenkins`

3. Take a snapshot of the application state

```bash
$ rsync -a /path/to/jenkins-persistence /path/to/jenkins-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

You can use this snapshot to restore the application state should the upgrade fail.

4. Remove the stopped container

 * For docker-compose: `$ docker-compose rm -v jenkins`
 * For manual execution: `$ docker rm -v jenkins`

5. Run the new image

 * For docker-compose: `$ docker-compose up jenkins`
 * For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name jenkins bitnami/jenkins:latest`

# Configuration

## Environment variables

The Jenkins instance can be customized by specifying environment variables on the first run. The following environment values are provided to custom Jenkins:

- `JENKINS_USERNAME`: Jenkins admin username. Default: **user**
- `JENKINS_PASSWORD`: Jenkins admin password. Default: **bitnami**

### Specifying Environment variables using Docker Compose

```yaml
version: '2'

services:
  jenkins:
    image: bitnami/jenkins:latest
    ports:
      - '80:8080'
      - '443:8443'
    environment:
      - JENKINS_PASSWORD=my_password
    volumes:
      - jenkins_data:/bitnami

volumes:
  jenkins_data:
    driver: local
```

### Specifying Environment variables on the Docker command line

```bash
$ docker run -d --name jenkins -p 80:8080 -p 443:8443 \
  --net jenkins-tier \
  --env JENKINS_PASSWORD=my_password \
  --volume jenkins_data:/bitnami \
  bitnami/jenkins:latest
```

# Notable Changes

## 2.121.2-ol-7-r14 / 2.121.2-debian-9-r18

- Use Jetty instead of Tomcat as web server.

## 2.107.1-r0

- The Jenkins container has been migrated to the LTS version. From now on, this repository will only track long term support releases from [Jenkins](https://jenkins.io/changelog-stable/).

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-jenkins/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-jenkins/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-jenkins/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright 2015-2018 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
