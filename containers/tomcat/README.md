[![Build Status](http://bitnami-container-builds.bitnamiapp.com/jenkins/buildStatus/icon?job=docker-tomcat)](http://bitnami-container-builds.bitnamiapp.com/jenkins/job/docker-tomcat/)

# What is Tomcat?

> [Apache Tomcat](http://tomcat.apache.org), often referred to as Tomcat, is an open-source web server and servlet container developed by the [Apache Software Foundation (ASF)](https://www.apache.org). Tomcat implements several Java EE specifications including Java Servlet, JavaServer Pages (JSP), Java EL, and WebSocket, and provides a "pure Java" HTTP web server environment for Java code to run in.

# TLDR

```bash
docker run --name tomcat bitnami/tomcat
```

## Docker Compose

```
tomcat:
  image: bitnami/tomcat
```

# Get this image

The recommended way to get the Bitnami tomcat Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/tomcat).

```bash
docker pull bitnami/tomcat:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/tomcat/tags/) in the Docker Hub Registry.

```bash
docker pull bitnami/tomcat:[TAG]
```

If you wish, you can also build the image yourself.

```bash
git clone https://github.com/bitnami/bitnami-docker-tomcat.git
cd bitnami-docker-tomcat
docker build -t bitnami/tomcat .
```

# Deploying web applications on Tomcat

This Tomcat image exposes a volume at `/app`. This path acts as the Tomcat webapps directory. At this location, you either copy a so-called *exploded web application*, i.e non-compressed or a compressed web application resource `.WAR` file and it will automatically be deployed by Tomcat at startup.

**Note!**
You can also deploy web applications on a running Tomcat instance.

```bash
docker run -v /path/to/app:/app bitnami/tomcat
```

or using Docker Compose:

```
tomcat:
  image: bitnami/tomcat
  volumes:
    - /path/to/app:/app
```

**Further Reading:**

  - [Tomcat Web Application Deployment](https://tomcat.apache.org/tomcat-7.0-doc/deployer-howto.html)

# Accessing your Tomcat server from the host

To access your web server from your host machine you can ask Docker to map a random port on your host to port `8080` of the container.

```bash
docker run --name tomcat -P bitnami/tomcat
```

Run `docker port` to determine the random ports Docker assigned.

```bash
$ docker port tomcat
8080/tcp -> 0.0.0.0:32768
```

You can also manually specify the ports you want forwarded from your host to the container.

```bash
docker run -p 8080:8080 bitnami/tomcat
```

Access your web server in the browser by navigating to [http://localhost:8080](http://localhost:8080/).

# Configuration

## Setting the `manager` password on first run

By default, the `manager` user is not assigned a password. To secure your Tomcat server you should assign a password to this user. Passing the `TOMCAT_PASSWORD` environment variable when running the image for the first time will set the password of the `manager` user to the value of `TOMCAT_PASSWORD`.

```bash
docker run --name tomcat -e TOMCAT_PASSWORD=password123 bitnami/tomcat
```

or using Docker Compose:

```
tomcat:
  image: bitnami/tomcat
  environment:
    - TOMCAT_PASSWORD=password123
```

## Configuration files

This image looks for Tomcat configuration files in `/bitnami/tomcat/conf`. You can mount a volume at this location with your own configuration, or the default configuration will be copied to your volume if it is empty.

### Step 1: Run the Tomcat image

Run the Tomcat image, mounting a directory from your host.

```bash
docker run --name tomcat -v /path/to/tomcat/conf:/bitnami/tomcat/conf bitnami/tomcat
```

or using Docker Compose:

```
tomcat:
  image: bitnami/tomcat
  volumes:
    - /path/to/tomcat/conf:/bitnami/tomcat/conf
```

### Step 2: Edit the configuration

Edit the configurations on your host using your favorite editor.

### Step 3: Restart Tomcat

After changing the configuration, restart your Tomcat container for the changes to take effect.

```bash
docker restart tomcat
```

or using Docker Compose:

```bash
docker-compose restart tomcat
```

**Further Reading:**

  - [Tomcat 7 Configuration Reference](https://tomcat.apache.org/tomcat-7.0-doc/config/index.html)

# Logging

The Bitnami Tomcat Docker Image supports two different logging modes: logging to stdout, and logging to a file.

## Logging to stdout

The default behavior is to log to stdout, as Docker expects. These will be collected by Docker, converted to JSON and stored in the host, to be accessible via the `docker logs` command.

```bash
docker logs tomcat
```

or using Docker Compose:

```bash
docker-compose logs tomcat
```

This method of logging has the downside of not being easy to manage. Without an easy way to rotate logs, they could grow exponentially and take up large amounts of disk space on your host.

## Logging to file

To log to file, run the Tomcat image, mounting a directory from your host at `/bitnami/tomcat/logs`. This will instruct the container to send logs to your directory.

```bash
docker run --name tomcat -v /path/to/tomcat/logs:/bitnami/tomcat/logs bitnami/tomcat
```

or using Docker Compose:

```
tomcat:
  image: bitnami/tomcat
  volumes:
    - /path/to/tomcat/logs:/bitnami/tomcat/logs
```

To perform operations (e.g. logrotate) on the logs, mount the same directory in a container designed to operate on log files, such as logstash.

# Maintenance

## Backing up your container

To backup your configuration and logs, follow these simple steps:

### Step 1: Stop the currently running container

```bash
docker stop tomcat
```

or using Docker Compose:

```bash
docker-compose stop tomcat
```

### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```bash
docker run --rm -v /path/to/backups:/backups --volumes-from tomcat busybox \
  cp -a /bitnami/tomcat /backups/latest
```

or using Docker Compose:

```bash
docker run --rm -v /path/to/backups:/backups --volumes-from `docker-compose ps -q tomcat` busybox \
  cp -a /bitnami/tomcat /backups/latest
```

**Note!**
If you only need to backup configuration, you can change the first argument to `cp` to `/bitnami/tomcat/conf`.

## Restoring a backup

Restoring a backup is as simple as mounting the backup as volumes in the container.

```bash
docker run -v /path/to/backups/latest/conf:/bitnami/tomcat/conf \
  -v /path/to/backups/latest/logs:/bitnami/tomcat/logs \
  bitnami/tomcat
```

or using Docker Compose:

```
tomcat:
  image: bitnami/tomcat
  volumes:
    - /path/to/backups/latest/conf:/bitnami/tomcat/conf
    - /path/to/backups/latest/logs:/bitnami/tomcat/logs
```

## Upgrade this image

Bitnami provides up-to-date versions of Tomcat, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
docker pull bitnami/tomcat:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/tomcat:latest`.

### Step 2: Stop and backup the currently running container

Before continuing, you should backup your container's configuration and logs.

Follow the steps on [creating a backup](#backing-up-your-container).

### Step 3: Remove the currently running container

```bash
docker rm -v tomcat
```

or using Docker Compose:

```bash
docker-compose rm -v tomcat
```

### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if
necessary.

```bash
docker run --name tomcat bitnami/tomcat:latest
```

or using Docker Compose:

```bash
docker-compose start tomcat
```

# Testing

This image is tested for expected runtime behavior, using the [Bats](https://github.com/sstephenson/bats) testing framework. You can run the tests on your machine using the `bats` command.

```
bats test.sh
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-tomcat/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-tomcat/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-tomcat/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_APP_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive
information)

# License

Copyright 2015 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
