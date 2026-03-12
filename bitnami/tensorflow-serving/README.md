# Bitnami Secure Image for TensorFlow Serving

> TensorFlow Serving is an open source high-performance system for serving machine learning models. It allows programmers to easily deploy algorithms and experiments without changing the architecture.

[Overview of TensorFlow Serving](https://github.com/tensorflow/serving)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name tensorflow-serving bitnami/tensorflow-serving:latest
```

You can find the available configuration options in the [Environment Variables](#environment-variables) section.

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

## Get this image

The recommended way to get the Bitnami TensorFlow Serving Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/tensorflow-serving).

```console
docker pull bitnami/tensorflow-serving:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/tensorflow-serving/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/tensorflow-serving:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/tensorflow-resnet).

## Persisting your configuration

If you remove the container all your data and configurations will be lost, and the next time you run the image the data and configurations will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path for the TensorFlow Serving data and configurations. If the mounted directory is empty, it will be initialized on the first run.

> **NOTE** As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a TensorFlow Serving server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Configuration

The following section describes the supported environment variables

### Environment variables

Tensorflow Serving can be customized by specifying environment variables on the first run. The following environment values are provided to custom Tensorflow:

#### Customizable environment variables

| Name                                      | Description                  | Default Value                    |
|-------------------------------------------|------------------------------|----------------------------------|
| `TENSORFLOW_SERVING_ENABLE_MONITORING`    | Enable tensorflow monitoring | `no`                             |
| `TENSORFLOW_SERVING_MODEL_NAME`           | Tensorflow model name        | `resnet`                         |
| `TENSORFLOW_SERVING_MONITORING_PATH`      | Tensorflow monitoring path   | `/monitoring/prometheus/metrics` |
| `TENSORFLOW_SERVING_PORT_NUMBER`          | Tensorflow port number       | `8500`                           |
| `TENSORFLOW_SERVING_REST_API_PORT_NUMBER` | Tensorflow API port number   | `8501`                           |

#### Read-only environment variables

| Name                                      | Description                                   | Value                                                    |
|-------------------------------------------|-----------------------------------------------|----------------------------------------------------------|
| `BITNAMI_VOLUME_DIR`                      | Directory where to mount volumes.             | `/bitnami`                                               |
| `TENSORFLOW_SERVING_BASE_DIR`             | Tensorflow installation directory.            | `${BITNAMI_ROOT_DIR}/tensorflow-serving`                 |
| `TENSORFLOW_SERVING_BIN_DIR`              | Tensorflow directory for binary executables.  | `${TENSORFLOW_SERVING_BASE_DIR}/bin`                     |
| `TENSORFLOW_SERVING_TMP_DIR`              | Tensorflow directory for temp files.          | `${TENSORFLOW_SERVING_BASE_DIR}/tmp`                     |
| `TENSORFLOW_SERVING_PID_FILE`             | Tensorflow PID file.                          | `${TENSORFLOW_SERVING_TMP_DIR}/tensorflow-serving.pid`   |
| `TENSORFLOW_SERVING_CONF_DIR`             | Tensorflow directory for configuration files. | `${TENSORFLOW_SERVING_BASE_DIR}/conf`                    |
| `TENSORFLOW_SERVING_CONF_FILE`            | Tensorflow configuration file.                | `${TENSORFLOW_SERVING_CONF_DIR}/tensorflow-serving.conf` |
| `TENSORFLOW_SERVING_MONITORING_CONF_FILE` | Tensorflow directory for configuration files. | `${TENSORFLOW_SERVING_CONF_DIR}/monitoring.conf`         |
| `TENSORFLOW_SERVING_LOGS_DIR`             | Tensorflow directory for logs files.          | `${TENSORFLOW_SERVING_BASE_DIR}/logs`                    |
| `TENSORFLOW_SERVING_LOGS_FILE`            | Tensorflow logs files.                        | `${TENSORFLOW_SERVING_LOGS_DIR}/tensorflow-serving.log`  |
| `TENSORFLOW_SERVING_VOLUME_DIR`           | Tensorflow persistence directory.             | `${BITNAMI_VOLUME_DIR}/tensorflow-serving`               |
| `TENSORFLOW_SERVING_MODEL_DATA`           | Tensorflow data to persist.                   | `${BITNAMI_VOLUME_DIR}/model-data`                       |
| `TENSORFLOW_SERVING_DAEMON_USER`          | Tensorflow system user                        | `tensorflow`                                             |
| `TENSORFLOW_SERVING_DAEMON_GROUP`         | Tensorflow system group                       | `tensorflow`                                             |

### Configuration file

The image looks for configurations in `/bitnami/tensorflow-serving/conf/`. As mentioned in [Persisting your configuation](#persisting-your-configuration) you can mount a volume at `/bitnami` and copy/edit the configurations in the `/path/to/tensorflow-serving-persistence/tensorflow-serving/conf/`. The default configuration will be populated to the `conf/` directory if it's empty.

### FIPS configuration in Bitnami Secure Images

The Bitnami TensorFlow Serving Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Logging

The Bitnami TensorFlow Serving Docker image sends the container logs to the `stdout`. To view the logs:

```console
docker logs tensorflow-serving
```

or using Docker Compose:

```console
docker-compose logs tensorflow-serving
```

The logs are also stored inside the container in the /opt/bitnami/tensorflow-serving/logs/tensorflow-serving.log file.

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Notable Changes

### 2.5.1-debian-10-r12

- The size of the container image has been decreased.
- The configuration logic is now based on Bash scripts in the rootfs/ folder.

### 1.12.0-r34

- The TensorFlow Serving container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the TensorFlow Serving daemon was started as the `tensorflow` user. From now on, both the container and the TensorFlow Serving daemon run as user `1001`. As a consequence, the data directory must be writable by that user. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

### 1.8.0-r12, 1.8.0-debian-9-r1, 1.8.0-ol-7-r11

- The default serving port has changed from 9000 to 8500.

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
