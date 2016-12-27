[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-symfony/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-symfony/tree/master)
[![Docker Hub Automated Build](http://container.checkforupdates.com/badges/bitnami/symfony)](https://hub.docker.com/r/bitnami/symfony/)

# Bitnami Symfony Development Container

## TL;DR;

### Local workspace

```bash
$ mkdir ~/myapp && cd ~/myapp
$ curl -LO https://raw.githubusercontent.com/bitnami/bitnami-docker-symfony/master/docker-compose.yml
$ docker-compose up
```

### Eclipse Che workspace

Launch an on-demand Symfony development workspace in Eclipse Che by clicking the link below:

[![Symfony Development Workspace](http://beta.codenvy.com/factory/resources/codenvy-contribute.svg)](https://beta.codenvy.com/f/?url=https%3A%2F%2Fgithub.com%2Fbitnami%2Fbitnami-docker-symfony%2Ftree%2Fche)

You can find the configuration files used on the previous link in the [Che branch](https://github.com/bitnami/bitnami-docker-symfony/tree/che). For more information about Eclipse Che workspaces check the [official documentation](https://eclipse-che.readme.io/docs/introduction).

## Introduction

[Symfony](http://rubyonsymfony.org/), is a web application framework written in [PHP](http://www.php.net) under [MIT License](http://symfony.com/doc/current/contributing/code/license.html).

The Bitnami Symfony Development Container has been carefully engineered to provide you and your team with a highly reproducible Symfony development environment. We hope you find the Bitnami Symfony Development Container useful in your quest for world domination. Happy hacking!

[Learn more about Bitnami Development Containers.](https://docs.bitnami.com/containers/how-to/use-bitnami-development-containers/)

## Getting started

The quickest way to get started with the Bitnami Symfony Development Container is using [docker-compose](https://docs.docker.com/compose/).

Begin by creating a directory for your Symfony application:

```bash
$ mkdir ~/myapp
$ cd ~/myapp
```

Download the [docker-compose.yml](https://raw.githubusercontent.com/bitnami/bitnami-docker-symfony/master/docker-compose.yml) file in the application directory:

```bash
$ curl -LO https://raw.githubusercontent.com/bitnami/bitnami-docker-symfony/master/docker-compose.yml
```

Finally launch the Symfony application development environment using:

```bash
$ docker-compose up
```

The above command creates a container service for Symfony development and bootstraps a new Symfony application, named `myapp` in working directory. You can use your favorite IDE for developing the application.

After the built-in PHP application server has been started, visit http://localhost:8000 in your favorite web browser and you'll be greeted by the Symfony welcome page.

## Executing commands

Commands can be launched inside the `myapp` Symfony Development Container with `docker-compose` using the [exec](https://docs.docker.com/compose/reference/exec/) command.

> **Note**:
>
> The `exec` command was added to `docker-compose` in release [1.7.0](https://github.com/docker/compose/blob/master/CHANGELOG.md#170-2016-04-13). Please ensure that you're using `docker-compose` version `1.7.0` or higher.

The general structure of the `exec` command is:

```bash
$ docker-compose exec <service> <command>
```
where `<service>` is the name of the container service as described in the `docker-compose.yml` file and `<command>` is the command you want to launch inside the service.

Following are a few examples:

- Create a new project named `foo`:

  ```bash
  $ docker-compose run myapp nami execute symfony createProject foo
  ```

- Create a new project named `bar` which uses Symfony version `2.5.0`

  ```bash
  $ docker-compose run myapp nami execute symfony createProject "bar 2.5.0"
  ```

  Note: In the above two examples the `docker-compose.yml` file should be updated so that the `SYMFONY_PROJECT_NAME` specifies the project name that should be served my the PHP application server.

## Issues

If you encountered a problem running this container, you can file an [issue](../../issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version (`$ uname -a`)
- Docker version (`$ docker version`)
- Docker info (`$ docker info`)
- Docker image version (`$ echo $BITNAMI_IMAGE_VERSION` inside the container)
- Steps to reproduce the issue.

## License

Copyright (c) 2015-2016 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
