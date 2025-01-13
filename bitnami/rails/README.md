# Bitnami package for Rails

## What is Rails?

> Rails is a web application framework running on the Ruby programming language.

[Overview of Rails](http://rubyonrails.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

### Local workspace

```console
docker run --name rails bitnami/rails:latest
```

**Warning**: This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options for the [MariaDB container](https://github.com/bitnami/containers/blob/main/bitnami/mariadb#readme) for a more secure deployment.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Rails in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Introduction

[Ruby on Rails](http://rubyonrails.org/), or simply Rails, is a web application framework written in [Ruby](https://www.ruby-lang.org) under [MIT License](https://github.com/rails/rails/blob/master/MIT-LICENSE). Rails is a model–view–controller (MVC) framework, providing default structures for a database, a web service, and web pages.

The Bitnami Rails Development Container has been carefully engineered to provide you and your team with a highly reproducible Rails development environment. We hope you find the Bitnami Rails Development Container useful in your quest for world domination. Happy hacking!

[Learn more about Bitnami Development Containers.](https://docs.bitnami.com/containers/how-to/use-bitnami-development-containers/)

## Getting started

The quickest way to get started with the Bitnami Rails Development Container is using [docker-compose](https://docs.docker.com/compose/).

Begin by creating a directory for your Rails application:

```console
mkdir ~/myapp
cd ~/myapp
```

Download the [docker-compose.yml](https://raw.githubusercontent.com/bitnami/containers/main/bitnami/rails/docker-compose.yml) file in the application directory:

```console
curl -LO https://raw.githubusercontent.com/bitnami/containers/main/bitnami/rails/docker-compose.yml
```

Finally launch the Rails application development environment using:

```console
docker-compose up
```

Among other things, the above command creates a container service, named `myapp`, for Rails development and bootstraps a new Rails application in the application directory. You can use your favourite IDE for developing the application.

> **Note**
>
> If the application directory contained the source code of an existing Rails application, the Bitnami Rails Development Container would load the existing application instead of bootstrapping a new one.

After the WEBrick application server has been launched in the `myapp` service, visit `http://localhost:3000` in your favourite web browser and you'll be greeted by the default Rails welcome page.

In addition to the Rails Development Container, the [docker-compose.yml](https://raw.githubusercontent.com/bitnami/containers/main/bitnami/rails/docker-compose.yml) file also configures a MariaDB service to serve as the database backend of your Rails application.

## Executing commands

Commands can be launched inside the `myapp` Rails Development Container with `docker-compose` using the [exec](https://docs.docker.com/compose/reference/exec/) command.

> **Note**:
>
> The `exec` command was added to `docker-compose` in release [1.7.0](https://github.com/docker/compose/blob/master/CHANGELOG.md#170-2016-04-13). Please ensure that you're using `docker-compose` version `1.7.0` or higher.

The general structure of the `exec` command is:

```console
docker-compose exec <service> <command>
```

, where `<service>` is the name of the container service as described in the `docker-compose.yml` file and `<command>` is the command you want to launch inside the service.

Following are a few examples of launching some commonly used Rails development commands inside the `myapp` service container.

* List all available rake tasks:

  ```console
  docker-compose exec myapp bundle exec rake -T
  ```

* Get information about the Rails environment:

  ```console
  docker-compose exec myapp bundle exec rake about
  ```

* Launch the Rails console:

  ```console
  docker-compose exec myapp rails console
  ```

* Generate a scaffold:

  ```console
  docker-compose exec myapp rails generate scaffold User name:string email:string
  ```

* Run database migrations:

  ```console
  docker-compose exec myapp bundle exec rake db:migrate
  ```

> **Note**
>
> Database migrations are automatically applied during the start up of the Rails Development Container. This means that the `myapp` service could also be restarted to apply the database migrations.
>
> ```console
> $ docker-compose restart myapp
> ```

## Environment variables

### Customizable environment variables

| Name                         | Description                            | Default Value   |
|------------------------------|----------------------------------------|-----------------|
| `RAILS_ENV`                  | Rails environment mode.                | `development`   |
| `RAILS_SKIP_ACTIVE_RECORD`   | Skip active record configuration.      | `no`            |
| `RAILS_SKIP_DB_SETUP`        | Skip database configuration.           | `no`            |
| `RAILS_SKIP_DB_WAIT`         | Skip waiting for database to be ready. | `no`            |
| `RAILS_RETRY_ATTEMPTS`       | Rails retry attempts.                  | `30`            |
| `RAILS_DATABASE_TYPE`        | Database server type.                  | `mariadb`       |
| `RAILS_DATABASE_HOST`        | Database server host.                  | `mariadb`       |
| `RAILS_DATABASE_PORT_NUMBER` | Database server port.                  | `3306`          |
| `RAILS_DATABASE_NAME`        | Database name.                         | `bitnami_myapp` |

### Read-only environment variables

## Configuring your database

You can configure the MariaDB hostname and database name to use for development purposes using the environment variables **DATABASE_HOST** & **DATABASE_NAME**.

For example, you can configure your Rails app to use the `development-db` database running on the `my-mariadb` MariaDB server by modifying the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/rails/docker-compose.yml) file present in this repository:

```yaml
services:
  myapp:
  ...
    environment:
      - DATABASE_HOST=my-mariadb
      - DATABASE_NAME=development-db
  ...
```

## Running additional services

Sometimes, your application will require extra pieces, such as background processing tools like Resque
or Sidekiq.

For these cases, it is possible to re-use this container to be run as an additional
service in your docker-compose file by modifying the command executed.

For example, you could run a Sidekiq container by adding the following to the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/rails/docker-compose.yml) file present in this repository:

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
  ...
```

> **Note**
>
> You can skip database wait period and creation/migration by setting the SKIP_DB_WAIT and SKIP_DB_SETUP environment variables.

## Installing Rubygems

To add a Rubygem to your application, update the `Gemfile` in the application directory as you would normally do and restart the `myapp` service container.

For example, to add the `httparty` Rubygem:

```console
echo "gem 'httparty'" >> Gemfile
docker-compose restart myapp
```

When the `myapp` service container is restarted, it will install all the missing gems before starting the WEBrick Rails application server.

## Notable Changes

## 6.0.2-2-debian-10-r52

* Decrease the size of the container. The configuration logic is now based on Bash scripts in the `rootfs/` folder.

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes.

If you detect any issue in the `docker-compose.yaml` file, feel free to report it or contribute with a fix by following our [Contributing Guidelines](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md).

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues/new) or submitting a [pull request](https://github.com/bitnami/containers/pulls/new) with your contribution.

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
