[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-laravel/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-laravel/tree/master)
[![Slack](http://slack.oss.bitnami.com/badge.svg)](http://slack.oss.bitnami.com)

# Bitnami Laravel Development Container

## TL;DR;

### Local workspace

```bash
$ mkdir ~/myapp && cd ~/myapp
$ curl -LO https://raw.githubusercontent.com/bitnami/bitnami-docker-laravel/master/docker-compose.yml
$ docker-compose up
```

### Eclipse Che workspace

Launch a on-demand Laravel development workspace in Eclipse Che by clicking the link below:

[![Laravel Development Workspace](http://beta.codenvy.com/factory/resources/codenvy-contribute.svg)](https://beta.codenvy.com/f/?url=https%3A%2F%2Fgithub.com%2Fbitnami%2Fbitnami-docker-laravel%2Ftree%2Fche)

You can find the configuration files used on the previous link in the [Che branch](https://github.com/bitnami/bitnami-docker-laravel/tree/che). For more information about Eclipse Che workspaces check the [official documentation](https://eclipse-che.readme.io/docs/introduction).

## Why use Bitnami Images ?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* Bitnami images are built on CircleCI and automatically pushed to the Docker Hub.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.

## Introduction

[Laravel](https://laravel.com/) is a web application framework for [PHP](https://php.net), released as free and open-source software under the [MIT License](https://opensource.org/licenses/MIT).

The Bitnami Laravel Development Container has been carefully engineered to provide you and your team with a highly reproducible Laravel development environment. We hope you find the Bitnami Laravel Development Container useful in your quest for world domination. Happy hacking!

[Learn more about Bitnami Development Containers.](https://docs.bitnami.com/containers/how-to/use-bitnami-development-containers/)

## Getting started

The quickest way to get started with the Bitnami Laravel Development Container is using [docker-compose](https://docs.docker.com/compose/).

Begin by creating a directory for your Laravel application:

```bash
mkdir ~/myapp
cd ~/myapp
```

Download the [docker-compose.yml](https://raw.githubusercontent.com/bitnami/bitnami-docker-laravel/master/docker-compose.yml) file in the application directory:

```bash
$ curl -LO https://raw.githubusercontent.com/bitnami/bitnami-docker-laravel/master/docker-compose.yml
```

Finally launch the Laravel application development environment using:

```bash
$ docker-compose up
```

Among other things, the above command creates a container service, named `myapp`, for Laravel development and bootstraps a new Laravel application in the application directory. You can use your favorite IDE for developing the application.

> **Note**
>
> If the application directory contained the source code of an existing Laravel application, the Bitnami Laravel Development Container would load the existing application instead of bootstrapping a new one.

After the artisan application server has been launched in the `myapp` service, visit http://localhost:3000 in your favorite web browser and you'll be greeted by the default Laravel welcome page.

In addition to the Laravel Development Container, the [docker-compose.yml](https://raw.githubusercontent.com/bitnami/bitnami-docker-laravel/master/docker-compose.yml) file also configures a MariaDB service to serve as the database backend of your Laravel application.

## Executing commands

Commands can be launched inside the `myapp` Laravel Development Container with `docker-compose` using the [exec](https://docs.docker.com/compose/reference/exec/) command.

> **Note**:
>
> The `exec` command was added to `docker-compose` in release [1.7.0](https://github.com/docker/compose/blob/master/CHANGELOG.md#170-2016-04-13). Please ensure that you're using `docker-compose` version `1.7.0` or higher.

The general structure of the `exec` command is:

```bash
$ docker-compose exec <service> <command>
```

, where `<service>` is the name of the container service as described in the `docker-compose.yml` file and `<command>` is the command you want to launch inside the service.

Following are a few examples of launching some commonly used Laravel development commands inside the `myapp` service container.

- List all `artisan` commands:

  ```bash
  $ docker-compose exec myapp php artisan list
  ```

- List all registered routes:

  ```bash
  $ docker-compose exec myapp php artisan route:list
  ```

- Create a new application controller named `User`:

  ```bash
  $ docker-compose exec myapp composer require phpmailer/phpmailer:5.2.*
  ```

## Issues

If you encountered a problem running this container, you can file an [issue](../../issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version (`uname -a`)
- Docker version (`docker version`)
- Docker info (`docker info`)
- Docker image version (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- Steps to reproduce the issue.

## Community

Most real time communication happens in the `#containers` channel at [bitnami-oss.slack.com](http://bitnami-oss.slack.com); you can sign up at [slack.oss.bitnami.com](http://slack.oss.bitnami.com).

Discussions are archived at [bitnami-oss.slackarchive.io](https://bitnami-oss.slackarchive.io).

## License

Copyright (c) 2015-2016 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
