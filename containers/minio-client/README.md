# What is MinIO Client?

> MinIO Client is a Golang CLI tool that offers alternatives for ls, cp, mkdir, diff, and rsync commands for filesystems and object storage systems.

[min.io](https://min.io/)

# TL;DR;

```console
$ docker run --name minio-client bitnami/minio-client:latest
```

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-minio-client/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DTC)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.

> This [CVE scan report](https://quay.io/repository/bitnami/minio-client?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`2020-debian-10`, `2020.5.6-debian-10-r7`, `2020`, `2020.5.6`, `latest` (2020/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-minio/blob/2020.5.6-debian-10-r7/2020/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/minio-client GitHub repo](https://github.com/bitnami/bitnami-docker-minio-client).

# Get this image

The recommended way to get the Bitnami MinIO Client Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/minio-client).

```console
$ docker pull bitnami/minio-client:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/minio-client/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/minio-client:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/minio-client:latest 'https://github.com/bitnami/bitnami-docker-minio-client.git#master:2020/debian-10'
```

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a MinIO Client can be used to access other running containers such as [MinIO server](https://github.com/bitnami/bitnami-docker-minio).

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

In this example, we will create a MinIO Client container that will connect to a MinIO server container that is running on the same docker network.

### Step 1: Create a network

```console
$ docker network create app-tier --driver bridge
```

### Step 2: Launch the MinIO server container

Use the `--network app-tier` argument to the `docker run` command to attach the MinIO container to the `app-tier` network.

```console
$ docker run -d --name minio-server \
    --env MINIO_ACCESS_KEY="minio-access-key" \
    --env MINIO_SECRET_KEY="minio-secret-key" \
    --network app-tier \
    bitnami/minio:latest
```

### Step 3: Launch your MinIO Client container

Finally we create a new container instance to launch the MinIO client and connect to the server created in the previous step. In this example, we create a new bucket in the MinIO storage server:

```console
$ docker run --rm --name minio-client \
    --env MINIO_SERVER_HOST="minio" \
    --env MINIO_SERVER_ACCESS_KEY="minio-access-key" \
    --env MINIO_SERVER_SECRET_KEY="minio-secret-key" \
    --network app-tier \
    bitnami/minio-client \
    mb minio/my-bucket
```

# Configuration

MinIO Client (`mc`) can be setup so it is already configured to point to a specific MinIO server by providing the environment variables below:

- `MINIO_SERVER_HOST`: MinIO server host.
- `MINIO_SERVER_PORT_NUMBER`: MinIO server port. Default: `9000`.
- `MINIO_SERVER_ACCESS_KEY`: MinIO server Access Key. Must be common on every node.
- `MINIO_SERVER_SECRET_KEY`: MinIO server Secret Key. Must be common on every node.

For instance, use the command below to create a new bucket in the MinIO Server `my.minio.domain`:

```console
$ docker run --rm --name minio-client \
    --env MINIO_SERVER_HOST="my.minio.domain" \
    --env MINIO_SERVER_ACCESS_KEY="minio-access-key" \
    --env MINIO_SERVER_SECRET_KEY="minio-secret-key" \
    bitnami/minio-client \
    mb minio/my-bucket
```

Find more information about the client configuration in the [MinIO Client documentation](https://docs.min.io/docs/minio-admin-complete-guide.html).

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-minio-client/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-minio-client/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-minio-client/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright (c) 2020 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
