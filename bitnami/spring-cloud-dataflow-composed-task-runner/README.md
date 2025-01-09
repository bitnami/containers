# Bitnami package for SCDF Composed Task Runner

## What is SCDF Composed Task Runner?

> The Spring Cloud Composed Task Runner is a helper used by the Data Flow server to parse a directed graph DSL, launch the task definition specified in an instance, and check task completion status.

[Overview of SCDF Composed Task Runner](https://github.com/spring-cloud/spring-cloud-dataflow)

## TL;DR

```console
docker run --name spring-cloud-dataflow-composed-task-runner bitnami/spring-cloud-dataflow-composed-task-runner:latest
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use SCDF Composed Task Runner in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami spring-cloud-dataflow-composed-task-runner Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/spring-cloud-dataflow-composed-task-runner).

```console
docker pull bitnami/spring-cloud-dataflow-composed-task-runner:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/spring-cloud-dataflow-composed-task-runner/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/spring-cloud-dataflow-composed-task-runner:[TAG]
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

| Name                | Description        | Default Value |
|---------------------|--------------------|---------------|
| `JAVA_OPTS`         | JVM options        | `nil`         |
| `JAVA_TOOL_OPTIONS` | Java tool options. | `nil`         |

#### Read-only environment variables

| Name                                     | Description                                                           | Value                                                            |
|------------------------------------------|-----------------------------------------------------------------------|------------------------------------------------------------------|
| `SCDF_COMPOSED_TASK_RUNNER_BASE_DIR`     | Base path for SCDF COMPOSED TASK RUNNER files.                        | `${BITNAMI_ROOT_DIR}/spring-cloud-dataflow-composed-task-runner` |
| `SCDF_COMPOSED_TASK_RUNNER_M2_DIR`       | SCDF COMPOSED TASK RUNNER maven root dir.                             | `/.m2`                                                           |
| `SCDF_COMPOSED_TASK_RUNNER_DAEMON_USER`  | Users that will execute the SCDF COMPOSED TASK RUNNER Server process. | `dataflow`                                                       |
| `SCDF_COMPOSED_TASK_RUNNER_DAEMON_GROUP` | Group that will execute the SCDF COMPOSED TASK RUNNER Server process. | `dataflow`                                                       |

### Running commands

To run tasks inside this container you can use `docker run`:

```console
docker run --rm --name spring-cloud-dataflow-composed-task-runner bitnami/spring-cloud-dataflow-composed-task-runner:latest <runner_args>
```

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
