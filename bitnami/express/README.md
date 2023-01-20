# Express packaged by Bitnami

## What is Express?

> Express is a minimal and unopinionated Node.js web application framework.

[Overview of Express](https://expressjs.com/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

### Local workspace

```console
$ mkdir ~/myapp && cd ~/myapp
$ curl -LO https://raw.githubusercontent.com/bitnami/containers/main/bitnami/express/docker-compose.yml
$ docker-compose up
```

**Warning**: This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options for the [MongoDB&reg; container](https://github.com/bitnami/containers/blob/main/bitnami/mongodb#readme) for a more secure deployment.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

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

Download the [docker-compose.yml](https://raw.githubusercontent.com/bitnami/containers/main/bitnami/express/docker-compose.yml) file in the application directory:

```console
$ curl -LO https://raw.githubusercontent.com/bitnami/containers/main/bitnami/express/docker-compose.yml
```

Finally launch the Express application development environment using:

```console
$ docker-compose up
```

Among other things, the above command creates a container service, named `myapp`, for Express development and bootstraps a new Express application in the application directory. You can use your favorite IDE for developing the application.

> **Note**
>
> If the application directory contained the source code of an existing Express application, the Bitnami Express Development Container would load the existing application instead of bootstrapping a new one.

After the Node application server has been launched in the `myapp` service, visit `http://localhost:3000` in your favorite web browser and you'll be greeted by the default Express welcome page.

In addition to the Express Development Container, the [docker-compose.yml](https://raw.githubusercontent.com/bitnami/containers/main/bitnami/express/docker-compose.yml) file also configures a MongoDB&reg; service to serve as the NoSQL database backend of your Express application.

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

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/containers/blob/main/bitnami/express/issues/new). Be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

### Community supported solution

Please, note this asset is a community-supported solution. This means that the Bitnami team is not actively working on new features/improvements nor providing support through GitHub Issues. Any new issue will stay open for 20 days to allow the community to contribute, after 15 days without activity the issue will be marked as stale being closed after 5 days.

The Bitnami team will review any PR that is created, feel free to create a PR if you find any issue or want to implement a new feature.

New versions and releases cadence are not going to be affected. Once a new version is released in the upstream project, the Bitnami container image will be updated to use the latest version, supporting the different branches supported by the upstream project as usual.

## License

Copyright &copy; 2023 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
