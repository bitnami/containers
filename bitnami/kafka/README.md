# Bitnami Secure Image for Apache Kafka

> Apache Kafka is a distributed streaming platform designed to build real-time pipelines and can be used as a message broker or as a replacement for a log aggregation solution for big data applications.

[Overview of Apache Kafka](https://kafka.apache.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name kafka bitnami/kafka:latest
```

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

## How to deploy Apache Kafka in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Apache Kafka Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/kafka).

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

## Get this image

The Bitnami Apache Kafka Docker image is only available to [Bitnami Secure Images](https://bitnami.com) customers.

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kafka).

## Persisting your data

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

> Note: If you have already started using your database, follow the steps on [backing up](#backing-up-your-container) and [restoring](#restoring-a-backup) to pull the data from your running container down to your host.

The image exposes a volume at `/bitnami/kafka` for the Apache Kafka data. For persistence you can mount a directory at this location from your host. If the mounted directory is empty, it will be initialized on the first run.

> **NOTE** As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), an Apache Kafka server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Configuration

The following section describes the supported environment variables

### Environment variables

The following tables list the main variables you can set.

#### Customizable environment variables

| Name                                            | Description                                                                                                                           | Default Value                       |
|-------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------|
| `KAFKA_MOUNTED_CONF_DIR`                        | Kafka directory for mounted configuration files.                                                                                      | `${KAFKA_VOLUME_DIR}/config`        |
| `KAFKA_CLUSTER_ID`                              | Kafka cluster ID.                                                                                                                     | `nil`                               |
| `KAFKA_CFG_CONTROLLER_QUORUM_BOOTSTRAP_SERVERS` | List of endpoints to use for bootstrapping the cluster metadata.                                                                      | `localhost:9093`                    |
| `KAFKA_INITIAL_CONTROLLERS`                     | List of Kafka cluster initial controllers.                                                                                            | `nil`                               |
| `KAFKA_SKIP_KRAFT_STORAGE_INIT`                 | If set to true, skip Kraft storage initialization when process.roles are configured.                                                  | `false`                             |
| `KAFKA_KRAFT_VERSION`                           | Configure dynamic or static controller cluster.                                                                                       | `1`                                 |
| `KAFKA_CFG_SASL_ENABLED_MECHANISMS`             | Kafka `sasl.enabled.mechanisms` configuration override.                                                                               | `PLAIN,SCRAM-SHA-256,SCRAM-SHA-512` |
| `KAFKA_CLIENT_LISTENER_NAME`                    | Name of the listener intended to be used by clients, if set, configures the producer/consumer accordingly.                            | `nil`                               |
| `KAFKA_OPTS`                                    | Kafka deployment options.                                                                                                             | `nil`                               |
| `KAFKA_ZOOKEEPER_PROTOCOL`                      | Authentication protocol for Zookeeper connections. Allowed protocols: `PLAINTEXT`, `SASL, SSL`, and `SASL_SSL`.                       | `PLAINTEXT`                         |
| `KAFKA_ZOOKEEPER_PASSWORD`                      | Kafka Zookeeper user password for SASL authentication.                                                                                | `nil`                               |
| `KAFKA_ZOOKEEPER_USER`                          | Kafka Zookeeper user for SASL authentication.                                                                                         | `nil`                               |
| `KAFKA_ZOOKEEPER_TLS_TYPE`                      | Choose the TLS certificate format to use. Allowed values: `JKS`, `PEM`.                                                               | `JKS`                               |
| `KAFKA_ZOOKEEPER_TLS_TRUSTSTORE_FILE`           | Kafka Zookeeper truststore file location.                                                                                             | `nil`                               |
| `KAFKA_ZOOKEEPER_TLS_KEYSTORE_PASSWORD`         | Kafka Zookeeper keystore file password and key password.                                                                              | `nil`                               |
| `KAFKA_ZOOKEEPER_TLS_TRUSTSTORE_PASSWORD`       | Kafka Zookeeper truststore file password.                                                                                             | `nil`                               |
| `KAFKA_ZOOKEEPER_TLS_VERIFY_HOSTNAME`           | Verify Zookeeper hostname on TLS certificates.                                                                                        | `true`                              |
| `KAFKA_INTER_BROKER_USER`                       | Kafka inter broker communication user.                                                                                                | `user`                              |
| `KAFKA_INTER_BROKER_PASSWORD`                   | Kafka inter broker communication password.                                                                                            | `bitnami`                           |
| `KAFKA_CONTROLLER_USER`                         | Kafka control plane communication user.                                                                                               | `controller_user`                   |
| `KAFKA_CONTROLLER_PASSWORD`                     | Kafka control plane communication password.                                                                                           | `bitnami`                           |
| `KAFKA_CERTIFICATE_PASSWORD`                    | Password for certificates.                                                                                                            | `nil`                               |
| `KAFKA_TLS_TRUSTSTORE_FILE`                     | Kafka truststore file location.                                                                                                       | `nil`                               |
| `KAFKA_TLS_TYPE`                                | Choose the TLS certificate format to use.                                                                                             | `JKS`                               |
| `KAFKA_TLS_CLIENT_AUTH`                         | Configures kafka broker to request client authentication.                                                                             | `required`                          |
| `KAFKA_CLIENT_USERS`                            | List of users that will be created when using `SASL_SCRAM` for client communications. Separated by commas, semicolons or whitespaces. | `user`                              |
| `KAFKA_CLIENT_PASSWORDS`                        | Passwords for the users specified at `KAFKA_CLIENT_USERS`. Separated by commas, semicolons or whitespaces.                            | `bitnami`                           |
| `KAFKA_HEAP_OPTS`                               | Kafka heap options for Java.                                                                                                          | `-Xmx1024m -Xms1024m`               |
| `JAVA_TOOL_OPTIONS`                             | Java tool options.                                                                                                                    | `nil`                               |

#### Read-only environment variables

| Name                    | Description                            | Value                                 |
|-------------------------|----------------------------------------|---------------------------------------|
| `KAFKA_BASE_DIR`        | Kafka installation directory.          | `${BITNAMI_ROOT_DIR}/kafka`           |
| `KAFKA_VOLUME_DIR`      | Kafka persistence directory.           | `/bitnami/kafka`                      |
| `KAFKA_DATA_DIR`        | Kafka directory where data is stored.  | `${KAFKA_VOLUME_DIR}/data`            |
| `KAFKA_CONF_DIR`        | Kafka configuration directory.         | `${KAFKA_BASE_DIR}/config`            |
| `KAFKA_CONF_FILE`       | Kafka configuration file.              | `${KAFKA_CONF_DIR}/server.properties` |
| `KAFKA_CERTS_DIR`       | Kafka directory for certificate files. | `${KAFKA_CONF_DIR}/certs`             |
| `KAFKA_INITSCRIPTS_DIR` | Kafka directory for init scripts.      | `/docker-entrypoint-initdb.d`         |
| `KAFKA_LOG_DIR`         | Directory where Kafka logs are stored. | `${KAFKA_BASE_DIR}/logs`              |
| `KAFKA_HOME`            | Kafka home directory.                  | `$KAFKA_BASE_DIR`                     |
| `KAFKA_DAEMON_USER`     | Kafka system user.                     | `kafka`                               |
| `KAFKA_DAEMON_GROUP`    | Kafka system group.                    | `kafka`                               |

Additionally, any environment variable beginning with `KAFKA_CFG_` will be mapped to its corresponding Apache Kafka key. For example, use `KAFKA_CFG_BACKGROUND_THREADS` in order to set `background.threads` or `KAFKA_CFG_AUTO_CREATE_TOPICS_ENABLE` in order to configure `auto.create.topics.enable`.

```console
docker run --name kafka -e KAFKA_CFG_PROCESS_ROLES ... -e KAFKA_CFG_AUTO_CREATE_TOPICS_ENABLE=true bitnami/kafka:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/kafka/docker-compose.yml) file present in this repository:

```yaml
kafka:
  ...
  environment:
    - KAFKA_CFG_AUTO_CREATE_TOPICS_ENABLE=true
  ...
```

### Security

In order to configure authentication, you must configure the Apache Kafka listeners properly. Let's see an example to configure Apache Kafka with `SASL_SSL` authentication for communications with clients, and `SASL` authentication for controller-related communications.

The environment variables below should be defined to configure the listeners, and the SASL credentials for client communications:

```console
KAFKA_CFG_LISTENERS=SASL_SSL://:9092,CONTROLLER://:9093
KAFKA_CFG_ADVERTISED_LISTENERS=SASL_SSL://localhost:9092
KAFKA_CLIENT_USERS=user
KAFKA_CLIENT_PASSWORDS=password
KAFKA_CLIENT_LISTENER_NAME=SASL_SSL
KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:SASL_PLAINTEXT,SASL_SSL:SASL_SSL
KAFKA_CFG_SASL_MECHANISM_CONTROLLER_PROTOCOL=PLAIN
KAFKA_CONTROLLER_USER=controller_user
KAFKA_CONTROLLER_PASSWORD=controller_password
```

You **must** also use your own certificates for SSL. You can drop your Java Key Stores or PEM files into `/opt/bitnami/kafka/config/certs`. If the JKS or PEM certs are password protected (recommended), you will need to provide it to get access to the keystores:

`KAFKA_CERTIFICATE_PASSWORD=myCertificatePassword`

If the truststore is mounted in a different location than `/opt/bitnami/kafka/config/certs/kafka.truststore.jks`, `/opt/bitnami/kafka/config/certs/kafka.truststore.pem`, `/bitnami/kafka/config/certs/kafka.truststore.jks` or `/bitnami/kafka/config/certs/kafka.truststore.pem`, set the `KAFKA_TLS_TRUSTSTORE_FILE` variable.

The following script can help you with the creation of the JKS and certificates:

- [kafka-generate-ssl.sh](https://raw.githubusercontent.com/confluentinc/confluent-platform-security-tools/master/kafka-generate-ssl.sh)

Keep in mind the following notes:

- When prompted to enter a password, use the same one for all.
- Set the Common Name or FQDN values to your Apache Kafka container hostname, e.g. `kafka.example.com`. After entering this value, when prompted "What is your first and last name?", enter this value as well.
  - As an alternative, you can disable host name verification setting the environment variable `KAFKA_CFG_SSL_ENDPOINT_IDENTIFICATION_ALGORITHM` to an empty string.
- When setting up a Apache Kafka Cluster (check the "Setting up an Apache Kafka Cluster") for more information), each Apache Kafka broker and logical client needs its own keystore. You will have to repeat the process for each of the brokers in the cluster.
- While producing and consuming messages using the `bitnami/kafka` image, you'll need to point to the `consumer.properties` and/or `producer.properties` file, which contains the needed configuration

#### Inter-Broker communications

When deploying a Apache Kafka cluster with multiple brokers, inter broker communications can be configured with `SASL` or `SASL_SSL` using the following variables:

- `KAFKA_CFG_SASL_MECHANISM_INTER_BROKER_PROTOCOL`: Apache Kafka inter broker communication protocol.
- `KAFKA_INTER_BROKER_USER`: Apache Kafka inter broker communication user.
- `KAFKA_INTER_BROKER_PASSWORD`: Apache Kafka inter broker communication password.

NOTE: When running in KRaft mode, KAFKA_CFG_SASL_MECHANISM_INTER_BROKER_PROTOCOL only supports `PLAIN` mechanism in Kafka version <= 3.4.

#### Control plane communications

When deploying a Apache Kafka cluster with multiple controllers in KRaft mode, controller communications can be configured with `SASL` or `SASL_SSL` using the following variables:

- `KAFKA_CFG_SASL_MECHANISM_CONTROLLER_PROTOCOL`: Apache Kafka controllers communication protocol.
- `KAFKA_CONTROLLER_USER`: Apache Kafka controllers communication user. Currently only `PLAIN` mechanism is supported.
- `KAFKA_CONTROLLER_PASSWORD`: Apache Kafka controllers communication password.

NOTE: When running in KRaft mode, KAFKA_CFG_SASL_MECHANISM_CONTROLLER_PROTOCOL only supports `PLAIN` mechanism.

#### Apache Kafka SASL configuration

When configuring Apache Kafka listeners with `SASL` or `SASL_SSL` for communications with clients, you can provide your SASL credentials using this environment variables:

- `KAFKA_CLIENT_USERS`: Apache Kafka client user. Default: **user**
- `KAFKA_CLIENT_PASSWORDS`: Apache Kafka client user password. Default: **bitnami**

NOTE: When running in KRaft mode, only the first user:password pair will take effect, as KRaft mode does not support SCRAM mechanism yet.

#### Apache Kafka KRaft mode configuration

KRaft mode can be enabled by providing the following values:

- `KAFKA_CFG_PROCESS_ROLES`: Comma-separated list of Kafka KRaft roles. Allowed values: `controller,broker`, `controller`, `broker`.
- `KAFKA_CFG_NODE_ID`: Unique id for the Kafka node.
- `KAFKA_CFG_LISTENERS`: List of Kafka listeners. If node is set with `controller` role, the listener `CONTROLLER` must be included.
- `KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP`: Maps each listener with a Apache Kafka security protocol. If node is set with `controller` role, this setting is required in order to assign a security protocol for the `CONTROLLER LISTENER`. E.g.: `PLAINTEXT:PLAINTEXT,CONTROLLER:PLAINTEXT`.

In order to configure controllers communications without authentication, you should provide the environment variables below:

- `KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP`: Should include `CONTROLLER:PLAINTEXT`.

In order to configure Apache Kafka controller communications with `SASL`, you should provide the environment variables below:

- `KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP`: Should include `CONTROLLER:SASL`.
- `KAFKA_CFG_SASL_MECHANISM_CONTROLLER_PROTOCOL`: SASL mechanism to use for controllers communications. NOTE: KRaft mode does not yet support SCRAM mechanisms, so the only supported SASL mechanism in KRaft mode would be `PLAIN`.
- `KAFKA_CONTROLLER_USER`: Apache Kafka controllers communication user.
- `KAFKA_CONTROLLER_PASSWORD`: Apache Kafka controllers communication password.

In order to configure Apache Kafka controller communications with `SSL`, you should provide the environment variables below:

- `KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP`: Should include `CONTROLLER:SSL`.
- `KAFKA_TLS_<uppercase_controller_listener_name>_CLIENT_AUTH`: Configures mTLS authentication method for kafka control plane communications. Allowed values: `required`, `requested`, `none`.
- `KAFKA_TLS_TYPE`: Choose the TLS certificate format to use. Allowed values: `JKS`, `PEM`. Defaults: **JKS**.
- Valid keystore and truststore are mounted at `/opt/bitnami/kafka/config/certs/kafka.keystore.jks` and `/opt/bitnami/kafka/config/certs/kafka.truststore.jks`.

In order to authenticate Apache Kafka controller communications with `SASL_SSL`, you should provide the environment variables below:

- `KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP`: Should include `CONTROLLER:SASL_SSL`.
- `KAFKA_CFG_SASL_MECHANISM_CONTROLLER_PROTOCOL`: SASL mechanism to use for controllers communications. NOTE: KRaft mode does not yet support SCRAM mechanisms, so the only supported SASL mechanism in KRaft mode would be `PLAIN`.
- `KAFKA_CONTROLLER_USER`: Apache Kafka controllers communication user.
- `KAFKA_CONTROLLER_PASSWORD`: Apache Kafka controllers communication password.
- `KAFKA_TLS_<uppercase_controller_listener_name>_CLIENT_AUTH`: Configures mTLS authentication method for kafka control plane communications. Allowed values: `required`, `requested`, `none`.
- `KAFKA_TLS_TYPE`: Choose the TLS certificate format to use. Allowed values: `JKS`, `PEM`. Defaults: **JKS**.
- Valid keystore and truststore are mounted at `/opt/bitnami/kafka/config/certs/kafka.keystore.jks` and `/opt/bitnami/kafka/config/certs/kafka.truststore.jks`.

> Note: SSL settings are shared by all listeners configured using `SSL` or `SASL_SSL` protocols. Setting different certificates per listener is not yet supported.

### Setting up a Apache Kafka cluster

An Apache Kafka cluster can easily be setup with the Bitnami Apache Kafka Docker image using the following environment variables:

- `KAFKA_CFG_CONTROLLER_QUORUM_BOOTSTRAP_SERVERS`: List of endpoints to use for bootstrapping the cluster metadata. The endpoints are specified in comma-separated list of {host}:{port} entries.
- `KAFKA_INITIAL_CONTROLLERS`: Used to initialize a server with the specified dynamic quorum. The argument is a comma-separated list of id@hostname:port:directory. The same values must be used to format all nodes.

### Full configuration

The image looks for configuration files (server.properties, log4j2.yaml, etc.) in the `/bitnami/kafka/config/`, this can be changed by setting the KAFKA_MOUNTED_CONF_DIR environment variable.

```console
docker run --name kafka -v /path/to/server.properties:/bitnami/kafka/config/server.properties bitnami/kafka:latest
```

### FIPS configuration in Bitnami Secure Images

The Bitnami Apache Kafka Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.
- `JAVA_TOOL_OPTIONS`: controls Java FIPS mode. Use `-Djava.security.properties==/opt/bitnami/java/conf/security/java.security.restricted` (restricted), `-Djava.security.properties==/opt/bitnami/java/conf/security/java.security.relaxed` (relaxed), or `-Djava.security.properties==/opt/bitnami/java/conf/security/java.security.original` (off).

## Logging

The Bitnami Apache Kafka Docker image sends the container logs to the `stdout`. To view the logs:

```console
docker logs kafka
```

Or using Docker Compose:

```console
docker-compose logs kafka
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Backing up your container

To backup your data, configuration and logs, follow these simple steps:

#### Step 1: Stop the currently running container

```console
docker stop kafka
```

Or using Docker Compose:

```console
docker-compose stop kafka
```

#### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```console
docker run --rm -v /path/to/kafka-backups:/backups --volumes-from kafka busybox \
  cp -a /bitnami/kafka /backups/latest
```

Or using Docker Compose:

```console
docker run --rm -v /path/to/kafka-backups:/backups --volumes-from `docker-compose ps -q kafka` busybox \
  cp -a /bitnami/kafka /backups/latest
```

### Restoring a backup

Restoring a backup is as simple as mounting the backup as volumes in the container.

```console
docker run -v /path/to/kafka-backups/latest:/bitnami/kafka bitnami/kafka:latest
```

You can also modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/kafka/docker-compose.yml) file present in this repository:

```yaml
kafka:
  volumes:
    - /path/to/kafka-backups/latest:/bitnami/kafka
```

## Notable Changes

### 4.1.1-debian-12-r1, 4.1.1-photon-5-r2

Updated the logic to configure contoller.quorum.bootstrap.servers parameter instead of controller.quorum.voters. That affects the initialization and setting the KAFKA_INITIAL_CONTROLLERS env var is now mandatory when building a cluster.

### 4.0.0-debian-12-r0

This version implies a significant milestone given now Kafka operates operate entirely without Apache ZooKeeper, running in KRaft mode by default. As a consequence, **ZooKeeper-related parameters have been removed.**.

### Branches rename

Branch 2 has been renamed to 2.8 and branch 3 has been split into branches 3.0 and 3.1 mirroring the upstream [Apache Kafka's naming policy](https://kafka.apache.org/downloads)

### 3.5.1-debian-11-r4, 3.4.1-debian-11-r50, 3.3.2-debian-11-r176 and 3.2.3-debian-11-r161

This new release of the bitnami/kafka container includes a refactor in its logic and introduces several breaking changes and improvements:

- Removed env variable KAFKA_ENABLE_KRAFT. Instead, KRaft configuration will be detected if KAFKA_CFG_PROCESS_ROLES is provided.
- By default, the container will not configure neither Zookeeper mode or KRaft mode.
  **IMPORTANT**: Either KAFKA_CFG_PROCESS_ROLES or KAFKA_CFG_ZOOKEEPER_CONNECT must be configured for Apache Kafka to be started.
  The equivalent configuration to the deprecated `KAFKA_ENABLE_KRAFT=true` option would be setting `KAFKA_CFG_PROCESS_ROLES=controller,broker`.
  This change is especially aimed to support migrating from Zookeeper mode to KRaft mode. Once Zookeeper mode is fully removed we will default to a KRaft controller+broker mode.
- Support for broker-only and controller-only nodes in KRaft mode.
  By setting KAFKA_CFG_PROCESS_ROLES, the Bitnami Apache Kafka container can be configured as a dedicated broker or controller node, or run both processes.
- Added support for SASL and SSL protocols in Control plane (controller listener).
  New variables have been added for this purpose:
  - KAFKA_CONTROLLER_USER - Username for the controller communications when SASL is enabled.
  - KAFKA_CONTROLLER_PASSWORD - Password for the controller communications when SASL is enabled.
- Removed the `${KAFKA_CONFIG}/server.properties` vs `${KAFKA_CONFIG}/kraft/server.properties` when using Zookeeper or KRaft mode.
  By default, Kafka uses `${KAFKA_CONFIG}/server.properties`, which is generated from `${KAFKA_CONFIG}/server.properties.original`, the original Kafka configuration file, based on environment variables. If no custom configuration file is mounted, references to both configurations are removed during container initialization.
- Refactor JAAS settings to use the recommended approach `listener.name.${listener_lower}.${mechanism_name}.sasl.jaas.config`.
  The `kafka_jaas.conf` will no longer be generated, although it will continue being loaded if mounted.
  Please note that, according to Kafka documentation, the preference will be:
  - Configuration property `listener.name.<listenerName>.<saslMechanism>.sasl.jaas.config` (Recommended)
  - `<listenerName>.KafkaServer` section of JAAS file
  - KafkaServer section of JAAS file
- The KAFKA_INTER_BROKER_USER and KAFKA_INTER_BROKER_PASSWORD will no longer be valid users in other listeners when INTERNAL listener is provided or KAFKA_CFG_INTER_BROKER_LISTENER_NAME is provided.
- Refactor `kafka_validate` function for consistency with both KRaft and Zookeeper modes and improving existing SASL and SSL validations.
- Definitively remove deprecated legacy values:
  - Alternative mount path `/opt/bitnami/kafka/conf` is no longer valid.
  - Deprecation messages for KAFKA_PORT variable
- Extended existing `BROKER_ID_COMMAND` to support KRaft, by adding `KAFKA_NODE_ID_COMMAND` and `KAFKA_CONTROLLER_QUORUM_VOTERS_COMMAND`.
- The existing `BROKER_ID_COMMAND` variable has been deprecated and replaced by `KAFKA_BROKER_ID_COMMAND` for consistency. It will be removed in a future release, so please update your deployments to use the new variable instead.
- Environment variable `ALLOW_PLAINTEXT_LISTENER` has been removed. This variable was used to ensure Kafka wasn't started without any unauthenticated listener unless explicitly set. Since this new release requires explicitly configuring listeners and listeners' security protocol map, we have decided to remove it.

### 3.4.0-debian-11-r23, 3.3.2-debian-11-r29 and 3.2.3-debian-11-r73

- Apache Kafka is now configured using KRaft. You can disable this configuration with the `KAFKA_ENABLE_KRAFT=false` env var and by following the instructions in this guide.

### 3.0.0-debian-10-r0

- Apache Kafka 3.0 deprecates the `--zookeper` flag in shell commands. Related operations such as topic creation require the use of updated flags. Please, refer to [Apache Kafka's official release notes](https://archive.apache.org/dist/kafka/3.0.0/RELEASE_NOTES.html) for further information on the changes introduced by this version.

### 2.5.0-debian-10-r111

- The `KAFKA_CLIENT_USER` AND `KAFKA_CLIENT_PASSWORD` have been deprecated in favor of `KAFKA_CLIENT_USERS` and `KAFKA_CLIENT_PASSWORDS`.

### 2.5.0-debian-10-r51

- The environment variables `KAFKA_PORT_NUMBER` and `KAFKA_CFG_PORT` was deprecated, you can specify the port number in `KAFKA_CFG_LISTENERS` instead.
- The following environment variables were renamed:

  - `KAFKA_BROKER_USER` -> `KAFKA_CLIENT_USER`
  - `KAFKA_BROKER_PASSWORD` -> `KAFKA_CLIENT_PASSWORD`

- Listeners & advertised listeners must be configured to enable authentication. Check [Security section](#security) for more information.

### 2.4.1-r38-debian-10

The configuration directory was changed to `/opt/bitnami/kafka/config`. Configuration files should be mounted to `/bitnami/kafka/config`.

### 1.1.1-debian-9-r224, 2.2.1-debian-9-r16, 1.1.1-ol-7-r306 and 2.2.1-ol-7-r14

- The following environment variables were being wrongly translated into `KAFKA_CFG_` environment variables, and therefore they were being wrongly mapped into Apache Kafka keys:

  - `KAFKA_LOGS_DIRS` -> `KAFKA_CFG_LOG_DIRS`
  - `KAFKA_PORT_NUMBER` -> `KAFKA_CFG_PORT`
  - `KAFKA_ZOOKEEPER_CONNECT_TIMEOUT_MS` -> `KAFKA_CFG_ZOOKEEPER_CONNECTION_TIMEOUT_MS`

- For consistency reasons with previous environment variables, the following `KAFKA_` to `KAFKA_CFG_` environment variable translations are now supported for mapping into Apache Kafka keys:

  - `KAFKA_LOG_DIRS` -> `KAFKA_CFG_LOG_DIRS`
  - `KAFKA_ZOOKEEPER_CONNECTION_TIMEOUT_MS` -> `KAFKA_CFG_ZOOKEEPER_CONNECTION_TIMEOUT_MS`

### 1.1.1-debian-9-r205, 2.2.0-debian-9-r40, 1.1.1-ol-7-r286, and 2.2.0-ol-7-r53

Configuration changes. Most environment variables now start with `KAFKA_CFG_`, as they are now mapped directly to Apache Kafka keys. Variables changed:

- `KAFKA_ADVERTISED_LISTENERS` -> `KAFKA_CFG_ADVERTISED_LISTENERS`
- `KAFKA_BROKER_ID` -> `KAFKA_CFG_BROKER_ID`
- `KAFKA_DEFAULT_REPLICATION_FACTOR` -> `KAFKA_CFG_DEFAULT_REPLICATION_FACTOR`
- `KAFKA_DELETE_TOPIC_ENABLE` -> `KAFKA_CFG_DELETE_TOPIC_ENABLE`
- `KAFKA_INTER_BROKER_LISTENER_NAME` -> `KAFKA_CFG_INTER_BROKER_LISTENER_NAME`
- `KAFKA_LISTENERS` -> `KAFKA_CFG_LISTENERS`
- `KAFKA_LISTENER_SECURITY_PROTOCOL_MAP` -> `KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP`
- `KAFKA_LOGS_DIRS` -> `KAFKA_CFG_LOG_DIRS`
- `KAFKA_LOG_FLUSH_INTERVAL_MESSAGES` -> `KAFKA_CFG_LOG_FLUSH_INTERVAL_MESSAGES`
- `KAFKA_LOG_FLUSH_INTERVAL_MS` -> `KAFKA_CFG_LOG_FLUSH_INTERVAL_MS`
- `KAFKA_LOG_MESSAGE_FORMAT_VERSION` -> `KAFKA_CFG_LOG_MESSAGE_FORMAT_VERSION`
- `KAFKA_LOG_RETENTION_BYTES` -> `KAFKA_CFG_LOG_RETENTION_BYTES`
- `KAFKA_LOG_RETENTION_CHECK_INTERVALS_MS` -> `KAFKA_CFG_LOG_RETENTION_CHECK_INTERVAL_MS`
- `KAFKA_LOG_RETENTION_HOURS` -> `KAFKA_CFG_LOG_RETENTION_HOURS`
- `KAFKA_MAX_MESSAGE_BYTES` -> `KAFKA_CFG_MESSAGE_MAX_BYTES`
- `KAFKA_NUM_IO_THREADS` -> `KAFKA_CFG_NUM_IO_THREADS`
- `KAFKA_NUM_NETWORK_THREADS` -> `KAFKA_CFG_NUM_NETWORK_THREADS`
- `KAFKA_NUM_PARTITIONS` -> `KAFKA_CFG_NUM_PARTITIONS`
- `KAFKA_NUM_RECOVERY_THREADS_PER_DATA_DIR` -> `KAFKA_CFG_NUM_RECOVERY_THREADS_PER_DATA_DIR`
- `KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR` -> `KAFKA_CFG_OFFSETS_TOPIC_REPLICATION_FACTOR`
- `KAFKA_PORT` -> `KAFKA_CFG_PORT`
- `KAFKA_SEGMENT_BYTES` -> `KAFKA_CFG_SEGMENT_BYTES`
- `KAFKA_SOCKET_RECEIVE_BUFFER_BYTES` -> `KAFKA_CFG_SOCKET_RECEIVE_BUFFER_BYTES`
- `KAFKA_SOCKET_REQUEST_MAX_BYTES` -> `KAFKA_CFG_SOCKET_REQUEST_MAX_BYTES`
- `KAFKA_SOCKET_SEND_BUFFER_BYTES` -> `KAFKA_CFG_SOCKET_SEND_BUFFER_BYTES`
- `KAFKA_SSL_ENDPOINT_IDENTIFICATION_ALGORITHM` -> `KAFKA_CFG_SSL_ENDPOINT_IDENTIFICATION_ALGORITHM`
- `KAFKA_TRANSACTION_STATE_LOG_MIN_ISR` -> `KAFKA_CFG_TRANSACTION_STATE_LOG_MIN_ISR`
- `KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR` -> `KAFKA_CFG_TRANSACTION_STATE_LOG_REPLICATION_FACTOR`
- `KAFKA_ZOOKEEPER_CONNECT_TIMEOUT_MS` -> `KAFKA_CFG_ZOOKEEPER_CONNECT_TIMEOUT_MS`
- `KAFKA_ZOOKEEPER_CONNECT` -> `KAFKA_CFG_ZOOKEEPER_CONNECT`

### 1.1.0-r41

- Configuration is not persisted anymore. It should be mounted as a volume or it will be regenerated each time the container is created.
- Dummy certificates are not used anymore when the SASL_SSL listener is configured. These certificates must be mounted as volumes.

### 0.10.2.1-r3

- The kafka container has been migrated to a non-root container approach. Previously the container run as `root` user and the kafka daemon was started as `kafka` user. From now own, both the container and the kafka daemon run as user `1001`.
  As a consequence, the configuration files are writable by the user running the kafka process.

### 0.10.2.1-r0

- New Bitnami release

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
