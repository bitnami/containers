# What is Jenkins?

> Jenkins is widely recognized as the most feature-rich CI available with easy configuration, continuous delivery and continuous integration support, easily test, build and stage your app, and more. It supports multiple SCM tools including CVS, Subversion and Git. It can execute Apache Ant and Apache Maven-based projects as well as arbitrary scripts.

https://jenkins.io

# Prerequisites

To run this application you need [Docker Engine](https://www.docker.com/products/docker-engine) >= `1.10.0`. [Docker Compose](https://www.docker.com/products/docker-compose) is recommended with a version `1.6.0` or later.

# How to use this image

## Using Docker Compose

The recommended way to run Jenkins is using Docker Compose using the following `docker-compose.yml` template:

```yaml
version: '2'
services:
  application:
    image: 'bitnami/jenkins:latest'
    ports:
      - '80:8080'
      - '443:8443'
    volumes:
      - 'jenkins_data:/bitnami/jenkins'
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
  --volume jenkins_data:/bitnami/jenkins \
  bitnami/jenkins:latest
```

Access your application at http://your-ip/

## Persisting your application

For persistence of the Jenkins deployment, the above examples define a docker volume namely jenkins_data`. The Jenkins application state will persist as long as this volume is not removed.

If avoid inadvertent removal of this volume you can [mount a host directory as data volume](https://docs.docker.com/engine/userguide/containers/dockervolumes/#mount-a-host-directory-as-a-data-volume). Alternatively you can make use of volume plugins to host the volume data.

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
      - /path/to/jenkins-persistence:/bitnami/jenkins
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
  --volume /path/to/jenkins-persistence:/bitnami/jenkins \
  bitnami/jenkins:latest
```

# Upgrading Jenkins

We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the Jenkins container.

The `bitnami/jenkins:latest` tag always points to the most recent release. To get the most recent release you can simple repull the `latest` tag from the Docker Hub with `docker pull bitnami/jenkins:latest`. However it is recommended to use [tagged versions](https://hub.docker.com/r/bitnami/jenkins/tags/).

Get the updated image:

```
$ docker pull bitnami/jenkins:latest
```

## Using Docker Compose

1. Stop the running Jenkins container

```bash
$ docker-compose stop jenkins
```

2. Remove the stopped container

```bash
$ docker-compose rm jenkins
```

3. Launch the updated Jenkins image

```bash
$ docker-compose start jenkins
```

## Using Docker command line

1. Stop the running Jenkins container

```bash
$ docker stop jenkins
```

2. Remove the stopped container

```bash
$ docker rm jenkins
```

3. Launch the updated Jenkins image

```bash
$ docker run -d --name jenkins -p 80:8080 -p 443:8443 \
  --net jenkins-tier \
  --volume jenkins_data:/bitnami/jenkins \
  bitnami/jenkins:latest
```

> **NOTE**:
>
> The above command assumes that local docker volumes are in use. Edit the command according to your usage.

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
      - jenkins_data:/bitnami/jenkins

volumes:
  jenkins_data:
    driver: local
```

### Specifying Environment variables on the Docker command line

```bash
$ docker run -d --name jenkins -p 80:8080 -p 443:8443 \
  --net jenkins-tier \
  --env JENKINS_PASSWORD=my_password \
  --volume jenkins_data:/bitnami/jenkins \
  bitnami/jenkins:latest
```

# Backing up your application

To backup your application data follow these steps:

## Backing up using Docker Compose

1. Stop the Jenkins container:

```bash
$ docker-compose stop jenkins
```

2. Copy the Jenkins data

```bash
$ docker cp $(docker-compose ps -q jenkins):/bitnami/jenkins/ /path/to/backups/jenkins/latest/
```

3. Start the Jenkins container

```bash
$ docker-compose start jenkins
```

## Backing up using the Docker command line

1. Stop the Jenkins container:

```bash
$ docker stop jenkins
```

2. Copy the Jenkins data

```bash
$ docker cp jenkins:/bitnami/jenkins/ /path/to/backups/jenkins/latest/
```

3. Start the Jenkins container

```bash
$ docker start jenkins
```

# Restoring a backup

To restore your application using backed up data simply mount the folder with Jenkins in the container. See [persisting your application](#persisting-your-application) section for more info.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/jenkins/issues), or submit a [pull request](https://github.com/bitnami/jenkins/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/jenkins/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright 2015-2016 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
