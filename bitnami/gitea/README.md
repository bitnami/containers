# Bitnami Secure Image for Gitea

> Gitea is a lightweight code hosting solution. Written in Go, features low resource consumption, easy upgrades and multiple databases.

[Overview of Gitea](https://gitea.io/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name gitea bitnami/gitea:latest
```

## Using `docker-compose.yml`

The docker-compose.yaml file of this container can be found in the [Bitnami Containers repository](https://github.com/bitnami/containers/).

[https://github.com/bitnami/containers/tree/main/bitnami/gitea/docker-compose.yml](https://github.com/bitnami/containers/tree/main/bitnami/gitea/docker-compose.yml)

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/gitea).

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

## How to deploy Gitea in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Gitea Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/gitea).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

## Get this image

The Bitnami Gitea Docker image is only available to [Bitnami Secure Images](https://bitnami.com) customers.

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/gitea` path. If the mounted directory is empty, it will be initialized on the first run.

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Configuration

Gitea can be configured via environment variables or using a configuration file (`app.ini`). If a configuration option is not specified in either the configuration file or in an environment variable, Gitea uses its internal default configuration.

### Environment variables

The following tables list the main variables you can set.

#### Customizable environment variables

| Name                                            | Description                                                                                                       | Default Value                                            |
|-------------------------------------------------|-------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------|
| `GITEA_REPO_ROOT_PATH`                          | Gitea git repositories path.                                                                                      | `${GITEA_DATA_DIR}/git/repositories`                     |
| `GITEA_LFS_ROOT_PATH`                           | Gitea git LFS path.                                                                                               | `nil`                                                    |
| `GITEA_LOG_ROOT_PATH`                           | Gitea log path.                                                                                                   | `${GITEA_TMP_DIR}/log`                                   |
| `GITEA_LOG_MODE`                                | Gitea log mode.                                                                                                   | `nil`                                                    |
| `GITEA_LOG_ROUTER`                              | Gitea log router.                                                                                                 | `nil`                                                    |
| `GITEA_ADMIN_USER`                              | Admin username.                                                                                                   | `bn_user`                                                |
| `GITEA_ADMIN_PASSWORD`                          | Admin password.                                                                                                   | `bitnami`                                                |
| `GITEA_ADMIN_EMAIL`                             | Admin user email.                                                                                                 | `user@bitnami.org`                                       |
| `GITEA_APP_NAME`                                | Application name, used in the page title                                                                          | `Gitea: Git with a cup of tea`                           |
| `GITEA_RUN_MODE`                                | Application run mode, affects performance and debugging. Either "dev", "prod" or "test".                          | `prod`                                                   |
| `GITEA_DOMAIN`                                  | Domain name of this server.                                                                                       | `localhost`                                              |
| `GITEA_SSH_DOMAIN`                              | Domain name of this server, used for displayed clone URL.                                                         | `${GITEA_DOMAIN}`                                        |
| `GITEA_SSH_LISTEN_PORT`                         | Port for the built-in SSH server.                                                                                 | `2222`                                                   |
| `GITEA_SSH_PORT`                                | SSH port displayed in clone URL.                                                                                  | `${GITEA_SSH_LISTEN_PORT}`                               |
| `GITEA_HTTP_PORT`                               | Gitea HTTP listen port                                                                                            | `3000`                                                   |
| `GITEA_PROTOCOL`                                | [http, https, fcgi, http+unix, fcgi+unix]                                                                         | `http`                                                   |
| `GITEA_ROOT_URL`                                | Overwrite the automatically generated public URL. This is useful if the internal and the external URL don't match | `${GITEA_PROTOCOL}://${GITEA_DOMAIN}:${GITEA_HTTP_PORT}` |
| `GITEA_PASSWORD_HASH_ALGO`                      | The hash algorithm to use [argon2, pbkdf2, scrypt, bcrypt], argon2 will spend more memory than others.            | `pbkdf2`                                                 |
| `GITEA_LFS_START_SERVER`                        | Enables Git LFS support                                                                                           | `false`                                                  |
| `GITEA_ENABLE_OPENID_SIGNIN`                    | Enable OpenID sign-in.                                                                                            | `false`                                                  |
| `GITEA_ENABLE_OPENID_SIGNUP`                    | Enable OpenID sign-up.                                                                                            | `false`                                                  |
| `GITEA_DATABASE_TYPE`                           | The database type in use [mysql, postgres].                                                                       | `postgres`                                               |
| `GITEA_DATABASE_HOST`                           | Database host address.                                                                                            | `postgresql`                                             |
| `GITEA_DATABASE_PORT_NUMBER`                    | Database host port.                                                                                               | `5432`                                                   |
| `GITEA_DATABASE_NAME`                           | Database name.                                                                                                    | `bitnami_gitea`                                          |
| `GITEA_DATABASE_USERNAME`                       | Database username.                                                                                                | `bn_gitea`                                               |
| `GITEA_DATABASE_PASSWORD`                       | Database password.                                                                                                | `nil`                                                    |
| `GITEA_DATABASE_SSL_MODE`                       | Database SSL mode.                                                                                                | `disable`                                                |
| `GITEA_DATABASE_SCHEMA`                         | Database Schema.                                                                                                  | `nil`                                                    |
| `GITEA_DATABASE_CHARSET`                        | Database character set.                                                                                           | `utf8`                                                   |
| `GITEA_SMTP_ENABLED`                            | Enable to use a mail service.                                                                                     | `false`                                                  |
| `GITEA_SMTP_HOST`                               | SMTP mail host address (example: smtp.gitea.io).                                                                  | `nil`                                                    |
| `GITEA_SMTP_PORT`                               | SMTP mail port (example: 587).                                                                                    | `nil`                                                    |
| `GITEA_SMTP_FROM`                               | Mail from address, RFC 5322. This can be just an email address, or the "Name" email@example.com format.           | `nil`                                                    |
| `GITEA_SMTP_USER`                               | Username of mailing user (usually the senders e-mail address).                                                    | `nil`                                                    |
| `GITEA_SMTP_PASSWORD`                           | Password of mailing user. Use "your password" for quoting if you use special characters in the password.          | `nil`                                                    |
| `GITEA_OAUTH2_CLIENT_AUTO_REGISTRATION_ENABLED` | Password of mailing user. Use "your password" for quoting if you use special characters in the password.          | `false`                                                  |
| `GITEA_OAUTH2_CLIENT_USERNAME`                  | Password of mailing user. Use "your password" for quoting if you use special characters in the password.          | `nickname`                                               |

#### Read-only environment variables

| Name                    | Description                                                                                                                 | Value                         |
|-------------------------|-----------------------------------------------------------------------------------------------------------------------------|-------------------------------|
| `GITEA_BASE_DIR`        | Gitea installation directory.                                                                                               | `${BITNAMI_ROOT_DIR}/gitea`   |
| `GITEA_WORK_DIR`        | Gitea installation directory.                                                                                               | `${GITEA_BASE_DIR}`           |
| `GITEA_CUSTOM_DIR`      | Gitea configuration directory.                                                                                              | `${GITEA_BASE_DIR}/custom`    |
| `GITEA_TMP_DIR`         | Gitea TEMP directory.                                                                                                       | `${GITEA_BASE_DIR}/tmp`       |
| `GITEA_DATA_DIR`        | Gitea data directory.                                                                                                       | `${GITEA_WORK_DIR}/data`      |
| `GITEA_CONF_DIR`        | Gitea configuration directory.                                                                                              | `${GITEA_CUSTOM_DIR}/conf`    |
| `GITEA_CONF_FILE`       | Gitea configuration file.                                                                                                   | `${GITEA_CONF_DIR}/app.ini`   |
| `GITEA_PID_FILE`        | Gitea PID file.                                                                                                             | `${GITEA_TMP_DIR}/gitea.pid`  |
| `GITEA_VOLUME_DIR`      | Gitea directory for mounted configuration files.                                                                            | `${BITNAMI_VOLUME_DIR}/gitea` |
| `GITEA_DATA_TO_PERSIST` | Files to persist relative to the Gitea installation directory. To provide multiple values, separate them with a whitespace. | `${GITEA_CONF_FILE} data`     |
| `GITEA_DAEMON_USER`     | Gitea daemon system user.                                                                                                   | `gitea`                       |
| `GITEA_DAEMON_GROUP`    | Gitea daemon system group.                                                                                                  | `gitea`                       |

### Configuration overrides

The configuration can easily be setup by mounting your own configuration overrides on the directory `/bitnami/gitea/custom/conf/app.ini`:

Check the [official gitea configuration documentation](https://docs.gitea.io/en-us/config-cheat-sheet/) for all the possible overrides and settings.

### Initializing a new instance

In order to have your custom files inside the docker image you can mount them as a volume.

### Setting the admin password on first run

Passing the `GITEA_ADMIN_PASSWORD` environment variable when running the image for the first time will set the password of the `GITEA_ADMIN_USER`/`GITEA_ADMIN_EMAIL` user to the value of `GITEA_ADMIN_PASSWORD`.

### FIPS configuration in Bitnami Secure Images

The Bitnami Gitea Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.
- `GODEBUG`: controls Go FIPS mode. Use `fips140=only` (restricted), `fips140=on` (relaxed), or `fips140=off` (disabled).

## Logging

The Bitnami Gitea Docker image sends the container logs to the `stdout`. You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

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
