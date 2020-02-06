
# What is Apache Solr?

> Solr is the popular, blazing-fast, open source enterprise search platform built on Apache Lucene.

[http://lucene.apache.org/solr/](http://lucene.apache.org/solr/)

# TL;DR;

```bash
$ docker run --name solr bitnami/solr:latest
```

## Docker Compose

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-solr/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DTC)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/solr?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy Apache Solr in Kubernetes?

You can find an example for testing in the file `test.yaml`. To launch this sample file run:

```bash
$ kubectl apply -f test.yaml
```

> NOTE: If you are pulling from a private containers registry, replace the image name with the full URL to the docker image. E.g.
>
> - image: 'your-registry/image-name:your-version'

# Supported tags and respective `Dockerfile` links

> NOTE: Debian 9 images have been deprecated in favor of Debian 10 images. Bitnami will not longer publish new Docker images based on Debian 9.

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/).


* [`8-ol-7`, `8.4.1-ol-7-r18` (8/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-solr/blob/8.4.1-ol-7-r18/8/ol-7/Dockerfile)
* [`8-debian-10`, `8.4.1-debian-10-r11`, `8`, `8.4.1`, `latest` (8/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-solr/blob/8.4.1-debian-10-r11/8/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/solr GitHub repo](https://github.com/bitnami/bitnami-docker-solr).

# Get this image

The recommended way to get the Bitnami solr Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/solr).

```bash
$ docker pull bitnami/solr:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/solr/tags/) in the Docker Hub Registry.

```bash
$ docker pull bitnami/solr:[TAG]
```

If you wish, you can also build the image yourself.

```bash
$ docker build -t bitnami/solr:latest 'https://github.com/bitnami/bitnami-docker-solr.git#master:8/debian-10'
```

# Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. The above examples define a docker volume namely `solr_data`. The Solr application state will persist as long as this volume is not removed.

To avoid inadvertent removal of this volume you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

```bash
$ docker run -v /path/to/solr-persistence:/bitnami bitnami/solr:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-solr/blob/master/docker-compose.yml) file present in this repository:

```yaml
solr:
  ...
  volumes:
    - /path/to/solr-persistence:/bitnami
  ...
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a Solr server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

### Step 1: Create a network

```bash
$ docker network create solr-network --driver bridge
```

### Step 2: Launch the solr container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `solr-network` network.

```bash
$ docker run --name solr-node1 --network solr-network bitnami/solr:latest
```

### Step 3: Run another containers

We can launch another containers using the same flag (`--network NETWORK`) in the `docker run` command. If you also set a name to your container, you will be able to use it as hostname in your network.

## Using Docker Compose

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new bridge network named solr-network.

```yaml
version: '2'

networks:
  solr-network:
    driver: bridge

services:
  solr-node1:
    image: bitnami/solr:latest
    networks:
      - solr-network
    ports:
      - '8983:8983'
  solr-node2:
    image: bitnami/solr:latest
    networks:
      - solr-network
    ports:
      - '8984:8984'
```

Then, launch the containers using:

```bash
$ docker-compose up -d
```

# Configuration

## Environment variables

When you start the solr image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the docker run command line. The following environment values are provided to custom Solr:

- `SOLR_PORT_NUMBER`: Port used by Solr server. Default: **8983**
- `SOLR_SERVER_DIRECTORY`: Specify the Solr server directory. Default: **server**
- `SOLR_CORE`: Core name to create at first run. By default, it will not create a core. (E.g.: '**my_core**')
- `SOLR_CORE_CONF_DIR`: Configuration directory to copy when creating a new core. Default: **data_driven_schema_configs**

### Specifying Environment Variables using Docker Compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-solr/blob/master/docker-compose.yml) file present in this repository:

```yaml
solr:
  ...
  environment:
    - SOLR_CORE=my_core
  ...
```

### Specifying Environment Variables on the Docker command line

```bash
$ docker run -d -e SOLR_CORE=my_core --name solr bitnami/solr:latest
```

## Using your Apache Solr Cores configuration files

In order to load your own configuration files, you will have to make them available to the container. You can do it mounting a [volume](https://docs.docker.com/engine/tutorials/dockervolumes/) in the desired location and setting the environment variable with the customized value (as it is pointed above, the default value is **data_driven_schema_configs**).

### Using Docker Compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-solr/blob/master/docker-compose.yml) file present in this repository:

```yaml
solr:
  ...
  environment:
    - SOLR_CORE_CONF_DIR=/path/to/your/confDir
  volumes:
    - '/local/path/to/your/confDir:/container/path/to/your/confDir'
  ...
```

# Logging

The Bitnami solr Docker image sends the container logs to the `stdout`. To view the logs:

```bash
$ docker logs solr
```

or using Docker Compose:

```bash
$ docker-compose logs solr
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of solr, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
$ docker pull bitnami/solr:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/solr:latest`.

### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```bash
$ docker stop solr
```

or using Docker Compose:

```bash
$ docker-compose stop solr
```

Next, take a snapshot of the persistent volume `/path/to/solr-persistence` using:

```bash
$ rsync -a /path/to/solr-persistence /path/to/solr-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

You can use this snapshot to restore the database state should the upgrade fail.

### Step 3: Remove the currently running container

```bash
$ docker rm -v solr
```

or using Docker Compose:

```bash
$ docker-compose rm -v solr
```

### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if necessary.

```bash
$ docker run --name solr bitnami/solr:latest
```

or using Docker Compose:

```bash
$ docker-compose up solr
```
# Notable Changes

## 7.4.0-r23

- The Solr container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the Solr daemon was started as the `solr` user. From now on, both the container and the Solr daemon run as user `1001`. As a consequence, the data directory must be writable by that user. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-solr/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-solr/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-solr/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License
Copyright 2016-2020 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
