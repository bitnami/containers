# Bitnami Secure Image for Neo4j

> Neo4j is a high performance graph store with all the features expected of a mature and robust database, like a friendly query language and ACID transactions.

[Overview of Neo4j](https://www.neo4j.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

Use this quick command to run the container.

```console
docker run --name neo4j bitnami/neo4j:latest
```

You can find the default credentials and available configuration options in the [Environment Variables](#environment-variables) section.

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

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes.

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. The above examples define a docker volume namely `neo4j_data`. The Neo4j application state will persist as long as this volume is not removed.

To avoid inadvertent removal of this volume you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

> **NOTE** As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the host name.

## Configuration

The following sections describe environment variables and related settings.

### Environment variables

The following tables list the main variables you can set.

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

### Using your Neo4j configuration files

In order to load your own configuration files, you will have to make them available to the container. You can do it mounting a [volume](https://docs.docker.com/engine/tutorials/dockervolumes/) in `/bitnami/neo4j/conf`.

### Adding extra Neo4j plugins

In order to add extra plugins, you will have to make them available to the container. You can do it mounting a [volume](https://docs.docker.com/engine/tutorials/dockervolumes/) in `/bitnami/neo4j/plugins`.

### FIPS configuration in Bitnami Secure Images

The Bitnami Neo4j Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.
- `JAVA_TOOL_OPTIONS`: controls Java FIPS mode. Use `-Djava.security.properties==/opt/bitnami/java/conf/security/java.security.restricted` (restricted), `-Djava.security.properties==/opt/bitnami/java/conf/security/java.security.relaxed` (relaxed), or `-Djava.security.properties==/opt/bitnami/java/conf/security/java.security.original` (off).

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

## Notable changes

The following subsections describe notable changes.

### 4.3.0-debian-10-r17

- Decrease the size of the container. The configuration logic is now based on Bash scripts in the `rootfs/` folder. In addition to this, the container now has the latest stable version of the [`apoc` library](https://github.com/neo4j-contrib/neo4j-apoc-procedures) enabled by default.

- Now the configuration file is not persisted, so it is recommended to remove the persisted file in `/bitnami/neo4j/conf/` to avoid potential upgrade issues.

### 3.4.3-r13

- The Neo4j container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the Neo4j daemon was started as the `neo4j` user. From now on, both the container and the Neo4j daemon run as user `1001`. As a consequence, the data directory must be writable by that user. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

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
