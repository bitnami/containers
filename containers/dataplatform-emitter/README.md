# Data Platform Blueprint 2 packaged by Bitnami

## What is Data Platform Blueprint 2?

> The metrics generator for OCTO Data Platform Blueprints includes the most critical metrics to determine the health of the data platform. See the Data Platform Blueprint 2 Helm Chart.

[Overview of Data Platform Blueprint 2](https://bitnami.com/stack/data-platform-metrics-emitter)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
$ docker run --name dataplatform-emitter bitnami/dataplatform-emitter:latest
```

## Why use Bitnami Images?

- Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
- With Bitnami images the latest bug fixes and features are available as soon as possible.
- Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
- All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
- All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
- Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/dataplatform-emitter?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


- [`1`, `1-scratch`, `1.0.1`, `1.0.1-scratch-r9`, `latest` (1/scratch/Dockerfile)](https://github.com/bitnami/bitnami-docker-dataplatform-emitter/blob/1.0.1-scratch-r9/1/scratch/Dockerfile)
- [`0`, `0-scratch`, `0.0.11`, `0.0.11-scratch-r5` (0/scratch/Dockerfile)](https://github.com/bitnami/bitnami-docker-dataplatform-emitter/blob/0.0.11-scratch-r5/0/scratch/Dockerfile)

Subscribe to project updates by watching the [bitnami/dataplatform-emitter GitHub repo](https://github.com/bitnami/bitnami-docker-dataplatform-emitter).

## Get this image

The recommended way to get the Bitnami dataplatform-emitter Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/dataplatform-emitter).

```console
$ docker pull bitnami/dataplatform-emitter:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/dataplatform-emitter/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/dataplatform-emitter:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/dataplatform-emitter:latest 'https://github.com/bitnami/bitnami-docker-dataplatform-emitter.git#master:1/scratch'
```

# How to deploy Data Platform Blueprint 2 in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Data Platform Blueprint chart](https://github.com/bitnami/charts/tree/master/bitnami/dataplatform-bp1).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

## Configuration

### Running commands

To run commands inside this container you can use `docker run`, for example to execute `dataplatform-emitter --emitter.listen-address :9782` you can follow the example below:

```console
$ docker run --rm --name dataplatform-emitter bitnami/dataplatform-emitter:latest --  --emitter.listen-address :9782
```

## Branch Deprecation Notice

Data Platform Blueprint 2's branch 0 is no longer maintained by upstream and is now internally tagged as to be deprecated. This branch will no longer be released in our catalog a month after this notice is published, but already released container images will still persist in the registries. Valid to be removed starting on: 01-31-2022

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-dataplatform-emitter/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-dataplatform-emitter/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-dataplatform-emitter/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

## License

Copyright &copy; 2022 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
