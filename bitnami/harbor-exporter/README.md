# Bitnami package for Harbor Exporter

## What is Harbor Exporter?

> Harbor Exporter is one of the components of Harbor: a cloud-native registry that stores, signs, and scans content. This component expose Harbor metrics in Prometheus format.

[Overview of Harbor Exporter](https://github.com/goharbor/harbor)

## TL;DR

This container is part of the [Harbor solution](https://github.com/bitnami/charts/tree/main/bitnami/harbor) that is primarily intended to be deployed in Kubernetes.

```console
docker run --name harbor-exporter bitnami/harbor-exporter:latest
```

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

## How to deploy Harbor in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Harbor Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/harbor).

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Configuration

Harbor Exporter is a component of the Harbor application. In order to get the Harbor application running on Kubernetes we encourage you to check the [bitnami/harbor Helm chart](https://github.com/bitnami/charts/tree/master/bitnami/harbor) and configure it using the options exposed in the values.yaml file.

For further information about the specific component itself, please refer to the [source repository documentation](https://github.com/goharbor/harbor/tree/main/docs

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

The Bitnami Harbor Exporter Docker image from the [Bitnami Secure Images](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

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
