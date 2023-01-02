# Envoy for Intel packaged by Bitnami

## What is Envoy for Intel?

> Envoy is a high-performance proxy for cloud-native applications. This image has been optimized to boost its performance on IceLake processors.

[Overview of Envoy for Intel](https://www.envoyproxy.io/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
$ docker run --name envoy bitnami/envoy-intel:latest
```

## Why use Intel optimized containers

Optimized containers fully leverage 3rd gen Intel(R) Xeon(R) Scalable Processor (Ice Lake) cores and architecture. Intel(R) AVX-512 instructions have been further improved to accelerate performance for HPC/AI across a diverse set of workloads, including 3D modeling, scientific simulation, financial analytics, machine learning, and AI, image processing, visualization, digital content creation, and data compression. This wider vectorization speeds computation processes per clock, increasing frequency over the prior generation. New instructions, coupled with algorithmic and software innovations, also deliver breakthrough performance for the industry's most widely deployed cryptographic ciphers. Security is becoming more pervasive with most organizations increasingly adopting encryption for application execution, data in flight, and data storage.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami Envoy for Intel Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/envoy-intel).

```console
$ docker pull bitnami/envoy-intel:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/envoy-intel/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/envoy-intel:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
$ git clone https://github.com/bitnami/containers.git
$ cd bitnami/APP/VERSION/OPERATING-SYSTEM
$ docker build -t bitnami/APP:latest .
```

## Configuration

### Running commands

To run commands inside this container you can use `docker run`, for example to execute `envoy --version` you can follow the example below:

```console
$ docker run --rm --name envoy bitnami/envoy-intel:latest -- --version
```

Check the [official envoy documentation](https://www.envoyproxy.io/docs/envoy/latest/operations/cli) for a list of the available parameters.

### Adding your custom configuration

By default, envoy will look for a configuration file in `/opt/bitnami/envoy/conf/envoy.yaml`. You can launch the envoy container with your custom configuration with the command below:

```console
$ docker run --rm -v /path/to/your/envoy.yaml:/opt/bitnami/envoy/conf/envoy.yaml bitnami/envoy-intel:latest
```

Visit the [official envoy documentation](https://www.envoyproxy.io/docs/envoy/latest/configuration/configuration) for all the available configurations.

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/containers/issues/new/choose). For us to provide better support, be sure to fill the issue template.

## License

Copyright &copy; 2023 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
