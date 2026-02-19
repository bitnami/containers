# Bitnami Secure Image for TensorFlow ResNet

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

## Why use Bitnami Secure Images?

Those are hardened, minimal CVE images built and maintained by Bitnami. Bitnami Secure Images are based on the cloud-optimized, security-hardened enterprise [OS Photon Linux](https://vmware.github.io/photon/). Why choose BSI images?

- Hardened secure images of popular open source software with Near-Zero Vulnerabilities
- Vulnerability Triage & Prioritization with VEX Statements, KEV and EPSS Scores
- Compliance focus with FIPS, STIG, and air-gap options, including secure bill of materials (SBOM)
- Software supply chain provenance attestation through in-toto
- First class support for the internet’s favorite Helm charts

Each image comes with valuable security metadata. You can view the metadata in [our public catalog here](https://app-catalog.vmware.com/bitnami/apps). Note: Some data is only available with [commercial subscriptions to BSI](https://bitnami.com/).

![Alt text](https://github.com/bitnami/containers/blob/main/BSI%20UI%201.png?raw=true "Application details")
![Alt text](https://github.com/bitnami/containers/blob/main/BSI%20UI%202.png?raw=true "Packaging report")

If you are looking for our previous generation of images based on Debian Linux, please see the [Bitnami Legacy registry](https://hub.docker.com/u/bitnamilegacy).

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

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

    - `$ docker stop tensorflow-resnet`

3. Take a snapshot of the application state

    ```console
    rsync -a tensorflow-resnet-persistence tensorflow-resnet-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
    ```

Additionally, [snapshot the TensorFlow Serving data](https://github.com/bitnami/containers/blob/main/bitnami/mariadb#step-2-stop-and-backup-the-currently-running-container)

You can use these snapshots to restore the application state should the upgrade fail.

1. Remove the currently running container

    - `$ docker rm tensorflow-resnet`

2. Run the new image

    - Mount the directories if needed: `docker run --name tensorflow-resnet bitnami/tensorflow-resnet:latest`

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

### FIPS configuration in Bitnami Secure Images

The Bitnami TensorFlow ResNet Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Notable Changes

### Starting January 16, 2024

- The `docker-compose.yaml` file has been removed, as it was solely intended for internal testing purposes.

### 2.4.1-debian-10-r87

- The container initialization logic is now using bash.

## License

Copyright &copy; 2026 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
