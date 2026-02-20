# Bitnami Secure Image for ClickHouse

## What is ClickHouse?

> ClickHouse is an open-source column-oriented OLAP database management system. Use it to boost your database performance while providing linear scalability and hardware efficiency.

[Overview of ClickHouse](https://clickhouse.com/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name clickhouse bitnami/clickhouse:latest
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

## How to deploy ClickHouse in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami ClickHouse Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/clickhouse).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

## Get this image

The recommended way to get the Bitnami ClickHouse Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/clickhouse).

```console
docker pull bitnami/clickhouse:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/clickhouse/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/clickhouse:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/clickhouse).

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/clickhouse` path. If the mounted directory is empty, it will be initialized on the first run.

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Configuration

ClickHouse can be configured via environment variables or using a configuration file (`config.xml`). If a configuration option is not specified in either the configuration file or in an environment variable, ClickHouse uses its internal default configuration.

### Configuration overrides

The configuration can easily be setup by mounting your own configuration overrides on the directory `/bitnami/clickhouse/etc/config.d` or `/bitnami/clickhouse/etc/users.d`.

Check the [official ClickHouse configuration documentation](https://clickhouse.com/docs/en/operations/configuration-files/) for all the possible overrides and settings.

### Initializing a new instance

When the container is executed for the first time, it will execute the files with extensions `.sh` located at `/docker-entrypoint-initdb.d`. For scripts to be executed every time the container starts, use the `/docker-entrypoint-startdb.d` folder.

In order to have your custom files inside the docker image you can mount them as a volume.

> NOTE: If you use JSON format for clickhouse logs and remove the message field of the logs, the application will fail to start if there are init or start scripts in any of those 2 folders.

### Environment variables

#### Customizable environment variables

| Name                               | Description                       | Default Value |
|------------------------------------|-----------------------------------|---------------|
| `ALLOW_EMPTY_PASSWORD`             | Allow an empty password.          | `no`          |
| `CLICKHOUSE_SKIP_USER_SETUP`       | Skip ClickHouse admin user setup. | `no`          |
| `CLICKHOUSE_ADMIN_USER`            | ClickHouse admin username.        | `default`     |
| `CLICKHOUSE_ADMIN_PASSWORD`        | ClickHouse admin password.        | `nil`         |
| `CLICKHOUSE_HTTP_PORT`             | ClickHouse HTTP port.             | `8123`        |
| `CLICKHOUSE_TCP_PORT`              | ClickHouse TCP port.              | `9000`        |
| `CLICKHOUSE_MYSQL_PORT`            | ClickHouse MySQL port.            | `9004`        |
| `CLICKHOUSE_POSTGRESQL_PORT`       | ClickHouse PostgreSQL port.       | `9005`        |
| `CLICKHOUSE_INTERSERVER_HTTP_PORT` | ClickHouse Inter-server port.     | `9009`        |

#### Read-only environment variables

| Name                          | Description                         | Value                                        |
|-------------------------------|-------------------------------------|----------------------------------------------|
| `CLICKHOUSE_BASE_DIR`         | ClickHouse installation directory.  | `${BITNAMI_ROOT_DIR}/clickhouse`             |
| `CLICKHOUSE_VOLUME_DIR`       | ClickHouse volume directory.        | `/bitnami/clickhouse`                        |
| `CLICKHOUSE_CONF_DIR`         | ClickHouse configuration directory. | `${CLICKHOUSE_BASE_DIR}/etc`                 |
| `CLICKHOUSE_DEFAULT_CONF_DIR` | ClickHouse configuration directory. | `${CLICKHOUSE_BASE_DIR}/etc.default`         |
| `CLICKHOUSE_MOUNTED_CONF_DIR` | ClickHouse configuration directory. | `${CLICKHOUSE_VOLUME_DIR}/etc`               |
| `CLICKHOUSE_DATA_DIR`         | ClickHouse data directory.          | `${CLICKHOUSE_VOLUME_DIR}/data`              |
| `CLICKHOUSE_LOG_DIR`          | ClickHouse logs directory.          | `${CLICKHOUSE_BASE_DIR}/logs`                |
| `CLICKHOUSE_CONF_FILE`        | ClickHouse log file.                | `${CLICKHOUSE_CONF_DIR}/config.xml`          |
| `CLICKHOUSE_LOG_FILE`         | ClickHouse log file.                | `${CLICKHOUSE_LOG_DIR}/clickhouse.log`       |
| `CLICKHOUSE_ERROR_LOG_FILE`   | ClickHouse log file.                | `${CLICKHOUSE_LOG_DIR}/clickhouse_error.log` |
| `CLICKHOUSE_TMP_DIR`          | ClickHouse temporary directory.     | `${CLICKHOUSE_BASE_DIR}/tmp`                 |
| `CLICKHOUSE_PID_FILE`         | ClickHouse PID file.                | `${CLICKHOUSE_TMP_DIR}/clickhouse.pid`       |
| `CLICKHOUSE_INITSCRIPTS_DIR`  | ClickHouse init scripts directory.  | `/docker-entrypoint-initdb.d`                |
| `CLICKHOUSE_DAEMON_USER`      | ClickHouse daemon system user.      | `clickhouse`                                 |
| `CLICKHOUSE_DAEMON_GROUP`     | ClickHouse daemon system group.     | `clickhouse`                                 |

### FIPS configuration in Bitnami Secure Images

The Bitnami ClickHouse Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Logging

The Bitnami ClickHouse Docker image sends the container logs to `stdout`. To view the logs:

```console
docker logs clickhouse
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

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
