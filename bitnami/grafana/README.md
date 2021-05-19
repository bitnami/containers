# What is Grafana?

Grafana is an open source, feature rich metrics dashboard and graph editor for Graphite, Elasticsearch, OpenTSDB, Prometheus and InfluxDB.

[https://grafana.com](https://grafana.com)

## TL;DR

```console
$ docker run --name grafana bitnami/grafana:latest
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.

> This [CVE scan report](https://quay.io/repository/bitnami/grafana?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

## How to deploy Grafana in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Grafana Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/grafana).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`7`, `7-debian-10`, `7.5.7`, `7.5.7-debian-10-r0`, `latest` (7/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-grafana/blob/7.5.7-debian-10-r0/7/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/grafana GitHub repo](https://github.com/bitnami/bitnami-docker-grafana).

## Get this image

The recommended way to get the Bitnami Grafana Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/grafana).

```console
$ docker pull bitnami/grafana:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/grafana/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/grafana:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/grafana:latest 'https://github.com/bitnami/bitnami-docker-grafana.git#master:7/debian-10'
```

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

#### Step 1: Create a network

```console
$ docker network create grafana-network --driver bridge
```

#### Step 2: Launch the grafana container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `grafana-network` network.

```console
$ docker run --name grafana-node1 --network grafana-network bitnami/grafana:latest
```

#### Step 3: Run another containers

We can launch another containers using the same flag (`--network NETWORK`) in the `docker run` command. If you also set a name to your container, you will be able to use it as hostname in your network.

## Configuration

### Dev config

Update the `grafana.ini` configuration file in the `/opt/bitnami/grafana/conf` directory to override default configuration options. You only need to add the options you want to override. Config files are applied in the order of:

```
grafana.ini
default.ini
```

To enable development mode, edit the `grafana.ini` file and set `app_mode = development`.

### Production config

Override the `/opt/bitnami/grafana/conf/grafana.ini` file mounting a volume.

```console
$ docker run --name grafana-node -v /path/to/grafana.ini:/opt/bitnami/grafana/conf/grafana.ini bitnami/grafana:latest
```

After that, your configuration will be taken into account in the server's behaviour.

You can also do this by changing the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-grafana/blob/master/docker-compose.yml) file present in this repository:

```yaml
grafana:
  ...
  volumes:
    - /path/to/grafana.ini:/opt/bitnami/grafana/conf/grafana.ini
  ...
```

### Install plugins at initialization

When you start the Grafana image, you can specify a comma, semi-colon or space separated list of plugins to install by setting the env. variable `GF_INSTALL_PLUGINS`. The entries in `GF_INSTALL_PLUGINS` have three different formats:

 * `plugin_id`: This will download the latest plugin version with name `plugin_id` from [the official Grafana plugins page](https://grafana.com/grafana/plugins).
 * `plugin_id:plugin_version`: This will download the plugin with name `plugin_id` and version `plugin_version` from [the official Grafana plugins page](https://grafana.com/grafana/plugins).
 * `plugin_id=url`: This will download the plugin with name `plugin_id` using the zip file specified in `url`. In case you want to skip TLS verification, set the variable `GF_INSTALL_PLUGINS_SKIP_TLS` to `yes`.

For Docker Compose, add the variable name and value under the application section:

```yaml
grafana:
  ...
  environment:
    - GF_INSTALL_PLUGINS=grafana-clock-panel:1.1.0,grafana-kubernetes-app,worldpring=https://github.com/raintank/worldping-app/releases/download/v1.2.6/worldping-app-release-1.2.6.zip
  ...
```

For manual execution add a `-e` option with each variable and value:

```console
$ docker run -d --name grafana -p 3000:3000 \
    -e GF_INSTALL_PLUGINS="grafana-clock-panel:1.1.0,grafana-kubernetes-app,worldpring=https://github.com/raintank/worldping-app/releases/download/v1.2.6/worldping-app-release-1.2.6.zip" \
    bitnami/grafana:latest
```

### Grafana Image Renderer plugin

You can install the [Grafana Image Renderer plugin](https://github.com/grafana/grafana-image-renderer) to handle rendering panels and dashboards as PNG images. To install the plugin, follow the instructions described in the [previous section](#install-plugins-at-initialization).

As an alternative to install this plugin, you can use the [Grafana Image Renderer container](https://github.com/bitnami/bitnami-docker-grafana-image-renderer) to set another Docker container for rendering and using remote rendering. We highly recommend to use this option. In the Docker Compose below you can see an example to use this container:

```yaml
version: '2'

services:
  grafana:
    image: bitnami/grafana:6
    ports:
      - '3000:3000'
    environment:
      GF_SECURITY_ADMIN_PASSWORD: "bitnami"
      GF_RENDERING_SERVER_URL: "http://grafana-image-renderer:8080/render"
      GF_RENDERING_CALLBACK_URL: "http://grafana:3000/"
  grafana-image-renderer:
    image: bitnami/grafana-image-renderer:1
    ports:
      - '8080:8080'
    environment:
      HTTP_HOST: "0.0.0.0"
      HTTP_PORT: "8080"
      ENABLE_METRICS: 'true'
```

## Logging

The Bitnami Grafana Docker image sends the container logs to the `stdout`. To view the logs:

```console
$ docker logs grafana
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of grafana, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
$ docker pull bitnami/grafana:latest
```

#### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
$ docker stop grafana
```

Next, take a snapshot of the persistent volume `/path/to/grafana-persistence` using:

```console
$ rsync -a /path/to/grafana-persistence /path/to/grafana-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

You can use this snapshot to restore the database state should the upgrade fail.

#### Step 3: Remove the currently running container

```console
$ docker rm -v grafana
```

#### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if necessary.

```console
$ docker run --name grafana bitnami/grafana:latest
```

## Notable Changes

### 6.7.3-debian-10-r28

- The `GF_INSTALL_PLUGINS` environment variable is not set by default anymore. This means it doesn't try to install the [`grafana-image-renderer` plugin](https://github.com/grafana/grafana-image-renderer) anymore unless you specify it. As an alternative to install this plugin, you can use the [Grafana Image Renderer container](https://github.com/bitnami/bitnami-docker-grafana-image-renderer).

### 6.7.2-debian-10-r18

- Grafana doesn't ship the [`grafana-image-renderer` plugin](https://github.com/grafana/grafana-image-renderer/) by default anymore since it's not compatible with K8s distros with IPv6 disable. Instead, the `GF_INSTALL_PLUGINS` environment variable is set by default including this plugin so it's installed during the container's initialization, users can easily avoid it by overwriting the environment variable.

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-grafana/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-grafana/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-grafana/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

## License

Copyright (c) 2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
