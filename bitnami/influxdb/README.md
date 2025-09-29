# Bitnami Stack for InfluxDB&trade;

## What is InfluxDB&trade; Core?

> InfluxDB&trade; Core is an open source time-series database. It is a core component of the FDAP (Apache Flight, DataFusion, Arrow, and Parquet) stack.

[Overview of InfluxDB&trade; Core](https://www.influxdata.com/products/influxdb-overview)
InfluxDB(TM) is a trademark owned by InfluxData, which is not affiliated with, and does not endorse, this site.

## TL;DR

```console
docker run --name influxdb bitnami/influxdb:latest
```

## ⚠️ Important Notice: Upcoming changes to the Bitnami Catalog

Beginning August 28th, 2025, Bitnami will evolve its public catalog to offer a curated set of hardened, security-focused images under the new [Bitnami Secure Images initiative](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications). As part of this transition:

- Granting community users access for the first time to security-optimized versions of popular container images.
- Bitnami will begin deprecating support for non-hardened, Debian-based software images in its free tier and will gradually remove non-latest tags from the public catalog. As a result, community users will have access to a reduced number of hardened images. These images are published only under the “latest” tag and are intended for development purposes
- Starting August 28th, over two weeks, all existing container images, including older or versioned tags (e.g., 2.50.0, 10.6), will be migrated from the public catalog (docker.io/bitnami) to the “Bitnami Legacy” repository (docker.io/bitnamilegacy), where they will no longer receive updates.
- For production workloads and long-term support, users are encouraged to adopt Bitnami Secure Images, which include hardened containers, smaller attack surfaces, CVE transparency (via VEX/KEV), SBOMs, and enterprise support.

These changes aim to improve the security posture of all Bitnami users by promoting best practices for software supply chain integrity and up-to-date deployments. For more details, visit the [Bitnami Secure Images announcement](https://github.com/bitnami/containers/issues/83267).

## Why use Bitnami Secure Images?

- Bitnami Secure Images and Helm charts are built to make open source more secure and enterprise ready.
- Triage security vulnerabilities faster, with transparency into CVE risks using industry standard Vulnerability Exploitability Exchange (VEX), KEV, and EPSS scores.
- Our hardened images use a minimal OS (Photon Linux), which reduces the attack surface while maintaining extensibility through the use of an industry standard package format.
- Stay more secure and compliant with continuously built images updated within hours of upstream patches.
- Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
- Hardened images come with attestation signatures (Notation), SBOMs, virus scan reports and other metadata produced in an SLSA-3 compliant software factory.

Only a subset of BSI applications are available for free. Looking to access the entire catalog of applications as well as enterprise support? Try the [commercial edition of Bitnami Secure Images today](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/).

## How to deploy InfluxDB&trade; Core in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami InfluxDB&trade; Core Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/influxdb).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami InfluxDB&trade; Core Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/influxdb).

```console
docker pull bitnami/influxdb:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/influxdb/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/influxdb:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/influxdb` path. If the mounted directory is empty, it will be initialized on the first run.

```console
docker run \
    --volume /path/to/influxdb-persistence:/bitnami/influxdb \
    --env INFLUXDB_NODE_ID=0 \
    bitnami/influxdb:latest
```

You can also do this with a minor change to the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/influxdb/docker-compose.yml) file present in this repository:

```console
InfluxDB:
  ...
  volumes:
    - /path/to/influxdb-persistence:/bitnami/influxdb
  ...
```

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

In this example, we will create a InfluxDB&trade; Core client instance that will connect to the server instance that is running on the same docker network as the client.

#### Step 1: Create a network

```console
docker network create my-network --driver bridge
```

#### Step 2: Launch the InfluxDB&trade; Core container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `my-network` network.

```console
docker run -d --name influxdb-server \
  --network my-network \
  --env INFLUXDB_NODE_ID=0 \
  bitnami/influxdb:latest
```

#### Step 3: Launch your InfluxDB&trade; Core client instance

Finally we create a new container instance to launch the InfluxDB&trade; Core client and connect to the server created in the previous step:

```console
docker run -it --rm \
    --network my-network \
    bitnami/influxdb:latest influxdb3 show databases --host http://influxdb-server:8181
```

### Using a Docker Compose file

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `my-network`. In this example we assume that you want to connect to the InfluxDB&trade; Core server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  my-network:
    driver: bridge

services:
  influxdb:
    image: bitnami/influxdb:latest
    environment:
      - INFLUXDB_NODE_ID=0
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
> 2. In your application container, use the hostname `influxdb` to connect to the InfluxDB&trade; Core server

Launch the containers using:

```console
docker-compose up -d
```

## Configuration

InfluxDB&trade; Core can be configured via environment variables or using CLI flags. If a configuration option is not specified in either CLI flags or in an environment variable, InfluxDB&trade; Core uses its internal default configuration.

### Environment variables

#### Customizable environment variables

| Name                                    | Description                                                                            | Default Value                              |
|-----------------------------------------|----------------------------------------------------------------------------------------|--------------------------------------------|
| `INFLUXDB_DATA_DIR`                     | InfluxDB directory where data is stored.                                               | `${INFLUXDB_VOLUME_DIR}/data`              |
| `INFLUXDB_DATA_WAL_DIR`                 | InfluxDB directory where the WAL file is stored.                                       | `${INFLUXDB_VOLUME_DIR}/wal`               |
| `INFLUXDB_META_DIR`                     | InfluxDB directory where metadata is stored.                                           | `${INFLUXDB_VOLUME_DIR}/meta`              |
| `INFLUXDB_CONF_FILE_FORMAT`             | InfluxDB configuration file format, supported formats: yaml, yml, toml, json           | `yaml`                                     |
| `INFLUXDB_AUTOGEN_ADMIN_TOKEN_FILE`     | File where to store auto-generated admin token.                                        | `${INFLUXDB_VOLUME_DIR}/.token`            |
| `INFLUXD_CONFIG_PATH`                   | InfluxDB 2.x alias for configuration file path.                                        | `${INFLUXDB_CONF_DIR}`                     |
| `INFLUXDB_HTTP_PORT_NUMBER`             | Port number used by InfluxDB HTTP server.                                              | `8181`                                     |
| `INFLUXDB_HTTP_BIND_ADDRESS`            | InfluxDB HTTP bind address.                                                            | `0.0.0.0:${INFLUXDB_HTTP_PORT_NUMBER}`     |
| `INFLUXDB_HTTP_AUTH_ENABLED`            | Whether to enable InfluxDB HTTP auth.                                                  | `true`                                     |
| `INFLUXDB_REPORTING_DISABLED`           | Whether to disable InfluxDB reporting.                                                 | `true`                                     |
| `INFLUXDB_PORT_NUMBER`                  | Port number used by InfluxDB.                                                          | `8088`                                     |
| `INFLUXDB_BIND_ADDRESS`                 | InfluxDB bind address.                                                                 | `0.0.0.0:${INFLUXDB_PORT_NUMBER}`          |
| `INFLUXDB_HTTP_READINESS_TIMEOUT`       | InfluxDB HTTP port readiness timeout in seconds.                                       | `60`                                       |
| `INFLUXDB_PORT_READINESS_TIMEOUT`       | InfluxDB port readiness timeout in seconds.                                            | `30`                                       |
| `INFLUXDB_NODE_ID`                      | InfluxDB node identifier used as a prefix in all object store file paths.              | `nil`                                      |
| `INFLUXDB_OBJECT_STORE`                 | InfluxDB object storage to use to store Parquet files.                                 | `file`                                     |
| `INFLUXDB_INIT_MODE`                    | InfluxDB init mode.                                                                    | `setup`                                    |
| `INFLUXDB_INIT_V1_DIR`                  | Path to InfluxDB 1.x data to be imported into 2.x format                               | `${BITNAMI_VOLUME_DIR}/v1`                 |
| `INFLUXDB_INIT_V1_CONFIG`               | Path to InfluxDB 1.x config file                                                       | `${BITNAMI_VOLUME_DIR}/v1/config.yaml`     |
| `INFLUXDB_UPGRADE_LOG_FILE`             | InfluxDB 1.x to 2.x log file (do not place it into ${INFLUXDB_VOLUME_DIR})             | `${INFLUXDB_INIT_V1_DIR}/upgrade.log`      |
| `INFLUXDB_CONTINUOUS_QUERY_EXPORT_FILE` | InfluxDB continuous query file created during 1.x data to 2.x format migration process | `${INFLUXDB_INIT_V1_DIR}/v1-cq-export.txt` |
| `INFLUXDB_ADMIN_USER`                   | InfluxDB admin username.                                                               | `admin`                                    |
| `INFLUXDB_ADMIN_USER_PASSWORD`          | InfluxDB admin user password.                                                          | `nil`                                      |
| `INFLUXDB_ADMIN_USER_TOKEN`             | InfluxDB admin user token.                                                             | `nil`                                      |
| `INFLUXDB_ADMIN_CONFIG_NAME`            | InfluxDB admin user config name.                                                       | `default`                                  |
| `INFLUXDB_ADMIN_ORG`                    | InfluxDB admin org.                                                                    | `primary`                                  |
| `INFLUXDB_ADMIN_BUCKET`                 | InfluxDB admin user bucket.                                                            | `primary`                                  |
| `INFLUXDB_ADMIN_RETENTION`              | InfluxDB admin user retention.                                                         | `0`                                        |
| `INFLUXDB_USER`                         | Additional InfluxDB username.                                                          | `nil`                                      |
| `INFLUXDB_USER_PASSWORD`                | Additional InfluxDB user password.                                                     | `nil`                                      |
| `INFLUXDB_USER_ORG`                     | Additional InfluxDB user org.                                                          | `${INFLUXDB_ADMIN_ORG}`                    |
| `INFLUXDB_USER_BUCKET`                  | Additional InfluxDB user bucket.                                                       | `nil`                                      |
| `INFLUXDB_CREATE_USER_TOKEN`            | Whether to create user token for InfluxDB.                                             | `no`                                       |
| `INFLUXDB_READ_USER`                    | Additional InfluxDB read-only username.                                                | `nil`                                      |
| `INFLUXDB_READ_USER_PASSWORD`           | Additional InfluxDB read-only user password.                                           | `nil`                                      |
| `INFLUXDB_WRITE_USER`                   | Additional InfluxDB username with write privileges.                                    | `nil`                                      |
| `INFLUXDB_WRITE_USER_PASSWORD`          | Additional InfluxDB user with write privileges.                                        | `nil`                                      |
| `INFLUXDB_DB`                           | InfluxDB database name.                                                                | `nil`                                      |
| `INFLUXDB_CREATE_ADMIN_TOKEN`           | Whether to create admin token during initialization.                                   | `no`                                       |
| `INFLUXDB_ADMIN_TOKEN`                  | InfluxDB admin token.                                                                  | `nil`                                      |
| `INFLUXDB_DATABASES`                    | Comma or semicolon separated list of databases to be created during initialization.    | `nil`                                      |
| `AWS_ACCESS_KEY_ID`                     | AWS S3 access key id.                                                                  | `nil`                                      |
| `AWS_SECRET_ACCESS_KEY`                 | AWS S3 secret access key.                                                              | `nil`                                      |
| `GOOGLE_SERVICE_ACCOUNT`                | Google Cloud service account key.                                                      | `nil`                                      |
| `AZURE_STORAGE_ACCESS_KEY`              | Microsoft Azure access key.                                                            | `nil`                                      |

#### Read-only environment variables

| Name                        | Description                                                  | Value                                                      |
|-----------------------------|--------------------------------------------------------------|------------------------------------------------------------|
| `INFLUXDB_BASE_DIR`         | InfluxDB installation directory.                             | `${BITNAMI_ROOT_DIR}/influxdb`                             |
| `INFLUXDB_VOLUME_DIR`       | InfluxDB persistence directory.                              | `${BITNAMI_VOLUME_DIR}/influxdb`                           |
| `INFLUXDB_BIN_DIR`          | InfluxDB directory for binary executables.                   | `${INFLUXDB_BASE_DIR}/bin`                                 |
| `INFLUXDB_CONF_DIR`         | InfluxDB configuration directory.                            | `${INFLUXDB_BASE_DIR}/etc`                                 |
| `INFLUXDB_DEFAULT_CONF_DIR` | InfluxDB default configuration directory.                    | `${INFLUXDB_BASE_DIR}/etc.default`                         |
| `INFLUXDB_CONF_FILE`        | InfluxDB configuration file.                                 | `${INFLUXDB_CONF_DIR}/config.${INFLUXDB_CONF_FILE_FORMAT}` |
| `INFLUXDB_INITSCRIPTS_DIR`  | Directory where to look for InfluxDB init scripts.           | `/docker-entrypoint-initdb.d`                              |
| `LD_LIBRARY_PATH`           | Add search path for the linker.                              | `${BITNAMI_ROOT_DIR}/python/lib`                           |
| `INFLUXD_ENGINE_PATH`       | InfluxDB 2.x alias for engine path.                          | `${INFLUXDB_VOLUME_DIR}`                                   |
| `INFLUXD_BOLT_PATH`         | InfluxDB 2.x alias for bolt path.                            | `${INFLUXDB_VOLUME_DIR}/influxd.bolt`                      |
| `INFLUX_CONFIGS_PATH`       | InfluxDB 2.x alias for paths to extra configuration folders. | `${INFLUXDB_VOLUME_DIR}/configs`                           |
| `INFLUXDB_DAEMON_USER`      | InfluxDB system user.                                        | `influxdb`                                                 |
| `INFLUXDB_DAEMON_GROUP`     | InfluxDB system group.                                       | `influxdb`                                                 |

Additionally, InfluxDB&trade; Core can be configured using its internal environment variables prefixed by `INFLUXDB3_`, find more information [here](https://docs.influxdata.com/influxdb3/core/reference/config-options).

> Note: The settings at the environment variables override the equivalent options in the configuration file.

### Initializing a new instance

When the container is executed for the first time, it will execute the files with extensions `.sh` located at `/docker-entrypoint-initdb.d`.

In order to have your custom files inside the docker image you can mount them as a volume.

### Setting the admin token on first run

The admin token can easily be setup with the Bitnami InfluxDB&trade; Core Docker image setting the environment variable `INFLUXDB_CREATE_ADMIN_TOKEN` to `yes`.

```console
docker run --name influxdb -e INFLUXDB_CREATE_ADMIN_TOKEN=yes bitnami/influxdb:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/influxdb/docker-compose.yml) file present in this repository:

```yaml
services:
  influxdb:
  ...
    environment:
      - INFLUXDB_CREATE_ADMIN_TOKEN=yes
  ...
```

### Creating databases during initialization

You can use the `INFLUXDB_DATABASES` environment variable to specify a comma separated list of databases to created during the container initialization. This is useful if your application requires databases ready to be consumed, saving you from having to manually create them using the InfluxDB&trade; Core CLI.

```console
docker run --name influxdb \
    -e INFLUXDB_CREATE_ADMIN_TOKEN=yes \
    -e INFLUXDB_DATABASES=foo,bar \
    bitnami/influxdb:latest
```

### FIPS configuration in Bitnami Secure Images

The Bitnami InfluxDB&trade; Core Docker image from the [Bitnami Secure Images](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Logging

The Bitnami InfluxDB&trade; Core Docker image sends the container logs to `stdout`. To view the logs:

```console
docker logs influxdb
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of InfluxDB&trade; Core, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/influxdb:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/influxdb:latest`.

#### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
docker stop influxdb
```

or using Docker Compose:

```console
docker-compose stop influxdb
```

Next, take a snapshot of the persistent volume `/path/to/influxdb-persistence` using:

```console
rsync -a /path/to/influxdb-persistence /path/to/influxdb-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

#### Step 3: Remove the currently running container

```console
docker rm -v influxdb
```

or using Docker Compose:

```console
docker-compose rm -v influxdb
```

#### Step 4: Run the new image

Re-create your container from the new image.

```console
docker run --name influxdb bitnami/influxdb:latest
```

or using Docker Compose:

```console
docker-compose up influxdb
```

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/influxdb).

If you detect any issue in the `docker-compose.yaml` file, feel free to report it or contribute with a fix by following our [Contributing Guidelines](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md).

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

InfluxDB&trade; Core is a trademark owned by InfluxData, which is not affiliated with, and does not endorse, this product.
