
# What is Kapacitor?

> Kapacitor is a native data processing engine for InfluxDB. Kapacitor can process both stream and batch data from InfluxDB, acting on this data in real-time via its programming language TICKscript.

[Overview of Kapacitor](https://github.com/influxdata/kapacitor)

# TL;DR;

```console
$ docker run --name kapacitor bitnami/kapacitor:latest
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DTC)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/kapacitor?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`1`, `1-debian-10`, `1.5.9`, `1.5.9-debian-10-r42`, `latest` (1/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-kapacitor/blob/1.5.9-debian-10-r42/1/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/kapacitor GitHub repo](https://github.com/bitnami/bitnami-docker-kapacitor).

# Get this image

The recommended way to get the Bitnami kapacitor Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/kapacitor).

```console
$ docker pull bitnami/kapacitor:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/kapacitor/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/kapacitor:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/kapacitor:latest 'https://github.com/bitnami/bitnami-docker-kapacitor.git#master:1/debian-10'
```

# Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/kapacitor` path. If the mounted directory is empty, it will be initialized on the first run.

```console
$ docker run \
    -v /path/to/kapacitor-persistence:/bitnami/kapacitor \
    bitnami/kapacitor:latest
```

# Configuration

## Running commands

The container has the `kapacitor`, `kapacitord` and `tickfmt` commands available. To run commands inside this container you can use `docker run`, for example to execute `kapacitord --help` you can follow the example below:

```console
$ docker run --rm --name kapacitor bitnami/kapacitor:latest -- kapacitord --help
```

Check the [official Kapacitor documentation](https://docs.influxdata.com/kapacitor) for a list of the available parameters.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-kapacitor/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-kapacitor/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-kapacitor/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright 2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
