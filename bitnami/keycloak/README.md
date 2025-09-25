# Bitnami package for Keycloak

## What is Keycloak?

> Keycloak is a high performance Java-based identity and access management solution. It lets developers add an authentication layer to their applications with minimum effort.

[Overview of Keycloak](https://www.keycloak.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name keycloak bitnami/keycloak:latest
```

**Warning**: This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options in the [Configuration](#configuration) section for a more secure deployment.

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

## How to deploy Keycloak in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Keycloak Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/keycloak).

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami keycloak Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/keycloak).

```console
docker pull bitnami/keycloak:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/keycloak/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/keycloak:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Configuration

### Environment variables

#### Customizable environment variables

| Name                            | Description                                                                                        | Default Value                 |
|---------------------------------|----------------------------------------------------------------------------------------------------|-------------------------------|
| `KEYCLOAK_MOUNTED_CONF_DIR`     | Directory for including custom configuration files (that override the default generated ones)      | `${KEYCLOAK_VOLUME_DIR}/conf` |
| `KC_RUN_IN_CONTAINER`           | Keycloak kc.sh context                                                                             | `true`                        |
| `KEYCLOAK_PRODUCTION`           | Run in production mode.                                                                            | `false`                       |
| `KEYCLOAK_EXTRA_ARGS`           | Append extra arguments to Keycloak start command.                                                  | `nil`                         |
| `KEYCLOAK_EXTRA_ARGS_PREPENDED` | Prepend extra arguments to Keycloak start command.                                                 | `nil`                         |
| `KC_HTTP_MANAGEMENT_PORT`       | Management interface port.                                                                         | `9000`                        |
| `KEYCLOAK_ENABLE_HTTPS`         | Enable SSL certificates                                                                            | `false`                       |
| `KEYCLOAK_HTTPS_USE_PEM`        | Set to true to configure HTTPS using PEM certificates                                              | `false`                       |
| `KC_BOOTSTRAP_ADMIN_USERNAME`   | Bootstrap admin username                                                                           | `user`                        |
| `KC_BOOTSTRAP_ADMIN_PASSWORD`   | Bootstrap admin password                                                                           | `nil`                         |
| `KC_HTTP_PORT`                  | HTTP port                                                                                          | `8080`                        |
| `KC_HTTPS_PORT`                 | HTTPS port                                                                                         | `8443`                        |
| `KC_HTTP_RELATIVE_PATH`         | Set the path relative to "/" for serving resources.                                                | `/`                           |
| `KC_LOG_LEVEL`                  | Keycloak log level                                                                                 | `info`                        |
| `KC_LOG_CONSOLE_OUTPUT`         | Keycloak log output                                                                                | `default`                     |
| `KC_METRICS_ENABLED`            | Enable metrics.                                                                                    | `false`                       |
| `KC_HEALTH_ENABLED`             | Enable health check endpoints.                                                                     | `false`                       |
| `KC_CACHE`                      | Cache mechanism for high-availability.                                                             | `ispn`                        |
| `KC_CACHE_STACK`                | Default stack to use for cluster communication and node discovery.                                 | `nil`                         |
| `KC_CACHE_CONFIG_FILE`          | Path to the file from which cache configuration should be loaded from.                             | `cache-ispn.xml`              |
| `KC_HOSTNAME`                   | Keycloak hostname                                                                                  | `nil`                         |
| `KC_HOSTNAME_ADMIN`             | Keycloak admin hostname                                                                            | `nil`                         |
| `KC_HOSTNAME_STRICT`            | Disables dynamically resolving the hostname from request headers                                   | `false`                       |
| `KC_HTTPS_TRUST_STORE_FILE`     | Path to the SSL truststore file                                                                    | `nil`                         |
| `KC_HTTPS_TRUST_STORE_PASSWORD` | Password for decrypting the truststore file                                                        | `nil`                         |
| `KC_HTTPS_KEY_STORE_FILE`       | Path to the SSL keystore file                                                                      | `nil`                         |
| `KC_HTTPS_KEY_STORE_PASSWORD`   | Password for decrypting the keystore file                                                          | `nil`                         |
| `KC_HTTPS_CERTIFICATE_FILE`     | Path to the PEM certificate file                                                                   | `nil`                         |
| `KC_HTTPS_CERTIFICATE_KEY_FILE` | Path to the PEM key file                                                                           | `nil`                         |
| `KC_DB`                         | Database vendor                                                                                    | `postgres`                    |
| `KEYCLOAK_DATABASE_HOST`        | Database hostname                                                                                  | `postgresql`                  |
| `KEYCLOAK_DATABASE_PORT`        | Database port                                                                                      | `5432`                        |
| `KEYCLOAK_DATABASE_NAME`        | Database name                                                                                      | `bitnami_keycloak`            |
| `KEYCLOAK_JDBC_PARAMS`          | Extra JDBC connection parameters for the database (e.g.: sslmode=verify-full&connectTimeout=30000) | `nil`                         |
| `KEYCLOAK_JDBC_DRIVER`          | JDBC driver to set in the connection string for the database                                       | `postgresql`                  |
| `KC_DB_USERNAME`                | Database username                                                                                  | `bn_keycloak`                 |
| `KC_DB_PASSWORD`                | Database password                                                                                  | `nil`                         |
| `KC_DB_SCHEMA`                  | PostgreSQL database schema                                                                         | `public`                      |
| `KEYCLOAK_INIT_MAX_RETRIES`     | Maximum retries for checking that the database works                                               | `10`                          |
| `KEYCLOAK_DAEMON_USER`          | Keycloak daemon user when running as root                                                          | `keycloak`                    |
| `KEYCLOAK_DAEMON_GROUP`         | Keycloak daemon group when running as root                                                         | `keycloak`                    |

#### Read-only environment variables

| Name                        | Description                                             | Value                             |
|-----------------------------|---------------------------------------------------------|-----------------------------------|
| `BITNAMI_VOLUME_DIR`        | Directory where to mount volumes.                       | `/bitnami`                        |
| `JAVA_HOME`                 | Java installation directory                             | `/opt/bitnami/java`               |
| `KEYCLOAK_BASE_DIR`         | Keycloak base directory                                 | `/opt/bitnami/keycloak`           |
| `KEYCLOAK_BIN_DIR`          | Keycloak bin directory                                  | `$KEYCLOAK_BASE_DIR/bin`          |
| `KEYCLOAK_PROVIDERS_DIR`    | Keycloak providers (extensions) directory               | `$KEYCLOAK_BASE_DIR/providers`    |
| `KEYCLOAK_LOG_DIR`          | Keycloak bin directory                                  | `$KEYCLOAK_PROVIDERS_DIR/log`     |
| `KEYCLOAK_TMP_DIR`          | Keycloak tmp directory                                  | `$KEYCLOAK_PROVIDERS_DIR/tmp`     |
| `KEYCLOAK_DOMAIN_TMP_DIR`   | Keycloak tmp directory                                  | `$KEYCLOAK_BASE_DIR/domain/tmp`   |
| `KEYCLOAK_VOLUME_DIR`       | Path to keycloak mount directory                        | `/bitnami/keycloak`               |
| `KEYCLOAK_CONF_DIR`         | Keycloak configuration directory                        | `$KEYCLOAK_BASE_DIR/conf`         |
| `KEYCLOAK_DEFAULT_CONF_DIR` | Keycloak default configuration directory                | `$KEYCLOAK_BASE_DIR/conf.default` |
| `KEYCLOAK_INITSCRIPTS_DIR`  | Path to keycloak init scripts directory                 | `/docker-entrypoint-initdb.d`     |
| `KEYCLOAK_CONF_FILE`        | Name of the keycloak configuration file (relative path) | `keycloak.conf`                   |

### Extra arguments to Keycloak startup

In case you want to add extra flags to the Keycloak use the `KEYCLOAK_EXTRA_ARGS` variable. Example:

```console
docker run --name keycloak \
  -e KEYCLOAK_EXTRA_ARGS="-Dkeycloak.profile.feature.scripts=enabled" \
  bitnami/keycloak:latest
```

Or, if you need flags which are applied directly to keycloak executable, you can use `KEYCLOAK_EXTRA_ARGS_PREPENDED` variable. Example:

```console
docker run --name keycloak \
  -e KEYCLOAK_EXTRA_ARGS_PREPENDED="--spi-login-protocol-openid-connect-legacy-logout-redirect-uri=true" \
  bitnami/keycloak:latest
```

### Initializing a new instance

When the container is launched, it will execute the files with extension `.sh` located at `/docker-entrypoint-initdb.d`.

In order to have your custom files inside the docker image you can mount them as a volume.

```console
docker run --name keycloak \
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

> Note: find more information about how to create these files at the [Keycloak documentation](https://www.keycloak.org/server/keycloak-truststore).

Apart from that, the following environment variables must be set:

- `KEYCLOAK_ENABLE_HTTPS`: Enable TLS encryption using the keystore. Default: **false**.
- `KEYCLOAK_HTTPS_KEY_STORE_FILE`: Path to the keystore file (e.g. `/opt/bitnami/keycloak/certs/keystore.jks`). No defaults.
- `KEYCLOAK_HTTPS_TRUST_STORE_FILE`: Path to the truststore file (e.g. `/opt/bitnami/keycloak/certs/truststore.jks`). No defaults.
- `KEYCLOAK_HTTPS_KEY_STORE_PASSWORD`: Password for accessing the keystore. No defaults.
- `KEYCLOAK_HTTPS_TRUST_STORE_PASSWORD`: Password for accessing the truststore. No defaults.
- `KEYCLOAK_HTTPS_USE_PEM`: Set to true to configure HTTPS using PEM certificates'. Default: **false**.
- `KEYCLOAK_HTTPS_CERTIFICATE_FILE`: Path to the PEM certificate file (e.g. `/opt/bitnami/keycloak/certs/tls.crt`). No defaults.
- `KEYCLOAK_HTTPS_CERTIFICATE_KEY_FILE`: Path to the PEM key file (e.g. `/opt/bitnami/keycloak/certs/tls.key`). No defaults.

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
      - postgresql_data:/bitnami/postgresql
  keycloak:
    image: docker.io/bitnami/keycloak:latest
    ports:
      - 80:8080
    environment:
      - KEYCLOAK_CREATE_ADMIN_USER=true
    depends_on:
      - postgresql
    volumes:
      - ./mynewtheme:/opt/bitnami/keycloak/themes/mynewtheme
volumes:
  postgresql_data:
    driver: local
```

### Enabling metrics

The Bitnami Keycloak container can activate different set of metrics (database, jgroups and http) by setting the environment variable `KC_METRICS_ENABLED=true`. See [the official documentation](https://www.keycloak.org/observability/configuration-metrics) for more information about these metrics.

### Enabling health endpoints

The Bitnami Keycloak container can activate several endpoints providing information about the health of Keycloak, by setting the environment variable `KC_HEALTH_ENABLED=true`.
See [the official documentation](https://www.keycloak.org/observability/health) for more information about these endpoints.

### Full configuration

The image looks for configuration files in the `/bitnami/keycloak/conf/` directory, this directory can be changed by setting the `KEYCLOAK_MOUNTED_CONF_DIR` environment variable.

```console
docker run --name keycloak \
    -v /path/to/keycloak.conf:/bitnami/keycloak/conf/keycloak.conf \
    bitnami/keycloak:latest
```

Or with docker-compose

```yaml
keycloak:
  image: bitnami/keycloak:latest
  volumes:
    - /path/to/keycloak.conf:/bitnami/keycloak/conf/keycloak.conf:ro
```

After that, your changes will be taken into account in the server's behaviour.

### FIPS configuration in Bitnami Secure Images

The Bitnami Keycloak Docker image from the [Bitnami Secure Images](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Notable Changes

### 26.3.2-debian-12-r1

The following environment variables have been deprecated. Instead rely on the native `KC_*` equivalent environment variables:

- `KEYCLOAK_CACHE_TYPE`, `KEYCLOAK_CACHE_STACK` and `KEYCLOAK_CACHE_CONFIG_FILE`
- `KEYCLOAK_ENABLE_STATISTICS` and `KEYCLOAK_ENABLE_HEALTH_ENDPOINTS`
- `KEYCLOAK_LOG_LEVEL` and `KEYCLOAK_LOG_OUTPUT`
- `KEYCLOAK_HOSTNAME`, `KEYCLOAK_HOSTNAME_ADMIN` and `KEYCLOAK_HOSTNAME_STRICT`
- `KEYCLOAK_PROXY_HEADERS`
- `KEYCLOAK_ADMIN_USER` and `KEYCLOAK_BOOTSTRAP_ADMIN_PASSWORD`

The [https://github.com/aerogear/keycloak-metrics-spi](https://github.com/aerogear/keycloak-metrics-spi) provider is no longer shipped by default in the container image.
Also, support for deprecated SPI truststore was removed.

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

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/keycloak).

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
