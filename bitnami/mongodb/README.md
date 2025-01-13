# MongoDB&reg; packaged by Bitnami

## What is MongoDB&reg;?

> MongoDB&reg; is a relational open source NoSQL database. Easy to use, it stores data in JSON-like documents. Automated scalability and high-performance. Ideal for developing cloud native applications.

[Overview of MongoDB&reg;](http://www.mongodb.org)
Disclaimer: The respective trademarks mentioned in the offering are owned by the respective companies. We do not provide a commercial license for any of these products. This listing has an open-source license. MongoDB(R) is run and maintained by MongoDB, which is a completely separate project from Bitnami.

## TL;DR

```console
docker run --name mongodb bitnami/mongodb:latest
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use MongoDB&reg; in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## How to deploy MongoDB&reg; in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami MongoDB&reg; Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/mongodb).

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

The recommended way to get the Bitnami MongoDB&reg; Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/mongodb).

```console
docker pull bitnami/mongodb:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/mongodb/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/mongodb:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Persisting your database

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/mongodb` path. If the mounted directory is empty, it will be initialized on the first run.

```console
docker run \
    -v /path/to/mongodb-persistence:/bitnami/mongodb \
    bitnami/mongodb:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/mongodb/docker-compose.yml) file present in this repository:

```diff
 ...
 services:
   mongodb:
     ...
     volumes:
-      - 'mongodb_data:/bitnami/mongodb'
+      - /path/to/mongodb-persistence:/bitnami/mongodb
   ...
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a MongoDB&reg; server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

In this example, we will create a MongoDB&reg; client instance that will connect to the server instance that is running on the same docker network as the client.

#### Step 1: Create a network

```console
docker network create app-tier --driver bridge
```

#### Step 2: Launch the MongoDB&reg; server instance

Use the `--network app-tier` argument to the `docker run` command to attach the MongoDB&reg; container to the `app-tier` network.

```console
docker run -d --name mongodb-server \
    --network app-tier \
    bitnami/mongodb:latest
```

#### Step 3: Launch your MongoDB&reg; client instance

Finally we create a new container instance to launch the MongoDB&reg; client and connect to the server created in the previous step:

```console
docker run -it --rm \
    --network app-tier \
    bitnami/mongodb:latest mongo --host mongodb-server
```

### Using a Docker Compose file

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `app-tier`. In this example we assume that you want to connect to the MongoDB&reg; server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge

services:
  mongodb:
    image: 'bitnami/mongodb:latest'
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
> 2. In your application container, use the hostname `mongodb` to connect to the MongoDB&reg; server

Launch the containers using:

```console
docker-compose up -d
```

## Configuration

### Environment variables

#### Customizable environment variables

| Name                                    | Description                                                                                                                                    | Default Value                       |
|-----------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------|
| `MONGODB_MOUNTED_CONF_DIR`              | Directory for including custom configuration files (that override the default generated ones)                                                  | `${MONGODB_VOLUME_DIR}/conf`        |
| `MONGODB_INIT_RETRY_ATTEMPTS`           | Maximum retries for checking the service initialization status                                                                                 | `7`                                 |
| `MONGODB_INIT_RETRY_DELAY`              | Time (in seconds) to wait between retries for checking the service initialization status                                                       | `5`                                 |
| `MONGODB_PORT_NUMBER`                   | MongoDB port                                                                                                                                   | `$MONGODB_DEFAULT_PORT_NUMBER`      |
| `MONGODB_ENABLE_MAJORITY_READ`          | Enable majority read in MongoDB operations                                                                                                     | `true`                              |
| `MONGODB_DEFAULT_ENABLE_MAJORITY_READ`  | Enable majority read in MongoDB operations set at build time                                                                                   | `true`                              |
| `MONGODB_EXTRA_FLAGS`                   | Extra flags for MongoDB initialization                                                                                                         | `nil`                               |
| `MONGODB_ENABLE_NUMACTL`                | Execute commands using numactl                                                                                                                 | `false`                             |
| `MONGODB_SHELL_EXTRA_FLAGS`             | Extra flags when using the mongodb client during initialization (useful when mounting init scripts)                                            | `nil`                               |
| `MONGODB_ADVERTISED_HOSTNAME`           | Hostname to use for advertising the MongoDB service                                                                                            | `nil`                               |
| `MONGODB_ADVERTISE_IP`                  | Whether advertised hostname is set to container ip                                                                                             | `false`                             |
| `MONGODB_ADVERTISED_PORT_NUMBER`        | MongoDB advertised port number. It is recommended to pass this environment variable if you have a proxy port forwarding requests to container. | `nil`                               |
| `MONGODB_DISABLE_JAVASCRIPT`            | Disable MongoDB server-side javascript execution                                                                                               | `no`                                |
| `MONGODB_ENABLE_JOURNAL`                | Enable MongoDB journal                                                                                                                         | `nil`                               |
| `MONGODB_DISABLE_SYSTEM_LOG`            | Disable MongoDB daemon system log                                                                                                              | `nil`                               |
| `MONGODB_ENABLE_DIRECTORY_PER_DB`       | Use a separate folder for storing each database data                                                                                           | `nil`                               |
| `MONGODB_ENABLE_IPV6`                   | Use IPv6 for database connections                                                                                                              | `nil`                               |
| `MONGODB_SYSTEM_LOG_VERBOSITY`          | MongoDB daemon log level                                                                                                                       | `nil`                               |
| `MONGODB_ROOT_USER`                     | User name for the MongoDB root user                                                                                                            | `root`                              |
| `MONGODB_ROOT_PASSWORD`                 | Password for the MongoDB root user                                                                                                             | `nil`                               |
| `MONGODB_USERNAME`                      | User to generate at initialization time                                                                                                        | `nil`                               |
| `MONGODB_PASSWORD`                      | Password for the non-root user specified in MONGODB_USERNAME                                                                                   | `nil`                               |
| `MONGODB_DATABASE`                      | Name of the database to create at initialization time                                                                                          | `nil`                               |
| `MONGODB_METRICS_USERNAME`              | User used for metrics collection, for example with mongodb_exporter                                                                            | `nil`                               |
| `MONGODB_METRICS_PASSWORD`              | Password for the non-root user specified in MONGODB_METRICS_USERNAME                                                                           | `nil`                               |
| `MONGODB_EXTRA_USERNAMES`               | Comma or semicolon separated list of extra users to be created.                                                                                | `nil`                               |
| `MONGODB_EXTRA_PASSWORDS`               | Comma or semicolon separated list of passwords for the users specified in MONGODB_EXTRA_USERNAMES.                                             | `nil`                               |
| `MONGODB_EXTRA_DATABASES`               | Comma or semicolon separated list of databases to create at initialization time for the users specified in MONGODB_EXTRA_USERNAMES.            | `nil`                               |
| `ALLOW_EMPTY_PASSWORD`                  | Permit accessing MongoDB without setting any password                                                                                          | `no`                                |
| `MONGODB_REPLICA_SET_MODE`              | MongoDB replica set mode. Can be one of primary, secondary or arbiter                                                                          | `nil`                               |
| `MONGODB_REPLICA_SET_NAME`              | Name of the MongoDB replica set                                                                                                                | `$MONGODB_DEFAULT_REPLICA_SET_NAME` |
| `MONGODB_REPLICA_SET_KEY`               | MongoDB replica set key                                                                                                                        | `nil`                               |
| `MONGODB_INITIAL_PRIMARY_HOST`          | Hostname of the replica set primary node (necessary for arbiter and secondary nodes)                                                           | `nil`                               |
| `MONGODB_INITIAL_PRIMARY_PORT_NUMBER`   | Port of the replica set primary node (necessary for arbiter and secondary nodes)                                                               | `27017`                             |
| `MONGODB_INITIAL_PRIMARY_ROOT_PASSWORD` | Primary node root user password (necessary for arbiter and secondary nodes)                                                                    | `nil`                               |
| `MONGODB_INITIAL_PRIMARY_ROOT_USER`     | Primary node root username (necessary for arbiter and secondary nodes)                                                                         | `root`                              |
| `MONGODB_SET_SECONDARY_OK`              | Mark node as readable. Necessary for cases where the PVC is lost                                                                               | `no`                                |
| `MONGODB_DISABLE_ENFORCE_AUTH`          | By default, MongoDB authentication will be enforced. If set to true, MongoDB will not enforce authentication                                   | `false`                             |

#### Read-only environment variables

| Name                                      | Description                                                            | Value                                     |
|-------------------------------------------|------------------------------------------------------------------------|-------------------------------------------|
| `MONGODB_VOLUME_DIR`                      | Persistence base directory                                             | `$BITNAMI_VOLUME_DIR/mongodb`             |
| `MONGODB_BASE_DIR`                        | MongoDB installation directory                                         | `$BITNAMI_ROOT_DIR/mongodb`               |
| `MONGODB_CONF_DIR`                        | MongoDB configuration directory                                        | `$MONGODB_BASE_DIR/conf`                  |
| `MONGODB_DEFAULT_CONF_DIR`                | MongoDB default configuration directory                                | `$MONGODB_BASE_DIR/conf.default`          |
| `MONGODB_LOG_DIR`                         | MongoDB logs directory                                                 | `$MONGODB_BASE_DIR/logs`                  |
| `MONGODB_DATA_DIR`                        | MongoDB data directory                                                 | `${MONGODB_VOLUME_DIR}/data`              |
| `MONGODB_TMP_DIR`                         | MongoDB temporary directory                                            | `$MONGODB_BASE_DIR/tmp`                   |
| `MONGODB_BIN_DIR`                         | MongoDB executables directory                                          | `$MONGODB_BASE_DIR/bin`                   |
| `MONGODB_TEMPLATES_DIR`                   | Directory where the mongodb.conf template file is stored               | `$MONGODB_BASE_DIR/templates`             |
| `MONGODB_MONGOD_TEMPLATES_FILE`           | Path to the mongodb.conf template file                                 | `$MONGODB_TEMPLATES_DIR/mongodb.conf.tpl` |
| `MONGODB_CONF_FILE`                       | Path to MongoDB configuration file                                     | `$MONGODB_CONF_DIR/mongodb.conf`          |
| `MONGODB_KEY_FILE`                        | Path to the MongoDB replica set keyfile                                | `$MONGODB_CONF_DIR/keyfile`               |
| `MONGODB_DB_SHELL_FILE`                   | Path to MongoDB dbshell file                                           | `/.dbshell`                               |
| `MONGODB_RC_FILE`                         | Path to MongoDB rc file                                                | `/.mongorc.js`                            |
| `MONGOSH_DIR`                             | Path to mongosh directory                                              | `/.mongodb`                               |
| `MONGOSH_RC_FILE`                         | Path to mongosh rc file                                                | `/.mongoshrc.js`                          |
| `MONGODB_PID_FILE`                        | Path to the MongoDB PID file                                           | `$MONGODB_TMP_DIR/mongodb.pid`            |
| `MONGODB_LOG_FILE`                        | Path to the MongoDB log file                                           | `$MONGODB_LOG_DIR/mongodb.log`            |
| `MONGODB_INITSCRIPTS_DIR`                 | Path to the MongoDB container init scripts directory                   | `/docker-entrypoint-initdb.d`             |
| `MONGODB_DAEMON_USER`                     | MongoDB system user                                                    | `mongo`                                   |
| `MONGODB_DAEMON_GROUP`                    | MongoDB system group                                                   | `mongo`                                   |
| `MONGODB_DEFAULT_PORT_NUMBER`             | MongoDB port set at build time                                         | `27017`                                   |
| `MONGODB_DEFAULT_ENABLE_JOURNAL`          | Enable MongoDB journal at build time                                   | `true`                                    |
| `MONGODB_DEFAULT_DISABLE_SYSTEM_LOG`      | Disable MongoDB daemon system log set at build time                    | `false`                                   |
| `MONGODB_DEFAULT_ENABLE_DIRECTORY_PER_DB` | Use a separate folder for storing each database data set at build time | `false`                                   |
| `MONGODB_DEFAULT_ENABLE_IPV6`             | Use IPv6 for database connections set at build time                    | `false`                                   |
| `MONGODB_DEFAULT_SYSTEM_LOG_VERBOSITY`    | MongoDB daemon log level set at build time                             | `0`                                       |
| `MONGODB_DEFAULT_REPLICA_SET_NAME`        | Name of the MongoDB replica set at build time                          | `replicaset`                              |

### Initializing a new instance

When the container is executed for the first time, it will execute the files with extensions `.sh`, and `.js` located at `/docker-entrypoint-initdb.d`.

In order to have your custom files inside the docker image you can mount them as a volume.

### Passing extra command-line flags to mongod startup

Passing extra command-line flags to the mongod service command is possible through the following env var:

* `MONGODB_EXTRA_FLAGS`: Flags to be appended to the `mongod` startup command. No defaults
* `MONGODB_CLIENT_EXTRA_FLAGS`: Flags to be appended to the `mongo` command which is used to connect to the (local or remote) `mongod` daemon. No defaults

```console
docker run --name mongodb -e ALLOW_EMPTY_PASSWORD=yes -e MONGODB_EXTRA_FLAGS='--wiredTigerCacheSizeGB=2' bitnami/mongodb:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/mongodb/docker-compose.yml) file present in this repository:

```yaml
services:
  mongodb:
  ...
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - MONGODB_EXTRA_FLAGS=--wiredTigerCacheSizeGB=2
  ...
```

### Configuring system log verbosity level

Configuring the system log verbosity level is possible through the following env vars:

* `MONGODB_DISABLE_SYSTEM_LOG`: Whether to enable/disable system log on MongoDB&reg;. Default: `false`. Possible values: `[true, false]`.
* `MONGODB_SYSTEM_LOG_VERBOSITY`: MongoDB&reg; system log verbosity level. Default: `0`. Possible values: `[0, 1, 2, 3, 4, 5]`. For more information about the verbosity levels please refer to the [MongoDB&reg; documentation](https://docs.mongodb.com/manual/reference/configuration-options/#systemLog.verbosity)

```console
docker run --name mongodb -e ALLOW_EMPTY_PASSWORD=yes -e MONGODB_SYSTEM_LOG_VERBOSITY='3' bitnami/mongodb:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/mongodb/docker-compose.yml) file present in this repository:

```yaml
services:
  mongodb:
  ...
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - MONGODB_SYSTEM_LOG_VERBOSITY=3
  ...
```

### Using numactl

  In order to enable launching commands using numactl, set the `MONGODB_ENABLE_NUMACTL` variable to true. For more information on this, check the official [MongoDB documentation][(<https://docs.mongodb.com/manual/administration/production-notes/#configuring-numa-on-linux>)

### Enabling/disabling IPv6

Enabling/disabling IPv6 is possible through the following env var:

* `MONGODB_ENABLE_IPV6`: Whether to enable/disable IPv6 on MongoDB&reg;. Default: `false`. Possible values: `[true, false]`

To enable IPv6 support, you can execute:

```console
docker run --name mongodb -e ALLOW_EMPTY_PASSWORD=yes -e MONGODB_ENABLE_IPV6=yes bitnami/mongodb:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/mongodb/docker-compose.yml) file present in this repository:

```yaml
services:
  mongodb:
  ...
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - MONGODB_ENABLE_IPV6=yes
  ...
```

### Enabling/disabling directoryPerDB

Enabling/disabling [directoryPerDB](https://docs.mongodb.com/manual/reference/configuration-options/#storage.directoryPerDB) is possible through the following env var:

* `MONGODB_ENABLE_DIRECTORY_PER_DB`: Whether to enable/disable directoryPerDB on MongoDB&reg;. Default: `true`. Possible values: `[true, false]`

```console
docker run --name mongodb -e ALLOW_EMPTY_PASSWORD=yes -e MONGODB_ENABLE_DIRECTORY_PER_DB=yes bitnami/mongodb:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/mongodb/docker-compose.yml) file present in this repository:

```yaml
services:
  mongodb:
  ...
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - MONGODB_ENABLE_DIRECTORY_PER_DB=yes
  ...
```

### Enabling/disabling journaling

Enabling/disabling [journal](https://docs.mongodb.com/manual/reference/configuration-options/#mongodb-setting-storage.journal.enabled) is possible through the following env var:

* `MONGODB_ENABLE_JOURNAL`: Whether to enable/disable journaling on MongoDB&reg;. Default: `true`. Possible values: `[true, false]`

```console
docker run --name mongodb -e ALLOW_EMPTY_PASSWORD=yes -e MONGODB_ENABLE_JOURNAL=true bitnami/mongodb:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/mongodb/docker-compose.yml) file present in this repository:

```yaml
services:
  mongodb:
  ...
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - MONGODB_ENABLE_JOURNAL=true
  ...
```

### Setting the root user and password on first run

Passing the `MONGODB_ROOT_PASSWORD` environment variable when running the image for the first time will set the password of `MONGODB_ROOT_USER` to the value of `MONGODB_ROOT_PASSWORD` and enable authentication on the MongoDB&reg; server. If unset, `MONGODB_ROOT_USER` defaults to `root`.

```console
docker run --name mongodb \
  -e MONGODB_ROOT_PASSWORD=password123 bitnami/mongodb:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/mongodb/docker-compose.yml) file present in this repository:

```yaml
services:
  mongodb:
  ...
    environment:
      - MONGODB_ROOT_PASSWORD=password123
  ...
```

The `MONGODB_ROOT_USER` user is configured to have full administrative access to the MongoDB&reg; server. When `MONGODB_ROOT_PASSWORD` is not specified the server allows unauthenticated and unrestricted access.

### Creating a user and database on first run

You can create a user with restricted access to a database while starting the container for the first time. To do this, provide the `MONGODB_USERNAME`, `MONGODB_PASSWORD` and `MONGODB_DATABASE` environment variables.

```console
docker run --name mongodb \
  -e MONGODB_USERNAME=my_user -e MONGODB_PASSWORD=password123 \
  -e MONGODB_DATABASE=my_database bitnami/mongodb:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/mongodb/docker-compose.yml) file present in this repository:

```yaml
services:
  mongodb:
  ...
    environment:
      - MONGODB_USERNAME=my_user
      - MONGODB_PASSWORD=password123
      - MONGODB_DATABASE=my_database
  ...
```

**Note!**
Creation of a user enables authentication on the MongoDB&reg; server and as a result unauthenticated access by *any* user is not permitted.

### Setting up replication

A [replication](https://docs.mongodb.com/manual/replication/) cluster can easily be setup with the Bitnami MongoDB&reg; Docker Image using the following environment variables:

* `MONGODB_REPLICA_SET_MODE`: The replication mode. Possible values `primary`/`secondary`/`arbiter`. No defaults.
* `MONGODB_REPLICA_SET_NAME`: MongoDB&reg; replica set name. Default: **replicaset**
* `MONGODB_PORT_NUMBER`: The port each MongoDB&reg; will use. Default: **27017**
* `MONGODB_INITIAL_PRIMARY_HOST`: MongoDB&reg; initial primary host, once the replicaset is created any node can be eventually promoted to be the primary. No defaults.
* `MONGODB_INITIAL_PRIMARY_PORT_NUMBER`: MongoDB&reg; initial primary node port, as seen by other nodes. Default: **27017**
* `MONGODB_ADVERTISED_HOSTNAME`: MongoDB&reg; advertised hostname. No defaults. It is recommended to pass this environment variable if you experience issues with ephemeral IPs. Setting this env var makes the nodes of the replica set to be configured with a hostname instead of the machine IP.
* `MONGODB_ADVERTISE_IP`: MongoDB&reg; advertised hostname is set to container ip. Default: **false**. Overrides `MONGODB_ADVERTISED_HOSTNAME`
* `MONGODB_ADVERTISED_PORT_NUMBER`: MongoDB&reg; advertised port number. No defaults. It is recommended to pass this environment variable if you have a proxy port forwarding requests to container.
* `MONGODB_REPLICA_SET_KEY`: MongoDB&reg; replica set key. Length should be greater than 5 characters and should not contain any special characters. Required for all nodes. No default.
* `MONGODB_ROOT_USER`: MongoDB&reg; root user name. Default: **root**.
* `MONGODB_ROOT_PASSWORD`: MongoDB&reg; root password. No defaults. Only for primary node.
* `MONGODB_INITIAL_PRIMARY_ROOT_PASSWORD`: MongoDB&reg; initial primary root password. No defaults. Only for secondaries and arbiter nodes.

In a replication cluster you can have one primary node, zero or more secondary nodes and zero or one arbiter node.

> **Note**: The total number of nodes on a replica set scenario cannot be higher than 8 (1 primary, 6 secondaries and 1 arbiter)

#### Step 1: Create the replication primary

The first step is to start the MongoDB&reg; primary.

```console
docker run --name mongodb-primary \
  -e MONGODB_REPLICA_SET_MODE=primary \
  -e MONGODB_ADVERTISED_HOSTNAME=mongodb-primary \
  -e MONGODB_ROOT_PASSWORD=password123 \
  -e MONGODB_REPLICA_SET_KEY=replicasetkey123 \
  bitnami/mongodb:latest
```

In the above command the container is configured as the `primary` using the `MONGODB_REPLICA_SET_MODE` parameter.

#### Step 2: Create the replication secondary node

Next we start a MongoDB&reg; secondary container.

```console
docker run --name mongodb-secondary \
  --link mongodb-primary:primary \
  -e MONGODB_REPLICA_SET_MODE=secondary \
  -e MONGODB_ADVERTISED_HOSTNAME=mongodb-secondary \
  -e MONGODB_INITIAL_PRIMARY_HOST=mongodb-primary \
  -e MONGODB_INITIAL_PRIMARY_PORT_NUMBER=27017 \
  -e MONGODB_INITIAL_PRIMARY_ROOT_PASSWORD=password123 \
  -e MONGODB_REPLICA_SET_KEY=replicasetkey123 \
  bitnami/mongodb:latest
```

In the above command the container is configured as a `secondary` using the `MONGODB_REPLICA_SET_MODE` parameter. The `MONGODB_INITIAL_PRIMARY_HOST` and `MONGODB_INITIAL_PRIMARY_PORT_NUMBER` parameters are used connect and with the MongoDB&reg; primary.

#### Step 3: Create a replication arbiter node

Finally we start a MongoDB&reg; arbiter container.

```console
docker run --name mongodb-arbiter \
  --link mongodb-primary:primary \
  -e MONGODB_REPLICA_SET_MODE=arbiter \
  -e MONGODB_ADVERTISED_HOSTNAME=mongodb-arbiter \
  -e MONGODB_INITIAL_PRIMARY_HOST=mongodb-primary \
  -e MONGODB_INITIAL_PRIMARY_PORT_NUMBER=27017 \
  -e MONGODB_INITIAL_PRIMARY_ROOT_PASSWORD=password123 \
  -e MONGODB_REPLICA_SET_KEY=replicasetkey123 \
  bitnami/mongodb:latest
```

In the above command the container is configured as a `arbiter` using the `MONGODB_REPLICA_SET_MODE` parameter. The `MONGODB_INITIAL_PRIMARY_HOST` and `MONGODB_INITIAL_PRIMARY_PORT_NUMBER` parameters are used connect and with the MongoDB&reg; primary.

You now have a three node MongoDB&reg; replication cluster up and running which can be scaled by adding/removing secondaries.

#### Optional: Create a replication hidden node

If we want a replication hidden node, we start a MongoDB&reg; hidden container.

```console
docker run --name mongodb-hidden \
  --link mongodb-primary:primary \
  -e MONGODB_REPLICA_SET_MODE=hidden \
  -e MONGODB_ADVERTISED_HOSTNAME=mongodb-hidden \
  -e MONGODB_INITIAL_PRIMARY_HOST=mongodb-primary \
  -e MONGODB_INITIAL_PRIMARY_PORT_NUMBER=27017 \
  -e MONGODB_INITIAL_PRIMARY_ROOT_PASSWORD=password123 \
  -e MONGODB_REPLICA_SET_KEY=replicasetkey123 \
  bitnami/mongodb:latest
```

In the above command the container is configured as a `hidden` using the `MONGODB_REPLICA_SET_MODE` parameter. The `MONGODB_INITIAL_PRIMARY_HOST` and `MONGODB_INITIAL_PRIMARY_PORT_NUMBER` parameters are used connect and with the MongoDB&reg; primary.

With Docker Compose the replicaset can be setup using:

```yaml
version: '2'

services:
  mongodb-primary:
    image: 'bitnami/mongodb:latest'
    environment:
      - MONGODB_ADVERTISED_HOSTNAME=mongodb-primary
      - MONGODB_REPLICA_SET_MODE=primary
      - MONGODB_ROOT_PASSWORD=password123
      - MONGODB_REPLICA_SET_KEY=replicasetkey123

    volumes:
      - 'mongodb_master_data:/bitnami'

  mongodb-secondary:
    image: 'bitnami/mongodb:latest'
    depends_on:
      - mongodb-primary
    environment:
      - MONGODB_ADVERTISED_HOSTNAME=mongodb-secondary
      - MONGODB_REPLICA_SET_MODE=secondary
      - MONGODB_INITIAL_PRIMARY_HOST=mongodb-primary
      - MONGODB_INITIAL_PRIMARY_PORT_NUMBER=27017
      - MONGODB_INITIAL_PRIMARY_ROOT_PASSWORD=password123
      - MONGODB_REPLICA_SET_KEY=replicasetkey123

  mongodb-arbiter:
    image: 'bitnami/mongodb:latest'
    depends_on:
      - mongodb-primary
    environment:
      - MONGODB_ADVERTISED_HOSTNAME=mongodb-arbiter
      - MONGODB_REPLICA_SET_MODE=arbiter
      - MONGODB_INITIAL_PRIMARY_HOST=mongodb-primary
      - MONGODB_INITIAL_PRIMARY_PORT_NUMBER=27017
      - MONGODB_INITIAL_PRIMARY_ROOT_PASSWORD=password123
      - MONGODB_REPLICA_SET_KEY=replicasetkey123

volumes:
  mongodb_master_data:
    driver: local
```

and run docker-compose using:

```console
docker-compose up --detach
```

In the case you want to scale the number of secondary nodes using the docker-compose parameter `--scale`, the MONGODB_ADVERTISED_HOSTNAME must not be set in mongodb-secondary and mongodb-arbiter defintions.

```yaml
version: '2'

services:
  mongodb-primary:
    image: 'bitnami/mongodb:latest'
    environment:
      - MONGODB_ADVERTISED_HOSTNAME=mongodb-primary
      - MONGODB_REPLICA_SET_MODE=primary
      - MONGODB_ROOT_PASSWORD=password123
      - MONGODB_REPLICA_SET_KEY=replicasetkey123

    volumes:
      - 'mongodb_master_data:/bitnami'

  mongodb-secondary:
    image: 'bitnami/mongodb:latest'
    depends_on:
      - mongodb-primary
    environment:
      - MONGODB_REPLICA_SET_MODE=secondary
      - MONGODB_INITIAL_PRIMARY_HOST=mongodb-primary
      - MONGODB_INITIAL_PRIMARY_PORT_NUMBER=27017
      - MONGODB_INITIAL_PRIMARY_ROOT_PASSWORD=password123
      - MONGODB_REPLICA_SET_KEY=replicasetkey123

  mongodb-arbiter:
    image: 'bitnami/mongodb:latest'
    depends_on:
      - mongodb-primary
    environment:
      - MONGODB_REPLICA_SET_MODE=arbiter
      - MONGODB_INITIAL_PRIMARY_HOST=mongodb-primary
      - MONGODB_INITIAL_PRIMARY_PORT_NUMBER=27017
      - MONGODB_INITIAL_PRIMARY_ROOT_PASSWORD=password123
      - MONGODB_REPLICA_SET_KEY=replicasetkey123

volumes:
  mongodb_master_data:
    driver: local
```

And then run docker-compose using:

```console
docker-compose up --detach --scale mongodb-primary=1 --scale mongodb-secondary=3 --scale mongodb-arbiter=1
```

The above command scales up the number of secondary nodes to `3`. You can scale down in the same way.

> **Note**: You should not scale up/down the number of primary nodes. Always have only one primary node running.
> **Note**: In this case, the client has to be in the same docker network to be able to reach all the nodes.

#### How is a replica set configured?

There are four different roles in a replica set configuration (primary, secondary, hidden or arbiter). Each one of these roles are configured in a different way:

**Primary node configuration:**

The replica set is started with the `rs.initiate()` command and some configuration options to force the primary to be the primary. Basically, the priority is increased from the default (1) to 5.
To verify the primary is actually the primary we validate it with the `db.isMaster().ismaster` command.

The primary node has a volume attached so the data is preserved between deployments as long as the volume exists.

In addition, the primary node initialization script will check for the existence of a `.initialized` file in the `/bitnami/mongodb` folder to discern whether it should create a new replica set or on the contrary a replica set has already been initialized.

If the primary got killed and the volume is deleted, in order to start it again in the same replica set it is important to launch the container with the original IP so other members of the replica set already knows about it.

**Secondary node configuration:**

Once the primary node is up and running we can start adding secondary nodes (and arbiter). For that, the secondary node connects to the primary node and add itself as a secondary node with the command `rs.add(SECONDARY_NODE_HOST)`.

After adding the secondary nodes we verified they have been successfully added by executing `rs.status().members` to see if they appear in the list.

**Arbiter node configuration:**

The arbiters follows the same procedure than secondary nodes with the exception that the command to add it to the replica set is `rs.addArb(ARBITER_NODE_HOST)`. An arbiter should be added when the sum of primary nodes plus secondaries nodes is even.

**Hidden node configuration:**

Finally, the hidden node follows the same procedure than secondary nodes with the exception that the command to add it to the replica set is `rs.add(host: HIDDEN_NODE_HOST, hidden: true, priority: 0})`.

### Enabling SSL/TLS

This container supports enabling SSL/TLS between nodes in the cluster, as well as between mongo clients and nodes, by setting the `MONGODB_EXTRA_FLAGS` and `MONGODB_CLIENT_EXTRA_FLAGS` environment variables,
together with the correct `MONGODB_ADVERTISED_HOSTNAME`.
Before starting the cluster you need to generate PEM certificates as required by Mongo - one way is to create self-signed certificates using `openssl` (see <http://www.openssl.org>).

> **The certificates generated as described are not for production use**

Another option would be to use letsencrypt certificates; the required configuration steps for that scenario are left as an exercise for the user and are beyond the scope of this README.

#### Generating self-signed certificates

* Generate a new private key which will be used to create your own Certificate Authority (CA):

```console
openssl genrsa -out mongoCA.key 2048
```

* Create the public certificate for your own CA:

```console
openssl req -x509 -new \
    -subj "/C=US/ST=NY/L=New York/O=Example Corp/OU=IT Department/CN=mongoCA" \
    -key mongoCA.key -out mongoCA.crt
```

* Create a Certificate Signing Request for a node `${NODE_NAME}`, the essential part here is that the `Common Name` corresponds to the hostname by which the nodes will be addressed.
Example for `mongodb-primary`:

```console
export NODE_NAME=mongodb-primary
openssl req -new -nodes \
    -subj "/C=US/ST=NY/L=New York/O=Example Corp/OU=IT Department/CN=${NODE_NAME}" \
    -keyout ${NODE_NAME}.key -out ${NODE_NAME}.csr
```

* Create a certificate from the Certificate Signing Request and sign it using the private key of your previously created Certificate Authority:

```console
openssl x509 \
    -req -days 365 -in ${NODE_NAME}.csr -out ${NODE_NAME}.crt \
    -CA mongoCA.crt -CAkey mongoCA.key -CAcreateserial -extensions req
```

* Create a PEM bundle using the private key and the public certificate:

```console
cat ${NODE_NAME}.key ${NODE_NAME}.crt > ${NODE_NAME}.pem
```

NB: Afterwards you do not need the Certificate Signing Request.

```console
rm ${NODE_NAME}.csr
```

Repeat the process to generate PEM bundles for all the nodes in your cluster.

#### Starting the cluster

After having generated the certificates and making them available to the containers at the correct mount points (i.e. `/certificates/`), the environment variables could be setup as in the following examples.

Example settings for the primary node `mongodb-primary`:

* `MONGODB_ADVERTISED_HOSTNAME=mongodb-primary`
* `MONGODB_EXTRA_FLAGS=--tlsMode=requireTLS --tlsCertificateKeyFile=/certificates/mongodb-primary.pem --tlsClusterFile=/certificates/mongodb-primary.pem --tlsCAFile=/certificates/mongoCA.crt`
* `MONGODB_CLIENT_EXTRA_FLAGS=--tls --tlsCertificateKeyFile=/certificates/mongodb-primary.pem --tlsCAFile=/certificates/mongoCA.crt`

Example corresponding settings for a secondary node `mongodb-secondary`:

* `MONGODB_ADVERTISED_HOSTNAME=mongodb-secondary`
* `MONGODB_EXTRA_FLAGS=--tlsMode=requireTLS --tlsCertificateKeyFile=/certificates/mongodb-secondary.pem --tlsClusterFile=/certificates/mongodb-secondary.pem --tlsCAFile=/certificates/mongoCA.crt`
* `MONGODB_CLIENT_EXTRA_FLAGS=--tls --tlsCertificateKeyFile=/certificates/mongodb-secondary.pem --tlsCAFile=/certificates/mongoCA.crt`

#### Connecting to the mongo daemon via SSL

After successfully starting a cluster as specified, within the container it should be possible to connect to the mongo daemon on the primary node using:

```console
/opt/bitnami/mongodb/bin/mongo -u ${MONGODB_ROOT_USER} -p ${MONGODB_ROOT_PASSWORD} --host mongodb-primary --tls --tlsCertificateKeyFile=/certificates/mongodb-primary.pem --tlsCAFile=/certificates/mongoCA.crt
```

**NB**: We only support `--clusterAuthMode=keyFile` in this configuration.

#### References

* To also allow clients to connect using username and password (without X509 certificates): <https://docs.mongodb.com/manual/reference/configuration-options/#net.ssl.allowConnectionsWithoutCertificates>

* For more extensive information regarding related configuration options: <https://docs.mongodb.com/manual/reference/program/mongod/#tls-ssl-options>,
Especially client authentication and requirements for common name and OU/DN/etc. fields in the certificates are important for creating a secure setup.

### Configuration file

The image looks for mounted configurations files in `/bitnami/mongodb/conf/`. You can mount a volume at `/bitnami/mongodb/conf/` and copy/edit the configurations in the `/path/to/mongodb-configuration-persistence/`. The default configurations will be populated to the `/opt/bitnami/mongodb/conf/` directory if it's empty.

#### Step 1: Run the MongoDB&reg; image

Run the MongoDB&reg; image, mounting a directory from your host.

```console
docker run --name mongodb -v /path/to/mongodb-configuration-persistence:/bitnami/mongodb/conf bitnami/mongodb:latest
```

or using Docker Compose:

```diff
 ...
 services:
   mongodb:
     ...
     volumes:
       - 'mongodb_data:/bitnami/mongodb'
+      - /path/to/mongodb-configuration-persistence:/bitnami/mongodb/conf
   ...
```

#### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```console
vi /path/to/mongodb-configuration-persistence/mongodb.conf
```

#### Step 3: Restart MongoDB&reg;

After changing the configuration, restart your MongoDB&reg; container for changes to take effect.

```console
docker restart mongodb
```

or using Docker Compose:

```console
docker-compose restart mongodb
```

Refer to the [configuration file options](http://docs.mongodb.org/v2.4/reference/configuration-options/) manual for the complete list of MongoDB&reg; configuration options.

## Logging

The Bitnami MongoDB&reg; Docker image sends the container logs to the `stdout`. To view the logs:

```console
docker logs mongodb
```

or using Docker Compose:

```console
docker-compose logs mongodb
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of MongoDB&reg;, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/mongodb:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/mongodb:latest`.

#### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
docker stop mongodb
```

or using Docker Compose:

```console
docker-compose stop mongodb
```

Next, take a snapshot of the persistent volume `/path/to/mongodb-persistence` using:

```console
rsync -a /path/to/mongodb-persistence /path/to/mongodb-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

You can use this snapshot to restore the database state should the upgrade fail.

#### Step 3: Remove the currently running container

```console
docker rm -v mongodb
```

or using Docker Compose:

```console
docker-compose rm -v mongodb
```

#### Step 4: Run the new image

Re-create your container from the new image.

```console
docker run --name mongodb bitnami/mongodb:latest
```

or using Docker Compose:

```console
docker-compose up mongodb
```

## Notable Changes

### 4.4.8-debian-10-r31, and 5.0.2-debian-10-r0

* From now on, "Default Write Concern" need to be set before adding new members (secondary, arbiter or hidden) to the cluster. In order to maintain the safest default configuration, `{"setDefaultRWConcern" : 1, "defaultWriteConcern" : {"w" : "majority"}}` is configured before adding new members. See <https://docs.mongodb.com/manual/reference/command/setDefaultRWConcern/> and <https://docs.mongodb.com/v5.0/reference/mongodb-defaults/#default-write-concern>

### 3.6.14-r69, 4.0.13-r11, and 4.2.1-r12

* The configuration files mount point changed from `/opt/bitnami/mongodb/conf` to `/bitnami/mongodb/conf`.

### 3.6.13-r33, 4.0.10-r42, 4.1.13-r40 and 4.1.13-r41

* `MONGODB_ENABLE_IPV6` set to `false` by default, if you want to enable IPv6, you need to set this environment variable to `true`. You can find more info at the above ["Enabling/disabling IPv6"](#enablingdisabling-ipv6) section.

### 3.6.13-debian-9-r15, 3.6.13-ol-7-r15, 4.0.10-debian-9-r23, 4.0.10-ol-7-r24, 4.1.13-debian-9-r22, 4.1.13-ol-7-r23 or later

* Decrease the size of the container. Node.js is not needed anymore. MongoDB&reg; configuration logic has been moved to bash scripts in the rootfs folder.

### 3.6.9, 4.0.4 and 4.1.5 or later

* All MongoDB&reg; versions released after October 16, 2018 (3.6.9 or later, 4.0.4 or later or 4.1.5 or later) are licensed under the [Server Side Public License](https://www.mongodb.com/licensing/server-side-public-license) that is not currently accepted as a Open Source license by the Open Source Iniciative (OSI).

### 3.6.6-r16 and 4.1.1-r9

* The MongoDB&reg; container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the MongoDB&reg; daemon was started as the `mongo` user. From now on, both the container and the MongoDB&reg; daemon run as user `1001`. As a consequence, the data directory must be writable by that user. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

### 3.2.7-r5

* `MONGODB_USER` parameter has been renamed to `MONGODB_USERNAME`.

### 3.2.6-r0

* All volumes have been merged at `/bitnami/mongodb`. Now you only need to mount a single volume at `/bitnami/mongodb` for persistence.
* The logs are always sent to the `stdout` and are no longer collected in the volume.

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/mongodb).

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
