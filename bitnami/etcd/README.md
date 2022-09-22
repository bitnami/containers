# Etcd packaged by Bitnami

## What is Etcd?

> etcd is a distributed key-value store designed to securely store data across a cluster. etcd is widely used in production on account of its reliability, fault-tolerance and ease of use.

[Overview of Etcd](https://etcd.io/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
$ docker run -it --name Etcd bitnami/etcd
```

### Docker Compose

```console
$ curl -LO https://raw.githubusercontent.com/bitnami/containers/main/bitnami/etcd/docker-compose.yml
$ docker-compose up
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

## How to deploy Etcd in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Etcd Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/etcd).

Bitnami containers can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`3.5`, `3.5-debian-11`, `3.5.5`, `3.5.5-debian-11-r2`, `latest` (3.5/debian-11/Dockerfile)](https://github.com/bitnami/containers/blob/main/bitnami/etcd/3.5/debian-11/Dockerfile)
* [`3.4`, `3.4-debian-11`, `3.4.21`, `3.4.21-debian-11-r3` (3.4/debian-11/Dockerfile)](https://github.com/bitnami/containers/blob/main/bitnami/etcd/3.4/debian-11/Dockerfile)
* [`3.3`, `3.3-debian-11`, `3.3.27`, `3.3.27-debian-11-r39` (3.3/debian-11/Dockerfile)](https://github.com/bitnami/containers/blob/main/bitnami/etcd/3.3/debian-11/Dockerfile)

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Prerequisites

To run this application you need [Docker Engine](https://www.docker.com/products/docker-engine) >= `1.10.0`. [Docker Compose](https://docs.docker.com/compose/) is recommended with a version `1.6.0` or later.

## Get this image

The recommended way to get the Bitnami Etcd Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/etcd).

```console
$ docker pull bitnami/etcd:latest
```

To use a specific version, you can pull a versioned tag. You can view the
[list of available versions](https://hub.docker.com/r/bitnami/etcd/tags/)
in the Docker Hub Registry.

```console
$ docker pull bitnami/etcd:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
$ git clone https://github.com/bitnami/containers.git
$ cd bitnami/APP/VERSION/OPERATING-SYSTEM
$ docker build -t bitnami/APP:latest .
```

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a Etcd server running inside a container can easily be accessed by your application containers using a Etcd client.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

In this example, we will create a Etcd client instance that will connect to the server instance that is running on the same docker network as the client.

#### Step 1: Create a network

```console
$ docker network create app-tier --driver bridge
```

#### Step 2: Launch the Etcd server instance

Use the `--network app-tier` argument to the `docker run` command to attach the Etcd container to the `app-tier` network.

```console
$ docker run -d --name Etcd-server \
    --network app-tier \
    --publish 2379:2379 \
    --publish 2380:2380 \
    --env ALLOW_NONE_AUTHENTICATION=yes \
    --env ETCD_ADVERTISE_CLIENT_URLS=http://etcd-server:2379 \
    bitnami/etcd:latest
```

#### Step 3: Launch your Etcd client instance

Finally we create a new container instance to launch the Etcd client and connect to the server created in the previous step:

```console
$ docker run -it --rm \
    --network app-tier \
    --env ALLOW_NONE_AUTHENTICATION=yes \
    bitnami/etcd:latest etcdctl --endpoints http://etcd-server:2379 put /message Hello
```

### Using Docker Compose

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `app-tier`. In this example we assume that you want to connect to the Etcd server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge

services:
  Etcd:
    image: 'bitnami/etcd:latest'
    environment:
      - ALLOW_NONE_AUTHENTICATION=yes
      - ETCD_ADVERTISE_CLIENT_URLS=http://etcd:2379
    ports:
      - 2379:2379
      - 2380:2380
    networks:
      - app-tier
  myapp:
    image: 'YOUR_APPLICATION_IMAGE'
    networks:
      - app-tier
```

> **IMPORTANT**:
>
> 1. Please update the placeholder `YOUR_APPLICATION_IMAGE` in the above snippet with your application image
> 2. In your application container, use the hostname `etcd` to connect to the Etcd server

Launch the containers using:

```console
$ docker-compose up -d
```

## Configuration

The configuration can easily be setup by mounting your own configuration file on the directory `/opt/bitnami/etcd/conf`:

```console
$ docker run --name Etcd -v /path/to/Etcd.conf.yml:/opt/bitnami/Etcd/conf/etcd.conf.yml bitnami/etcd:latest
```

After that, your configuration will be taken into account in the server's behaviour.

You can also do this by changing the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/etcd/docker-compose.yml) file present in this repository:

```yaml
Etcd:
  ...
  volumes:
    - /path/to/Etcd.conf.yml:/opt/bitnami/etcd/conf/etcd.conf.yml
  ...
```

You can find a sample configuration file on this [link](https://github.com/coreos/etcd/blob/master/etcd.conf.yml.sample)

Apart from providing your custom configuration file, you can also modify the server behavior via configuration flags exposed as environment variables.

For example if you want to modify the flag `--my-flag`, you will need to set the `ETCD_MY_FLAG` environment variable.

The previous rule applies to all [etcd flags](https://coreos.com/etcd/docs/latest/op-guide/configuration.html).

> Note: by default the environment variable `ETCDCTL_API` is set to `3`. Modify this environment variable to use a different API version.

## Notable Changes

### 3.4.15-debian-10-r7

* The container now contains the needed logic to deploy the Etcd container on Kubernetes using the [Bitnami Etcd Chart](https://github.com/bitnami/charts/tree/master/bitnami/etcd).

### 3.4.13-debian-10-r7

* Arbitrary user ID(s) are supported again, see https://github.com/etcd-io/etcd/issues/12158 for more information abut the changes in the upstream source code

### 3.4.10-debian-10-r0

* Arbitrary user ID(s) when running the container with a non-privileged user are not supported (only `1001` UID is allowed).

## Further documentation

For further documentation, please check [Etcd documentation](https://coreos.com/etcd/docs/latest/) or its [GitHub repository](https://github.com/coreos/etcd)

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues), or submit a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/containers/issues/new/choose). For us to provide better support, be sure to fill the issue template.

## License

Copyright &copy; 2022 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
