# What is keycloak?

> Keycloak is a high performance Java-based identity and access management solution. It lets developers add an authentication layer to their applications with minimum effort.

[Overview of keycloak](https://www.keycloak.org)

# TL;DR

```console
$ docker run --name keycloak bitnami/keycloak:latest
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.

> This [CVE scan report](https://quay.io/repository/bitnami/keycloak?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy Keycloak in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Thanos Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/keycloak).

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`12`, `12-debian-10`, `12.0.4`, `12.0.4-debian-10-r75`, `latest` (12/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-keycloak/blob/12.0.4-debian-10-r75/12/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/keycloak GitHub repo](https://github.com/bitnami/bitnami-docker-keycloak).

# Get this image

The recommended way to get the Bitnami keycloak Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/keycloak).

```console
$ docker pull bitnami/keycloak:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/keycloak/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/keycloak:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/keycloak:latest 'https://github.com/bitnami/bitnami-docker-keycloak.git#master:12/debian-10'
```

# Configuration

## Admin credentials

The Bitnami Keycloak container can create a default admin user by setting the following environment variables:

- `KEYCLOAK_CREATE_ADMIN_USER`: Create administrator user on boot. Default: **true**.
- `KEYCLOAK_ADMIN_USER`: Administrator default user. Default: **user**.
- `KEYCLOAK_ADMIN_PASSWORD`: Administrator default password. Default: **bitnami**.
- `KEYCLOAK_MANAGEMENT_USER`: WildFly default management user. Default: **manager**.
- `KEYCLOAK_MANAGEMENT_PASSWORD`: WildFly default management password. Default: **bitnami1**.

## Connecting to a PostgreSQL database

The Bitnami Keycloak container requires a PostgreSQL database to work. This is configured with the following environment variables:

- `KEYCLOAK_DATABASE_HOST`: PostgreSQL host. Default: **postgresql**.
- `KEYCLOAK_DATABASE_PORT`: PostgreSQL port. Default: **5432**.
- `KEYCLOAK_DATABASE_NAME`: PostgreSQL database name. Default: **bitnami_keycloak**.
- `KEYCLOAK_DATABASE_USER`: PostgreSQL database user. Default: **bn_keycloak**.
- `KEYCLOAK_DATABASE_PASSWORD`: PostgreSQL database password. No defaults.
- `KEYCLOAK_DATABASE_SCHEMA`: PostgreSQL database schema. Default: **public**.

## Port and address binding

The listening port and listening address can be configured with the following environment variables:

- `KEYCLOAK_HTTP_PORT`: Keycloak HTTP port. Default: **8080**.
- `KEYCLOAK_HTTPS_PORT`: Keycloak HTTPS port. Default: **8443**.
- `KEYCLOAK_BIND_ADDRESS`: Keycloak bind address. Default: **0.0.0.0**.

## Extra arguments to Keycloak startup

In case you want to add extra flags to the Keycloak `standalone.sh` command, use the `KEYCLOAK_EXTRA_ARGS` variable. Example:

```console
$ docker run --name keycloak \
  -e KEYCLOAK_EXTRA_ARGS="-Dkeycloak.profile.feature.scripts=enabled" \
  bitnami/keycloak:latest
```

## Initializing a new instance

When the container is launched, it will execute the files with extension `.sh` located at `/docker-entrypoint-initdb.d`.

In order to have your custom files inside the docker image you can mount them as a volume.

```console
$ docker run --name keycloak \
  -v /path/to/init-scripts:/docker-entrypoint-initdb.d \
  bitnami/keycloak:latest
```

Or with docker-compose

```yaml
keycloak:
  image: bitnami/keycloak:latest
  volumes:
    - /path/to/init-scripts:/docker-entrypoint-initdb.d
```

## TLS Encryption

The Bitnami Keycloak Docker image allows configuring TLS encryption between nodes and between server-client. This is done by mounting in `/opt/bitnami/keycloak/certs` two files:

 - `keystore`: File with the server keystore
 - `truststore`: File with the server truststore

> Note: find more information about how to create these files at the [Keycloak documentation](https://github.com/keycloak/keycloak-documentation/blob/master/openshift/topics/advanced_concepts.adoc#creating-https-and-jgroups-keystores-and-truststore-for-the-project_name-server).

Apart from that, the following environment variables must be set:

 - `KEYCLOAK_ENABLE_TLS`: Enable TLS encryption using the keystore. Default: **false**.
 - `KEYCLOAK_TLS_KEYSTORE_FILE`: Path to the keystore file (e.g. `/opt/bitnami/keycloak/certs/keystore.jks`). No defaults.
 - `KEYCLOAK_TLS_TRUSTSTORE_FILE`: Path to the truststore file (e.g. `/opt/bitnami/keycloak/certs/truststore.jks`). No defaults.
 - `KEYCLOAK_TLS_KEYSTORE_PASSWORD`: Password for accessing the keystore. No defaults.
 - `KEYCLOAK_TLS_TRUSTSTORE_PASSWORD`: Password for accessing the truststore. No defaults.

## Cluster configuration

The Bitnami Keycloak Docker image allows configuring a highly available cluster. In order to do so, two elements must be configured: the service discovery mechanism and the caching settings.

Service discovery is configured by setting the following variables:

- `KEYCLOAK_JGROUPS_DISCOVERY_PROTOCOL`: Sets the protocol that Keycloak nodes would use to discover new peers. Check the [official jgroups documentation](http://www.jgroups.org/javadoc3/org/jgroups/protocols/) for the list of available protocols. No defaults.
- `KEYCLOAK_JGROUPS_DISCOVERY_PROPERTIES`: Sets the properties for the discovery protocol set in `KEYCLOAK_JGROUPS_DISCOVERY_PROTOCOL`. It is a comma-separated list of `key=>value` pairs. No defaults.
- `KEYCLOAK_JGROUPS_TRANSPORT_STACK`: Transport stack for the discovery protocol set in `KEYCLOAK_JGROUPS_DISCOVERY_PROTOCOL`. Default: **tcp**.

Caching is configured by setting the following variables:

- `KEYCLOAK_CACHE_OWNERS_COUNT`: Number of nodes that will replicate cached data. Default: **1**.
- `KEYCLOAK_AUTH_CACHE_OWNERS_COUNT`: Number of nodes that will replicate cached authentication data. Default: **1**.

In the example below we will configure a 3-node keycloak cluster with a database-based discovery protocol (JDBC_PING):

```yaml
version: "2"
services:
  postgresql:
    image: "docker.io/bitnami/postgresql:11"
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - POSTGRESQL_USERNAME=bn_keycloak
      - POSTGRESQL_DATABASE=bitnami_keycloak
    volumes:
      - "postgresql_data:/bitnami/postgresql"
  keycloak-1:
    image: docker.io/bitnami/keycloak:latest
    ports:
      - "80:8080"
    environment:
      - KEYCLOAK_CREATE_ADMIN_USER=true
      - KEYCLOAK_JGROUPS_DISCOVERY_PROTOCOL=JDBC_PING
      - 'KEYCLOAK_JGROUPS_DISCOVERY_PROPERTIES=datasource_jndi_name=>java:jboss/datasources/KeycloakDS, initialize_sql=>"CREATE TABLE IF NOT EXISTS JGROUPSPING ( own_addr varchar(200) NOT NULL, cluster_name varchar(200) NOT NULL, created timestamp default current_timestamp, ping_data BYTEA, constraint PK_JGROUPSPING PRIMARY KEY (own_addr, cluster_name))"'
      - KEYCLOAK_CACHE_OWNERS_COUNT=3
      - KEYCLOAK_AUTH_CACHE_OWNERS_COUNT=3
    depends_on:
      - postgresql
  keycloak-2:
    image: docker.io/bitnami/keycloak:latest
    ports:
      - "81:8080"
    depends_on:
      - postgresql
    environment:
      - KEYCLOAK_JGROUPS_DISCOVERY_PROTOCOL=JDBC_PING
      - 'KEYCLOAK_JGROUPS_DISCOVERY_PROPERTIES=datasource_jndi_name=>java:jboss/datasources/KeycloakDS, initialize_sql=>"CREATE TABLE IF NOT EXISTS JGROUPSPING ( own_addr varchar(200) NOT NULL, cluster_name varchar(200) NOT NULL, created timestamp default current_timestamp, ping_data BYTEA, constraint PK_JGROUPSPING PRIMARY KEY (own_addr, cluster_name))"'
      - KEYCLOAK_CACHE_OWNERS_COUNT=3
      - KEYCLOAK_AUTH_CACHE_OWNERS_COUNT=3
  keycloak-3:
    image: docker.io/bitnami/keycloak:latest
    ports:
      - "82:8080"
    depends_on:
      - postgresql
    environment:
      - KEYCLOAK_JGROUPS_DISCOVERY_PROTOCOL=JDBC_PING
      - 'KEYCLOAK_JGROUPS_DISCOVERY_PROPERTIES=datasource_jndi_name=>java:jboss/datasources/KeycloakDS, initialize_sql=>"CREATE TABLE IF NOT EXISTS JGROUPSPING ( own_addr varchar(200) NOT NULL, cluster_name varchar(200) NOT NULL, created timestamp default current_timestamp, ping_data BYTEA, constraint PK_JGROUPSPING PRIMARY KEY (own_addr, cluster_name))"'
      - KEYCLOAK_CACHE_OWNERS_COUNT=3
      - KEYCLOAK_AUTH_CACHE_OWNERS_COUNT=3
volumes:
  postgresql_data:
    driver: local
```

In case of adding a reverse proxy, you need to set the `KEYCLOAK_PROXY_ADDRESS_FORWARDING` to `true.

## Adding custom themes

In order to add new themes to Keycloak, you can mount them to the `/opt/bitnami/keycloak/themes` folder. The example below mounts a new theme.

```yaml
version: "2"
services:
  postgresql:
    image: "docker.io/bitnami/postgresql:11-debian-10"
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - POSTGRESQL_USERNAME=bn_keycloak
      - POSTGRESQL_DATABASE=bitnami_keycloak
    volumes:
      - "postgresql_data:/bitnami/postgresql"
  keycloak:
    image: docker.io/bitnami/keycloak:12-debian-10
    ports:
      - "80:8080"
    environment:
      - KEYCLOAK_CREATE_ADMIN_USER=true
    depends_on:
      - postgresql
    volumes:
      - "./mynewtheme:/opt/bitnami/keycloak/themes/mynewtheme"
volumes:
  postgresql_data:
    driver: local
```

## Enabling statistics

The Bitnami Keycloak container can activate different set of statistics (database, jgroups and http) by setting the environment variable `KEYCLOAK_ENABLE_STATISTICS=true`.

### Full configuration

The image looks for configuration files (e.g. `standalone-ha.xml`) in the `/bitnami/keycloak/configuration/` directory, this directory can be changed by setting the KEYCLOAK_MOUNTED_CONF_DIR environment variable.

```console
$ docker run --name keycloak \
    -v /path/to/standalone-ha.xml:/bitnami/keycloak/configuration/standalone-ha.xml \
    bitnami/keycloak:latest
```

Or with docker-compose

```yaml
keycloak:
  image: bitnami/keycloak:latest
  volumes:
    - /path/to/standalone-ha.xml:/bitnami/keycloak/configuration/standalone-ha.xml:ro
```

After that, your changes will be taken into account in the server's behaviour.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-keycloak/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-keycloak/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-keycloak/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright 2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
