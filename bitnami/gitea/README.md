# Gitea packaged by Bitnami

## What is Gitea?

> Gitea is a lightweight code hosting solution. Written in Go, features low resource consumption, easy upgrades and multiple databases.

[Overview of Gitea](https://gitea.io/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
$ docker run --name gitea bitnami/gitea:latest
```

### Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/containers/main/bitnami/gitea/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

## How to deploy Gitea in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Gitea Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/gitea).

Bitnami containers can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami Gitea Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/gitea).

```console
$ docker pull bitnami/gitea:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/gitea/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/gitea:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
$ git clone https://github.com/bitnami/containers.git
$ cd bitnami/APP/VERSION/OPERATING-SYSTEM
$ docker build -t bitnami/APP:latest .
```

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/gitea` path. If the mounted directory is empty, it will be initialized on the first run.

```console
$ docker run \
    --volume /path/to/gitea-persistence:/bitnami/gitea \
    --env ALLOM_EMPTY_PASSWORD=false \
    bitnami/gitea:latest
```

You can also do this with a minor change to the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/gitea/docker-compose.yml) file present in this repository:

```console
gitea:
  ...
  volumes:
    - /path/to/gitea-persistence:/bitnami/gitea
  ...
```

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

In this example, we will create a Gitea client instance that will connect to the server instance that is running on the same docker network as the client.

#### Step 1: Create a network

```console
$ docker network create my-network --driver bridge
```

#### Step 2: Launch the Gitea container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `my-network` network.

```console
$ docker run -d --name gitea-server \
  --network my-network \
  --env ALLOW_EMPTY_PASSWORD=yes \
  bitnami/gitea:latest
```

#### Step 3: Launch your Gitea client instance

Finally we create a new container instance to launch the Gitea client and connect to the server created in the previous step:

```console
$ docker run -it --rm \
    --network my-network \
    bitnami/gitea:latest gitea-client --host gitea-server
```

### Using Docker Compose

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `my-network`. In this example we assume that you want to connect to the Gitea server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  my-network:
    driver: bridge

services:
  gitea:
    image: bitnami/gitea:latest
    environment:
      - ALLOW_EMPTY_PASSWORD=no
    networks:
      - my-network
  myapp:
    image: 'YOUR_APPLICATION_IMAGE'
    networks:
      - my-network
```

> **IMPORTANT**:
>
> 1. Please update the `YOUR_APPLICATION_IMAGE` placeholder in the above snippet with your application image
> 2. In your application container, use the hostname `gitea` to connect to the Gitea server

Launch the containers using:

```console
$ docker-compose up -d
```

## Configuration

Gitea can be configured via environment variables or using a configuration file (`app.ini`). If a configuration option is not specified in either the configuration file or in an environment variable, Gitea uses its internal default configuration.

### Configuration overrides

The configuration can easily be setup by mounting your own configuration overrides on the directory `/bitnami/gitea/custom/conf/app.ini`:

```console
$ docker run --name gitea \
    --volume /path/to/override.ini:/bitnami/gitea/custom/conf/app.ini:ro \
    bitnami/gitea:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  gitea:
    image: bitnami/gitea:latest
    volumes:
      - /path/to/override.ini:/bitnami/gitea/custom/conf/app.ini:ro
```

Check the [official gitea configuration documentation](https://docs.gitea.io/en-us/config-cheat-sheet/) for all the possible overrides and settings.

### Initializing a new instance

In order to have your custom files inside the docker image you can mount them as a volume.

### Setting the admin password on first run

The admin user and password can easily be setup with the Bitnami Gitea Docker image using the following environment variables:

 - `GITEA_ADMIN_USER`: Admin user name. Defaults to `bn_user`.
 - `GITEA_ADMIN_PASSWORD`: Admin password. Defaults to `bitnami`.
 - `GITEA_ADMIN_EMAIL`: Admin user email. Defaults to `user@bitnami.org`.

Passing the `GITEA_ADMIN_PASSWORD` environment variable when running the image for the first time will set the password of the `GITEA_ADMIN_USER` user to the value of `GITEA_ADMIN_PASSWORD`.

```console
$ docker run --name gitea -e GITEA_ADMIN_PASSWORD=password123 bitnami/gitea:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/gitea/docker-compose.yml) file present in this repository:

```yaml
services:
  gitea:
  ...
    environment:
      - GITEA_ADMIN_PASSWORD=password123
  ...
```

### Changing the default ports

Gitea default ports can be changed using the following environment variables:

- `GITEA_HTTP_PORT`: HTTP port. Defaults to `3000`.
- `GITEA_SSH_LISTEN_PORT`: Port for the built-in SSH server. Defaults to `2222`

## Logging

The Bitnami Gitea Docker image sends the container logs to `stdout`. To view the logs:

```console
$ docker logs gitea
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of Gitea, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
$ docker pull bitnami/gitea:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/gitea:latest`.

#### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
$ docker stop gitea
```

or using Docker Compose:

```console
$ docker-compose stop gitea
```

Next, take a snapshot of the persistent volume `/path/to/gitea-persistence` using:

```console
$ rsync -a /path/to/gitea-persistence /path/to/gitea-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

#### Step 3: Remove the currently running container

```console
$ docker rm -v gitea
```

or using Docker Compose:

```console
$ docker-compose rm -v gitea
```

#### Step 4: Run the new image

Re-create your container from the new image.

```console
$ docker run --name gitea bitnami/gitea:latest
```

or using Docker Compose:

```console
$ docker-compose up gitea
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

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
