# What is Keycloak Gatekeeper?

> Keycloak Gatekeeper is an adapter which integrates with the Keycloak authentication service supporting both access tokens in browser cookie or bearer tokens.

[https://github.com/keycloak/keycloak-gatekeeper](https://github.com/keycloak/keycloak-gatekeeper)

# TL;DR;

```bash
$ docker run --rm --name keycloak-gatekeeper bitnami/keycloak-gatekeeper:2 /keycloak-gatekeeper --help
```

## Docker Compose

```bash
$ curl -LO https://raw.githubusercontent.com/bitnami/bitnami-docker-keycloak-gatekeeper/master/docker-compose.yml
$ docker-compose up
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DTC)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.

> This [CVE scan report](https://quay.io/repository/bitnami/keycloak-gatekeeper?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/containers/how-to/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

> NOTE: Debian 9 images have been deprecated in favor of Debian 10 images. Bitnami will not longer publish new Docker images based on Debian 9.

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/).


* [`8-scratch`, `8.0.1-scratch-r0`, `8`, `8.0.1`, `8.0.1-r0`, `latest` (8/scratch/Dockerfile)](https://github.com/bitnami/bitnami-docker-keycloak-gatekeeper/blob/8.0.1/8/scratch/Dockerfile)

Subscribe to project updates by watching the [bitnami/keycloak-gatekeeper GitHub repo](https://github.com/bitnami/bitnami-docker-keycloak-gatekeeper).

# Prerequisites

To run this application you need [Docker Engine](https://www.docker.com/products/docker-engine) >= `1.10.0`. [Docker Compose](https://www.docker.com/products/docker-compose) is recommended with a version `1.6.0` or later.

# Get this image

The recommended way to get the Bitnami Keycloak Gatekeeper Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/keycloak-gatekeeper).

```bash
$ docker pull bitnami/keycloak-gatekeeper:latest
```

To use a specific version, you can pull a versioned tag. You can view the
[list of available versions](https://hub.docker.com/r/bitnami/keycloak-gatekeeper/tags/)
in the Docker Hub Registry.

```bash
$ docker pull bitnami/keycloak-gatekeeper:[TAG]
```

If you wish, you can also build the image yourself.

```bash
$ docker build -t bitnami/keycloak-gatekeeper:latest 'https://github.com/bitnami/bitnami-docker-keycloak-gatekeeper.git#master:8/scratch'
```

# Configuration

## Using a configuration file

The configuration can easily be setup by mounting your own configuration file on the directory `/opt/bitnami/keycloak-gatekeeper/conf` (both JSON and YAML formats are supported: `config.json` or `config.yaml`).

```bash
$ docker run --name keycloak-gatekeeper \
  --volume /path/to/config.yaml:/opt/bitnami/keycloak-gatekeeper/config.yaml \
  bitnami/keycloak-gatekeeper:latest \
  /keycloak-gatekeeper --config /opt/bitnami/keycloak-gatekeeper/config.yaml
```

After that, your configuration will be taken into account in Keycloak Gatekeeper.

You can do this using Docker Compose by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-keycloak-gatekeeper/blob/master/docker-compose.yml) file present in this repository:

```yaml
keycloak-gatekeeper:
  ...
  command: /keycloak-gatekeeper --config /opt/bitnami/keycloak-gatekeeper/config.yaml
  volumes:
    - /path/to/config.yaml:/opt/bitnami/keycloak-gatekeeper/config.yaml:ro
  ...
```

## Using command-line options

The configuration can also be setup by providing command-line options.

```bash
$ docker run --name keycloak-gatekeeper bitnami/keycloak-gatekeeper:latest /keycloak-gatekeeper \
  --listen 127.0.0.1:3000 \
  --upstream-url http://127.0.0.1:80 \
  --discovery-url https://keycloak.example.com/auth/realms/<REALM_NAME> \
  --client-id <CLIENT_ID>
```

You can do this using Docker Compose by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-keycloak-gatekeeper/blob/master/docker-compose.yml) file present in this repository:

```yaml
keycloak-gatekeeper:
  ...
  command:
    - /keycloak-gatekeeper
    - --listen
    - 127.0.0.1:3000
    - --upstream-url
    - http://127.0.0.1:80
    - --discovery-url
    - https://keycloak.example.com/auth/realms/<REALM_NAME>
    - --client-id
    - <CLIENT_ID>
  ...
```

Find more information about the available configuration options on this [link](https://www.keycloak.org/docs/latest/securing_apps/index.html#configuration-options)

## Further documentation

For further documentation, please check [Keycloak Gatekeeper documentation](https://www.keycloak.org/docs/latest/securing_apps/index.html#_keycloak_generic_adapter)

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-keycloak-gatekeeper/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-keycloak-gatekeeper/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-keycloak-gatekeeper/issues). For us to provide better support, be sure to include the following information in your issue:

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
