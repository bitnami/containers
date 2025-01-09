# Bitnami package for TensorFlow ResNet

## What is TensorFlow ResNet?

> TensorFlow ResNet is a client utility for use with TensorFlow Serving and ResNet models.

[Overview of TensorFlow ResNet](https://github.com/tensorflow/models)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

Before running the docker image you first need to download the ResNet model training checkpoint so it will be available for the TensorFlow Serving server.

```console
mkdir -p /tmp/model-data/1
cd /tmp/model-data
curl -o resnet_50_classification_1.tar.gz https://storage.googleapis.com/tfhub-modules/tensorflow/resnet_50/classification/1.tar.gz
tar xzf resnet_50_classification_1.tar.gz -C 1
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use TensorFlow ResNet in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Prerequisites

To run this application you need Docker Engine 1.10.0.

## How to use this image

### Run TensorFlow ResNet client with TensorFlow Serving

Running TensorFlow ResNet client with the TensorFlow Serving server is the recommended way.

#### Run the application manually

1. Create a new network for the application and the database:

    ```console
    docker network create tensorflow-tier
    ```

2. Start a Tensorflow Serving server in the network generated:

    ```console
    docker run -d -v /tmp/model-data:/bitnami/model-data -e TENSORFLOW_SERVING_MODEL_NAME=resnet -p 8500:8500 -p 8501:8501 --name tensorflow-serving --net tensorflow-tier bitnami/tensorflow-serving:latest
    ```

    *Note:* You need to give the container a name in order to TensorFlow ResNet client to resolve the host

3. Run the TensorFlow ResNet client container:

    ```console
    docker run -d -v /tmp/model-data:/bitnami/model-data --name tensorflow-resnet --net tensorflow-tier bitnami/tensorflow-resnet:latest
    ```

## Upgrade this application

Bitnami provides up-to-date versions of Tensorflow-Serving and TensorFlow ResNet client, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the TensorFlow ResNet client container. For the Tensorflow-Serving upgrade see <https://github.com/bitnami/containers/tree/main/bitnami/tensorflow-serving#user-content-upgrade-this-image>

1. Get the updated images:

    ```console
    docker pull bitnami/tensorflow-resnet:latest
    ```

2. Stop your container

    * `$ docker stop tensorflow-resnet`

3. Take a snapshot of the application state

    ```console
    rsync -a tensorflow-resnet-persistence tensorflow-resnet-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
    ```

Additionally, [snapshot the TensorFlow Serving data](https://github.com/bitnami/containers/blob/main/bitnami/mariadb#step-2-stop-and-backup-the-currently-running-container)

You can use these snapshots to restore the application state should the upgrade fail.

1. Remove the currently running container

    * `$ docker rm tensorflow-resnet`

2. Run the new image

    * Mount the directories if needed: `docker run --name tensorflow-resnet bitnami/tensorflow-resnet:latest`

## Configuration

### Predict an image

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

### Environment variables

Tensorflow Resnet can be customized by specifying environment variables on the first run. The following environment values are provided to custom Tensorflow:

#### Customizable environment variables

| Name                            | Description                    | Default Value        |
|---------------------------------|--------------------------------|----------------------|
| `TF_RESNET_SERVING_PORT_NUMBER` | Tensorflow serving port number | `8500`               |
| `TF_RESNET_SERVING_HOST`        | Tensorflow serving host name   | `tensorflow-serving` |

#### Read-only environment variables

## Notable Changes

### Starting January 16, 2024

* The `docker-compose.yaml` file has been removed, as it was solely intended for internal testing purposes.

### 2.4.1-debian-10-r87

* The container initialization logic is now using bash.

## Contributing

We'd love for you to contribute to this Docker image. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

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
