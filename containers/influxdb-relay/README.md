# What is InfluxDB Relay?

> [InfluxDB Relay](https://github.com/influxdata/influxdb-relay) adds a basic high availability layer to InfluxDB by loadbalancing UDP/TCP traffic to each InfluxDB server.

# TL;DR;

```bash
$ docker run --name influxdb-relay bitnami/influxdb-relay:latest
```

## Docker Compose

```bash
$ curl -LO https://raw.githubusercontent.com/bitnami/bitnami-docker-influxdb-relay/master/docker-compose.yml
$ docker-compose up
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DTC)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.

> This [CVE scan report](https://quay.io/repository/bitnami/influxdb-relay?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy InfluxDB in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami InfluxDB Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/influxdb).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/containers/how-to/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

> NOTE: Debian 9 images have been deprecated in favor of Debian 10 images. Bitnami will not longer publish new Docker images based on Debian 9.

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/).


* [`0-scratch`, `0.20161114.0-scratch-r2`, `0`, `0.20161114.0`, `0.20161114.0-r2`, `latest` (0/scratch/Dockerfile)](https://github.com/bitnami/bitnami-docker-influxdb-relay/blob/0.20161114.0/0/scratch/Dockerfile)

Subscribe to project updates by watching the [bitnami/influxdb-relay GitHub repo](https://github.com/bitnami/bitnami-docker-influxdb-relay).

# Get this image

The recommended way to get the Bitnami InfluxDB Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/influxdb-relay).

```bash
$ docker pull bitnami/influxdb-relay:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/influxdb-relay/tags/) in the Docker Hub Registry.

```bash
$ docker pull bitnami/influxdb-relay:[TAG]
```

If you wish, you can also build the image yourself.

```bash
$ docker build -t bitnami/influxdb-relay:latest 'https://github.com/bitnami/bitnami-docker-influxdb-relay.git#master:0/scratch'
```

# Configuration

The configuration can easily be setup by mounting your own configuration file (TOML format): `relay.toml`.

```bash
$ docker run --name influxdb-relay \
  --volume /path/to/relay.toml:/relay.toml \
  bitnami/influxdb-relay:latest \
  /influxdb-relay --config /relay.toml
```

After that, your configuration will be taken into account in InfluxDB Relay.

You can do this using Docker Compose by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-influxdb-relay/blob/master/docker-compose.yml) file present in this repository:

```yaml
influxdb-relay:
  ...
  command: /influxdb-relay --config /relay.toml
  volumes:
    - /path/to/relay.toml:/relay.toml:ro
  ...
```

## Further documentation

For further documentation, please check [InfluxDB Relay documentation](https://github.com/influxdata/influxdb-relay#configuration)

# Logging

The Bitnami InfluxDB Docker image sends the container logs to `stdout`. To view the logs:

```bash
$ docker logs influxdb-relay
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-influxdb-relay/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-influxdb-relay/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-influxdb-relay/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright (c) 2020 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
