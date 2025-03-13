# Bitnami package for Apache Solr

## What is Apache Solr?

> Apache Solr is an extremely powerful, open source enterprise search platform built on Apache Lucene. It is highly reliable and flexible, scalable, and designed to add value very quickly after launch.

[Overview of Apache Solr](http://lucene.apache.org/solr/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name solr bitnami/solr:latest
```

You can find the available configuration options in the [Environment Variables](#environment-variables) section.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Apache Solr in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami solr Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/solr).

```console
docker pull bitnami/solr:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/solr/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/solr:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. The above examples define a docker volume namely `solr_data`. The Solr application state will persist as long as this volume is not removed.

To avoid inadvertent removal of this volume you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

```console
docker run -v /path/to/solr-persistence:/bitnami bitnami/solr:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/solr/docker-compose.yml) file present in this repository:

```yaml
solr:
  ...
  volumes:
    - /path/to/solr-persistence:/bitnami
  ...
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a Solr server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

#### Step 1: Create a network

```console
docker network create solr-network --driver bridge
```

#### Step 2: Launch the solr container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `solr-network` network.

```console
docker run --name solr-node1 --network solr-network bitnami/solr:latest
```

#### Step 3: Run another containers

We can launch another containers using the same flag (`--network NETWORK`) in the `docker run` command. If you also set a name to your container, you will be able to use it as hostname in your network.

### Using a Docker Compose file

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new bridge network named solr-network.

```yaml
version: '2'

networks:
  solr-network:
    driver: bridge

services:
  solr-node1:
    image: bitnami/solr:latest
    networks:
      - solr-network
    ports:
      - '8983:8983'
  solr-node2:
    image: bitnami/solr:latest
    networks:
      - solr-network
    ports:
      - '8984:8984'
```

Then, launch the containers using:

```console
docker-compose up -d
```

## Configuration

### Environment variables

#### Customizable environment variables

| Name                                 | Description                                                                   | Default Value                                      |
|--------------------------------------|-------------------------------------------------------------------------------|----------------------------------------------------|
| `SOLR_ENABLE_CLOUD_MODE`             | Starts solr in cloud mode                                                     | `no`                                               |
| `SOLR_NUMBER_OF_NODES`               | Number of nodes of the solr cloud cluster                                     | `1`                                                |
| `SOLR_HOST`                          | Solr Host name                                                                | `nil`                                              |
| `SOLR_JETTY_HOST`                    | Configuration to listen on a specific IP address or host name                 | `0.0.0.0`                                          |
| `SOLR_HEAP`                          | Solr Heap                                                                     | `nil`                                              |
| `SOLR_SECURITY_MANAGER_ENABLED`      | Solr Java security manager                                                    | `false`                                            |
| `SOLR_JAVA_MEM`                      | Solr JVM memory                                                               | `-Xms512m -Xmx512m`                                |
| `SOLR_PORT_NUMBER`                   | Solr port number                                                              | `8983`                                             |
| `SOLR_CORES`                         | Solr CORE name                                                                | `nil`                                              |
| `SOLR_COLLECTION`                    | Solr COLLECTION name                                                          | `nil`                                              |
| `SOLR_COLLECTION_REPLICAS`           | Solar collection replicas                                                     | `1`                                                |
| `SOLR_COLLECTION_SHARDS`             | Solar collection shards                                                       | `1`                                                |
| `SOLR_ENABLE_AUTHENTICATION`         | Enables authentication                                                        | `no`                                               |
| `SOLR_ADMIN_USERNAME`                | Administrator Username                                                        | `admin`                                            |
| `SOLR_ADMIN_PASSWORD`                | Administrator password                                                        | `bitnami`                                          |
| `SOLR_CLOUD_BOOTSTRAP`               | Indicates if this node is the one that performs the boostraping               | `no`                                               |
| `SOLR_CORE_CONF_DIR`                 | Solar CORE configuration directory                                            | `${SOLR_SERVER_DIR}/solr/configsets/_default/conf` |
| `SOLR_SSL_ENABLED`                   | Indicates if Solr starts with SSL enabled                                     | `no`                                               |
| `SOLR_SSL_CHECK_PEER_NAME`           | Indicates if Solr should check the peer names                                 | `false`                                            |
| `SOLR_ZK_MAX_RETRIES`                | Maximum retries when waiting for zookeeper configuration operations to finish | `5`                                                |
| `SOLR_ZK_SLEEP_TIME`                 | Sleep time when waiting for zookeeper configuration operations to finish      | `5`                                                |
| `SOLR_ZK_CHROOT`                     | ZooKeeper ZNode chroot where to store solr data. Default: /solr               | `/solr`                                            |
| `SOLR_ZK_HOSTS`                      | ZooKeeper nodes (comma-separated list of `host:port`\)                        | `nil`                                              |
| `SOLR_ZK_CONNECTION_ATTEMPT_TIMEOUT` | ZooKeeper connection attempt timeout in seconds                               | `10`                                               |

#### Read-only environment variables

| Name                   | Description                            | Value                                          |
|------------------------|----------------------------------------|------------------------------------------------|
| `BITNAMI_VOLUME_DIR`   | Directory where to mount volumes.      | `/bitnami`                                     |
| `SOLR_BASE_DIR`        | Solr installation directory.           | `${BITNAMI_ROOT_DIR}/solr`                     |
| `SOLR_JAVA_HOME`       | JAVA installation directory.           | `${BITNAMI_ROOT_DIR}/java`                     |
| `SOLR_BIN_DIR`         | Solr directory for binary executables. | `${SOLR_BASE_DIR}/bin`                         |
| `SOLR_TMP_DIR`         | Solr directory for temp files.         | `${SOLR_BASE_DIR}/tmp`                         |
| `SOLR_PID_DIR`         | Solr directory for PID files.          | `${SOLR_BASE_DIR}/tmp`                         |
| `SOLR_LOGS_DIR`        | Solr directory for logs files.         | `${SOLR_BASE_DIR}/logs`                        |
| `SOLR_SERVER_DIR`      | Solr directory for server files.       | `${SOLR_BASE_DIR}/server`                      |
| `SOLR_VOLUME_DIR`      | Solr persistence directory.            | `${BITNAMI_VOLUME_DIR}/solr`                   |
| `SOLR_DATA_TO_PERSIST` | Solr data to persist.                  | `server/solr`                                  |
| `SOLR_PID_FILE`        | Solr PID file                          | `${SOLR_PID_DIR}/solr-${SOLR_PORT_NUMBER}.pid` |
| `SOLR_DAEMON_USER`     | Solr system user                       | `solr`                                         |
| `SOLR_DAEMON_GROUP`    | Solr system group                      | `solr`                                         |

When you start the solr image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line.

#### Specifying Environment Variables using Docker Compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/solr/docker-compose.yml) file present in this repository:

```yaml
solr:
  ...
  environment:
    - SOLR_CORES=my_core
  ...
```

#### Specifying Environment Variables on the Docker command line

```console
docker run -d -e SOLR_CORES=my_core --name solr bitnami/solr:latest
```

### Using your Apache Solr Cores configuration files

In order to load your own configuration files, you will have to make them available to the container. You can do it mounting a [volume](https://docs.docker.com/engine/tutorials/dockervolumes/) in the desired location and setting the environment variable with the customized value (as it is pointed above, the default value is **data_driven_schema_configs**).

#### Using Docker Compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/solr/docker-compose.yml) file present in this repository:

```yaml
solr:
  ...
  environment:
    - SOLR_CORE_CONF_DIR=/container/path/to/your/confDir
  volumes:
    - '/local/path/to/your/confDir:/container/path/to/your/confDir'
  ...
```

## Logging

The Bitnami solr Docker image sends the container logs to the `stdout`. To view the logs:

```console
docker logs solr
```

or using Docker Compose:

```console
docker-compose logs solr
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of solr, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/solr:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/solr:latest`.

#### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
docker stop solr
```

or using Docker Compose:

```console
docker-compose stop solr
```

Next, take a snapshot of the persistent volume `/path/to/solr-persistence` using:

```console
rsync -a /path/to/solr-persistence /path/to/solr-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

You can use this snapshot to restore the database state should the upgrade fail.

#### Step 3: Remove the currently running container

```console
docker rm -v solr
```

or using Docker Compose:

```console
docker-compose rm -v solr
```

#### Step 4: Run the new image

Re-create your container from the new image, restoring your backup if necessary.

```console
docker run --name solr bitnami/solr:latest
```

or using Docker Compose:

```console
docker-compose up solr
```

## Notable Changes

### 8.11.3-debian-12-r2 and 9.5.0-debian-12-r7

* Remove HDFS modules due to CVEs

### 8.8.0-debian-10-r11

* Adds SSL support.

### 8.8.0-debian-10-r9

* The Solr container initialization logic has been moved to Bash scripts.
* The size of the container image has been decreased.
* Added the support for cloud mode.
* Added support for authentication and admin user creation.
* Data migration for the upgrades. If you are running an older version of this container, run this version as user `root` and it will migrate your current data.

### 7.4.0-r23

* The Solr container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the Solr daemon was started as the `solr` user. From now on, both the container and the Solr daemon run as user `1001`. As a consequence, the data directory must be writable by that user. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/solr).

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
