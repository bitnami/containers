# Bitnami package for ScyllaDB

## What is ScyllaDB?

> ScyllaDB is an open-source, distributed NoSQL wide-column data store. Written in C++, it is designed for high throughput and low latency, compatible with Apache Cassandra.

[Overview of ScyllaDB](https://www.scylladb.com/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name scylladb bitnami/scylladb:latest
```

You can find the default credentials and available configuration options in the [Environment Variables](#environment-variables) section.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use ScyllaDB in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

## How to deploy ScyllaDB in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami ScyllaDB Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/scylladb).

Bitnami containers can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami ScyllaDB Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/scylladb).

```console
docker pull bitnami/scylladb:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/scylladb/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/scylladb:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami` path. If the mounted directory is empty, it will be initialized on the first run.

```console
docker run \
    -v /path/to/scylladb-persistence:/bitnami \
    bitnami/scylladb:latest
```

or using Docker Compose:

```yaml
scylladb:
  image: bitnami/scylladb:latest
  volumes:
    - /path/to/scylladb-persistence:/bitnami
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), an ScyllaDB server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

In this example, we will create an ScyllaDB client instance that will connect to the server instance that is running on the same docker network as the client.

#### Step 1: Create a network

```console
docker network create app-tier --driver bridge
```

#### Step 2: Launch the ScyllaDB server instance

Use the `--network app-tier` argument to the `docker run` command to attach the ScyllaDB container to the `app-tier` network.

```console
docker run -d --name scylladb-server \
    --network app-tier \
    bitnami/scylladb:latest
```

#### Step 3: Launch your ScyllaDB client instance

Finally we create a new container instance to launch the ScyllaDB client and connect to the server created in the previous step:

```console
docker run -it --rm \
    --network app-tier \
    bitnami/scylladb:latest cqlsh --username scylladb --password scylladb scylladb-server
```

### Using a Docker Compose file

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `app-tier`. In this example we assume that you want to connect to the ScyllaDB server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge

services:
  scylladb:
    image: 'bitnami/scylladb:latest'
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
> 2. In your application container, use the hostname `scylladb` to connect to the ScyllaDB server

Launch the containers using:

```console
docker-compose up -d
```

## Configuration

### Environment variables

#### Customizable environment variables

| Name                                              | Description                                                                             | Default Value                         |
|---------------------------------------------------|-----------------------------------------------------------------------------------------|---------------------------------------|
| `SCYLLADB_CLIENT_ENCRYPTION`                      | Enable client encryption                                                                | `false`                               |
| `SCYLLADB_CLUSTER_NAME`                           | ScyllaDB cluster name                                                                   | `My Cluster`                          |
| `SCYLLADB_DATACENTER`                             | ScyllaDB datacenter name                                                                | `dc1`                                 |
| `SCYLLADB_ENABLE_REMOTE_CONNECTIONS`              | Enable connection from remote locations                                                 | `true`                                |
| `SCYLLADB_ENABLE_RPC`                             | Enable RPC endpoint in ScyllaDB                                                         | `false`                               |
| `SCYLLADB_ENABLE_USER_DEFINED_FUNCTIONS`          | Enable user defined functions                                                           | `false`                               |
| `SCYLLADB_ENABLE_SCRIPTED_USER_DEFINED_FUNCTIONS` | Enable scripted user defined functions                                                  | `false`                               |
| `SCYLLADB_ENDPOINT_SNITCH`                        | Name of the cluster endpoint snitch                                                     | `SimpleSnitch`                        |
| `SCYLLADB_HOST`                                   | ScyllaDB host name                                                                      | `nil`                                 |
| `SCYLLADB_INTERNODE_ENCRYPTION`                   | Internode encryption type                                                               | `none`                                |
| `SCYLLADB_NUM_TOKENS`                             | Number of tokens in cluster connection                                                  | `256`                                 |
| `SCYLLADB_PASSWORD_SEEDER`                        | Set node as password seeder in the cluster                                              | `no`                                  |
| `SCYLLADB_SEEDS`                                  | List of cluster seeds                                                                   | `$DB_HOST`                            |
| `SCYLLADB_PEERS`                                  | List of cluster peers                                                                   | `$DB_SEEDS`                           |
| `SCYLLADB_NODES`                                  | List of cluster nodes (seeders and non seeders)                                         | `nil`                                 |
| `SCYLLADB_RACK`                                   | ScyllaDB rack name                                                                      | `rack1`                               |
| `SCYLLADB_BROADCAST_ADDRESS`                      | Node broadcast address                                                                  | `nil`                                 |
| `SCYLLADB_AUTOMATIC_SSTABLE_UPGRADE`              | Automatically upgrade sstables after upgrade                                            | `false`                               |
| `SCYLLADB_STARTUP_CQL`                            | Startup CQL commands to run at boot                                                     | `nil`                                 |
| `SCYLLADB_IGNORE_INITDB_SCRIPTS`                  | Ignore the execution of init scripts                                                    | `no`                                  |
| `SCYLLADB_CQL_PORT_NUMBER`                        | CQL port                                                                                | `9042`                                |
| `SCYLLADB_JMX_PORT_NUMBER`                        | JMX port                                                                                | `7199`                                |
| `SCYLLADB_TRANSPORT_PORT_NUMBER`                  | Transport port                                                                          | `7000`                                |
| `SCYLLADB_CQL_MAX_RETRIES`                        | Maximum retries for CQL startup operations                                              | `20`                                  |
| `SCYLLADB_CQL_SLEEP_TIME`                         | Sleep time for CQL startup operations                                                   | `5`                                   |
| `SCYLLADB_INIT_MAX_RETRIES`                       | Maximum retries for init startup operations                                             | `100`                                 |
| `SCYLLADB_INIT_SLEEP_TIME`                        | Sleep time for init startup operations                                                  | `5`                                   |
| `SCYLLADB_PEER_CQL_MAX_RETRIES`                   | Maximum retries for peer startup operations                                             | `100`                                 |
| `SCYLLADB_PEER_CQL_SLEEP_TIME`                    | Sleep time for peer startup operations                                                  | `10`                                  |
| `SCYLLADB_DELAY_START_TIME`                       | Delay ScyllaDB start by the number of provided seconds                                  | `10`                                  |
| `SCYLLADB_AUTO_SNAPSHOT_TTL`                      | Take an automatic snapshot of the data before truncating a keyspace or dropping a table | `30d`                                 |
| `ALLOW_EMPTY_PASSWORD`                            | Allow no credentials in the installation.                                               | `no`                                  |
| `SCYLLADB_AUTHORIZER`                             | ScyllaDB connection authorizer                                                          | `CassandraAuthorizer`                 |
| `SCYLLADB_AUTHENTICATOR`                          | ScyllaDB connection authenticator                                                       | `PasswordAuthenticator`               |
| `SCYLLADB_USER`                                   | ScyllaDB username                                                                       | `cassandra`                           |
| `SCYLLADB_PASSWORD`                               | ScyllaDB password                                                                       | `nil`                                 |
| `SCYLLADB_KEYSTORE_PASSWORD`                      | ScyllaDB keystore password                                                              | `cassandra`                           |
| `SCYLLADB_TRUSTSTORE_PASSWORD`                    | ScyllaDB truststore password                                                            | `cassandra`                           |
| `SCYLLADB_KEYSTORE_LOCATION`                      | ScyllaDB keystore location                                                              | `${DB_VOLUME_DIR}/secrets/keystore`   |
| `SCYLLADB_TRUSTSTORE_LOCATION`                    | ScyllaDB truststore location                                                            | `${DB_VOLUME_DIR}/secrets/truststore` |
| `SCYLLADB_TMP_P12_FILE`                           | ScyllaDB truststore location                                                            | `${DB_TMP_DIR}/keystore.p12`          |
| `SCYLLADB_SSL_CERT_FILE`                          | ScyllaDB SSL certificate location                                                       | `${DB_VOLUME_DIR}/certs/tls.crt`      |
| `SCYLLADB_SSL_KEY_FILE`                           | ScyllaDB SSL keyfile location                                                           | `${DB_VOLUME_DIR}/certs/tls.key`      |
| `SCYLLADB_SSL_CA_FILE`                            | ScyllaDB SSL CA location                                                                | `nil`                                 |
| `SCYLLADB_SSL_VALIDATE`                           | Perform SSL validation on the certificates                                              | `false`                               |
| `SSL_VERSION`                                     | TLS version to use when connecting.                                                     | `TLSv1_2`                             |
| `SCYLLADB_MOUNTED_CONF_DIR`                       | ScyllaDB directory for mounted configuration files                                      | `${DB_VOLUME_DIR}/etc`                |
| `SCYLLADB_CQL_SHARD_PORT_NUMBER`                  | CQL (shard aware) port                                                                  | `19042`                               |
| `SCYLLADB_API_PORT_NUMBER`                        | REST API port                                                                           | `10000`                               |
| `SCYLLADB_PROMETHEUS_PORT_NUMBER`                 | Prometheus metrics port                                                                 | `9180`                                |
| `SCYLLADB_DEVELOPER_MODE`                         | Use ScyllaDB developer mode                                                             | `yes`                                 |
| `SCYLLADB_RUN_JMX_PROXY`                          | Launch JMX Proxy as a subprocess                                                        | `no`                                  |

#### Read-only environment variables

| Name                                 | Description                                                                    | Value                                                            |
|--------------------------------------|--------------------------------------------------------------------------------|------------------------------------------------------------------|
| `DB_FLAVOR`                          | Database flavor. Valid values: `cassandra` or `scylladb`.                      | `scylladb`                                                       |
| `SCYLLADB_BASE_DIR`                  | ScyllaDB installation directory                                                | `/opt/bitnami/scylladb`                                          |
| `SCYLLADB_BIN_DIR`                   | ScyllaDB executables directory                                                 | `${DB_BASE_DIR}/bin`                                             |
| `SCYLLADB_VOLUME_DIR`                | Persistence base directory                                                     | `/bitnami/scylladb`                                              |
| `SCYLLADB_DATA_DIR`                  | ScyllaDB data directory                                                        | `${DB_VOLUME_DIR}/data`                                          |
| `SCYLLADB_COMMITLOG_DIR`             | ScyllaDB commit log directory                                                  | `${DB_DATA_DIR}/commitlog`                                       |
| `SCYLLADB_INITSCRIPTS_DIR`           | Path to the ScyllaDB container init scripts directory                          | `/docker-entrypoint-initdb.d`                                    |
| `SCYLLADB_LOG_DIR`                   | ScyllaDB logs directory                                                        | `${DB_BASE_DIR}/logs`                                            |
| `SCYLLADB_TMP_DIR`                   | ScyllaDB temporary directory                                                   | `${DB_BASE_DIR}/tmp`                                             |
| `JAVA_BASE_DIR`                      | Java base directory                                                            | `${BITNAMI_ROOT_DIR}/java`                                       |
| `JAVA_BIN_DIR`                       | Java binary directory                                                          | `${JAVA_BASE_DIR}/bin`                                           |
| `PYTHON_BASE_DIR`                    | Python base directory                                                          | `${BITNAMI_ROOT_DIR}/python`                                     |
| `PYTHON_BIN_DIR`                     | Python binary directory                                                        | `${PYTHON_BASE_DIR}/bin`                                         |
| `SCYLLADB_LOG_FILE`                  | Path to the ScyllaDB log file                                                  | `${DB_LOG_DIR}/scylladb.log`                                     |
| `SCYLLADB_FIRST_BOOT_LOG_FILE`       | Path to the ScyllaDB first boot log file                                       | `${DB_LOG_DIR}/scylladb_first_boot.log`                          |
| `SCYLLADB_INITSCRIPTS_BOOT_LOG_FILE` | Path to the ScyllaDB init scripts log file                                     | `${DB_LOG_DIR}/scylladb_init_scripts_boot.log`                   |
| `SCYLLADB_PID_FILE`                  | Path to the ScyllaDB pid file                                                  | `${DB_TMP_DIR}/scylladb.pid`                                     |
| `SCYLLADB_DAEMON_USER`               | ScyllaDB system user                                                           | `scylladb`                                                       |
| `SCYLLADB_DAEMON_GROUP`              | ScyllaDB system group                                                          | `scylladb`                                                       |
| `SCYLLADB_CONF_DIR`                  | ScyllaDB configuration directory                                               | `${DB_BASE_DIR}/etc`                                             |
| `SCYLLADB_DEFAULT_CONF_DIR`          | ScyllaDB default configuration directory                                       | `${DB_BASE_DIR}/etc.default`                                     |
| `SCYLLADB_CONF_FILE`                 | Path to ScyllaDB configuration file                                            | `${DB_CONF_DIR}/scylla/scylla.yaml`                              |
| `SCYLLADB_RACKDC_FILE`               | Path to ScyllaDB cassandra-rackdc.properties file                              | `${DB_CONF_DIR}/scylla/cassandra-rackdc.properties`              |
| `SCYLLADB_LOGBACK_FILE`              | Path to ScyllaDB logback.xml file                                              | `${DB_CONF_DIR}/scylla/cassandra/logback.xml`                    |
| `SCYLLADB_COMMITLOG_ARCHIVING_FILE`  | Path to ScyllaDB commitlog_archiving.properties file                           | `${DB_CONF_DIR}/scylla/cassandra/commitlog_archiving.properties` |
| `SCYLLADB_ENV_FILE`                  | Path to ScyllaDB cassandra-env.sh file                                         | `${DB_CONF_DIR}/scylla/cassandra/cassandra-env.sh`               |
| `SCYLLADB_MOUNTED_CONF_PATH`         | Relative path (in mounted volume) to ScyllaDB configuration file               | `scylla/scylla.yaml`                                             |
| `SCYLLADB_MOUNTED_RACKDC_PATH`       | Relative path (in mounted volume) to ScyllaDB cassandra-rackdc-properties file | `scylla/cassandra-rackdc.properties`                             |
| `SCYLLADB_MOUNTED_ENV_PATH`          | Relative path (in mounted volume) to ScyllaDB cassandra-env.sh file            | `scylla/cassandra/cassandra-env.sh`                              |
| `SCYLLADB_MOUNTED_LOGBACK_PATH`      | Path to ScyllaDB logback.xml file                                              | `scylla/cassandra/logback.xml`                                   |
| `SCYLLADB_CONF`                      | ScyllaDB configuration directory                                               | `$SCYLLADB_CONF_DIR`                                             |

Additionally, any environment variable beginning with the following prefix will be mapped to its corresponding ScyllaDB key in the proper file:

* `SCYLLADB_CFG_ENV_`: Will add the corresponding key and the provided value to `scylladb-env.sh`.
* `SCYLLADB_CFG_RACKDC_`: Will add the corresponding key and the provided value to `scylladb-rackdc.properties`.
* `SCYLLADB_CFG_COMMITLOG_`: Will add the corresponding key and the provided value to `commitlog_archiving.properties`.
* `SCYLLADB_CFG_YAML_`: Will add the corresponding key and the provided value to `scylladb.yaml`.

For example, use `SCYLLADB_CFG_RACKDC_PREFER_LOCAL=true` in order to configure `prefer_local` in `scylladb-rackdc.properties`. Or, use `SCYLLADB_CFG_YAML_INTERNODE_COMPRESSION=all` in order to set `internode_compression` to `all` in `scylladb.yaml`.

**NOTE:** Environment variables will be omitted when mounting a configuration file

When you start the scylladb image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. If you want to add a new environment variable:

* For docker-compose add the variable name and value under the application section:

```yaml
scylladb:
  image: bitnami/scylladb:latest
  environment:
    - SCYLLADB_TRANSPORT_PORT_NUMBER=7000
```

* For manual execution add a `-e` option with each variable and value:

```console
 $ docker run --name scylladb -d -p 7000:7000 --network=scylladb_network \
    -e SCYLLADB_TRANSPORT_PORT_NUMBER=7000 \
    -v /your/local/path/bitnami/scylladb:/bitnami \
    bitnami/scylladb
```

### Setting the server password on first run

Passing the `SCYLLADB_PASSWORD` environment variable along with `SCYLLADB_PASSWORD_SEEDER=yes` when running the image for the first time will set the ScyllaDB server password to the value of `SCYLLADB_PASSWORD`.

```console
docker run --name scylladb \
    -e SCYLLADB_PASSWORD_SEEDER=yes \
    -e SCYLLADB_PASSWORD=password123 \
    bitnami/scylladb:latest
```

or using Docker Compose:

```yaml
scylladb:
  image: bitnami/scylladb:latest
  environment:
    - SCYLLADB_PASSWORD_SEEDER=yes
    - SCYLLADB_PASSWORD=password123
```

#### Step 1: Create a new network

```console
docker network create scylladb_network
```

#### Step 2: Create a first node

```console
docker run --name scylladb-node1 \
  --net=scylladb_network \
  -p 9042:9042 \
  -e SCYLLADB_CLUSTER_NAME=scylladb-cluster \
  -e SCYLLADB_SEEDS=scylladb-node1,scylladb-node2 \
  -e SCYLLADB_PASSWORD_SEEDER=yes \
  -e SCYLLADB_PASSWORD=mypassword \
  bitnami/scylladb:latest
```

In the above command the container is added to a cluster named `scylladb-cluster` using the `SCYLLADB_CLUSTER_NAME`. The `SCYLLADB_CLUSTER_HOSTS` parameter set the name of the nodes that set the cluster so we will need to launch other container for the second node. Finally the `SCYLLADB_NODE_NAME` parameter allows to indicate a known name for the node, otherwise scylladb will generate a random one.

#### Step 3: Create a second node

```console
docker run --name scylladb-node2 \
  --net=scylladb_network \
  -e SCYLLADB_CLUSTER_NAME=scylladb-cluster \
  -e SCYLLADB_SEEDS=scylladb-node1,scylladb-node2 \
  -e SCYLLADB_PASSWORD=mypassword \
  bitnami/scylladb:latest
```

In the above command a new scylladb node is being added to the scylladb cluster indicated by `SCYLLADB_CLUSTER_NAME`.

You now have a two node ScyllaDB cluster up and running which can be scaled by adding/removing nodes.

With Docker Compose the cluster configuration can be setup using:

```yaml
version: '2'
services:
  scylladb-node1:
    image: bitnami/scylladb:latest
    environment:
      - SCYLLADB_CLUSTER_NAME=scylladb-cluster
      - SCYLLADB_SEEDS=scylladb-node1,scylladb-node2
      - SCYLLADB_PASSWORD_SEEDER=yes
      - SCYLLADB_PASSWORD=password123

  scylladb-node2:
    image: bitnami/scylladb:latest
    environment:
      - SCYLLADB_CLUSTER_NAME=scylladb-cluster
      - SCYLLADB_SEEDS=scylladb-node1,scylladb-node2
      - SCYLLADB_PASSWORD=password123
```

### Initializing with custom scripts

When the container is executed for the first time, it will execute the files with extensions `.sh`, `.cql` or `.cql.gz` located at `/docker-entrypoint-initdb.d` in sort'ed order by filename. This behavior can be skipped by setting the environment variable `SCYLLADB_IGNORE_INITDB_SCRIPTS` to a value other than `yes` or `true`.

In order to have your custom files inside the docker image you can mount them as a volume.

```console
docker run --name scylladb \
  -v /path/to/init-scripts:/docker-entrypoint-initdb.d \
  -v /path/to/scylladb-persistence:/bitnami
  bitnami/scylladb:latest
```

Or with docker-compose

```yaml
scylladb:
  image: bitnami/scylladb:latest
  volumes:
    - /path/to/init-scripts:/docker-entrypoint-initdb.d
    - /path/to/scylladb-persistence:/bitnami
```

### Configuration file

The image looks for configurations in `/bitnami/scylladb/conf/`. As mentioned in [Persisting your application](#persisting-your-application) you can mount a volume at `/bitnami` and copy/edit the configurations in the `/path/to/scylladb-persistence/scylladb/conf/`. The default configurations will be populated to the `conf/` directory if it's empty.

#### Step 1: Run the ScyllaDB image

Run the ScyllaDB image, mounting a directory from your host.

```console
docker run --name scylladb \
    -v /path/to/scylladb-persistence:/bitnami \
    bitnami/scylladb:latest
```

or using Docker Compose:

```yaml
scylladb:
  image: bitnami/scylladb:latest
  volumes:
    - /path/to/scylladb-persistence:/bitnami
```

#### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```console
vi /path/to/scylladb-persistence/scylladb/conf/scylladb.yaml
```

#### Step 3: Restart ScyllaDB

After changing the configuration, restart your ScyllaDB container for changes to take effect.

```console
docker restart scylladb
```

or using Docker Compose:

```console
docker-compose restart scylladb
```

Refer to the [configuration](http://docs.datastax.com/en/scylladb/3.x/scylladb/configuration/configTOC.html) manual for the complete list of configuration options.

## TLS Encryption

The Bitnami ScyllaDB Docker image allows configuring TLS encryption between nodes and between server-client. This is done by mounting in `/bitnami/scylladb/secrets` two files:

* `keystore`: File with the server keystore
* `truststore`: File with the server truststore

Apart from that, the following environment variables must be set:

* `SCYLLADB_KEYSTORE_PASSWORD`: Password for accessing the keystore.
* `SCYLLADB_TRUSTSTORE_PASSWORD`: Password for accessing the truststore.
* `SCYLLADB_INTERNODE_ENCRYPTION`: Sets the type of encryption between nodes. The default value is `none`. Can be set to `all`, `none`, `dc` or `rack`.
* `SCYLLADB_CLIENT_ENCRYPTION`: Enables client-server encryption. The default value is `false`.

## Logging

The Bitnami ScyllaDB Docker image sends the container logs to the `stdout`. To view the logs:

```console
docker logs scylladb
```

or using Docker Compose:

```console
docker-compose logs scylladb
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of ScyllaDB, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/scylladb:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/scylladb:latest`.

#### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
docker stop scylladb
```

or using Docker Compose:

```console
docker-compose stop scylladb
```

Next, take a snapshot of the persistent volume `/path/to/scylladb-persistence` using:

```console
rsync -a /path/to/scylladb-persistence /path/to/scylladb-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

#### Step 3: Remove the currently running container

```console
docker rm -v scylladb
```

or using Docker Compose:

```console
docker-compose rm -v scylladb
```

#### Step 4: Run the new image

Re-create your container from the new image.

```console
docker run --name scylladb bitnami/scylladb:latest
```

or using Docker Compose:

```console
docker-compose up scylladb
```

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/scylladb).

If you detect any issue in the `docker-compose.yaml` file, feel free to report it or contribute with a fix by following our [Contributing Guidelines](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md).

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues), or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

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
