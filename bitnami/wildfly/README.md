# What is WildFly?

> [WildFly](http://wildfly.org), formerly known as JBoss AS, or simply JBoss, is an application server authored by JBoss, now developed by Red Hat. WildFly is written in Java, and implements the Java Platform, Enterprise Edition (Java EE) specification.

# TLDR

```console
$ docker run --name wildfly bitnami/wildfly:latest
```

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-wildfly/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DTC)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/wildfly?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy WildFly in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami WildFly Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/wildfly).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`20-debian-10`, `20.0.0-debian-10-r3`, `20`, `20.0.0`, `latest` (20/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-wildfly/blob/20.0.0-debian-10-r3/20/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/wildfly GitHub repo](https://github.com/bitnami/bitnami-docker-wildfly).

# Get this image

The recommended way to get the Bitnami Wildfly Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/wildfly).

```console
$ docker pull bitnami/wildfly:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/wildfly/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/wildfly:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/wildfly:latest 'https://github.com/bitnami/bitnami-docker-wildfly.git#master:20/debian-10'
```

# Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami` path. If the mounted directory is empty, it will be initialized on the first run.

```console
$ docker run -p 8080:8080 -p 9990:9990 \
    -v /path/to/wildfly-persistence:/bitnami \
    bitnami/wildfly:latest
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-wildfly/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  wildfly:
  ...
    volumes:
      - /path/to/wildfly-persistence:/bitnami
  ...
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

# Deploying web applications on Wildfly

The `/bitnami/wildfly/data` directory is configured as the Wildfly webapps deployment directory. At this location, you either copy a so-called *exploded web application*, i.e. non-compressed, or a compressed web application resource (`.WAR`) file and it will automatically be deployed by Wildfly.

Additionally a helper symlink `/app` is present that points to the webapps deployment directory which enables us to deploy applications on a running Wildfly instance by simply doing:

```console
$ docker cp /path/to/app.war wildfly:/app
```

**Note!**
You can also deploy web applications on a running Wildfly instance using the Wildfly management interface.

# Accessing your Wildfly server from the host

The image exposes the application server on port `8080` and the management console on port `9990`. To access your web server from your host machine you can ask Docker to map random ports on your host to the ports `8080` and `9990` of the container.

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

# Accessing the command line interface

The command line management tool `jboss-cli.sh` allows a user to connect to the Wildfly server and execute management operations available through the de-typed management model.

The Bitnami Wildfly Docker Image ships the `jboss-cli.sh` client and can be launched by specifying the command while launching the container.

## Connecting a client container to the Wildfly server container

### Step 1: Create a network

```console
$ docker network create wildfly-tier --driver bridge
```

### Step 2: Launch the Wildfly server instance

Use the `--network wildfly-tier` argument to the `docker run` command to attach the Wildfly container to the `wildfly-tier` network.

```console
$ docker run -d --name wildfly-server \
    --network wildfly-tier \
    bitnami/wildfly:latest
```

### Step 3: Launch your Wildfly client instance

Finally we create a new container instance to launch the Wildfly client and connect to the server created in the previous step:

```console
$ docker run -it --rm \
    --network wildfly-tier \
    bitnami/wildfly:latest \
      jboss-cli.sh --controller=wildfly-server:9990  --connect
```

**Note!**
You can also run the client in the same container as the server using the Docker [exec](https://docs.docker.com/reference/commandline/cli/#exec) command.

```console
$ docker exec -it wildfly-server \
  jboss-cli.sh --controller=wildfly-server:9990 --connect
```

# Configuration

## Creating a custom user

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

## Configuration files

The image looks for configurations in `/bitnami/wildfly/conf/`. As mentioned in [Persisting your application](#persisting-your-application) you can mount a volume at `/bitnami` and copy/edit the configurations in the `/path/to/wildfly-persistence/wildfly/conf/`. The default configurations will be populated to the `conf/` directory if it's empty.

### Step 1: Run the Wildfly image

Run the Wildfly image, mounting a directory from your host.

```console
$ docker run --name wildfly -v /path/to/wildfly-persistence:/bitnami bitnami/wildfly:latest
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-wildfly/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  wildfly:
  ...
    volumes:
      - /path/to/wildfly-persistence:/bitnami
  ...
```

### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

eg.

```console
$ vim /path/to/wildfly-persistence/wildfly/conf/standalone.xml
```

### Step 3: Restart Wildfly

After changing the configuration, restart your Wildfly container for the changes to take effect.

```console
$ docker restart wildfly
```

or using Docker Compose:

```console
$ docker-compose restart wildfly
```

Refer to the [configuration](https://docs.jboss.org/author/display/WFLY9/General+configuration+concepts) manual for the complete list of configuration options.

# Logging

The Bitnami Wildfly Docker image sends the container logs to the `stdout`. To view the logs:

```console
$ docker logs wildfly
```

or using Docker Compose:

```console
$ docker-compose logs wildfly
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of Wildfly, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```console
$ docker pull bitnami/wildfly:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/wildfly:latest`.

### Step 2: Stop and backup the currently running container

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

### Step 3: Remove the currently running container

```console
$ docker rm -v wildfly
```

or using Docker Compose:

```console
$ docker-compose rm -v wildfly
```

### Step 4: Run the new image

Re-create your container from the new image.

```console
$ docker run --name wildfly bitnami/wildfly:latest
```

or using Docker Compose:

```console
$ docker-compose up wildfly
```

# Notable Changes

## 14.0.1-r75

- The Wildfly container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the Wildfly daemon was started as the `wildfly` user. From now on, both the container and the Wildfly daemon run as user `1001`. As a consequence, the data directory must be writable by that user. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

## 10.0.0-r3

- `WILDFLY_USER` parameter has been renamed to `WILDFLY_USERNAME`.

## 10.0.0-r0

- All volumes have been merged at `/bitnami/wildfly`. Now you only need to mount a single volume at `/bitnami/wildfly` for persistence.
- The logs are always sent to the `stdout` and are no longer collected in the volume.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-wildfly/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-wildfly/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-wildfly/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright (c) 2015-2020 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
