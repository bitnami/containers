[![Build Status](http://bitnami-container-builds.bitnamiapp.com/jenkins/buildStatus/icon?job=docker-wildfly)](http://bitnami-container-builds.bitnamiapp.com/jenkins/job/docker-wildfly/)

# What is Wildfly?

> [Wildfly](http://wildfly.org), formerly known as JBoss AS, or simply JBoss, is an application server authored by JBoss, now developed by Red Hat. WildFly is written in Java, and implements the Java Platform, Enterprise Edition (Java EE) specification.

# TLDR

```bash
docker run --name wildfly bitnami/wildfly
```

## Docker Compose

```
wildfly:
  image: bitnami/wildfly
```

# Get this image

The recommended way to get the Bitnami wildfly Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/wildfly).

```bash
docker pull bitnami/wildfly:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/wildfly/tags/) in the Docker Hub Registry.

```bash
docker pull bitnami/wildfly:[TAG]
```

If you wish, you can also build the image yourself.

```bash
git clone https://github.com/bitnami/bitnami-docker-wildfly.git
cd bitnami-docker-wildfly
docker build -t bitnami/wildfly .
```

## Operating modes

Wildfly can be booted in two different modes. A *managed domain* allows you to run and manage a multi-server topology. Alternatively, you can run a *standalone server* instance.

By default, the Bitnami Wildfly Docker image boots in the standalone server mode. To boot in the managed domain mode specify `domain.sh` as the first argument while running the image.

```bash
docker run bitnami/wildfly domain.sh
```

or using Docker Compose:

```
wildfly:
  image: bitnami/wildfly
  command: domain.sh
```

**Further Reading:**

  - [Wildfly Operating modes](https://docs.jboss.org/author/display/WFLY9/Operating+modes)

## Command-line options

The simplest way to configure your Wildfly server is to pass custom command-line options when running the image.

```bash
docker run bitnami/wildfly -Dwildfly.as.deployment.ondemand=true
```

or using Docker Compose:

```
wildfly:
  image: bitnami/wildfly
  command: -Dwildfly.as.deployment.ondemand=true
```

> **Note!**: To configure the JVM parameters specify them in the environment variable `JAVA_OPTS` using `-e JAVA_OPTS=<parameters>` while running the Wildfly image.

**Further Reading:**

  - [Wildfly Command line parameters](https://docs.jboss.org/author/display/WFLY9/Command+line+parameters)
  - [Caveats](#caveats)

# Deploying web applications on Wildfly

This Wildfly image exposes a volume at `/app`. In the standalone server mode, this path acts as the Wildfly deployments directory. At this location, you either copy a so-called *exploded web application*, i.e non-compressed or a compressed web application resource `.WAR` file and it will automatically be deployed by Wildfly at startup.

**Note!**
You can also deploy web applications on a running Wildfly instance.

```bash
docker run -v /path/to/app:/app bitnami/wildfly
```

or using Docker Compose:

```
wildfly:
  image: bitnami/wildfly
  volumes:
    - /path/to/app:/app
```

# Accessing your Wildfly server from the host

The image exposes the application server on port `8080` and the management console on port `9990`. To access your web server from your host machine you can ask Docker to map random ports on your host to the ports `8080` and `9990` of the container.

```bash
docker run --name wildfly -P bitnami/wildfly
```

Run `docker port` to determine the random ports Docker assigned.

```bash
$ docker port wildfly
8080/tcp -> 0.0.0.0:32775
9990/tcp -> 0.0.0.0:32774
```

You can also manually specify the ports you want forwarded from your host to the container.

```bash
docker run -p 8080:8080 -p 9990:9990 bitnami/wildfly
```

Access your web server in the browser by navigating to [http://localhost:8080](http://localhost:8080/) to access the application server and [http://localhost:9990](http://localhost:9990/console/) to access the management console.

# Accessing the command line interface

The Command Line Interface (CLI) is a management tool for a managed domain or standalone server. It allows a user to connect to the domain controller or a standalone server and execute management operations available through the de-typed management model.

The Bitnami Wildfly Docker Image ships the `jboss-cli.sh` client, but by default it will start the standalone server. To start the client instead, we can override the default command Docker runs by stating a different command to run after the image name.

## Connecting a `jboss-cli.sh` container to the Wildfly server container

### Step 1: Run the Wildfly image with a specific name

The first step is to start our Wildfly server.

Docker's linking system uses container ids or names to reference containers. We can explicitly specify a name for our Wildfly server to make it easier to connect to other containers.

```bash
docker run --name wildfly bitnami/wildfly
```

### Step 2: Run Wildfly as a client and link to our server

Now that we have our Wildfly server running, we can create another container to launch `jboss-cli.sh` that links to the server container by giving Docker the `--link` option. This option takes the id or name of the container we want to link it to as well as a hostname to use inside the container, separated by a colon. For example, to have our Wildfly server accessible in another container with `server` as it's hostname we would pass `--link wildfly:server` to the Docker run command.

```bash
docker run --rm -it --link wildfly:server bitnami/wildfly \
  jboss-cli.sh --controller=server:9990 --user=manager --password=wildfly --connect
```

We started `jboss-cli.sh` passing in the `--controller` option that allows us to specify the hostname and port of the server, which we set to the hostname we created in the link.

**Note!**
You can also run the client in the same container as the server using the Docker [exec](https://docs.docker.com/reference/commandline/cli/#exec) command.

```bash
docker exec -it wildfly jboss-cli.sh --user=manager --password=wildfly --connect
```

# Configuration

## Setting the `manager` password on first run

By default, the `manager` user is assigned the password `wildfly`. To secure your Wildfly server you should specify a different password for this user. Passing the `WILDFLY_PASSWORD` environment variable when running the image for the first time will set the password of the `manager` user to the value of `WILDFLY_PASSWORD`.

```bash
docker run --name wildfly -e WILDFLY_PASSWORD=password123 bitnami/wildfly
```

or using Docker Compose:

```
wildfly:
  image: bitnami/wildfly
  environment:
    - WILDFLY_PASSWORD=password123
```

## Configuration files

This image looks for Wildfly configuration files in `/bitnami/wildfly/conf`. You can mount a volume at this location with your own configurations, or the default configurations will be copied to your volume if it is empty.

### Step 1: Run the Wildfly image

Run the Wildfly image, mounting a directory from your host.

```bash
docker run --name wildfly -v /path/to/wildfly/conf:/bitnami/wildfly/conf bitnami/wildfly
```

or using Docker Compose:

```
wildfly:
  image: bitnami/wildfly
  volumes:
    - /path/to/wildfly/conf:/bitnami/wildfly/conf
```

### Step 2: Edit the configuration

Edit the configurations on your host using your favorite editor.

### Step 3: Restart Wildfly

After changing the configuration, restart your Wildfly container for the changes to take effect.

```bash
docker restart wildfly
```

or using Docker Compose:

```bash
docker-compose restart wildfly
```

**Further Reading:**

  - [General configuration concepts](https://docs.jboss.org/author/display/WFLY9/General+configuration+concepts)

## Caveats

The following options cannot be modified, to ensure that the image runs correctly.

```bash
-b 0.0.0.0
-bmanagement 0.0.0.0
-Djboss.server.config.dir=/opt/bitnami/wildfly/conf/standalone/configuration
-Djboss.server.log.dir=/opt/bitnami/wildfly/logs
-Djboss.domain.config.dir=/opt/bitnami/wildfly/conf/domain/configuration
-Djboss.domain.log.dir=/opt/bitnami/wildfly/logs
```

# Logging

The Bitnami Wildfly Docker Image supports two different logging modes: logging to stdout, and logging to a file.

## Logging to stdout

The default behavior is to log to stdout, as Docker expects. These will be collected by Docker, converted to JSON and stored in the host, to be accessible via the `docker logs` command.

```bash
docker logs wildfly
```

or using Docker Compose:

```bash
docker-compose logs wildfly
```

This method of logging has the downside of not being easy to manage. Without an easy way to rotate logs, they could grow exponentially and take up large amounts of disk space on your host.

## Logging to file

To log to file, run the Wildfly image, mounting a directory from your host at `/bitnami/wildfly/logs`. This will instruct the container to send logs to your directory.

```bash
docker run --name wildfly -v /path/to/wildfly/logs:/bitnami/wildfly/logs bitnami/wildfly
```

or using Docker Compose:

```
wildfly:
  image: bitnami/wildfly
  volumes:
    - /path/to/wildfly/logs:/bitnami/wildfly/logs
```

To perform operations (e.g. logrotate) on the logs, mount the same directory in a container designed to operate on log files, such as logstash.

# Maintenance

## Backing up your container

To backup your configuration and logs, follow these simple steps:

### Step 1: Stop the currently running container

```bash
docker stop wildfly
```

or using Docker Compose:

```bash
docker-compose stop wildfly
```

### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```bash
docker run --rm -v /path/to/backups:/backups --volumes-from wildfly busybox \
  cp -a /bitnami/wildfly /backups/latest
```

or using Docker Compose:

```bash
docker run --rm -v /path/to/backups:/backups --volumes-from `docker-compose ps -q wildfly` busybox \
  cp -a /bitnami/wildfly /backups/latest
```

**Note!**
If you only need to backup configuration, you can change the first argument to `cp` to `/bitnami/wildfly/conf`.

## Restoring a backup

Restoring a backup is as simple as mounting the backup as volumes in the container.

```bash
docker run -v /path/to/backups/latest/conf:/bitnami/wildfly/conf \
  -v /path/to/backups/latest/logs:/bitnami/wildfly/logs \
  bitnami/wildfly
```

or using Docker Compose:

```
wildfly:
  image: bitnami/wildfly
  volumes:
    - /path/to/backups/latest/conf:/bitnami/wildfly/conf
    - /path/to/backups/latest/logs:/bitnami/wildfly/logs
```

## Upgrade this image

Bitnami provides up-to-date versions of Wildfly, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
docker pull bitnami/wildfly:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/wildfly:latest`.

### Step 2: Stop and backup the currently running container

Before continuing, you should backup your container's configuration and logs.

Follow the steps on [creating a backup](#backing-up-your-container).

### Step 3: Remove the currently running container

```bash
docker rm -v wildfly
```

or using Docker Compose:

```bash
docker-compose rm -v wildfly
```

### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if necessary.

```bash
docker run --name wildfly bitnami/wildfly:latest
```

or using Docker Compose:

```bash
docker-compose start wildfly
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-wildfly/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-wildfly/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-wildfly/issues). For us to provide better support, be sure to include the following information in your issue:

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
