# What is Tensorflow Serving?

> TensorFlow Serving is a flexible, high-performance serving system for machine learning models, designed for production environments. TensorFlow Serving makes it easy to deploy new algorithms and experiments, while keeping the same server architecture and APIs. TensorFlow Serving provides out-of-the-box integration with TensorFlow models, but can be easily extended to serve other types of models and data.

> With the Bitnami Docker TensorFlow Serving image it is easy to server models like ResNet or MNIST. For a functional example you can check the [TensorFlow ResNet repository.](https://github.com/bitnami/bitnami-docker-tensorflow-resnet)

[tensorflow.github.io/serving/](https://tensorflow.github.io/serving/)

> NOTE: This image needs access to trained data to actually works. Please check [bitnami-docker-tensorflow-resnet](https://github.com/bitnami/bitnami-docker-tensorflow-resnet) repository or follow the steps provided [here](#using-the-command-line)

# TL;DR

```console
$ docker run --name tensorflow-serving bitnami/tensorflow-serving:latest
```

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-tensorflow-serving/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

You can find the available configuration options in the [Environment Variables](#environment-variables) section.

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.

> This [CVE scan report](https://quay.io/repository/bitnami/tensorflow-serving?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`2`, `2-debian-10`, `2.4.1`, `2.4.1-debian-10-r104`, `latest` (2/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-tensorflow-serving/blob/2.4.1-debian-10-r104/2/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/tensorflow-serving GitHub repo](https://github.com/bitnami/bitnami-docker-tensorflow-serving).

# Get this image

The recommended way to get the Bitnami TensorFlow Serving Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/tensorflow-serving).

```console
$ docker pull bitnami/tensorflow-serving:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/tensorflow-serving/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/tensorflow-serving:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/tensorflow-serving:latest 'https://github.com/bitnami/bitnami-docker-tensorflow-serving.git#master:2/debian-10'
```

# Persisting your configuration

If you remove the container all your data and configurations will be lost, and the next time you run the image the data and configurations will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path for the TensorFlow Serving data and configurations. If the mounted directory is empty, it will be initialized on the first run.

```console
$ docker run -v /path/to/tensorflow-serving-persistence:/bitnami bitnami/tensorflow-serving:latest
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-tensorflow-serving/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  tensorflow-serving:
  ...
    volumes:
      - /path/to/tensorflow-serving-persistence:/bitnami
  ...
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a TensorFlow Serving server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

In this example, we will create a TensorFlow ResNet client instance that will connect to the server instance that is running on the same docker network as the client. The ResNet client will export an already trained data so the server can read it and you will be able to query the server with an image to get it categorized.

### Step 1: Download the ResNet trained data

```console
$ mkdir /tmp/model-data
$ curl -o '/tmp/model-data/resnet_v2_fp32_savedmodel_NHWC_jpg.tar.gz' 'http://download.tensorflow.org/models/official/20181001_resnet/savedmodels/resnet_v2_fp32_savedmodel_NHWC_jpg.tar.gz'
$ cd /tmp/model-data
$ tar xzf resnet_v2_fp32_savedmodel_NHWC_jpg.tar.gz --strip-components=2
```

### Step 2: Create a network

```console
$ docker network create app-tier --driver bridge
```

### Step 3: Launch the TensorFlow Serving server instance

Use the `--network app-tier` argument to the `docker run` command to attach the TensorFlow Serving container to the `app-tier` network.

```console
$ docker run -d --name tensorflow-serving \
    --volume /tmp/model-data:/bitnami/model-data \
    --network app-tier \
    bitnami/tensorflow-serving:latest
```

### Step 4: Export the data model

Run the `tensorflow-resnet` container in background mode to export the data model that you have already downloaded.

```console
$ docker run -d --name tensorflow-resnet \
    --volume /tmp/model-data:/bitnami/model-data \
    --network app-tier \
    bitnami/tensorflow-resnet:latest
```

Monitor the logs of tensorflow-serving until it shows the message `Successfully loaded servable version`. That will mean it is serving the model:

```console
$ docker logs tensorflow-serving -f
```

### Step 5: Launch your TensorFlow ResNet client instance

Finally we create a new container instance to launch the TensorFlow Serving client and connect to the server created in the previous step:

```console
$ docker run -it --rm \
    --volume /tmp/model-data:/bitnami/model-data \
    --network app-tier \
    bitnami/tensorflow-resnet:latest resnet_client_cc --server_port=tensorflow-serving:8500 --image_file=path/to/image.jpg
```

## Using Docker Compose

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `app-tier`. In this example we assume that you want to connect to the TensorFlow Serving server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge

services:
  tensorflow-serving:
    image: 'bitnami/tensorflow-serving:latest'
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
> 2. In your application container, use the hostname `tensorflow-serving` to connect to the TensorFlow Serving server

Launch the containers using:

```console
$ docker-compose up -d
```

# Configuration

## Environment variables

Tensorflow Serving can be customized by specifying environment variables on the first run. The following environment values are provided to custom Tensorflow:

- `TENSORFLOW_SERVING_PORT_NUMBER`: TensorFlow Serving Port. Default: **8500**
- `TENSORFLOW_SERVING_REST_API_PORT_NUMBER`: TensorFlow Serving Rest API Port. Default: **8501**
- `TENSORFLOW_SERVING_MODEL_NAME`: TensorFlow Model to serve. Default: **resnet**
- `TENSORFLOW_SERVING_ENABLE_MONITORING`: Expose Prometheus metrics. Default: **no**
- `TENSORFLOW_SERVING_MONITORING_PATH`: The API path where the metrics can be scraped. Default: **/monitoring/prometheus/metrics**

## Configuration file

The image looks for configurations in `/bitnami/tensorflow-serving/conf/`. As mentioned in [Persisting your configuation](#persisting-your-configuation) you can mount a volume at `/bitnami` and copy/edit the configurations in the `/path/to/tensorflow-serving-persistence/tensorflow-serving/conf/`. The default configurations will be populated to the `conf/` directory if it's empty.

### Step 1: Run the TensorFlow Serving image

Run the TensorFlow Serving image, mounting a directory from your host.

```console
$ docker run --name tensorflow-serving -v /path/to/tensorflow-serving-persistence:/bitnami bitnami/tensorflow-serving:latest
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-tensorflow-serving/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  tensorflow-serving:
  ...
    volumes:
      - /path/to/tensorflow-serving-persistence:/bitnami
  ...
```

### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```console
$ vi /path/to/tensorflow-serving-persistence/conf/tensorflow-serving.conf
```

### Step 3: Restart TensorFlow Serving

After changing the configuration, restart your TensorFlow Serving container for changes to take effect.

```console
$ docker restart tensorflow-serving
```

or using Docker Compose:

```console
$ docker-compose restart tensorflow-serving
```

# Logging

The Bitnami TensorFlow Serving Docker image sends the container logs to the `stdout`. To view the logs:

```console
$ docker logs tensorflow-serving
```

or using Docker Compose:

```console
$ docker-compose logs tensorflow-serving
```

The logs are also stored inside the container in the /opt/bitnami/tensorflow-serving/logs/tensorflow-serving.log file.

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of TensorFlow Serving, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```console
$ docker pull bitnami/tensorflow-serving:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/tensorflow-serving:latest`.

### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
$ docker stop tensorflow-serving
```

or using Docker Compose:

```console
$ docker-compose stop tensorflow-serving
```

Next, take a snapshot of the persistent volume `/path/to/tensorflow-serving-persistence` using:

```console
$ rsync -a /path/to/tensorflow-serving-persistence /path/to/tensorflow-serving-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

You can use this snapshot to restore the database state should the upgrade fail.

### Step 3: Remove the currently running container

```console
$ docker rm -v tensorflow-serving
```

or using Docker Compose:

```console
$ docker-compose rm -v tensorflow-serving
```

### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if necessary.

```console
$ docker run --name tensorflow-serving bitnami/tensorflow-serving:latest
```

or using Docker Compose:

```console
$ docker-compose start tensorflow-serving
```

# Notable Changes

## 1.12.0-r34

- The TensorFlow Serving container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the TensorFlow Serving daemon was started as the `tensorflow` user. From now on, both the container and the TensorFlow Serving daemon run as user `1001`. As a consequence, the data directory must be writable by that user. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

## 1.8.0-r12, 1.8.0-debian-9-r1, 1.8.0-ol-7-r11

- The default serving port has changed from 9000 to 8500.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-tensorflow-serving/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-tensorflow-serving/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-tensorflow-serving/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright 2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
