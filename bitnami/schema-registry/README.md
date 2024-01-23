# Bitnami package for Confluent Schema Registry

## What is Confluent Schema Registry?

> Confluent Schema Registry provides a RESTful interface by adding a serving layer for your metadata on top of Kafka. It expands Kafka enabling support for Apache Avro, JSON, and Protobuf schemas.

[Overview of Confluent Schema Registry](https://www.confluent.io)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name schema-registry bitnami/schema-registry:latest
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Confluent Schema Registry in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami schema-registry Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/schema-registry).

```console
docker pull bitnami/schema-registry:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/schema-registry/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/schema-registry:[TAG]
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

| Name                               | Description                                                                                   | Default Value                       |
|------------------------------------|-----------------------------------------------------------------------------------------------|-------------------------------------|
| `SCHEMA_REGISTRY_MOUNTED_CONF_DIR` | Directory for including custom configuration files (that override the default generated ones) | `${SCHEMA_REGISTRY_VOLUME_DIR}/etc` |

#### Read-only environment variables

| Name                                    | Description                                                                               | Value                                                                    |
|-----------------------------------------|-------------------------------------------------------------------------------------------|--------------------------------------------------------------------------|
| `SCHEMA_REGISTRY_BASE_DIR`              | Base path for SCHEMA REGISTRY files.                                                      | `${BITNAMI_ROOT_DIR}/schema-registry`                                    |
| `SCHEMA_REGISTRY_VOLUME_DIR`            | SCHEMA REGISTRY directory for persisted files.                                            | `${BITNAMI_VOLUME_DIR}/schema-registry`                                  |
| `SCHEMA_REGISTRY_BIN_DIR`               | SCHEMA REGISTRY certificates directory.                                                   | `${SCHEMA_REGISTRY_BASE_DIR}/bin`                                        |
| `SCHEMA_REGISTRY_CERTS_DIR`             | SCHEMA REGISTRY certificates directory.                                                   | `${SCHEMA_REGISTRY_BASE_DIR}/certs`                                      |
| `SCHEMA_REGISTRY_CONF_DIR`              | SCHEMA REGISTRY configuration directory.                                                  | `${SCHEMA_REGISTRY_BASE_DIR}/etc`                                        |
| `SCHEMA_REGISTRY_LOGS_DIR`              | SCHEMA REGISTRY logs directory.                                                           | `${SCHEMA_REGISTRY_BASE_DIR}/logs`                                       |
| `SCHEMA_REGISTRY_CONF_FILE`             | Main SCHEMA REGISTRY configuration file.                                                  | `${SCHEMA_REGISTRY_CONF_DIR}/schema-registry/schema-registry.properties` |
| `SCHEMA_REGISTRY_DAEMON_USER`           | Users that will execute the SCHEMA REGISTRY Server process.                               | `schema-registry`                                                        |
| `SCHEMA_REGISTRY_DAEMON_GROUP`          | Group that will execute the SCHEMA REGISTRY Server process.                               | `schema-registry`                                                        |
| `SCHEMA_REGISTRY_DEFAULT_LISTENERS`     | Comma-separated list of listeners that listen for API requests over either HTTP or HTTPS. | `http://0.0.0.0:8081`                                                    |
| `SCHEMA_REGISTRY_DEFAULT_KAFKA_BROKERS` | List of Kafka brokers to connect to.                                                      | `PLAINTEXT://localhost:9092`                                             |

When you start the Confluent Schema Registry image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. Please note that some variables are only considered when the container is started for the first time. If you want to add a new environment variable:

* For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/schema-registry/docker-compose.yml) file present in this repository:

    ```yaml
    schema-registry:
      ...
      environment:
        - SCHEMA_REGISTRY_DEBUG=true
      ...
    ```

* For manual execution add a `--env` option with each variable and value:

    ```console
    $ docker run -d --name schema-registry -p 8081:8081 \
      --env SCHEMA_REGISTRY_DEBUG=true \
      --network schema-registry-tier \
      --volume /path/to/schema-registry-persistence:/bitnami \
      bitnami/schema-registry:latest
    ```

#### Kafka settings

Please check the configuration settings for the Kakfa service in the [Kafka's README file](https://github.com/bitnami/containers/tree/main/bitnami/kafka#configuration).

#### Zookeeper settings

Please check the configuration settings for the Kakfa service in the [Zookeeper's README file](https://github.com/bitnami/containers/tree/main/bitnami/zookeeper#configuration).

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/schema-registry).

If you detect any issue in the `docker-compose.yaml` file, feel free to report it or contribute with a fix by following our [Contributing Guidelines](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md).

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/containers/issues/new/choose). For us to provide better support, be sure to fill the issue template.

## License

Copyright &copy; 2024 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
