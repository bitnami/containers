# What is Logstash?

Logstash is an open source, server-side data processing pipeline that ingests data from a multitude of sources simultaneously, transforms it, and then sends it to your favorite "stash."
[https://www.elastic.co/products/logstash](https://www.elastic.co/products/logstash)

# TL;DR

```console
$ docker run --name logstash bitnami/logstash:latest
```

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-logstash/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.

> This [CVE scan report](https://quay.io/repository/bitnami/logstash?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy Logstash in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Logstash Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/logstash).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`7`, `7-debian-10`, `7.12.1`, `7.12.1-debian-10-r17`, `latest` (7/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-logstash/blob/7.12.1-debian-10-r17/7/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/logstash GitHub repo](https://github.com/bitnami/bitnami-docker-logstash).

# Get this image

The recommended way to get the Bitnami Logstash Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/logstash).

```console
$ docker pull bitnami/logstash:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/logstash/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/logstash:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/logstash:latest 'https://github.com/bitnami/bitnami-docker-logstash.git#master:7/debian-10'
```

# Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami` path. If the mounted directory is empty, it will be initialized on the first run.

```console
$ docker run \
    -v /path/to/logstash-persistence:/bitnami \
    bitnami/logstash:latest
```

You can also do this with a minor change to the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-logstash/blob/master/docker-compose.yml) file present in this repository:

```yaml
logstash:
  ...
  volumes:
    - /path/to/logstash-persistence:/bitnami
  ...
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

### Step 1: Create a network

```console
$ docker network create logstash-network --driver bridge
```

### Step 2: Launch the Logstash container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `logstash-network` network.

```console
$ docker run --name logstash-node1 --network logstash-network bitnami/logstash:latest
```

### Step 3: Run another containers

We can launch another containers using the same flag (`--network NETWORK`) in the `docker run` command. If you also set a name to your container, you will be able to use it as hostname in your network.

# Configuration

This container, by default, provides a very basic configuration for logstash, that listen http on port 8080 and writes to stdout.

```console
$ docker run -d -p 8080:8080 bitnami/logstash:latest
```

## Using a configuration string

For simple configurations, you specify it using the `LOGSTASH_CONF_STRING` environment variable:

```console
$ docker run --env LOGSTASH_CONF_STRING="input {file {path => \"/tmp/logstash_input\"}} output {file {path => \"/tmp/logstash_output\"}}" bitnami/logstash:latest
```

## Using a configuration file

You can override the default configuration for logstash by mounting your own configuration files on directory `/bitnami/logstash/config`. You will need to indicate the file holding the pipeline definition by setting the `LOGSTASH_CONF_FILENAME` environment variable.

```console
$ docker run -d --env LOGSTASH_CONF_FILENAME=my_config.conf -v /path/to/custom-conf-directory:/bitnami/logstash/config bitnami/logstash:latest
```

## Additional command line options

In case you want to add extra flags to the Logstash command, use the `LOGSTASH_EXTRA_ARGS` variable. Example:

```console
$ docker run -d --env LOGSTASH_EXTRA_ARGS="-w 4 -b 4096" bitnami/logstash:latest
```

## Using multiple pipelines

You can use [multiple pipelines](https://www.elastic.co/guide/en/logstash/master/multiple-pipelines.html) by setting the `LOGSTASH_ENABLE_MULTIPLE_PIPELINES` environment variable to `true`.

In that case, you should place your `pipelines.yml` file in the mounted volume (together with the rest of the desired configuration files). If the `LOGSTASH_ENABLE_MULTIPLE_PIPELINES` environment variable is set to `true` but there is not any `pipelines.yml` file in the mounted volume, a dummy file is created using `LOGSTASH_CONF_FILENAME` as a single pipeline.

```console
$ docker run -d --env LOGSTASH_ENABLE_MULTIPLE_PIPELINES=true -v /path/to/custom-conf-directory:/bitnami/logstash/config bitnami/logstash:latest
```

## Exposing logstash API

You can expose the logstash API by setting the environment variable `LOGSTASH_EXPOSE_API`, you can also change the default port by using `LOGSTASH_API_PORT_NUMBER`.

```console
$ docker run -d --env LOGSTASH_EXPOSE_API=yes --env LOGSTASH_API_PORT_NUMBER=9090 -p 9090:9090 bitnami/logstash:latest
```

# Logging

The Bitnami Logstash Docker image sends the container logs to `stdout`. To view the logs:

```console
$ docker logs logstash
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

Additionally, in case you'd like to modify Logstash logging configuration, it can be done by overwriting the file `/opt/bitnami/logstash/config/log4j2.properties`.
The syntax of this file can be found in Logstash [logging documentation](https://www.elastic.co/guide/en/logstash/current/logging.html).

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of Logstash, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```console
$ docker pull bitnami/logstash:latest
```

### Step 2: Stop the running container

Stop the currently running container using the command

```console
$ docker stop logstash
```

### Step 3: Remove the currently running container

```console
$ docker rm -v logstash
```

### Step 4: Run the new image

Re-create your container from the new image.

```console
$ docker run --name logstash bitnami/logstash:latest
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-logstash/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-logstash/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-logstash/issues/new). For us to provide better support, be sure to include the following information in your issue:

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
