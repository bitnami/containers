# Bitnami package for JanusGraph

## What is JanusGraph?

> JanusGraph is a scalable graph database optimized for storing and querying graphs containing hundreds of billions of vertices and edges distributed across a multi-machine cluster.

[Overview of JanusGraph](https://janusgraph.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name janusgraph bitnami/janusgraph:latest
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

The recommended way to get the Bitnami JanusGraph Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/janusgraph).

```console
docker pull bitnami/janusgraph:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/janusgraph/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/janusgraph:[TAG]
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

| Name                             | Description                                                                                     | Default Value                                  |
|----------------------------------|-------------------------------------------------------------------------------------------------|------------------------------------------------|
| `JANUSGRAPH_MOUNTED_CONF_DIR`    | Directory for including custom configuration files (that override the default generated ones)   | `${JANUSGRAPH_VOLUME_DIR}/conf`                |
| `JANUSGRAPH_GREMLIN_CONF_FILE`   | Path to JanusGraph Gremlin server configuration file                                            | `${JANUSGRAPH_CONF_DIR}/gremlin-server.yaml`   |
| `JANUSGRAPH_PROPERTIES`          | Path to JanusGraph properties file                                                              | `${JANUSGRAPH_CONF_DIR}/janusgraph.properties` |
| `JANUSGRAPH_HOST`                | The name of the host to bind the JanusGraph server to.                                          | `0.0.0.0`                                      |
| `JANUSGRAPH_PORT_NUMBER`         | The port to bind the JanusGraph server to.                                                      | `8182`                                         |
| `JANUSGRAPH_STORAGE_PASSWORD`    | Password for the Janusgraph storage                                                             | `nil`                                          |
| `GREMLIN_REMOTE_HOSTS`           | Comma-separated list of Gremlin remote hosts                                                    | `localhost`                                    |
| `GREMLIN_REMOTE_PORT`            | Comma-separated list of Gremlin remote port                                                     | `$JANUSGRAPH_PORT_NUMBER`                      |
| `GREMLIN_AUTOCONFIGURE_POOL`     | If set to true, the gremlinPool will be determined by Runtime.availableProcessors().            | `false`                                        |
| `GREMLIN_THREAD_POOL_WORKER`     | The number of threads available to Gremlin Server for processing non-blocking reads and writes. | `1`                                            |
| `GREMLIN_POOL`                   | The number of threads available to execute actual scripts in a ScriptEngine.                    | `8`                                            |
| `JANUSGRAPH_JMX_METRICS_ENABLED` | Turns on JMX reporting of metrics.                                                              | `false`                                        |
| `JAVA_OPTIONS`                   | JanusGraph java options.                                                                        | `${JAVA_OPTIONS:-} -XX:+UseContainerSupport`   |

#### Read-only environment variables

| Name                          | Description                                            | Value                                 |
|-------------------------------|--------------------------------------------------------|---------------------------------------|
| `JANUSGRAPH_BASE_DIR`         | Base path for JanusGraph files.                        | `${BITNAMI_ROOT_DIR}/janusgraph`      |
| `JANUSGRAPH_VOLUME_DIR`       | JanusGraph directory for persisted files.              | `${BITNAMI_VOLUME_DIR}/janusgraph`    |
| `JANUSGRAPH_DATA_DIR`         | JanusGraph data directory.                             | `${JANUSGRAPH_VOLUME_DIR}/data`       |
| `JANUSGRAPH_BIN_DIR`          | JanusGraph bin directory.                              | `${JANUSGRAPH_BASE_DIR}/bin`          |
| `JANUSGRAPH_CONF_DIR`         | JanusGraph configuration directory.                    | `${JANUSGRAPH_BASE_DIR}/conf`         |
| `JANUSGRAPH_DEFAULT_CONF_DIR` | JanusGraph default configuration directory.            | `${JANUSGRAPH_BASE_DIR}/conf.default` |
| `JANUSGRAPH_LOGS_DIR`         | JanusGraph logs directory.                             | `${JANUSGRAPH_BASE_DIR}/logs`         |
| `JANUSGRAPH_DAEMON_USER`      | Users that will execute the JanusGraph Server process. | `janusgraph`                          |
| `JANUSGRAPH_DAEMON_GROUP`     | Group that will execute the JanusGraph Server process. | `janusgraph`                          |

Additionally, any environment variable beginning with `JANUSGRAPH_CFG_` will be mapped to its corresponding JanusGraph key. For example, use `JANUSGRAPH_CFG_STORAGE_BACKEND` in order to set `storage.backed` or `JANUSGRAPH_CFG_CACHE_DB__CACHE` in order to configure `cache.db-cache`.

### Using mounted configuration

The image looks for configuration files (janusgraph.properties, gremlin-server.yaml) in the `/bitnami/janusgraph/conf/`, this can be changed by setting the JANUSGRAPH_MOUNTED_CONF_DIR environment variable.

```console
docker run --name janusgraph -v /path/to/janusgraph.properties:/bitnami/janusgraph/conf/janusgraph.properties -v /path/to/gremlin-server.yaml:/bitnami/janusgraph/conf/gremlin-server.yaml  bitnami/janusgraph:latest
```

### FIPS configuration in Bitnami Secure Images

The Bitnami JanusGraph Docker image from the [Bitnami Secure Images](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Notable Changes

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
