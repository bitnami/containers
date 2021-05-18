
# What is Alertmanager?

The Alertmanager handles alerts sent by client applications such as the Prometheus server. It takes care of deduplicating, grouping, and routing them to the correct receiver integrations such as email, PagerDuty, or OpsGenie. It also takes care of silencing and inhibition of alerts.

[https://github.com/prometheus/alertmanager](https://github.com/prometheus/alertmanager)

# TL;DR

```console
$ docker run --name alertmanager bitnami/alertmanager:latest
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/alertmanager?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`0`, `0-debian-10`, `0.21.0`, `0.21.0-debian-10-r311`, `latest` (0/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-alertmanager/blob/0.21.0-debian-10-r311/0/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/alertmanager GitHub repo](https://github.com/bitnami/bitnami-docker-alertmanager).

# Get this image

The recommended way to get the Bitnami Alertmanager Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/alertmanager).

```console
$ docker pull bitnami/alertmanager:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/alertmanager/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/alertmanager:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/alertmanager:latest 'https://github.com/bitnami/bitnami-docker-alertmanager.git#master:0/debian-10'
```

# Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/opt/bitnami/data` path. The above examples define a docker volume namely `alertmanager_data`. The Alertmanager application state will persist as long as this volume is not removed.

To avoid inadvertent removal of this volume you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

```console
$ docker run -v /path/to/alertmanager-persistence:/opt/bitnami/data bitnami/alertmanager:latest
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

### Step 1: Create a network

```console
$ docker network create alertmanager-network --driver bridge
```

### Step 2: Launch the Alertmanager container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `alertmanager-network` network.

```console
$ docker run --name alertmanager-node1 --network alertmanager-network bitnami/alertmanager:latest
```

### Step 3: Run another containers

We can launch another containers using the same flag (`--network NETWORK`) in the `docker run` command. If you also set a name to your container, you will be able to use it as hostname in your network.

# Configuration

The configuration can easily be setup by mounting your own configuration file on the directory `/opt/bitnami/alertmanager/conf/`:

```console
$ docker run --name alertmanager -v /path/to/config.yml:/opt/bitnami/alertmanager/conf/config.yml bitnami/alertmanager:latest
```

After that, your configuration will be taken into account in the server's behaviour.

Using Docker Compose:

```yaml
version: '2'

services:
  alertmanager:
    image: bitnami/alertmanager:latest
    volumes:
      - /path/to/config.yml:/opt/bitnami/alertmanager/conf/config.yml
```

Configuration is yaml based. The full documentation of the configuration can be found [here](https://prometheus.io/docs/alerting/configuration/).

## Amtool

`amtool` is a cli tool for interacting with the alertmanager api. It is bundled with all releases of alertmanager.

# Logging

The Bitnami alertmanager Docker image sends the container logs to the `stdout`. To view the logs:

```console
$ docker logs alertmanager
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of alertmanager, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```console
$ docker pull bitnami/alertmanager:latest
```

### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
$ docker stop alertmanager
```

Next, take a snapshot of the persistent volume `/path/to/alertmanager-persistence` using:

```console
$ rsync -a /path/to/alertmanager-persistence /path/to/alertmanager-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

You can use this snapshot to restore the database state should the upgrade fail.

### Step 3: Remove the currently running container

```console
$ docker rm -v alertmanager
```

### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if necessary.

```console
$ docker run --name alertmanager bitnami/alertmanager:latest
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-alertmanager/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-alertmanager/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-alertmanager/issues/new). For us to provide better support, be sure to include the following information in your issue:

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
