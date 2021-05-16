# What is .NET SDK?

> .NET is an open-source framework for web application development created by Microsoft.

[https://dotnet.microsoft.com/](https://dotnet.microsoft.com/)

# TL;DR

```console
$ docker run --name dotnet-sdk bitnami/dotnet-sdk:latest
```

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-dotnet-sdk/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.

> This [CVE scan report](https://quay.io/repository/bitnami/dotnet-sdk?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`5`, `5-debian-10`, `5.0.203`, `5.0.203-debian-10-r4` (5/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-dotnet-sdk/blob/5.0.203-debian-10-r4/5/debian-10/Dockerfile)
* [`3.1`, `3.1-debian-10`, `3.1.409`, `3.1.409-debian-10-r4`, `latest` (3.1/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-dotnet-sdk/blob/3.1.409-debian-10-r4/3.1/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/dotnet-sdk GitHub repo](https://github.com/bitnami/bitnami-docker-dotnet-sdk).

# Get this image

The recommended way to get the Bitnami .NET SDK Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/dotnet-sdk).

```console
$ docker pull bitnami/dotnet-sdk:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/dotnet-sdk/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/dotnet-sdk:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/dotnet-sdk:latest 'https://github.com/bitnami/bitnami-docker-dotnet-sdk.git#master:3.1/debian-10'
```

# Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami` path. If the mounted directory is empty, it will be initialized on the first run.

```console
$ docker run \
    -v /path/to/dotnet-persistence:/bitnami \
    bitnami/dotnet-sdk:latest
```

You can also do this with a minor change to the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-dotnet-sdk/blob/master/docker-compose.yml) file present in this repository:

```yaml
dotnet-sdk:
  ...
  volumes:
    - /path/to/dotnet-persistence:/app
  ...
```

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

### Step 1: Create a network

```console
$ docker network create dotnet-network --driver bridge
```

### Step 2: Launch the .NET SDK container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `dotnet-network` network.

```console
$ docker run --name dotnet-node1 --network dotnet-network bitnami/dotnet-sdk:latest
```

### Step 3: Run another containers

We can launch another containers using the same flag (`--network NETWORK`) in the `docker run` command. If you also set a name to your container, you will be able to use it as hostname in your network.

# Logging

The Bitnami .NET SDK Docker image sends the container logs to `stdout`. To view the logs:

```console
$ docker logs dotnet-sdk
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of .NET SDK, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```console
$ docker pull bitnami/dotnet-sdk:latest
```

### Step 2: Stop the running container

Stop the currently running container using the command

```console
$ docker stop dotnet-sdk
```

### Step 3: Remove the currently running container

```console
$ docker rm -v dotnet-sdk
```

### Step 4: Run the new image

Re-create your container from the new image.

```console
$ docker run --name dotnet-sdk bitnami/dotnet-sdk:latest
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-dotnet-sdk/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-dotnet-sdk/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-dotnet-sdk/issues/new). For us to provide better support, be sure to include the following information in your issue:

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
