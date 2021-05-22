# What is Python?

> Python is a programming language that lets you work quickly and integrate systems more effectively

[python.org](https://www.python.org/)

# TL;DR

```console
$ docker run -it --name python bitnami/python-snapshot
```

> **_NOTE:_**  This Python "snapshot" container is based on [Debian Snapshot archive](https://snapshot.debian.org/). This archive provides a valuable resource for tracking down when regressions were introduced, or for providing a specific environment that a particular application may require to run. Using a specific snapshot repository allows you to build the container from source at any time and continue using the same system package versions.
> Bitnami also provides containers based on the upstream Debian repository that allows you to rebuild the container and get the latests packages available, see "bitnami-docker-python" repository.

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-python-snapshot/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/python-snapshot?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`3.9-prod`, `3.9-prod-debian-10`, `3.9.5-prod`, `3.9.5-prod-debian-10-r18` (3.9-prod/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-python-snapshot/blob/3.9.5-prod-debian-10-r18/3.9-prod/debian-10/Dockerfile)
* [`3.9`, `3.9-debian-10`, `3.9.5`, `3.9.5-debian-10-r18` (3.9/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-python-snapshot/blob/3.9.5-debian-10-r18/3.9/debian-10/Dockerfile)
* [`3.8-prod`, `3.8-prod-debian-10`, `3.8.10-prod`, `3.8.10-prod-debian-10-r18` (3.8-prod/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-python-snapshot/blob/3.8.10-prod-debian-10-r18/3.8-prod/debian-10/Dockerfile)
* [`3.8`, `3.8-debian-10`, `3.8.10`, `3.8.10-debian-10-r18` (3.8/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-python-snapshot/blob/3.8.10-debian-10-r18/3.8/debian-10/Dockerfile)
* [`3.7-prod`, `3.7-prod-debian-10`, `3.7.10-prod`, `3.7.10-prod-debian-10-r89` (3.7-prod/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-python-snapshot/blob/3.7.10-prod-debian-10-r89/3.7-prod/debian-10/Dockerfile)
* [`3.7`, `3.7-debian-10`, `3.7.10`, `3.7.10-debian-10-r90`, `latest` (3.7/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-python-snapshot/blob/3.7.10-debian-10-r90/3.7/debian-10/Dockerfile)
* [`3.6-prod`, `3.6-prod-debian-10`, `3.6.13-prod`, `3.6.13-prod-debian-10-r92` (3.6-prod/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-python-snapshot/blob/3.6.13-prod-debian-10-r92/3.6-prod/debian-10/Dockerfile)
* [`3.6`, `3.6-debian-10`, `3.6.13`, `3.6.13-debian-10-r91` (3.6/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-python-snapshot/blob/3.6.13-debian-10-r91/3.6/debian-10/Dockerfile)
* [`2-prod`, `2-prod-debian-10`, `2.7.18-prod`, `2.7.18-prod-debian-10-r290` (2-prod/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-python-snapshot/blob/2.7.18-prod-debian-10-r290/2-prod/debian-10/Dockerfile)
* [`2`, `2-debian-10`, `2.7.18`, `2.7.18-debian-10-r291` (2/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-python-snapshot/blob/2.7.18-debian-10-r291/2/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/python-snapshot GitHub repo](https://github.com/bitnami/bitnami-docker-python-snapshot).

# What are `prod` tagged containers for?

Containers tagged `prod` are production containers based on [minideb](https://github.com/bitnami/minideb). They contain the minimal dependencies required by an application to work.

They don't include development dependencies, so they are commonly used in multi-stage builds as the target image. Application code and dependencies should be copied from a different container.

The resultant containers only contain the necessary pieces of software to run the application. Therefore, they are smaller and safer.

Learn how to use multi-stage builds to build your production application container in the [example](/example) directory

# Get this image

The recommended way to get the Bitnami Python Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/python-snapshot).

```console
$ docker pull bitnami/python-snapshot:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/python-snapshot/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/python-snapshot:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/python-snapshot 'https://github.com/bitnami/bitnami-docker-python-snapshot.git#master:3.7/debian-10'
```

# Entering the REPL

By default, running this image will drop you into the Python REPL, where you can interactively test and try things out in Python.

```console
$ docker run -it --name python bitnami/python-snapshot
```

# Configuration

## Running your Python script

The default work directory for the Python image is `/app`. You can mount a folder from your host here that includes your Python script, and run it normally using the `python` command.

```console
$ docker run -it --name python -v /path/to/app:/app bitnami/python-snapshot \
  python script.py
```

## Running a Python app with package dependencies

If your Python app has a `requirements.txt` defining your app's dependencies, you can install the dependencies before running your app.

```console
$ docker run --rm -v /path/to/app:/app bitnami/python-snapshot pip install -r requirements.txt
$ docker run -it --name python -v /path/to/app:/app bitnami/python-snapshot python script.py
```

or using Docker Compose:

```yaml
python:
  image: bitnami/python-snapshot:latest
  command: "sh -c 'pip install -r requirements.txt && python script.py'"
  volumes:
    - .:/app
```

**Further Reading:**

  - [python documentation](https://www.python.org/doc/)
  - [pip documentation](https://pip.pypa.io/en/stable/)

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of Python, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```console
$ docker pull bitnami/python-snapshot:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/python-snapshot:latest`.

### Step 2: Remove the currently running container

```console
$ docker rm -v python
```

or using Docker Compose:

```console
$ docker-compose rm -v python
```

### Step 3: Run the new image

Re-create your container from the new image.

```console
$ docker run --name python bitnami/python-snapshot:latest
```

or using Docker Compose:

```console
$ docker-compose up python
```

# Contributing

We'd love for you to contribute to this Docker image. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-python-snapshot/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-python-snapshot/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-python-snapshot/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive
information)

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
