# Bitnami Secure Image for Harbor Exporter

## What is Harbor Exporter?

> Harbor Exporter is one of the components of Harbor: a cloud-native registry that stores, signs, and scans content. This component expose Harbor metrics in Prometheus format.

[Overview of Harbor Exporter](https://goharbor.io/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

This container is part of the [Harbor solution](https://github.com/bitnami/charts/tree/main/bitnami/harbor) that is primarily intended to be deployed in Kubernetes.

```console
docker run --name harbor-exporter bitnami/harbor-exporter:latest
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

## How to deploy Harbor in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Harbor Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/harbor).

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

## Configuration

Harbor Exporter is a component of the Harbor application. In order to get the Harbor application running on Kubernetes we encourage you to check the [bitnami/harbor Helm chart](https://github.com/bitnami/charts/tree/master/bitnami/harbor) and configure it using the options exposed in the values.yaml file.

For further information about the specific component itself, please refer to the [source repository documentation](https://goharbor.io//tree/main/docs

### Environment variables

#### Customizable environment variables

| Name                           | Description                                                                                | Default Value                         |
|--------------------------------|--------------------------------------------------------------------------------------------|---------------------------------------|
| `HARBOR_EXPORTER_BASE_DIR`     | harbor-exporter installation directory.                                                    | `${BITNAMI_ROOT_DIR}/harbor-exporter` |
| `HARBOR_DATABASE_HOST`         | The hostname of external database                                                          | `nil`                                 |
| `HARBOR_DATABASE_PORT`         | The port of external database                                                              | `5432`                                |
| `HARBOR_DATABASE_USERNAME`     | The username of external database                                                          | `nil`                                 |
| `HARBOR_DATABASE_PASSWORD`     | The password of external database                                                          | `nil`                                 |
| `HARBOR_DATABASE_DBNAME`       | The database used by core service                                                          | `nil`                                 |
| `HARBOR_DATABASE_SSLMODE`      | Database certificate verfication: require, verify-full, verify-ca, disable (default value) | `disable`                             |
| `HARBOR_SERVICE_SCHEME`        | Core service scheme (http or https)                                                        | `http`                                |
| `HARBOR_SERVICE_HOST`          | Core service hostname                                                                      | `core`                                |
| `HARBOR_SERVICE_PORT`          | Core service port                                                                          | `8080`                                |
| `HARBOR_REDIS_URL`             | Redis URL for job service (scheme://[redis:password@]addr/db_index)                        | `nil`                                 |
| `HARBOR_REDIS_NAMESPACE`       | Redis namespace for jobservice. Default `harbor_job_service_namespace                      | `harbor_job_service_namespace`        |
| `HARBOR_REDIS_TIMEOUT`         | Redis connection timeout.                                                                  | `3600`                                |
| `HARBOR_EXPORTER_PORT`         | Port for exporter metrics                                                                  | `9090`                                |
| `HARBOR_EXPORTER_METRICS_PATH` | URL path for exporter metrics.                                                             | `/metrics`                            |

#### Read-only environment variables

| Name                           | Description                   | Value    |
|--------------------------------|-------------------------------|----------|
| `HARBOR_EXPORTER_DAEMON_USER`  | harbor-exporter system user.  | `harbor` |
| `HARBOR_EXPORTER_DAEMON_GROUP` | harbor-exporter system group. | `harbor` |

## Notable Changes

### Starting January 16, 2024

- The `docker-compose.yaml` file has been removed, as it was solely intended for internal testing purposes.

### FIPS configuration in Bitnami Secure Images

The Bitnami Harbor Exporter Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

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
