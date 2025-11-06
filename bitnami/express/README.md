# Bitnami Secure Image for Express

## What is Express?

> Express is a minimal and unopinionated Node.js web application framework.

[Overview of Express](https://expressjs.com/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

### Local workspace

```console
mkdir ~/myapp && cd ~/myapp
docker run --name express -v ${PWD}/my-project:/app bitnami/express:latest
```

**Warning**: This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options for the [MongoDB&reg; container](https://github.com/bitnami/containers/blob/main/bitnami/mongodb#readme) for a more secure deployment.

## Why use Bitnami Secure Images?

Those are hardened, minimal CVE images built and maintained by Bitnami. Bitnami Secure Images are based on the cloud-optimized, security-hardened enterprise [OS Photon Linux](https://vmware.github.io/photon/). Why choose BSI images?

- Hardened secure images of popular open source software with Near-Zero Vulnerabilities
- Vulnerability Triage & Prioritization with VEX Statements, KEV and EPSS Scores
- Compliance focus with FIPS, STIG, and air-gap options, including secure bill of materials (SBOM)
- Software supply chain provenance attestation through in-toto
- First class support for the internet’s favorite Helm charts

Each image comes with valuable security metadata. You can view the metadata in [our public catalog here](https://app-catalog.vmware.com/bitnami/apps). Note: Some data is only available with [commercial subscriptions to BSI](https://bitnami.com/).

![Alt text](https://github.com/bitnami/containers/blob/main/BSI%20UI%201.png?raw=true "Application details")
![Alt text](https://github.com/bitnami/containers/blob/main/BSI%20UI%202.png?raw=true "Packaging report")

If you are looking for our previous generation of images based on Debian Linux, please see the [Bitnami Legacy registry](https://hub.docker.com/u/bitnamilegacy).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

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
curl -LO https://raw.githubusercontent.com/bitnami/containers/main/bitnami/express/docker-compose.yml
```

Finally launch the Express application development environment using:

```console
docker-compose up
```

Among other things, the above command creates a container service, named `myapp`, for Express development and bootstraps a new Express application in the application directory. You can use your favorite IDE for developing the application.

> **Note**
>
> If the application directory contained the source code of an existing Express application, the Bitnami Express Development Container would load the existing application instead of bootstrapping a new one.

After the Node application server has been launched in the `myapp` service, visit `http://localhost:3000` in your favorite web browser and you'll be greeted by the default Express welcome page.

In addition to the Express Development Container, the [docker-compose.yml](https://raw.githubusercontent.com/bitnami/containers/main/bitnami/express/docker-compose.yml) file also configures a MongoDB&reg; service to serve as the NoSQL database backend of your Express application.

## Environment variables

### Customizable environment variables

| Name                                              | Description                         | Default Value |
|---------------------------------------------------|-------------------------------------|---------------|
| `EXPRESS_SKIP_DATABASE_WAIT`                      | Skip waiting for database.          | `no`          |
| `EXPRESS_SKIP_DATABASE_MIGRATE`                   | Skip database migration.            | `no`          |
| `EXPRESS_SKIP_SAMPLE_CODE`                        | Skip copying sample code.           | `no`          |
| `EXPRESS_SKIP_NPM_INSTALL`                        | Skip installation of NPM modules.   | `no`          |
| `EXPRESS_SKIP_BOWER_INSTALL`                      | Skip installation of Bower modules. | `no`          |
| `EXPRESS_DATABASE_TYPE`                           | Database server type.               | `nil`         |
| `EXPRESS_DATABASE_HOST`                           | Database server host.               | `nil`         |
| `EXPRESS_DATABASE_PORT_NUMBER`                    | Database server port number.        | `nil`         |
| `EXPRESS_DEFAULT_MARIADB_DATABASE_PORT_NUMBER`    | Default MariaDB database port.      | `3306`        |
| `EXPRESS_DEFAULT_MONGODB_DATABASE_PORT_NUMBER`    | Default MongoDB database port.      | `27017`       |
| `EXPRESS_DEFAULT_MYSQL_DATABASE_PORT_NUMBER`      | Default MySQL database port.        | `3306`        |
| `EXPRESS_DEFAULT_POSTGRESQL_DATABASE_PORT_NUMBER` | Default PostgreSQL database port.   | `5432`        |

### Read-only environment variables

### FIPS configuration in Bitnami Secure Images

The Bitnami Express Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Executing commands

Commands can be launched inside the `myapp` Express Development Container with `docker-compose` using the [exec](https://docs.docker.com/compose/reference/exec/) command.

> **Note**:
>
> The `exec` command was added to `docker-compose` in release [1.7.0](https://github.com/docker/compose/blob/master/CHANGELOG.md#170-2016-04-13). Please ensure that you're using `docker-compose` version `1.7.0` or higher.

The general structure of the `exec` command is:

```console
docker-compose exec <service> <command>
```

, where `<service>` is the name of the container service as described in the `docker-compose.yml` file and `<command>` is the command you want to launch inside the service.

Following are a few examples of launching some commonly used Express development commands inside the `myapp` service container.

- Load the Node.js REPL:

  ```console
  docker-compose exec myapp node
  ```

- List installed NPM modules:

  ```console
  docker-compose exec myapp npm ls
  ```

- Install a NPM module:

  ```console
  docker-compose exec myapp npm install bootstrap --save
  docker-compose restart myapp
  ```

## Connecting to Database

Express by default does not require a database connection to work but we provide a running and configured MongoDB&reg; service and an example file `config/mongodb.js` with some insights for how to connect to it.

You can use [Mongoose](http://mongoosejs.com/) ODM in your application to model your application data.

## Going to Production

The Express Development Container generates a Dockerfile in your working directory. This can be used to create a production-ready container image consisting of your application code and its dependencies.

1. Build your Docker image

    ```console
    docker build -t myregistry/myapp:1.0.0
    ```

2. Push to an image registry

   ```console
   docker push myregistry/myapp:1.0.0
   ```

3. Update orchestration files to reference the pushed image

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes.

If you detect any issue in the `docker-compose.yaml` file, feel free to report it or contribute with a fix by following our [Contributing Guidelines](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md).

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/containers/issues/new). Be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

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
