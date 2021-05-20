
# What is TensorFlow ResNet?

> The TensorFlow ResNet docker image allows querying a TensorFlow server serving the ResNet model. For example, it is very easy to start using the already trained data from the ImageNet image database. For more information check [this link](https://github.com/tensorflow/models/tree/master/official/resnet).

# TL;DR

Before running the docker image you first need to download the ResNet model training checkpoint so it will be available for the TensorFlow Serving server.

```console
$ mkdir /tmp/model-data
$ cd /tmp/model-data
$ wget 'http://download.tensorflow.org/models/official/20181001_resnet/savedmodels/resnet_v2_fp32_savedmodel_NHWC_jpg.tar.gz'
$ tar xzf resnet_v2_fp32_savedmodel_NHWC_jpg.tar.gz --strip-components=2
```

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-tensorflow-resnet/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/tensorflow-resnet?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`2`, `2-debian-10`, `2.4.1`, `2.4.1-debian-10-r102`, `latest` (2/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-tensorflow-resnet/blob/2.4.1-debian-10-r102/2/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/tensorflow-resnet GitHub repo](https://github.com/bitnami/bitnami-docker-tensorflow-resnet).

# Prerequisites

To run this application you need Docker Engine 1.10.0. Docker Compose is recommended with a version 1.6.0 or later.

# How to use this image

## Run TensorFlow ResNet client with TensorFlow Serving

Running TensorFlow ResNet client with the TensorFlow Serving server is the recommended way. You can either use docker-compose or run the containers manually.

### Run the application using Docker Compose

The main folder of this repository contains a functional [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-tensorflow-resnet/blob/master/docker-compose.yml) file. Run the application using it as shown below:

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-tensorflow-resnet/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

### Run the application manually

If you want to run the application manually instead of using docker-compose, these are the basic steps you need to run:

1. Create a new network for the application and the database:

  ```console
  $ docker network create tensorflow-tier
  ```

2. Start a Tensorflow Serving server in the network generated:

  ```console
  $ docker run -d -v /tmp/model-data:/bitnami/model-data -e TENSORFLOW_SERVING_MODEL_NAME=resnet -p 8500:8500 -p 8501:8501 --name tensorflow-serving --net tensorflow-tier bitnami/tensorflow-serving:latest
  ```

  *Note:* You need to give the container a name in order to TensorFlow ResNet client to resolve the host

3. Run the TensorFlow ResNet client container:

  ```console
  $ docker run -d -v /tmp/model-data:/bitnami/model-data --name tensorflow-resnet --net tensorflow-tier bitnami/tensorflow-resnet:latest
  ```

# Upgrade this application

Bitnami provides up-to-date versions of Tensorflow-Serving and TensorFlow ResNet client, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the TensorFlow ResNet client container. For the Tensorflow-Serving upgrade see https://github.com/bitnami/bitnami-docker-tensorflow-serving/blob/master/README.md#upgrade-this-image

1. Get the updated images:

  ```console
  $ docker pull bitnami/tensorflow-resnet:latest
  ```

2. Stop your container

 * For docker-compose: `$ docker-compose stop tensorflow-resnet`
 * For manual execution: `$ docker stop tensorflow-resnet`

3. Take a snapshot of the application state

```console
$ rsync -a tensorflow-resnet-persistence tensorflow-resnet-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

Additionally, [snapshot the TensorFlow Serving data](https://github.com/bitnami/bitnami-docker-mariadb#step-2-stop-and-backup-the-currently-running-container)

You can use these snapshots to restore the application state should the upgrade fail.

4. Remove the currently running container

 * For docker-compose: `$ docker-compose rm tensorflow-resnet`
 * For manual execution: `$ docker rm tensorflow-resnet`

5. Run the new image

 * For docker-compose: `$ docker-compose up tensorflow-resnet`
 * For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name tensorflow-resnet bitnami/tensorflow-resnet:latest`

# Configuration

## Predict an image

Once you have deployed both the TensorFlow Serving and TensorFlow ResNet containers you can use the `resnet_client_cc` utility to predict images. To do that follow the next steps:

1. Exec into the TensorFlow ResNet container.
2. Download an image:

```console
curl -L --output cat.jpeg https://tensorflow.org/images/blogs/serving/cat.jpg
```

3. Send the image to the TensorFlow Serving server.

```console
resnet_client_cc --server_port=tensorflow-serving:8500 --image_file=./cat.jpg
```

4. The model says the image belongs to the category 286. You can check the [imagenet classes index](https://s3.amazonaws.com/deep-learning-models/image-models/imagenet_class_index.json) to see how the category 286 correspond to a cougar.

```console
calling predict using file: cat.jpg  ...
call predict ok
outputs size is 2
the result tensor[0] is:
[2.41628254e-06 1.90121955e-06 2.72477027e-05 4.4263885e-07 8.98362089e-07 6.84422412e-06 1.66555201e-05 3.4298439e-06 5.25692e-06 2.66782135e-05...]...
the result tensor[1] is:
286
Done.
```

## Environment variables

Tensorflow Resnet can be customized by specifying environment variables on the first run. The following environment values are provided to custom Tensorflow:

- `TF_RESNET_SERVING_PORT_NUMBER`: TensorFlow Serving Port. Default: **8500**
- `TF_RESNET_SERVING_HOST`: TensorFlow Serving server name. Default: **tensorflow-serving**

# Notable Changes

## 2.4.1-debian-10-r87

- The container initialization logic is now using bash.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-tensorflow-resnet/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-tensorflow-resnet/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-tensorflow-resnet/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`$ docker version`)
- Output of `$ docker info`
- Version of this container (`$ echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright (c) 2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
