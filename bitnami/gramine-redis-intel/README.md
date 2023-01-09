# Bitnami package for Redis&reg;-Confidential Compute

## What is Redis&reg; with Intel SGX?

> This containerized version of Redis&reg; protects data from unauthorized access to the operating system. Gramine secures Redis&reg; container image in secure Intel SGX (Software Guard Extensions) enclaves

[Overview of Redis&reg; with Intel SGX](https://github.com/gramineproject/gramine)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
$ docker run -it --name gramine-redis-intel -p 6379:6379 --device=/dev/sgx/enclave --device=/dev/sgx/provision bitnami/gramine-redis-intel
```

### Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/containers/main/bitnami/gramine-redis-intel/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

## Why use Intel optimized containers

Encryption is becoming pervasive with most organizations increasingly adopting encryption for application execution, data in flight, and data storage. Intel(R) 3rd gen Xeon(R) Scalable Processor (Ice Lake) cores and architecture, offers several new instructions for encryption acceleration. These new instructions, coupled with algorithmic and software innovations, deliver breakthrough performance for the industry's most widely deployed cryptographic ciphers.

This solution accelerates the processing of the Transport Layer Security (TLS) significantly by using built-in Intel crypto acceleration included in the latest Intel 3rd gen Xeon Scalable Processor (Ice Lake). For more information, refer to Intel's documentation.

It requires a 3rd gen Xeon Scalable Processor (Ice Lake) to get a breakthrough performance improvement.

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

The recommended way to get the Bitnami Redis(R) with Intel SGX Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/gramine-redis-intel).

```console
$ docker pull bitnami/gramine-redis-intel:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/gramine-redis-intel/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/gramine-redis-intel:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
$ git clone https://github.com/bitnami/containers.git
$ cd bitnami/APP/VERSION/OPERATING-SYSTEM
$ docker build -t bitnami/APP:latest .
```

**Further Reading:**

  - [Gramine Redis(R) documentation](https://github.com/gramineproject/gramine)

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of Redis&reg; with Intel SGX, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
$ docker pull bitnami/gramine-redis-intel:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/gramine-redis-intel:latest`.

#### Step 2: Remove the currently running container

```console
$ docker rm -v gramine-redis-intel
```

or using Docker Compose:

```console
$ docker-compose rm -v gramine-redis-intel
```

#### Step 3: Run the new image

Re-create your container from the new image.

```console
$ docker run --name gramine-redis-intel -p 6379:6379 --device=/dev/sgx/enclave --device=/dev/sgx/provision bitnami/gramine-redis-intel:latest
```

or using Docker Compose:

```console
$ docker-compose up gramine-redis-intel
```

## Contributing

We'd love for you to contribute to this Docker image. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

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
