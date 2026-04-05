# Bitnami Object Storage based on MinIO&reg;

> MinIO&reg; is an object storage server, compatible with Amazon S3 cloud storage service, mainly used for storing unstructured data (such as photos, videos, log files, etc.).

[Overview of Bitnami Object Storage based on MinIO&reg;](https://min.io/)
All software products, projects and company names are trademark(TM) or registered(R) trademarks of their respective holders, and use of them does not imply any affiliation or endorsement. This software is licensed to you subject to one or more open source licenses and VMware provides the software on an AS-IS basis. MinIO(R) is a registered trademark of the MinIO, Inc in the US and other countries. Bitnami is not affiliated, associated, authorized, endorsed by, or in any way officially connected with MinIO Inc. MinIO(R) is licensed under GNU AGPL v3.0.

## TL;DR

```console
docker run --name minio bitnami/minio:latest
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

## How to deploy MinIO(R) in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami MinIO(R) Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/minio).

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

## Get this image

The Bitnami Bitnami Object Storage based on MinIO&reg; Docker image is only available to [Bitnami Secure Images](https://bitnami.com) customers.

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/minio).

## Persisting your database

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/minio/data` path. You can also mount a volume to a custom path inside the container, provided that you run the container using the `MINIO_DATA_DIR` environment variable.

> **NOTE** As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a MinIO(R) server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Configuration

The following section describes the supported environment variables

### Environment variables

The following tables list the main variables you can set.

#### Customizable environment variables

| Name                                     | Description                                                                | Default Value                                      |
|------------------------------------------|----------------------------------------------------------------------------|----------------------------------------------------|
| `MINIO_DATA_DIR`                         | MinIO directory for data.                                                  | `/bitnami/minio/data`                              |
| `MINIO_API_PORT_NUMBER`                  | MinIO API port number.                                                     | `9000`                                             |
| `MINIO_BROWSER`                          | Enable / disable the embedded MinIO Console.                               | `off`                                              |
| `MINIO_CONSOLE_PORT_NUMBER`              | MinIO Console port number.                                                 | `9001`                                             |
| `MINIO_SCHEME`                           | MinIO web scheme.                                                          | `http`                                             |
| `MINIO_SKIP_CLIENT`                      | Skip MinIO client configuration.                                           | `no`                                               |
| `MINIO_DISTRIBUTED_MODE_ENABLED`         | Enable MinIO distributed mode.                                             | `no`                                               |
| `MINIO_DEFAULT_BUCKETS`                  | MinIO default buckets.                                                     | `nil`                                              |
| `MINIO_STARTUP_TIMEOUT`                  | MinIO startup timeout.                                                     | `10`                                               |
| `MINIO_SERVER_URL`                       | MinIO server external URL.                                                 | `$MINIO_SCHEME://localhost:$MINIO_API_PORT_NUMBER` |
| `MINIO_APACHE_CONSOLE_HTTP_PORT_NUMBER`  | MinIO Console UI HTTP port, exposed via Apache with basic authentication.  | `80`                                               |
| `MINIO_APACHE_CONSOLE_HTTPS_PORT_NUMBER` | MinIO Console UI HTTPS port, exposed via Apache with basic authentication. | `443`                                              |
| `MINIO_APACHE_API_HTTP_PORT_NUMBER`      | MinIO API HTTP port, exposed via Apache with basic authentication.         | `9000`                                             |
| `MINIO_APACHE_API_HTTPS_PORT_NUMBER`     | MinIO API HTTPS port, exposed via Apache with basic authentication.        | `9443`                                             |
| `MINIO_FORCE_NEW_KEYS`                   | Force recreating MinIO keys.                                               | `no`                                               |
| `MINIO_ROOT_USER`                        | MinIO root user name.                                                      | `minio`                                            |
| `MINIO_ROOT_PASSWORD`                    | Password for MinIO root user.                                              | `miniosecret`                                      |

#### Read-only environment variables

| Name                 | Description                           | Value                         |
|----------------------|---------------------------------------|-------------------------------|
| `MINIO_BASE_DIR`     | MinIO installation directory.         | `${BITNAMI_ROOT_DIR}/minio`   |
| `MINIO_BIN_DIR`      | MinIO directory for binaries.         | `${MINIO_BASE_DIR}/bin`       |
| `MINIO_CERTS_DIR`    | MinIO directory for TLS certificates. | `/certs`                      |
| `MINIO_LOGS_DIR`     | MinIO directory for log files.        | `${MINIO_BASE_DIR}/log`       |
| `MINIO_TMP_DIR`      | MinIO directory for log files.        | `${MINIO_BASE_DIR}/tmp`       |
| `MINIO_SECRETS_DIR`  | MinIO directory for credentials.      | `${MINIO_BASE_DIR}/secrets`   |
| `MINIO_LOG_FILE`     | MinIO log file.                       | `${MINIO_LOGS_DIR}/minio.log` |
| `MINIO_PID_FILE`     | MinIO PID file.                       | `${MINIO_TMP_DIR}/minio.pid`  |
| `MINIO_DAEMON_USER`  | MinIO system user.                    | `minio`                       |
| `MINIO_DAEMON_GROUP` | MinIO system group.                   | `minio`                       |

Additionally, MinIO can be configured via environment variables as detailed at [MinIO(R) documentation](https://docs.min.io/docs/minio-server-configuration-guide.html).

A MinIO(R) Client  (`mc`) is also shipped on this image that can be used to perform administrative tasks as described at the [MinIO(R) Client documentation](https://docs.min.io/docs/minio-admin-complete-guide.html). In the example below, the client is used to obtain the server info:

```console
docker run --name minio -d bitnami/minio:latest
docker exec minio mc admin info local
```

or using Docker Compose:

```console
curl -sSL https://raw.githubusercontent.com/bitnami/containers/main/bitnami/minio/docker-compose.yml > docker-compose.yml
docker-compose up -d
docker-compose exec minio mc admin info local
```

### Creating default buckets

You can create a series of buckets in the MinIO(R) server during the initialization of the container by setting the environment variable `MINIO_DEFAULT_BUCKETS`.

### Securing access to MinIO(R) server with TLS

You can secure the access to MinIO(R) server with TLS as detailed at [MinIO(R) documentation](https://docs.min.io/docs/how-to-secure-access-to-minio-server-with-tls.html).

This image expects the variable `MINIO_SCHEME` set to `https` and certificates to be mounted at the `/certs` directory. You can put your key and certificate files on a local directory and mount it in the container.

### Setting up MinIO(R) in Distributed Mode

You can configure MinIO(R) in Distributed Mode to setup a highly-available storage system. To do so, the environment variables below **must** be set on each node:

- `MINIO_DISTRIBUTED_MODE_ENABLED`: Set it to 'yes' to enable Distributed Mode.
- `MINIO_DISTRIBUTED_NODES`: List of MinIO(R) nodes hosts. Available separators are ' ', ',' and ';'.
- `MINIO_ROOT_USER`: MinIO(R) server root user. Must be common on every node.
- `MINIO_ROOT_PASSWORD`: MinIO(R) server root password. Must be common on every node.

MinIO(R) also supports ellipsis syntax (`{1..n}`) to list the MinIO(R) node hosts, where `n` is the number of nodes. This syntax is also valid to use multiple drives (`{1..m}`) on each MinIO(R) node, where `n` is the number of drives per node.

Find more information about the Distributed Mode in the [MinIO(R) documentation](https://docs.min.io/docs/distributed-minio-quickstart-guide.html).

### Reconfiguring Keys on container restarts

MinIO(R) configures the access & secret key during the 1st initialization based on the `MINIO_ROOT_USER` and `MINIO_ROOT_PASSWORD` environment variables, respectively.

When using persistence, MinIO(R) will reuse the data configured during the 1st initialization by default, ignoring whatever values are set on these environment variables. You can force MinIO(R) to reconfigure the keys based on the environment variables by setting the `MINIO_FORCE_NEW_KEYS` environment variable to `yes`.

### FIPS configuration in Bitnami Secure Images

The Bitnami Bitnami Object Storage based on MinIO&reg; Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Logging

The Bitnami MinIO(R) Docker image sends the container logs to the `stdout`. To view the logs:

```console
docker logs minio
```

or using Docker Compose:

```console
docker-compose logs minio
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

### HTTP log trace

To enable HTTP log trace, you can set the environment variable `MINIO_HTTP_TRACE` to redirect the logs to a specific file as detailed at [MinIO(R) documentation](https://docs.min.io/docs/minio-server-configuration-guide.html).

When setting this environment variable to `/opt/bitnami/minio/log/minio.log`, the logs will be sent to the `stdout`.

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
