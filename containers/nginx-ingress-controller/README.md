# What is NGINX Ingress Controller?

NGINX Ingress Controller is an Ingress controller that uses NGINX to manage external access to HTTP services in a Kubernetes cluster.

https://github.com/kubernetes/ingress-nginx

# TL;DR

Deploy NGINX Ingress Controller for Kubernetes on your [Kubernetes cluster](https://kubernetes.io/docs/concepts/services-networking/ingress/).


```console
$ docker run --name nginx-ingress-controller bitnami/nginx-ingress-controller:latest
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/nginx-ingress-controller?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy NGINX Ingress Controller in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami NGINX Ingress Controller Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/nginx-ingress-controller).


Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Supported tags and respective `Dockerfile` links


* [`0`, `0-debian-10`, `0.46.0`, `0.46.0-debian-10-r16`, `latest` (0/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-nginx-ingress-controller/blob/0.46.0-debian-10-r16/0/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/nginx-ingress-controller GitHub repo](https://github.com/bitnami/bitnami-docker-nginx-ingress-controller).


# Configuration

For further documentation, please check [here](https://github.com/kubernetes/ingress-nginx).


# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-nginx-ingress-controller/issues), or submit a [pull
request](https://github.com/bitnami/bitnami-docker-nginx-ingress-controller/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-nginx-ingress-controller/issues/new). For us to provide better support, be sure to include the following information in your issue:

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
