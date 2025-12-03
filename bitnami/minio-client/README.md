# Bitnami Object Storage Client based on MinIO&reg;

## What is Bitnami Object Storage Client based on MinIO&reg;?

> MinIO&reg; Client is a Golang CLI tool that offers alternatives for ls, cp, mkdir, diff, and rsync commands for filesystems and object storage systems.

[Overview of Bitnami Object Storage Client based on MinIO&reg;](https://min.io/)
All software products, projects and company names are trademark(TM) or registered(R) trademarks of their respective holders, and use of them does not imply any affiliation or endorsement. This software is licensed to you subject to one or more open source licenses and VMware provides the software on an AS-IS basis. MinIO(R) is a registered trademark of the MinIO, Inc in the US and other countries. Bitnami is not affiliated, associated, authorized, endorsed by, or in any way officially connected with MinIO Inc. MinIO(R) is licensed under GNU AGPL v3.0.

## TL;DR

```console
docker run --name minio-client bitnami/minio-client:latest
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

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami MinIO(R) Client Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/minio-client).

```console
docker pull bitnami/minio-client:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/minio-client/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/minio-client:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Environment variables

### Customizable environment variables

| Name                         | Description                                     | Default Value |
|------------------------------|-------------------------------------------------|---------------|
| `MINIO_CLIENT_CONF_DIR`      | MinIO Client directory for configuration files. | `/.mc`        |
| `MINIO_SERVER_HOST`          | MinIO Server host.                              | `nil`         |
| `MINIO_SERVER_PORT_NUMBER`   | MinIO Server port number.                       | `9000`        |
| `MINIO_SERVER_SCHEME`        | MinIO Server web scheme.                        | `http`        |
| `MINIO_SERVER_ROOT_USER`     | MinIO Server root user name.                    | `nil`         |
| `MINIO_SERVER_ROOT_PASSWORD` | Password for MinIO Server root user.            | `nil`         |

### Read-only environment variables

| Name                    | Description                          | Value                              |
|-------------------------|--------------------------------------|------------------------------------|
| `MINIO_CLIENT_BASE_DIR` | MinIO Client installation directory. | `${BITNAMI_ROOT_DIR}/minio-client` |
| `MINIO_CLIENT_BIN_DIR`  | MinIO Client directory for binaries. | `${MINIO_CLIENT_BASE_DIR}/bin`     |
| `MINIO_DAEMON_USER`     | MinIO system user.                   | `minio`                            |
| `MINIO_DAEMON_GROUP`    | MinIO system group.                  | `minio`                            |

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a MinIO(R) Client can be used to access other running containers such as [MinIO(R) server](https://github.com/bitnami/containers/blob/main/bitnami/minio).

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

In this example, we will create a MinIO(R) Client container that will connect to a MinIO(R) server container that is running on the same docker network.

#### Step 1: Create a network

```console
docker network create app-tier --driver bridge
```

#### Step 2: Launch the MinIO(R) server container

Use the `--network app-tier` argument to the `docker run` command to attach the MinIO(R) container to the `app-tier` network.

```console
docker run -d --name minio-server \
    --env MINIO_ROOT_USER="minio-root-user" \
    --env MINIO_ROOT_PASSWORD="minio-root-password" \
    --network app-tier \
    bitnami/minio:latest
```

#### Step 3: Launch your MinIO(R) Client container

Finally we create a new container instance to launch the MinIO(R) client and connect to the server created in the previous step. In this example, we create a new bucket in the MinIO(R) storage server:

```console
docker run --rm --name minio-client \
    --env MINIO_SERVER_HOST="minio-server" \
    --env MINIO_SERVER_ACCESS_KEY="minio-root-user" \
    --env MINIO_SERVER_SECRET_KEY="minio-root-password" \
    --network app-tier \
    bitnami/minio-client \
    mb minio/my-bucket
```

## Configuration

MinIO(R) Client (`mc`) can be setup so it is already configured to point to a specific MinIO(R) server by providing the environment variables below:

- `MINIO_SERVER_HOST`: MinIO(R) server host.
- `MINIO_SERVER_PORT_NUMBER`: MinIO(R) server port. Default: `9000`.
- `MINIO_SERVER_SCHEME`: MinIO(R) server scheme. Default: `http`.
- `MINIO_SERVER_ACCESS_KEY`: MinIO(R) server Access Key. Must be common on every node.
- `MINIO_SERVER_SECRET_KEY`: MinIO(R) server Secret Key. Must be common on every node.

For instance, use the command below to create a new bucket in the MinIO(R) Server `my.minio.domain`:

```console
docker run --rm --name minio-client \
    --env MINIO_SERVER_HOST="my.minio.domain" \
    --env MINIO_SERVER_ACCESS_KEY="minio-access-key" \
    --env MINIO_SERVER_SECRET_KEY="minio-secret-key" \
    bitnami/minio-client \
    mb minio/my-bucket
```

Find more information about the client configuration in the [MinIO(R) Client documentation](https://docs.min.io/docs/minio-admin-complete-guide.html).

### FIPS configuration in Bitnami Secure Images

The Bitnami Bitnami Object Storage Client based on MinIO&reg; Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Notable Changes

### Starting January 16, 2024

- The `docker-compose.yaml` file has been removed, as it was solely intended for internal testing purposes.

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
