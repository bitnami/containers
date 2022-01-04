# Concourse packaged by Bitnami

## What is Concourse?

> Concourse is an open source automation tool. It enables developers to create and configure workflows using YAML.

[Overview of Concourse](https://concourse-ci.org/)



## TL;DR

```console
$ docker run --name concourse bitnami/concourse:latest
```

### Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-concourse/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

**Warning**: This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options for the [PostgreSQL container](https://github.com/bitnami/bitnami-docker-postgresql#readme) for a more secure deployment.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.

> This [CVE scan report](https://quay.io/repository/bitnami/concourse?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/containers/how-to/work-with-non-root-containers/).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/).


* [`7`, `7-debian-10`, `7.6.0`, `7.6.0-debian-10-r61`, `latest` (7/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-concourse/blob/7.6.0-debian-10-r61/7/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/concourse GitHub repo](https://github.com/bitnami/bitnami-docker-concourse).

## Get this image

The recommended way to get the Bitnami concourse Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/concourse).

```console
$ docker pull bitnami/concourse:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/concourse/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/concourse:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/concourse:latest 'https://github.com/bitnami/bitnami-docker-concourse.git#master:7/debian-10'
```

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami` path. If the mounted directory is empty, it will be initialized on the first run.

```console
$ docker run \
    -v /path/to/concourse-persistence:/bitnami/concourse \
    bitnami/concourse:latest
```

You can also do this with a minor change to the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-concourse/blob/master/docker-compose.yml) file present in this repository:

```yaml
concourse:
  ...
  volumes:
    - /path/to/concourse-persistence:/bitnami/concourse
  ...
```

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

#### Step 1: Create a network

```console
$ docker network create concourse-network --driver bridge
```

#### Step 2: Launch the concourse container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `concourse-network` network.

```console
$ docker run --name concourse-node1 --network concourse-network bitnami/concourse:latest
```

#### Step 3: Run another container

We can launch another container using the same flag (`--network NETWORK`) in the `docker run` command. If you also set a name to your container, you will be able to use it as hostname in your network.

## Configuration

Find how to configure Concourse in its [official documentation](https://concourse-ci.org//docs.html).

## Logging

The Bitnami concourse Docker image sends the container logs to `stdout`. To view the logs:

```console
$ docker logs concourse
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of concourse, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
$ docker pull bitnami/concourse:latest
```

#### Step 2: Stop the running container

Stop the currently running container using the command

```console
$ docker stop concourse
```

#### Step 3: Remove the currently running container

```console
$ docker rm -v concourse
```

#### Step 4: Run the new image

Re-create your container from the new image.

```console
$ docker run --name concourse bitnami/concourse:latest
```

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-concourse/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-concourse/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-concourse/issues). For us to provide better support, be sure to include the following information in your issue:

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
