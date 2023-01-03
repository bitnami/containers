# PyTorch for Intel packaged by Bitnami

## What is PyTorch for Intel?

> PyTorch is an open-source deep learning framework that accelerates the path from research to production. Equipped with a performance-optimized PyTorch deep learning framework on Intel platforms.  

[Overview of PyTorch for Intel](https://pytorch.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
$ docker run -it --name pytorch bitnami/pytorch-intel:latest
```

### Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/containers/main/bitnami/pytorch-intel/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

## Why use Intel optimized containers

Optimized containers fully leverage 3rd gen Intel(R) Xeon(R) Scalable Processor (Ice Lake) cores and architecture. Intel(R) AVX-512 instructions have been further improved to accelerate performance for HPC/AI across a diverse set of workloads, including 3D modeling, scientific simulation, financial analytics, machine learning and AI, image processing, visualization, digital content creation, and data compression.  This wider vectorization speeds computation processes per clock, increasing frequency over the prior generation. New instructions, coupled with algorithmic and software innovations, also deliver breakthrough performance for the industry's most widely deployed cryptographic ciphers. Security is becoming more pervasive with most organizations increasingly adopting encryption for application execution, data in flight, and data storage.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami Pytorch Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/pytorch-intel).

```console
$ docker pull bitnami/pytorch-intel:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/pytorch-intel/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/pytorch-intel:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
$ git clone https://github.com/bitnami/containers.git
$ cd bitnami/APP/VERSION/OPERATING-SYSTEM
$ docker build -t bitnami/APP:latest .
```

## Entering the REPL

By default, running this image will drop you into the Python REPL, where you can interactively test and try things out with PyTorch for Intel in Python.

```console
$ docker run -it --name pytorch bitnami/pytorch-intel
```

## Configuration

### Running your PyTorch for Intel app

The default work directory for the PyTorch for Intel image is `/app`. You can mount a folder from your host here that includes your PyTorch for Intel script, and run it normally using the `python` command.

```console
$ docker run -it --name pytorch -v /path/to/app:/app bitnami/pytorch-intel \
  python script.py
```

### Running a PyTorch for Intel app with package dependencies

If your PyTorch for Intel app has a `requirements.txt` defining your app's dependencies, you can install the dependencies before running your app.

```console
$ docker run -it --name pytorch -v /path/to/app:/app bitnami/pytorch-intel \
  sh -c "pip install -r requirements.txt && python script.py"
```

**Further Reading:**

  - [pytorch documentation](https://pytorch.org/docs/stable/index.html)

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of PyTorch for Intel, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
$ docker pull bitnami/pytorch-intel:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/pytorch-intel:latest`.

#### Step 2: Remove the currently running container

```console
$ docker rm -v pytorch
```

or using Docker Compose:

```console
$ docker-compose rm -v pytorch
```

#### Step 3: Run the new image

Re-create your container from the new image.

```console
$ docker run --name pytorch bitnami/pytorch-intel:latest
```

or using Docker Compose:

```console
$ docker-compose up pytorch
```

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/containers/issues/new/choose). For us to provide better support, be sure to fill the issue template.

## License

Copyright &copy; 2023 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
