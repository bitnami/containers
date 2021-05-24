# What is Grafana Operator?

A Kubernetes Operator based on the Operator SDK for creating and managing Grafana instances.

[https://github.com/integr8ly/grafana-operator](https://github.com/integr8ly/grafana-operator)

# TL;DR

Deploy [Grafana Operator](https://github.com/integr8ly/grafana-operator/tree/master/documentation) on your Kubernetes cluster.

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.

> This [CVE scan report](https://quay.io/repository/bitnami/grafana-operator?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# How to deploy Grafana Operator in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Grafana Operator Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/grafana-operator).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`3`, `3-debian-10`, `3.10.1`, `3.10.1-debian-10-r9`, `latest` (3/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-grafana-operator/blob/3.10.1-debian-10-r9/3/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/grafana-operator GitHub repo](https://github.com/bitnami/bitnami-docker-grafana-operator).

# Get this image

The recommended way to get the Bitnami Grafana Operator Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/grafana-operator).

```console
$ docker pull bitnami/grafana-operator:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/grafana-operator/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/grafana-operator:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/grafana-operator:latest 'https://github.com/bitnami/bitnami-docker-grafana-operator.git#master:3/debian-10'
```

# Configuration

Find how to configure Grafana Operator in its [official documentation](https://github.com/integr8ly/grafana-operator/tree/master/documentation).

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-grafana-operator/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-grafana-operator/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-grafana-operator/issues/new). For us to provide better support, be sure to include the following information in your issue:

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
