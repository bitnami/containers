
# Bitnami Symfony Development Container

## TL;DR

### Local workspace

```console
$ mkdir ~/my-project
$ curl -LO https://raw.githubusercontent.com/bitnami/bitnami-docker-symfony/master/docker-compose.yml
$ docker-compose up
```

**Warning**: This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options for the [MariaDB container](https://github.com/bitnami/bitnami-docker-mariadb#readme) for a more secure deployment.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/symfony?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`5.3`, `5.3-debian-10`, `5.3.10`, `5.3.10-debian-10-r2` (5.3/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-symfony/blob/5.3.10-debian-10-r2/5.3/debian-10/Dockerfile)
* [`4.4`, `4.4-debian-10`, `4.4.33`, `4.4.33-debian-10-r2` (4.4/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-symfony/blob/4.4.33-debian-10-r2/4.4/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/symfony GitHub repo](https://github.com/bitnami/bitnami-docker-symfony).

## Introduction

[Symfony](https://symfony.com/), is a web application framework written in [PHP](http://www.php.net) under [MIT License](http://symfony.com/doc/current/contributing/code/license.html).

The Bitnami Symfony Development Container has been carefully engineered to provide you and your team with a highly reproducible Symfony development environment. We hope you find the Bitnami Symfony Development Container useful in your quest for world domination. Happy hacking!

[Learn more about Bitnami Development Containers.](https://docs.bitnami.com/containers/how-to/use-bitnami-development-containers/)

## Getting started

The quickest way to get started with the Bitnami Symfony Development Container is using [docker-compose](https://docs.docker.com/compose/).

Begin by creating a directory for your Symfony application:

```console
$ mkdir ~/my-project
```

Download the [docker-compose.yml](https://raw.githubusercontent.com/bitnami/bitnami-docker-symfony/master/docker-compose.yml) file:

```console
$ curl -LO https://raw.githubusercontent.com/bitnami/bitnami-docker-symfony/master/docker-compose.yml
```

Choose the skeleton you want to use to create your project. By default this image ships two skeletons:

- `symfony/skeleton`: useful for microservices or API(s).
- `symfony/website-skeleton`: useful for traditional web applications.

You can use the `SYMFONY_PROJECT_SKELETON` env. variable to choose the skeleton to use. Find more information about available skeletons [at the Symfony documentation](https://symfony.com/doc/current/setup.html#creating-symfony-applications).

You can also configure your Symfony app to use a database. As an alternative, you can also set `SYMFONY_SKIP_DATABASE` to `true` to skip the database configuration.
The example below shows how to set the required env. vars to do use a MariaDB container as database:

```yaml
version: '2'

services:
  mariadb:
    image: bitnami/mariadb:10.3
    environment:
      # ALLOW_EMPTY_PASSWORD is recommended only for development.
      - ALLOW_EMPTY_PASSWORD=yes
      - MARIADB_USER=bn_myapp
      - MARIADB_DATABASE=bitnami_myapp
  myapp:
    image: bitnami/symfony:latest
    ports:
      - '8000:8000'
    environment:
      # ALLOW_EMPTY_PASSWORD is recommended only for development.
      - ALLOW_EMPTY_PASSWORD=yes
      - SYMFONY_PROJECT_SKELETON=symfony/website-skeleton
      - SYMFONY_DATABASE_HOST=mariadb
      - SYMFONY_DATABASE_PORT_NUMBER=3306
      - SYMFONY_DATABASE_USER=bn_myapp
      - SYMFONY_DATABASE_NAME=bitnami_myapp
    volumes:
      - './my-project:/app'
    depends_on:
      - mariadb
```

Finally launch the Symfony application development environment using:

```console
$ docker-compose up
```

The above command creates a container service for Symfony development and bootstraps a new Symfony application, in the "my-project" subdirectory under your working directory. You can use your favorite IDE for developing the application.

After the built-in PHP application server has been started, visit http://localhost:8000 in your favorite web browser and you'll be greeted by the Symfony welcome page.

## Executing commands

Commands can be launched inside the `myapp` Symfony Development Container with `docker-compose` using the [exec](https://docs.docker.com/compose/reference/exec/) command.

The general structure of the `exec` command is:

```console
$ docker-compose exec <service> <command>
```

where `<service>` is the name of the container service as described in the `docker-compose.yml` file and `<command>` is the command you want to launch inside the service.

For instance, follow the example below to install a custom Symfony pack in your app:

```console
$ docker-compose run myapp composer require SYMFONY_PACK -d /app
```

> Note: remember to replace the _SYMFONY_PACK_ placeholder with the actual pack you want to install.

## Notable Changes

### 4.4.30-debian-10-r0 and 5.3.7-debian-10-r0

- The size of the container image has been decreased.
- The configuration logic is now based on Bash scripts in the *rootfs/* folder.
- The `symfony` cli is not included in the container anymore, use `composer` to install Symfony packs instead.

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-symfony/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-symfony/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-symfony/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version (`$ uname -a`)
- Docker version (`$ docker version`)
- Docker info (`$ docker info`)
- Docker image version (`$ echo $BITNAMI_IMAGE_VERSION` inside the container)
- Steps to reproduce the issue.

## License

Copyright (c) 2015-2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
