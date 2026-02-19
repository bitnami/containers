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

```console
docker run \
    --volume /path/to/clickhouse-keeper-persistence:/bitnami/clickhouse-keeper \
    bitnami/clickhouse-keeper:latest
```

You can also do this with a minor change to the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/clickhouse-keeper/docker-compose.yml) file present in this repository:

```console
clickhouse-keeper:
  ...
  volumes:
    - /path/to/clickhouse-keeper-persistence:/bitnami/clickhouse-keeper
  ...
```

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

In this example, we will create a ClickHouse Keeper client instance that will connect to the ClickHouse Keeper instance that is running on the same docker network as the client.

#### Step 1: Create a network

```console
docker network create my-network --driver bridge
```

#### Step 2: Launch the ClickHouse Keeper container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `my-network` network.

```console
docker run -d --name clickhouse-keeper \
  --env CLICKHOUSE_KEEPER_SERVER_ID=1 \
  --network my-network \
  bitnami/clickhouse-keeper:latest
```

#### Step 3: Launch your ClickHouse Keeper client instance

Finally we create a new container instance to launch the ClickHouse Keeper client and connect to the ClickHouse Keeper created in the previous step:

```console
docker run -it --rm \
    --network my-network \
    bitnami/clickhouse-keeper:latest clickhouse-keeper-client --host clickhouse-keeper
```

### Using a Docker Compose file

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `my-network`. In this example we assume that you want to connect to the ClickHouse Keeper from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  my-network:
    driver: bridge

services:
  clickhouse-keeper:
    image: bitnami/clickhouse-keeper:latest
    environment:
      - CLICKHOUSE_KEEPER_SERVER_ID=1
    networks:
      - my-network
  myapp:
    image: YOUR_APPLICATION_IMAGE
    networks:
      - my-network
```

> **IMPORTANT**:
>
> 1. Please update the `YOUR_APPLICATION_IMAGE` placeholder in the above snippet with your application image
> 2. In your application container, use the hostname `clickhouse-keeper` to connect to the ClickHouse Keeper server

Launch the containers using:

```console
docker-compose up -d
```

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

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of ClickHouse Keeper, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/clickhouse-keeper:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/clickhouse-keeper:latest`.

#### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
docker stop clickhouse-keeper
```

or using Docker Compose:

```console
docker-compose stop clickhouse-keeper
```

Next, take a snapshot of the persistent volume `/path/to/clickhouse-keeper-persistence` using:

```console
rsync -a /path/to/clickhouse-keeper-persistence /path/to/clickhouse-keeper-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

#### Step 3: Remove the currently running container

```console
docker rm -v clickhouse-keeper
```

or using Docker Compose:

```console
docker-compose rm -v clickhouse-keeper
```

#### Step 4: Run the new image

Re-create your container from the new image.

```console
docker run --name clickhouse-keeper bitnami/clickhouse-keeper:latest
```

or using Docker Compose:

```console
docker-compose up clickhouse-keeper
```

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
