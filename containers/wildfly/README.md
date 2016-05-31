[![Build Status](http://bitnami-container-builds.bitnamiapp.com/jenkins/buildStatus/icon?job=docker-wildfly)](http://bitnami-container-builds.bitnamiapp.com/jenkins/job/docker-wildfly/)

# What is Wildfly?

> [Wildfly](http://wildfly.org), formerly known as JBoss AS, or simply JBoss, is an application server authored by JBoss, now developed by Red Hat. WildFly is written in Java, and implements the Java Platform, Enterprise Edition (Java EE) specification.

# TLDR

```bash
docker run --name wildfly bitnami/wildfly:latest
```

## Docker Compose

```yaml
wildfly:
  image: bitnami/wildfly:latest
```

# Get this image

The recommended way to get the Bitnami Wildfly Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/wildfly).

```bash
docker pull bitnami/wildfly:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/wildfly/tags/) in the Docker Hub Registry.

```bash
docker pull bitnami/wildfly:[TAG]
```

If you wish, you can also build the image yourself.

```bash
docker build -t bitnami/wildfly:latest https://github.com/bitnami/bitnami-docker-wildfly.git
```

# Persisting Wildfly configurations and deployments

If you remove the container all your Wildfly configurations and application deployments will be lost. To avoid this you should mount a volume that will persist even after the container is removed.

**Note!**
If you have already started using your Wildfly deployment, follow the steps on
[backing up](#backing-up-your-container) and [restoring](#restoring-a-backup) to pull the data from your running container down to your host.

The image exposes a volume at `/bitnami/wildfly` for the Wildfly configurations and application deployments. For persistence you can mount a directory at this location from your host. If the mounted directory is empty, it will be initialized on the first run.

```bash
docker run -v /path/to/wildfly-persistence:/bitnami/wildfly bitnami/wildfly:latest
```

or using Docker Compose:

```yaml
wildfly:
  image: bitnami/wildfly:latest
  volumes:
    - /path/to/wildfly-persistence:/bitnami/wildfly
```

# Deploying web applications on Wildfly

The `/bitnami/wildfly/data` directory is configured as the Wildfly webapps deployment directory. At this location, you either copy a so-called *exploded web application*, i.e. non-compressed, or a compressed web application resource (`.WAR`) file and it will automatically be deployed by Wildfly.

Additionally a helper symlink `/app` is present that points to the webapps deployment directory which enables us to deploy applications on a running Wildfly instance by simply doing:

```bash
docker cp /path/to/app.war wildfly:/app
```

**Note!**
You can also deploy web applications on a running Wildfly instance using the Wildfly management interface.

# Accessing your Wildfly server from the host

The image exposes the application server on port `8080` and the management console on port `9990`. To access your web server from your host machine you can ask Docker to map random ports on your host to the ports `8080` and `9990` of the container.

```bash
docker run --name wildfly -P bitnami/wildfly:latest
```

Run `docker port` to determine the random ports Docker assigned.

```bash
$ docker port wildfly
8080/tcp -> 0.0.0.0:32775
9990/tcp -> 0.0.0.0:32774
```

You can also manually specify the ports you want forwarded from your host to the container.

```bash
docker run -p 8080:8080 -p 9990:9990 bitnami/wildfly:latest
```

Access your web server in the browser by navigating to [http://localhost:8080](http://localhost:8080/) to access the application server and [http://localhost:9990/console](http://localhost:9990/console/) to access the management console.

# Accessing the command line interface

The command line management tool `jboss-cli.sh` allows a user to connect to the Wildfly server and execute management operations available through the de-typed management model.

The Bitnami Wildfly Docker Image ships the `jboss-cli.sh` client and can be launched by specifying the command while launching the container.

## Connecting a client container to the Wildfly server container

### Step 1: Run the Wildfly image with a specific name

The first step is to start our Wildfly server.

Docker's linking system uses container ids or names to reference containers. We can explicitly specify a name for our Wildfly server to make it easier to connect to other containers.

```bash
docker run --name wildfly bitnami/wildfly:latest
```

### Step 2: Run Wildfly as a client and link to our server

Now that we have our Wildfly server running, we can create another container to launch `jboss-cli.sh` that links to the server container by giving Docker the `--link` option. This option takes the id or name of the container we want to link it to as well as a hostname to use inside the container, separated by a colon. For example, to have our Wildfly server accessible in another container with `server` as it's hostname we would pass `--link wildfly:server` to the Docker run command.

```bash
docker run --rm -it --link wildfly:server bitnami/wildfly \
  jboss-cli.sh --controller=server:9990 --user=test --password=password --connect
```

We started `jboss-cli.sh` passing in the `--controller` option that allows us to specify the hostname and port of the server, which we set to the hostname we created in the link.

**Note!**
You can also run the client in the same container as the server using the Docker [exec](https://docs.docker.com/reference/commandline/cli/#exec) command.

```bash
docker exec -it wildfly jboss-cli.sh --user=user --password=password --connect
```

# Configuration

## Creating a custom user

By default, a management user named `user` is created with the default password `password`. Passing the `WILDFLY_PASSWORD` environment variable when running the image for the first time will set the password of this user to the value of `WILDFLY_PASSWORD`.

Additionally you can specify a user name for the management user using the `WILDFLY_USER` environment variable. When not specified, the `WILDFLY_PASSWORD` configuration is applied on the default user (`user`).

```bash
docker run --name wildfly \
  -e WILDFLY_USER=my_user \
  -e WILDFLY_PASSWORD=my_password \
  bitnami/wildfly:latest
```

or using Docker Compose:

```yaml
wildfly:
  image: bitnami/wildfly:latest
  environment:
    - WILDFLY_USER=my_user
    - WILDFLY_PASSWORD=my_password
```

## Configuration files

This image looks for Wildfly configuration files in `/bitnami/wildfly/conf`. You may recall from the [persisting wildfly configurations and deployments](#persisting-wildfly-configurations-and-deployments) section, `/bitnami/wildfly` is the path to the persistence volume.

Create a directory named `conf/` at this location with your own configuration, or the default configuration will be copied on the first run which can be customized later.

### Step 1: Run the Wildfly image

Run the Wildfly image, mounting a directory from your host.

```bash
docker run --name wildfly -v /path/to/wildfly-persistence:/bitnami/wildfly bitnami/wildfly:latest
```

or using Docker Compose:

```yaml
wildfly:
  image: bitnami/wildfly:latest
  volumes:
    - /path/to/wildfly-persistence:/bitnami/wildfly
```

### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

eg.

```bash
vim /path/to/wildfly-persistence/conf/standalone.xml
```

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

# Logging

The Bitnami Wildfly Docker image sends the container logs to the `stdout`. To view the logs:

```bash
docker logs wildfly
```

or using Docker Compose:

```bash
docker-compose logs wildfly
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

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
docker run --rm \
  -v /path/to/wildfly-backups:/backups \
  --volumes-from wildfly \
  busybox cp -a /bitnami/wildfly /backups/latest
```

or using Docker Compose:

```bash
docker run --rm \
  -v /path/to/wildfly-backups:/backups \
  --volumes-from `docker-compose ps -q wildfly` \
  busybox cp -a /bitnami/wildfly /backups/latest
```

## Restoring a backup

Restoring a backup is as simple as mounting the backup as volumes in the container.

```bash
docker run \
  -v /path/to/wildfly-backups/latest:/bitnami/wildfly \
  bitnami/wildfly:latest
```

or using Docker Compose:

```yaml
wildfly:
  image: bitnami/wildfly:latest
  volumes:
    - /path/to/wildfly-backups/latest:/bitnami/wildfly
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

# Testing

This image is tested for expected runtime behavior, using the [Bats](https://github.com/sstephenson/bats) testing framework. You can run the tests on your machine using the `bats` command.

```
bats test.sh
```

# Notable Changes

## 10.0.0-r0

- All volumes have been merged at `/bitnami/tomcat`. Now you only need to mount a single volume at `/bitnami/tomcat` for persistence.
- The logs are always sent to the `stdout` and are no longer collected in the volume.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-wildfly/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-wildfly/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-wildfly/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_APP_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

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
