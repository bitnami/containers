
# Bitnami Express Development Container

## TL;DR

### Local workspace

```console
$ mkdir ~/myapp && cd ~/myapp
$ curl -LO https://raw.githubusercontent.com/bitnami/bitnami-docker-express/master/docker-compose.yml
$ docker-compose up
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/express?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`4`, `4-debian-10`, `4.17.1`, `4.17.1-debian-10-r432`, `latest` (4/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-express/blob/4.17.1-debian-10-r432/4/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/codiad GitHub repo](https://github.com/bitnami/bitnami-docker-codiad).

## Introduction

[Express.js](http://expressjs.org/), or simply Express, is a web application framework for [Node.js](https://nodejs.org), released as free and open-source software under the [MIT License](https://github.com/nodejs/node/blob/master/LICENSE).

The Bitnami Express Development Container has been carefully engineered to provide you and your team with a highly reproducible Express development environment. We hope you find the Bitnami Express Development Container useful in your quest for world domination. Happy hacking!

[Learn more about Bitnami Development Containers.](https://docs.bitnami.com/containers/how-to/use-bitnami-development-containers/)

## Getting started

The quickest way to get started with the Bitnami Express Development Container is using [docker-compose](https://docs.docker.com/compose/).

Begin by creating a directory for your Express application:

```console
mkdir ~/myapp
cd ~/myapp
```

Download the [docker-compose.yml](https://raw.githubusercontent.com/bitnami/bitnami-docker-express/master/docker-compose.yml) file in the application directory:

```console
$ curl -LO https://raw.githubusercontent.com/bitnami/bitnami-docker-express/master/docker-compose.yml
```

Finally launch the Express application development environment using:

```console
$ docker-compose up
```

Among other things, the above command creates a container service, named `myapp`, for Express development and bootstraps a new Express application in the application directory. You can use your favorite IDE for developing the application.

> **Note**
>
> If the application directory contained the source code of an existing Express application, the Bitnami Express Development Container would load the existing application instead of bootstrapping a new one.

After the Node application server has been launched in the `myapp` service, visit http://localhost:3000 in your favorite web browser and you'll be greeted by the default Express welcome page.

In addition to the Express Development Container, the [docker-compose.yml](https://raw.githubusercontent.com/bitnami/bitnami-docker-express/master/docker-compose.yml) file also configures a MongoDB&reg; service to serve as the NoSQL database backend of your Express application.

## Executing commands

Commands can be launched inside the `myapp` Express Development Container with `docker-compose` using the [exec](https://docs.docker.com/compose/reference/exec/) command.

> **Note**:
>
> The `exec` command was added to `docker-compose` in release [1.7.0](https://github.com/docker/compose/blob/master/CHANGELOG.md#170-2016-04-13). Please ensure that you're using `docker-compose` version `1.7.0` or higher.

The general structure of the `exec` command is:

```console
$ docker-compose exec <service> <command>
```

, where `<service>` is the name of the container service as described in the `docker-compose.yml` file and `<command>` is the command you want to launch inside the service.

Following are a few examples of launching some commonly used Express development commands inside the `myapp` service container.

- Load the Node.js REPL:

  ```console
  $ docker-compose exec myapp node
  ```

- List installed NPM modules:

  ```console
  $ docker-compose exec myapp npm ls
  ```

- Install a NPM module:

  ```console
  $ docker-compose exec myapp npm install bootstrap --save
  $ docker-compose restart myapp
  ```

## Connecting to Database

Express by default does not require a database connection to work but we provide a running and configured MongoDB&reg; service and an example file `config/mongodb.js` with some insights for how to connect to it.

You can use [Mongoose](http://mongoosejs.com/) ODM in your application to model your application data.

## Going to Production

The Express Development Container generates a Dockerfile in your working directory. This can be used to create a production-ready container image consisting of your application code and its dependencies.

1. Build your Docker image

  ```console
  $ docker build -t myregistry/myapp:1.0.0
  ```

2. Push to an image registry

  ```console
  $ docker push myregistry/myapp:1.0.0
  ```

3. Update orchestration files to reference the pushed image

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-express/issues/new). For us to provide better support, be sure to include the following information in your issue:

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
