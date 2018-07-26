[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-open-service-broker-azure/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-open-service-broker-azure/tree/master)

# What is Open Service Broker for Azure?

Open Service Broker for Azure is the open source, [Open Service Broker](https://www.openservicebrokerapi.org/)-compatible API server that provisions managed services in the Microsoft Azure public cloud.

# Prerequisites

In order to use the charts in this repository, you must have the following components installed:

1. A compatible [Kubernetes](https://github.com/kubernetes/kubernetes) cluster (version 1.7 or later)
1. [Helm](https://github.com/kubernetes/helm)
1. [Kubernetes Service Catalog](https://github.com/kubernetes-incubator/service-catalog)
1. [Open Service Broker for Azure](https://github.com/azure/open-service-broker-azure)

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* Bitnami images are built on CircleCI and automatically pushed to the Docker Hub.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.

# Supported tags and respective `Dockerfile` links

> NOTE: Debian 8 images have been deprecated in favor of Debian 9 images. Bitnami will not longer publish new Docker images based on Debian 8.


* [`1-ol-7`, `1.0.1-ol-7-r8` (1/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-open-service-broker-azure/blob/1.0.1-ol-7-r8/1/ol-7/Dockerfile)
* [`1-debian-9`, `1.0.1-debian-9-r9`, `1`, `1.0.1`, `1.0.1-r9`, `latest` (1/Dockerfile)](https://github.com/bitnami/bitnami-docker-open-service-broker-azure/blob/1.0.1-debian-9-r9/1/Dockerfile)

Subscribe to project updates by watching the [bitnami/open-service-broker-azure GitHub repo](https://github.com/bitnami/bitnami-docker-open-service-broker-azure).

# Get this image

The recommended way to get the Bitnami Open Service Broker Azure Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/open-service-broker-azure).

```bash
$ docker pull bitnami/open-service-broker-azure:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/open-service-broker-azure/tags/) in the Docker Hub Registry.

```bash
$ docker pull bitnami/open-service-broker-azure:[TAG]
```

If you wish, you can also build the image yourself.

```bash
$ docker build -t bitnami/open-service-broker-azure:latest https://github.com/bitnami/bitnami-docker-open-service-broker-azure.git
```

# Configuration

# Further documentation

For further documentation, please check [here](https://github.com/Azure/open-service-broker-azure/tree/master/docs)

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-open-service-broker-azure/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-open-service-broker-azure/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-open-service-broker-azure/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright 2018 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
