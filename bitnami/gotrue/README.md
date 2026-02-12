# Bitnami Secure Image for GoTrue

## What is GoTrue?

> GoTrue is an API written in Golang that can handle user registration and authentication for Jamstack projects. Based on OAuth2 and JWT, fetures user signup, authentication and custom user data.

[Overview of GoTrue](https://github.com/netlify/gotrue)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run -it --name gotrue bitnami/gotrue
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

The recommended way to get the Bitnami GoTrue Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/gotrue).

```console
docker pull bitnami/gotrue:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/gotrue/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/gotrue:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of GoTrue, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/gotrue:latest
```

#### Step 2: Remove the currently running container

```console
docker rm -v gotrue
```

#### Step 3: Run the new image

Re-create your container from the new image.

```console
docker run --name gotrue bitnami/gotrue:latest
```

## Configuration

### Environment variables

#### Customizable environment variables

| Name                                  | Description                                  | Default Value                                                                                                |
|---------------------------------------|----------------------------------------------|--------------------------------------------------------------------------------------------------------------|
| `DB_HOST`                             | Database host                                | `localhost`                                                                                                  |
| `DB_PORT`                             | Database port number                         | `5432`                                                                                                       |
| `DB_NAME`                             | Database name                                | `postgres`                                                                                                   |
| `DB_USER`                             | Database user username                       | `postgres`                                                                                                   |
| `DB_PASSWORD`                         | Database password                            | `nil`                                                                                                        |
| `DB_SSL`                              | Database SSL connection enabled              | `disable`                                                                                                    |
| `GOTRUE_DB_DATABASE_URL`              | Database URL                                 | `postgresql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}?search_path=auth&sslmode=${DB_SSL}` |
| `GOTRUE_URI_ALLOW_LIST`               |                                              | `*`                                                                                                          |
| `GOTRUE_OPERATOR_TOKEN`               | Operator token                               | `nil`                                                                                                        |
| `GOTRUE_JWT_SECRET`                   | JWT Secret                                   | `nil`                                                                                                        |
| `GOTRUE_SITE_URL`                     |                                              | `http://localhost:80`                                                                                        |
| `GOTRUE_API_PORT`                     |                                              | `9999`                                                                                                       |
| `GOTRUE_API_HOST`                     |                                              | `0.0.0.0`                                                                                                    |
| `API_EXTERNAL_URL`                    | The URL on which Gotrue might be accessed at | `http://localhost:9999`                                                                                      |
| `GOTRUE_DISABLE_SIGNUP`               |                                              | `false`                                                                                                      |
| `GOTRUE_DB_DRIVER`                    |                                              | `postgres`                                                                                                   |
| `GOTRUE_DB_MIGRATIONS_PATH`           |                                              | `${GOTRUE_BASE_DIR}`                                                                                         |
| `GOTRUE_JWT_DEFAULT_GROUP_NAME`       |                                              | `authenticated`                                                                                              |
| `GOTRUE_JWT_ADMIN_ROLES`              |                                              | `service_role`                                                                                               |
| `GOTRUE_JWT_AUD`                      |                                              | `authenticated`                                                                                              |
| `GOTRUE_JWT_EXP`                      |                                              | `3600`                                                                                                       |
| `GOTRUE_EXTERNAL_EMAIL_ENABLED`       |                                              | `true`                                                                                                       |
| `GOTRUE_MAILER_AUTOCONFIRM`           |                                              | `true`                                                                                                       |
| `GOTRUE_SMTP_ADMIN_EMAIL`             |                                              | `your-mail@example.com`                                                                                      |
| `GOTRUE_SMTP_HOST`                    |                                              | `smtp.exmaple.com`                                                                                           |
| `GOTRUE_SMTP_PORT`                    |                                              | `587`                                                                                                        |
| `GOTRUE_SMTP_SENDER_NAME`             |                                              | `your-mail@example.com`                                                                                      |
| `GOTRUE_EXTERNAL_PHONE_ENABLED`       |                                              | `false`                                                                                                      |
| `GOTRUE_SMS_AUTOCONFIRM`              |                                              | `false`                                                                                                      |
| `GOTRUE_MAILER_URLPATHS_INVITE`       |                                              | `http://localhost:80/auth/v1/verify`                                                                         |
| `GOTRUE_MAILER_URLPATHS_CONFIRMATION` |                                              | `http://localhost:80/auth/v1/verify`                                                                         |
| `GOTRUE_MAILER_URLPATHS_RECOVERY`     |                                              | `http://localhost:80/auth/v1/verify`                                                                         |
| `GOTRUE_MAILER_URLPATHS_EMAIL_CHANGE` |                                              | `http://localhost:80/auth/v1/verify`                                                                         |

#### Read-only environment variables

| Name                  | Description                              | Value                           |
|-----------------------|------------------------------------------|---------------------------------|
| `GOTRUE_BASE_DIR`     | gotrue installation directory.           | `${BITNAMI_ROOT_DIR}/gotrue`    |
| `GOTRUE_LOGS_DIR`     | Directory where gotrue logs are stored.  | `${GOTRUE_BASE_DIR}/logs`       |
| `GOTRUE_LOG_FILE`     | Directory where gotrue logs are stored.  | `${GOTRUE_LOGS_DIR}/gotrue.log` |
| `GOTRUE_BIN_DIR`      | gotrue directory for binary executables. | `${GOTRUE_BASE_DIR}/bin`        |
| `GOTRUE_DAEMON_USER`  | postgrest system user.                   | `supabase`                      |
| `GOTRUE_DAEMON_GROUP` | postgrest system group.                  | `supabase`                      |

### Running commands

To run commands inside this container you can use `docker run`, for example to execute `gotrue --help` you can follow the example below:

```console
docker run --rm --name gotrue bitnami/gotrue:latest --help
```

Check the [official GoTrue documentation](https://github.com/netlify/gotrue) for more information about how to use GoTrue.

### FIPS configuration in Bitnami Secure Images

The Bitnami GoTrue Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Notable Changes

### Starting January 16, 2024

- The `docker-compose.yaml` file has been removed, as it was solely intended for internal testing purposes.

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
