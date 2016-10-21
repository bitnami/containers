[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-express/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-express/tree/master)
[![Docker Hub Automated Build](http://container.checkforupdates.com/badges/bitnami/express)](https://hub.docker.com/r/bitnami/express/)

# Bitnami Express Development Container

## TL;DR;

### Local workspace

```bash
$ mkdir ~/myapp && cd ~/myapp
$ curl -LO https://raw.githubusercontent.com/bitnami/bitnami-docker-express/master/docker-compose.yml
$ docker-compose up
```

### Eclipse Che workspace

Launch a on-demand Express development workspace in Eclipse Che by clicking the link below:

[![Express Development Workspace](http://beta.codenvy.com/factory/resources/codenvy-contribute.svg)](https://beta.codenvy.com/f/?url=https%3A%2F%2Fgithub.com%2Fbitnami%2Fbitnami-docker-express%2Ftree%2Fche)

You can find the configuration files used on the previous link in the [Che branch](https://github.com/bitnami/bitnami-docker-express/tree/che). For more information about Eclipse Che workspaces check the [official documentation](https://eclipse-che.readme.io/docs/introduction).

## Introduction

[Express.js](http://expressjs.org/), or simply Express, is a web application framework for [Node.js](https://nodejs.org), released as free and open-source software under the [MIT License](https://github.com/nodejs/node/blob/master/LICENSE).

The Bitnami Express Development Container has been carefully engineered to provide you and your team with a highly reproducible Express development environment. We hope you find the Bitnami Express Development Container useful in your quest for world domination. Happy hacking!

[Learn more about Bitnami Development Containers.](https://docs.bitnami.com/containers/how-to/use-bitnami-development-containers/)

## Getting started

The quickest way to get started with the Bitnami Express Development Container is using [docker-compose](https://docs.docker.com/compose/).

Begin by creating a directory for your Express application:

```bash
mkdir ~/myapp
cd ~/myapp
```

Download the [docker-compose.yml](https://raw.githubusercontent.com/bitnami/bitnami-docker-express/master/docker-compose.yml) file in the application directory:

```bash
$ curl -LO https://raw.githubusercontent.com/bitnami/bitnami-docker-express/master/docker-compose.yml
```

Finally launch the Express application development environment using:

```bash
$ docker-compose up
```

Among other things, the above command creates a container service, named `myapp`, for Express development and bootstraps a new Express application in the application directory. You can use your favorite IDE for developing the application.

> **Note**
>
> If the application directory contained the source code of an existing Express application, the Bitnami Express Development Container would load the existing application instead of bootstrapping a new one.

After the Node application server has been launched in the `myapp` service, visit http://localhost:3000 in your favorite web browser and you'll be greeted by the default Express welcome page.

In addition to the Express Development Container, the [docker-compose.yml](https://raw.githubusercontent.com/bitnami/bitnami-docker-express/master/docker-compose.yml) file also configures a MongoDB service to serve as the NoSQL database backend of your Express application.

## Executing commands

Commands can be launched inside the `myapp` Express Development Container with `docker-compose` using the [exec](https://docs.docker.com/compose/reference/exec/) command.

> **Note**:
>
> The `exec` command was added to `docker-compose` in release [1.7.0](https://github.com/docker/compose/blob/master/CHANGELOG.md#170-2016-04-13). Please ensure that you're using `docker-compose` version `1.7.0` or higher.

The general structure of the `exec` command is:

```bash
$ docker-compose exec <service> <command>
```

, where `<service>` is the name of the container service as described in the `docker-compose.yml` file and `<command>` is the command you want to launch inside the service.

Following are a few examples of launching some commonly used Express development commands inside the `myapp` service container.

- Load the Node.js REPL:

  ```bash
  $ docker-compose exec myapp node
  ```

- List installed NPM modules:

  ```bash
  $ docker-compose exec myapp npm ls
  ```

- Install a NPM module:

  ```bash
  $ docker-compose exec myapp npm install bootstrap --save
  $ docker-compose restart myapp
  ```

## Connecting to Database

Express by default does not require a database connection to work but we provide a running and configured MongoDB service and an example file `config/mongodb.js` with some insights for how to connect to it.

You can use [Mongoose](http://mongoosejs.com/) ODM in your application to model your application data.

## Issues

If you encountered a problem running this container, you can file an [issue](../../issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version (`uname -a`)
- Docker version (`docker version`)
- Docker info (`docker info`)
- Docker image version (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- Steps to reproduce the issue.

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

