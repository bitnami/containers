# Bitnami Secure Image for Mastodon

## What is Mastodon?

> Mastodon is self-hosted social network server based on ActivityPub. Written in Ruby, features real-time updates, multimedia attachments and no vendor lock-in.

[Overview of Mastodon](https://joinmastodon.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run -it --name mastodon bitnami/mastodon
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

The recommended way to get the Bitnami Mastodon Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/mastodon).

```console
docker pull bitnami/mastodon:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/mastodon/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/mastodon:[TAG]
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

| Name                                 | Description                                                           | Default Value                                                                  |
|--------------------------------------|-----------------------------------------------------------------------|--------------------------------------------------------------------------------|
| `MASTODON_MODE`                      | Mastodon service to run (can be web, streaming or sidekiq).           | `web`                                                                          |
| `ALLOW_EMPTY_PASSWORD`               | Allow an empty password.                                              | `no`                                                                           |
| `MASTODON_CREATE_ADMIN`              | Create admin for Mastodon.                                            | `true`                                                                         |
| `MASTODON_ADMIN_USERNAME`            | Mastodon admin username.                                              | `user`                                                                         |
| `MASTODON_ADMIN_PASSWORD`            | Mastodon admin password.                                              | `bitnami1`                                                                     |
| `MASTODON_ADMIN_EMAIL`               | Mastodon admin email.                                                 | `user@bitnami.org`                                                             |
| `MASTODON_ALLOW_ALL_DOMAINS`         | Allow accessing Mastodon with any domain.                             | `true`                                                                         |
| `MASTODON_SECRET_KEY_BASE`           | Mastodon secret key base.                                             | `bitnami123`                                                                   |
| `MASTODON_OTP_SECRET`                | Mastodon OTP secret.                                                  | `bitnami123`                                                                   |
| `MASTODON_HTTPS_ENABLED`             | Enable HTTPS in Mastodon.                                             | `false`                                                                        |
| `MASTODON_ASSETS_PRECOMPILE`         | Run rake assets:precompile on startup.                                | `true`                                                                         |
| `MASTODON_WEB_DOMAIN`                | Mastodon web domain (for generating links).                           | `127.0.0.1`                                                                    |
| `MASTODON_WEB_HOST`                  | Mastodon web host (for the streaming and sidekiq services to access). | `mastodon`                                                                     |
| `MASTODON_WEB_PORT_NUMBER`           | Mastodon web port.                                                    | `3000`                                                                         |
| `MASTODON_STREAMING_PORT_NUMBER`     | Mastodon streaming port.                                              | `4000`                                                                         |
| `MASTODON_AUTHORIZED_FETCH`          | Use secure mode.                                                      | `false`                                                                        |
| `MASTODON_LIMITED_FEDERATION_MODE`   | Use an allow-list for federating with other servers.                  | `false`                                                                        |
| `MASTODON_STREAMING_API_BASE_URL`    | Mastodon public api base url.                                         | `ws://localhost:${MASTODON_STREAMING_PORT_NUMBER}`                             |
| `MASTODON_SMTP_LOGIN`                | SMTP server authentication username.                                  | `5432`                                                                         |
| `MASTODON_SMTP_PASSWORD`             | SMTP server authentication password.                                  | `bitnami_mastodon`                                                             |
| `RAILS_SERVE_STATIC_FILES`           | Have puma server the static files in the public/ folder               | `true`                                                                         |
| `MASTODON_BIND_ADDRESS`              | Address to listen for interfaces                                      | `0.0.0.0`                                                                      |
| `MASTODON_DATA_TO_PERSIST`           | Data to persist from installations.                                   | `$MASTODON_ASSETS_DIR $MASTODON_SYSTEM_DIR`                                    |
| `MASTODON_USE_LIBVIPS`               | Use libvips for image processing instead of ImageMagick.              | `true`                                                                         |
| `MASTODON_MIGRATE_DATABASE`          | Run rake db:migrate job.                                              | `true`                                                                         |
| `MASTODON_DATABASE_HOST`             | Database server host.                                                 | `postgresql`                                                                   |
| `MASTODON_DATABASE_PORT_NUMBER`      | Database server port.                                                 | `5432`                                                                         |
| `MASTODON_DATABASE_NAME`             | Database name.                                                        | `bitnami_mastodon`                                                             |
| `MASTODON_DATABASE_USERNAME`         | Database user name.                                                   | `bn_mastodon`                                                                  |
| `MASTODON_DATABASE_PASSWORD`         | Database user password.                                               | `nil`                                                                          |
| `MASTODON_DATABASE_POOL`             | Number of DB pool processes.                                          | `5`                                                                            |
| `MASTODON_REDIS_HOST`                | Redis server host.                                                    | `redis`                                                                        |
| `MASTODON_REDIS_PORT_NUMBER`         | Redis server port.                                                    | `6379`                                                                         |
| `MASTODON_REDIS_PASSWORD`            | Redis user password.                                                  | `nil`                                                                          |
| `MASTODON_ELASTICSEARCH_ENABLED`     | Enable Elasticsearch.                                                 | `true`                                                                         |
| `MASTODON_MIGRATE_ELASTICSEARCH`     | Run rake chewy:upgrade on startup.                                    | `true`                                                                         |
| `MASTODON_ELASTICSEARCH_HOST`        | Elasticsearch server host.                                            | `elasticsearch`                                                                |
| `MASTODON_ELASTICSEARCH_PORT_NUMBER` | Elasticsearch server port.                                            | `9200`                                                                         |
| `MASTODON_ELASTICSEARCH_USER`        | Elasticsearch user.                                                   | `elastic`                                                                      |
| `MASTODON_ELASTICSEARCH_PASSWORD`    | Elasticsearch user password.                                          | `nil`                                                                          |
| `MASTODON_S3_ENABLED`                | Enable S3                                                             | `false`                                                                        |
| `MASTODON_S3_BUCKET`                 | S3 Bucket for storing data                                            | `bitnami_mastodon`                                                             |
| `MASTODON_S3_HOSTNAME`               | S3 endpoint                                                           | `minio`                                                                        |
| `MASTODON_S3_PROTOCOL`               | S3 protocol (can be https or http)                                    | `http`                                                                         |
| `MASTODON_S3_PORT_NUMBER`            | S3 port                                                               | `9000`                                                                         |
| `MASTODON_S3_ALIAS_HOST`             | S3 route for uploaded files (for generating links in Mastodon)        | `localhost:${MASTODON_S3_PORT_NUMBER}`                                         |
| `MASTODON_AWS_SECRET_ACCESS_KEY`     | AWS secret access key                                                 | `nil`                                                                          |
| `MASTODON_AWS_ACCESS_KEY_ID`         | AWS access key id                                                     | `nil`                                                                          |
| `MASTODON_S3_REGION`                 | S3 region                                                             | `us-east-1`                                                                    |
| `MASTODON_S3_ENDPOINT`               | S3 endpoint                                                           | `${MASTODON_S3_PROTOCOL}://${MASTODON_S3_HOSTNAME}:${MASTODON_S3_PORT_NUMBER}` |
| `MASTODON_STARTUP_ATTEMPTS`          | Startup check attempts.                                               | `40`                                                                           |

#### Read-only environment variables

| Name                    | Description                       | Value                                |
|-------------------------|-----------------------------------|--------------------------------------|
| `MASTODON_BASE_DIR`     | Mastodon installation directory.  | `${BITNAMI_ROOT_DIR}/mastodon`       |
| `MASTODON_VOLUME_DIR`   | Mastodon volume directory.        | `/bitnami/mastodon`                  |
| `MASTODON_ASSETS_DIR`   | Mastodon public assets directory. | `${MASTODON_BASE_DIR}/public/assets` |
| `MASTODON_SYSTEM_DIR`   | Mastodon public system directory. | `${MASTODON_BASE_DIR}/public/system` |
| `MASTODON_TMP_DIR`      | Mastodon tmp directory.           | `${MASTODON_BASE_DIR}/tmp`           |
| `MASTODON_LOGS_DIR`     | Mastodon logs directory.          | `${MASTODON_BASE_DIR}/log`           |
| `NODE_ENV`              | Node.js environment mode          | `production`                         |
| `RAILS_ENV`             | Rails environment mode            | `production`                         |
| `MASTODON_DAEMON_USER`  | Mastodon daemon system user.      | `mastodon`                           |
| `MASTODON_DAEMON_GROUP` | Mastodon daemon system group.     | `mastodon`                           |

When you start the Mastodon image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line.

#### Run mode

Mastodon supports three running modes:

- Web: The Mastodon web frontend. It is the essential functional element of Mastodon.
- Streaming: Necessary for performing real-time interactions inside Mastodon.
- Sidekiq: Performs background operations like sending emails.

The running mode is defined via the `MASTODON_MODE` environment variable. The possible values are `web`, `streaming` and `sidekiq`.

### FIPS configuration in Bitnami Secure Images

The Bitnami Mastodon Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Logging

The Bitnami Mastodon Docker image sends the container logs to `stdout`. To view the logs:

```console
docker logs mastodon
```

Or using Docker Compose:

```console
docker-compose logs mastodon
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
