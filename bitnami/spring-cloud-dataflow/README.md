
# What is Spring Cloud Data Flow?

> Spring Cloud Data Flow is a microservices-based toolkit for building streaming and batch data processing pipelines in Cloud Foundry and Kubernetes.

[Overview of spring cloud data flow](https://docs.spring.io/spring-cloud-dataflow/docs/current/reference/htmlsingle/#getting-started)

# TL;DR

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-spring-cloud-dataflow/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/spring-cloud-dataflow?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy Data Flow in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Spring Cloud Data Flow Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/spring-cloud-dataflow).

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`2`, `2-debian-10`, `2.7.2`, `2.7.2-debian-10-r14`, `latest` (2/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-spring-cloud-dataflow/blob/2.7.2-debian-10-r14/2/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/spring-cloud-dataflow GitHub repo](https://github.com/bitnami/bitnami-docker-spring-cloud-dataflow).

# Get this image

The recommended way to get the Bitnami spring-cloud-dataflow Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/spring-cloud-dataflow).

```console
$ docker pull bitnami/spring-cloud-dataflow:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/spring-cloud-dataflow/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/spring-cloud-dataflow:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/spring-cloud-dataflow:latest 'https://github.com/bitnami/bitnami-docker-spring-cloud-dataflow.git#master:2/debian-10'
```

# Configuration

You can use some environment variable in order to configure the deployment of spring cloud data flow.

## Configuring database

A relational database is used to store stream and task definitions as well as the state of executed tasks. Spring Cloud Data Flow provides schemas for H2, MySQL, Oracle, PostgreSQL, Db2, and SQL Server. Use the following environment to configure the connection.

- SPRING_DATASOURCE_URL=jdbc:mariadb://mariadb-dataflow:3306/dataflow?useMysqlMetadata=true
- SPRING_DATASOURCE_USERNAME=bn_dataflow
- SPRING_DATASOURCE_PASSWORD=bn_dataflow
- SPRING_DATASOURCE_DRIVER_CLASS_NAME=org.mariadb.jdbc.Driver

If you are using MariaDB 10.2 or greater, you must also set the following environment variable:

- spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MariaDB102Dialect

## Configuring additional features

Spring Cloud Data Flow Server offers specific set of features that can be enabled/disabled when launching.

- SPRING_CLOUD_DATAFLOW_FEATURES_STREAMS_ENABLED=true. If you enable streams, you will need to configure the stream platform, see [Configuring stream platform](#configuringstreamplatform).
- SPRING_CLOUD_DATAFLOW_FEATURES_TASKS_ENABLED=true

In the same way, you might need to customize the JVM. Use the `JAVA_OPTS` environment variable for this purpose.

## Configuring stream platform

In order to deploy streams using data flow you will require [Spring Cloud Skipper](https://github.com/bitnami/bitnami-docker-spring-cloud-skipper) and one of the following messaging platforms. Please add the following environment variable to point to a different skipper endpoint.

- SPRING_CLOUD_SKIPPER_CLIENT_SERVER_URI=http://spring-cloud-skipper:7577/api

### Using RabbitMQ

- spring.cloud.dataflow.applicationProperties.stream.spring.rabbitmq.host=rabbitmq
- spring.cloud.dataflow.applicationProperties.stream.spring.rabbitmq.port=5672
- spring.cloud.dataflow.applicationProperties.stream.spring.rabbitmq.username=user
- spring.cloud.dataflow.applicationProperties.stream.spring.rabbitmq.password=bitnami

### Using Kafka

- spring.cloud.dataflow.applicationProperties.stream.spring.cloud.stream.kafka.binder.brokers=PLAINTEXT://kafka-broker:9092
- spring.cloud.dataflow.applicationProperties.stream.spring.cloud.stream.kafka.streams.binder.brokers=PLAINTEXT://kafka-broker:9092
- spring.cloud.dataflow.applicationProperties.stream.spring.cloud.stream.kafka.binder.zkNodes=zookeeper:2181
- spring.cloud.dataflow.applicationProperties.stream.spring.cloud.stream.kafka.streams.binder.zkNodes=zookeeper:2181

Consult the [spring-cloud-dataflow Reference Documentation](https://docs.spring.io/spring-cloud-dataflow/docs/current/reference/htmlsingle/#configuration-local) to find the completed list of documentation.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-spring-cloud-dataflow/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-spring-cloud-dataflow/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-spring-cloud-dataflow/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright 2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
