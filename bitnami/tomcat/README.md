# What is Tomcat?

> [Apache Tomcat](http://tomcat.apache.org), often referred to as Tomcat, is an open-source web server and servlet container developed by the [Apache Software Foundation (ASF)](https://www.apache.org). Tomcat implements several Java EE specifications including Java Servlet, JavaServer Pages (JSP), Java EL, and WebSocket, and provides a "pure Java" HTTP web server environment for Java code to run in.

# TL;DR

```console
$ docker run --name tomcat bitnami/tomcat:latest
```

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-tomcat/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

You can find the default credentials and available configuration options in the [Environment Variables](#environment-variables) section.

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/tomcat?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy Apache Tomcat in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Apache Tomcat Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/tomcat).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`10`, `10-debian-10`, `10.0.6`, `10.0.6-debian-10-r8` (10/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-tomcat/blob/10.0.6-debian-10-r8/10/debian-10/Dockerfile)
* [`9.0`, `9.0-debian-10`, `9.0.46`, `9.0.46-debian-10-r8`, `latest` (9.0/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-tomcat/blob/9.0.46-debian-10-r8/9.0/debian-10/Dockerfile)
* [`8.5`, `8.5-debian-10`, `8.5.66`, `8.5.66-debian-10-r8` (8.5/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-tomcat/blob/8.5.66-debian-10-r8/8.5/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/tomcat GitHub repo](https://github.com/bitnami/bitnami-docker-tomcat).

# Get this image

The recommended way to get the Bitnami Tomcat Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/tomcat).

```console
$ docker pull bitnami/tomcat:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/tomcat/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/tomcat:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/tomcat:latest 'https://github.com/bitnami/bitnami-docker-tomcat.git#master:9.0/debian-10'
```

# Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami` path. If the mounted directory is empty, it will be initialized on the first run.

```console
$ docker run -v /path/to/tomcat-persistence:/bitnami bitnami/tomcat:latest
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-tomcat/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  tomcat:
  ...
    volumes:
      - /path/to/tomcat-persistence:/bitnami
  ...
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

# Deploying web applications on Tomcat

The `/bitnami/tomcat/data` directory is configured as the Tomcat webapps deployment directory. At this location, you either copy a so-called *exploded web application*, i.e. non-compressed, or a compressed web application resource (`.WAR`) file and it will automatically be deployed by Tomcat.

Additionally a helper symlink `/app` is present that points to the webapps deployment directory which enables us to deploy applications on a running Tomcat instance by simply doing:

```console
$ docker cp /path/to/app.war tomcat:/app
```

In case you want to create a custom image that already contains your application war file, you need to add it to the `/opt/bitnami/tomcat/webapps_default` folder. In the example below we create a forked image with an extra `.war` file.

```Dockerfile
FROM bitnami/tomcat:9.0
COPY sample.war /opt/bitnami/tomcat/webapps_default
```

**Note!**
You can also deploy web applications on a running Tomcat instance using the Tomcat management interface.

**Further Reading:**

  - [Tomcat Web Application Deployment](https://tomcat.apache.org/tomcat-7.0-doc/deployer-howto.html)

# Accessing your Tomcat server from the host

To access your web server from your host machine you can ask Docker to map a random port on your host to port `8080` exposed in the container.

```console
$ docker run --name tomcat -P bitnami/tomcat:latest
```

Run `docker port` to determine the random ports Docker assigned.

```console
$ docker port tomcat
8080/tcp -> 0.0.0.0:32768
```

You can also manually specify the ports you want forwarded from your host to the container.

```console
$ docker run -p 8080:8080 bitnami/tomcat:latest
```

Access your web server in the browser by navigating to [http://localhost:8080](http://localhost:8080/).

# Configuration

## Environment variables

The Tomcat instance can be customized by specifying environment variables on the first run. The following environment values are provided to custom Tomcat:

- `TOMCAT_SHUTDOWN_PORT_NUMBER`: Tomcat shutdown port. Default: **8005**
- `TOMCAT_HTTP_PORT_NUMBER`: Tomcat HTTP port. Default: **8080**
- `TOMCAT_AJP_PORT_NUMBER`: Tomcat AJP port. Default: **8009**
- `TOMCAT_HOME`: Tomcat user's home directory, this will set `user.home`. Default: **/opt/bitnami/tomcat**
- `TOMCAT_USERNAME`: Tomcat user. Default: **user**
- `TOMCAT_PASSWORD`: Tomcat password.
- `TOMCAT_ALLOW_REMOTE_MANAGEMENT`: Allow to connect to manager applications from remote addresses. Valid values are *0* and *1*. Default: **0**
- `JAVA_HOME`: Java home directory.
- `JAVA_OPTS`: Tomcat java settings. Default: `-Djava.awt.headless=true -XX:+UseG1GC -Dfile.encoding=UTF-8 -Duser.home=$TOMCAT_HOME`

### Creating a custom user

By default, a management user named `user` is created and is not assigned a password. Passing the `TOMCAT_PASSWORD` environment variable when running the image for the first time will set the password of this user to the value of `TOMCAT_PASSWORD`.

Additionally you can specify a user name for the management user using the `TOMCAT_USERNAME` environment variable. When not specified, the `TOMCAT_PASSWORD` configuration is applied on the default user (`user`).

### Specifying Environment variables using Docker Compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-tomcat/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  tomcat:
  ...
    environment:
      - TOMCAT_USERNAME=my_user
      - TOMCAT_PASSWORD=my_password
  ...
```

### Specifying Environment variables on the Docker command line

```console
$ docker run --name tomcat \
  -e TOMCAT_USERNAME=my_user \
  -e TOMCAT_PASSWORD=my_password \
  bitnami/tomcat:latest
```

## Configuration files

During the initialization of the container, the default Tomcat configuration files are modified with the basic options defined through [environment variables](#environment-variables). If you want to add more specific configuration options, you can always mount your own configuration files under `/opt/bitnami/tomcat/conf/` to override the existing ones. Please note that those files should be writable by the system user of the container.

```console
$ docker run --name tomcat -v /path/to/config/server.xml:/opt/bitnami/tomcat/conf/server.xml bitnami/tomcat:latest
```

or using Docker Compose:

```yaml
services:
  tomcat:
  ...
    volumes:
      - /path/to/config/server.xml:/opt/bitnami/tomcat/conf/server.xml
  ...
```

Refer to the [Tomcat configuration](https://tomcat.apache.org/tomcat-7.0-doc/config/index.html) manual for the complete list of configuration options.

# Logging

The Bitnami Tomcat Docker image sends the container logs to the `stdout`. To view the logs:

```console
$ docker logs tomcat
```

or using Docker Compose:

```console
$ docker-compose logs tomcat
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of Tomcat, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```console
$ docker pull bitnami/tomcat:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/tomcat:latest`.

### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
$ docker stop tomcat
```

or using Docker Compose:

```console
$ docker-compose stop tomcat
```

Next, take a snapshot of the persistent volume `/path/to/tomcat-persistence` using:

```console
$ rsync -a /path/to/tomcat-persistence /path/to/tomcat-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

### Step 3: Remove the currently running container

```console
$ docker rm -v tomcat
```

or using Docker Compose:

```console
$ docker-compose rm -v tomcat
```

### Step 4: Run the new image

Re-create your container from the new image.

```console
$ docker run --name tomcat bitnami/tomcat:latest
```

or using Docker Compose:

```console
$ docker-compose up tomcat
```

# Notable Changes

## Debian: 9.0.26-r0, 8.5.46-r0, 8.0.53-r382, 7.0.96-r50. Oracle: 9.0.24-ol-7-r35, 8.5.45-ol-7-r34, 8.0.53-ol-7-r426, 7.0.96-ol-7-r61

- Decrease the size of the container. The configuration logic is now based on Bash scripts in the `rootfs/` folder.

## 9.0.13-r27 , 8.5.35-r26, 8.0.53-r131 & 7.0.92-r20

- The Tomcat container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the Tomcat daemon was started as the `tomcat` user. From now on, both the container and the Tomcat daemon run as user `1001`. As a consequence, the data directory must be writable by that user. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

## 8.0.35-r3

- `TOMCAT_USER` parameter has been renamed to `TOMCAT_USERNAME`.

## 8.0.35-r0

- All volumes have been merged at `/bitnami/tomcat`. Now you only need to mount a single volume at `/bitnami/tomcat` for persistence.
- The logs are always sent to the `stdout` and are no longer collected in the volume.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-tomcat/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-tomcat/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-tomcat/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

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
