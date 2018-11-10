[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-rails/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-rails/tree/master)

# Bitnami Rails Development Container

## TL;DR;

### Local workspace

```bash
$ mkdir ~/myapp && cd ~/myapp
$ curl -LO https://raw.githubusercontent.com/bitnami/bitnami-docker-rails/master/docker-compose.yml
$ docker-compose up
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* Bitnami images are built on CircleCI and automatically pushed to the Docker Hub.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.
* Bitnami container images are released daily with the latest distribution packages available.

[![Anchore Image Overview](https://anchore.io/service/badges/image/b03d5b902d89c9285f85107fed1d5507abd3805f256d3912bd78b10240f0e7e8)](https://anchore.io/image/dockerhub/bitnami%2Frails%3Alatest#security)

> The image overview badge contains a security report with all open CVEs. Click on 'Show only CVEs with fixes' to get the list of actionable security issues.

## Supported tags and respective `Dockerfile` links

> NOTE: Debian 8 images have been deprecated in favor of Debian 9 images. Bitnami will not longer publish new Docker images based on Debian 8.

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/).


* [`5-ol-7`, `5.2.1-ol-7-r6` (5/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-rails/blob/5.2.1-ol-7-r6/5/ol-7/Dockerfile)
* [`5-debian-9`, `5.2.1-debian-9-r5`, `5`, `5.2.1`, `5.2.1-r5`, `latest` (5/debian-9/Dockerfile)](https://github.com/bitnami/bitnami-docker-rails/blob/5.2.1-debian-9-r5/5/debian-9/Dockerfile)

Subscribe to project updates by watching the [bitnami/rails GitHub repo](https://github.com/bitnami/bitnami-docker-rails).

## Introduction

[Ruby on Rails](http://rubyonrails.org/), or simply Rails, is a web application framework written in [Ruby](https://www.ruby-lang.org) under [MIT License](https://github.com/rails/rails/blob/master/MIT-LICENSE). Rails is a model–view–controller (MVC) framework, providing default structures for a database, a web service, and web pages.

The Bitnami Rails Development Container has been carefully engineered to provide you and your team with a highly reproducible Rails development environment. We hope you find the Bitnami Rails Development Container useful in your quest for world domination. Happy hacking!

[Learn more about Bitnami Development Containers.](https://docs.bitnami.com/containers/how-to/use-bitnami-development-containers/)

## Getting started

The quickest way to get started with the Bitnami Rails Development Container is using [docker-compose](https://docs.docker.com/compose/).

Begin by creating a directory for your Rails application:

```bash
mkdir ~/myapp
cd ~/myapp
```

Download the [docker-compose.yml](https://raw.githubusercontent.com/bitnami/bitnami-docker-rails/master/docker-compose.yml) file in the application directory:

```bash
$ curl -LO https://raw.githubusercontent.com/bitnami/bitnami-docker-rails/master/docker-compose.yml
```

Finally launch the Rails application development environment using:

```bash
$ docker-compose up
```

Among other things, the above command creates a container service, named `myapp`, for Rails development and bootstraps a new Rails application in the application directory. You can use your favorite IDE for developing the application.

> **Note**
>
> If the application directory contained the source code of an existing Rails application, the Bitnami Rails Development Container would load the existing application instead of bootstrapping a new one.

After the WEBrick application server has been launched in the `myapp` service, visit http://localhost:3000 in your favorite web browser and you'll be greeted by the default Rails welcome page.

In addition to the Rails Development Container, the [docker-compose.yml](https://raw.githubusercontent.com/bitnami/bitnami-docker-rails/master/docker-compose.yml) file also configures a MariaDB service to serve as the database backend of your Rails application.

## Executing commands

Commands can be launched inside the `myapp` Rails Development Container with `docker-compose` using the [exec](https://docs.docker.com/compose/reference/exec/) command.

> **Note**:
>
> The `exec` command was added to `docker-compose` in release [1.7.0](https://github.com/docker/compose/blob/master/CHANGELOG.md#170-2016-04-13). Please ensure that you're using `docker-compose` version `1.7.0` or higher.

The general structure of the `exec` command is:

```bash
$ docker-compose exec <service> <command>
```

, where `<service>` is the name of the container service as described in the `docker-compose.yml` file and `<command>` is the command you want to launch inside the service.

Following are a few examples of launching some commonly used Rails development commands inside the `myapp` service container.

- List all available rake tasks:

  ```bash
  $ docker-compose exec myapp bundle exec rake -T
  ```

- Get information about the Rails environment:

  ```bash
  $ docker-compose exec myapp bundle exec rake about
  ```

- Launch the Rails console:

  ```bash
  $ docker-compose exec myapp rails console
  ```

- Generate a scaffold:

  ```bash
  $ docker-compose exec myapp rails generate scaffold User name:string email:string
  ```

- Run database migrations:

  ```bash
  $ docker-compose exec myapp bundle exec rake db:migrate
  ```

  > **Note**
  >
  > Database migrations are automatically applied during the start up of the Rails Development Container. This means that the `myapp` service could also be restarted to apply the database migrations.
  > ```bash
  > $ docker-compose restart myapp
  > ```

## Running additional services:

  Sometimes, your application will require extra pieces, such as background processing tools like Resque
or Sidekiq.

  For these cases, it is possible to re-use this container to be run as an additional
service in your docker-compose file by modifying the command
executed.

For example, you could run a Sidekiq container by adding the following to your
`docker-compose.yml` file:

```yaml
services:
  ...
  sidekiq:
    image: bitnami/rails:latest
    environment:
      # This skips the execution of rake db:create and db:migrate
      # since it is being executed by the rails service.
      - SKIP_DB_SETUP=true
    command: bundle exec sidekiq
```

> **Note**
>
> You can skip database wait period and creation/migration by setting the SKIP_DB_WAIT and SKIP_DB_SETUP environment variables.

## Installing Rubygems

To add a Rubygem to your application, update the `Gemfile` in the application directory as you would normally do and restart the `myapp` service container.

For example, to add the `httparty` Rubygem:

```bash
$ echo "gem 'httparty'" >> Gemfile
$ docker-compose restart myapp
```

When the `myapp` service container is restarted, it will install all the missing gems before starting the WEBrick Rails application server.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-rails/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-rails/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](../../issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version (`uname -a`)
- Docker version (`docker version`)
- Docker info (`docker info`)
- Docker image version (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- Steps to reproduce the issue.

## License

Copyright (c) 2015-2018 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
