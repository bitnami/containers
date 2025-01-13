# Bitnami package for Python

## What is Python?

> Python is a programming language that lets you work quickly and integrate systems more effectively.

[Overview of Python](https://www.python.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run -it --name python bitnami/python
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Python in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

### Deprecation Note (2022-01-21)

The `prod` tags has been removed; from now on just the regular container images will be released.

### Deprecation Note (2020-08-18)

The formatting convention for `prod` tags has been changed:

* `BRANCH-debian-10-prod` is now tagged as `BRANCH-prod-debian-10`
* `VERSION-debian-10-rX-prod` is now tagged as `VERSION-prod-debian-10-rX`
* `latest-prod` is now deprecated

## Get this image

The recommended way to get the Bitnami Python Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/python).

```console
docker pull bitnami/python:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/python/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/python:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Entering the REPL

By default, running this image will drop you into the Python REPL, where you can interactively test and try things out in Python.

```console
docker run -it --name python bitnami/python
```

## Configuration

### Running your Python script

The default work directory for the Python image is `/app`. You can mount a folder from your host here that includes your Python script, and run it normally using the `python` command.

```console
docker run -it --name python -v /path/to/app:/app bitnami/python \
  python script.py
```

### Running a Python app with package dependencies

If your Python app has a `requirements.txt` defining your app's dependencies, you can install the dependencies before running your app.

```console
docker run --rm -v /path/to/app:/app bitnami/python pip install -r requirements.txt
docker run -it --name python -v /path/to/app:/app bitnami/python python script.py
```

or using Docker Compose:

```yaml
python:
  image: bitnami/python:latest
  command: "sh -c 'pip install -r requirements.txt && python script.py'"
  volumes:
    - .:/app
```

**Further Reading:**

* [python documentation](https://www.python.org/doc/)
* [pip documentation](https://pip.pypa.io/en/stable/)

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of Python, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/python:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/python:latest`.

#### Step 2: Remove the currently running container

```console
docker rm -v python
```

or using Docker Compose:

```console
docker-compose rm -v python
```

#### Step 3: Run the new image

Re-create your container from the new image.

```console
docker run --name python bitnami/python:latest
```

or using Docker Compose:

```console
docker-compose up python
```

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes.

If you detect any issue in the `docker-compose.yaml` file, feel free to report it or contribute with a fix by following our [Contributing Guidelines](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md).

## Contributing

We'd love for you to contribute to this Docker image. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/containers/issues/new/choose). For us to provide better support, be sure to fill the issue template.

## License

Copyright &copy; 2025 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
