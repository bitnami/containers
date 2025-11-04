# Bitnami Secure Image for Confluent KSQL DB

## What is Confluent KSQL DB?

> ksqlDB is a database for building stream processing applications on top of Apache Kafka. It is distributed, scalable, reliable, and real-time.

[Overview of Confluent KSQL DB](https://www.confluent.io)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name ksql bitnami/ksql:latest
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

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami ksql Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/ksql).

```console
docker pull bitnami/ksql:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/ksql/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/ksql:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Environment variables

### Customizable environment variables

| Name                           | Description                                                                                   | Default Value            |
|--------------------------------|-----------------------------------------------------------------------------------------------|--------------------------|
| `KSQL_MOUNTED_CONF_DIR`        | Directory for including custom configuration files (that override the default generated ones) | `${KSQL_VOLUME_DIR}/etc` |
| `KSQL_LISTENERS`               | Comma-separated list of listeners that listen for API requests over either HTTP or HTTPS.     | `nil`                    |
| `KSQL_SSL_KEYSTORE_PASSWORD`   | Password to access the SSL keystore.                                                          | `nil`                    |
| `KSQL_SSL_TRUSTSTORE_PASSWORD` | Password to access the SSL truststore.                                                        | `nil`                    |
| `KSQL_CLIENT_AUTHENTICATION`   | Client authentication configuration. Valid options: none, requested, over required.           | `nil`                    |
| `KSQL_BOOTSTRAP_SERVERS`       | The set of Kafka brokers to bootstrap Kafka cluster information from.                         | `nil`                    |

### Read-only environment variables

| Name                             | Description                                                                               | Value                                     |
|----------------------------------|-------------------------------------------------------------------------------------------|-------------------------------------------|
| `KSQL_BASE_DIR`                  | Base path for KSQL files.                                                                 | `${BITNAMI_ROOT_DIR}/ksql`                |
| `KSQL_VOLUME_DIR`                | KSQL directory for persisted files.                                                       | `${BITNAMI_VOLUME_DIR}/ksql`              |
| `KSQL_DATA_DIR`                  | KSQL data directory.                                                                      | `${KSQL_VOLUME_DIR}/data`                 |
| `KSQL_BIN_DIR`                   | KSQL bin directory.                                                                       | `${KSQL_BASE_DIR}/bin`                    |
| `KSQL_CONF_DIR`                  | KSQL configuration directory.                                                             | `${KSQL_BASE_DIR}/etc/ksqldb`             |
| `KSQL_LOGS_DIR`                  | KSQL logs directory.                                                                      | `${KSQL_BASE_DIR}/logs`                   |
| `KSQL_CONF_FILE`                 | Main KSQL configuration file.                                                             | `${KSQL_CONF_DIR}/ksql-server.properties` |
| `KSQL_CERTS_DIR`                 | KSQL certificates directory.                                                              | `${KSQL_BASE_DIR}/certs`                  |
| `KSQL_CONNECTION_TIMEOUT`        | KSQL connection attempt timeout.                                                          | `10`                                      |
| `KSQL_DAEMON_USER`               | Users that will execute the KSQL Server process.                                          | `ksql`                                    |
| `KSQL_DAEMON_GROUP`              | Group that will execute the KSQL Server process.                                          | `ksql`                                    |
| `KSQL_DEFAULT_LISTENERS`         | Comma-separated list of listeners that listen for API requests over either HTTP or HTTPS. | `http://0.0.0.0:8088`                     |
| `KSQL_DEFAULT_BOOTSTRAP_SERVERS` | List of Kafka brokers to bootstrap Kafka cluster information from.                        | `localhost:9092`                          |

### FIPS configuration in Bitnami Secure Images

The Bitnami Confluent KSQL DB Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Notable Changes

### Starting January 16, 2024

- The `docker-compose.yaml` file has been removed, as it was solely intended for internal testing purposes.

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

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
