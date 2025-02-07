# MongoDB&reg; Sharded packaged by Bitnami

## What is MongoDB&reg; Sharded?

> MongoDB&reg; is an open source NoSQL database that uses JSON for data storage. MongoDB&trade; Sharded improves scalability and reliability for large datasets by distributing data across multiple machines.

[Overview of MongoDB&reg; Sharded](http://www.mongodb.org)
Disclaimer: The respective trademarks mentioned in the offering are owned by the respective companies. We do not provide a commercial license for any of these products. This listing has an open-source license. MongoDB(R) is run and maintained by MongoDB, which is a completely separate project from Bitnami.

## TL;DR

```console
docker run --name mongodb bitnami/mongodb-sharded:latest
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use MongoDB&reg; Sharded in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## How to deploy MongoDB&reg; Sharded in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami MongoDB&reg; Sharded Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/mongodb-sharded).

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

The recommended way to get the Bitnami MongoDB&reg; Sharded Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/mongodb-sharded).

```console
docker pull bitnami/mongodb-sharded:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/mongodb-sharded/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/mongodb-sharded:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Persisting your database

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should create a directory and mount it at the `/bitnami/mongodb` path. If the mounted directory is empty, it will be initialized on the first run. As this is a non-root container, directory must have read/write permissions for the UID 1001.

```console
docker run \
    -v /path/to/mongodb-persistence:/bitnami/mongodb \
    bitnami/mongodb-sharded:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/mongodb-sharded/docker-compose.yml) file present in this repository:

* Create directories to hold the persistence data. At minimum you will need one directory for each mongo instance running in the sharded cluster. For example, that means one directory for mongos, mongocfg and mongoshard. You need to assign read write permission to UID 1001 (ie. mkdir [directory] && chown 1001:1001 [directory] && chmod 777 [directory]) to all directories.

```yaml
services:
  mongodb-sharded:
  ...
    volumes:
      - /path/to/mongos-persistence:/bitnami
  ...
  mongodb-shard0:
  ...
    volumes:
      - /path/to/mongoshard-persistence:/bitnami
  ...
  mongodb-cfg:
  ...
    volumes:
      - /path/to/mongocfg-persistence:/bitnami
  ...
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
| `MONGODB_SHARDING_MODE`                 | MongoDB Sharding mode. Can be one of shardsvr, configsvr or mongos                                                                             | `nil`                               |
| `MONGODB_CFG_REPLICA_SET_NAME`          | MongoDB config server replica set name. Mandatory for configuring mongos                                                                       | `nil`                               |
| `MONGODB_CFG_PRIMARY_HOST`              | MongoDB config server replica set primary host. Mandatory for configuring mongos                                                               | `nil`                               |
| `MONGODB_CFG_PRIMARY_PORT_NUMBER`       | MongoDB config server primary host port. Mandatory for shardsvr mode                                                                           | `27017`                             |
| `MONGODB_MONGOS_HOST`                   | MongoDB mongos host. Mandatory for shardsvr mode                                                                                               | `nil`                               |
| `MONGODB_MONGOS_PORT_NUMBER`            | MongoDB mongos port. Mandatory for shardsvr mode                                                                                               | `27017`                             |

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
| `MONGODB_MONGOS_TEMPLATES_FILE`           | Path to MongoDB Sharded template file                                  | `$MONGODB_TEMPLATES_DIR/mongos.conf.tpl`  |
| `MONGODB_MONGOS_CONF_FILE`                | MongoDB mongos configuration file. Used by mongos node                 | `$MONGODB_CONF_DIR/mongos.conf`           |

### Setting up a sharded cluster

In a sharded cluster, there are [three components](https://docs.mongodb.com/manual/sharding/#sharded-cluster):

* Mongos: Interface between the applications and the sharded database.
* Config Servers: Stores metadata and configuration settings for the sharded database.
* Shards: Contains a subset of the data.

A [sharded cluster](https://docs.mongodb.com/manual/sharding/#sharded-cluster) can easily be setup with the Bitnami MongoDB&reg; Sharded Docker Image using the following environment variables:

* `MONGODB_SHARDING_MODE`: The sharding mode. Possible values: `mongos`/`configsvr`/`shardsvr`. No defaults.
* `MONGODB_REPLICA_SET_NAME`: MongoDB&reg; replica set name. In a sharded cluster we will have multiple replica sets. Default: **replicaset**
* `MONGODB_MONGOS_HOST`: MongoDB&reg; mongos instance host. No defaults.
* `MONGODB_CFG_REPLICA_SET_NAME`: MongoDB&reg; config server replica set name. In a sharded cluster we will have multiple replica sets. Default: **replicaset**
* `MONGODB_CFG_PRIMARY_HOST`: MongoDB&reg; config server primary host. No defaults.
* `MONGODB_ADVERTISED_HOSTNAME`: MongoDB&reg; advertised hostname. No defaults. It is recommended to pass this environment variable if you experience issues with ephemeral IPs. Setting this env var makes the nodes of the replica set to be configured with a hostname instead of the machine IP.
* `MONGODB_REPLICA_SET_KEY`: MongoDB&reg; replica set key. Length should be greater than 5 characters and should not contain any special characters. Required for all nodes in the sharded cluster. No default.
* `MONGODB_ROOT_PASSWORD`: MongoDB&reg; root password. No defaults.
* `MONGODB_REPLICA_SET_MODE`: The replication mode. Possible values `primary`/`secondary`/`arbiter`. No defaults.

#### Step 1: Create the config server replica set

The first step is to start the MongoDB&reg; primary config server.

```console
docker run --name mongodb-configsvr-primary \
  -e MONGODB_SHARDING_MODE=configsvr \
  -e MONGODB_REPLICA_SET_MODE=primary \
  -e MONGODB_ROOT_PASSWORD=password123 \
  -e MONGODB_REPLICA_SET_KEY=replicasetkey123 \
  -e MONGODB_REPLICA_SET_NAME=config-replicaset \
   bitnami/mongodb-sharded:latest
```

In the above command the container is configured as Config server using the `MONGODB_SHARDING_MODE` parameter and as `primary` using the `MONGODB_REPLICA_SET_MODE` parameter. You can configure secondary nodes by following the [Bitnami MongoDB&reg; container replication guide](https://github.com/bitnami/containers/blob/main/bitnami/mongodb#setting-up-replication).

#### Step 2: Create the mongos instance

Next we start a MongoDB&reg; mongos server and connect it to the config server replica set.

```console
docker run --name mongos \
  --link mongodb-configsvr-primary:cfg-primary \
  -e MONGODB_SHARDING_MODE=mongos \
  -e MONGODB_CFG_PRIMARY_HOST=cfg-primary \
  -e MONGODB_CFG_REPLICA_SET_NAME=config-replicaset \
  -e MONGODB_REPLICA_SET_KEY=replicasetkey123 \
  -e MONGODB_ROOT_PASSWORD=password123 \
  bitnami/mongodb-sharded:latest
```

In the above command the container is configured as a `mongos` using the `MONGODB_SHARDING_MODE` parameter. The `MONGODB_CFG_PRIMARY_HOST`, `MONGODB_REPLICA_SET_KEY`, `MONGODB_CFG_REPLICA_SET_NAME` and `MONGODB_ROOT_PASSWORD` parameters are used connect and with the MongoDB&reg; primary config server.

#### Step 3: Create a shard

Finally we start a MongoDB&reg; data shard container.

```console
docker run --name mongodb-shard0-primary \
  --link mongodb-configsvr-primary:cfg-primary \
  --link mongos:mongos \
  -e MONGODB_SHARDING_MODE=shardsvr \
  -e MONGODB_MONGOS_HOST=mongos \
  -e MONGODB_ROOT_PASSWORD=password123 \
  -e MONGODB_REPLICA_SET_MODE=primary \
  -e MONGODB_REPLICA_SET_KEY=replicasetkey123 \
  -e MONGODB_REPLICA_SET_NAME=shard0 \
  bitnami/mongodb-sharded:latest
```

In the above command the container is configured as a data shard using the `MONGODB_SHARDING_MODE` parameter. The `MONGODB_MONGOS_HOST`,  `MONGODB_ROOT_PASSWORD` and `MONGODB_REPLICA_SET_KEY` parameters are used connect and with the Mongos instance. You can configure secondary nodes by following the [Bitnami MongoDB&reg; container replication guide](https://github.com/bitnami/containers/blob/main/bitnami/mongodb#setting-up-replication).

You now have a sharded MongoDB&reg; cluster up and running. You can add more shards by repeating step 3. Make sure you set a different `MONGODB_REPLICA_SET_NAME` value. You can also add more mongos instances by repeating step 2.

With Docker Compose the sharded cluster can be setup using:

```yaml
version: '2'

services:
  mongos:
    image: 'bitnami/mongodb-sharded:latest'
    environment:
      - MONGODB_SHARDING_MODE=mongos
      - MONGODB_CFG_PRIMARY_HOST=mongodb-cfg
      - MONGODB_CFG_REPLICA_SET_NAME=cfgreplicaset
      - MONGODB_REPLICA_SET_KEY=replicasetkey123
      - MONGODB_ROOT_PASSWORD=password123
    ports:
      - "27017:27017"

  mongodb-shard0-primary:
    image: 'bitnami/mongodb-sharded:latest'
    environment:
      - MONGODB_SHARDING_MODE=shardsvr
      - MONGODB_MONGOS_HOST=mongos
      - MONGODB_ROOT_PASSWORD=password123
      - MONGODB_REPLICA_SET_MODE=primary
      - MONGODB_REPLICA_SET_KEY=replicasetkey123
      - MONGODB_REPLICA_SET_NAME=shard0
    volumes:
      - 'shard0_data:/bitnami'

  mongodb-configsvr-primary:
    image: 'bitnami/mongodb-sharded:latest'
    environment:
      - MONGODB_SHARDING_MODE=configsvr
      - MONGODB_ROOT_PASSWORD=password123
      - MONGODB_REPLICA_SET_MODE=primary
      - MONGODB_REPLICA_SET_KEY=replicasetkey123
      - MONGODB_REPLICA_SET_NAME=config-replicaset
    volumes:
      - 'cfg_data:/bitnami'

volumes:
  shard0_data:
    driver: local
  cfg_data:
    driver: local
```

### More MongoDB&reg; configuration settings

The Bitnami MongoDB&reg; Sharded image contains the [same configuration features than the Bitnami MongoDB&reg; image](https://github.com/bitnami/containers/blob/main/bitnami/mongodb#configuration).

## Logging

The Bitnami MongoDB&reg; Sharded Docker image sends the container logs to the `stdout`. To view the logs:

```console
docker logs mongodb-sharded
```

or using Docker Compose:

```console
docker-compose logs mongodb-sharded
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of MongoDB&reg;, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/mongodb-sharded:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/mongodb-sharded:latest`.

#### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
docker stop mongodb-sharded
```

or using Docker Compose:

```console
docker-compose stop mongodb-sharded
```

Next, take a snapshot of the persistent volume `/path/to/mongodb-persistence` using:

```console
rsync -a /path/to/mongodb-persistence /path/to/mongodb-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

You can use this snapshot to restore the database state should the upgrade fail.

#### Step 3: Remove the currently running container

```console
docker rm -v mongodb-sharded
```

or using Docker Compose:

```console
docker-compose rm -v mongodb-sharded
```

#### Step 4: Run the new image

Re-create your container from the new image.

```console
docker run --name mongodb bitnami/mongodb-sharded:latest
```

or using Docker Compose:

```console
docker-compose up mongodb-sharded
```

## Notable Changes

### 4.4.8-debian-10-r32, and 5.0.2-debian-10-r0

* From now on, "Default Write Concern" need to be set before adding new members (secondary, arbiter or hidden) to the cluster. In order to maintain the safest default configuration, `{"setDefaultRWConcern" : 1, "defaultWriteConcern" : {"w" : "majority"}}` is configured before adding new members. See <https://docs.mongodb.com/manual/reference/command/setDefaultRWConcern/> and <https://docs.mongodb.com/v5.0/reference/mongodb-defaults/#default-write-concern>

### 3.6.16-centos-7-r49, 4.0.14-centos-7-r29, and 4.2.2-centos-7-r41

* `3.6.16-centos-7-r49`, `4.0.14-centos-7-r29`, and `4.2.2-centos-7-r41` are considered the latest images based on CentOS.
* Standard supported distros: Debian & OEL.

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/mongodb-sharded).

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
