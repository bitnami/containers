
# Bitnami Laravel Development Container

## TL;DR

### Local workspace

```console
$ mkdir ~/myapp && cd ~/myapp
$ curl -LO https://raw.githubusercontent.com/bitnami/bitnami-docker-laravel/master/docker-compose.yml
$ docker-compose up
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/laravel?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`8`, `8-debian-10`, `8.5.18`, `8.5.18-debian-10-r5`, `latest` (8/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-laravel/blob/8.5.18-debian-10-r5/8/debian-10/Dockerfile)
* [`6`, `6-debian-10`, `6.20.1`, `6.20.1-debian-10-r12` (6/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-laravel/blob/6.20.1-debian-10-r12/6/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/laravel GitHub repo](https://github.com/bitnami/bitnami-docker-laravel).

## Introduction

[Laravel](https://laravel.com/) is a web application framework for [PHP](https://php.net), released as free and open-source software under the [MIT License](https://opensource.org/licenses/MIT).

The Bitnami Laravel Development Container has been carefully engineered to provide you and your team with a highly reproducible Laravel development environment. We hope you find the Bitnami Laravel Development Container useful in your quest for world domination. Happy hacking!

[Learn more about Bitnami Development Containers.](https://docs.bitnami.com/containers/how-to/use-bitnami-development-containers/)

## Getting started

The quickest way to get started with the Bitnami Laravel Development Container is using [docker-compose](https://docs.docker.com/compose/).

Begin by creating a directory for your Laravel application:

```console
mkdir ~/myapp
cd ~/myapp
```

Download the [docker-compose.yml](https://raw.githubusercontent.com/bitnami/bitnami-docker-laravel/master/docker-compose.yml) file in the application directory:

```console
$ curl -LO https://raw.githubusercontent.com/bitnami/bitnami-docker-laravel/master/docker-compose.yml
```

Finally launch the Laravel application development environment using:

```console
$ docker-compose up
```

Among other things, the above command creates a container service, named `myapp`, for Laravel development and bootstraps a new Laravel application in the application directory. You can use your favorite IDE for developing the application.

> **Note**
>
> If the application directory contained the source code of an existing Laravel application, the Bitnami Laravel Development Container would load the existing application instead of bootstrapping a new one.

After the artisan application server has been launched in the `myapp` service, visit http://localhost:3000 in your favorite web browser and you'll be greeted by the default Laravel welcome page.

> **Note**
>
> If no application available at http://localhost:3000 and you're running Docker on Windows, you might need to uncomment `privileged` setting for `myapp` container. Later, re-launch the Laravel application development environment as stated before.

In addition to the Laravel Development Container, the [docker-compose.yml](https://raw.githubusercontent.com/bitnami/bitnami-docker-laravel/master/docker-compose.yml) file also configures a MariaDB service to serve as the database backend of your Laravel application.

## Executing commands

Commands can be launched inside the `myapp` Laravel Development Container with `docker-compose` using the [exec](https://docs.docker.com/compose/reference/exec/) command.

> **Note**:
>
> The `exec` command was added to `docker-compose` in release [1.7.0](https://github.com/docker/compose/blob/master/CHANGELOG.md#170-2016-04-13). Please ensure that you're using `docker-compose` version `1.7.0` or higher.

The general structure of the `exec` command is:

```console
$ docker-compose exec <service> <command>
```

, where `<service>` is the name of the container service as described in the `docker-compose.yml` file and `<command>` is the command you want to launch inside the service.

Following are a few examples of launching some commonly used Laravel development commands inside the `myapp` service container.

- List all `artisan` commands:

  ```console
  $ docker-compose exec myapp php artisan list
  ```

- List all registered routes:

  ```console
  $ docker-compose exec myapp php artisan route:list
  ```

- Create a new application controller named `UserController`:

  ```console
  $ docker-compose exec myapp php artisan make:controller UserController
  ```

- Installing a new composer package called `phpmailer/phpmailer` with version `5.2.*`:

  ```console
  $ docker-compose exec myapp composer require phpmailer/phpmailer:5.2.*
  ```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-laravel/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-laravel/pulls) with your contribution.

## Special Thanks

We want to thank the following individuals for reporting vulnerabilities responsibly and helping improve the security of this container.

- [LEI WANG](`https://github.com/ssst0n3): [APP_KEY fixed into the docker image](https://github.com/bitnami/bitnami-docker-laravel/issues/139)

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-laravel/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version (`uname -a`)
- Docker version (`docker version`)
- Docker info (`docker info`)
- Docker image version (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- Steps to reproduce the issue.

## License

Copyright (c) 2015-2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
