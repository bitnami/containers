[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-metrics-server/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-metrics-server/tree/master)

# What is Metrics Server?

Metrics Server is a cluster-wide aggregator of resource usage data. Metrics Server collects metrics from the Summary API, exposed by Kubelet on each node.

[https://github.com/kubernetes-incubator/metrics-server](https://github.com/kubernetes-incubator/metrics-server)

# TL;DR;

Deploy Metrics Server on your [Kubernetes cluster](https://github.com/kubernetes/heapster/tree/master/docs).

```bash
$ docker run --name metrics-server bitnami/metrics-server:latest
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* Bitnami images are built on CircleCI and automatically pushed to the Docker Hub.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.

# Supported tags and respective `Dockerfile` links

> NOTE: Debian 8 images have been deprecated in favor of Debian 9 images. Bitnami will not longer publish new Docker images based on Debian 8.


* [`0-ol-7`, `0.2.1-ol-7-r20` (0/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-metrics-server/blob/0.2.1-ol-7-r20/0/ol-7/Dockerfile)
* [`0-debian-9`, `0.2.1-debian-9-r26`, `0`, `0.2.1`, `0.2.1-r26`, `latest` (0/Dockerfile)](https://github.com/bitnami/bitnami-docker-metrics-server/blob/0.2.1-debian-9-r26/0/Dockerfile)

Subscribe to project updates by watching the [bitnami/metrics-server GitHub repo](https://github.com/bitnami/bitnami-docker-metrics-server).

# Configuration

For further documentation, please check [here](https://github.com/kubernetes-incubator/metrics-server).

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-metrics-server/issues), or submit a [pull
request](https://github.com/bitnami/bitnami-docker-metrics-server/pulls) with your contribution.

# Issues

<!-- If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-metrics-server/issues). For us to provide better support, be sure to include the following information in your issue: -->

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
