# Bitnami package for Node Exporter

## What is Node Exporter?

> Prometheus exporter for hardware and OS metrics exposed by UNIX kernels, with pluggable metric collectors.

[Overview of Node Exporter](https://prometheus.io/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name node-exporter bitnami/node-exporter:latest
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Node Exporter in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami Node Exporter Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/node-exporter).

```console
docker pull bitnami/node-exporter:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/node-exporter/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/node-exporter:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

#### Step 1: Create a network

```console
docker network create node-exporter-network --driver bridge
```

#### Step 2: Launch the Node Exporter container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `node-exporter-network` network.

```console
docker run --name node-exporter-node1 --network node-exporter-network bitnami/node-exporter:latest
```

#### Step 3: Run another container

We can launch another container using the same flag (`--network NETWORK`) in the `docker run` command. If you also set a name for your container, you will be able to use it as a hostname in your network.

## Configuration

There is varying support for collectors on each operating system.

Collectors are enabled by providing a `--collector.<name>` flag. Collectors that are enabled by default can be disabled by providing a `--no-collector.<name>` flag.
[Further information](https://prometheus.io/docs/introduction/overview/)

## Logging

The Bitnami Node Exporter Docker image sends the container logs to the `stdout`. To view the logs:

```console
docker logs node-exporter
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of node-exporter, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/node-exporter:latest
```

#### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
docker stop node-exporter
```

Next, take a snapshot of the persistent volume `/path/to/node-exporter-persistence` using:

```console
rsync -a /path/to/node-exporter-persistence /path/to/node-exporter-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

You can use this snapshot to restore the database state should the upgrade fail.

#### Step 3: Remove the currently running container

```console
docker rm -v node-exporter
```

#### Step 4: Run the new image

Re-create your container from the new image, restoring your backup if necessary.

```console
docker run --name node-exporter bitnami/node-exporter:latest
```

## Notable Changes

### Starting January 16, 2024

* The `docker-compose.yaml` file has been removed, as it was solely intended for internal testing purposes.

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

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
