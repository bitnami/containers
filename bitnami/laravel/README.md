# Bitnami package for Laravel

## What is Laravel?

> Laravel is an open source PHP framework for web application development.

[Overview of Laravel](https://laravel.com/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

### Local workspace

```console
mkdir ~/myapp && cd ~/myapp
docker run --name laravel -v ${PWD}/my-project:/app bitnami/laravel:latest
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Laravel in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Introduction

[Laravel](https://laravel.com/) is a web application framework for [PHP](https://php.net), released as free and open-source software under the [MIT License](https://opensource.org/licenses/MIT).

The Bitnami Laravel Development Container has been carefully engineered to provide you and your team with a highly reproducible Laravel development environment. We hope you find the Bitnami Laravel Development Container useful in your quest for world domination. Happy hacking!

[Learn more about Bitnami Development Containers.](https://docs.bitnami.com/containers/how-to/use-bitnami-development-containers/)

## Getting started

Laravel requires access to a MySQL or MariaDB database to store information. We'll use the [Bitnami Docker Image for MariaDB](https://github.com/bitnami/containers/tree/main/bitnami/mariadb) for the database requirements.

### Step 1: Create a network

```console
docker network create laravel-network
```

### Step 2: Create a volume for MariaDB persistence and create a MariaDB container

```console
$ docker volume create --name mariadb_data
docker run -d --name mariadb \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MARIADB_USER=bn_myapp \
  --env MARIADB_DATABASE=bitnami_myapp \
  --network laravel-network \
  --volume mariadb_data:/bitnami/mariadb \
  bitnami/mariadb:latest
```

### Step 3: Launch the container using the local current directory as volume

```console
$ docker run -d --name laravel \
  -p 8000:8000 \
  --env DB_HOST=mariadb \
  --env DB_PORT=3306 \
  --env DB_USERNAME=bn_myapp \
  --env DB_DATABASE=bitnami_myapp \
  --network laravel-network \
  --volume ${PWD}/my-project:/app \
  bitnami/laravel:latest
```

Among other things, the above command creates a container service, named `myapp`, for Laravel development and bootstraps a new Laravel application in the application directory. You can use your favorite IDE for developing the application.

> **Note**
>
> If the application directory contained the source code of an existing Laravel application, the Bitnami Laravel Development Container would load the existing application instead of bootstrapping a new one.

After the application server has been launched in the `myapp` service, visit `http://localhost:8000` in your favorite web browser and you'll be greeted by the default Laravel welcome page.

**Warning**: This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options for the [MariaDB container](https://github.com/bitnami/containers/blob/main/bitnami/mariadb#readme) for a more secure deployment.

## Environment variables

### Customizable environment variables

| Name                           | Description                                    | Default Value   |
|--------------------------------|------------------------------------------------|-----------------|
| `LARAVEL_PORT_NUMBER`          | Laravel server port.                           | `8000`          |
| `LARAVEL_SKIP_COMPOSER_UPDATE` | Skip command to execute Composer dependencies. | `no`            |
| `LARAVEL_SKIP_DATABASE`        | Skip database configuration.                   | `no`            |
| `LARAVEL_DATABASE_TYPE`        | Database server type.                          | `mysql`         |
| `LARAVEL_DATABASE_HOST`        | Database server host.                          | `mariadb`       |
| `LARAVEL_DATABASE_PORT_NUMBER` | Database server port.                          | `3306`          |
| `LARAVEL_DATABASE_NAME`        | Database name.                                 | `bitnami_myapp` |
| `LARAVEL_DATABASE_USER`        | Database user name.                            | `bn_myapp`      |
| `LARAVEL_DATABASE_PASSWORD`    | Database user password.                        | `nil`           |

### Read-only environment variables

| Name               | Description                     | Value                         |
|--------------------|---------------------------------|-------------------------------|
| `LARAVEL_BASE_DIR` | Laravel installation directory. | `${BITNAMI_ROOT_DIR}/laravel` |

## Executing commands

Commands can be launched inside the `myapp` Laravel Development Container with `docker` using the [exec](https://docs.docker.com/engine/reference/commandline/exec/) command.

The general structure of the `exec` command is:

```console
docker exec <container-name> <command>
```

where `<command>` is the command you want to launch inside the container.

## Notable Changes

### Starting January 16, 2024

* The `docker-compose.yaml` file has been removed, as it was solely intended for internal testing purposes.

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues/new) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Special Thanks

We want to thank the following individuals for reporting vulnerabilities responsibly and helping improve the security of this container.

* [LEI WANG](https://github.com/ssst0n3): APP_KEY fixed into the docker image

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/containers/issues/new). Be sure to include the following information in your issue:

* Host OS and version
* Docker version (`docker version`)
* Output of `docker info`
* Version of this container
* The command you used to run the container, and any relevant output you saw (masking any sensitive information)

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
