# Bitnami Stack for InfluxDB&trade;

## What is InfluxDB&trade;?

> InfluxDB&trade; is an open source time-series database. It is a core component of the TICK (Telegraf, InfluxDB&trade;, Chronograf, Kapacitor) stack.

[Overview of InfluxDB&trade;](https://www.influxdata.com/products/influxdb-overview)
InfluxDB(TM) is a trademark owned by InfluxData, which is not affiliated with, and does not endorse, this site.

## TL;DR

```console
docker run --name influxdb bitnami/influxdb:latest
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use InfluxDB&trade; in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## How to deploy InfluxDB (TM) in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami InfluxDB (TM) Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/influxdb).

Bitnami containers can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami InfluxDB (TM) Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/influxdb).

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
    --env INFLUXDB_HTTP_AUTH_ENABLED=false \
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

In this example, we will create a InfluxDB (TM) client instance that will connect to the server instance that is running on the same docker network as the client.

#### Step 1: Create a network

```console
docker network create my-network --driver bridge
```

#### Step 2: Launch the InfluxDB (TM) container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `my-network` network.

```console
docker run -d --name influxdb-server \
  --network my-network \
  --env INFLUXDB_HTTP_AUTH_ENABLED=false \
  bitnami/influxdb:latest
```

#### Step 3: Launch your InfluxDB (TM) client instance

Finally we create a new container instance to launch the InfluxDB (TM) client and connect to the server created in the previous step:

```console
docker run -it --rm \
    --network my-network \
    bitnami/influxdb:latest influx -host influxdb-server
```

### Using a Docker Compose file

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `my-network`. In this example we assume that you want to connect to the InfluxDB (TM) server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  my-network:
    driver: bridge

services:
  influxdb:
    image: bitnami/influxdb:latest
    environment:
      - INFLUXDB_HTTP_AUTH_ENABLED=false
    networks:
      - my-network
  myapp:
    image: 'YOUR_APPLICATION_IMAGE'
    networks:
      - my-network
```

> **IMPORTANT**:
>
> 1. Please update the `YOUR_APPLICATION_IMAGE` placeholder in the above snippet with your application image
> 2. In your application container, use the hostname `influxdb` to connect to the InfluxDB (TM) server

Launch the containers using:

```console
docker-compose up -d
```

## Configuration

InfluxDB (TM) can be configured via environment variables or using a configuration file (`config.yaml`). If a configuration option is not specified in either the configuration file or in an environment variable, InfluxDB (TM) uses its internal default configuration.

### Environment variables

#### Customizable environment variables

| Name                                    | Description                                                                            | Default Value                              |
|-----------------------------------------|----------------------------------------------------------------------------------------|--------------------------------------------|
| `INFLUXDB_DATA_DIR`                     | InfluxDB directory where data is stored.                                               | `${INFLUXDB_VOLUME_DIR}/data`              |
| `INFLUXDB_DATA_WAL_DIR`                 | InfluxDB directory where the WAL file is stored.                                       | `${INFLUXDB_VOLUME_DIR}/wal`               |
| `INFLUXDB_META_DIR`                     | InfluxDB directory where metadata is stored.                                           | `${INFLUXDB_VOLUME_DIR}/meta`              |
| `INFLUXD_CONFIG_PATH`                   | InfluxDB 2.x alias for configuration file path.                                        | `${INFLUXDB_CONF_DIR}`                     |
| `INFLUXDB_REPORTING_DISABLED`           | Whether to disable InfluxDB reporting.                                                 | `true`                                     |
| `INFLUXDB_HTTP_PORT_NUMBER`             | Port number used by InfluxDB HTTP server.                                              | `8086`                                     |
| `INFLUXDB_HTTP_BIND_ADDRESS`            | InfluxDB HTTP bind address.                                                            | `0.0.0.0:${INFLUXDB_HTTP_PORT_NUMBER}`     |
| `INFLUXDB_HTTP_READINESS_TIMEOUT`       | InfluxDB HTTP port readiness timeout in seconds.                                       | `60`                                       |
| `INFLUXDB_PORT_NUMBER`                  | Port number used by InfluxDB.                                                          | `8088`                                     |
| `INFLUXDB_BIND_ADDRESS`                 | InfluxDB bind address.                                                                 | `0.0.0.0:${INFLUXDB_PORT_NUMBER}`          |
| `INFLUXDB_PORT_READINESS_TIMEOUT`       | InfluxDB port readiness timeout in seconds.                                            | `30`                                       |
| `INFLUXDB_INIT_MODE`                    | InfluxDB init mode.                                                                    | `setup`                                    |
| `INFLUXDB_INIT_V1_DIR`                  | Path to InfluxDB 1.x data to be imported into 2.x format                               | `${BITNAMI_VOLUME_DIR}/v1`                 |
| `INFLUXDB_INIT_V1_CONFIG`               | Path to InfluxDB 1.x config file                                                       | `${BITNAMI_VOLUME_DIR}/v1/config.yaml`     |
| `INFLUXDB_UPGRADE_LOG_FILE`             | InfluxDB 1.x to 2.x log file (do not place it into ${INFLUXDB_VOLUME_DIR})             | `${INFLUXDB_INIT_V1_DIR}/upgrade.log`      |
| `INFLUXDB_CONTINUOUS_QUERY_EXPORT_FILE` | InfluxDB continuous query file created during 1.x data to 2.x format migration process | `${INFLUXDB_INIT_V1_DIR}/v1-cq-export.txt` |
| `INFLUXDB_HTTP_AUTH_ENABLED`            | Whether to enable InfluxDB HTTP auth.                                                  | `true`                                     |
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

#### Read-only environment variables

| Name                        | Description                                                  | Value                                 |
|-----------------------------|--------------------------------------------------------------|---------------------------------------|
| `INFLUXDB_BASE_DIR`         | InfluxDB installation directory.                             | `${BITNAMI_ROOT_DIR}/influxdb`        |
| `INFLUXDB_VOLUME_DIR`       | InfluxDB persistence directory.                              | `${BITNAMI_VOLUME_DIR}/influxdb`      |
| `INFLUXDB_BIN_DIR`          | InfluxDB directory for binary executables.                   | `${INFLUXDB_BASE_DIR}/bin`            |
| `INFLUXDB_CONF_DIR`         | InfluxDB configuration directory.                            | `${INFLUXDB_BASE_DIR}/etc`            |
| `INFLUXDB_DEFAULT_CONF_DIR` | InfluxDB default configuration directory.                    | `${INFLUXDB_BASE_DIR}/etc.default`    |
| `INFLUXDB_CONF_FILE`        | InfluxDB configuration file.                                 | `${INFLUXDB_CONF_DIR}/config.yaml`    |
| `INFLUXDB_INITSCRIPTS_DIR`  | Directory where to look for InfluxDB init scripts.           | `/docker-entrypoint-initdb.d`         |
| `INFLUXD_ENGINE_PATH`       | InfluxDB 2.x alias for engine path.                          | `${INFLUXDB_VOLUME_DIR}`              |
| `INFLUXD_BOLT_PATH`         | InfluxDB 2.x alias for bolt path.                            | `${INFLUXDB_VOLUME_DIR}/influxd.bolt` |
| `INFLUX_CONFIGS_PATH`       | InfluxDB 2.x alias for paths to extra configuration folders. | `${INFLUXDB_VOLUME_DIR}/configs`      |
| `INFLUXDB_DAEMON_USER`      | InfluxDB system user.                                        | `influxdb`                            |
| `INFLUXDB_DAEMON_GROUP`     | InfluxDB system group.                                       | `influxdb`                            |

Additionally, InfluxDB (TM) can be configured using its internal environment variables prefixed by `INFLUXD_`, find more information [here](https://docs.influxdata.com/influxdb/v2.0/reference/config-options).

> Note: The settings at the environment variables override the equivalent options in the configuration file."

### Configuration file

The configuration can easily be setup by mounting your own configuration file (`config.yaml`) on the directory `/opt/bitnami/influxdb/etc/`:

```console
docker run --name influxdb \
    --volume /path/to/config.yaml:/opt/bitnami/influxdb/etc/config.yaml:ro \
    bitnami/influxdb:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  influxdb:
    image: bitnami/influxdb:latest
    volumes:
      - /path/to/config.yaml:/opt/bitnami/influxdb/etc/config.yaml:ro
```

### Initializing a new instance

When the container is executed for the first time, it will execute the files with extensions `.sh`, and `.txt` located at `/docker-entrypoint-initdb.d`.

In order to have your custom files inside the docker image you can mount them as a volume.

### Setting the admin password on first run

The admin user and password can easily be setup with the Bitnami InfluxDB (TM) Docker image using the following environment variables:

* `INFLUXDB_ADMIN_USER`: The database admin user. Defaults to `admin`.
* `INFLUXDB_ADMIN_USER_PASSWORD`: The database admin user password. No defaults.

Passing the `INFLUXDB_ADMIN_USER_PASSWORD` environment variable when running the image for the first time will set the password of the `INFLUXDB_ADMIN_USER` user to the value of `INFLUXDB_ADMIN_USER_PASSWORD`.

```console
docker run --name influxdb -e INFLUXDB_ADMIN_USER_PASSWORD=password123 bitnami/influxdb:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/influxdb/docker-compose.yml) file present in this repository:

```yaml
services:
  influxdb:
  ...
    environment:
      - INFLUXDB_ADMIN_USER_PASSWORD=password123
  ...
```

**Warning** In case you want to allow users to access the database without credentials, set the environment variable `INFLUXDB_HTTP_AUTH_ENABLED=false`. **This is recommended only for development**. If you are using InfluxDB (TM) v2 authentication is required and `INFLUXDB_HTTP_AUTH_ENABLED` will be ignored.

### Allowing empty passwords

By default the InfluxDB (TM) image expects all the available passwords to be set. In order to allow empty passwords, it is necessary to set the `INFLUXDB_HTTP_AUTH_ENABLED=false` env variable. This env variable is only recommended for testing or development purposes. We strongly recommend specifying the `INFLUXDB_ADMIN_USER_PASSWORD` for any other scenario. If you are using InfluxDB (TM) v2, authentication is required and `INFLUXDB_HTTP_AUTH_ENABLED` will be ignored.

```console
docker run --name influxdb --env INFLUXDB_HTTP_AUTH_ENABLED=false bitnami/influxdb:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/influxdb/docker-compose.yml) file present in this repository:

```yaml
services:
  influxdb:
  ...
    environment:
      - INFLUXDB_HTTP_AUTH_ENABLED=false
  ...
```

### Creating a database on first run

For InfluxDB (TM) v2 you can pass `INFLUXDB_USER_BUCKET` environment variable when running the image for the first time, a new bucket will be created. This is useful if your application requires that a bucket already exists, saving you from having to manually create the bucket using the InfluxDB (TM) CLI.

```console
docker run --name influxdb \
    -e INFLUXDB_ADMIN_USER_PASSWORD=password123 \
    -e INFLUXDB_USER_BUCKET=my_bucket \
    bitnami/influxdb:latest
```

### Creating a database user on first run

You can create a restricted database user that only has permissions for the database created with the [`INFLUXDB_DB`](#creating-a-database-on-first-run) environment variable. To do this, provide the `INFLUXDB_USER` environment variable and to set a password for the database user provide the `INFLUXDB_USER_PASSWORD` variable.

```console
docker run --name influxdb \
  -e INFLUXDB_ADMIN_USER_PASSWORD=password123 \
  -e INFLUXDB_USER=my_user \
  -e INFLUXDB_USER_PASSWORD=my_password \
  -e INFLUXDB_DB=my_database \
  bitnami/influxdb:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/influxdb/docker-compose.yml) file present in this repository:

```yaml
services:
  influxdb:
  ...
    environment:
      - INFLUXDB_ADMIN_USER_PASSWORD=password123
      - INFLUXDB_USER=my_user
      - INFLUXDB_USER_PASSWORD=my_password
      - INFLUXDB_DB=my_database
  ...
```

You can also create users with restricted privileges in the database in a very similar way. To do so, user the environment variables below:

* `INFLUXDB_READ_USER`: Specify the user with "read" privileges in the database.
* `INFLUXDB_READ_USER_PASSWORD`: Specify the password of the `INFLUXDB_READ_USER` user.
* `INFLUXDB_WRITE_USER`: Specify the user with "write" privileges in the database.
* `INFLUXDB_WRITE_USER_PASSWORD`: Specify the password of the `INFLUXDB_WRITE_USER` user.

### Customize the HTTP port readiness

You can modify the timeout for the HTTP port readiness probe where the container waits until the HTTP port is actually ready to receive queries before finish the setup. Use `INFLUXDB_HTTP_READINESS_TIMEOUT` to do this.

```console
docker run --name influxdb \
  -e INFLUXDB_ADMIN_USER_PASSWORD=password123 \
  -e INFLUXDB_USER=my_user \
  -e INFLUXDB_USER_PASSWORD=my_password \
  -e INFLUXDB_DB=my_database \
  -e INFLUXDB_HTTP_READINESS_TIMEOUT=30 \
  bitnami/influxdb:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/influxdb/docker-compose.yml) file present in this repository:

```yaml
services:
  influxdb:
  ...
    environment:
      - INFLUXDB_ADMIN_USER_PASSWORD=password123
      - INFLUXDB_USER=my_user
      - INFLUXDB_USER_PASSWORD=my_password
      - INFLUXDB_DB=my_database
      - INFLUXDB_HTTP_READINESS_TIMEOUT=30
  ...
```

* `INFLUXDB_HTTP_READINESS_TIMEOUT`: Spacify the time to wait until the HTTP endpoint is ready in seconds. Default: 60

### Migrate InfluxDB 1.x data into 2.x format

You can migrate your InfluxDB 1.x data into 2.x format by setting `INFLUXDB_INIT_MODE=upgrade`, and mounting the InfluxDB 1.x data into the container (let the initialization logic know where it is located with the `INFLUXDB_INIT_V1_DIR` variable). Do not point `INFLUXDB_INIT_V1_DIR` into `INFLUXDB_VOLUME_DIR` (default: `/bitnami/influxdb`), or the upgrade process will fail.

```console
docker run --name influxdb \
  -e INFLUXDB_ADMIN_USER_PASSWORD=password123 \
  -e INFLUXDB_USER=my_user \
  -e INFLUXDB_USER_PASSWORD=my_password \
  -e INFLUXDB_DB=my_database \
  -e INFLUXDB_INIT_MODE=upgrade \
  -e INFLUXDB_INIT_V1_DIR=/bitnami/v1 \
  bitnami/influxdb:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/influxdb/docker-compose.yml) file present in this repository:

```yaml
services:
  influxdb:
  ...
    environment:
      - INFLUXDB_ADMIN_USER_PASSWORD=password123
      - INFLUXDB_USER=my_user
      - INFLUXDB_USER_PASSWORD=my_password
      - INFLUXDB_DB=my_database
      - INFLUXDB_INIT_MODE=upgrade
      - INFLUXDB_INIT_V1_DIR=/bitnami/v1
  ...
```

* `INFLUXDB_INIT_MODE`: InfluxDB init mode. `['setup', 'upgrade']`. Default: `setup`.
* `INFLUXDB_INIT_V1_DIR`: Path to InfluxDB 1.x data to be imported into 2.x format. Default: `${BITNAMI_VOLUME_DIR}/v1`.

## Logging

The Bitnami InfluxDB (TM) Docker image sends the container logs to `stdout`. To view the logs:

```console
docker logs influxdb
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of InfluxDB (TM), including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

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

InfluxDB (TM) is a trademark owned by InfluxData, which is not affiliated with, and does not endorse, this product.
