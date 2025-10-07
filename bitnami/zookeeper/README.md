# Bitnami package for Apache ZooKeeper

## What is Apache ZooKeeper?

> Apache ZooKeeper provides a reliable, centralized register of configuration data and services for distributed applications.

[Overview of Apache ZooKeeper](https://zookeeper.apache.org)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name zookeeper bitnami/zookeeper:latest
```

## ⚠️ Important Notice: Upcoming changes to the Bitnami Catalog

Beginning August 28th, 2025, Bitnami will evolve its public catalog to offer a curated set of hardened, security-focused images under the new [Bitnami Secure Images initiative](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications). As part of this transition:

- Granting community users access for the first time to security-optimized versions of popular container images.
- Bitnami will begin deprecating support for non-hardened, Debian-based software images in its free tier and will gradually remove non-latest tags from the public catalog. As a result, community users will have access to a reduced number of hardened images. These images are published only under the “latest” tag and are intended for development purposes
- Starting August 28th, over two weeks, all existing container images, including older or versioned tags (e.g., 2.50.0, 10.6), will be migrated from the public catalog (docker.io/bitnami) to the “Bitnami Legacy” repository (docker.io/bitnamilegacy), where they will no longer receive updates.
- For production workloads and long-term support, users are encouraged to adopt Bitnami Secure Images, which include hardened containers, smaller attack surfaces, CVE transparency (via VEX/KEV), SBOMs, and enterprise support.

These changes aim to improve the security posture of all Bitnami users by promoting best practices for software supply chain integrity and up-to-date deployments. For more details, visit the [Bitnami Secure Images announcement](https://github.com/bitnami/containers/issues/83267).

## Why use Bitnami Secure Images?

- Bitnami Secure Images and Helm charts are built to make open source more secure and enterprise ready.
- Triage security vulnerabilities faster, with transparency into CVE risks using industry standard Vulnerability Exploitability Exchange (VEX), KEV, and EPSS scores.
- Our hardened images use a minimal OS (Photon Linux), which reduces the attack surface while maintaining extensibility through the use of an industry standard package format.
- Stay more secure and compliant with continuously built images updated within hours of upstream patches.
- Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
- Hardened images come with attestation signatures (Notation), SBOMs, virus scan reports and other metadata produced in an SLSA-3 compliant software factory.

Only a subset of BSI applications are available for free. Looking to access the entire catalog of applications as well as enterprise support? Try the [commercial edition of Bitnami Secure Images today](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/).

## How to deploy Apache ZooKeeper in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Apache ZooKeeper Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/zookeeper).

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami Apache ZooKeeper Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/zookeeper).

```console
docker pull bitnami/zookeeper:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/zookeeper/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/zookeeper:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Persisting your data

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

**Note!**
If you have already started using Apache ZooKeeper, follow the steps on
[backing up](#backing-up-your-container) and [restoring](#restoring-a-backup) to pull the data from your running container down to your host.

The image exposes a volume at `/bitnami/zookeeper` for the Apache ZooKeeper data. For persistence you can mount a directory at this location from your host. If the mounted directory is empty, it will be initialized on the first run.

```console
docker run -v /path/to/zookeeper-persistence:/bitnami/zookeeper bitnami/zookeeper:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/zookeeper/docker-compose.yml) file present in this repository:

```yaml
services:
  zookeeper:
  ...
    volumes:
      - /path/to/zookeeper-persistence:/bitnami/zookeeper
  ...
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), an Apache ZooKeeper server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

In this example, we will create an Apache ZooKeeper client instance that will connect to the server instance that is running on the same docker network as the client.

#### Step 1: Create a network

```console
docker network create app-tier --driver bridge
```

#### Step 2: Launch the Apache ZooKeeper server instance

Use the `--network app-tier` argument to the `docker run` command to attach the Apache ZooKeeper container to the `app-tier` network.

```console
docker run -d --name zookeeper-server \
    --network app-tier \
    bitnami/zookeeper:latest
```

#### Step 3: Launch your Apache ZooKeeper client instance

Finally we create a new container instance to launch the Apache ZooKeeper client and connect to the server created in the previous step:

```console
docker run -it --rm \
    --network app-tier \
    bitnami/zookeeper:latest zkCli.sh -server zookeeper-server:2181  get /
```

### Using a Docker Compose file

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `app-tier`. In this example we assume that you want to connect to the Apache ZooKeeper server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge

services:
  zookeeper:
    image: bitnami/zookeeper:latest
    networks:
      - app-tier
  myapp:
    image: YOUR_APPLICATION_IMAGE
    networks:
      - app-tier
```

> **IMPORTANT**:
>
> 1. Please update the `YOUR_APPLICATION_IMAGE` placeholder in the above snippet with your application image
> 2. In your application container, use the hostname `zookeeper` to connect to the Apache ZooKeeper server

Launch the containers using:

```console
docker-compose up -d
```

## Configuration

### Environment variables

#### Customizable environment variables

| Name                                 | Description                                                                                                                                                                                                          | Default Value |
|--------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------|
| `ZOO_DATA_LOG_DIR`                   | ZooKeeper directory where data is stored.                                                                                                                                                                            | `nil`         |
| `ZOO_PORT_NUMBER`                    | ZooKeeper client port.                                                                                                                                                                                               | `2181`        |
| `ZOO_SERVER_ID`                      | ID of the server in the ensemble.                                                                                                                                                                                    | `1`           |
| `ZOO_SERVERS`                        | Comma, space or semi-colon separated list of servers.                                                                                                                                                                | `nil`         |
| `ZOO_ENABLE_ADMIN_SERVER`            | Whether to enable the ZooKeeper admin server.                                                                                                                                                                        | `yes`         |
| `ZOO_ADMIN_SERVER_PORT_NUMBER`       | ZooKeeper admin server port.                                                                                                                                                                                         | `8080`        |
| `ZOO_PEER_TYPE`                      | Zookeeper Node Peer type                                                                                                                                                                                             | `nil`         |
| `ZOO_TICK_TIME`                      | Basic time unit in milliseconds used by ZooKeeper for heartbeats.                                                                                                                                                    | `2000`        |
| `ZOO_INIT_LIMIT`                     | ZooKeeper uses to limit the length of time the ZooKeeper servers in quorum have to connect to a leader                                                                                                               | `10`          |
| `ZOO_SYNC_LIMIT`                     | How far out of date a server can be from a leader.                                                                                                                                                                   | `5`           |
| `ZOO_MAX_CNXNS`                      | Limits the total number of concurrent connections that can be made to a ZooKeeper server. Setting it to 0 entirely removes the limit.                                                                                | `0`           |
| `ZOO_MAX_CLIENT_CNXNS`               | Limits the number of concurrent connections that a single client may make to a single member of the ZooKeeper ensemble.                                                                                              | `60`          |
| `ZOO_AUTOPURGE_INTERVAL`             | The time interval in hours for which the autopurge task is triggered. Set to a positive integer (1 and above) to enable auto purging of old snapshots and log files.                                                 | `0`           |
| `ZOO_AUTOPURGE_RETAIN_COUNT`         | When auto purging is enabled, ZooKeeper retains the most recent snapshots and the corresponding transaction logs in the dataDir and dataLogDir respectively to this number and deletes the rest. Minimum value is 3. | `3`           |
| `ZOO_LOG_LEVEL`                      | ZooKeeper log level. Available levels are: `ALL`, `DEBUG`, `INFO`, `WARN`, `ERROR`, `FATAL`, `OFF`, `TRACE`.                                                                                                         | `INFO`        |
| `ZOO_4LW_COMMANDS_WHITELIST`         | List of whitelisted 4LW commands.                                                                                                                                                                                    | `srvr, mntr`  |
| `ZOO_RECONFIG_ENABLED`               | Enable ZooKeeper Dynamic Reconfiguration.                                                                                                                                                                            | `no`          |
| `ZOO_LISTEN_ALLIPS_ENABLED`          | Listen for connections from its peers on all available IP addresses.                                                                                                                                                 | `no`          |
| `ZOO_ENABLE_PROMETHEUS_METRICS`      | Expose Prometheus metrics.                                                                                                                                                                                           | `no`          |
| `ZOO_PROMETHEUS_METRICS_PORT_NUMBER` | Port where a Jetty server will expose Prometheus metrics.                                                                                                                                                            | `7000`        |
| `ZOO_MAX_SESSION_TIMEOUT`            | Maximum session timeout in milliseconds that the server will allow the client to negotiate.                                                                                                                          | `40000`       |
| `ZOO_PRE_ALLOC_SIZE`                 | Block size for transaction log file.                                                                                                                                                                                 | `65536`       |
| `ZOO_SNAPCOUNT`                      | The number of transactions recorded in the transaction log before a snapshot can be taken (and the transaction log rolled).                                                                                          | `100000`      |
| `ZOO_HC_TIMEOUT`                     | Timeout for the Zookeeper healthcheck script (in seconds).                                                                                                                                                           | `5`           |
| `ZOO_FIPS_MODE`                      | Enable FIPS compatibility mode in ZooKeeper                                                                                                                                                                          | `yes`         |
| `ZOO_TLS_CLIENT_ENABLE`              | Enable TLS for client communication.                                                                                                                                                                                 | `false`       |
| `ZOO_TLS_PORT_NUMBER`                | Zookeeper TLS port.                                                                                                                                                                                                  | `3181`        |
| `ZOO_TLS_CLIENT_KEYSTORE_FILE`       | KeyStore file.                                                                                                                                                                                                       | `nil`         |
| `ZOO_TLS_CLIENT_KEYSTORE_TYPE`       | KeyStore file type.                                                                                                                                                                                                  | `nil`         |
| `ZOO_TLS_CLIENT_KEYSTORE_PASSWORD`   | KeyStore file password.                                                                                                                                                                                              | `nil`         |
| `ZOO_TLS_CLIENT_TRUSTSTORE_FILE`     | TrustStore file.                                                                                                                                                                                                     | `nil`         |
| `ZOO_TLS_CLIENT_TRUSTSTORE_TYPE`     | TrustStore file type.                                                                                                                                                                                                | `nil`         |
| `ZOO_TLS_CLIENT_TRUSTSTORE_PASSWORD` | TrustStore file password.                                                                                                                                                                                            | `nil`         |
| `ZOO_TLS_CLIENT_AUTH`                | Specifies options to authenticate TLS connections from clients. Available values are: `none`, `want`, `need`.                                                                                                        | `need`        |
| `ZOO_TLS_QUORUM_ENABLE`              | Enable TLS for quorum communication.                                                                                                                                                                                 | `false`       |
| `ZOO_TLS_QUORUM_KEYSTORE_FILE`       | KeyStore file.                                                                                                                                                                                                       | `nil`         |
| `ZOO_TLS_QUORUM_KEYSTORE_TYPE`       | KeyStore file type.                                                                                                                                                                                                  | `nil`         |
| `ZOO_TLS_QUORUM_KEYSTORE_PASSWORD`   | KeyStore file password.                                                                                                                                                                                              | `nil`         |
| `ZOO_TLS_QUORUM_TRUSTSTORE_FILE`     | TrustStore file.                                                                                                                                                                                                     | `nil`         |
| `ZOO_TLS_QUORUM_TRUSTSTORE_TYPE`     | TrustStore file type.                                                                                                                                                                                                | `nil`         |
| `ZOO_TLS_QUORUM_TRUSTSTORE_PASSWORD` | TrustStore file password.                                                                                                                                                                                            | `nil`         |
| `ZOO_TLS_QUORUM_CLIENT_AUTH`         | Specifies options to authenticate TLS connections from clients. Available values are: `none`, `want`, `need`.                                                                                                        | `need`        |
| `JVMFLAGS`                           | Default JVMFLAGS for the ZooKeeper process.                                                                                                                                                                          | `nil`         |
| `ZOO_HEAP_SIZE`                      | Size in MB for the Java Heap options (Xmx and XMs). This env var is ignored if Xmx an Xms are configured via `JVMFLAGS`.                                                                                             | `1024`        |
| `ZOO_ENABLE_AUTH`                    | Enable ZooKeeper auth. It uses SASL/Digest-MD5.                                                                                                                                                                      | `no`          |
| `ZOO_CLIENT_USER`                    | User that will use ZooKeeper clients to auth.                                                                                                                                                                        | `nil`         |
| `ZOO_SERVER_USERS`                   | Comma, semicolon or whitespace separated list of user to be created.                                                                                                                                                 | `nil`         |
| `ZOO_CLIENT_PASSWORD`                | Password that will use ZooKeeper clients to auth.                                                                                                                                                                    | `nil`         |
| `ZOO_SERVER_PASSWORDS`               | Comma, semicolon or whitespace separated list of passwords to assign to users when created. Example: `pass4user1, pass4user2, pass4admin`.                                                                           | `nil`         |
| `ZOO_ENABLE_QUORUM_AUTH`             | Enable ZooKeeper auth. It uses SASL/Digest-MD5.                                                                                                                                                                      | `no`          |
| `ZOO_QUORUM_LEARNER_USER`            | User that will be used by the ZooKeeper Quorum Learner to auth with Quorum Servers.                                                                                                                                  | `nil`         |
| `ZOO_QUORUM_LEARNER_PASSWORD`        | Password that will use ZooKeeper Quorum Learner to auth.                                                                                                                                                             | `nil`         |
| `ZOO_QUORUM_SERVER_USERS`            | Comma, semicolon or whitespace separated list of quorum users to be created.                                                                                                                                         | `nil`         |
| `ZOO_QUORUM_SERVER_PASSWORDS`        | Comma, semicolon or whitespace separated list of passwords to assign to quorum users when created. Example: `pass4user1, pass4user2, pass4admin`.                                                                    | `nil`         |

#### Read-only environment variables

| Name                   | Description                                 | Value                           |
|------------------------|---------------------------------------------|---------------------------------|
| `ZOO_BASE_DIR`         | ZooKeeper installation directory.           | `${BITNAMI_ROOT_DIR}/zookeeper` |
| `ZOO_VOLUME_DIR`       | ZooKeeper persistence directory.            | `/bitnami/zookeeper`            |
| `ZOO_DATA_DIR`         | ZooKeeper directory where data is stored.   | `${ZOO_VOLUME_DIR}/data`        |
| `ZOO_CONF_DIR`         | ZooKeeper configuration directory.          | `${ZOO_BASE_DIR}/conf`          |
| `ZOO_DEFAULT_CONF_DIR` | ZooKeeper default configuration directory.  | `${ZOO_BASE_DIR}/conf.default`  |
| `ZOO_CONF_FILE`        | ZooKeeper configuration file.               | `${ZOO_CONF_DIR}/zoo.cfg`       |
| `ZOO_LOG_DIR`          | Directory where ZooKeeper logs are stored.  | `${ZOO_BASE_DIR}/logs`          |
| `ZOO_LOG_FILE`         | Directory where ZooKeeper logs are stored.  | `${ZOO_LOG_DIR}/zookeeper.out`  |
| `ZOO_BIN_DIR`          | ZooKeeper directory for binary executables. | `${ZOO_BASE_DIR}/bin`           |
| `ZOO_DAEMON_USER`      | ZooKeeper system user.                      | `zookeeper`                     |
| `ZOO_DAEMON_GROUP`     | ZooKeeper system group.                     | `zookeeper`                     |

When you start the Apache ZooKeeper image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. If you want to add a new environment variable:

- For manual execution add a -e option with each variable and value:

```console
docker run --name zookeeper -e ZOO_SERVER_ID=1 bitnami/zookeeper:latest
```

- For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/zookeeper/docker-compose.yml) file present in this repository:

```yaml
services:
  zookeeper:
  ...
    environment:
      - ZOO_SERVER_ID=1
  ...
```

### Apache ZooKeeper Configuration

The image looks for configuration in the `conf/` directory of `/opt/bitnami/zookeeper`.

```console
docker run --name zookeeper -v /path/to/zoo.cfg:/opt/bitnami/zookeeper/conf/zoo.cfg  bitnami/zookeeper:latest
```

After that, your changes will be taken into account in the server's behaviour.

#### Step 1: Run the Apache ZooKeeper image

Run the Apache ZooKeeper image, mounting a directory from your host.

```console
docker run --name zookeeper -v /path/to/zoo.cfg:/opt/bitnami/zookeeper/conf/zoo.cfg bitnami/zookeeper:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  zookeeper:
    image: bitnami/zookeeper:latest
    ports:
      - 2181:2181
    volumes:
      - /path/to/zoo.cfg:/opt/bitnami/zookeeper/conf/zoo.cfg
```

#### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```console
vi /path/to/zoo.cfg
```

#### Step 3: Restart Apache ZooKeeper

After changing the configuration, restart your Apache ZooKeeper container for changes to take effect.

```console
docker restart zookeeper
```

or using Docker Compose:

```console
docker-compose restart zookeeper
```

### Security

Authentication based on SASL/Digest-MD5 can be easily enabled by passing the `ZOO_ENABLE_AUTH` env var.
When enabling the Apache ZooKeeper authentication, it is also required to pass the list of users and passwords that will
be able to login.

> Note: Authentication is enabled using the CLI tool `zkCli.sh`. Therefore, it's necessary to set
`ZOO_CLIENT_USER` and `ZOO_CLIENT_PASSWORD` environment variables too.

As SASL/Digest-MD5 is not compatible with FIPS, it's mandatory to disable "fips-mode" in Apache ZooKeeper.

> Note: If fips-mode is required in your environment, you should deploy Apache ZooKeeper using a different auth mechanism like TLS.

```console
docker run -it -e ZOO_ENABLE_AUTH=yes \
               -e ZOO_SERVER_USERS=user1,user2 \
               -e ZOO_SERVER_PASSWORDS=pass4user1,pass4user2 \
               -e ZOO_CLIENT_USER=user1 \
               -e ZOO_CLIENT_PASSWORD=pass4user1 \
               -e ZOO_FIPS_MODE=no \
               bitnami/zookeeper
```

or modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/zookeeper/docker-compose.yml) file present in this repository:

```yaml
services:
  zookeeper:
  ...
    environment:
      - ZOO_ENABLE_AUTH=yes
      - ZOO_SERVER_USERS=user1,user2
      - ZOO_SERVER_PASSWORDS=pass4user1,pass4user2
      - ZOO_CLIENT_USER=user1
      - ZOO_CLIENT_PASSWORD=pass4user1
      - ZOO_FIPS_MODE=no
  ...
```

### Start Apache ZooKeeper with TLS

```console
docker run --name zookeeper \
  -v /path/to/zookeeper.keystore.jks:/bitnami/zookeeper/certs/zookeeper.keystore.jks:ro
  -v /path/to/zookeeper.truststore.jks:/bitnami/zookeeper/certs/zookeeper.truststore.jks:ro
  -e ZOO_TLS_CLIENT_ENABLE=yes \
  -e ZOO_TLS_CLIENT_KEYSTORE_FILE=/bitnami/zookeeper/certs/zookeeper.keystore.jks \
  -e ZOO_TLS_CLIENT_TRUSTSTORE_FILE=/bitnami/zookeeper/certs/zookeeper.truststore.jks \
  bitnami/zookeeper:latest
```

### Setting up an Apache ZooKeeper ensemble

An Apache ZooKeeper (<https://zookeeper.apache.org/doc/r3.1.2/zookeeperAdmin.html>) cluster can easily be setup with the Bitnami Apache ZooKeeper Docker image using the following environment variables:

- `ZOO_SERVERS`: Comma, space or semi-colon separated list of servers. This can be done with or without specifying the ID of the server in the ensemble. No defaults. Examples:
- without Server ID - zoo1:2888:3888,zoo2:2888:3888
- with Server ID - zoo1:2888:3888::1,zoo2:2888:3888::2
- without Server ID and Observers - zoo1:2888:3888,zoo2:2888:3888:observer
- with Server ID and Observers - zoo1:2888:3888::1,zoo2:2888:3888:observer::2

For reliable Apache ZooKeeper service, you should deploy Apache ZooKeeper in a cluster known as an ensemble. As long as a majority of the ensemble are up, the service will be available. Because Apache ZooKeeper requires a majority, it is best to use an odd number of machines. For example, with four machines Apache ZooKeeper can only handle the failure of a single machine; if two machines fail, the remaining two machines do not constitute a majority. However, with five machines Apache ZooKeeper can handle the failure of two machines.

You have to use 0.0.0.0 as the host for the server. More concretely, if the ID of the zookeeper1 container starting is 1, then the ZOO_SERVERS environment variable has to be 0.0.0.0:2888:3888,zookeeper2:2888:3888,zookeeper3:2888:3888 or if the ID of zookeeper servers are non-sequential then they need to be specified 0.0.0.0:2888:3888::2,zookeeper2:2888:3888::4.zookeeper3:2888:3888::6

See below:

Create a Docker network to enable visibility to each other via the docker container name

```console
docker network create app-tier --driver bridge
```

#### Step 1: Create the first node

The first step is to create one Apache ZooKeeper instance.

```console
docker run --name zookeeper1 \
  --network app-tier \
  -e ZOO_SERVER_ID=1 \
  -e ZOO_SERVERS=0.0.0.0:2888:3888,zookeeper2:2888:3888,zookeeper3:2888:3888 \
  -p 2181:2181 \
  -p 2888:2888 \
  -p 3888:3888 \
  bitnami/zookeeper:latest
```

#### Step 2: Create the second node

Next we start a new Apache ZooKeeper container.

```console
docker run --name zookeeper2 \
  --network app-tier \
  -e ZOO_SERVER_ID=2 \
  -e ZOO_SERVERS=zookeeper1:2888:3888,0.0.0.0:2888:3888,zookeeper3:2888:3888 \
  -p 2181:2181 \
  -p 2888:2888 \
  -p 3888:3888 \
  bitnami/zookeeper:latest
```

#### Step 3: Create the third node

Next we start another new Apache ZooKeeper container.

```console
docker run --name zookeeper3 \
  --network app-tier \
  -e ZOO_SERVER_ID=3 \
  -e ZOO_SERVERS=zookeeper1:2888:3888,zookeeper2:2888:3888,0.0.0.0:2888:3888 \
  -p 2181:2181 \
  -p 2888:2888 \
  -p 3888:3888 \
  bitnami/zookeeper:latest
```

You now have a two node Apache ZooKeeper cluster up and running. You can scale the cluster by adding/removing slaves without incurring any downtime.

With Docker Compose the ensemble can be setup using:

```yaml
version: '2'

services:
  zookeeper1:
    image: bitnami/zookeeper:latest
    ports:
      - 2181
      - 2888
      - 3888
    volumes:
      - /path/to/zookeeper-persistence:/bitnami/zookeeper
    environment:
      - ZOO_SERVER_ID=1
      - ZOO_SERVERS=0.0.0.0:2888:3888,zookeeper2:2888:3888,zookeeper3:2888:3888
  zookeeper2:
    image: bitnami/zookeeper:latest
    ports:
      - 2181
      - 2888
      - 3888
    volumes:
      - /path/to/zookeeper-persistence:/bitnami/zookeeper
    environment:
      - ZOO_SERVER_ID=2
      - ZOO_SERVERS=zookeeper1:2888:3888,0.0.0.0:2888:3888,zookeeper3:2888:3888
  zookeeper3:
    image: bitnami/zookeeper:latest
    ports:
      - 2181
      - 2888
      - 3888
    volumes:
      - /path/to/zookeeper-persistence:/bitnami/zookeeper
    environment:
      - ZOO_SERVER_ID=3
      - ZOO_SERVERS=zookeeper1:2888:3888,zookeeper2:2888:3888,0.0.0.0:2888:3888
```

### FIPS configuration in Bitnami Secure Images

The Bitnami Apache ZooKeeper Docker image from the [Bitnami Secure Images](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Logging

The Bitnami Apache ZooKeeper Docker image sends the container logs to the `stdout`. To view the logs:

```console
docker logs zookeeper
```

or using Docker Compose:

```console
docker-compose logs zookeeper
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Backing up your container

To backup your data, follow these simple steps:

#### Step 1: Stop the currently running container

```console
docker stop zookeeper
```

or using Docker Compose:

```console
docker-compose stop zookeeper
```

#### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```console
docker run --rm -v /path/to/zookeeper-backups:/backups --volumes-from zookeeper busybox \
  cp -a /bitnami/zookeeper /backups/latest
```

or using Docker Compose:

```console
docker run --rm -v /path/to/zookeeper-backups:/backups --volumes-from `docker-compose ps -q zookeeper` busybox \
  cp -a /bitnami/zookeeper /backups/latest
```

### Restoring a backup

Restoring a backup is as simple as mounting the backup as volumes in the container.

```console
docker run -v /path/to/zookeeper-backups/latest:/bitnami/zookeeper bitnami/zookeeper:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  zookeeper:
    image: bitnami/zookeeper:latest
    ports:
      - 2181:2181
    volumes:
      - /path/to/zookeeper-backups/latest:/bitnami/zookeeper
```

### Upgrade this image

Bitnami provides up-to-date versions of Apache ZooKeeper, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/zookeeper:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/zookeeper:latest`.

#### Step 2: Stop and backup the currently running container

Before continuing, you should backup your container's data, configuration and logs.

Follow the steps on [creating a backup](#backing-up-your-container).

#### Step 3: Remove the currently running container

```console
docker rm -v zookeeper
```

or using Docker Compose:

```console
docker-compose rm -v zookeeper
```

#### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if necessary.

```console
docker run --name zookeeper bitnami/zookeeper:latest
```

or using Docker Compose:

```console
docker-compose up zookeeper
```

## Notable Changes

### 3.5.5-r95

- Apache ZooKeeper configuration moved to bash scripts in the rootfs/ folder.

### 3.4.12-r25

- Configuration is not persisted, it is regenerated each time the container is created or it is used as volume.

### 3.4.10-r4

- The zookeeper container has been migrated to a non-root container approach. Previously the container run as `root` user and the zookeeper daemon was started as `zookeeper` user. From now own, both the container and the zookeeper daemon run as user `1001`.
  As a consequence, the configuration files are writable by the user running the zookeeper process.

### 3.4.10-r0

- New release

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/zookeeper).

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
