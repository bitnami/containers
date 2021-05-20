# What is Gradle?

>  Gradle is a build tool with a focus on build automation and support for multi-language development.

[gradle.org](https://gradle.org/)

# TL;DR

```console
$ docker run -it --name gradle bitnami/gradle
```

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-gradle/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/gradle?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`7`, `7-debian-10`, `7.0.2`, `7.0.2-debian-10-r0`, `latest` (7/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-gradle/blob/7.0.2-debian-10-r0/7/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/gradle GitHub repo](https://github.com/bitnami/bitnami-docker-gradle).

# Get this image

The recommended way to get the Bitnami Gradle Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/gradle).

```console
$ docker pull bitnami/gradle:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/gradle/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/gradle:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/gradle 'https://github.com/bitnami/bitnami-docker-gradle.git#master:7/debian-10'
```

# Configuration

## Running your Gradle builds

The default work directory for the Gradle image is `/app`. You can mount a folder from your host here that includes your Gradle build script, and run any task specifying its identifier.

```console
$ docker run --name gradle -v /path/to/app:/app bitnami/gradle \
  build
```

**Further Reading:**

  - [gradle documentation](https://docs.gradle.org/)
  - [gradle command-line interface](https://docs.gradle.org/current/userguide/command_line_interface.html)

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of Gradle, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```console
$ docker pull bitnami/gradle:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/gradle:latest`.

### Step 2: Remove the currently running container

```console
$ docker rm -v gradle
```

or using Docker Compose:

```console
$ docker-compose rm -v gradle
```

### Step 3: Run the new image

Re-create your container from the new image.

```console
$ docker run --name gradle bitnami/gradle:latest
```

or using Docker Compose:

```console
$ docker-compose up gradle
```

# Contributing

We'd love for you to contribute to this Docker image. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-gradle/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-gradle/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-gradle/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive
information)

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
