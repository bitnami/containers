# Bitnami package for Spring Cloud Skipper

## What is Spring Cloud Skipper?

> A package manager that installs, upgrades, and rolls back Spring Boot applications on multiple Cloud Platforms. Skipper can be used as part of implementing the practice of Continuous Deployment.

[Overview of Spring Cloud Skipper](https://github.com/spring-cloud/spring-cloud-skipper)

## TL;DR

```console
docker run --name spring-cloud-skipper bitnami/spring-cloud-skipper:latest
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Spring Cloud Skipper in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## How to deploy Skipper in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Spring Cloud Data Flow Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/spring-cloud-dataflow).

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami spring-cloud-skipper Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/spring-cloud-skipper).

```console
docker pull bitnami/spring-cloud-skipper:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/spring-cloud-skipper/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/spring-cloud-skipper:[TAG]
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

| Name                                         | Description                                                            | Default Value |
|----------------------------------------------|------------------------------------------------------------------------|---------------|
| `SERVER_PORT`                                | Custom port number to use for the SPRING CLOUD SKIPPER Server service. | `nil`         |
| `SPRING_CLOUD_CONFIG_ENABLED`                | Whether to load config using Spring Cloud Config Servie.               | `false`       |
| `SPRING_CLOUD_KUBERNETES_SECRETS_ENABLE_API` | Whether to load config using Kubernetes API.                           | `false`       |
| `SPRING_CLOUD_KUBERNETES_CONFIG_NAME`        | Name of the ConfigMap that contains the configuration.                 | `nil`         |
| `SPRING_CLOUD_KUBERNETES_SECRETS_PATHS`      | Paths where the secrets are going to be mount.                         | `nil`         |
| `JAVA_OPTS`                                  | JVM options                                                            | `nil`         |
| `JAVA_TOOL_OPTIONS`                          | Java tool options.                                                     | `nil`         |

#### Read-only environment variables

| Name                                | Description                                                      | Value                                              |
|-------------------------------------|------------------------------------------------------------------|----------------------------------------------------|
| `SPRING_CLOUD_SKIPPER_BASE_DIR`     | Base path for SPRING CLOUD SKIPPER files.                        | `${BITNAMI_ROOT_DIR}/spring-cloud-skipper`         |
| `SPRING_CLOUD_SKIPPER_VOLUME_DIR`   | SPRING CLOUD SKIPPER directory for persisted files.              | `${BITNAMI_VOLUME_DIR}/spring-cloud-skipper`       |
| `SPRING_CLOUD_SKIPPER_CONF_DIR`     | SPRING CLOUD SKIPPER configuration directory.                    | `${SPRING_CLOUD_SKIPPER_BASE_DIR}/conf`            |
| `SPRING_CLOUD_SKIPPER_CONF_FILE`    | Main SPRING CLOUD SKIPPER configuration file.                    | `${SPRING_CLOUD_SKIPPER_CONF_DIR}/application.yml` |
| `SPRING_CLOUD_SKIPPER_M2_DIR`       | SPRING CLOUD SKIPPER maven root dir.                             | `/.m2`                                             |
| `SPRING_CLOUD_SKIPPER_DAEMON_USER`  | Users that will execute the SPRING CLOUD SKIPPER Server process. | `dataflow`                                         |
| `SPRING_CLOUD_SKIPPER_DAEMON_GROUP` | Group that will execute the SPRING CLOUD SKIPPER Server process. | `dataflow`                                         |

#### Configuring database

A relational database is used to store stream and task definitions as well as the state of executed tasks. Spring Cloud Skipper provides schemas for H2, MySQL, Oracle, PostgreSQL, Db2, and SQL Server. Use the following environment to configure the connection.

* SPRING_DATASOURCE_URL=jdbc:mariadb://mariadb-skipper:3306/skipper?useMysqlMetadata=true
* SPRING_DATASOURCE_USERNAME=bn_skipper
* SPRING_DATASOURCE_PASSWORD=bn_skipper
* SPRING_DATASOURCE_DRIVER_CLASS_NAME=org.mariadb.jdbc.Driver

Consult the [spring-cloud-skipper Reference Documentation](https://docs.spring.io/spring-cloud-skipper/docs/current/reference/htmlsingle/#_local_platform_configuration) to find the completed list of documentation.

In the same way, you might need to customize the JVM. Use the `JAVA_OPTS` environment variable for this purpose.

## Notable Changes

### Starting January 16, 2024

* The `docker-compose.yaml` file has been removed, as it was solely intended for internal testing purposes.

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
