# What is Apache MXNet (Incubating)?

>A flexible and efficient library for deep learning.
Based on the the Gluon API specification, the new Gluon library in Apache MXNet (Incubating) provides a clear, concise, and simple API for deep learning. It makes it easy to prototype, build, and train deep learning models without sacrificing training speed. Install the latest version of Apache MXNet (Incubating) to get access to Gluon.

[mxnet.incubator.apache.org](https://mxnet.incubator.apache.org/versions/master/)

# TL;DR

```console
$ docker run -it --name mxnet bitnami/mxnet
```

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-mxnet/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.

> This [CVE scan report](https://quay.io/repository/bitnami/mxnet?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`1`, `1-debian-10`, `1.8.0`, `1.8.0-debian-10-r57`, `latest` (1/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-mxnet/blob/1.8.0-debian-10-r57/1/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/mxnet GitHub repo](https://github.com/bitnami/bitnami-docker-mxnet).

# Get this image

The recommended way to get the Bitnami Apache MXNet (Incubating) Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/mxnet).

```console
$ docker pull bitnami/mxnet:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/mxnet/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/mxnet:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/mxnet 'https://github.com/bitnami/bitnami-docker-mxnet.git#master:1/debian-10'
```

# Entering the REPL

By default, running this image will drop you into the Python REPL, where you can interactively test and try things out with mxnet in Python.

```console
$ docker run -it --name mxnet bitnami/mxnet
```

# Configuration

## Running your Apache MXNet (Incubating) app

The default work directory for the mxnet image is `/app`. You can mount a folder from your host here that includes your mxnet script, and run it normally using the `python` command.

```console
$ docker run -it --name mxnet -v /path/to/app:/app bitnami/mxnet \
  python script.py
```

## Running an Apache MXNet (Incubating) app with package dependencies

If your mxnet app has a `requirements.txt` defining your app's dependencies, you can install the dependencies before running your app.

```console
$ docker run -it --name mxnet -v /path/to/app:/app bitnami/mxnet \
  sh -c "pip install -y --file requirements.txt && python script.py"
```

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of Apache MXNet (Incubating), including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```console
$ docker pull bitnami/mxnet:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/mxnet:latest`.

### Step 2: Remove the currently running container

```console
$ docker rm -v mxnet
```

or using Docker Compose:

```console
$ docker-compose rm -v mxnet
```

### Step 3: Run the new image

Re-create your container from the new image.

```console
$ docker run --name mxnet bitnami/mxnet:latest
```

or using Docker Compose:

```console
$ docker-compose up mxnet
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-mxnet/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-mxnet/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-mxnet/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`$ docker version`)
- Output of `$ docker info`
- Version of this container (`$ echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright (c) 2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
