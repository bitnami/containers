# Bitnami Secure Image for OpenSearch

> OpenSearch is a scalable open-source solution for search, analytics, and observability. Features full-text queries, natural language processing, custom dictionaries, amongst others.

[Overview of OpenSearch](https://opensearch.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name opensearch bitnami/opensearch:latest
```

## Using `docker-compose.yml`

The docker-compose.yaml file of this container can be found in the [Bitnami Containers repository](https://github.com/bitnami/containers/).

[https://github.com/bitnami/containers/tree/main/bitnami/opensearch/docker-compose.yml](https://github.com/bitnami/containers/tree/main/bitnami/opensearch/docker-compose.yml)

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/opensearch).

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

## How to deploy OpenSearch in Kubernetes

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami OpenSearch Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/opensearch).

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

## Get this image

The Bitnami OpenSearch Docker image is only available to [Bitnami Secure Images](https://bitnami.com) customers.

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the application will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami` path. If the mounted directory is empty, it will be initialized on the first run.

> **NOTE** As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

It is also possible to use multiple volumes for data persistence by using the `OPENSEARCH_DATA_DIR_LIST` environment variable:

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), an OpenSearch server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the host name.

## Configuration

The following sections describe environment variables and related settings.

### Environment variables

The following tables list the main variables you can set.

#### Customizable environment variables

| Name                                           | Description                                                                                                         | Default Value                               |
|------------------------------------------------|---------------------------------------------------------------------------------------------------------------------|---------------------------------------------|
| `OPENSEARCH_CERTS_DIR`                         | Path to certificates folder.                                                                                        | `${DB_CONF_DIR}/certs`                      |
| `OPENSEARCH_DATA_DIR_LIST`                     | Comma, semi-colon or space separated list of directories to use for data storage                                    | `nil`                                       |
| `OPENSEARCH_BIND_ADDRESS`                      | Opensearch bind address                                                                                             | `nil`                                       |
| `OPENSEARCH_ADVERTISED_HOSTNAME`               | Opensearch advertised hostname, used for publish                                                                    | `nil`                                       |
| `OPENSEARCH_CLUSTER_HOSTS`                     | Opensearch cluster hosts                                                                                            | `nil`                                       |
| `OPENSEARCH_CLUSTER_MASTER_HOSTS`              | Opensearch cluster master hosts                                                                                     | `nil`                                       |
| `OPENSEARCH_CLUSTER_NAME`                      | Opensearch cluster name                                                                                             | `nil`                                       |
| `OPENSEARCH_HEAP_SIZE`                         | Opensearch heap size                                                                                                | `1024m`                                     |
| `OPENSEARCH_MAX_ALLOWED_MEMORY_PERCENTAGE`     | Opensearch maximum allowed memory percentage                                                                        | `100`                                       |
| `OPENSEARCH_MAX_ALLOWED_MEMORY`                | Opensearch maximum allowed memory amount (in megabytes)                                                             | `nil`                                       |
| `OPENSEARCH_MAX_TIMEOUT`                       | Opensearch maximum init timeout                                                                                     | `60`                                        |
| `OPENSEARCH_LOCK_ALL_MEMORY`                   | Sets bootstrap.memory_lock parameter                                                                                | `no`                                        |
| `OPENSEARCH_DISABLE_JVM_HEAP_DUMP`             | Disable JVM Heap dump                                                                                               | `no`                                        |
| `OPENSEARCH_DISABLE_GC_LOGS`                   | Disable GC logs                                                                                                     | `no`                                        |
| `OPENSEARCH_IS_DEDICATED_NODE`                 | If false, Opensearch will be configured with all the roles, deploy as dedicated node using DB_NODE_ROLES.           | `no`                                        |
| `OPENSEARCH_MINIMUM_MASTER_NODES`              | Minimum number of master nodes                                                                                      | `nil`                                       |
| `OPENSEARCH_NODE_NAME`                         | Opensearch node name                                                                                                | `nil`                                       |
| `OPENSEARCH_FS_SNAPSHOT_REPO_PATH`             | Opensearch repo path to restore snapshots from system repository                                                    | `nil`                                       |
| `OPENSEARCH_NODE_ROLES`                        | Comma-separated list of Opensearch roles. If empty, will be deployed as a coordinating-only node.                   | `nil`                                       |
| `OPENSEARCH_PLUGINS`                           | List of Opensearch plugins to activate                                                                              | `nil`                                       |
| `OPENSEARCH_TRANSPORT_PORT_NUMBER`             | Opensearch node port number                                                                                         | `9300`                                      |
| `OPENSEARCH_HTTP_PORT_NUMBER`                  | Opensearch port                                                                                                     | `9200`                                      |
| `OPENSEARCH_ACTION_DESTRUCTIVE_REQUIRES_NAME`  | Enable action destructive requires name                                                                             | `nil`                                       |
| `OPENSEARCH_ENABLE_SECURITY`                   | Enable Opensearch security settings.                                                                                | `false`                                     |
| `OPENSEARCH_PASSWORD`                          | Password for "admin" user.                                                                                          | `bitnami`                                   |
| `OPENSEARCH_TLS_VERIFICATION_MODE`             | Opensearch TLS verification mode in transport layer.                                                                | `full`                                      |
| `OPENSEARCH_TLS_USE_PEM`                       | Configure Security settings using PEM certificates.                                                                 | `false`                                     |
| `OPENSEARCH_KEYSTORE_PASSWORD`                 | Password for the Opensearch keystore containing the certificates or password-protected PEM key.                     | `nil`                                       |
| `OPENSEARCH_TRUSTSTORE_PASSWORD`               | Password for the Opensearch truststore.                                                                             | `nil`                                       |
| `OPENSEARCH_KEY_PASSWORD`                      | Password for the Opensearch node PEM key.                                                                           | `nil`                                       |
| `OPENSEARCH_KEYSTORE_LOCATION`                 | Path to Keystore                                                                                                    | `${DB_CERTS_DIR}/opensearch.keystore.jks`   |
| `OPENSEARCH_TRUSTSTORE_LOCATION`               | Path to Truststore.                                                                                                 | `${DB_CERTS_DIR}/opensearch.truststore.jks` |
| `OPENSEARCH_NODE_CERT_LOCATION`                | Path to PEM node certificate.                                                                                       | `${DB_CERTS_DIR}/tls.crt`                   |
| `OPENSEARCH_NODE_KEY_LOCATION`                 | Path to PEM node key.                                                                                               | `${DB_CERTS_DIR}/tls.key`                   |
| `OPENSEARCH_CA_CERT_LOCATION`                  | Path to CA certificate.                                                                                             | `${DB_CERTS_DIR}/ca.crt`                    |
| `OPENSEARCH_SKIP_TRANSPORT_TLS`                | Skips transport layer TLS configuration. Useful when deploying single-node clusters.                                | `false`                                     |
| `OPENSEARCH_TRANSPORT_TLS_USE_PEM`             | Configure transport layer TLS settings using PEM certificates.                                                      | `$DB_TLS_USE_PEM`                           |
| `OPENSEARCH_TRANSPORT_TLS_KEYSTORE_PASSWORD`   | Password for the Opensearch transport layer TLS keystore containing the certificates or password-protected PEM key. | `$DB_KEYSTORE_PASSWORD`                     |
| `OPENSEARCH_TRANSPORT_TLS_TRUSTSTORE_PASSWORD` | Password for the Opensearch transport layer TLS truststore.                                                         | `$DB_TRUSTSTORE_PASSWORD`                   |
| `OPENSEARCH_TRANSPORT_TLS_KEY_PASSWORD`        | Password for the Opensearch transport layer TLS node PEM key.                                                       | `$DB_KEY_PASSWORD`                          |
| `OPENSEARCH_TRANSPORT_TLS_KEYSTORE_LOCATION`   | Path to Keystore for transport layer TLS.                                                                           | `$DB_KEYSTORE_LOCATION`                     |
| `OPENSEARCH_TRANSPORT_TLS_TRUSTSTORE_LOCATION` | Path to Truststore for transport layer TLS.                                                                         | `$DB_TRUSTSTORE_LOCATION`                   |
| `OPENSEARCH_TRANSPORT_TLS_NODE_CERT_LOCATION`  | Path to PEM node certificate for transport layer TLS.                                                               | `$DB_NODE_CERT_LOCATION`                    |
| `OPENSEARCH_TRANSPORT_TLS_NODE_KEY_LOCATION`   | Path to PEM node key for transport layer TLS.                                                                       | `$DB_NODE_KEY_LOCATION`                     |
| `OPENSEARCH_TRANSPORT_TLS_CA_CERT_LOCATION`    | Path to CA certificate for transport layer TLS.                                                                     | `$DB_CA_CERT_LOCATION`                      |
| `OPENSEARCH_ENABLE_REST_TLS`                   | Enable TLS encryption for REST API communications.                                                                  | `true`                                      |
| `OPENSEARCH_HTTP_TLS_USE_PEM`                  | Configure HTTP TLS settings using PEM certificates.                                                                 | `$DB_TLS_USE_PEM`                           |
| `OPENSEARCH_HTTP_TLS_KEYSTORE_PASSWORD`        | Password for the Opensearch HTTP TLS keystore containing the certificates or password-protected PEM key.            | `$DB_KEYSTORE_PASSWORD`                     |
| `OPENSEARCH_HTTP_TLS_TRUSTSTORE_PASSWORD`      | Password for the Opensearch HTTP TLS truststore.                                                                    | `$DB_TRUSTSTORE_PASSWORD`                   |
| `OPENSEARCH_HTTP_TLS_KEY_PASSWORD`             | Password for the Opensearch HTTP TLS node PEM key.                                                                  | `$DB_KEY_PASSWORD`                          |
| `OPENSEARCH_HTTP_TLS_KEYSTORE_LOCATION`        | Path to Keystore for HTTP TLS.                                                                                      | `$DB_KEYSTORE_LOCATION`                     |
| `OPENSEARCH_HTTP_TLS_TRUSTSTORE_LOCATION`      | Path to Truststore for HTTP TLS.                                                                                    | `$DB_TRUSTSTORE_LOCATION`                   |
| `OPENSEARCH_HTTP_TLS_NODE_CERT_LOCATION`       | Path to PEM node certificate for HTTP TLS.                                                                          | `$DB_NODE_CERT_LOCATION`                    |
| `OPENSEARCH_HTTP_TLS_NODE_KEY_LOCATION`        | Path to PEM node key for HTTP TLS.                                                                                  | `$DB_NODE_KEY_LOCATION`                     |
| `OPENSEARCH_HTTP_TLS_CA_CERT_LOCATION`         | Path to CA certificate for HTTP TLS.                                                                                | `$DB_CA_CERT_LOCATION`                      |
| `OPENSEARCH_SECURITY_DIR`                      | Root directory of the Opensearch Security plugin.                                                                   | `${DB_PLUGINS_DIR}/opensearch-security`     |
| `OPENSEARCH_SECURITY_CONF_DIR`                 | Configuration directory of the Opensearch Security plugin.                                                          | `${DB_CONF_DIR}/opensearch-security`        |
| `OPENSEARCH_DASHBOARDS_PASSWORD`               | Password for the Opensearch-dashboards user.                                                                        | `bitnami`                                   |
| `LOGSTASH_PASSWORD`                            | Password for the Logstash user.                                                                                     | `bitnami`                                   |
| `OPENSEARCH_SET_CGROUP`                        | Configure Opensearch java opts with cgroup hierarchy override, so cgroup statistics are available in the container. | `true`                                      |
| `OPENSEARCH_SECURITY_BOOTSTRAP`                | If set to true, this node will be configured with instructions to bootstrap the Opensearch security config.         | `false`                                     |
| `OPENSEARCH_SECURITY_NODES_DN`                 | Comma-separated list including the Opensearch nodes allowed TLS DNs.                                                | `nil`                                       |
| `OPENSEARCH_SECURITY_ADMIN_DN`                 | Comma-separated list including the Opensearch Admin user allowed TLS DNs.                                           | `nil`                                       |
| `OPENSEARCH_SECURITY_ADMIN_CERT_LOCATION`      | Path to the Opensearch Admin PEM certificate.                                                                       | `${DB_CERTS_DIR}/admin.crt`                 |
| `OPENSEARCH_SECURITY_ADMIN_KEY_LOCATION`       | Path to the Opensearch Admin PEM key.                                                                               | `${DB_CERTS_DIR}/admin.key`                 |

#### Read-only environment variables

| Name                             | Description                                                     | Value                            |
|----------------------------------|-----------------------------------------------------------------|----------------------------------|
| `DB_FLAVOR`                      | Database flavor. Valid values: `elasticsearch` or `opensearch`. | `opensearch`                     |
| `OPENSEARCH_VOLUME_DIR`          | Persistence base directory                                      | `/bitnami/opensearch`            |
| `OPENSEARCH_BASE_DIR`            | Opensearch installation directory                               | `/opt/bitnami/opensearch`        |
| `OPENSEARCH_CONF_DIR`            | Opensearch configuration directory                              | `${DB_BASE_DIR}/config`          |
| `OPENSEARCH_DEFAULT_CONF_DIR`    | Opensearch default configuration directory                      | `${DB_BASE_DIR}/config.default`  |
| `OPENSEARCH_LOGS_DIR`            | Opensearch logs directory                                       | `${DB_BASE_DIR}/logs`            |
| `OPENSEARCH_PLUGINS_DIR`         | Opensearch plugins directory                                    | `${DB_BASE_DIR}/plugins`         |
| `OPENSEARCH_DEFAULT_PLUGINS_DIR` | Opensearch default plugins directory                            | `${DB_BASE_DIR}/plugins.default` |
| `OPENSEARCH_DATA_DIR`            | Opensearch data directory                                       | `${DB_VOLUME_DIR}/data`          |
| `OPENSEARCH_TMP_DIR`             | Opensearch temporary directory                                  | `${DB_BASE_DIR}/tmp`             |
| `OPENSEARCH_BIN_DIR`             | Opensearch executables directory                                | `${DB_BASE_DIR}/bin`             |
| `OPENSEARCH_MOUNTED_PLUGINS_DIR` | Directory where plugins are mounted                             | `${DB_VOLUME_DIR}/plugins`       |
| `OPENSEARCH_CONF_FILE`           | Path to Opensearch configuration file                           | `${DB_CONF_DIR}/opensearch.yml`  |
| `OPENSEARCH_LOG_FILE`            | Path to the Opensearch log file                                 | `${DB_LOGS_DIR}/opensearch.log`  |
| `OPENSEARCH_PID_FILE`            | Path to the Opensearch pid file                                 | `${DB_TMP_DIR}/opensearch.pid`   |
| `OPENSEARCH_INITSCRIPTS_DIR`     | Path to the Opensearch container init scripts directory         | `/docker-entrypoint-initdb.d`    |
| `OPENSEARCH_DAEMON_USER`         | Opensearch system user                                          | `opensearch`                     |
| `OPENSEARCH_DAEMON_GROUP`        | Opensearch system group                                         | `opensearch`                     |
| `OPENSEARCH_USERNAME`            | Username of the Opensearch superuser.                           | `admin`                          |

### Setting up a cluster

A cluster can easily be setup with the Bitnami OpenSearch Docker Image using the following environment variables:

- `OPENSEARCH_CLUSTER_NAME`: The OpenSearch Cluster Name. Default: **opensearch-cluster**
- `OPENSEARCH_CLUSTER_HOSTS`: List of OpenSearch hosts to set the cluster. Available separators are ' ', ',' and ';'. No defaults.
- `OPENSEARCH_CLIENT_NODE`: OpenSearch node to behave as a 'smart router' for Kibana app. Default: **false**
- `OPENSEARCH_NODE_NAME`: OpenSearch node name. No defaults.
- `OPENSEARCH_MINIMUM_MASTER_NODES`: Minimum OpenSearch master nodes for a quorum. No defaults.

For larger cluster, you can setup 'dedicated nodes' using the following environment variables:

- `OPENSEARCH_IS_DEDICATED_NODE`: OpenSearch node to behave as a 'dedicated node'. Default: **no**
- `OPENSEARCH_NODE_TYPE`: OpenSearch node type when behaving as a 'dedicated node'. Valid values: *master*, *data*, *coordinating* or *ingest*.
- `OPENSEARCH_CLUSTER_MASTER_HOSTS`: List of OpenSearch master-eligible hosts. Available separators are ' ', ',' and ';'. If no values are provided, it will have the same value as `OPENSEARCH_CLUSTER_HOSTS`.

Find more information about 'dedicated nodes' in the [official documentation](https://www.elastic.co/guide/en/opensearch/reference/current/modules-node.html).

### Configuration file

In order to use a custom configuration file instead of the default one provided out of the box, you can create a file named `opensearch.yml` and mount it at `/opt/bitnami/opensearch/config/opensearch.yml` to overwrite the default configuration:

```console
docker run -d --name opensearch \
    -p 9201:9201 \
    -v /path/to/opensearch.yml:/opt/bitnami/opensearch/config/opensearch.yml \
    -v /path/to/opensearch-data-persistence:/bitnami/opensearch/data \
    bitnami/opensearch:latest
```

Please, note that the whole configuration file will be replaced by the provided, default one; ensure that the syntax and fields you provide are properly set and exhaustive.

If you would rather extend than replace the default configuration with your settings, mount your custom configuration file at `/opt/bitnami/opensearch/config/my_opensearch.yml`.

### Plugins

You can add extra plugins by setting the `OPENSEARCH_PLUGINS` environment variable. To specify multiple plugins, separate them by spaces, commas or semicolons. When the container is initialized it will install all of the specified plugins before starting OpenSearch.

```console
docker run -d --name opensearch \
    -e OPENSEARCH_PLUGINS=analysis-icu \
    bitnami/opensearch:latest
```

The Bitnami OpenSearch Docker image will also install plugin `.zip` files mounted at the `/bitnami/opensearch/plugins` directory inside the container, making it possible to install them from disk without requiring Internet access.

#### Adding plugins at build time (persisting plugins)

The Bitnami OpenSearch image provides a way to create your custom image installing plugins on build time. This is the preferred way to persist plugins when using OpenSearch, as they will not be installed every time the container is started but just once at build time.

To create your own image providing plugins execute the following command. Remember to replace the `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/opensearch/VERSION/OPERATING-SYSTEM
docker build --build-arg OPENSEARCH_PLUGINS=<plugin1,plugin2,...> -t bitnami/opensearch:latest .
```

The command above will build the image providing this GitHub repository as build context, and will pass the list of plugins to install to the build logic.

### Initializing a new instance

When the container is executed for the first time, it will execute the files with extension `.sh` located at `/docker-entrypoint-initdb.d`.

In order to have your custom files inside the Docker image, you can mount them as a volume.

### FIPS configuration in Bitnami Secure Images

The Bitnami OpenSearch Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.
- `JAVA_TOOL_OPTIONS`: controls Java FIPS mode. Use `-Djava.security.properties==/opt/bitnami/java/conf/security/java.security.restricted` (restricted), `-Djava.security.properties==/opt/bitnami/java/conf/security/java.security.relaxed` (relaxed), or `-Djava.security.properties==/opt/bitnami/java/conf/security/java.security.original` (off).

## Logging

The Bitnami OpenSearch Docker image sends the container logs to the `stdout`. You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## License

Copyright &copy; 2026 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
