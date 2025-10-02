# Bitnami package for Jaeger

## What is Jaeger?

> Jaeger is a distributed tracing system. It is used for monitoring and troubleshooting microservices-based distributed systems.

[Overview of Jaeger](https://jaegertracing.io/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name jaeger bitnami/jaeger:latest
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

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami Jaeger Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/jaeger).

```console
docker pull bitnami/jaeger:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/jaeger/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/jaeger:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Configuration

### Environment variables

#### Customizable environment variables

| Name                                        | Description                                                                | Default Value                                     |
|---------------------------------------------|----------------------------------------------------------------------------|---------------------------------------------------|
| `JAEGER_USERNAME`                           | Jaeger username.                                                           | `user`                                            |
| `JAEGER_PASSWORD`                           | Jaeger password.                                                           | `bitnami`                                         |
| `JAEGER_AGENT_ZIPKIN_UDP_PORT_NUMBER`       | Jaeger Agent UDP port. Accept zipkin.thrift over compact thrift protocol   | `5775`                                            |
| `JAEGER_AGENT_COMPACT_UDP_PORT_NUMBER`      | Jaeger Agent UDP port. Accept jaeger.thrift over compact thrift protocol   | `6831`                                            |
| `JAEGER_AGENT_BINARY_UDP_PORT_NUMBER`       | Jaeger Agent UDP port. Accept jaeger.thrift over binary thrift protocol    | `6832`                                            |
| `JAEGER_AGENT_HTTP_PORT_NUMBER`             | Jaeger Agent HTTP port. Serve configs.                                     | `5778`                                            |
| `JAEGER_QUERY_HTTP_PORT_NUMBER`             | Jaeger Query HTTP port.                                                    | `16686`                                           |
| `JAEGER_QUERY_GRPC_PORT_NUMBER`             | Jaeger Query GRPC port.                                                    | `16685`                                           |
| `JAEGER_COLLECTOR_ZIPKIN_PORT_NUMBER`       | Jaeger Collector Zipkin compatible port.                                   | `nil`                                             |
| `JAEGER_COLLECTOR_HTTP_PORT_NUMBER`         | Jaeger Collector HTTP port. Accept jaeger.thrift directly from clients     | `14268`                                           |
| `JAEGER_COLLECTOR_GRPC_PORT_NUMBER`         | Jaeger Collector GRPC port. Accept jaeger.thrift directly from clients     | `14250`                                           |
| `JAEGER_ADMIN_HTTP_PORT_NUMBER`             | Jaeger Admin port.                                                         | `14269`                                           |
| `JAEGER_METRICS_PORT_NUMBER`                | Jaeger prometheus metrics port.                                            | `8888`                                            |
| `JAEGER_HEALTHCHECK_PORT_NUMBER`            | Jaeger healthcheck port.                                                   | `13133`                                           |
| `JAEGER_COLLECTOR_OTLP_GRPC_PORT_NUMBER`    | Jaeger Collector OpenTelemetry gRPC port.                                  | `4317`                                            |
| `JAEGER_COLLECTOR_OTLP_HTTP_PORT_NUMBER`    | Jaeger Collector OpenTelemetry HTTP port.                                  | `4318`                                            |
| `JAEGER_AGENT_ZIPKIN_UDP_HOST`              | Jaeger Agent UDP host. Accept zipkin.thrift over compact thrift protocol   | `0.0.0.0`                                         |
| `JAEGER_AGENT_COMPACT_UDP_HOST`             | Jaeger Agent UDP host. Accept jaeger.thrift over compact thrift protocol   | `0.0.0.0`                                         |
| `JAEGER_AGENT_BINARY_UDP_HOST`              | Jaeger Agent UDP host. Accept jaeger.thrift over binary thrift protocol    | `0.0.0.0`                                         |
| `JAEGER_AGENT_HTTP_HOST`                    | Jaeger Agent HTTP host. Serve configs.                                     | `0.0.0.0`                                         |
| `JAEGER_QUERY_HTTP_HOST`                    | Jaeger Query HTTP host.                                                    | `0.0.0.0`                                         |
| `JAEGER_QUERY_GRPC_HOST`                    | Jaeger Query GRPC host.                                                    | `0.0.0.0`                                         |
| `JAEGER_COLLECTOR_HTTP_HOST`                | Jaeger Collector Zipkin compatible host.                                   | `0.0.0.0`                                         |
| `JAEGER_COLLECTOR_GRPC_HOST`                | Jaeger Collector HTTP host. Accept jaeger.thrift directly from clients     | `0.0.0.0`                                         |
| `JAEGER_ADMIN_HTTP_HOST`                    | Jaeger Collector GRPC host. Accept jaeger.thrift directly from clients     | `0.0.0.0`                                         |
| `JAEGER_COLLECTOR_ZIPKIN_HOST`              | Jaeger Admin host.                                                         | `0.0.0.0`                                         |
| `JAEGER_METRICS_HOST`                       | Jaeger prometheus metrics host.                                            | `0.0.0.0`                                         |
| `JAEGER_HEALTHCHECK_HOST`                   | Jaeger healthcheck host.                                                   | `0.0.0.0`                                         |
| `JAEGER_COLLECTOR_OTLP_GRPC_HOST`           | Jaeger Collector OpenTelemetry gRPC host.                                  | `0.0.0.0`                                         |
| `JAEGER_COLLECTOR_OTLP_HTTP_HOST`           | Jaeger Collector OpenTelemetry HTTP host.                                  | `0.0.0.0`                                         |
| `JAEGER_APACHE_QUERY_HTTP_PORT_NUMBER`      | Jaeger Query UI HTTP port, exposed via Apache with basic authentication.   | `nil`                                             |
| `JAEGER_APACHE_QUERY_HTTPS_PORT_NUMBER`     | Jaeger Query UI HTTPS port, exposed via Apache with basic authentication.  | `nil`                                             |
| `JAEGER_APACHE_COLLECTOR_HTTP_PORT_NUMBER`  | Jaeger Collector HTTP port, exposed via Apache with basic authentication.  | `14270`                                           |
| `JAEGER_APACHE_COLLECTOR_HTTPS_PORT_NUMBER` | Jaeger Collector HTTPS port, exposed via Apache with basic authentication. | `14271`                                           |
| `SPAN_STORAGE_TYPE`                         | Jaeger storage type.                                                       | `cassandra`                                       |
| `JAEGER_CASSANDRA_HOST`                     | Cassandra server host.                                                     | `127.0.0.1`                                       |
| `JAEGER_CASSANDRA_PORT_NUMBER`              | Cassandra server port.                                                     | `9042`                                            |
| `JAEGER_CASSANDRA_KEYSPACE`                 | Cassandra keyspace.                                                        | `bn_jaeger`                                       |
| `JAEGER_CASSANDRA_DATACENTER`               | Cassandra keyspace.                                                        | `dc1`                                             |
| `JAEGER_CASSANDRA_USER`                     | Cassandra user name.                                                       | `cassandra`                                       |
| `JAEGER_CASSANDRA_PASSWORD`                 | Cassandra user password.                                                   | `nil`                                             |
| `JAEGER_CASSANDRA_ALLOWED_AUTHENTICATORS`   | Comma-separated list of allowed password authenticators for Cassandra.     | `org.apache.cassandra.auth.PasswordAuthenticator` |

#### Read-only environment variables

| Name                  | Description                        | Value                           |
|-----------------------|------------------------------------|---------------------------------|
| `JAEGER_BASE_DIR`     | Jaeger installation directory.     | `${BITNAMI_ROOT_DIR}/jaeger`    |
| `JAEGER_BIN_DIR`      | Jaeger directory for binary files. | `${JAEGER_BASE_DIR}/bin`        |
| `JAEGER_CONF_DIR`     | Jaeger configuration directory.    | `${JAEGER_BASE_DIR}/conf`       |
| `JAEGER_CONF_FILE`    | Jaeger configuration file.         | `${JAEGER_CONF_DIR}/jaeger.yml` |
| `JAEGER_LOGS_DIR`     | Jaeger logs directory.             | `${JAEGER_BASE_DIR}/logs`       |
| `JAEGER_LOG_FILE`     | Jaeger log file.                   | `${JAEGER_LOGS_DIR}/jaeger.log` |
| `JAEGER_TMP_DIR`      | Jaeger temporary directory.        | `${JAEGER_BASE_DIR}/tmp`        |
| `JAEGER_PID_FILE`     | Jaeger PID file.                   | `${JAEGER_TMP_DIR}/jaeger.pid`  |
| `JAEGER_DAEMON_USER`  | Jaeger daemon system user.         | `jaeger`                        |
| `JAEGER_DAEMON_GROUP` | Jaeger daemon system group.        | `jaeger`                        |

### Running commands

To run commands inside this container you can use `docker run`, for example to execute `jaeger --help` you can follow the example below:

```console
docker run --rm --name jaeger bitnami/jaeger:latest --help
```

Check the [official Jaeger documentation](https://jaegertracing.io//docs) for more information.

### FIPS configuration in Bitnami Secure Images

The Bitnami Jaeger Docker image from the [Bitnami Secure Images](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/jaeger).

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
