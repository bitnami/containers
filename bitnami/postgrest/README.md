# Bitnami Secure Image for PostgREST

## What is PostgREST?

> PostgREST is a web server that allows communicating to PostgreSQL using API endpoints and operations.

[Overview of PostgREST](https://postgrest.org/en/stable/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run -it --name postgrest bitnami/postgrest
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

The recommended way to get the Bitnami PostgREST Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/postgrest).

```console
docker pull bitnami/postgrest:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/postgrest/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/postgrest:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of PostgREST, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/postgrest:latest
```

#### Step 2: Remove the currently running container

```console
docker rm -v postgrest
```

#### Step 3: Run the new image

Re-create your container from the new image.

```console
docker run --name postgrest bitnami/postgrest:latest
```

## Configuration

### Environment variables

#### Customizable environment variables

| Name                       | Description                     | Default Value    |
|----------------------------|---------------------------------|------------------|
| `DB_HOST`                  | Database host                   | `localhost`      |
| `DB_PORT`                  | Database port number            | `5432`           |
| `DB_USER`                  | Database user username          | `postgres`       |
| `DB_PASSWORD`              | Database user password          | `nil`            |
| `DB_NAME`                  | Database name                   | `postgres`       |
| `DB_SSL`                   | Database SSL connection enabled | `disable`        |
| `PGRST_JWT_SECRET`         | Postgrest JWT secret            | `nil`            |
| `PGRST_DB_ANON_ROLE`       | Postgrest anon role             | `anon`           |
| `PGRST_DB_SCHEMA`          | Postgrest database schema       | `public,storage` |
| `PGRST_DB_USE_LEGACY_GUCS` | Postgrest use legacy GUCS       | `false`          |
| `PGRST_SERVER_PORT`        | Postgrest server port           | `3000`           |

#### Read-only environment variables

| Name                     | Description                                 | Value                                                                                       |
|--------------------------|---------------------------------------------|---------------------------------------------------------------------------------------------|
| `POSTGREST_BASE_DIR`     | postgrest installation directory.           | `${BITNAMI_ROOT_DIR}/postgrest`                                                             |
| `POSTGREST_LOGS_DIR`     | Directory where postgrest logs are stored.  | `${POSTGREST_BASE_DIR}/logs`                                                                |
| `POSTGREST_LOG_FILE`     | Directory where postgrest logs are stored.  | `${POSTGREST_LOGS_DIR}/postgrest.log`                                                       |
| `POSTGREST_BIN_DIR`      | postgrest directory for binary executables. | `${POSTGREST_BASE_DIR}/bin`                                                                 |
| `PGRST_DB_URI`           | Postgres DB URI                             | `postgresql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}?sslmode=${DB_SSL}` |
| `POSTGREST_DAEMON_USER`  | postgrest system user.                      | `supabase`                                                                                  |
| `POSTGREST_DAEMON_GROUP` | postgrest system group.                     | `supabase`                                                                                  |

### Running commands

To run commands inside this container you can use `docker run`, for example to execute `postgrest --help` you can follow the example below:

```console
docker run --rm --name postgrest bitnami/postgrest:latest --help
```

Check the [official PostgREST documentation](https://postgrest.org/en/stable//configuration.html) for more information about how to use PostgREST.

### FIPS configuration in Bitnami Secure Images

The Bitnami PostgREST Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

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
