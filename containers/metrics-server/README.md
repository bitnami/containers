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
* Bitnami container images are released daily with the latest distribution packages available.

[![Anchore Image Overview](https://anchore.io/service/badges/image/531b87df597d52b68b114f7ce662f17facb6ff252339ce7b7c3d3c1e4a28e0f8)](https://anchore.io/image/dockerhub/bitnami%2Fmetrics-server%3Alatest#security)

> The image overview badge contains a security report with all open CVEs. Click on 'Show only CVEs with fixes' to get the list of actionable security issues.

# How to deploy Metrics Server in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Metrics Server Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/metrics-server).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/containers/how-to/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

> NOTE: Debian 8 images have been deprecated in favor of Debian 9 images. Bitnami will not longer publish new Docker images based on Debian 8.

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/).


* [`0-ol-7`, `0.3.1-ol-7-r54` (0/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-metrics-server/blob/0.3.1-ol-7-r54/0/ol-7/Dockerfile)
* [`0-debian-9`, `0.3.1-debian-9-r44`, `0`, `0.3.1`, `0.3.1-r44`, `latest` (0/debian-9/Dockerfile)](https://github.com/bitnami/bitnami-docker-metrics-server/blob/0.3.1-debian-9-r44/0/debian-9/Dockerfile)

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
