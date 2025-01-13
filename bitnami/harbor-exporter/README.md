# harbor-exporter packaged by Bitnami

## What is harbor-exporter?

> The exporter component metrics collects some data from the Harbor database.

[Overview of harbor-exporter](https://github.com/goharbor/harbor)

## TL;DR

This container is part of the [Harbor solution](https://github.com/bitnami/charts/tree/main/bitnami/harbor) that is primarily intended to be deployed in Kubernetes.

```console
docker run --name harbor-exporter bitnami/harbor-exporter:latest
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use harbor-exporter in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## How to deploy Harbor in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Harbor Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/harbor).

Bitnami containers can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Configuration

harbor-exporter is a component of the Harbor application. In order to get the Harbor application running on Kubernetes we encourage you to check the [bitnami/harbor Helm chart](https://github.com/bitnami/charts/tree/master/bitnami/harbor) and configure it using the options exposed in the values.yaml file.

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

* The `docker-compose.yaml` file has been removed, as it was solely intended for internal testing purposes.

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
