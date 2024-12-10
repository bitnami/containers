# Bitnami package for NATS

## What is NATS?

> NATS is an open source, lightweight and high-performance messaging system. It is ideal for distributed systems and supports modern cloud architectures and pub-sub, request-reply and queuing models.

[Overview of NATS](https://nats.io/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run -it --name nats bitnami/nats:latest
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use NATS in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## How to deploy NATS in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami NATS Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/nats).

Bitnami containers can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Prerequisites

To run this application you need [Docker Engine](https://www.docker.com/products/docker-engine) >= `1.10.0`. [Docker Compose](https://docs.docker.com/compose/) is recommended with a version `1.6.0` or later.

## Get this image

The recommended way to get the Bitnami NATS Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/nats).

```console
docker pull bitnami/nats:latest
```

To use a specific version, you can pull a versioned tag. You can view the
[list of available versions](https://hub.docker.com/r/bitnami/nats/tags/)
in the Docker Hub Registry.

```console
docker pull bitnami/nats:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a NATS server running inside a container can easily be accessed by your application containers using a NATS client.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

In this example, we will create a NATS client instance that will connect to the server instance that is running on the same docker network as the client.

#### Step 1: Create a network

```console
docker network create app-tier --driver bridge
```

#### Step 2: Launch the NATS server instance

Use the `--network app-tier` argument to the `docker run` command to attach the NATS container to the `app-tier` network.

```console
docker run -d --name nats-server \
    --network app-tier \
    --publish 4222:4222 \
    --publish 6222:6222 \
    --publish 8222:8222 \
    bitnami/nats:latest
```

#### Step 3: Launch your NATS client instance

You can create a small script which downloads, installs and uses the [NATS Golang client](https://github.com/nats-io/go-nats).

There are some examples available to use that client. For instance, write the script below and save it as *nats-pub.sh* to use the publishing example:

```console
##!/bin/bash

go get github.com/nats-io/go-nats
go build /go/src/github.com/nats-io/go-nats/examples/nats-pub.go
./nats-pub -s nats://nats-server:4222 "$1" "$2"
```

Then, you can use the script to create a client instance as shown below:

```console
docker run -it --rm \
    --network app-tier \
    --volume /path/to/your/workspace:/go
    golang ./nats-pub.sh foo bar
```

### Using a Docker Compose file

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `app-tier`. In this example we assume that you want to connect to the NATS server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge

services:
  nats:
    image: 'bitnami/nats:latest'
    ports:
      - 4222:4222
      - 6222:6222
      - 8222:8222
    networks:
      - app-tier
  myapp:
    image: 'YOUR_APPLICATION_IMAGE'
    networks:
      - app-tier
```

> **IMPORTANT**:
>
> 1. Please update the `YOUR_APPLICATION_IMAGE` placeholder in the above snippet with your application image
> 2. In your application container, use the hostname `nats` to connect to the NATS server

Launch the containers using:

```console
docker-compose up -d
```

## Configuration

### Environment variables

#### Customizable environment variables

| Name                       | Description                                                                                        | Default Value                            |
|----------------------------|----------------------------------------------------------------------------------------------------|------------------------------------------|
| `NATS_BIND_ADDRESS`        | NATS bind address.                                                                                 | `$NATS_DEFAULT_BIND_ADDRESS`             |
| `NATS_CLIENT_PORT_NUMBER`  | NATS CLIENT port number.                                                                           | `$NATS_DEFAULT_CLIENT_PORT_NUMBER`       |
| `NATS_HTTP_PORT_NUMBER`    | NATS HTTP port number.                                                                             | `$NATS_DEFAULT_HTTP_PORT_NUMBER`         |
| `NATS_HTTPS_PORT_NUMBER`   | NATS HTTPS port number.                                                                            | `$NATS_DEFAULT_HTTPS_PORT_NUMBER`        |
| `NATS_CLUSTER_PORT_NUMBER` | NATS CLUSTER port number.                                                                          | `$NATS_DEFAULT_CLUSTER_PORT_NUMBER`      |
| `NATS_FILENAME`            | Pefix to use for NATS files (e.g. the PID file would be formed using "${NATS_FILENAME}.pid").      | `nats-server`                            |
| `NATS_CONF_FILE`           | Path to the NATS conf file.                                                                        | `${NATS_CONF_DIR}/${NATS_FILENAME}.conf` |
| `NATS_LOG_FILE`            | Path to the NATS log file.                                                                         | `${NATS_LOGS_DIR}/${NATS_FILENAME}.log`  |
| `NATS_PID_FILE`            | Path to the NATS pid file.                                                                         | `${NATS_TMP_DIR}/${NATS_FILENAME}.pid`   |
| `NATS_ENABLE_AUTH`         | Enable Authentication.                                                                             | `no`                                     |
| `NATS_USERNAME`            | Username credential for client connections.                                                        | `nats`                                   |
| `NATS_PASSWORD`            | Password credential for client connections.                                                        | `nil`                                    |
| `NATS_TOKEN`               | Auth token for client connections.                                                                 | `nil`                                    |
| `NATS_ENABLE_TLS`          | Enable TLS.                                                                                        | `no`                                     |
| `NATS_TLS_CRT_FILENAME`    | TLS certificate filename.                                                                          | `${NATS_FILENAME}.crt`                   |
| `NATS_TLS_KEY_FILENAME`    | TLS key filename.                                                                                  | `${NATS_FILENAME}.key`                   |
| `NATS_ENABLE_CLUSTER`      | Enable Cluster configuration.                                                                      | `no`                                     |
| `NATS_CLUSTER_USERNAME`    | Username credential for route connections.                                                         | `nats`                                   |
| `NATS_CLUSTER_PASSWORD`    | Password credential for route connections.                                                         | `nil`                                    |
| `NATS_CLUSTER_TOKEN`       | Auth token for route connections.                                                                  | `nil`                                    |
| `NATS_CLUSTER_ROUTES`      | Comma-separated list of routes to solicit and connect.                                             | `nil`                                    |
| `NATS_CLUSTER_SEED_NODE`   | Node to use as seed server for routes announcement.                                                | `nil`                                    |
| `NATS_EXTRA_ARGS`          | Additional command line arguments passed while starting NATS (e.g., `-js` for enabling JetStream). | `nil`                                    |

#### Read-only environment variables

| Name                               | Description                                                                                    | Value                           |
|------------------------------------|------------------------------------------------------------------------------------------------|---------------------------------|
| `NATS_BASE_DIR`                    | NATS installation directory.                                                                   | `${BITNAMI_ROOT_DIR}/nats`      |
| `NATS_BIN_DIR`                     | NATS directory for binaries.                                                                   | `${NATS_BASE_DIR}/bin`          |
| `NATS_CONF_DIR`                    | NATS directory for configuration files.                                                        | `${NATS_BASE_DIR}/conf`         |
| `NATS_DEFAULT_CONF_DIR`            | NATS default directory for configuration files.                                                | `${NATS_BASE_DIR}/conf.default` |
| `NATS_LOGS_DIR`                    | NATS directory for log files.                                                                  | `${NATS_BASE_DIR}/logs`         |
| `NATS_TMP_DIR`                     | NATS directory for temporary files.                                                            | `${NATS_BASE_DIR}/tmp`          |
| `NATS_VOLUME_DIR`                  | NATS persistence base directory.                                                               | `${BITNAMI_VOLUME_DIR}/nats`    |
| `NATS_DATA_DIR`                    | NATS directory for data.                                                                       | `${NATS_VOLUME_DIR}/data`       |
| `NATS_MOUNTED_CONF_DIR`            | Directory for including custom configuration files (that override the default generated ones). | `${NATS_VOLUME_DIR}/conf`       |
| `NATS_INITSCRIPTS_DIR`             | Path to NATS init scripts directory                                                            | `/docker-entrypoint-initdb.d`   |
| `NATS_DAEMON_USER`                 | NATS system user.                                                                              | `nats`                          |
| `NATS_DAEMON_GROUP`                | NATS system group.                                                                             | `nats`                          |
| `NATS_DEFAULT_BIND_ADDRESS`        | Default NATS bind address to enable at build time.                                             | `0.0.0.0`                       |
| `NATS_DEFAULT_CLIENT_PORT_NUMBER`  | Default NATS CLIENT port number to enable at build time.                                       | `4222`                          |
| `NATS_DEFAULT_HTTP_PORT_NUMBER`    | Default NATS HTTP port number to enable at build time.                                         | `8222`                          |
| `NATS_DEFAULT_HTTPS_PORT_NUMBER`   | Default NATS HTTPS port number to enable at build time.                                        | `8443`                          |
| `NATS_DEFAULT_CLUSTER_PORT_NUMBER` | Default NATS CLUSTER port number to enable at build time.                                      | `6222`                          |

When you start the NATS image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. If you want to add a new environment variable:

* For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/nats/docker-compose.yml) file present in this repository:

```yaml
nats:
  ...
  environment:
    - NATS_ENABLE_AUTH=yes
    - NATS_PASSWORD=my_password
  ...
```

* For manual execution add a `--env` option with each variable and value:

  ```console
  docker run -d --name nats -p 4222:4222 -p 6222:6222 -p 8222:8222 \
    --env NATS_ENABLE_AUTH=yes \
    --env NATS_PASSWORD=my_password \
    bitnami/nats:latest
  ```

### Full configuration

The image looks for custom configuration files in the `/bitnami/nats/conf/` directory. Find very simple examples below.

#### Using the Docker Command Line

```console
docker run -d --name nats -p 4222:4222 -p 6222:6222 -p 8222:8222 \
  --volume /path/to/nats-server.conf:/bitnami/nats/conf/nats-server.conf:ro \
  bitnami/nats:latest
```

#### Deploying a Docker Compose file

Modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/nats/docker-compose.yml) file present in this repository as follows:

```diff
...
services:
  nats:
    ...
+   volumes:
+     - /path/to/nats-server.conf:/bitnami/nats/conf/nats-server.conf:ro
```

After that, your custom configuration will be taken into account to start the NATS node. Find more information about how to create your own configuration file on this [link](https://nats-io.github.io/docs/nats_server/configuration.html)

### Further documentation

For further documentation, please check [NATS documentation](https://docs.nats.io/)

## Notable Changes

### 2.6.4-debian-10-r14

* The configuration logic is now based on Bash scripts in the *rootfs/* folder.

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/nats).

If you detect any issue in the `docker-compose.yaml` file, feel free to report it or contribute with a fix by following our [Contributing Guidelines](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md).

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/containers/issues/new/choose). For us to provide better support, be sure to fill the issue template.

## License

Copyright &copy; 2024 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
