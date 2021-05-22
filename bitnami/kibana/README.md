
# What is Kibana?

> Kibana is an open source, browser based analytics and search dashboard for Elasticsearch. Kibana is a snap to setup and start using. Kibana strives to be easy to get started with, while also being flexible and powerful, just like Elasticsearch

[elastic.co/products/kibana](https://www.elastic.co/products/kibana)

# TL;DR

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-kibana/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/kibana?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`7`, `7-debian-10`, `7.12.1`, `7.12.1-debian-10-r21`, `latest` (7/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-kibana/blob/7.12.1-debian-10-r21/7/debian-10/Dockerfile)
* [`7.10.2`, `7.10.2-debian-10`, `7.10.2-debian-10-r104` (7.10.2/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-kibana/blob/7.10.2-debian-10-r104/7.10.2/debian-10/Dockerfile)
* [`6`, `6-debian-10`, `6.8.15`, `6.8.15-debian-10-r53` (6/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-kibana/blob/6.8.15-debian-10-r53/6/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/kibana GitHub repo](https://github.com/bitnami/bitnami-docker-kibana).

# Get this image

The recommended way to get the Bitnami Kibana Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/kibana).

```console
$ docker pull bitnami/kibana:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/kibana/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/kibana:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/kibana:latest 'https://github.com/bitnami/bitnami-docker-kibana.git#master:7/debian-10'
```

# How to use this image

## Run the application using Docker Compose

The main folder of this repository contains a functional [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-kibana/blob/master/docker-compose.yml) file. Run the application using it as shown below:

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-kibana/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

## Run the application manually

If you want to run the application manually instead of using docker-compose, these are the basic steps you need to run:

1. Create a new network for the application and the database:

  ```console
  $ docker network create kibana_network
  ```

2. Run the Elasticsearch container:

  ```console
  $ docker run -d -p 9200:9200 --name elasticsearch --net=kibana_network bitnami/elasticsearch
  ```

3. Run the Kibana container:

  ```console
  $ docker run -d -p 5601:5601 --name kibana --net=kibana_network \
    -e KIBANA_ELASTICSEARCH_URL=elasticsearch \
    bitnami/kibana
  ```

Then you can access your application at http://your-ip:5601/

# Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the application will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. Additionally you should mount a volume for [persistence of the Elasticsearch data](https://github.com/bitnami/bitnami-docker-elasticsearch#persisting-your-application).

The above examples define docker volumes namely `elasticsearch_data` and `kibana_data`. The Kibana application state will persist as long as these volumes are not removed.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

```console
$ docker run -v /path/to/kibana-persistence:/bitnami/kibana bitnami/kibana:latest
```

or modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-kibana/blob/master/docker-compose.yml) file present in this repository:

```yaml
kibana:
  ...
  volumes:
    - /path/to/kibana-persistence:/bitnami/kibana
  ...
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a Kibana server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

### Step 1: Create a network

```console
$ docker network create app-tier --driver bridge
```

### Step 2: Launch the Kibana server instance

Use the `--network app-tier` argument to the `docker run` command to attach the Kibana container to the `app-tier` network.

```console
$ docker run -d --name kibana-server \
    --network app-tier \
    bitnami/kibana:latest
```

### Step 3: Launch your application container

```console
$ docker run -d --name myapp \
    --network app-tier \
    YOUR_APPLICATION_IMAGE
```

> **IMPORTANT**:
>
> 1. Please update the **YOUR_APPLICATION_IMAGE_** placeholder in the above snippet with your application image
> 2. In your application container, use the hostname `kibana-server` to connect to the Kibana server

## Using Docker Compose

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `app-tier`. In this example we assume that you want to connect to the Kibana server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge

services:
  kibana:
    image: 'bitnami/kibana:latest'
    networks:
      - app-tier
  myapp:
    image: 'YOUR_APPLICATION_IMAGE'
    networks:
      - app-tier
```

> **IMPORTANT**:
>
> 1. Please update the **YOUR_APPLICATION_IMAGE_** placeholder in the above snippet with your application image
> 2. In your application container, use the hostname `kibana` to connect to the Kibana server

Launch the containers using:

```console
$ docker-compose up -d
```

# Configuration

## Environment variables

When you start the kibana image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. The following environment values are provided to custom Kibana:

- `KIBANA_ELASTICSEARCH_URL`: Elasticsearch URL. Provide Client node url in the case of a cluster. Default: **elasticsearch**
- `KIBANA_ELASTICSEARCH_PORT_NUMBER`: Elasticsearch port. Default: **9200**
- `KIBANA_HOST`: Kibana host. Default: **0.0.0.0**
- `KIBANA_PORT_NUMBER`: Kibana port. Default: **5601**
- `KIBANA_WAIT_READY_MAX_RETRIES`: Max retries to wait for Kibana to be ready. Default: **30**
- `KIBANA_INITSCRIPTS_START_SERVER`: Whether to start the Kibana server before executing the init scripts. Default: **yes**
- `KIBANA_FORCE_INITSCRIPTS`: Whether to force the execution of the init scripts. Default: **no**

### Specifying Environment Variables using Docker Compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-kibana/blob/master/docker-compose.yml) file present in this repository:

```yaml
kibana:
  ...
  environment:
    - KIBANA_ELASTICSEARCH_URL=elasticsearch
  ...
```

### Specifying Environment Variables on the Docker command line

```console
$ docker run -d -e KIBANA_ELASTICSEARCH_URL=elasticsearch --name kibana bitnami/kibana:latest
```

## Initializing a new instance

When the container is executed for the first time, it will execute the files with extension `.sh`, located at `/docker-entrypoint-initdb.d`.

In order to have your custom files inside the docker image you can mount them as a volume.

## Configuration file

The image looks for configurations in `/bitnami/kibana/conf/`. As mentioned in [Persisting your application](#persisting-your-application) you can mount a volume at `/bitnami` and copy/edit the configurations in the `/path/to/kibana-persistence/kibana/conf/`. The default configurations will be populated to the `conf/` directory if it's empty.

### Step 1: Run the Kibana image

Run the Kibana image, mounting a directory from your host.

```console
$ docker run --name kibana -v /path/to/kibana-persistence:/bitnami bitnami/kibana:latest
```

or modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-kibana/blob/master/docker-compose.yml) file present in this repository:

```yaml
kibana:
  ...
  volumes:
    - /path/to/kibana-persistence:/bitnami/kibana
  ...
```

### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```console
$ vi /path/to/kibana-persistence/kibana/conf/kibana.conf
```

### Step 3: Restart Kibana

After changing the configuration, restart your Kibana container for changes to take effect.

```console
$ docker restart kibana
```

or using Docker Compose:

```console
$ docker-compose restart kibana
```

Refer to the [configuration](https://www.elastic.co/guide/en/kibana/current/settings.html) manual for the complete list of configuration options.

# Logging

The Bitnami Kibana Docker image sends the container logs to the `stdout`. To view the logs:

```console
$ docker logs kibana
```

or using Docker Compose:

```console
$ docker-compose logs kibana
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of Kibana, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```console
$ docker pull bitnami/kibana:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/kibana:latest`.

### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
$ docker stop kibana
```

or using Docker Compose:

```console
$ docker-compose stop kibana
```

Next, take a snapshot of the persistent volume `/path/to/kibana-persistence` using:

```console
$ rsync -a /path/to/kibana-persistence /path/to/kibana-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

Additionally, [snapshot the Elasticsearch data](https://github.com/bitnami/bitnami-docker-elasticsearch#step-2-stop-and-backup-the-currently-running-container)

You can use these snapshots to restore the application state should the upgrade fail.

### Step 3: Remove the currently running container

```console
$ docker rm -v kibana
```

or using Docker Compose:

```console
$ docker-compose rm -v kibana
```

### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if necessary.

```console
$ docker run --name kibana bitnami/kibana:latest
```

or using Docker Compose:

```console
$ docker-compose up kibana
```

# Notable Changes

## 6.8.15-debian-10-r12 & 7.10.2-debian-10-r62 & 7.12.0-debian-10-r0

- The size of the container image has been decreased.
- The configuration logic is now based on Bash scripts in the *rootfs/* folder.
- Kibana 7.12.0 version or later are licensed under the Elastic License that is not currently accepted as an Open Source license by the Open Source Initiative (OSI).
- Kibana 7.12.0 version or later are including x-pack plugin installed by default. Follow official documentation to use it.

## 6.5.1-r3 & 5.6.13-r20

- The Kibana container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the Kibana daemon was started as the `kibana` user. From now on, both the container and the Kibana daemon run as user `1001`. As a consequence, the data directory must be writable by that user. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

## 4.5.4-r1

- `ELASTICSEARCH_URL` parameter has been renamed to `KIBANA_ELASTICSEARCH_URL`.
- `ELASTICSEARCH_PORT` parameter has been renamed to `KIBANA_ELASTICSEARCH_PORT`.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-kibana/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-kibana/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-kibana/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright 2016-2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
