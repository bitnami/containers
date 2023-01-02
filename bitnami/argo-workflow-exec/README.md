# Argo Workflow Executor packaged by Bitnami

## What is Argo Workflow Executor?

> Argo Workflow Executor is the executor component for the Argo Workflows engine, which is meant to orchestrate Kubernetes jobs in parallel.

[Overview of Argo Workflow Executor](https://argoproj.github.io/workflows)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
$ docker run -it --name argo-workflow-exec bitnami/argo-workflow-exec
```

### Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/containers/main/bitnami/argo-workflow-exec/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

## How to deploy Argo Workflows Executor in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Argo Workflows Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/argo-workflows).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami Argo Workflows Executor Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/argo-workflow-exec).

```console
$ docker pull bitnami/argo-workflow-exec:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/argo-workflow-exec/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/argo-workflow-exec:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
$ git clone https://github.com/bitnami/containers.git
$ cd bitnami/APP/VERSION/OPERATING-SYSTEM
$ docker build -t bitnami/APP:latest .
```

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of Argo Workflows Executor, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
$ docker pull bitnami/argo-workflow-exec:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/argo-workflow-exec:latest`.

#### Step 2: Remove the currently running container

```console
$ docker rm -v argo-workflow-exec
```

or using Docker Compose:

```console
$ docker-compose rm -v argo-workflow-exec
```

#### Step 3: Run the new image

Re-create your container from the new image.

```console
$ docker run --name argo-workflow-exec bitnami/argo-workflow-exec:latest
```

or using Docker Compose:

```console
$ docker-compose up argo-workflow-exec
```

## Configuration

### Running commands

To run commands inside this container you can use `docker run`, for example to execute `argocd --help` you can follow the example below:

```console
$ docker run --rm --name argo-workflow-exec bitnami/argo-workflow-exec:latest --help
```

Check the [official Argo Workflows Executor documentation](https://argoproj.github.io/argo-workflows/workflow-executors/) for the list of the available parameters.

## Contributing

We'd love for you to contribute to this Docker image. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

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
