
# What is Prometheus?

Prometheus, is a systems and service monitoring system. It collects metrics from configured targets at given intervals, evaluates rule expressions, displays the results, and can trigger alerts if some condition is observed to be true.

Prometheus' main distinguishing features as compared to other monitoring systems are:

a multi-dimensional data model (timeseries defined by metric name and set of key/value dimensions)
a flexible query language to leverage this dimensionality
no dependency on distributed storage; single server nodes are autonomous
timeseries collection happens via a pull model over HTTP
pushing timeseries is supported via an intermediary gateway
targets are discovered via service discovery or static configuration
multiple modes of graphing and dashboarding support
support for hierarchical and horizontal federation

[https://prometheus.io/](https://prometheus.io/)

# TL;DR

```console
$ docker run --name prometheus bitnami/prometheus:latest
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/prometheus?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`2`, `2-debian-10`, `2.27.0`, `2.27.0-debian-10-r4`, `latest` (2/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-prometheus/blob/2.27.0-debian-10-r4/2/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/prometheus GitHub repo](https://github.com/bitnami/bitnami-docker-prometheus).

# Get this image

The recommended way to get the Bitnami Prometheus Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/prometheus).

```console
$ docker pull bitnami/prometheus:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/prometheus/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/prometheus:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/prometheus:latest 'https://github.com/bitnami/bitnami-docker-prometheus.git#master:2/debian-10'
```

# Persisting your database

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will add persistance even after the container is removed.

For persistence, mount a directory at the `/opt/bitnami/prometheus/data` path. If the mounted directory is empty, it will be initialized on the first run.

```console
$ docker run --name prometheus \
    -v /path/to/prometheus-persistence:/opt/bitnami/prometheus/data \
    bitnami/prometheus:latest
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

### Step 1: Create a network

```console
$ docker network create prometheus-network --driver bridge
```

### Step 2: Launch the Blacbox_exporter container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `prometheus-network` network.

```console
$ docker run --name prometheus-node1 --network prometheus-network bitnami/prometheus:latest
```

### Step 3: Run other containers

We can launch other containers using the same flag (`--network NETWORK`) in the `docker run` command. If you also set a name to your container, you will be able to use it as hostname in your network.

# Configuration

Prometheus is configured via command-line flags and a configuration file. While the command-line flags configure immutable system parameters (such as storage locations, amount of data to keep on disk and in memory, listening address, etc.), the configuration file defines everything related to scraping jobs and their instances, as well as which rule files to load.

Prometheus can reload its configuration at runtime. If the new configuration is not well-formed, the changes will not be applied. A configuration reload is triggered by sending a SIGHUP to the Prometheus process or sending a HTTP POST request to the /-/reload endpoint (when the --web.enable-lifecycle flag is enabled). This will also reload any configured rule files.

[Further information](https://prometheus.io/docs/prometheus/latest/configuration/configuration/)

## Command-Line Flags

You can add new flags to the ones already in use by default, which are passed to Prometheus through the `CMD` instruction in the Dockerfile.

To view all available command-line flags, run `docker run bitnami/prometheus:latest -h`.

## Configuration file

You can overwrite the default configuration file with your custom `prometheus.yml`. Create a custom conf file and mount it at `/opt/bitnami/prometheus/conf/prometheus.yml` like so:

```console
$ docker run --name prometheus \
    -v path/to/prometheus.yml:/opt/bitnami/prometheus/conf/prometheus.yml \
    bitnami/prometheus:latest
```

# Logging

The Bitnami Prometheus Docker image sends the container logs to the `stdout`. To view the logs:

```console
$ docker logs prometheus
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of prometheus, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```console
$ docker pull bitnami/prometheus:latest
```

### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
$ docker stop prometheus
```

Next, take a snapshot of the persistent volume `/path/to/prometheus-persistence` using:

```console
$ rsync -a /path/to/prometheus-persistence /path/to/prometheus-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

You can use this snapshot to restore the database state should the upgrade fail.

### Step 3: Remove the currently running container

```console
$ docker rm -v prometheus
```

### Step 4: Run the new image

Re-create your container from the new image, if necessary.

```console
$ docker run --name prometheus bitnami/prometheus:latest
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-prometheus/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-prometheus/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-prometheus/issues/new). For us to provide better support, be sure to include the following information in your issue:

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
