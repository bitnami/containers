# What is PyTorch?

> PyTorch is a deep learning platform that accelerates the transition from research prototyping to production deployment. It is built for full integration into Python that enables you to use it with its libraries and main packages.
>
> PyTorch enables tensor computation with strong GPU acceleration and provides deep neural networks built on a tape-based autograd system for faster and more flexible experimentation and efficient production deployment.
>
> The docker image includes Torchvision for specific computer vision support. The Torchvision package includes common datasets, model architectures and image transformations for computer vision.

[pytorch.org](https://pytorch.org/)

# TL;DR

```console
$ docker run -it --name pytorch bitnami/pytorch
```

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-pytorch/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.

> This [CVE scan report](https://quay.io/repository/bitnami/pytorch?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`1`, `1-debian-10`, `1.8.1`, `1.8.1-debian-10-r29`, `latest` (1/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-pytorch/blob/1.8.1-debian-10-r29/1/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/pytorch GitHub repo](https://github.com/bitnami/bitnami-docker-pytorch).

# Get this image

The recommended way to get the Bitnami Pytorch Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/pytorch).

```console
$ docker pull bitnami/pytorch:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/pytorch/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/pytorch:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/pytorch 'https://github.com/bitnami/bitnami-docker-pytorch.git#master:1/debian-10'
```

# Entering the REPL

By default, running this image will drop you into the Python REPL, where you can interactively test and try things out with PyTorch in Python.

```console
$ docker run -it --name pytorch bitnami/pytorch
```

# Configuration

## Running your PyTorch app

The default work directory for the PyTorch image is `/app`. You can mount a folder from your host here that includes your PyTorch script, and run it normally using the `python` command.

```console
$ docker run -it --name pytorch -v /path/to/app:/app bitnami/pytorch \
  python script.py
```

## Running a PyTorch app with package dependencies

If your PyTorch app has a `requirements.txt` defining your app's dependencies, you can install the dependencies before running your app.

```console
$ docker run -it --name pytorch -v /path/to/app:/app bitnami/pytorch \
  sh -c "conda install -y --file requirements.txt && python script.py"
```

**Further Reading:**

  - [pytorch documentation](https://pytorch.org/docs/stable/index.html)
  - [conda documentation](https://docs.conda.io/en/latest/)

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of PyTorch, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```console
$ docker pull bitnami/pytorch:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/pytorch:latest`.

### Step 2: Remove the currently running container

```console
$ docker rm -v pytorch
```

or using Docker Compose:

```console
$ docker-compose rm -v pytorch
```

### Step 3: Run the new image

Re-create your container from the new image.

```console
$ docker run --name pytorch bitnami/pytorch:latest
```

or using Docker Compose:

```console
$ docker-compose up pytorch
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-pytorch/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-pytorch/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-pytorch/issues/new). For us to provide better support, be sure to include the following information in your issue:

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
