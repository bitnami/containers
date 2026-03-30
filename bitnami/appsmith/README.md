# Bitnami Secure Image for Appsmith

> Appsmith is an open source platform for building and maintaining internal tools, such as custom dashboards, admin panels or CRUD apps.

[Overview of Appsmith](https://www.appsmith.com/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run -it --name appsmith bitnami/appsmith:latest
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

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

## Get this image

The Bitnami Appsmith Docker image is only available to [Bitnami Secure Images](https://bitnami.com) customers.

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/appsmith).

## Configuration

The following section describes the supported environment variables

### Environment variables

The following tables list the main variables you can set.

#### Customizable environment variables

| Name                            | Description                                             | Default Value         |
|---------------------------------|---------------------------------------------------------|-----------------------|
| `ALLOW_EMPTY_PASSWORD`          | Allow an empty password.                                | `no`                  |
| `APPSMITH_USERNAME`             | Appsmith default username.                              | `user`                |
| `APPSMITH_PASSWORD`             | Appsmith default password.                              | `bitnami123`          |
| `APPSMITH_EMAIL`                | Appsmith default email.                                 | `user@example.com`    |
| `APPSMITH_MODE`                 | Appsmith service to run (can be backend, client or UI). | `backend`             |
| `APPSMITH_ENCRYPTION_PASSWORD`  | Appsmith database encryption password.                  | `bitnami123`          |
| `APPSMITH_ENCRYPTION_SALT`      | Appsmith database encryption salt.                      | `nil`                 |
| `APPSMITH_API_HOST`             | Appsmith API host.                                      | `appsmith-api`        |
| `APPSMITH_API_PORT`             | Appsmith API port.                                      | `8080`                |
| `APPSMITH_UI_HTTP_PORT`         | Appsmith UI HTTP port.                                  | `8080`                |
| `APPSMITH_UI_HTTPS_PORT`        | Appsmith UI HTTPS port.                                 | `8443`                |
| `APPSMITH_RTS_HOST`             | Appsmith RTS port.                                      | `appsmith-rts`        |
| `APPSMITH_RTS_PORT`             | Appsmith RTS port.                                      | `8091`                |
| `APPSMITH_DATABASE_HOST`        | Database server hosts (comma-separated list).           | `mongodb`             |
| `APPSMITH_DATABASE_PORT_NUMBER` | Database server port.                                   | `27017`               |
| `APPSMITH_DATABASE_NAME`        | Database name.                                          | `bitnami_appsmith`    |
| `APPSMITH_DATABASE_USER`        | Database user name.                                     | `bn_appsmith`         |
| `APPSMITH_DATABASE_PASSWORD`    | Database user password.                                 | `nil`                 |
| `APPSMITH_DATABASE_INIT_DELAY`  | Time to wait before the database is actually ready.     | `0`                   |
| `APPSMITH_REDIS_HOST`           | Redis server host.                                      | `redis`               |
| `APPSMITH_REDIS_PORT_NUMBER`    | Redis server port.                                      | `6379`                |
| `APPSMITH_REDIS_PASSWORD`       | Redis user password.                                    | `nil`                 |
| `APPSMITH_STARTUP_TIMEOUT`      | Appsmith startup check timeout.                         | `120`                 |
| `APPSMITH_STARTUP_ATTEMPTS`     | Appsmith startup check attempts.                        | `5`                   |
| `APPSMITH_DATA_TO_PERSIST`      | Data to persist from installations.                     | `$APPSMITH_CONF_FILE` |

#### Read-only environment variables

| Name                        | Description                                  | Value                               |
|-----------------------------|----------------------------------------------|-------------------------------------|
| `APPSMITH_BASE_DIR`         | Appsmith installation directory.             | `${BITNAMI_ROOT_DIR}/appsmith`      |
| `APPSMITH_VOLUME_DIR`       | Appsmith volume directory.                   | `/bitnami/appsmith`                 |
| `APPSMITH_LOG_DIR`          | Appsmith logs directory.                     | `${APPSMITH_BASE_DIR}/logs`         |
| `APPSMITH_LOG_FILE`         | Appsmith log file.                           | `${APPSMITH_LOG_DIR}/appsmith.log`  |
| `APPSMITH_CONF_DIR`         | Appsmith configuration directory.            | `${APPSMITH_BASE_DIR}/conf`         |
| `APPSMITH_DEFAULT_CONF_DIR` | Appsmith default configuration directory.    | `${APPSMITH_BASE_DIR}/conf.default` |
| `APPSMITH_CONF_FILE`        | Appsmith configuration file.                 | `${APPSMITH_CONF_DIR}/docker.env`   |
| `APPSMITH_TMP_DIR`          | Appsmith temporary directory.                | `${APPSMITH_BASE_DIR}/tmp`          |
| `APPSMITH_PID_FILE`         | Appsmith PID file.                           | `${APPSMITH_TMP_DIR}/appsmith.pid`  |
| `APPSMITH_GIT_ROOT`         | Git root path for Appsmith Git repositories. | `${APPSMITH_BASE_DIR}/git-storage`  |
| `APPSMITH_DAEMON_USER`      | Appsmith daemon system user.                 | `appsmith`                          |
| `APPSMITH_DAEMON_GROUP`     | Appsmith daemon system group.                | `appsmith`                          |

When you start the Appsmith image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. Please note that some variables are only considered when the container is started for the first time.

#### Run mode

Appsmith supports three running modes:

- Backend: The Appsmith API. It is the essential functional element of Appsmith.
- RTS: Necessary for performing real-time editing of the applications created by Appsmith.
- Client: Contains the UI of Appsmith. This is the main entrypoint for users.

The running mode is defined via the `APPSMITH_MODE` environment variable. The possible values are `backend`, `rts` and `client`.

##### Connect Appsmith container to an existing database

The Bitnami Appsmith container supports connecting the Appsmith application to an external database.

### FIPS configuration in Bitnami Secure Images

The Bitnami Appsmith Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.
- `JAVA_TOOL_OPTIONS`: controls Java FIPS mode. Use `-Djava.security.properties==/opt/bitnami/java/conf/security/java.security.restricted` (restricted), `-Djava.security.properties==/opt/bitnami/java/conf/security/java.security.relaxed` (relaxed), or `-Djava.security.properties==/opt/bitnami/java/conf/security/java.security.original` (off).

## Logging

The Bitnami Appsmith Docker image sends the container logs to `stdout`. To view the logs:

```console
docker logs wordpress
```

Or using Docker Compose:

```console
docker-compose logs wordpress
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

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
