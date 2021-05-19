# What is Go?

> Go is an object oriented programming language with sensible primitives, static typing and reflection. It also supports packages for efficient management of dependencies.

[Golang](https://golang.org/)

# TL;DR

```console
$ docker run --name golang bitnami/golang:latest
```

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-golang/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.

> This [CVE scan report](https://quay.io/repository/bitnami/golang?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`1.16`, `1.16-debian-10`, `1.16.4`, `1.16.4-debian-10-r12`, `latest` (1.16/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-golang/blob/1.16.4-debian-10-r12/1.16/debian-10/Dockerfile)
* [`1.15`, `1.15-debian-10`, `1.15.12`, `1.15.12-debian-10-r11` (1.15/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-golang/blob/1.15.12-debian-10-r11/1.15/debian-10/Dockerfile)
* [`1.14`, `1.14-debian-10`, `1.14.15`, `1.14.15-debian-10-r97` (1.14/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-golang/blob/1.14.15-debian-10-r97/1.14/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/golang GitHub repo](https://github.com/bitnami/bitnami-docker-golang).

# Get this image

The recommended way to get the Bitnami Golang Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/golang).

```console
$ docker pull bitnami/golang:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/golang/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/golang:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/golang:latest 'https://github.com/bitnami/bitnami-docker-golang.git#master:1.16/debian-10'
```

# Persisting your application

For persistence you should mount a directory at the `/bitnami` path. If the mounted directory is empty, it will be initialized on the first run.

```console
$ docker run \
    -v /path/to/golang-persistence:/bitnami \
    bitnami/golang:latest
```

You can also do this with a minor change to the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-golang/blob/master/docker-compose.yml) file present in this repository:

```yaml
golang:
  ...
  volumes:
    - /path/to/golang-persistence:/bitnami
  ...
```

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

### Step 1: Create a network

```console
$ docker network create golang-network --driver bridge
```

### Step 2: Launch the Golang container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `golang-network` network.

```console
$ docker run --name golang-node1 --network golang-network bitnami/golang:latest
```

### Step 3: Run another containers

We can launch another containers using the same flag (`--network NETWORK`) in the `docker run` command. If you also set a name to your container, you will be able to use it as hostname in your network.

# Configuration

## Running your Golang project

The default workspace for the Bitnami Golang image is `/go` (GOPATH, consult [Golang documentation](https://golang.org/doc/gopath_code#Workspaces) for more info about workspaces). You can mount your custom Golang project from your host, and run it normally using the `go` command.

```console
$ docker -it --name golang run \
  -v /path/to/your/project:/go/src/project \
  bitnami/golang \
  bash -ec 'cd src/project && go run .'
```

# Logging

The Bitnami Golang Docker image sends the container logs to `stdout`. To view the logs:

```console
$ docker logs golang
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of Golang, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```console
$ docker pull bitnami/golang:latest
```

### Step 2: Stop the running container

Stop the currently running container using the command

```console
$ docker stop golang
```

### Step 3: Remove the currently running container

```console
$ docker rm -v golang
```

### Step 4: Run the new image

Re-create your container from the new image.

```console
$ docker run --name golang bitnami/golang:latest
```

# Branch Deprecation Notice

Golang's branch 1.14 is no longer maintained by upstream and is now internally tagged as to be deprecated. This branch will no longer be released in our catalog a month after this notice is published, but already released container images will still persist in the registries. Valid to be removed starting on: 06-19-2021

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-golang/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-golang/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-golang/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright (c) 2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
