# What is WildFly?

> [WildFly](http://wildfly.org), formerly known as JBoss AS, or simply JBoss, is an application server authored by JBoss, now developed by Red Hat. WildFly is written in Java, and implements the Java Platform, Enterprise Edition (Java EE) specification.

## TLDR

```console
$ docker run --name wildfly bitnami/wildfly:latest
```

### Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-wildfly/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.

> This [CVE scan report](https://quay.io/repository/bitnami/wildfly?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

## How to deploy WildFly in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami WildFly Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/wildfly).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`24`, `24-debian-10`, `24.0.0`, `24.0.0-debian-10-r6`, `latest` (24/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-wildfly/blob/24.0.0-debian-10-r6/24/debian-10/Dockerfile)
* [`23`, `23-debian-10`, `23.0.2`, `23.0.2-debian-10-r53` (23/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-wildfly/blob/23.0.2-debian-10-r53/23/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/wildfly GitHub repo](https://github.com/bitnami/bitnami-docker-wildfly).

## Get this image

The recommended way to get the Bitnami WildFly Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/wildfly).

```console
$ docker pull bitnami/wildfly:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/wildfly/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/wildfly:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/wildfly:latest 'https://github.com/bitnami/bitnami-docker-wildfly.git#master:24/debian-10'
```

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/wildfly` path. If the mounted directory is empty, it will be initialized on the first run.

```console
$ docker run -p 8080:8080 -p 9990:9990 \
    -v /path/to/wildfly-persistence:/bitnami/wildfly \
    bitnami/wildfly:latest
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-wildfly/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  wildfly:
  ...
    volumes:
      - /path/to/wildfly-persistence:/bitnami/wildfly
  ...
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

## Deploying web applications on WildFly

The Bitnami WildFly image launches WildFLy in standalone mode. Therefore, you can deploy your web applications by placing your compressed web application resource (`.WAR`) files there at `/opt/bitnami/wildfly/standalone/` directory.

Additionally a helper symlink `/app` is present that points to the deployment directory which enables us to deploy applications on a running WildFly instance by simply doing:

```console
$ docker cp /path/to/app.war wildfly:/app
```

Find more information about the directory structue at [WildFly official documentation](https://docs.wildfly.org/23/Getting_Started_Guide.html#standalone-directory-structure)

> NOTE: You can also deploy web applications on a running WildFly instance using the WildFly management interface.

## Accessing your WildFly server from the host

The Bitnami WildFly image exposes the application server on port `8080` and the management console on port `9990`. To access your web server from your host machine you can ask Docker to map random ports on your host to the ports `8080` and `9990` of the container.

```console
$ docker run --name wildfly -P bitnami/wildfly:latest
```

Run `docker port` to determine the random ports Docker assigned.

```console
$ docker port wildfly
8080/tcp -> 0.0.0.0:32775
9990/tcp -> 0.0.0.0:32774
```

You can also manually specify the ports you want forwarded from your host to the container.

```console
$ docker run -p 8080:8080 -p 9990:9990 bitnami/wildfly:latest
```

Access your web server in the browser by navigating to [http://localhost:8080](http://localhost:8080/) to access the application server and [http://localhost:9990/console](http://localhost:9990/console/) to access the management console.

> NOTE: the management console is configured by default to listen exclusively in the localhost interface for security reasons. To allow access from different hosts, you can use the `WILDFLY_MANAGEMENT_LISTEN_ADDRESS` environment variable to set a different listen address (this is not recommended for production environments).

## Accessing the command line interface

The command line management tool `jboss-cli.sh` allows a user to connect to the WildFly server and execute management operations available through the de-typed management model. The Bitnami WildFly image ships the `jboss-cli.sh` client and can be launched by specifying the command while launching the container.

### Connecting a client container to the WildFly server container

#### Step 1: Create a network

```console
$ docker network create wildfly-tier --driver bridge
```

#### Step 2: Launch the WildFly server instance

Use the `--network wildfly-tier` argument to the `docker run` command to attach the WildFly container to the `wildfly-tier` network.

```console
$ docker run -d --name wildfly-server \
    --network wildfly-tier \
    bitnami/wildfly:latest
```

#### Step 3: Launch your WildFly client instance

Finally we create a new container instance to launch the WildFly client and connect to the server created in the previous step:

```console
$ docker run -it --rm \
    --network wildfly-tier \
    bitnami/wildfly:latest \
    jboss-cli.sh --controller=wildfly-server:9990 --connect
```

You can also run the client in the same container as the server using the Docker [exec](https://docs.docker.com/reference/commandline/cli/#exec) command.

```console
$ docker exec -it wildfly-server \
    jboss-cli.sh --controller=wildfly-server:9990 --connect
```

## Configuration

### Creating a custom user

By default, a management user named `user` is created with the default password `bitnami`. Passing the `WILDFLY_PASSWORD` environment variable when running the image for the first time will set the password of this user to the value of `WILDFLY_PASSWORD`.

Additionally you can specify a user name for the management user using the `WILDFLY_USERNAME` environment variable. When not specified, the `WILDFLY_PASSWORD` configuration is applied on the default user (`user`).

```console
$ docker run --name wildfly \
    -e WILDFLY_USERNAME=my_user \
    -e WILDFLY_PASSWORD=my_password \
    bitnami/wildfly:latest
```

or modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-wildfly/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  wildfly:
  ...
    environment:
      - WILDFLY_USERNAME=my_user
      - WILDFLY_PASSWORD=my_password
  ...
```

### Full configuration

The image looks for configurations (e.g. `standalone.xml`) in the `/bitnami/wildfly/configuration/` directory, this directory can be changed by setting the `WILDFLY_MOUNTED_CONF_DIR` environment variable.

```console
$ docker run --name wildfly \
    -v /path/to/standalone.xml:/bitnami/wildfly/configuration/standalone.xml \
    bitnami/wildfly:latest
```

Alternatively, modify the [docker-compose.yml](https://github.com/bitnami/bitnami-docker-wildfly/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  wildfly:
    ...
    volumes:
      - /path/to/standalone.xml:/bitnami/wildfly/configuration/standalone.xml:ro
    ...
```

After that, your changes will be taken into account in the server's behaviour.

## Logging

The Bitnami WildFly Docker image sends the container logs to the `stdout`. To view the logs:

```console
$ docker logs wildfly
```

or using Docker Compose:

```console
$ docker-compose logs wildfly
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of WildFly, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
$ docker pull bitnami/wildfly:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/wildfly:latest`.

#### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
$ docker stop wildfly
```

or using Docker Compose:

```console
$ docker-compose stop wildfly
```

Next, take a snapshot of the persistent volume `/path/to/wildfly-persistence` using:

```console
$ rsync -a /path/to/wildfly-persistence /path/to/wildfly-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

#### Step 3: Remove the currently running container

```console
$ docker rm -v wildfly
```

or using Docker Compose:

```console
$ docker-compose rm -v wildfly
```

#### Step 4: Run the new image

Re-create your container from the new image.

```console
$ docker run --name wildfly bitnami/wildfly:latest
```

or using Docker Compose:

```console
$ docker-compose up wildfly
```

## Notable Changes

### 22.0.1-debian-10-r68 and 23.0.1-debian-10-r8 release

- The size of the container image has been decreased.
- The configuration logic is now based on Bash scripts in the *rootfs/* folder.
- The configuration is no longer persisted, instead it's adapted based on environment variables during the container initialization on every container restart. You can also mount custom configuration files and skip the configuration based on environment variables as it's detailed in [this section](#full-configuration).

Consequences:

- Backwards compatibility should be possible, but it is highly recommended to backup your application data before upgrading.

### 14.0.1-r75

- The WildFly container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the WildFly daemon was started as the `wildfly` user. From now on, both the container and the WildFly daemon run as user `1001`. As a consequence, the data directory must be writable by that user. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

### 10.0.0-r3

- `WILDFLY_USER` parameter has been renamed to `WILDFLY_USERNAME`.

### 10.0.0-r0

- All volumes have been merged at `/bitnami/wildfly`. Now you only need to mount a single volume at `/bitnami/wildfly` for persistence.
- The logs are always sent to the `stdout` and are no longer collected in the volume.

## Branch Deprecation Notice

Wildfly's branch 23 is no longer maintained by upstream and is now internally tagged as to be deprecated. This branch will no longer be released in our catalog a month after this notice is published, but already released container images will still persist in the registries. Valid to be removed starting on: 07-28-2021

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-wildfly/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-wildfly/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-wildfly/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

## License

Copyright (c) 2015-2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
