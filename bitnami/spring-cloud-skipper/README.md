# Spring Cloud Skipper packaged by Bitnami

## What is Spring Cloud Skipper?

> A package manager that installs, upgrades, and rolls back Spring Boot applications on multiple Cloud Platforms. Skipper can be used as part of implementing the practice of Continuous Deployment.

[Overview of Spring Cloud Skipper](https://github.com/spring-cloud/spring-cloud-skipper)



## TL;DR

### Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/containers/main/bitnami/spring-cloud-skipper/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

## How to deploy Skipper in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Spring Cloud Data Flow Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/spring-cloud-dataflow).

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami spring-cloud-skipper Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/spring-cloud-skipper).

```console
$ docker pull bitnami/spring-cloud-skipper:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/spring-cloud-skipper/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/spring-cloud-skipper:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
$ git clone https://github.com/bitnami/containers.git
$ cd bitnami/APP/VERSION/OPERATING-SYSTEM
$ docker build -t bitnami/APP:latest .
```

## Configuration

You can use some environment variable in order to configure the deployment of spring cloud skipper.

### Configuring database

A relational database is used to store stream and task definitions as well as the state of executed tasks. Spring Cloud Skipper provides schemas for H2, MySQL, Oracle, PostgreSQL, Db2, and SQL Server. Use the following environment to configure the connection.

- SPRING_DATASOURCE_URL=jdbc:mariadb://mariadb-skipper:3306/skipper?useMysqlMetadata=true
- SPRING_DATASOURCE_USERNAME=bn_skipper
- SPRING_DATASOURCE_PASSWORD=bn_skipper
- SPRING_DATASOURCE_DRIVER_CLASS_NAME=org.mariadb.jdbc.Driver

Consult the [spring-cloud-skipper Reference Documentation](https://docs.spring.io/spring-cloud-skipper/docs/current/reference/htmlsingle/#_local_platform_configuration) to find the completed list of documentation.

In the same way, you might need to customize the JVM. Use the `JAVA_OPTS` environment variable for this purpose.

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/containers/issues/new/choose). For us to provide better support, be sure to fill the issue template.

## License

Copyright &copy; 2022 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
