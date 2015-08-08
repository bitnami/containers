[![Build
Status](http://bitnami-container-builds.bitnamiapp.com/jenkins/buildStatus/icon?job=docker-apache)](http://bitnami-container-builds.bitnamiapp.com/jenkins/job/docker-apache/)
# What is Apache?

> The Apache HTTP Server Project is an effort to develop and maintain an open-source HTTP server for
> modern operating systems including UNIX and Windows NT. The goal of this project is to provide a
> secure, efficient and extensible server that provides HTTP services in sync with the current HTTP
> standards.

[http://httpd.apache.org/](http://httpd.apache.org/)

# TLDR

```bash
docker run --name apache bitnami/apache
```

## Docker Compose

```
apache:
  image: bitnami/apache
```

# Get this image

The recommended way to get the Bitnami Apache Docker Image is to pull the prebuilt image from the
[Docker Hub Registry](https://hub.docker.com/r/bitnami/apache).

```bash
docker pull bitnami/apache:latest
```

To use a specific version, you can pull a versioned tag. You can view the
[list of available versions](https://hub.docker.com/r/bitnami/apache/tags/)
in the Docker Hub Registry.

```bash
docker pull bitnami/apache:[TAG]
```

If you wish, you can also build the image yourself.

```bash
git clone https://github.com/bitnami/bitnami-docker-apache.git
cd bitnami-docker-apache
docker build -t bitnami/apache .
```

# Hosting a static website

This Apache image exposes a volume at `/app`. Content mounted here is served by the default
catch-all virtual host. Mounting an empty directory here will copy the default content to your
volume.

```bash
docker run --name apache -v /path/to/app:/app bitnami/apache
```

or using Docker Compose:

```
apache:
  image: bitnami/apache
  volumes:
    - /path/to/app:/app
```

# Accessing your server from the host

To access your web server from your host machine you can ask Docker to map a random port on your
host to ports `80` and `443` exposed in the container.

```bash
docker run --name apache -P bitnami/apache
```

Run `docker port` to determine the random ports Docker assigned.

```bash
$ docker port apache
443/tcp -> 0.0.0.0:32768
80/tcp -> 0.0.0.0:32769
```

You can also manually specify the ports you want forwarded from your host to the container.

```bash
docker run -p 8080:80 -p 8443:443 bitnami/apache
```

Access your web server in the browser by navigating to
[http://localhost:8080](http://localhost:8080/).

# Configuration

## Adding custom virtual hosts

The default httpd.conf includes virtual hosts placed in `/bitnami/apache/conf/vhosts/*.conf`. You
can mount a directory at `/bitnami/apache/conf/vhosts` from your host containing your custom virtual
hosts.

```bash
docker run -v /path/to/apache/vhosts:/bitnami/apache/conf/vhosts bitnami/apache
```

or using Docker Compose:

```
apache:
  image: bitnami/apache
  volumes:
    - /path/to/apache/vhosts:/bitnami/apache/conf/vhosts
```

## Full configuration

This container looks for configuration in `/bitnami/apache/conf`. You can mount a directory there
with your own configuration, or the default configuration will be copied to your directory if it is
empty.

### Step 1: Run the Apache image

Run the Apache image, mounting a directory from your host.

```bash
docker run --name apache -v /path/to/apache/conf:/bitnami/apache/conf bitnami/apache
```

or using Docker Compose:

```
apache:
  image: bitnami/apache
  volumes:
    - /path/to/apache/conf:/bitnami/apache/conf
```

### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```bash
vi /path/to/apache/conf/httpd.conf
```

### Step 4: Restart Apache

After changing the configuration, restart your Apache container for changes to take effect.

```bash
docker restart apache
```

or using Docker Compose:

```bash
docker-compose restart apache
```

**Note!**

You can also reload the Apache configuration by sending the `HUP` signal to the container using the
`docker kill` command.

```bash
docker kill -s HUP apache
```

# Reverse proxy to other containers

Apache can be used to reverse proxy to other containers using Docker's linking system. This is
particularly useful if you want to serve dynamic content through an Apache frontend. Bitnami provides
example virtual hosts for all of our runtime containers in `/bitnami/apache/conf/vhosts/`.

**Further Reading:**

  - [mod_proxy documentation](http://httpd.apache.org/docs/2.2/mod/mod_proxy.html#forwardreverse)

# Logging

The Bitnami Apache Docker Image supports two different logging modes: logging to stdout, and logging
to a file.

## Logging to stdout

The default behavior is to log to stdout, as Docker expects. These will be collected by Docker,
converted to JSON and stored in the host, to be accessible via the `docker logs` command.

```bash
docker logs apache
```

or using Docker Compose:

```bash
docker-compose logs apache
```

This method of logging has the downside of not being easy to manage. Without an easy way to rotate
logs, they could grow exponentially and take up large amounts of disk space on your host.

## Logging to file

To log to file, run the Apache image, mounting a directory from your host at `/bitnami/apache/logs`.
This will instruct the container to send logs to your directory.

```bash
docker run --name apache -v /path/to/apache/logs:/bitnami/apache/logs bitnami/apache
```

or using Docker Compose:

```
apache:
  image: bitnami/apache
  volumes:
    - /path/to/apache/logs:/bitnami/apache/logs
```

To perform operations (e.g. logrotate) on the logs, mount the same directory in a container designed
to operate on log files, such as logstash.

# Maintenance

## Backing up your container

To backup your configuration and logs, follow these simple steps:

### Step 1: Stop the currently running container

```bash
docker stop apache
```

or using Docker Compose:

```bash
docker-compose stop apache
```

### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your
host to store the backup in, and the volumes from the container we just stopped so we can access the
data.

```bash
docker run --rm -v /path/to/backups:/backups --volumes-from apache busybox \
  cp -a /bitnami/apache /backups/latest
```

or using Docker Compose:

```bash
docker run --rm -v /path/to/backups:/backups --volumes-from `docker-compose ps -q apache` busybox \
  cp -a /bitnami/apache /backups/latest
```

**Note!**
If you only need to backup configuration, you can change the first argument to `cp` to
`/bitnami/apache/conf`.

## Restoring a backup

Restoring a backup is as simple as mounting the backup as volumes in the container.

```bash
docker run -v /path/to/backups/latest/conf:/bitnami/apache/conf \
  -v /path/to/backups/latest/logs:/bitnami/apache/logs \
  bitnami/apache
```

or using Docker Compose:

```
apache:
  image: bitnami/apache
  volumes:
    - /path/to/backups/latest/conf:/bitnami/apache/conf
    - /path/to/backups/latest/logs:/bitnami/apache/logs
```

## Upgrade this image

Bitnami provides up-to-date versions of Apache, including security patches, soon after they are made
upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
docker pull bitnami/apache:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/apache:latest`.

### Step 2: Stop and backup the currently running container

Before continuing, you should backup your container's configuration and logs.

Follow the steps on [creating a backup](#backing-up-your-container).

### Step 3: Remove the currently running container

```bash
docker rm -v apache
```

or using Docker Compose:

```bash
docker-compose rm -v apache
```

### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if
necessary.

```bash
docker run --name apache bitnami/apache:latest
```

or using Docker Compose:

```bash
docker-compose start apache
```

# Testing

This image is tested for expected runtime behavior, using the
[Bats](https://github.com/sstephenson/bats) testing framework. You can run the tests on your machine
using the `bats` command.

```
bats test.sh
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an
[issue](https://github.com/bitnami/bitnami-docker-apache/issues), or submit a
[pull request](https://github.com/bitnami/bitnami-docker-apache/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an
[issue](https://github.com/bitnami/bitnami-docker-apache/issues). For us to provide better support,
be sure to include the following information in your issue:

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
