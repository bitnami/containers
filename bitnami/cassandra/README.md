# Bitnami package for Apache Cassandra

## What is Apache Cassandra?

> Apache Cassandra is an open source distributed database management system designed to handle large amounts of data across many servers, providing high availability with no single point of failure.

[Overview of Apache Cassandra](http://cassandra.apache.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name cassandra bitnami/cassandra:latest
```

You can find the default credentials and available configuration options in the [Environment Variables](#environment-variables) section.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Apache Cassandra in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## How to deploy Apache Cassandra in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Apache Cassandra Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/cassandra).

Bitnami containers can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami Apache Cassandra Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/cassandra).

```console
docker pull bitnami/cassandra:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/cassandra/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/cassandra:[TAG]
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
    -v /path/to/cassandra-persistence:/bitnami \
    bitnami/cassandra:latest
```

or using Docker Compose:

```yaml
cassandra:
  image: bitnami/cassandra:latest
  volumes:
    - /path/to/cassandra-persistence:/bitnami
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), an Apache Cassandra server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

In this example, we will create an Apache Cassandra client instance that will connect to the server instance that is running on the same docker network as the client.

#### Step 1: Create a network

```console
docker network create app-tier --driver bridge
```

#### Step 2: Launch the Apache Cassandra server instance

Use the `--network app-tier` argument to the `docker run` command to attach the Apache Cassandra container to the `app-tier` network.

```console
docker run -d --name cassandra-server \
    --network app-tier \
    bitnami/cassandra:latest
```

#### Step 3: Launch your Apache Cassandra client instance

Finally we create a new container instance to launch the Apache Cassandra client and connect to the server created in the previous step:

```console
docker run -it --rm \
    --network app-tier \
    bitnami/cassandra:latest cqlsh --username cassandra --password cassandra cassandra-server
```

### Using a Docker Compose file

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `app-tier`. In this example we assume that you want to connect to the Apache Cassandra server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge

services:
  cassandra:
    image: 'bitnami/cassandra:latest'
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
> 2. In your application container, use the hostname `cassandra` to connect to the Apache Cassandra server

Launch the containers using:

```console
docker-compose up -d
```

## Configuration

### Environment variables

#### Customizable environment variables

| Name                                               | Description                                                                             | Default Value                         |
|----------------------------------------------------|-----------------------------------------------------------------------------------------|---------------------------------------|
| `CASSANDRA_CLIENT_ENCRYPTION`                      | Enable client encryption                                                                | `false`                               |
| `CASSANDRA_CLUSTER_NAME`                           | Cassandra cluster name                                                                  | `My Cluster`                          |
| `CASSANDRA_DATACENTER`                             | Cassandra datacenter name                                                               | `dc1`                                 |
| `CASSANDRA_ENABLE_REMOTE_CONNECTIONS`              | Enable connection from remote locations                                                 | `true`                                |
| `CASSANDRA_ENABLE_RPC`                             | Enable RPC endpoint in Cassandra                                                        | `false`                               |
| `CASSANDRA_ENABLE_USER_DEFINED_FUNCTIONS`          | Enable user defined functions                                                           | `false`                               |
| `CASSANDRA_ENABLE_SCRIPTED_USER_DEFINED_FUNCTIONS` | Enable scripted user defined functions                                                  | `false`                               |
| `CASSANDRA_ENDPOINT_SNITCH`                        | Name of the cluster endpoint snitch                                                     | `SimpleSnitch`                        |
| `CASSANDRA_HOST`                                   | Cassandra host name                                                                     | `nil`                                 |
| `CASSANDRA_INTERNODE_ENCRYPTION`                   | Internode encryption type                                                               | `none`                                |
| `CASSANDRA_NUM_TOKENS`                             | Number of tokens in cluster connection                                                  | `256`                                 |
| `CASSANDRA_PASSWORD_SEEDER`                        | Set node as password seeder in the cluster                                              | `no`                                  |
| `CASSANDRA_SEEDS`                                  | List of cluster seeds                                                                   | `$DB_HOST`                            |
| `CASSANDRA_PEERS`                                  | List of cluster peers                                                                   | `$DB_SEEDS`                           |
| `CASSANDRA_NODES`                                  | List of cluster nodes (seeders and non seeders)                                         | `nil`                                 |
| `CASSANDRA_RACK`                                   | Cassandra rack name                                                                     | `rack1`                               |
| `CASSANDRA_BROADCAST_ADDRESS`                      | Node broadcast address                                                                  | `nil`                                 |
| `CASSANDRA_AUTOMATIC_SSTABLE_UPGRADE`              | Automatically upgrade sstables after upgrade                                            | `false`                               |
| `CASSANDRA_STARTUP_CQL`                            | Startup CQL commands to run at boot                                                     | `nil`                                 |
| `CASSANDRA_IGNORE_INITDB_SCRIPTS`                  | Ignore the execution of init scripts                                                    | `no`                                  |
| `CASSANDRA_CQL_PORT_NUMBER`                        | CQL port                                                                                | `9042`                                |
| `CASSANDRA_JMX_PORT_NUMBER`                        | JMX port                                                                                | `7199`                                |
| `CASSANDRA_TRANSPORT_PORT_NUMBER`                  | Transport port                                                                          | `7000`                                |
| `CASSANDRA_CQL_MAX_RETRIES`                        | Maximum retries for CQL startup operations                                              | `20`                                  |
| `CASSANDRA_CQL_SLEEP_TIME`                         | Sleep time for CQL startup operations                                                   | `5`                                   |
| `CASSANDRA_INIT_MAX_RETRIES`                       | Maximum retries for init startup operations                                             | `100`                                 |
| `CASSANDRA_INIT_SLEEP_TIME`                        | Sleep time for init startup operations                                                  | `5`                                   |
| `CASSANDRA_PEER_CQL_MAX_RETRIES`                   | Maximum retries for peer startup operations                                             | `100`                                 |
| `CASSANDRA_PEER_CQL_SLEEP_TIME`                    | Sleep time for peer startup operations                                                  | `10`                                  |
| `CASSANDRA_DELAY_START_TIME`                       | Delay Cassandra start by the number of provided seconds                                 | `10`                                  |
| `CASSANDRA_AUTO_SNAPSHOT_TTL`                      | Take an automatic snapshot of the data before truncating a keyspace or dropping a table | `30d`                                 |
| `ALLOW_EMPTY_PASSWORD`                             | Allow no credentials in the installation.                                               | `no`                                  |
| `CASSANDRA_AUTHORIZER`                             | Cassandra connection authorizer                                                         | `CassandraAuthorizer`                 |
| `CASSANDRA_AUTHENTICATOR`                          | Cassandra connection authenticator                                                      | `PasswordAuthenticator`               |
| `CASSANDRA_USER`                                   | Cassandra username                                                                      | `cassandra`                           |
| `CASSANDRA_PASSWORD`                               | Cassandra password                                                                      | `nil`                                 |
| `CASSANDRA_KEYSTORE_PASSWORD`                      | Cassandra keystore password                                                             | `cassandra`                           |
| `CASSANDRA_TRUSTSTORE_PASSWORD`                    | Cassandra truststore password                                                           | `cassandra`                           |
| `CASSANDRA_KEYSTORE_LOCATION`                      | Cassandra keystore location                                                             | `${DB_VOLUME_DIR}/secrets/keystore`   |
| `CASSANDRA_TRUSTSTORE_LOCATION`                    | Cassandra truststore location                                                           | `${DB_VOLUME_DIR}/secrets/truststore` |
| `CASSANDRA_TMP_P12_FILE`                           | Cassandra truststore location                                                           | `${DB_TMP_DIR}/keystore.p12`          |
| `CASSANDRA_SSL_CERT_FILE`                          | Cassandra SSL certificate location                                                      | `${DB_VOLUME_DIR}/certs/tls.crt`      |
| `CASSANDRA_SSL_KEY_FILE`                           | Cassandra SSL keyfile location                                                          | `${DB_VOLUME_DIR}/certs/tls.key`      |
| `CASSANDRA_SSL_CA_FILE`                            | Cassandra SSL CA location                                                               | `nil`                                 |
| `CASSANDRA_SSL_VALIDATE`                           | Perform SSL validation on the certificates                                              | `false`                               |
| `SSL_VERSION`                                      | TLS version to use when connecting.                                                     | `TLSv1_2`                             |
| `CASSANDRA_MOUNTED_CONF_DIR`                       | Cassandra directory for mounted configuration files                                     | `${DB_VOLUME_DIR}/conf`               |
| `JAVA_TOOL_OPTIONS`                                | Java tool options.                                                                      | `nil`                                 |

#### Read-only environment variables

| Name                                  | Description                                                                     | Value                                           |
|---------------------------------------|---------------------------------------------------------------------------------|-------------------------------------------------|
| `DB_FLAVOR`                           | Database flavor. Valid values: `cassandra` or `scylladb`.                       | `cassandra`                                     |
| `CASSANDRA_BASE_DIR`                  | Cassandra installation directory                                                | `/opt/bitnami/cassandra`                        |
| `CASSANDRA_BIN_DIR`                   | Cassandra executables directory                                                 | `${DB_BASE_DIR}/bin`                            |
| `CASSANDRA_VOLUME_DIR`                | Persistence base directory                                                      | `/bitnami/cassandra`                            |
| `CASSANDRA_DATA_DIR`                  | Cassandra data directory                                                        | `${DB_VOLUME_DIR}/data`                         |
| `CASSANDRA_COMMITLOG_DIR`             | Cassandra commit log directory                                                  | `${DB_DATA_DIR}/commitlog`                      |
| `CASSANDRA_INITSCRIPTS_DIR`           | Path to the Cassandra container init scripts directory                          | `/docker-entrypoint-initdb.d`                   |
| `CASSANDRA_LOG_DIR`                   | Cassandra logs directory                                                        | `${DB_BASE_DIR}/logs`                           |
| `CASSANDRA_TMP_DIR`                   | Cassandra temporary directory                                                   | `${DB_BASE_DIR}/tmp`                            |
| `JAVA_BASE_DIR`                       | Java base directory                                                             | `${BITNAMI_ROOT_DIR}/java`                      |
| `JAVA_BIN_DIR`                        | Java binary directory                                                           | `${JAVA_BASE_DIR}/bin`                          |
| `PYTHON_BASE_DIR`                     | Python base directory                                                           | `${BITNAMI_ROOT_DIR}/python`                    |
| `PYTHON_BIN_DIR`                      | Python binary directory                                                         | `${PYTHON_BASE_DIR}/bin`                        |
| `CASSANDRA_LOG_FILE`                  | Path to the Cassandra log file                                                  | `${DB_LOG_DIR}/cassandra.log`                   |
| `CASSANDRA_FIRST_BOOT_LOG_FILE`       | Path to the Cassandra first boot log file                                       | `${DB_LOG_DIR}/cassandra_first_boot.log`        |
| `CASSANDRA_INITSCRIPTS_BOOT_LOG_FILE` | Path to the Cassandra init scripts log file                                     | `${DB_LOG_DIR}/cassandra_init_scripts_boot.log` |
| `CASSANDRA_PID_FILE`                  | Path to the Cassandra pid file                                                  | `${DB_TMP_DIR}/cassandra.pid`                   |
| `CASSANDRA_DAEMON_USER`               | Cassandra system user                                                           | `cassandra`                                     |
| `CASSANDRA_DAEMON_GROUP`              | Cassandra system group                                                          | `cassandra`                                     |
| `CASSANDRA_CONF_DIR`                  | Cassandra configuration directory                                               | `${DB_BASE_DIR}/conf`                           |
| `CASSANDRA_DEFAULT_CONF_DIR`          | Cassandra default configuration directory                                       | `${DB_BASE_DIR}/conf.default`                   |
| `CASSANDRA_CONF_FILE`                 | Path to Cassandra configuration file                                            | `${DB_CONF_DIR}/cassandra.yaml`                 |
| `CASSANDRA_RACKDC_FILE`               | Path to Cassandra cassandra-rackdc.properties file                              | `${DB_CONF_DIR}/cassandra-rackdc.properties`    |
| `CASSANDRA_LOGBACK_FILE`              | Path to Cassandra logback.xml file                                              | `${DB_CONF_DIR}/logback.xml`                    |
| `CASSANDRA_COMMITLOG_ARCHIVING_FILE`  | Path to Cassandra commitlog_archiving.properties file                           | `${DB_CONF_DIR}/commitlog_archiving.properties` |
| `CASSANDRA_ENV_FILE`                  | Path to Cassandra cassandra-env.sh file                                         | `${DB_CONF_DIR}/cassandra-env.sh`               |
| `CASSANDRA_MOUNTED_CONF_PATH`         | Relative path (in mounted volume) to Cassandra configuration file               | `cassandra.yaml`                                |
| `CASSANDRA_MOUNTED_RACKDC_PATH`       | Relative path (in mounted volume) to Cassandra cassandra-rackdc-properties file | `cassandra-rackdc.properties`                   |
| `CASSANDRA_MOUNTED_ENV_PATH`          | Relative path (in mounted volume) to Cassandra cassandra-env.sh file            | `cassandra-env.sh`                              |
| `CASSANDRA_MOUNTED_LOGBACK_PATH`      | Path to Cassandra logback.xml file                                              | `logback.xml`                                   |

Additionally, any environment variable beginning with the following prefix will be mapped to its corresponding Apache Cassandra key in the proper file:

* `CASSANDRA_CFG_ENV_`: Will add the corresponding key and the provided value to `cassandra-env.sh`.
* `CASSANDRA_CFG_RACKDC_`: Will add the corresponding key and the provided value to `cassandra-rackdc.properties`.
* `CASSANDRA_CFG_COMMITLOG_`: Will add the corresponding key and the provided value to `commitlog_archiving.properties`.
* `CASSANDRA_CFG_YAML_`: Will add the corresponding key and the provided value to `cassandra.yaml`.

For example, use `CASSANDRA_CFG_RACKDC_PREFER_LOCAL=true` in order to configure `prefer_local` in `cassandra-rackdc.properties`. Or, use `CASSANDRA_CFG_YAML_INTERNODE_COMPRESSION=all` in order to set `internode_compression` to `all` in `cassandra.yaml`.

**NOTE:** Environment variables will be omitted when mounting a configuration file

When you start the cassandra image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. If you want to add a new environment variable:

* For docker-compose add the variable name and value under the application section:

```yaml
cassandra:
  image: bitnami/cassandra:latest
  environment:
    - CASSANDRA_TRANSPORT_PORT_NUMBER=7000
```

* For manual execution add a `-e` option with each variable and value:

```console
 $ docker run --name cassandra -d -p 7000:7000 --network=cassandra_network \
    -e CASSANDRA_TRANSPORT_PORT_NUMBER=7000 \
    -v /your/local/path/bitnami/cassandra:/bitnami \
    bitnami/cassandra
```

### Setting the server password on first run

Passing the `CASSANDRA_PASSWORD` environment variable along with `CASSANDRA_PASSWORD_SEEDER=yes` when running the image for the first time will set the Apache Cassandra server password to the value of `CASSANDRA_PASSWORD`.

```console
docker run --name cassandra \
    -e CASSANDRA_PASSWORD_SEEDER=yes \
    -e CASSANDRA_PASSWORD=password123 \
    bitnami/cassandra:latest
```

or using Docker Compose:

```yaml
cassandra:
  image: bitnami/cassandra:latest
  environment:
    - CASSANDRA_PASSWORD_SEEDER=yes
    - CASSANDRA_PASSWORD=password123
```

#### Step 1: Create a new network

```console
docker network create cassandra_network
```

#### Step 2: Create a first node

```console
docker run --name cassandra-node1 \
  --net=cassandra_network \
  -p 9042:9042 \
  -e CASSANDRA_CLUSTER_NAME=cassandra-cluster \
  -e CASSANDRA_SEEDS=cassandra-node1,cassandra-node2 \
  -e CASSANDRA_PASSWORD_SEEDER=yes \
  -e CASSANDRA_PASSWORD=mypassword \
  bitnami/cassandra:latest
```

In the above command the container is added to a cluster named `cassandra-cluster` using the `CASSANDRA_CLUSTER_NAME`. The `CASSANDRA_CLUSTER_HOSTS` parameter set the name of the nodes that set the cluster so we will need to launch other container for the second node. Finally the `CASSANDRA_NODE_NAME` parameter allows to indicate a known name for the node, otherwise cassandra will generate a random one.

#### Step 3: Create a second node

```console
docker run --name cassandra-node2 \
  --net=cassandra_network \
  -e CASSANDRA_CLUSTER_NAME=cassandra-cluster \
  -e CASSANDRA_SEEDS=cassandra-node1,cassandra-node2 \
  -e CASSANDRA_PASSWORD=mypassword \
  bitnami/cassandra:latest
```

In the above command a new cassandra node is being added to the cassandra cluster indicated by `CASSANDRA_CLUSTER_NAME`.

You now have a two node Apache Cassandra cluster up and running which can be scaled by adding/removing nodes.

With Docker Compose the cluster configuration can be setup using:

```yaml
version: '2'
services:
  cassandra-node1:
    image: bitnami/cassandra:latest
    environment:
      - CASSANDRA_CLUSTER_NAME=cassandra-cluster
      - CASSANDRA_SEEDS=cassandra-node1,cassandra-node2
      - CASSANDRA_PASSWORD_SEEDER=yes
      - CASSANDRA_PASSWORD=password123

  cassandra-node2:
    image: bitnami/cassandra:latest
    environment:
      - CASSANDRA_CLUSTER_NAME=cassandra-cluster
      - CASSANDRA_SEEDS=cassandra-node1,cassandra-node2
      - CASSANDRA_PASSWORD=password123
```

### Initializing with custom scripts

When the container is executed for the first time, it will execute the files with extensions `.sh`, `.cql` or `.cql.gz` located at `/docker-entrypoint-initdb.d` in sort'ed order by filename. This behavior can be skipped by setting the environment variable `CASSANDRA_IGNORE_INITDB_SCRIPTS` to a value other than `yes` or `true`.

In order to have your custom files inside the docker image you can mount them as a volume.

```console
docker run --name cassandra \
  -v /path/to/init-scripts:/docker-entrypoint-initdb.d \
  -v /path/to/cassandra-persistence:/bitnami
  bitnami/cassandra:latest
```

Or with docker-compose

```yaml
cassandra:
  image: bitnami/cassandra:latest
  volumes:
    - /path/to/init-scripts:/docker-entrypoint-initdb.d
    - /path/to/cassandra-persistence:/bitnami
```

### Configuration file

The image looks for configurations in `/bitnami/cassandra/conf/`. As mentioned in [Persisting your application](#persisting-your-application) you can mount a volume at `/bitnami` and copy/edit the configurations in the `/path/to/cassandra-persistence/cassandra/conf/`. The default configurations will be populated to the `conf/` directory if it's empty.

#### Step 1: Run the Apache Cassandra image

Run the Apache Cassandra image, mounting a directory from your host.

```console
docker run --name cassandra \
    -v /path/to/cassandra-persistence:/bitnami \
    bitnami/cassandra:latest
```

or using Docker Compose:

```yaml
cassandra:
  image: bitnami/cassandra:latest
  volumes:
    - /path/to/cassandra-persistence:/bitnami
```

#### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```console
vi /path/to/cassandra-persistence/cassandra/conf/cassandra.yaml
```

#### Step 3: Restart Apache Cassandra

After changing the configuration, restart your Apache Cassandra container for changes to take effect.

```console
docker restart cassandra
```

or using Docker Compose:

```console
docker-compose restart cassandra
```

Refer to the [configuration](http://docs.datastax.com/en/cassandra/3.x/cassandra/configuration/configTOC.html) manual for the complete list of configuration options.

## TLS Encryption

The Bitnami Apache Cassandra Docker image allows configuring TLS encryption between nodes and between server-client. This is done by mounting in `/bitnami/cassandra/secrets` two files:

* `keystore`: File with the server keystore
* `truststore`: File with the server truststore

Apart from that, the following environment variables must be set:

* `CASSANDRA_KEYSTORE_PASSWORD`: Password for accessing the keystore.
* `CASSANDRA_TRUSTSTORE_PASSWORD`: Password for accessing the truststore.
* `CASSANDRA_INTERNODE_ENCRYPTION`: Sets the type of encryption between nodes. The default value is `none`. Can be set to `all`, `none`, `dc` or `rack`.
* `CASSANDRA_CLIENT_ENCRYPTION`: Enables client-server encryption. The default value is `false`.

## Logging

The Bitnami Apache Cassandra Docker image sends the container logs to the `stdout`. To view the logs:

```console
docker logs cassandra
```

or using Docker Compose:

```console
docker-compose logs cassandra
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of Apache Cassandra, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/cassandra:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/cassandra:latest`.

#### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
docker stop cassandra
```

or using Docker Compose:

```console
docker-compose stop cassandra
```

Next, take a snapshot of the persistent volume `/path/to/cassandra-persistence` using:

```console
rsync -a /path/to/cassandra-persistence /path/to/cassandra-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

#### Step 3: Remove the currently running container

```console
docker rm -v cassandra
```

or using Docker Compose:

```console
docker-compose rm -v cassandra
```

#### Step 4: Run the new image

Re-create your container from the new image.

```console
docker run --name cassandra bitnami/cassandra:latest
```

or using Docker Compose:

```console
docker-compose up cassandra
```

## Notable Changes

## 3.11.10-debian-10-r81 Split branch 3

* Branch 3 has been split into branch 3.0 and 3.11 mirroring the upstream Apache Cassandra repo.

### 3.11.4-debian-9-r188 and 3.11.4-ol-7-r201

* Decrease the size of the container. The configuration logic is now based on Bash scripts in the `rootfs/` folder.

### 3.11.3-r129

-The Apache Cassandra container now adds the possibility to inject custom initialization scripts by mounting cql and sh files in `/docker-entrypoint-initdb.d`. See [this section](#initializing-with-custom-scripts) for more information.

### 3.11.2-r22

* The Apache Cassandra container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the Apache Cassandra daemon was started as the `cassandra` user. From now on, both the container and the Apache Cassandra daemon run as user `1001`. As a consequence, the data directory must be writable by that user. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/cassandra).

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
