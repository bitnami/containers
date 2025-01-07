# Bitnami package for JupyterHub

## What is JupyterHub?

> JupyterHub brings the power of notebooks to groups of users. It gives users access to computational environments and resources without burdening the users with installation and maintenance tasks.

[Overview of JupyterHub](https://jupyter.org/hub)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

This image is meant to run in a Kubernetes cluster.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use JupyterHub in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami jupyterhub Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/jupyterhub).

```console
docker pull bitnami/jupyterhub:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/jupyterhub/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/jupyterhub:[TAG]
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

| Name                              | Description                   | Default Value        |
|-----------------------------------|-------------------------------|----------------------|
| `JUPYTERHUB_USERNAME`             | JupyterHub admin username.    | `user`               |
| `JUPYTERHUB_PASSWORD`             | JupyterHub admin password.    | `bitnami`            |
| `JUPYTERHUB_PROXY_PORT_NUMBER`    | JupyterHub proxy port number. | `8000`               |
| `JUPYTERHUB_DATABASE_TYPE`        | Database server type.         | `postgresql`         |
| `JUPYTERHUB_DATABASE_HOST`        | Database server host.         | `127.0.0.1`          |
| `JUPYTERHUB_DATABASE_PORT_NUMBER` | Database server port.         | `5432`               |
| `JUPYTERHUB_DATABASE_NAME`        | Database name.                | `bitnami_jupyterhub` |
| `JUPYTERHUB_DATABASE_USER`        | Database user name.           | `bn_jupyterhub`      |
| `JUPYTERHUB_DATABASE_PASSWORD`    | Database user password.       | `nil`                |

#### Read-only environment variables

| Name                        | Description                                  | Value                                             |
|-----------------------------|----------------------------------------------|---------------------------------------------------|
| `JUPYTERHUB_BASE_DIR`       | JupyterHub installation directory.           | `${BITNAMI_ROOT_DIR}/jupyterhub`                  |
| `JUPYTERHUB_BIN_DIR`        | JupyterHub directory for binary executables. | `${BITNAMI_ROOT_DIR}/miniforge/bin`               |
| `JUPYTERHUB_PROXY_BIN_DIR`  | JupyterHub directory for binary executables. | `${BITNAMI_ROOT_DIR}/configurable-http-proxy/bin` |
| `JUPYTERHUB_CONF_DIR`       | JupyterHub configuration directory.          | `${JUPYTERHUB_BASE_DIR}/etc`                      |
| `JUPYTERHUB_CONF_FILE`      | JupyterHub configuration file.               | `${JUPYTERHUB_CONF_DIR}/jupyterhub_config.py`     |
| `JUPYTERHUB_LOGS_DIR`       | JupyterHub logs directory.                   | `${JUPYTERHUB_BASE_DIR}/logs`                     |
| `JUPYTERHUB_LOG_FILE`       | JupyterHub log file.                         | `${JUPYTERHUB_LOGS_DIR}/jupyterhub.log`           |
| `JUPYTERHUB_TMP_DIR`        | JupyterHub temporary directory.              | `${JUPYTERHUB_BASE_DIR}/tmp`                      |
| `JUPYTERHUB_PID_FILE`       | JupyterHub PID file.                         | `${JUPYTERHUB_TMP_DIR}/jupyterhub.pid`            |
| `JUPYTERHUB_PROXY_PID_FILE` | JupyterHub proxy PID file.                   | `${JUPYTERHUB_TMP_DIR}/jupyterhub-proxy.pid`      |
| `JUPYTERHUB_DAEMON_USER`    | JupyterHub daemon system user.               | `jupyterhub`                                      |
| `JUPYTERHUB_DAEMON_GROUP`   | JupyterHub daemon system group.              | `jupyterhub`                                      |

### Running commands

To run commands inside this container you can use `docker run`, for example to execute `jupyterhub --version` you can follow the example below:

```console
docker run --rm --name jupyterhub bitnami/jupyterhub:latest --version
```

Check the [official Jupyter Hub documentation](https://jupyterhub.readthedocs.io/en/stable/reference/config-reference.html)i, or run the following to list of the available parameters.

```console
docker run --rm --name jupyterhub bitnami/jupyterhub:latest --help-all
```

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/jupyterhub).

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
