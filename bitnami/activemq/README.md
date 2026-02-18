# Bitnami Secure Image for ActiveMQ

## What is ActiveMQ?

> Apache ActiveMQ is an open source message broker written in Java together with a full Java Message Service (JMS) client.
[Overview of ActiveMQ](https://activemq.apache.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name activemq bitnami/activemq:latest
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

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

## Get this image

The recommended way to get the Bitnami ActiveMQ Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/activemq).

```console
docker pull bitnami/activemq:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/activemq/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/activemq:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Configuration

### Running commands

To run commands inside this container, you can use `docker run`, for example to execute `activemq --help` you can follow the example below:

```console
docker run --rm --name activemq bitnami/activemq:latest -- --help
```

Check the [official ActiveMQ documentation](https://activemq.apache.org/ for more information.

### Environment variables

#### Customizable environment variables

| Name                             | Description                                                                                   | Default Value                 |
|----------------------------------|-----------------------------------------------------------------------------------------------|-------------------------------|
| `ACTIVEMQ_MOUNTED_CONF_DIR`      | Directory for including custom configuration files (that override the default generated ones) | `${ACTIVEMQ_VOLUME_DIR}/conf` |
| `ACTIVEMQ_MQTT_PORT_NUMBER`      | ActiveMQ MQTT port number.                                                                    | `1883`                        |
| `ACTIVEMQ_AQMQ_PORT_NUMBER`      | ActiveMQ AQMQ port number.                                                                    | `5672`                        |
| `ACTIVEMQ_HTTP_PORT_NUMBER`      | ActiveMQ HTTP port number.                                                                    | `8161`                        |
| `ACTIVEMQ_STOMP_PORT_NUMBER`     | ActiveMQ STOMP port number.                                                                   | `61613`                       |
| `ACTIVEMQ_WEBSOCKET_PORT_NUMBER` | ActiveMQ WebSocket port number.                                                               | `61614`                       |
| `ACTIVEMQ_OPENWIRE_PORT_NUMBER`  | ActiveMQ OpenWire port number.                                                                | `61616`                       |
| `ACTIVEMQ_USERNAME`              | ActiveMQ username.                                                                            | `admin`                       |
| `ACTIVEMQ_PASSWORD`              | ActiveMQ password.                                                                            | `password`                    |
| `ACTIVEMQ_SECRET`                | ActiveMQ secret for encryption.                                                               | `bitnami`                     |

#### Read-only environment variables

| Name                        | Description                                          | Value                               |
|-----------------------------|------------------------------------------------------|-------------------------------------|
| `ACTIVEMQ_BASE_DIR`         | ActiveMQ installation directory.                     | `${BITNAMI_ROOT_DIR}/activemq`      |
| `ACTIVEMQ_BIN_DIR`          | ActiveMQ directory for binary files.                 | `${ACTIVEMQ_BASE_DIR}/bin`          |
| `ACTIVEMQ_VOLUME_DIR`       | Persistence base directory.                          | `${BITNAMI_VOLUME_DIR}/activemq`    |
| `ACTIVEMQ_DATA_DIR`         | ActiveMQ configuration directory.                    | `${ACTIVEMQ_VOLUME_DIR}/data`       |
| `ACTIVEMQ_CONF_DIR`         | ActiveMQ configuration directory.                    | `${ACTIVEMQ_BASE_DIR}/conf`         |
| `ACTIVEMQ_DEFAULT_CONF_DIR` | ActiveMQ default configuration directory.            | `${ACTIVEMQ_BASE_DIR}/conf.default` |
| `ACTIVEMQ_LOGS_DIR`         | Directory where ActiveMQ logs are stored.            | `${ACTIVEMQ_BASE_DIR}/logs`         |
| `ACTIVEMQ_TMP_DIR`          | Directory where ActiveMQ temporary files are stored. | `${ACTIVEMQ_BASE_DIR}/tmp`          |
| `ACTIVEMQ_CONF_FILE`        | ActiveMQ configuration file.                         | `${ACTIVEMQ_CONF_DIR}/activemq.xml` |
| `ACTIVEMQ_LOG_FILE`         | Path to the log file for ActiveMQ.                   | `${ACTIVEMQ_LOGS_DIR}/activemq.log` |
| `ACTIVEMQ_PID_FILE`         | Path to the PID file for ActiveMQ.                   | `${ACTIVEMQ_TMP_DIR}/activemq.pid`  |
| `ACTIVEMQ_HOME`             | ActiveMQ home directory.                             | `$ACTIVEMQ_BASE_DIR`                |
| `ACTIVEMQ_DAEMON_USER`      | ActiveMQ system user.                                | `activemq`                          |
| `ACTIVEMQ_DAEMON_GROUP`     | ActiveMQ system group.                               | `activemq`                          |
| `JAVA_HOME`                 | Java installation folder.                            | `${BITNAMI_ROOT_DIR}/java`          |
| `ACTIVEMQ_PIDFILE`          | ActiveMQ output destination                          | `${ACTIVEMQ_PID_FILE}`              |
| `ACTIVEMQ_OUT`              | ActiveMQ output destination                          | `${ACTIVEMQ_LOG_FILE}`              |

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