
# What is Fluent Bit?

Fluent Bit is a Data Forwarder for Linux, Embedded Linux, OSX and BSD family operating systems. It's part of the Fluentd Ecosystem. Fluent Bit allows collection of information from different sources, buffering and dispatching them to different outputs such as Fluentd, Elasticsearch, Nats or any HTTP end-point within others. It's fully supported on x86_64, x86 and ARM architectures.

For more details about it capabilities and general features please visit the official documentation:

[http://fluentbit.io](http://fluentbit.io)

# TL;DR

```console
$ docker run --name fluent-bit bitnami/fluent-bit:latest
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/fluent-bit?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`1`, `1-debian-10`, `1.7.5`, `1.7.5-debian-10-r3`, `latest` (1/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-fluent-bit/blob/1.7.5-debian-10-r3/1/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/fluent-bit GitHub repo](https://github.com/bitnami/bitnami-docker-fluent-bit).

# Get this image

The recommended way to get the Bitnami Fluent Bit Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/fluent-bit).

```console
$ docker pull bitnami/fluent-bit:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/fluent-bit/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/fluent-bit:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/fluent-bit:latest 'https://github.com/bitnami/bitnami-docker-fluent-bit.git#master:1/debian-10'
```

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

### Step 1: Create a network

```console
$ docker network create fluent-bit-network --driver bridge
```

### Step 2: Launch the Fluent Bit container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `fluent-bit-network` network.

```console
$ docker run --name fluent-bit-node1 --network fluent-bit-network bitnami/fluent-bit:latest
```

### Step 3: Run another container

We can launch another container using the same flag (`--network NETWORK`) in the `docker run` command. If you also set a name to your container, you will be able to use it as hostname in your network.

## Using Docker Compose

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `app-tier`. In this example we assume that you want to connect to the Fluent Bit log processor from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge

services:
  fluent-bit:
    image: 'bitnami/bitnami-docker-fluent-bit:latest'
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
> 2. In your application container, use the hostname `fluent-bit` to connect to the Fluent Bit log processor

Launch the containers using:

```console
$ docker-compose up -d
```

# Configuration

Fluent Bit is flexible enough to be configured either from the command line or through a configuration file. For production environments, Fluent Bit strongly recommends to use the configuration file approach.

[Configuration reference](http://fluentbit.io/documentation/)

# Plugins

Fluent Bit supports multiple extensions via plugins.

[Plugins reference](http://fluentbit.io/documentation/)

# Logging

The Bitnami fluent-bit Docker image sends the container logs to the `stdout`. To view the logs:

```console
$ docker logs fluent-bit
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-fluent-bit/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-fluent-bit/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-fluent-bit/issues/new). For us to provide better support, be sure to include the following information in your issue:

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
