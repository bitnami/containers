[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-rails/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-rails/tree/master)
[![Slack](http://slack.oss.bitnami.com/badge.svg)](http://slack.oss.bitnami.com)
[![Kubectl](https://img.shields.io/badge/kubectl-Available-green.svg)](https://raw.githubusercontent.com/bitnami/bitnami-docker-rails/master/kubernetes.yml)

# Bitnami Rails Development Container

## TL;DR;

### Local workspace

```bash
$ mkdir ~/myapp && cd ~/myapp
$ curl -LO https://raw.githubusercontent.com/bitnami/bitnami-docker-rails/master/docker-compose.yml
$ docker-compose up
```

### Eclipse Che workspace

Launch a on-demand Rails development workspace in Eclipse Che by clicking the link below:

[![Rails Development Workspace](http://beta.codenvy.com/factory/resources/codenvy-contribute.svg)](https://beta.codenvy.com/f/?url=https%3A%2F%2Fgithub.com%2Fbitnami%2Fbitnami-docker-rails%2Ftree%2Fche)

You can find the configuration files used on the previous link in the [Che branch](https://github.com/bitnami/bitnami-docker-rails/tree/che). For more information about Eclipse Che workspaces check the [official documentation](https://eclipse-che.readme.io/docs/introduction).

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* Bitnami images are built on CircleCI and automatically pushed to the Docker Hub.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.

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
