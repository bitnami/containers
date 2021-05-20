
# What is Pushgateway?

The Prometheus Pushgateway exists to allow ephemeral and batch jobs to expose their metrics to Prometheus. Since these kinds of jobs may not exist long enough to be scraped, they can instead push their metrics to a Pushgateway. The Pushgateway then exposes these metrics to Prometheus.

[https://prometheus.io/](https://prometheus.io/)

# TL;DR

```console
$ docker run --name pushgateway bitnami/pushgateway:latest
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/pushgateway?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`1`, `1-debian-10`, `1.4.0`, `1.4.0-debian-10-r114`, `latest` (1/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-pushgateway/blob/1.4.0-debian-10-r114/1/debian-10/Dockerfile)
* [`0`, `0-debian-10`, `0.10.0`, `0.10.0-debian-10-r444` (0/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-pushgateway/blob/0.10.0-debian-10-r444/0/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/pushgateway GitHub repo](https://github.com/bitnami/bitnami-docker-pushgateway).

# Get this image

The recommended way to get the Bitnami Pushgateway Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/pushgateway).

```console
$ docker pull bitnami/pushgateway:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/pushgateway/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/pushgateway:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/pushgateway:latest 'https://github.com/bitnami/bitnami-docker-pushgateway.git#master:1/debian-10'
```

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

### Step 1: Create a network

```console
$ docker network create pushgateway-network --driver bridge
```

### Step 2: Launch the Blacbox_exporter container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `pushgateway-network` network.

```console
$ docker run --name pushgateway-node1 --network pushgateway-network bitnami/pushgateway:latest
```

### Step 3: Run another containers

We can launch another containers using the same flag (`--network NETWORK`) in the `docker run` command. If you also set a name to your container, you will be able to use it as hostname in your network.


# Configuration

The Pushgateway has to be configured as a target to scrape by Prometheus, using one of the usual methods. However, you should always set honor_labels: true in the scrape config (see below for a detailed explanation).

[Further information](https://prometheus.io/docs/instrumenting/pushing/)

# Logging

The Bitnami pushgateway Docker image sends the container logs to the `stdout`. To view the logs:

```console
$ docker logs pushgateway
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of pushgateway, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```console
$ docker pull bitnami/pushgateway:latest
```

### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
$ docker stop pushgateway
```

Next, take a snapshot of the persistent volume `/path/to/pushgateway-persistence` using:

```console
$ rsync -a /path/to/pushgateway-persistence /path/to/pushgateway-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

You can use this snapshot to restore the database state should the upgrade fail.

### Step 3: Remove the currently running container

```console
$ docker rm -v pushgateway
```

### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if necessary.

```console
$ docker run --name pushgateway bitnami/pushgateway:latest
```

# Branch Deprecation Notice

Prometheus Pushgateway's branch 0 is no longer maintained by upstream and is now internally tagged as to be deprecated. This branch will no longer be released in our catalog a month after this notice is published, but already released container images will still persist in the registries. Valid to be removed starting on: 06-19-2021

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-pushgateway/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-pushgateway/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-pushgateway/issues/new). For us to provide better support, be sure to include the following information in your issue:

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
