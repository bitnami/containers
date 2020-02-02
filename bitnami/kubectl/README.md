
# What is Kubectl?

> Kubectl is the Kubernetes command line interface.

[Overview of kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)

# TL;DR;

```bash
$ docker run --name kubectl bitnami/kubectl:latest
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DTC)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/kubectl?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Supported tags and respective `Dockerfile` links

> NOTE: Debian 9 images have been deprecated in favor of Debian 10 images. Bitnami will not longer publish new Docker images based on Debian 9.

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/).


* [`1.17-ol-7`, `1.17.2-ol-7-r10` (1.17/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-kubectl/blob/1.17.2-ol-7-r10/1.17/ol-7/Dockerfile)
* [`1.17-debian-10`, `1.17.2-debian-10-r8`, `1.17`, `1.17.2` (1.17/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-kubectl/blob/1.17.2-debian-10-r8/1.17/debian-10/Dockerfile)
* [`1.16-ol-7`, `1.16.3-ol-7-r80` (1.16/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-kubectl/blob/1.16.3-ol-7-r80/1.16/ol-7/Dockerfile)
* [`1.16-debian-10`, `1.16.3-debian-10-r8`, `1.16`, `1.16.3`, `latest` (1.16/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-kubectl/blob/1.16.3-debian-10-r8/1.16/debian-10/Dockerfile)
* [`1.15-ol-7`, `1.15.3-ol-7-r173` (1.15/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-kubectl/blob/1.15.3-ol-7-r173/1.15/ol-7/Dockerfile)
* [`1.15-debian-10`, `1.15.3-debian-10-r8`, `1.15`, `1.15.3` (1.15/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-kubectl/blob/1.15.3-debian-10-r8/1.15/debian-10/Dockerfile)
* [`1.14-ol-7`, `1.14.3-ol-7-r249` (1.14/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-kubectl/blob/1.14.3-ol-7-r249/1.14/ol-7/Dockerfile)
* [`1.14-debian-10`, `1.14.3-debian-10-r8`, `1.14`, `1.14.3` (1.14/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-kubectl/blob/1.14.3-debian-10-r8/1.14/debian-10/Dockerfile)
* [`1.13-ol-7`, `1.13.4-ol-7-r340` (1.13/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-kubectl/blob/1.13.4-ol-7-r340/1.13/ol-7/Dockerfile)
* [`1.13-debian-10`, `1.13.4-debian-10-r8`, `1.13`, `1.13.4` (1.13/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-kubectl/blob/1.13.4-debian-10-r8/1.13/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/kubectl GitHub repo](https://github.com/bitnami/bitnami-docker-kubectl).

# Get this image

The recommended way to get the Bitnami Kubectl Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/kubectl).

```bash
$ docker pull bitnami/kubectl:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/kubectl/tags/) in the Docker Hub Registry.

```bash
$ docker pull bitnami/kubectl:[TAG]
```

If you wish, you can also build the image yourself.

```bash
$ docker build -t bitnami/kubectl:latest 'https://github.com/bitnami/bitnami-docker-kubectl.git#master:1.16/debian-10'
```

# Configuration

## Running commands

To run commands inside this container you can use `docker run`, for example to execute `kubectl --version` you can follow the example below:

```bash
$ docker run --rm --name kubectl bitnami/kubectl:latest -- --version
```

Consult the [Kubectl Reference Documentation](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands) to find the completed list of commands available.

## Loading your own configuration

It's possible to load your own configuration, which is useful if you want to connect to a remote cluster:

```bash
$ docker run --rm --name kubectl -v /path/to/your/kube/config:/.kube/config bitnami/kubectl:latest
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-kubectl/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-kubectl/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-kubectl/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright 2020 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
