# Spring Cloud Skipper Shell packaged by Bitnami

## What is Spring Cloud Skipper Shell?

> Spring Cloud Skipper Shell is a tool for interacting with the Spring Cloud Data Skipper server.

[Overview of Spring Cloud Skipper Shell](https://github.com/spring-cloud/spring-cloud-skipper)



## TL;DR

```console
$ docker run --name spring-cloud-skipper-shell bitnami/spring-cloud-skipper-shell:latest
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/spring-cloud-skipper-shell?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`2`, `2-debian-10`, `2.8.1`, `2.8.1-debian-10-r61`, `latest` (2/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-spring-cloud-skipper-shell/blob/2.8.1-debian-10-r61/2/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/spring-cloud-skipper-shell GitHub repo](https://github.com/bitnami/bitnami-docker-spring-cloud-skipper-shell).

## Get this image

The recommended way to get the Bitnami spring-cloud-skipper-shell Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/spring-cloud-skipper-shell).

```console
$ docker pull bitnami/spring-cloud-skipper-shell:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/spring-cloud-skipper-shell/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/spring-cloud-skipper-shell:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/spring-cloud-skipper-shell:latest 'https://github.com/bitnami/bitnami-docker-spring-cloud-skipper-shell.git#master:2/debian-10'
```

## Configuration

### Running commands

To run commands inside this container you can use `docker run`, for example to execute `spring-cloud-skipper-shell --help` you can follow the example below:

```console
$ docker run --rm --name spring-cloud-skipper-shell bitnami/spring-cloud-skipper-shell:latest --help
```

Consult the [spring-cloud-skipper-shell Reference Documentation](https://docs.spring.io/spring-cloud-skipper/docs/current/reference/htmlsingle/#using-shell) to find the completed list of commands available.

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-spring-cloud-skipper-shell/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-spring-cloud-skipper-shell/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-spring-cloud-skipper-shell/issues/new). Be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

### Community supported solution

Please, note this asset is a community-supported solution. This means that the Bitnami team is not actively working on new features/improvements nor providing support through GitHub Issues. Any new issue will stay open for 20 days to allow the community to contribute, after 15 days without activity the issue will be marked as stale being closed after 5 days.

The Bitnami team will review any PR that is created, feel free to create a PR if you find any issue or want to implement a new feature.

New versions and releases cadence are not going to be affected. Once a new version is released in the upstream project, the Bitnami container image will be updated to use the latest version, supporting the different branches supported by the upstream project as usual.

## License

Copyright 2022 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
