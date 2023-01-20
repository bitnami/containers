# Keycloak packaged by Bitnami

## What is Keycloak?

> Keycloak is a high performance Java-based identity and access management solution. It lets developers add an authentication layer to their applications with minimum effort.

[Overview of Keycloak](https://www.keycloak.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
$ docker run --name keycloak bitnami/keycloak:latest
```

### Docker Compose

```console
$ curl -LO https://raw.githubusercontent.com/bitnami/containers/main/bitnami/keycloak/docker-compose.yml
$ docker-compose up
```

**Warning**: This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options in the [Configuration](#configuration) section for a more secure deployment.
## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

## How to deploy Keycloak in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Keycloak Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/keycloak).

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami keycloak Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/keycloak).

```console
$ docker pull bitnami/keycloak:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/keycloak/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/keycloak:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
$ git clone https://github.com/bitnami/containers.git
$ cd bitnami/APP/VERSION/OPERATING-SYSTEM
$ docker build -t bitnami/APP:latest .
```

## Configuration

### Admin credentials

The Bitnami Keycloak container can create a default admin user by setting the following environment variables:

- `KEYCLOAK_CREATE_ADMIN_USER`: Create administrator user on boot. Default: **true**.
- `KEYCLOAK_ADMIN_USER`: Administrator default user. Default: **user**.
- `KEYCLOAK_ADMIN_PASSWORD`: Administrator default password. Default: **bitnami**.
- `KEYCLOAK_MANAGEMENT_USER`: WildFly default management user. Default: **manager**.
- `KEYCLOAK_MANAGEMENT_PASSWORD`: WildFly default management password. Default: **bitnami1**.

### Connecting to a PostgreSQL database

The Bitnami Keycloak container requires a PostgreSQL database to work. This is configured with the following environment variables:

- `KEYCLOAK_DATABASE_HOST`: PostgreSQL host. Default: **postgresql**.
- `KEYCLOAK_DATABASE_PORT`: PostgreSQL port. Default: **5432**.
- `KEYCLOAK_DATABASE_NAME`: PostgreSQL database name. Default: **bitnami_keycloak**.
- `KEYCLOAK_DATABASE_USER`: PostgreSQL database user. Default: **bn_keycloak**.
- `KEYCLOAK_DATABASE_PASSWORD`: PostgreSQL database password. No defaults.
- `KEYCLOAK_DATABASE_SCHEMA`: PostgreSQL database schema. Default: **public**.
- `KEYCLOAK_JDBC_PARAMS`: PostgreSQL database JDBC parameters (example: `sslmode=verify-full&connectTimeout=30000`). No defaults.

### Port and address binding

The listening port and listening address can be configured with the following environment variables:

- `KEYCLOAK_HTTP_PORT`: Keycloak HTTP port. Default: **8080**.
- `KEYCLOAK_HTTPS_PORT`: Keycloak HTTPS port. Default: **8443**.
- `KEYCLOAK_BIND_ADDRESS`: Keycloak bind address. Default: **0.0.0.0**.

### Extra arguments to Keycloak startup

In case you want to add extra flags to the Keycloak use the `KEYCLOAK_EXTRA_ARGS` variable. Example:

```console
$ docker run --name keycloak \
  -e KEYCLOAK_EXTRA_ARGS="-Dkeycloak.profile.feature.scripts=enabled" \
  bitnami/keycloak:latest
```

Or, if you need flags which are applied directly to keycloak executable, you can use `KEYCLOAK_EXTRA_ARGS_PREPENDED` variable. Example:

```console
$ docker run --name keycloak \
  -e KEYCLOAK_EXTRA_ARGS_PREPENDED="--spi-login-protocol-openid-connect-legacy-logout-redirect-uri=true" \
  bitnami/keycloak:latest
```

### Initializing a new instance

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

### TLS Encryption

The Bitnami Keycloak Docker image allows configuring HTTPS/TLS encription. This is done by mounting in `/opt/bitnami/keycloak/certs` two files:

 - `keystore`: File with the server keystore
 - `truststore`: File with the server truststore

> Note: find more information about how to create these files at the [Keycloak documentation](https://www.keycloak.org/docs/latest/server_installation/#_truststore).

Apart from that, the following environment variables must be set:

 - `KEYCLOAK_ENABLE_HTTPS`: Enable TLS encryption using the keystore. Default: **false**.
 - `KEYCLOAK_HTTPS_KEY_STORE_FILE`: Path to the keystore file (e.g. `/opt/bitnami/keycloak/certs/keystore.jks`). No defaults.
 - `KEYCLOAK_HTTPS_TRUST_STORE_FILE`: Path to the truststore file (e.g. `/opt/bitnami/keycloak/certs/truststore.jks`). No defaults.
 - `KEYCLOAK_HTTPS_KEY_STORE_PASSWORD`: Password for accessing the keystore. No defaults.
 - `KEYCLOAK_HTTPS_TRUST_STORE_PASSWORD`: Password for accessing the truststore. No defaults.
 - `KEYCLOAK_HTTPS_USE_PEM`: Set to true to configure HTTPS using PEM certificates'. Default: **false**.
 - `KEYCLOAK_HTTPS_CERTIFICATE_FILE`: Path to the PEM certificate file (e.g. `/opt/bitnami/keycloak/certs/tls.crt`). No defaults.
 - `KEYCLOAK_HTTPS_CERTIFICATE_KEY_FILE`: Path to the PEM key file (e.g. `/opt/bitnami/keycloak/certs/tls.key`). No defaults.

### SPI TLS truststore

The Bitnami Keycloak Docker image supports configuring a truststore for HTTP/TLS connection with Keycloak SPIs.

 - `KEYCLOAK_SPI_TRUSTSTORE_FILE`: Path to the Keycloak SPI truststore file (e.g. `/opt/bitnami/keycloak/certs-spi/truststore.jks`). No defaults.
 - `KEYCLOAK_SPI_TRUSTSTORE_PASSWORD`: Password for decrypting the SPI truststore file. No defaults.
 - `KEYCLOAK_SPI_TRUSTSTORE_FILE_HOSTNAME_VERIFICATION_POLICY`: Hostname verification policy for SPI connection over HTTPS/TLS

### Adding custom themes

In order to add new themes to Keycloak, you can mount them to the `/opt/bitnami/keycloak/themes` folder. The example below mounts a new theme.

```yaml
version: '2'
services:
  postgresql:
    image: docker.io/bitnami/postgresql:latest
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - POSTGRESQL_USERNAME=bn_keycloak
      - POSTGRESQL_DATABASE=bitnami_keycloak
    volumes:
      - 'postgresql_data:/bitnami/postgresql'
  keycloak:
    image: docker.io/bitnami/keycloak:latest
    ports:
      - "80:8080"
    environment:
      - KEYCLOAK_CREATE_ADMIN_USER=true
    depends_on:
      - postgresql
    volumes:
      - './mynewtheme:/opt/bitnami/keycloak/themes/mynewtheme'
volumes:
  postgresql_data:
    driver: local
```

### Enabling statistics

The Bitnami Keycloak container can activate different set of statistics (database, jgroups and http) by setting the environment variable `KEYCLOAK_ENABLE_STATISTICS=true`.

#### Full configuration

The image looks for configuration files in the `/bitnami/keycloak/configuration/` directory, this directory can be changed by setting the KEYCLOAK_MOUNTED_CONF_DIR environment variable.

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

## Notable Changes

### 19-debian-11-r4

- TLS environment variables have been renamed to match upstream.
  - `KEYCLOAK_ENABLE_TLS` was renamed as `KEYCLOAK_ENABLE_HTTPS`.
  - `KEYCLOAK_TLS_KEYSTORE_FILE` was renamed as `KEYCLOAK_TLS_KEY_STORE_FILE`.
  - `KEYCLOAK_TLS_TRUSTSTORE_FILE` was renamed as `KEYCLOAK_TLS_TRUST_STORE_FILE`.
  - `KEYCLOAK_TLS_KEYSTORE_PASSWORD` was renamed as `KEYCLOAK_TLS_KEY_STORE_PASSWORD`.
  - `KEYCLOAK_TLS_TRUSTSTORE_PASSWORD` was renamed as `KEYCLOAK_TLS_TRUST_STORE_PASSWORD`.
- HTTPS/TLS can now be configured using PEM certificates.
- Added support to add SPI truststore file.

### 17-debian-10

Keycloak 17 is powered by Quarkus and to deploy it in production mode it is necessary to set up TLS.
To do this you need to set `KEYCLOAK_PRODUCTION` to **true** and configure TLS

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/containers/issues/new/choose). For us to provide better support, be sure to fill the issue template.

## License

Copyright &copy; 2023 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
