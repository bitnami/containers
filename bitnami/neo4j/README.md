# Bitnami package for Neo4j

## What is Neo4j?

> Neo4j is a high performance graph store with all the features expected of a mature and robust database, like a friendly query language and ACID transactions.

[Overview of Neo4j](http://www.neo4j.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name neo4j bitnami/neo4j:latest
```

You can find the default credentials and available configuration options in the [Environment Variables](#environment-variables) section.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Neo4j in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami Neo4j Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/neo4j).

```console
docker pull bitnami/neo4j:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/neo4j/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/neo4j:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. The above examples define a docker volume namely `neo4j_data`. The Neo4j application state will persist as long as this volume is not removed.

To avoid inadvertent removal of this volume you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

```console
docker run -v /path/to/neo4j-persistence:/bitnami bitnami/neo4j:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/neo4j/docker-compose.yml) file present in this repository:

```yaml
neo4j:
  ...
  volumes:
    - /path/to/neo4j-persistence:/bitnami
  ...
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

#### Step 1: Create a network

```console
docker network create neo4j-network --driver bridge
```

#### Step 2: Launch the Neo4j container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `neo4j-network` network.

```console
docker run --name neo4j-node1 --network neo4j-network bitnami/neo4j:latest
```

#### Step 3: Run another containers

We can launch another containers using the same flag (`--network NETWORK`) in the `docker run` command. If you also set a name to your container, you will be able to use it as hostname in your network.

### Using a Docker Compose file

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new bridge network named neo4j-network.

```yaml
version: '2'

networks:
  neo4j-network:
    driver: bridge

services:
  neo4j:
    image: bitnami/neo4j:latest
    networks:
      - neo4j-network
    ports:
      - '7474:7474'
      - '7473:7473'
      - '7687:7687'
```

Then, launch the containers using:

```console
docker-compose up -d
```

## Configuration

### Environment variables

#### Customizable environment variables

| Name                                      | Description                                                                                                                                   | Default Value              |
|-------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------|----------------------------|
| `NEO4J_HOST`                              | Hostname used to configure Neo4j advertised address. It can be either an IP or a domain. If left empty, it will be resolved to the machine IP | `nil`                      |
| `NEO4J_BIND_ADDRESS`                      | Neo4j bind address                                                                                                                            | `0.0.0.0`                  |
| `NEO4J_ALLOW_UPGRADE`                     | Allow automatic schema upgrades                                                                                                               | `true`                     |
| `NEO4J_PASSWORD`                          | Neo4j password.                                                                                                                               | `bitnami1`                 |
| `NEO4J_APOC_IMPORT_FILE_ENABLED`          | Allow importing files using the apoc library                                                                                                  | `true`                     |
| `NEO4J_APOC_IMPORT_FILE_USE_NEO4J_CONFIG` | Use neo4j configuration with the apoc library                                                                                                 | `false`                    |
| `NEO4J_BOLT_PORT_NUMBER`                  | Port used for the bolt protocol.                                                                                                              | `7687`                     |
| `NEO4J_HTTP_PORT_NUMBER`                  | Port used for the http protocol.                                                                                                              | `7474`                     |
| `NEO4J_HTTPS_PORT_NUMBER`                 | Port used for the https protocol.                                                                                                             | `7473`                     |
| `NEO4J_BOLT_ADVERTISED_PORT_NUMBER`       | Advertised port for the bolt protocol.                                                                                                        | `$NEO4J_BOLT_PORT_NUMBER`  |
| `NEO4J_HTTP_ADVERTISED_PORT_NUMBER`       | Advertised port for the http protocol.                                                                                                        | `$NEO4J_HTTP_PORT_NUMBER`  |
| `NEO4J_HTTPS_ADVERTISED_PORT_NUMBER`      | Advertised port for the https protocol.                                                                                                       | `$NEO4J_HTTPS_PORT_NUMBER` |
| `NEO4J_HTTPS_ENABLED`                     | Enables the HTTPS connector.                                                                                                                  | `false`                    |
| `NEO4J_BOLT_TLS_LEVEL`                    | The encryption level to be used to secure communications with Bolt connector. Allowed values: REQUIRED, OPTIONAL, DISABLED                    | `DISABLED`                 |

#### Read-only environment variables

| Name                        | Description                                      | Value                              |
|-----------------------------|--------------------------------------------------|------------------------------------|
| `NEO4J_BASE_DIR`            | Neo4j installation directory.                    | `${BITNAMI_ROOT_DIR}/neo4j`        |
| `NEO4J_VOLUME_DIR`          | Neo4j volume directory.                          | `/bitnami/neo4j`                   |
| `NEO4J_DATA_DIR`            | Neo4j volume directory.                          | `$NEO4J_VOLUME_DIR/data`           |
| `NEO4J_RUN_DIR`             | Neo4j temp directory.                            | `${NEO4J_BASE_DIR}/run`            |
| `NEO4J_LOGS_DIR`            | Neo4j logs directory.                            | `${NEO4J_BASE_DIR}/logs`           |
| `NEO4J_LOG_FILE`            | Neo4j log file.                                  | `${NEO4J_LOGS_DIR}/neo4j.log`      |
| `NEO4J_PID_FILE`            | Neo4j PID file.                                  | `${NEO4J_RUN_DIR}/neo4j.pid`       |
| `NEO4J_CONF_DIR`            | Configuration dir for Neo4j.                     | `${NEO4J_BASE_DIR}/conf`           |
| `NEO4J_DEFAULT_CONF_DIR`    | Neo4j default configuration directory.           | `${NEO4J_BASE_DIR}/conf.default`   |
| `NEO4J_PLUGINS_DIR`         | Plugins dir for Neo4j.                           | `${NEO4J_BASE_DIR}/plugins`        |
| `NEO4J_METRICS_DIR`         | Metrics dir for Neo4j.                           | `${NEO4J_VOLUME_DIR}/metrics`      |
| `NEO4J_CERTIFICATES_DIR`    | Certificates dir for Neo4j.                      | `${NEO4J_VOLUME_DIR}/certificates` |
| `NEO4J_IMPORT_DIR`          | Import dir for Neo4j.                            | `${NEO4J_VOLUME_DIR}/import`       |
| `NEO4J_MOUNTED_CONF_DIR`    | Mounted Configuration dir for Neo4j.             | `${NEO4J_VOLUME_DIR}/conf/`        |
| `NEO4J_MOUNTED_PLUGINS_DIR` | Mounted Plugins dir for Neo4j.                   | `${NEO4J_VOLUME_DIR}/plugins/`     |
| `NEO4J_INITSCRIPTS_DIR`     | Path to neo4j init scripts directory             | `/docker-entrypoint-initdb.d`      |
| `NEO4J_CONF_FILE`           | Configuration file for Neo4j.                    | `${NEO4J_CONF_DIR}/neo4j.conf`     |
| `NEO4J_APOC_CONF_FILE`      | Configuration file for Neo4j.                    | `${NEO4J_CONF_DIR}/apoc.conf`      |
| `NEO4J_VOLUME_DIR`          | Neo4j directory for mounted configuration files. | `${BITNAMI_VOLUME_DIR}/neo4j`      |
| `NEO4J_DATA_TO_PERSIST`     | Neo4j data to persist.                           | `data`                             |
| `NEO4J_DAEMON_USER`         | Neo4j system user.                               | `neo4j`                            |
| `NEO4J_DAEMON_GROUP`        | Neo4j system group.                              | `neo4j`                            |
| `JAVA_HOME`                 | Java installation folder.                        | `${BITNAMI_ROOT_DIR}/java`         |

When you start the neo4j image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line.

#### Specifying Environment Variables using Docker Compose

Modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/neo4j/docker-compose.yml) file present in this repository:

```yaml
neo4j:
  ...
  environment:
    - NEO4J_BOLT_PORT_NUMBER=7777
  ...
```

#### Specifying Environment Variables on the Docker command line

```console
docker run -d -e NEO4J_BOLT_PORT_NUMBER=7777 --name neo4j bitnami/neo4j:latest
```

### Using your Neo4j configuration files

In order to load your own configuration files, you will have to make them available to the container. You can do it mounting a [volume](https://docs.docker.com/engine/tutorials/dockervolumes/) in `/bitnami/neo4j/conf`.

#### Using Docker Compose

Modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/neo4j/docker-compose.yml) file present in this repository:

```yaml
neo4j:
  ...
  volumes:
    - '/local/path/to/your/confDir:/bitnami/neo4j/conf'
  ...
```

### Adding extra Neo4j plugins

In order to add extra plugins, you will have to make them available to the container. You can do it mounting a [volume](https://docs.docker.com/engine/tutorials/dockervolumes/) in `/bitnami/neo4j/plugins`.

#### Using Docker Compose to add plugins

Modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/neo4j/docker-compose.yml) file present in this repository:

```yaml
neo4j:
  ...
  volumes:
    - '/local/path/to/your/plugins:/bitnami/neo4j/plugins'
  ...
```

## Logging

The Bitnami neo4j Docker image sends the container logs to the `stdout`. To view the logs:

```console
docker logs neo4j
```

or using Docker Compose:

```console
docker-compose logs neo4j
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of neo4j, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/neo4j:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/neo4j:latest`.

#### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
docker stop neo4j
```

or using Docker Compose:

```console
docker-compose stop neo4j
```

Next, take a snapshot of the persistent volume `/path/to/neo4j-persistence` using:

```console
rsync -a /path/to/neo4j-persistence /path/to/neo4j-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

You can use this snapshot to restore the database state should the upgrade fail.

#### Step 3: Remove the currently running container

```console
docker rm -v neo4j
```

or using Docker Compose:

```console
docker-compose rm -v neo4j
```

#### Step 4: Run the new image

Re-create your container from the new image, restoring your backup if necessary.

```console
docker run --name neo4j bitnami/neo4j:latest
```

or using Docker Compose:

```console
docker-compose up neo4j
```

## Notable Changes

### 4.3.0-debian-10-r17

* Decrease the size of the container. The configuration logic is now based on Bash scripts in the `rootfs/` folder. In addition to this, the container now has the latest stable version of the [apoc library](https://github.com/neo4j-contrib/neo4j-apoc-procedures) enabled by default.

* Now the configuration file is not persisted, so it is recommended to remove the persisted file in `/bitnami/neo4j/conf/` to avoid potential upgrade issues.

### 3.4.3-r13

* The Neo4j container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the Neo4j daemon was started as the `neo4j` user. From now on, both the container and the Neo4j daemon run as user `1001`. As a consequence, the data directory must be writable by that user. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes.

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
