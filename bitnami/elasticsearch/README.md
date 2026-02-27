# Bitnami Elasticsearch Stack

> Elasticsearch is a distributed search and analytics engine. It is used for web search, log monitoring, and real-time analytics. Ideal for Big Data applications.

[Overview of Elasticsearch](https://www.elastic.co/products/elasticsearch)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## <a id="tl-dr"></a> TL;DR

```console
docker run --name elasticsearch bitnami/elasticsearch:latest
```

You can find the available configuration options in the [Environment Variables](#environment-variables) section.

## <a id="why-use-bitnami-secure-images"></a> Why use Bitnami Secure Images?

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

## <a id="how-to-deploy-in-kubernetes"></a> How to deploy Elasticsearch in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Elasticsearch Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/elasticsearch).

## <a id="why-non-root"></a> Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## <a id="supported-tags"></a> Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

## <a id="get-this-image"></a> Get this image

The recommended way to get the Bitnami Elasticsearch Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/elasticsearch).

```console
docker pull bitnami/elasticsearch:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/elasticsearch/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/elasticsearch:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## <a id="using-`docker-compose.yaml`"></a> Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/elasticsearch).

## <a id="persisting-your-application"></a> Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the application will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami` path. If the mounted directory is empty, it will be initialized on the first run.

> **NOTE** As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

It is also possible to use multiple volumes for data persistence by using the `ELASTICSEARCH_DATA_DIR_LIST` environment variable:

```yaml
elasticsearch:
  ...
  volumes:
    - /path/to/elasticsearch-data-persistence-1:/elasticsearch/data-1
    - /path/to/elasticsearch-data-persistence-2:/elasticsearch/data-2
  environment:
    - ELASTICSEARCH_DATA_DIR_LIST=/elasticsearch/data-1,/elasticsearch/data-2
  ...
```

## <a id="connecting-to-other-containers"></a> Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), an Elasticsearch server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## <a id="configuration"></a> Configuration

The following section describes the supported environment variables

### <a id="environment-variables"></a> Environment variables

The following tables list the main variables you can set.

#### Customizable environment variables

| Name                                              | Description                                                                                                            | Default Value                                  |
|---------------------------------------------------|------------------------------------------------------------------------------------------------------------------------|------------------------------------------------|
| `ELASTICSEARCH_CERTS_DIR`                         | Path to certificates folder.                                                                                           | `${DB_CONF_DIR}/certs`                         |
| `ELASTICSEARCH_DATA_DIR_LIST`                     | Comma, semi-colon or space separated list of directories to use for data storage                                       | `nil`                                          |
| `ELASTICSEARCH_BIND_ADDRESS`                      | Elasticsearch bind address                                                                                             | `nil`                                          |
| `ELASTICSEARCH_ADVERTISED_HOSTNAME`               | Elasticsearch advertised hostname, used for publish                                                                    | `nil`                                          |
| `ELASTICSEARCH_CLUSTER_HOSTS`                     | Elasticsearch cluster hosts                                                                                            | `nil`                                          |
| `ELASTICSEARCH_CLUSTER_MASTER_HOSTS`              | Elasticsearch cluster master hosts                                                                                     | `nil`                                          |
| `ELASTICSEARCH_CLUSTER_NAME`                      | Elasticsearch cluster name                                                                                             | `nil`                                          |
| `ELASTICSEARCH_HEAP_SIZE`                         | Elasticsearch heap size                                                                                                | `1024m`                                        |
| `ELASTICSEARCH_MAX_ALLOWED_MEMORY_PERCENTAGE`     | Elasticsearch maximum allowed memory percentage                                                                        | `100`                                          |
| `ELASTICSEARCH_MAX_ALLOWED_MEMORY`                | Elasticsearch maximum allowed memory amount (in megabytes)                                                             | `nil`                                          |
| `ELASTICSEARCH_MAX_TIMEOUT`                       | Elasticsearch maximum init timeout                                                                                     | `60`                                           |
| `ELASTICSEARCH_LOCK_ALL_MEMORY`                   | Sets bootstrap.memory_lock parameter                                                                                   | `no`                                           |
| `ELASTICSEARCH_DISABLE_JVM_HEAP_DUMP`             | Disable JVM Heap dump                                                                                                  | `no`                                           |
| `ELASTICSEARCH_DISABLE_GC_LOGS`                   | Disable GC logs                                                                                                        | `no`                                           |
| `ELASTICSEARCH_IS_DEDICATED_NODE`                 | If false, Elasticsearch will be configured with all the roles, deploy as dedicated node using DB_NODE_ROLES.           | `no`                                           |
| `ELASTICSEARCH_MINIMUM_MASTER_NODES`              | Minimum number of master nodes                                                                                         | `nil`                                          |
| `ELASTICSEARCH_NODE_NAME`                         | Elasticsearch node name                                                                                                | `nil`                                          |
| `ELASTICSEARCH_FS_SNAPSHOT_REPO_PATH`             | Elasticsearch repo path to restore snapshots from system repository                                                    | `nil`                                          |
| `ELASTICSEARCH_NODE_ROLES`                        | Comma-separated list of Elasticsearch roles. If empty, will be deployed as a coordinating-only node.                   | `nil`                                          |
| `ELASTICSEARCH_PLUGINS`                           | List of Elasticsearch plugins to activate                                                                              | `nil`                                          |
| `ELASTICSEARCH_TRANSPORT_PORT_NUMBER`             | Elasticsearch node port number                                                                                         | `9300`                                         |
| `ELASTICSEARCH_HTTP_PORT_NUMBER`                  | Elasticsearch port                                                                                                     | `9200`                                         |
| `ELASTICSEARCH_ACTION_DESTRUCTIVE_REQUIRES_NAME`  | Enable action destructive requires name                                                                                | `nil`                                          |
| `ELASTICSEARCH_ENABLE_SECURITY`                   | Enable Elasticsearch security settings.                                                                                | `false`                                        |
| `ELASTICSEARCH_PASSWORD`                          | Password for "elastic" user.                                                                                           | `bitnami`                                      |
| `ELASTICSEARCH_TLS_VERIFICATION_MODE`             | Elasticsearch TLS verification mode in transport layer.                                                                | `full`                                         |
| `ELASTICSEARCH_TLS_USE_PEM`                       | Configure Security settings using PEM certificates.                                                                    | `false`                                        |
| `ELASTICSEARCH_KEYSTORE_PASSWORD`                 | Password for the Elasticsearch keystore containing the certificates or password-protected PEM key.                     | `nil`                                          |
| `ELASTICSEARCH_TRUSTSTORE_PASSWORD`               | Password for the Elasticsearch truststore.                                                                             | `nil`                                          |
| `ELASTICSEARCH_KEY_PASSWORD`                      | Password for the Elasticsearch node PEM key.                                                                           | `nil`                                          |
| `ELASTICSEARCH_KEYSTORE_LOCATION`                 | Path to Keystore                                                                                                       | `${DB_CERTS_DIR}/elasticsearch.keystore.jks`   |
| `ELASTICSEARCH_TRUSTSTORE_LOCATION`               | Path to Truststore.                                                                                                    | `${DB_CERTS_DIR}/elasticsearch.truststore.jks` |
| `ELASTICSEARCH_NODE_CERT_LOCATION`                | Path to PEM node certificate.                                                                                          | `${DB_CERTS_DIR}/tls.crt`                      |
| `ELASTICSEARCH_NODE_KEY_LOCATION`                 | Path to PEM node key.                                                                                                  | `${DB_CERTS_DIR}/tls.key`                      |
| `ELASTICSEARCH_CA_CERT_LOCATION`                  | Path to CA certificate.                                                                                                | `${DB_CERTS_DIR}/ca.crt`                       |
| `ELASTICSEARCH_SKIP_TRANSPORT_TLS`                | Skips transport layer TLS configuration. Useful when deploying single-node clusters.                                   | `false`                                        |
| `ELASTICSEARCH_TRANSPORT_TLS_USE_PEM`             | Configure transport layer TLS settings using PEM certificates.                                                         | `$DB_TLS_USE_PEM`                              |
| `ELASTICSEARCH_TRANSPORT_TLS_KEYSTORE_PASSWORD`   | Password for the Elasticsearch transport layer TLS keystore containing the certificates or password-protected PEM key. | `$DB_KEYSTORE_PASSWORD`                        |
| `ELASTICSEARCH_TRANSPORT_TLS_TRUSTSTORE_PASSWORD` | Password for the Elasticsearch transport layer TLS truststore.                                                         | `$DB_TRUSTSTORE_PASSWORD`                      |
| `ELASTICSEARCH_TRANSPORT_TLS_KEY_PASSWORD`        | Password for the Elasticsearch transport layer TLS node PEM key.                                                       | `$DB_KEY_PASSWORD`                             |
| `ELASTICSEARCH_TRANSPORT_TLS_KEYSTORE_LOCATION`   | Path to Keystore for transport layer TLS.                                                                              | `$DB_KEYSTORE_LOCATION`                        |
| `ELASTICSEARCH_TRANSPORT_TLS_TRUSTSTORE_LOCATION` | Path to Truststore for transport layer TLS.                                                                            | `$DB_TRUSTSTORE_LOCATION`                      |
| `ELASTICSEARCH_TRANSPORT_TLS_NODE_CERT_LOCATION`  | Path to PEM node certificate for transport layer TLS.                                                                  | `$DB_NODE_CERT_LOCATION`                       |
| `ELASTICSEARCH_TRANSPORT_TLS_NODE_KEY_LOCATION`   | Path to PEM node key for transport layer TLS.                                                                          | `$DB_NODE_KEY_LOCATION`                        |
| `ELASTICSEARCH_TRANSPORT_TLS_CA_CERT_LOCATION`    | Path to CA certificate for transport layer TLS.                                                                        | `$DB_CA_CERT_LOCATION`                         |
| `ELASTICSEARCH_ENABLE_REST_TLS`                   | Enable TLS encryption for REST API communications.                                                                     | `true`                                         |
| `ELASTICSEARCH_HTTP_TLS_USE_PEM`                  | Configure HTTP TLS settings using PEM certificates.                                                                    | `$DB_TLS_USE_PEM`                              |
| `ELASTICSEARCH_HTTP_TLS_KEYSTORE_PASSWORD`        | Password for the Elasticsearch HTTP TLS keystore containing the certificates or password-protected PEM key.            | `$DB_KEYSTORE_PASSWORD`                        |
| `ELASTICSEARCH_HTTP_TLS_TRUSTSTORE_PASSWORD`      | Password for the Elasticsearch HTTP TLS truststore.                                                                    | `$DB_TRUSTSTORE_PASSWORD`                      |
| `ELASTICSEARCH_HTTP_TLS_KEY_PASSWORD`             | Password for the Elasticsearch HTTP TLS node PEM key.                                                                  | `$DB_KEY_PASSWORD`                             |
| `ELASTICSEARCH_HTTP_TLS_KEYSTORE_LOCATION`        | Path to Keystore for HTTP TLS.                                                                                         | `$DB_KEYSTORE_LOCATION`                        |
| `ELASTICSEARCH_HTTP_TLS_TRUSTSTORE_LOCATION`      | Path to Truststore for HTTP TLS.                                                                                       | `$DB_TRUSTSTORE_LOCATION`                      |
| `ELASTICSEARCH_HTTP_TLS_NODE_CERT_LOCATION`       | Path to PEM node certificate for HTTP TLS.                                                                             | `$DB_NODE_CERT_LOCATION`                       |
| `ELASTICSEARCH_HTTP_TLS_NODE_KEY_LOCATION`        | Path to PEM node key for HTTP TLS.                                                                                     | `$DB_NODE_KEY_LOCATION`                        |
| `ELASTICSEARCH_HTTP_TLS_CA_CERT_LOCATION`         | Path to CA certificate for HTTP TLS.                                                                                   | `$DB_CA_CERT_LOCATION`                         |
| `ELASTICSEARCH_ENABLE_FIPS_MODE`                  | Enables FIPS mode of operation                                                                                         | `false`                                        |
| `ELASTICSEARCH_PASSWD_HASH_ALGORITHM`             | Password hashing algorithm                                                                                             | `nil`                                          |
| `ELASTICSEARCH_KEYS`                              | Comma-separated list of key=value to be added to the Elasticsearch keystore                                            | `nil`                                          |
| `ES_JAVA_HOME`                                    | Elasticsearch supported Java installation folder.                                                                      | `${JAVA_HOME}`                                 |

#### Read-only environment variables

| Name                                | Description                                                     | Value                                       |
|-------------------------------------|-----------------------------------------------------------------|---------------------------------------------|
| `DB_FLAVOR`                         | Database flavor. Valid values: `elasticsearch` or `opensearch`. | `elasticsearch`                             |
| `ELASTICSEARCH_VOLUME_DIR`          | Persistence base directory                                      | `/bitnami/elasticsearch`                    |
| `ELASTICSEARCH_BASE_DIR`            | Elasticsearch installation directory                            | `/opt/bitnami/elasticsearch`                |
| `ELASTICSEARCH_CONF_DIR`            | Elasticsearch configuration directory                           | `${DB_BASE_DIR}/config`                     |
| `ELASTICSEARCH_DEFAULT_CONF_DIR`    | Elasticsearch default configuration directory                   | `${DB_BASE_DIR}/config.default`             |
| `ELASTICSEARCH_LOGS_DIR`            | Elasticsearch logs directory                                    | `${DB_BASE_DIR}/logs`                       |
| `ELASTICSEARCH_PLUGINS_DIR`         | Elasticsearch plugins directory                                 | `${DB_BASE_DIR}/plugins`                    |
| `ELASTICSEARCH_DEFAULT_PLUGINS_DIR` | Elasticsearch default plugins directory                         | `${DB_BASE_DIR}/plugins.default`            |
| `ELASTICSEARCH_DATA_DIR`            | Elasticsearch data directory                                    | `${DB_VOLUME_DIR}/data`                     |
| `ELASTICSEARCH_TMP_DIR`             | Elasticsearch temporary directory                               | `${DB_BASE_DIR}/tmp`                        |
| `ELASTICSEARCH_BIN_DIR`             | Elasticsearch executables directory                             | `${DB_BASE_DIR}/bin`                        |
| `ELASTICSEARCH_MOUNTED_PLUGINS_DIR` | Directory where plugins are mounted                             | `${DB_VOLUME_DIR}/plugins`                  |
| `ELASTICSEARCH_CONF_FILE`           | Path to Elasticsearch configuration file                        | `${DB_CONF_DIR}/elasticsearch.yml`          |
| `ELASTICSEARCH_LOG_FILE`            | Path to the Elasticsearch log file                              | `${DB_LOGS_DIR}/elasticsearch.log`          |
| `ELASTICSEARCH_PID_FILE`            | Path to the Elasticsearch pid file                              | `${DB_TMP_DIR}/elasticsearch.pid`           |
| `ELASTICSEARCH_INITSCRIPTS_DIR`     | Path to the Elasticsearch container init scripts directory      | `/docker-entrypoint-initdb.d`               |
| `ELASTICSEARCH_DAEMON_USER`         | Elasticsearch system user                                       | `elasticsearch`                             |
| `ELASTICSEARCH_DAEMON_GROUP`        | Elasticsearch system group                                      | `elasticsearch`                             |
| `ELASTICSEARCH_USERNAME`            | Username of the Elasticsearch superuser.                        | `elastic`                                   |
| `JAVA_HOME`                         | Java installation folder.                                       | `${BITNAMI_ROOT_DIR}/java`                  |
| `ES_JAVA_OPTS`                      | Elasticsearch supported Java options.                           | `${ES_JAVA_OPTS:-} ${JAVA_TOOL_OPTIONS:-}`  |
| `CLI_JAVA_OPTS`                     | Elasticsearch CLI supported Java options.                       | `${CLI_JAVA_OPTS:-} ${JAVA_TOOL_OPTIONS:-}` |

When you start the elasticsearch image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line.

### <a id="configuration-file"></a> Configuration file

In order to use a custom configuration file instead of the default one provided out of the box, you can create a file named `elasticsearch.yml` and mount it at `/opt/bitnami/elasticsearch/config/elasticsearch.yml` to overwrite the default configuration.

Please, note that the whole configuration file will be replaced by the provided, default one; ensure that the syntax and fields you provide are properly set and exhaustive.

If you would rather extend than replace the default configuration with your settings, mount your custom configuration file at `/opt/bitnami/elasticsearch/config/my_elasticsearch.yml`.

### <a id="plugins"></a> Plugins

The Bitnami Elasticsearch Docker image comes with the [S3 Repository plugin](https://www.elastic.co/guide/en/elasticsearch/plugins/current/repository-s3.html) installed by default.

You can add extra plugins by setting the `ELASTICSEARCH_PLUGINS` environment variable. To specify multiple plugins, separate them by spaces, commas or semicolons. When the container is initialized it will install all of the specified plugins before starting Elasticsearch.

The Bitnami Elasticsearch Docker image will also install plugin `.zip` files mounted at the `/bitnami/elasticsearch/plugins` directory inside the container, making it possible to install them from disk without requiring Internet access.

#### Adding plugins at build time (persisting plugins)

The Bitnami Elasticsearch image provides a way to create your custom image installing plugins on build time. This is the preferred way to persist plugins when using ElasticSearch, as they will not be installed every time the container is started but just once at build time.

To create your own image providing plugins execute the following command. Remember to replace the `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/elasticsearch/VERSION/OPERATING-SYSTEM
docker build --build-arg ELASTICSEARCH_PLUGINS=<plugin1,plugin2,...> -t bitnami/elasticsearch:latest .
```

The command above will build the image providing this GitHub repository as build context, and will pass the list of plugins to install to the build logic.

### <a id="initializing-a-new-instance"></a> Initializing a new instance

When the container is executed for the first time, it will execute the files with extension `.sh` located at `/docker-entrypoint-initdb.d`.

In order to have your custom files inside the Docker image, you can mount them as a volume.

### <a id="fips-configuration"></a> FIPS configuration in Bitnami Secure Images

The Bitnami Elasticsearch Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## <a id="logging"></a> Logging

The Bitnami Elasticsearch Docker image sends the container logs to the `stdout`. To view the logs:

```console
docker logs elasticsearch
```

or using Docker Compose:

```console
docker-compose logs elasticsearch
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

Additionally, in case you'd like to modify Elasticsearch logging configuration, it can be done by overwriting the file `/opt/bitnami/elasticsearch/config/log4j2.properties`.
The syntax of this file can be found in Elasticsearch [logging documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/logging.html).

## <a id="notable-changes"></a> Notable Changes

### 7.12.0-debian-10-r0

- Elasticsearch 7.12.0 version or later are licensed under the Elastic License that is not currently accepted as an Open Source license by the Open Source Initiative (OSI).
- Elasticsearch 7.12.0 version or later are including x-pack plugin installed by default. Follow the official documentation to use it.

### 6.8.5-debian-9-r0, 6.8.5-ol-7-r1, 7.4.2-debian-9-r10, 7.4.2-ol-7-r27

- Arbitrary user ID(s) when running the container with a non-privileged user is not supported (only `1001` UID is allowed).
- This is temporary solution while Elasticsearch maintainers address an issue with ownership/permissions when installing plugins.

### 6.8.2-debian-9-r36, 6.8.2-ol-7-r36, 7.3.1-debian-9-r8, 7.3.1-ol-7-r13

- Updated OpenJDK to version 11

### 6.6.1-debian-9-r12, 6.6.1-ol-7-r13, 6.6.1-rhel-7-r13, 5.6.15-debian-9-r12 and 5.6.15-ol-7-r13

- Deprecate the use of `elasticsearch_custom.yml` in favor of replacing the whole `elasticsearch.yml` file.

### 6.4.0-debian-9-r19, 6.4.0-ol-7-r18, 5.6.4-debian-9-r54, and 5.6.4-ol-7-r60

- Decrease the size of the container. It is not necessary Node.js anymore. Elasticsearch configuration moved to bash scripts in the `rootfs/` folder.
- The recommended mount point to persist data changes to `/bitnami/elasticsearch/data`.
- The Elasticsearch configuration files are not persisted in a volume anymore. Now, they can be found at `/opt/bitnami/elasticsearch/config`.
- Elasticsearch `plugins` and `modules` are not persisted anymore. It's necessary to indicate what plugins to install using the env. variable `ELASTICSEARCH_PLUGINS`
- Backwards compatibility is not guaranteed when data is persisted using docker-compose. You can use the workaround below to overcome it:

```console
$ docker-compose down
# Change the mount point
sed -i -e 's#elasticsearch_data:/bitnami#elasticsearch_data:/bitnami/elasticsearch/data#g' docker-compose.yml
# Pull the latest bitnami/elasticsearch image
$ docker pull bitnami/elasticsearch:latest
$ docker-compose up -d
```

### 6.2.3-r7 & 5.6.4-r18

- The Elasticsearch container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the Elasticsearch daemon was started as the `elasticsearch` user. From now on, both the container and the Elasticsearch daemon run as user `1001`. As a consequence, the data directory must be writable by that user. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

### 6.2.3-r2 & 5.6.4-r6

- Elasticsearch container can be configured as a dedicated node with 4 different types: *master*, *data*, *coordinating* or *ingest*.
  Previously it was only achievable by using a custom `elasticsearch_custom.yml` file. From now on, you can use the environment variables `ELASTICSEARCH_IS_DEDICATED_NODE` & `ELASTICSEARCH_NODE_TYPE` to configure it.

## <a id="license"></a> License

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
