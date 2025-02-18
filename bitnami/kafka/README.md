# Bitnami package for Apache Kafka

## What is Apache Kafka?

> Apache Kafka is a distributed streaming platform designed to build real-time pipelines and can be used as a message broker or as a replacement for a log aggregation solution for big data applications.

[Overview of Apache Kafka](http://kafka.apache.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name kafka bitnami/kafka:latest
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Apache Kafka in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## How to deploy Apache Kafka in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Apache Kafka Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/kafka).

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

The recommended way to get the Bitnami Apache Kafka Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/kafka).

```console
docker pull bitnami/kafka:latest
```

To use a specific version, you can pull a versioned tag. You can view the
[list of available versions](https://hub.docker.com/r/bitnami/kafka/tags/)
in the Docker Hub Registry.

```console
docker pull bitnami/kafka:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Persisting your data

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

> Note: If you have already started using your database, follow the steps on [backing up](#backing-up-your-container) and [restoring](#restoring-a-backup) to pull the data from your running container down to your host.

The image exposes a volume at `/bitnami/kafka` for the Apache Kafka data. For persistence you can mount a directory at this location from your host. If the mounted directory is empty, it will be initialized on the first run.

Using Docker Compose:

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/kafka/docker-compose.yml) file present in this repository:

```yaml
kafka:
  ...
  volumes:
    - /path/to/kafka-persistence:/bitnami/kafka
  ...
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), an Apache Kafka server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

In this example, we will create an Apache Kafka client instance that will connect to the server instance that is running on the same docker network as the client.

#### Step 1: Create a network

```console
docker network create app-tier --driver bridge
```

#### Step 2: Launch the Apache Kafka server instance

Use the `--network app-tier` argument to the `docker run` command to attach the Apache Kafka container to the `app-tier` network.

```console
docker run -d --name kafka-server --hostname kafka-server \
    --network app-tier \
    -e KAFKA_CFG_NODE_ID=0 \
    -e KAFKA_CFG_PROCESS_ROLES=controller,broker \
    -e KAFKA_CFG_LISTENERS=PLAINTEXT://:9092,CONTROLLER://:9093 \
    -e KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT \
    -e KAFKA_CFG_CONTROLLER_QUORUM_VOTERS=0@kafka-server:9093 \
    -e KAFKA_CFG_CONTROLLER_LISTENER_NAMES=CONTROLLER \
    bitnami/kafka:latest
```

#### Step 3: Launch your Apache Kafka client instance

Finally we create a new container instance to launch the Apache Kafka client and connect to the server created in the previous step:

```console
docker run -it --rm \
    --network app-tier \
    bitnami/kafka:latest kafka-topics.sh --list  --bootstrap-server kafka-server:9092
```

### Using a Docker Compose file

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `app-tier`. In this example we assume that you want to connect to the Apache Kafka server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge

services:
  kafka:
    image: 'bitnami/kafka:latest'
    networks:
      - app-tier
    environment:
      - KAFKA_CFG_NODE_ID=0
      - KAFKA_CFG_PROCESS_ROLES=controller,broker
      - KAFKA_CFG_LISTENERS=PLAINTEXT://:9092,CONTROLLER://:9093
      - KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT
      - KAFKA_CFG_CONTROLLER_QUORUM_VOTERS=0@kafka:9093
      - KAFKA_CFG_CONTROLLER_LISTENER_NAMES=CONTROLLER
  myapp:
    image: 'YOUR_APPLICATION_IMAGE'
    networks:
      - app-tier
```

> **IMPORTANT**:
>
> 1. Please update the `YOUR_APPLICATION_IMAGE` placeholder in the above snippet with your application image
> 2. In your application container, use the hostname `kafka` to connect to the Apache Kafka server

Launch the containers using:

```console
docker-compose up -d
```

## Configuration

### Environment variables

#### Customizable environment variables

| Name                                      | Description                                                                                                                                                                            | Default Value                       |
|-------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------|
| `KAFKA_MOUNTED_CONF_DIR`                  | Kafka directory for mounted configuration files.                                                                                                                                       | `${KAFKA_VOLUME_DIR}/config`        |
| `KAFKA_INTER_BROKER_USER`                 | Kafka inter broker communication user.                                                                                                                                                 | `user`                              |
| `KAFKA_INTER_BROKER_PASSWORD`             | Kafka inter broker communication password.                                                                                                                                             | `bitnami`                           |
| `KAFKA_CONTROLLER_USER`                   | Kafka control plane communication user.                                                                                                                                                | `controller_user`                   |
| `KAFKA_CONTROLLER_PASSWORD`               | Kafka control plane communication password.                                                                                                                                            | `bitnami`                           |
| `KAFKA_CERTIFICATE_PASSWORD`              | Password for certificates.                                                                                                                                                             | `nil`                               |
| `KAFKA_TLS_TRUSTSTORE_FILE`               | Kafka truststore file location.                                                                                                                                                        | `nil`                               |
| `KAFKA_TLS_TYPE`                          | Choose the TLS certificate format to use.                                                                                                                                              | `JKS`                               |
| `KAFKA_TLS_CLIENT_AUTH`                   | Configures kafka broker to request client authentication.                                                                                                                              | `required`                          |
| `KAFKA_OPTS`                              | Kafka deployment options.                                                                                                                                                              | `nil`                               |
| `KAFKA_CFG_SASL_ENABLED_MECHANISMS`       | Kafka `sasl.enabled.mechanisms` configuration override.                                                                                                                                | `PLAIN,SCRAM-SHA-256,SCRAM-SHA-512` |
| `KAFKA_KRAFT_CLUSTER_ID`                  | Kafka cluster ID when using Kafka Raft mode (KRaft).                                                                                                                                   | `nil`                               |
| `KAFKA_SKIP_KRAFT_STORAGE_INIT`           | If set to true, skip Kraft storage initialization when process.roles are configured.                                                                                                   | `false`                             |
| `KAFKA_CLIENT_LISTENER_NAME`              | Name of the listener intended to be used by clients, if set, configures the producer/consumer accordingly.                                                                             | `nil`                               |
| `KAFKA_ZOOKEEPER_PROTOCOL`                | Authentication protocol for Zookeeper connections. Allowed protocols: `PLAINTEXT`, `SASL, SSL`, and `SASL_SSL`.                                                                        | `PLAINTEXT`                         |
| `KAFKA_ZOOKEEPER_PASSWORD`                | Kafka Zookeeper user password for SASL authentication.                                                                                                                                 | `nil`                               |
| `KAFKA_ZOOKEEPER_USER`                    | Kafka Zookeeper user for SASL authentication.                                                                                                                                          | `nil`                               |
| `KAFKA_ZOOKEEPER_TLS_KEYSTORE_PASSWORD`   | Kafka Zookeeper keystore file password and key password.                                                                                                                               | `nil`                               |
| `KAFKA_ZOOKEEPER_TLS_TRUSTSTORE_PASSWORD` | Kafka Zookeeper truststore file password.                                                                                                                                              | `nil`                               |
| `KAFKA_ZOOKEEPER_TLS_TRUSTSTORE_FILE`     | Kafka Zookeeper truststore file location.                                                                                                                                              | `nil`                               |
| `KAFKA_ZOOKEEPER_TLS_VERIFY_HOSTNAME`     | Verify Zookeeper hostname on TLS certificates.                                                                                                                                         | `true`                              |
| `KAFKA_ZOOKEEPER_TLS_TYPE`                | Choose the TLS certificate format to use. Allowed values: `JKS`, `PEM`.                                                                                                                | `JKS`                               |
| `KAFKA_CLIENT_USERS`                      | List of additional users to `KAFKA_CLIENT_USER` that will be created into Zookeeper when using `SASL_SCRAM` for client communications. Separated by commas, semicolons or whitespaces. | `user`                              |
| `KAFKA_CLIENT_PASSWORDS`                  | Passwords for the users specified at `KAFKA_CLIENT_USERS`. Separated by commas, semicolons or whitespaces.                                                                             | `bitnami`                           |
| `KAFKA_HEAP_OPTS`                         | Kafka heap options for Java.                                                                                                                                                           | `-Xmx1024m -Xms1024m`               |
| `JAVA_TOOL_OPTIONS`                       | Java tool options.                                                                                                                                                                     | `nil`                               |

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

### Apache Kafka development setup example

To use Apache Kafka in a development setup, create the following `docker-compose.yml` file:

```yaml
version: "3"
services:
  kafka:
    image: 'bitnami/kafka:latest'
    ports:
      - '9092:9092'
    environment:
      - KAFKA_CFG_NODE_ID=0
      - KAFKA_CFG_PROCESS_ROLES=controller,broker
      - KAFKA_CFG_LISTENERS=PLAINTEXT://:9092,CONTROLLER://:9093
      - KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT
      - KAFKA_CFG_CONTROLLER_QUORUM_VOTERS=0@kafka:9093
      - KAFKA_CFG_CONTROLLER_LISTENER_NAMES=CONTROLLER
```

To deploy it, run the following command in the directory where the `docker-compose.yml` file is located:

```console
docker-compose up -d
```

### Kafka with Zookeeper

Apache Kafka Raft (KRaft) makes use of a new quorum controller service in Kafka which replaces the previous controller and makes use of an event-based variant of the Raft consensus protocol.
This greatly simplifies Kafka’s architecture by consolidating responsibility for metadata into Kafka itself, rather than splitting it between two different systems: ZooKeeper and Kafka.

More Info can be found here: <https://developer.confluent.io/learn/kraft/>

> **NOTE:** According to [KIP-833](https://cwiki.apache.org/confluence/display/KAFKA/KIP-833%3A+Mark+KRaft+as+Production+Ready), KRaft is now in a production-ready state.

However, if you want to keep using ZooKeeper, you can use the following configuration:

```yaml
version: "2"

services:
  zookeeper:
    image: docker.io/bitnami/zookeeper:3.9
    ports:
      - "2181:2181"
    volumes:
      - "zookeeper_data:/bitnami"
    environment:
      - ALLOW_ANONYMOUS_LOGIN=yes
  kafka:
    image: docker.io/bitnami/kafka:3.4
    ports:
      - "9092:9092"
    volumes:
      - "kafka_data:/bitnami"
    environment:
      - KAFKA_CFG_ZOOKEEPER_CONNECT=zookeeper:2181
    depends_on:
      - zookeeper

volumes:
  zookeeper_data:
    driver: local
  kafka_data:
    driver: local
```

### Accessing Apache Kafka with internal and external clients

In order to use internal and external clients to access Apache Kafka brokers you need to configure one listener for each kind of client.

To do so, add the following environment variables to your docker-compose:

```diff
    environment:
      - KAFKA_CFG_NODE_ID=0
      - KAFKA_CFG_PROCESS_ROLES=controller,broker
      - KAFKA_CFG_CONTROLLER_QUORUM_VOTERS=0@<your_host>:9093
+     - KAFKA_CFG_LISTENERS=PLAINTEXT://:9092,CONTROLLER://:9093,EXTERNAL://:9094
+     - KAFKA_CFG_ADVERTISED_LISTENERS=PLAINTEXT://kafka:9092,EXTERNAL://localhost:9094
+     - KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:PLAINTEXT,EXTERNAL:PLAINTEXT,PLAINTEXT:PLAINTEXT
      - KAFKA_CFG_CONTROLLER_LISTENER_NAMES=CONTROLLER
```

And expose the external port:

(the internal, client one can still be used within the docker network)

```diff
    ports:
-     - '9092:9092'
+     - '9094:9094'
```

**Note**: To connect from an external machine, change `localhost` above to your host's external IP/hostname and include `EXTERNAL://0.0.0.0:9094` in `KAFKA_CFG_LISTENERS` to allow for remote connections.

#### Producer and consumer using external client

These clients, from the same host, will use `localhost` to connect to Apache Kafka.

```console
kafka-console-producer.sh --producer.config /opt/bitnami/kafka/config/producer.properties --bootstrap-server 127.0.0.1:9094 --topic test
kafka-console-consumer.sh --consumer.config /opt/bitnami/kafka/config/consumer.properties --bootstrap-server 127.0.0.1:9094 --topic test --from-beginning
```

If running these commands from another machine, change the address accordingly.

#### Producer and consumer using internal client

These clients, from other containers on the same Docker network, will use the kafka container service hostname to connect to Apache Kafka.

```console
kafka-console-producer.sh --producer.config /opt/bitnami/kafka/config/producer.properties --bootstrap-server kafka:9092 --topic test
kafka-console-consumer.sh --consumer.config /opt/bitnami/kafka/config/consumer.properties --bootstrap-server kafka:9092 --topic test --from-beginning
```

Similarly, application code will need to use `bootstrap.servers=kafka:9092`

More info about Apache Kafka listeners can be found in [this great article](https://rmoff.net/2018/08/02/kafka-listeners-explained/)

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

* [kafka-generate-ssl.sh](https://raw.githubusercontent.com/confluentinc/confluent-platform-security-tools/master/kafka-generate-ssl.sh)

Keep in mind the following notes:

* When prompted to enter a password, use the same one for all.
* Set the Common Name or FQDN values to your Apache Kafka container hostname, e.g. `kafka.example.com`. After entering this value, when prompted "What is your first and last name?", enter this value as well.
  * As an alternative, you can disable host name verification setting the environment variable `KAFKA_CFG_SSL_ENDPOINT_IDENTIFICATION_ALGORITHM` to an empty string.
* When setting up a Apache Kafka Cluster (check the "Setting up an Apache Kafka Cluster") for more information), each Apache Kafka broker and logical client needs its own keystore. You will have to repeat the process for each of the brokers in the cluster.

The following docker-compose file is an example showing how to mount your JKS certificates protected by the password `certificatePassword123`. Additionally it is specifying the Apache Kafka container hostname and the credentials for the client and zookeeper users.

```yaml
version: '2'

services:
  kafka:
    image: 'bitnami/kafka:latest'
    hostname: kafka.example.com
    ports:
      - '9092'
    environment:
      # KRaft
      - KAFKA_CFG_NODE_ID=0
      - KAFKA_CFG_PROCESS_ROLES=controller,broker
      - KAFKA_CFG_CONTROLLER_QUORUM_VOTERS=0@kafka:9093
      # Listeners
      - KAFKA_CFG_LISTENERS=SASL_SSL://:9092,CONTROLLER://:9093
      - KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:SASL_PLAINTEXT,SASL_SSL:SASL_SSL
      - KAFKA_CFG_ADVERTISED_LISTENERS=SASL_SSL://:9092
      - KAFKA_CFG_CONTROLLER_LISTENER_NAMES=CONTROLLER
      - KAFKA_CFG_INTER_BROKER_LISTENER_NAME=SASL_SSL
      - KAFKA_CLIENT_LISTENER_NAME=SASL_SSL # Remove this line if consumer/producer.properties are not required
      # SASL
      - KAFKA_CFG_SASL_MECHANISM_CONTROLLER_PROTOCOL=PLAIN
      - KAFKA_CFG_SASL_MECHANISM_INTER_BROKER_PROTOCOL=PLAIN
      - KAFKA_CONTROLLER_USER=controller_user
      - KAFKA_CONTROLLER_PASSWORD=controller_password
      - KAFKA_INTER_BROKER_USER=interbroker_user
      - KAFKA_INTER_BROKER_PASSWORD=interbroker_password
      - KAFKA_CLIENT_USERS=user
      - KAFKA_CLIENT_PASSWORDS=password
      # SSL
      - KAFKA_TLS_TYPE=JKS # or PEM
      - KAFKA_CERTIFICATE_PASSWORD=certificatePassword123
    volumes:
      # Both .jks and .pem files are supported
      # - './kafka.keystore.pem:/opt/bitnami/kafka/config/certs/kafka.keystore.pem:ro'
      # - './kafka.keystore.key:/opt/bitnami/kafka/config/certs/kafka.keystore.key:ro'
      # - './kafka.truststore.pem:/opt/bitnami/kafka/config/certs/kafka.truststore.pem:ro'
      - './kafka.keystore.jks:/opt/bitnami/kafka/config/certs/kafka.keystore.jks:ro'
      - './kafka.truststore.jks:/opt/bitnami/kafka/config/certs/kafka.truststore.jks:ro'
```

In order to get the required credentials to consume and produce messages you need to provide the credentials in the client. If your Apache Kafka client allows it, use the credentials you've provided.

While producing and consuming messages using the `bitnami/kafka` image, you'll need to point to the `consumer.properties` and/or `producer.properties` file, which contains the needed configuration
to work. You can find this files in the `/opt/bitnami/kafka/config` directory.

Use this to generate messages using a secure setup:

```console
kafka-console-producer.sh --bootstrap-server 127.0.0.1:9092 --topic test --producer.config /opt/bitnami/kafka/config/producer.properties
```

Use this to consume messages using a secure setup

```console
kafka-console-consumer.sh --bootstrap-server 127.0.0.1:9092 --topic test --consumer.config /opt/bitnami/kafka/config/consumer.properties
```

If you use other tools to use your Apache Kafka cluster, you'll need to provide the required information. You can find the required information in the files located at `/opt/bitnami/kafka/config` directory.

#### Inter-Broker communications

When deploying a Apache Kafka cluster with multiple brokers, inter broker communications can be configured with `SASL` or `SASL_SSL` using the following variables:

* `KAFKA_CFG_SASL_MECHANISM_INTER_BROKER_PROTOCOL`: Apache Kafka inter broker communication protocol.
* `KAFKA_INTER_BROKER_USER`: Apache Kafka inter broker communication user.
* `KAFKA_INTER_BROKER_PASSWORD`: Apache Kafka inter broker communication password.

NOTE: When running in KRaft mode, KAFKA_CFG_SASL_MECHANISM_INTER_BROKER_PROTOCOL only supports `PLAIN` mechanism in Kafka version <= 3.4.

#### Control plane communications

When deploying a Apache Kafka cluster with multiple controllers in KRaft mode, controller communications can be configured with `SASL` or `SASL_SSL` using the following variables:

* `KAFKA_CFG_SASL_MECHANISM_CONTROLLER_PROTOCOL`: Apache Kafka controllers communication protocol.
* `KAFKA_CONTROLLER_USER`: Apache Kafka controllers communication user. Currently only `PLAIN` mechanism is supported.
* `KAFKA_CONTROLLER_PASSWORD`: Apache Kafka controllers communication password.

NOTE: When running in KRaft mode, KAFKA_CFG_SASL_MECHANISM_CONTROLLER_PROTOCOL only supports `PLAIN` mechanism.

#### Apache Kafka SASL configuration

When configuring Apache Kafka listeners with `SASL` or `SASL_SSL` for communications with clients, you can provide your SASL credentials using this environment variables:

* `KAFKA_CLIENT_USERS`: Apache Kafka client user. Default: **user**
* `KAFKA_CLIENT_PASSWORDS`: Apache Kafka client user password. Default: **bitnami**

NOTE: When running in KRaft mode, only the first user:password pair will take effect, as KRaft mode does not support SCRAM mechanism yet.

#### Apache Kafka KRaft mode configuration

KRaft mode can be enabled by providing the following values:

* `KAFKA_CFG_PROCESS_ROLES`: Comma-separated list of Kafka KRaft roles. Allowed values: `controller,broker`, `controller`, `broker`.
* `KAFKA_CFG_NODE_ID`: Unique id for the Kafka node.
* `KAFKA_CFG_LISTENERS`: List of Kafka listeners. If node is set with `controller` role, the listener `CONTROLLER` must be included.
* `KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP`: Maps each listener with a Apache Kafka security protocol. If node is set with `controller` role, this setting is required in order to assign a security protocol for the `CONTROLLER LISTENER`. E.g.: `PLAINTEXT:PLAINTEXT,CONTROLLER:PLAINTEXT`.

In order to configure controllers communications without authentication, you should provide the environment variables below:

* `KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP`: Should include `CONTROLLER:PLAINTEXT`.

In order to configure Apache Kafka controller communications with `SASL`, you should provide the environment variables below:

* `KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP`: Should include `CONTROLLER:SASL`.
* `KAFKA_CFG_SASL_MECHANISM_CONTROLLER_PROTOCOL`: SASL mechanism to use for controllers communications. NOTE: KRaft mode does not yet support SCRAM mechanisms, so the only supported SASL mechanism in KRaft mode would be `PLAIN`.
* `KAFKA_CONTROLLER_USER`: Apache Kafka controllers communication user.
* `KAFKA_CONTROLLER_PASSWORD`: Apache Kafka controllers communication password.

In order to configure Apache Kafka controller communications with `SSL`, you should provide the environment variables below:

* `KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP`: Should include `CONTROLLER:SSL`.
* `KAFKA_TLS_<uppercase_controller_listener_name>_CLIENT_AUTH`: Configures mTLS authentication method for kafka control plane communications. Allowed values: `required`, `requested`, `none`.
* `KAFKA_TLS_TYPE`: Choose the TLS certificate format to use. Allowed values: `JKS`, `PEM`. Defaults: **JKS**.
* Valid keystore and truststore are mounted at `/opt/bitnami/kafka/config/certs/kafka.keystore.jks` and `/opt/bitnami/kafka/config/certs/kafka.truststore.jks`.

In order to authenticate Apache Kafka against a Zookeeper server with `SASL_SSL`, you should provide the environment variables below:

* `KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP`: Should include `CONTROLLER:SASL_SSL`.
* `KAFKA_CFG_SASL_MECHANISM_CONTROLLER_PROTOCOL`: SASL mechanism to use for controllers communications. NOTE: KRaft mode does not yet support SCRAM mechanisms, so the only supported SASL mechanism in KRaft mode would be `PLAIN`.
* `KAFKA_CONTROLLER_USER`: Apache Kafka controllers communication user.
* `KAFKA_CONTROLLER_PASSWORD`: Apache Kafka controllers communication password.
* `KAFKA_TLS_<uppercase_controller_listener_name>_CLIENT_AUTH`: Configures mTLS authentication method for kafka control plane communications. Allowed values: `required`, `requested`, `none`.
* `KAFKA_TLS_TYPE`: Choose the TLS certificate format to use. Allowed values: `JKS`, `PEM`. Defaults: **JKS**.
* Valid keystore and truststore are mounted at `/opt/bitnami/kafka/config/certs/kafka.keystore.jks` and `/opt/bitnami/kafka/config/certs/kafka.truststore.jks`.

> Note: SSL settings are shared by all listeners configured using `SSL` or `SASL_SSL` protocols. Setting different certificates per listener is not yet supported.

#### Apache Kafka ZooKeeper mode configuration

Zookeeper mode can be enabled by providing the following values:

* `KAFKA_CFG_ZOOKEEPER_CONNECT`: Comma-separated list of Zookeeper connection strings. E.g `<zk_host1>:<zk_port1>,<zk_host2>:<zk_port2>`
* `KAFKA_CFG_BROKER_ID`: **Optional** ID of the Kafka broker. If not set, a random ID will be automatically generated.

There are different options of configuration to connect a Zookeeper server.

In order to connect a Zookeeper server without authentication, you should provide the environment variables below:

* `KAFKA_ZOOKEEPER_PROTOCOL`: **PLAINTEXT**.

In order to authenticate Apache Kafka against a Zookeeper server with `SASL`, you should provide the environment variables below:

* `KAFKA_ZOOKEEPER_PROTOCOL`: **SASL**.
* `KAFKA_ZOOKEEPER_USER`: Apache Kafka Zookeeper user for SASL authentication. No defaults.
* `KAFKA_ZOOKEEPER_PASSWORD`: Apache Kafka Zookeeper user password for SASL authentication. No defaults.

In order to authenticate Apache Kafka against a Zookeeper server with `SSL`, you should provide the environment variables below:

* `KAFKA_ZOOKEEPER_PROTOCOL`: **SSL**.
* `KAFKA_ZOOKEEPER_TLS_KEYSTORE_PASSWORD`: Apache Kafka Zookeeper keystore file password and key password. No defaults.
* `KAFKA_ZOOKEEPER_TLS_TRUSTSTORE_PASSWORD`: Apache Kafka Zookeeper truststore file password. No defaults.
* `KAFKA_ZOOKEEPER_TLS_VERIFY_HOSTNAME`: Verify Zookeeper hostname on TLS certificates. Defaults: **true**.
* `KAFKA_ZOOKEEPER_TLS_TYPE`: Choose the TLS certificate format to use. Allowed values: `JKS`, `PEM`. Defaults: **JKS**.

In order to authenticate Apache Kafka against a Zookeeper server with `SASL_SSL`, you should provide the environment variables below:

* `KAFKA_ZOOKEEPER_PROTOCOL`: **SASL_SSL**.
* `KAFKA_ZOOKEEPER_USER`: Apache Kafka Zookeeper user for SASL authentication. No defaults.
* `KAFKA_ZOOKEEPER_PASSWORD`: Apache Kafka Zookeeper user password for SASL authentication. No defaults.
* `KAFKA_ZOOKEEPER_TLS_TRUSTSTORE_FILE`: Apache Kafka Zookeeper truststore file location. Set it if the mount location is different from `/bitnami/kafka/conf/certs/zookeeper.truststore.pem`, `/bitnami/kafka/conf/certs/zookeeper.truststore.jks`, `/opt/bitnami/kafka/config/certs/zookeeper.truststore.jks` or `/opt/bitnami/kafka/conf/certs/zookeeper.truststore.pem` No defaults.
* `KAFKA_ZOOKEEPER_TLS_KEYSTORE_PASSWORD`: Apache Kafka Zookeeper keystore file password and key password. No defaults.
* `KAFKA_ZOOKEEPER_TLS_TRUSTSTORE_PASSWORD`: Apache Kafka Zookeeper truststore file password. No defaults.
* `KAFKA_ZOOKEEPER_TLS_VERIFY_HOSTNAME`: Verify Zookeeper hostname on TLS certificates. Defaults: **true**.
* `KAFKA_ZOOKEEPER_TLS_TYPE`: Choose the TLS certificate format to use. Allowed values: `JKS`, `PEM`. Defaults: **JKS**.

> Note: You **must** also use your own certificates for SSL. You can mount your Java Key Stores (`zookeeper.keystore.jks` and `zookeeper.truststore.jks`) or PEM files (`zookeeper.keystore.pem`, `zookeeper.keystore.key` and `zookeeper.truststore.pem`) into `/opt/bitnami/kafka/conf/certs`. If client authentication is `none` or `want` in Zookeeper, the cert files are optional.

### Setting up a Apache Kafka cluster

An Apache Kafka cluster can easily be setup with the Bitnami Apache Kafka Docker image using the following environment variables:

* `KAFKA_CFG_CONTROLLER_QUORUM_VOTERS`: Comma separated host:port pairs, each corresponding to a Kafka controller connection.

#### Step 1: Create the first node for Apache Kafka

The first step is to create one Apache Kafka instance.

```console
docker run --name kafka-0 \
  --network app-tier \
  -e KAFKA_CFG_NODE_ID=0 \
  -e KAFKA_CFG_PROCESS_ROLES=controller,broker \
  -e KAFKA_CFG_LISTENERS=PLAINTEXT://:9092,CONTROLLER://:9093 \
  -e KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT \
  -e KAFKA_CFG_CONTROLLER_QUORUM_VOTERS=0@kafka-0:9093,1@kafka-1:9093,2@kafka-2:9093 \
  -e KAFKA_CFG_OFFSETS_TOPIC_REPLICATION_FACTOR=3 \
  -e KAFKA_CFG_TRANSACTION_STATE_LOG_REPLICATION_FACTOR=3 \
  -e KAFKA_CFG_TRANSACTION_STATE_LOG_MIN_ISR=2 \
  -e KAFKA_KRAFT_CLUSTER_ID=abcdefghijklmnopqrstuv \
  -p :9092 \
  -p :9093 \
  bitnami/kafka:latest
```

#### Step 2: Create the second node

Next we start a new Apache Kafka container.

```console
docker run --name kafka-1 \
  --network app-tier \
  -e KAFKA_CFG_NODE_ID=1 \
  -e KAFKA_CFG_PROCESS_ROLES=controller,broker \
  -e KAFKA_CFG_LISTENERS=PLAINTEXT://:9092,CONTROLLER://:9093 \
  -e KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT \
  -e KAFKA_CFG_CONTROLLER_QUORUM_VOTERS=0@kafka-0:9093,1@kafka-1:9093,2@kafka-2:9093 \
  -e KAFKA_CFG_OFFSETS_TOPIC_REPLICATION_FACTOR=3 \
  -e KAFKA_CFG_TRANSACTION_STATE_LOG_REPLICATION_FACTOR=3 \
  -e KAFKA_CFG_TRANSACTION_STATE_LOG_MIN_ISR=2 \
  -e KAFKA_KRAFT_CLUSTER_ID=abcdefghijklmnopqrstuv \
  -p :9092 \
  -p :9093 \
  bitnami/kafka:latest
```

### Step 3: Create the third node

Next we start another new Apache Kafka container.

```console
docker run --name kafka-3 \
  --network app-tier \
  -e KAFKA_CFG_NODE_ID=3 \
  -e KAFKA_CFG_PROCESS_ROLES=controller,broker \
  -e KAFKA_CFG_LISTENERS=PLAINTEXT://:9092,CONTROLLER://:9093 \
  -e KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT \
  -e KAFKA_CFG_CONTROLLER_QUORUM_VOTERS=0@kafka-0:9093,1@kafka-1:9093,2@kafka-2:9093 \
  -e KAFKA_CFG_OFFSETS_TOPIC_REPLICATION_FACTOR=3 \
  -e KAFKA_CFG_TRANSACTION_STATE_LOG_REPLICATION_FACTOR=3 \
  -e KAFKA_CFG_TRANSACTION_STATE_LOG_MIN_ISR=2 \
  -e KAFKA_KRAFT_CLUSTER_ID=abcdefghijklmnopqrstuv \
  -p :9092 \
  -p :9093 \
  bitnami/kafka:latest
```

You now have an Apache Kafka cluster up and running. You can scale the cluster by adding/removing slaves without incurring any downtime.

A docker-compose version of this deployment can be found in the file `docker-compose-cluster.yml`.

#### Example: Create a replicated topic

A replicated topic could be created using the following command:

```console
root@kafka-0:/# /opt/bitnami/kafka/bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --topic mytopic --partitions 3 --replication-factor 3
Created topic "mytopic".

root@kafka-0:/# /opt/bitnami/kafka/bin/kafka-topics.sh --describe --bootstrap-server localhost:9092 --topic mytopic
Topic:mytopic   PartitionCount:3        ReplicationFactor:3     Configs:
        Topic: mytopic  Partition: 0    Leader: 2       Replicas: 2,3,1 Isr: 2,3,1
        Topic: mytopic  Partition: 1    Leader: 3       Replicas: 3,1,2 Isr: 3,1,2
        Topic: mytopic  Partition: 2    Leader: 1       Replicas: 1,2,3 Isr: 1,2,3
```

### Setting up a Apache Kafka KRaft cluster with dedicated nodes

The following docker-compose can be use as guide to build a Apache Kafka cluster with dedicated nodes.
Please note this deployment is not suited for production usage as it does not met quorum minimums to prevent split-brain scenarios.

```yaml
version: '2'

services:
  kafka-combined:
    image: docker.io/bitnami/kafka:latest
    ports:
      - "9092:9092"
    environment:
      - KAFKA_CFG_NODE_ID=0
      - KAFKA_CFG_PROCESS_ROLES=controller,broker
      - KAFKA_CFG_LISTENERS=PLAINTEXT://:9092,CONTROLLER://:9093
      - KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT
      - KAFKA_CFG_CONTROLLER_QUORUM_VOTERS=0@kafka-0:9093,1@kafka-1:9093
      - KAFKA_CFG_CONTROLLER_LISTENER_NAMES=CONTROLLER
      - KAFKA_KRAFT_CLUSTER_ID=abcdefghijklmnopqrstuv
    volumes:
      - kafka_0_data:/bitnami/kafka
  kafka-controller:
    image: docker.io/bitnami/kafka:latest
    environment:
      - KAFKA_CFG_NODE_ID=1
      - KAFKA_CFG_PROCESS_ROLES=controller
      - KAFKA_CFG_LISTENERS=CONTROLLER://:9093
      - KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:PLAINTEXT
      - KAFKA_CFG_CONTROLLER_QUORUM_VOTERS=0@kafka-0:9093,1@kafka-1:9093
      - KAFKA_CFG_CONTROLLER_LISTENER_NAMES=CONTROLLER
      - KAFKA_KRAFT_CLUSTER_ID=abcdefghijklmnopqrstuv
    volumes:
      - kafka_1_data:/bitnami/kafka
  kafka-broker:
    image: docker.io/bitnami/kafka:latest
    environment:
      - KAFKA_CFG_NODE_ID=2
      - KAFKA_CFG_PROCESS_ROLES=broker
      - KAFKA_CFG_CONTROLLER_QUORUM_VOTERS=0@kafka-0:9093,1@kafka-1:9093
    volumes:
      - kafka_2_data:/bitnami/kafka

volumes:
  kafka_0_data:
    driver: local
  kafka_1_data:
    driver: local
  kafka_2_data:
    driver: local
```

### Full configuration

The image looks for configuration files (server.properties, log4j.properties, etc.) in the `/bitnami/kafka/config/`, this can be changed by setting the KAFKA_MOUNTED_CONF_DIR environment variable.

```console
docker run --name kafka -v /path/to/server.properties:/bitnami/kafka/config/server.properties bitnami/kafka:latest
```

After that, your changes will be taken into account in the server's behaviour.

#### Step 1: Run the Apache Kafka image

Run the Apache Kafka image, mounting a directory from your host.

Modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/kafka/docker-compose.yml) file present in this repository:

```diff
...
services:
  kafka:
    ...
    volumes:
      - 'kafka_data:/bitnami'
+     - /path/to/server.properties:/bitnami/kafka/config/server.properties
```

#### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```console
vi /path/to/server.properties
```

#### Step 3: Restart Apache Kafka

After changing the configuration, restart your Apache Kafka container for changes to take effect.

```console
docker restart kafka
```

Or using Docker Compose:

```console
docker-compose restart kafka
```

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

### Upgrade this image

Bitnami provides up-to-date versions of Apache Kafka, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/kafka:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/kafka:latest`.

#### Step 2: Stop and backup the currently running container

Before continuing, you should backup your container's data, configuration and logs.

Follow the steps on [creating a backup](#backing-up-your-container).

#### Step 3: Remove the currently running container

```console
docker rm -v kafka
```

Or using Docker Compose:

```console
docker-compose rm -v kafka
```

#### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if necessary.

```console
docker run --name kafka bitnami/kafka:latest
```

Or using Docker Compose:

```console
docker-compose up kafka
```

## Migrating from Zookeeper mode to KRaft mode

This guide covers how to execute the Kafka migration from Zookeeper mode to KRaft mode as explained in the [upstream documentation](https://docs.confluent.io/platform/current/installation/migrate-zk-kraft.html) when using the `bitnami/kafka` container.

1. Retrieve the cluster ID from Zookeeper

2. Configure Controller quorum by adding the following env variables in the nodes you'd like to configure as controller-elegible nodes:

    ```console
    KAFKA_CFG_PROCESS_ROLES=controller
    KAFKA_CFG_NODE_ID=<unique_id>
    KAFKA_CFG_CONTROLLER_QUORUM_VOTERS=<controller1_node_id>@<controller1_host>:9093,<controller2_node_id>@<controller2_host>:9093,...
    KAFKA_CFG_CONTROLLER_LISTENER_NAMES=CONTROLLER
    KAFKA_CFG_LISTENERS=CONTROLLER://:9093
    KAFKA_CFG_ZOOKEEPER_METADATA_MIGRATION_ENABLE=true
    KAFKA_CFG_ZOOKEEPER_CONNECT=<zk_host>:<zk_port>
    KAFKA_KRAFT_CLUSTER_ID=<cluster_id_step1>
    ```

3. Configure brokers with migration settings:

    ```console
    KAFKA_CFG_BROKER_ID=<current_broker_id>
    KAFKA_CFG_CONTROLLER_QUORUM_VOTERS=<controller1_node_id>@<controller1_host>:9093,<controller2_node_id>@<controller2_host>:9093,...
    KAFKA_CFG_CONTROLLER_LISTENER_NAMES=CONTROLLER
    KAFKA_CFG_INTER_BROKER_PROTOCOL_VERSION=3.4
    KAFKA_CFG_ZOOKEEPER_METADATA_MIGRATION_ENABLE=true
    KAFKA_CFG_ZOOKEEPER_CONNECT=<zk_host>:<zk_port>
    ```

4. Migrate brokers:

    ```console
    KAFKA_CFG_PROCESS_ROLES=broker
    KAFKA_CFG_NODE_ID=<unique_id>
    KAFKA_CFG_CONTROLLER_QUORUM_VOTERS=<controller1_node_id>@<controller1_host>:9093,<controller2_node_id>@<controller2_host>:9093,...
    KAFKA_CFG_CONTROLLER_LISTENER_NAMES=CONTROLLER
    ```

5. Disable migration mode on controllers:

    ```console
    KAFKA_CFG_PROCESS_ROLES=controller
    KAFKA_CFG_NODE_ID=<unique_id>
    KAFKA_CFG_CONTROLLER_QUORUM_VOTERS=<controller1_node_id>@<controller1_host>:9093,<controller2_node_id>@<controller2_host>:9093,...
    KAFKA_CFG_CONTROLLER_LISTENER_NAMES=CONTROLLER
    KAFKA_CFG_LISTENERS=CONTROLLER://:9093
    KAFKA_KRAFT_CLUSTER_ID=<cluster_id_step1>
    ```

## Notable Changes

### Branches rename

Branch 2 has been renamed to 2.8 and branch 3 has been splited into branches 3.0 and 3.1 mirroing the upstream [Apache Kafka's naming policy](https://kafka.apache.org/downloads)

### 3.5.1-debian-11-r4, 3.4.1-debian-11-r50, 3.3.2-debian-11-r176 and 3.2.3-debian-11-r161

This new release of the bitnami/kafka container includes a refactor in its logic and introduces several breaking changes and improvements:

* Removed env variable KAFKA_ENABLE_KRAFT. Instead, KRaft configuration will be detected if KAFKA_CFG_PROCESS_ROLES is provided.
* By default, the container will not configure neither Zookeeper mode or KRaft mode.
  **IMPORTANT**: Either KAFKA_CFG_PROCESS_ROLES or KAFKA_CFG_ZOOKEEPER_CONNECT must be configured for Apache Kafka to be started.
  The equivalent configuration to the deprecated `KAFKA_ENABLE_KRAFT=true` option would be setting `KAFKA_CFG_PROCESS_ROLES=controller,broker`.
  This change is especially aimed to support migrating from Zookeeper mode to KRaft mode. Once Zookeeper mode is fully removed we will default to a KRaft controller+broker mode.
* Support for broker-only and controller-only nodes in KRaft mode.
  By setting KAFKA_CFG_PROCESS_ROLES, the Bitnami Apache Kafka container can be configured as a dedicated broker or controller node, or run both processes.
* Added support for SASL and SSL protocols in Control plane (controller listener).
  New variables have been added for this purpose:
  * KAFKA_CONTROLLER_USER - Username for the controller communications when SASL is enabled.
  * KAFKA_CONTROLLER_PASSWORD - Password for the controller communications when SASL is enabled.
* Removed the `${KAFKA_CONFIG}/server.properties` vs `${KAFKA_CONFIG}/kraft/server.properties` when using Zookeeper or KRaft mode.
  By default, Kafka uses `${KAFKA_CONFIG}/server.properties`, which is generated from `${KAFKA_CONFIG}/server.properties.original`, the original Kafka configuration file, based on environment variables. If no custom configuration file is mounted, references to both configurations are removed during container initialization.
* Refactor JAAS settings to use the recommended approach `listener.name.${listener_lower}.${mechanism_name}.sasl.jaas.config`.
  The `kafka_jaas.conf` will no longer be generated, although it will continue being loaded if mounted.
  Please note that, according to Kafka documentation, the preference will be:
  * Configuration property `listener.name.<listenerName>.<saslMechanism>.sasl.jaas.config` (Recommended)
  * `<listenerName>.KafkaServer` section of JAAS file
  * KafkaServer section of JAAS file
* The KAFKA_INTER_BROKER_USER and KAFKA_INTER_BROKER_PASSWORD will no longer be valid users in other listeners when INTERNAL listener is provided or KAFKA_CFG_INTER_BROKER_LISTENER_NAME is provided.
* Refactor `kafka_validate` function for consistency with both KRaft and Zookeeper modes and improving existing SASL and SSL validations.
* Definitively remove deprecated legacy values:
  * Alternative mount path `/opt/bitnami/kafka/conf` is no longer valid.
  * Deprecation messages for KAFKA_PORT variable
* Extended existing `BROKER_ID_COMMAND` to support KRaft, by adding `KAFKA_NODE_ID_COMMAND` and `KAFKA_CONTROLLER_QUORUM_VOTERS_COMMAND`.
* The existing `BROKER_ID_COMMAND` variable has been deprecated and replaced by `KAFKA_BROKER_ID_COMMAND` for consistency. It will be removed in a future release, so please update your deployments to use the new variable instead.
* Environment variable `ALLOW_PLAINTEXT_LISTENER` has been removed. This variable was used to ensure Kafka wasn't started without any unauthenticated listener unless explicitly set. Since this new release requires explicitly configuring listeners and listeners' security protocol map, we have decided to remove it.

### 3.4.0-debian-11-r23, 3.3.2-debian-11-r29 and 3.2.3-debian-11-r73

* Apache Kafka is now configured using KRaft. You can disable this configuration with the `KAFKA_ENABLE_KRAFT=false` env var and by following the instructions in this guide.

### 3.0.0-debian-10-r0

* Apache Kafka 3.0 deprecates the `--zookeper` flag in shell commands. Related operations such as topic creation require the use of updated flags. Please, refer to [Apache Kafka's official release notes](https://archive.apache.org/dist/kafka/3.0.0/RELEASE_NOTES.html) for further information on the changes introduced by this version.

### 2.5.0-debian-10-r111

* The `KAFKA_CLIENT_USER` AND `KAFKA_CLIENT_PASSWORD` have been deprecated in favor of `KAFKA_CLIENT_USERS` and `KAFKA_CLIENT_PASSWORDS`.

### 2.5.0-debian-10-r51

* The environment variables `KAFKA_PORT_NUMBER` and `KAFKA_CFG_PORT` was deprecated, you can specify the port number in `KAFKA_CFG_LISTENERS` instead.
* The following environment variables were renamed:

  * `KAFKA_BROKER_USER` -> `KAFKA_CLIENT_USER`
  * `KAFKA_BROKER_PASSWORD` -> `KAFKA_CLIENT_PASSWORD`

* Listeners & advertised listeners must be configured to enable authentication. Check [Security section](#security) for more information.

### 2.4.1-r38-debian-10

The configuration directory was changed to `/opt/bitnami/kafka/config`. Configuration files should be mounted to `/bitnami/kafka/config`.

### 1.1.1-debian-9-r224, 2.2.1-debian-9-r16, 1.1.1-ol-7-r306 and 2.2.1-ol-7-r14

* The following environment variables were beingly wrongly translated into `KAFKA_CFG_` environment variables, and therefore they were being wrongly mapped into Apache Kafka keys:

  * `KAFKA_LOGS_DIRS` -> `KAFKA_CFG_LOG_DIRS`
  * `KAFKA_PORT_NUMBER` -> `KAFKA_CFG_PORT`
  * `KAFKA_ZOOKEEPER_CONNECT_TIMEOUT_MS` -> `KAFKA_CFG_ZOOKEEPER_CONNECTION_TIMEOUT_MS`

* For consistency reasons with previous environment variables, the following `KAFKA_` to `KAFKA_CFG_` environment variable translations are now supported for mapping into Apache Kafka keys:

  * `KAFKA_LOG_DIRS` -> `KAFKA_CFG_LOG_DIRS`
  * `KAFKA_ZOOKEEPER_CONNECTION_TIMEOUT_MS` -> `KAFKA_CFG_ZOOKEEPER_CONNECTION_TIMEOUT_MS`

### 1.1.1-debian-9-r205, 2.2.0-debian-9-r40, 1.1.1-ol-7-r286, and 2.2.0-ol-7-r53

Configuration changes. Most environment variables now start with `KAFKA_CFG_`, as they are now mapped directly to Apache Kafka keys. Variables changed:

* `KAFKA_ADVERTISED_LISTENERS` -> `KAFKA_CFG_ADVERTISED_LISTENERS`
* `KAFKA_BROKER_ID` -> `KAFKA_CFG_BROKER_ID`
* `KAFKA_DEFAULT_REPLICATION_FACTOR` -> `KAFKA_CFG_DEFAULT_REPLICATION_FACTOR`
* `KAFKA_DELETE_TOPIC_ENABLE` -> `KAFKA_CFG_DELETE_TOPIC_ENABLE`
* `KAFKA_INTER_BROKER_LISTENER_NAME` -> `KAFKA_CFG_INTER_BROKER_LISTENER_NAME`
* `KAFKA_LISTENERS` -> `KAFKA_CFG_LISTENERS`
* `KAFKA_LISTENER_SECURITY_PROTOCOL_MAP` -> `KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP`
* `KAFKA_LOGS_DIRS` -> `KAFKA_CFG_LOG_DIRS`
* `KAFKA_LOG_FLUSH_INTERVAL_MESSAGES` -> `KAFKA_CFG_LOG_FLUSH_INTERVAL_MESSAGES`
* `KAFKA_LOG_FLUSH_INTERVAL_MS` -> `KAFKA_CFG_LOG_FLUSH_INTERVAL_MS`
* `KAFKA_LOG_MESSAGE_FORMAT_VERSION` -> `KAFKA_CFG_LOG_MESSAGE_FORMAT_VERSION`
* `KAFKA_LOG_RETENTION_BYTES` -> `KAFKA_CFG_LOG_RETENTION_BYTES`
* `KAFKA_LOG_RETENTION_CHECK_INTERVALS_MS` -> `KAFKA_CFG_LOG_RETENTION_CHECK_INTERVAL_MS`
* `KAFKA_LOG_RETENTION_HOURS` -> `KAFKA_CFG_LOG_RETENTION_HOURS`
* `KAFKA_MAX_MESSAGE_BYTES` -> `KAFKA_CFG_MESSAGE_MAX_BYTES`
* `KAFKA_NUM_IO_THREADS` -> `KAFKA_CFG_NUM_IO_THREADS`
* `KAFKA_NUM_NETWORK_THREADS` -> `KAFKA_CFG_NUM_NETWORK_THREADS`
* `KAFKA_NUM_PARTITIONS` -> `KAFKA_CFG_NUM_PARTITIONS`
* `KAFKA_NUM_RECOVERY_THREADS_PER_DATA_DIR` -> `KAFKA_CFG_NUM_RECOVERY_THREADS_PER_DATA_DIR`
* `KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR` -> `KAFKA_CFG_OFFSETS_TOPIC_REPLICATION_FACTOR`
* `KAFKA_PORT` -> `KAFKA_CFG_PORT`
* `KAFKA_SEGMENT_BYTES` -> `KAFKA_CFG_SEGMENT_BYTES`
* `KAFKA_SOCKET_RECEIVE_BUFFER_BYTES` -> `KAFKA_CFG_SOCKET_RECEIVE_BUFFER_BYTES`
* `KAFKA_SOCKET_REQUEST_MAX_BYTES` -> `KAFKA_CFG_SOCKET_REQUEST_MAX_BYTES`
* `KAFKA_SOCKET_SEND_BUFFER_BYTES` -> `KAFKA_CFG_SOCKET_SEND_BUFFER_BYTES`
* `KAFKA_SSL_ENDPOINT_IDENTIFICATION_ALGORITHM` -> `KAFKA_CFG_SSL_ENDPOINT_IDENTIFICATION_ALGORITHM`
* `KAFKA_TRANSACTION_STATE_LOG_MIN_ISR` -> `KAFKA_CFG_TRANSACTION_STATE_LOG_MIN_ISR`
* `KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR` -> `KAFKA_CFG_TRANSACTION_STATE_LOG_REPLICATION_FACTOR`
* `KAFKA_ZOOKEEPER_CONNECT_TIMEOUT_MS` -> `KAFKA_CFG_ZOOKEEPER_CONNECT_TIMEOUT_MS`
* `KAFKA_ZOOKEEPER_CONNECT` -> `KAFKA_CFG_ZOOKEEPER_CONNECT`

### 1.1.0-r41

* Configuration is not persisted anymore. It should be mounted as a volume or it will be regenerated each time the container is created.
* Dummy certificates are not used anymore when the SASL_SSL listener is configured. These certificates must be mounted as volumes.

### 0.10.2.1-r3

* The kafka container has been migrated to a non-root container approach. Previously the container run as `root` user and the kafka daemon was started as `kafka` user. From now own, both the container and the kafka daemon run as user `1001`.
  As a consequence, the configuration files are writable by the user running the kafka process.

### 0.10.2.1-r0

* New Bitnami release

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kafka).

If you detect any issue in the `docker-compose.yaml` file, feel free to report it or contribute with a fix by following our [Contributing Guidelines](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md).

## Contributing

We'd love for you to contribute to this Docker image. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/containers/issues/new/choose). For us to provide better support, be sure to include the following information in your issue:

* Host OS and version
* Docker version (`docker version`)
* Output of `docker info`
* Version of this container
* The command you used to run the container, and any relevant output you saw (masking any sensitive information)

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
