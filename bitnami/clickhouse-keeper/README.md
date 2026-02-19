# Bitnami Secure Image for ClickHouse Keeper

## What is ClickHouse Keeper?

> ClickHouse Keeper is an alternative for ZooKeeper that solves well-known drawbacks and makes many additional improvements.

[Overview of ClickHouse Keeper](https://clickhouse.com/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name clickhouse-keeper bitnami/clickhouse-keeper:latest
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

The recommended way to get the Bitnami ClickHouse Keeper Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/clickhouse-keeper).

```console
docker pull bitnami/clickhouse-keeper:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/clickhouse-keeper/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/clickhouse-keeper:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/clickhouse-keeper` path. If the mounted directory is empty, it will be initialized on the first run.

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Configuration

ClickHouse Keeper can be configured via environment variables or using a configuration file (`keeper_config.xml`). If a configuration option is not specified in either the configuration file or in an environment variable, ClickHouse Keeper uses its internal default configuration.

### Configuration overrides

The configuration can easily be setup by mounting your own configuration overrides on the directory `/bitnami/clickhouse-keeper/etc/config.d` or `/bitnami/clickhouse-keeper/etc/users.d`:

```console
docker run --name clickhouse-keeper \
    --volume /path/to/override.xml:/bitnami/clickhouse-keeper/etc/config.d/override.xml:ro \
    bitnami/clickhouse-keeper:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  clickhouse-keeper:
    image: bitnami/clickhouse-keeper:latest
    volumes:
      - /path/to/override.xml:/bitnami/clickhouse-keeper/etc/config.d/override.xml:ro
```

Check the [official ClickHouse Keeper configuration documentation](https://clickhouse.com/docs/guides/sre/keeper/clickhouse-keeper) for all the possible overrides and settings.

### Environment variables

#### Customizable environment variables

| Name                           | Description                   | Default Value |
|--------------------------------|-------------------------------|---------------|
| `CLICKHOUSE_KEEPER_SKIP_SETUP` | Skip ClickHouse Keeper setup. | `no`          |
| `CLICKHOUSE_KEEPER_SERVER_ID`  | ClickHouse Keeper server ID.  | `nil`         |
| `CLICKHOUSE_KEEPER_TCP_PORT`   | ClickHouse Keeper TCP port.   | `9181`        |
| `CLICKHOUSE_KEEPER_RAFT_PORT`  | ClickHouse Keeper Raft port.  | `9234`        |

#### Read-only environment variables

| Name                                    | Description                                         | Value                                                    |
|-----------------------------------------|-----------------------------------------------------|----------------------------------------------------------|
| `CLICKHOUSE_KEEPER_BASE_DIR`            | ClickHouse Keeper installation directory.           | `${BITNAMI_ROOT_DIR}/clickhouse-keeper`                  |
| `CLICKHOUSE_KEEPER_VOLUME_DIR`          | ClickHouse Keeper volume directory.                 | `/bitnami/clickhouse-keeper`                             |
| `CLICKHOUSE_KEEPER_CONF_DIR`            | ClickHouse Keeper configuration directory.          | `${CLICKHOUSE_KEEPER_BASE_DIR}/etc`                      |
| `CLICKHOUSE_KEEPER_DEFAULT_CONF_DIR`    | ClickHouse Keeper default configuration directory.  | `${CLICKHOUSE_KEEPER_BASE_DIR}/etc.default`              |
| `CLICKHOUSE_KEEPER_MOUNTED_CONF_DIR`    | ClickHouse Keeper mounted configuration directory.  | `${CLICKHOUSE_KEEPER_VOLUME_DIR}/etc`                    |
| `CLICKHOUSE_KEEPER_CONF_FILE`           | ClickHouse Keeper configuration file.               | `${CLICKHOUSE_KEEPER_CONF_DIR}/keeper_config.xml`        |
| `CLICKHOUSE_KEEPER_DATA_DIR`            | ClickHouse Keeper data directory.                   | `${CLICKHOUSE_KEEPER_VOLUME_DIR}/coordination`           |
| `CLICKHOUSE_KEEPER_COORD_LOGS_DIR`      | ClickHouse Keeper coordination logs directory.      | `${CLICKHOUSE_KEEPER_DATA_DIR}/logs`                     |
| `CLICKHOUSE_KEEPER_COORD_SNAPSHOTS_DIR` | ClickHouse Keeper coordination snapshots directory. | `${CLICKHOUSE_KEEPER_DATA_DIR}/snapshots`                |
| `CLICKHOUSE_KEEPER_LOG_DIR`             | ClickHouse Keeper logs directory.                   | `${CLICKHOUSE_KEEPER_BASE_DIR}/logs`                     |
| `CLICKHOUSE_KEEPER_LOG_FILE`            | ClickHouse Keeper log file.                         | `${CLICKHOUSE_KEEPER_LOG_DIR}/clickhouse-keeper.log`     |
| `CLICKHOUSE_KEEPER_ERROR_LOG_FILE`      | ClickHouse Keeper error log file.                   | `${CLICKHOUSE_KEEPER_LOG_DIR}/clickhouse-keeper.err.log` |
| `CLICKHOUSE_KEEPER_TMP_DIR`             | ClickHouse Keeper temporary directory.              | `${CLICKHOUSE_KEEPER_BASE_DIR}/tmp`                      |
| `CLICKHOUSE_KEEPER_PID_FILE`            | ClickHouse Keeper PID file.                         | `${CLICKHOUSE_KEEPER_TMP_DIR}/clickhouse-keeper.pid`     |
| `CLICKHOUSE_DAEMON_USER`                | ClickHouse daemon system user.                      | `clickhouse`                                             |
| `CLICKHOUSE_DAEMON_GROUP`               | ClickHouse daemon system group.                     | `clickhouse`                                             |

### FIPS configuration in Bitnami Secure Images

The Bitnami ClickHouse Keeper Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Logging

The Bitnami ClickHouse Keeper Docker image sends the container logs to `stdout`. To view the logs:

```console
docker logs clickhouse-keeper
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
