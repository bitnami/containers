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

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/clickhouse` path. If the mounted directory is empty, it will be initialized on the first run.

```console
docker run \
    --volume /path/to/clickhouse-persistence:/bitnami/clickhouse \
    --env ALLOM_EMPTY_PASSWORD=false \
    bitnami/clickhouse:latest
```

You can also do this with a minor change to the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/clickhouse/docker-compose.yml) file present in this repository:

```console
clickhouse:
  ...
  volumes:
    - /path/to/clickhouse-persistence:/bitnami/clickhouse
  ...
```

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

In this example, we will create a ClickHouse client instance that will connect to the server instance that is running on the same docker network as the client.

#### Step 1: Create a network

```console
docker network create my-network --driver bridge
```

#### Step 2: Launch the ClickHouse container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `my-network` network.

```console
docker run -d --name clickhouse-server \
  --network my-network \
  --env ALLOW_EMPTY_PASSWORD=yes \
  bitnami/clickhouse:latest
```

#### Step 3: Launch your ClickHouse client instance

Finally we create a new container instance to launch the ClickHouse client and connect to the server created in the previous step:

```console
docker run -it --rm \
    --network my-network \
    bitnami/clickhouse:latest clickhouse-client --host clickhouse-server
```

### Using a Docker Compose file

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `my-network`. In this example we assume that you want to connect to the ClickHouse server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  my-network:
    driver: bridge

services:
  clickhouse:
    image: bitnami/clickhouse:latest
    environment:
      - ALLOW_EMPTY_PASSWORD=no
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
> 2. In your application container, use the hostname `clickhouse` to connect to the ClickHouse server

Launch the containers using:

```console
docker-compose up -d
```

## Configuration

ClickHouse can be configured via environment variables or using a configuration file (`config.xml`). If a configuration option is not specified in either the configuration file or in an environment variable, ClickHouse uses its internal default configuration.

### Configuration overrides

The configuration can easily be setup by mounting your own configuration overrides on the directory `/bitnami/clickhouse/etc/config.d` or `/bitnami/clickhouse/etc/users.d`:

```console
docker run --name clickhouse \
    --volume /path/to/override.xml:/bitnami/clickhouse/etc/config.d/override.xml:ro \
    bitnami/clickhouse:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  clickhouse:
    image: bitnami/clickhouse:latest
    volumes:
      - /path/to/override.xml:/bitnami/clickhouse/etc/config.d/override.xml:ro
```

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

### Setting the admin password on first run

Passing the `CLICKHOUSE_ADMIN_PASSWORD` environment variable when running the image for the first time will set the password of the `CLICKHOUSE_ADMIN_USER` user to the value of `CLICKHOUSE_ADMIN_PASSWORD`.

```console
docker run --name clickhouse -e CLICKHOUSE_ADMIN_PASSWORD=password123 bitnami/clickhouse:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/clickhouse/docker-compose.yml) file present in this repository:

```yaml
services:
  clickhouse:
  ...
    environment:
      - CLICKHOUSE_ADMIN_PASSWORD=password123
  ...
```

### Allowing empty passwords

By default the ClickHouse image expects all the available passwords to be set. In order to allow empty passwords, it is necessary to set the `ALLOW_EMPTY_PASSWORD=yes` env variable. This env variable is only recommended for testing or development purposes. We strongly recommend specifying the `CLICKHOUSE_ADMIN_PASSWORD` for any other scenario.

```console
docker run --name clickhouse --env ALLOW_EMPTY_PASSWORD=yes bitnami/clickhouse:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/clickhouse/docker-compose.yml) file present in this repository:

```yaml
services:
  clickhouse:
  ...
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
  ...
```

### FIPS configuration in Bitnami Secure Images

The Bitnami ClickHouse Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Logging

The Bitnami ClickHouse Docker image sends the container logs to `stdout`. To view the logs:

```console
docker logs clickhouse
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of ClickHouse, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/clickhouse:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/clickhouse:latest`.

#### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
docker stop clickhouse
```

or using Docker Compose:

```console
docker-compose stop clickhouse
```

Next, take a snapshot of the persistent volume `/path/to/clickhouse-persistence` using:

```console
rsync -a /path/to/clickhouse-persistence /path/to/clickhouse-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

#### Step 3: Remove the currently running container

```console
docker rm -v clickhouse
```

or using Docker Compose:

```console
docker-compose rm -v clickhouse
```

#### Step 4: Run the new image

Re-create your container from the new image.

```console
docker run --name clickhouse bitnami/clickhouse:latest
```

or using Docker Compose:

```console
docker-compose up clickhouse
```

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/clickhouse).

If you detect any issue in the `docker-compose.yaml` file, feel free to report it or contribute with a fix by following our [Contributing Guidelines](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md).

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
