# Bitnami package for OpenSearch

## What is OpenSearch?

> OpenSearch is a scalable open-source solution for search, analytics, and observability. Features full-text queries, natural language processing, custom dictionaries, amongst others.

[Overview of OpenSearch](https://opensearch.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name opensearch bitnami/opensearch:latest
```

You can find the available configuration options in the [Environment Variables](#environment-variables) section.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use OpenSearch in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## How to deploy OpenSearch in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami OpenSearch Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/opensearch).

Bitnami containers can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami OpenSearch Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/opensearch).

```console
docker pull bitnami/opensearch:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/opensearch/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/opensearch:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the application will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami` path. If the mounted directory is empty, it will be initialized on the first run.

```console
docker run \
    -v /path/to/opensearch-data-persistence:/bitnami/opensearch/data \
    bitnami/opensearch:latest
```

or by making a minor change to the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/opensearch/docker-compose.yml) file present in this repository:

```yaml
opensearch:
  ...
  volumes:
    - /path/to/opensearch-data-persistence:/bitnami/opensearch/data
  ...
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

It is also possible to use multiple volumes for data persistence by using the `OPENSEARCH_DATA_DIR_LIST` environment variable:

```yaml
opensearch:
  ...
  volumes:
    - /path/to/opensearch-data-persistence-1:/opensearch/data-1
    - /path/to/opensearch-data-persistence-2:/opensearch/data-2
  environment:
    - OPENSEARCH_DATA_DIR_LIST=/opensearch/data-1,/opensearch/data-2
  ...
```

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), an OpenSearch server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

#### Step 1: Create a network

```console
docker network create app-tier --driver bridge
```

#### Step 2: Launch the OpenSearch server instance

Use the `--network app-tier` argument to the `docker run` command to attach the OpenSearch container to the `app-tier` network.

```console
docker run -d --name opensearch-server \
    --network app-tier \
    bitnami/opensearch:latest
```

#### Step 3: Launch your application container

```console
docker run -d --name myapp \
    --network app-tier \
    YOUR_APPLICATION_IMAGE
```

> **IMPORTANT**:
>
> 1. Please update the **YOUR_APPLICATION_IMAGE_** placeholder in the above snippet with your application image
> 2. In your application container, use the hostname `opensearch-server` to connect to the OpenSearch server

### Using a Docker Compose file

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `app-tier`. In this example we assume that you want to connect to the OpenSearch server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge

services:
  opensearch:
    image: 'bitnami/opensearch:latest'
    networks:
      - app-tier
  myapp:
    image: 'YOUR_APPLICATION_IMAGE'
    networks:
      - app-tier
```

> **IMPORTANT**:
>
> 1. Please update the **YOUR_APPLICATION_IMAGE_** placeholder in the above snippet with your application image
> 2. In your application container, use the hostname `opensearch` to connect to the OpenSearch server

Launch the containers using:

```console
docker-compose up -d
```

## Configuration

### Environment variables

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

When you start the opensearch image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. If you want to add a new environment variable:

* For Docker Compose, add the variable name and value under the application section:

```yaml
opensearch:
  ...
  environment:
    - OPENSEARCH_PORT_NUMBER=9201
  ...
```

* For manual execution add a `-e` option with each variable and value:

```console
 $ docker run -d --name opensearch \
    -p 9201:9201 --network=opensearch_network \
    -e OPENSEARCH_PORT_NUMBER=9201 \
    -v /path/to/opensearch-data-persistence:/bitnami/opensearch/data \
    bitnami/opensearch
```

### Setting up a cluster

A cluster can easily be setup with the Bitnami OpenSearch Docker Image using the following environment variables:

* `OPENSEARCH_CLUSTER_NAME`: The OpenSearch Cluster Name. Default: **opensearch-cluster**
* `OPENSEARCH_CLUSTER_HOSTS`: List of opensearch hosts to set the cluster. Available separators are ' ', ',' and ';'. No defaults.
* `OPENSEARCH_CLIENT_NODE`: OpenSearch node to behave as a 'smart router' for Kibana app. Default: **false**
* `OPENSEARCH_NODE_NAME`: OpenSearch node name. No defaults.
* `OPENSEARCH_MINIMUM_MASTER_NODES`: Minimum OpenSearch master nodes for a quorum. No defaults.

For larger cluster, you can setup 'dedicated nodes' using the following environment variables:

* `OPENSEARCH_IS_DEDICATED_NODE`: OpenSearch node to behave as a 'dedicated node'. Default: **no**
* `OPENSEARCH_NODE_TYPE`: OpenSearch node type when behaving as a 'dedicated node'. Valid values: *master*, *data*, *coordinating* or *ingest*.
* `OPENSEARCH_CLUSTER_MASTER_HOSTS`: List of opensearch master-eligible hosts. Available separators are ' ', ',' and ';'. If no values are provided, it will have the same value as `OPENSEARCH_CLUSTER_HOSTS`.

Find more information about 'dedicated nodes' in the [official documentation](https://www.elastic.co/guide/en/opensearch/reference/current/modules-node.html).

#### Step 1: Create a new network

```console
docker network create opensearch_network
```

#### Step 2: Create the first node

```console
docker run --name opensearch-node1 \
  --net=opensearch_network \
  -p 9200:9200 \
  -e OPENSEARCH_CLUSTER_NAME=opensearch-cluster \
  -e OPENSEARCH_CLUSTER_HOSTS=opensearch-node1,opensearch-node2 \
  -e OPENSEARCH_NODE_NAME=elastic-node1 \
  bitnami/opensearch:latest
```

In the above command the container is added to a cluster named `opensearch-cluster` using the `OPENSEARCH_CLUSTER_NAME`. The `OPENSEARCH_CLUSTER_HOSTS` parameter set the name of the nodes that set the cluster so we will need to launch other container for the second node. Finally the `OPENSEARCH_NODE_NAME` parameter allows to indicate a known name for the node, otherwise opensearch will generate a random one.

#### Step 3: Create a second node

```console
docker run --name opensearch-node2 \
  --link opensearch-node1:opensearch-node1 \
  --net=opensearch_network \
  -e OPENSEARCH_CLUSTER_NAME=opensearch-cluster \
  -e OPENSEARCH_CLUSTER_HOSTS=opensearch-node1,opensearch-node2 \
  -e OPENSEARCH_NODE_NAME=elastic-node2 \
  bitnami/opensearch:latest
```

In the above command a new opensearch node is being added to the opensearch cluster indicated by `OPENSEARCH_CLUSTER_NAME`.

You now have a two node OpenSearch cluster up and running which can be scaled by adding/removing nodes.

With Docker Compose the cluster configuration can be setup using:

```yaml
version: '2'
services:
  opensearch-node1:
    image: bitnami/opensearch:latest
    environment:
      - OPENSEARCH_CLUSTER_NAME=opensearch-cluster
      - OPENSEARCH_CLUSTER_HOSTS=opensearch-node1,opensearch-node2
      - OPENSEARCH_NODE_NAME=elastic-node1

  opensearch-node2:
    image: bitnami/opensearch:latest
    environment:
      - OPENSEARCH_CLUSTER_NAME=opensearch-cluster
      - OPENSEARCH_CLUSTER_HOSTS=opensearch-node1,opensearch-node2
      - OPENSEARCH_NODE_NAME=elastic-node2
```

### Configuration file

In order to use a custom configuration file instead of the default one provided out of the box, you can create a file named `opensearch.yml` and mount it at `/opt/bitnami/opensearch/config/opensearch.yml` to overwrite the default configuration:

```console
docker run -d --name opensearch \
    -p 9201:9201 \
    -v /path/to/opensearch.yml:/opt/bitnami/opensearch/config/opensearch.yml \
    -v /path/to/opensearch-data-persistence:/bitnami/opensearch/data \
    bitnami/opensearch:latest
```

or by changing the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/opensearch/docker-compose.yml) file present in this repository:

```yaml
opensearch:
  ...
  volumes:
    - /path/to/opensearch.yml:/opt/bitnami/opensearch/config/opensearch.yml
    - /path/to/opensearch-data-persistence:/bitnami/opensearch/data
  ...
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

The Bitnami OpenSearch image provides a way to create your custom image installing plugins on build time. This is the preferred way to persist plugins when using Opensearch, as they will not be installed every time the container is started but just once at build time.

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

## Logging

The Bitnami OpenSearch Docker image sends the container logs to the `stdout`. To view the logs:

```console
docker logs opensearch
```

or using Docker Compose:

```console
docker-compose logs opensearch
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

Additionally, in case you'd like to modify OpenSearch logging configuration, it can be done by overwriting the file `/opt/bitnami/opensearch/config/log4j2.properties`.
The syntax of this file can be found in OpenSearch [logging documentation](https://www.elastic.co/guide/en/opensearch/reference/current/logging.html).

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of OpenSearch, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/opensearch:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/opensearch:latest`.

#### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
docker stop opensearch
```

or using Docker Compose:

```console
docker-compose stop opensearch
```

Next, take a snapshot of the persistent volume `/path/to/opensearch-data-persistence` using:

```console
rsync -a /path/to/opensearch-data-persistence /path/to/opensearch-data-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

You can use this snapshot to restore the application state should the upgrade fail.

#### Step 3: Remove the currently running container

```console
docker rm -v opensearch
```

or using Docker Compose:

```console
docker-compose rm -v opensearch
```

#### Step 4: Run the new image

Re-create your container from the new image, restoring your backup if necessary.

```console
docker run --name opensearch bitnami/opensearch:latest
```

or using Docker Compose:

```console
docker-compose up opensearch
```

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/opensearch).

If you detect any issue in the `docker-compose.yaml` file, feel free to report it or contribute with a fix by following our [Contributing Guidelines](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md).

## Contributing

We'd love for you to contribute to this Docker image. You can request new features by creating an [issue], or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/containers/issues/new/choose). For us to provide better support, be sure to include the following information in your issue:

* Host OS and version
* Docker version (`docker version`)
* Output of `docker info`
* Version of this container
* The command you used to run the container, and any relevant output you saw (masking any sensitive information)

## License

Copyright &copy; 2025 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
