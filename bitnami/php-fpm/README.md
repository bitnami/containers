[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-php-fpm/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-php-fpm/tree/master)
[![Slack](https://img.shields.io/badge/slack-join%20chat%20%E2%86%92-e01563.svg)](http://slack.oss.bitnami.com)
[![Kubectl](https://img.shields.io/badge/kubectl-Available-green.svg)](https://raw.githubusercontent.com/bitnami/bitnami-docker-php-fpm/master/kubernetes.yml)

# What is PHP-FPM?

> PHP-FPM (FastCGI Process Manager) is an alternative PHP FastCGI implementation with some additional features useful for sites of any size, especially busier sites.

[php-fpm.org](http://php-fpm.org/)

# TL;DR;

```bash
$ docker run -it --name phpfpm -v /path/to/app:/app bitnami/php-fpm
```

## Docker Compose

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-php-fpm/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

## Kubernetes

> **WARNING:** This is a beta configuration, currently unsupported.

Get the raw URL pointing to the `kubernetes.yml` manifest and use `kubectl` to create the resources on your Kubernetes cluster like so:

```bash
$ kubectl create -f https://raw.githubusercontent.com/bitnami/bitnami-docker-php-fpm/master/kubernetes.yml
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* Bitnami images are built on CircleCI and automatically pushed to the Docker Hub.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.

# Supported tags and respective `Dockerfile` links

 - [`7.2`, `7.2.0-r1` (7.2/Dockerfile)](https://github.com/bitnami/bitnami-docker-php-fpm/blob/7.2.0-r1/7.2/Dockerfile), [`7.2-prod`, `7.2.0-r1-prod` (7.2/prod/Dockerfile)](https://github.com/bitnami/bitnami-docker-php-fpm/blob/7.2.0-r1/7.2/prod/Dockerfile)
 - [`7.1`, `7.1.12-r0`, `latest` (7.1/Dockerfile)](https://github.com/bitnami/bitnami-docker-php-fpm/blob/7.1.12-r0/7.1/Dockerfile), [`7.1-prod`, `7.1.12-r0-prod` (7.1/prod/Dockerfile)](https://github.com/bitnami/bitnami-docker-php-fpm/blob/7.1.12-r0/7.1/prod/Dockerfile)
 - [`7.0`, `7.0.26-r0` (7.0/Dockerfile)](https://github.com/bitnami/bitnami-docker-php-fpm/blob/7.0.26-r0/7.0/Dockerfile), [`7.0-prod`, `7.0.26-r0-prod` (7.0/prod/Dockerfile)](https://github.com/bitnami/bitnami-docker-php-fpm/blob/7.0.26-r0/7.0/prod/Dockerfile)
 - [`5.6`, `5.6.32-r0` (5.6/Dockerfile)](https://github.com/bitnami/bitnami-docker-php-fpm/blob/5.6.32-r0/5.6/Dockerfile), [`5.6-prod`, `5.6.32-r0-prod` (5.6/prod/Dockerfile)](https://github.com/bitnami/bitnami-docker-php-fpm/blob/5.6.32-r0/5.6/prod/Dockerfile)

Subscribe to project updates by watching the [bitnami/php-fpm GitHub repo](https://github.com/bitnami/bitnami-docker-php-fpm).

# Get this image

The recommended way to get the Bitnami PHP-FPM Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/php-fpm).

```bash
$ docker pull bitnami/php-fpm:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/php-fpm/tags/) in the Docker Hub Registry.

```bash
$ docker pull bitnami/php-fpm:[TAG]
```

If you wish, you can also build the image yourself.

```bash
$ docker build -t bitnami/php-fpm https://github.com/bitnami/bitnami-docker-php-fpm.git
```

# Connecting to other containers

This image is designed to be used with a web server to serve your PHP app, you can use docker networking to create a network and attach all the containers to that network.

## Serving your PHP app through an nginx frontend

We will use PHP-FPM with nginx to serve our PHP app. Doing so will allow us to setup more complex configuration, serve static assets using nginx, load balance to different PHP-FPM instances, etc.

### Step 1: Create a network

```bash
$ docker network create app-tier --driver bridge
```

or using Docker Compose:

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge
```

### Step 2: Create a virtual host

Let's create an nginx virtual host to reverse proxy to our PHP-FPM container.

```nginx
server {
  listen 0.0.0.0:80;
  server_name myapp.com;

  root /app;

  location / {
    try_files $uri $uri/index.php;
  }

  location ~ \.php$ {
    # fastcgi_pass [PHP_FPM_LINK_NAME]:9000;
    fastcgi_pass phpfpm:9000;
    fastcgi_index index.php;
    include fastcgi.conf;
  }
}
```

Notice we've substituted the link alias name `myapp`, we will use the same name when creating the container.

Copy the virtual host above, saving the file somewhere on your host. We will mount it as a volume in our nginx container.

### Step 3: Run the PHP-FPM image with a specific name

Docker's linking system uses container ids or names to reference containers. We can explicitly specify a name for our PHP-FPM server to make it easier to connect to other containers.

```bash
$ docker run -it --name phpfpm \
  --network app-tier
  -v /path/to/app:/app \
  bitnami/php-fpm
```

or using Docker Compose:

```yaml
services:
  phpfpm:
    image: 'bitnami/php-fpm:latest'
    networks:
      - app-tier
    volumes:
      - /path/to/app:/app
```

### Step 4: Run the nginx image

```bash
$ docker run -it \
  -v /path/to/vhost.conf:/bitnami/nginx/conf/vhosts/yourapp.conf \
  --network app-tier \
  bitnami/nginx
```

or using Docker Compose:

```yaml
services:
  nginx:
    image: 'bitnami/nginx:latest'
    depends_on:
      - phpfpm
    networks:
      - app-tier
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - /path/to/vhost.conf:/bitnami/nginx/conf/vhosts/yourapp.conf
```

# PHP runtime

Since this image bundles a PHP runtime, you may want to make use of PHP outside of PHP-FPM. By default, running this image will start a server. To use the PHP runtime instead, we can override the the default command Docker runs by stating a different command to run after the image name.

## Entering the REPL

PHP provides a REPL where you can interactively test and try things out in PHP.

```bash
$ docker run -it --name phpfpm bitnami/php-fpm php -a
```

**Further Reading:**

- [PHP Interactive Shell Documentation](http://php.net/manual/en/features.commandline.interactive.php)

# Running your PHP script

The default work directory for the PHP-FPM image is `/app`. You can mount a folder from your host here that includes your PHP script, and run it normally using the `php` command.

```bash
$ docker run -it --name php-fpm -v /path/to/app:/app bitnami/php-fpm \
  php script.php
```

# Configuration

The image looks for configurations in `/bitnami/php-fpm/conf/`. You can mount a volume at `/bitnami` and copy/edit the configurations in `/bitnami/php-fpm/php-fpm/conf/`. The default configurations will be populated to the `conf/` directory if it's empty.

### Step 1: Run the PHP-FPM image

Run the PHP-FPM image, mounting a directory from your host.

```bash
$ docker run --name phpfpm -v /path/to/php-fpm:/bitnami bitnami/php-fpm
```

or using Docker Compose:

```yaml
version: '2'

services:
  phpfpm:
    image: 'bitnami/php-fpm:latest'
    ports:
      - '9000:9000'
    volumes:
      - /path/to/php-fpm:/bitnami
```

### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```bash
$ vi /path/to/php-fpm/php-fpm/conf/php-fpm.conf
```

### Step 3: Restart PHP-FPM

After changing the configuration, restart your PHP-FPM container for the changes to take effect.

```bash
$ docker restart phpfpm
```

or using Docker Compose:

```bash
$ docker-compose restart phpfpm
```

# Logging

The Bitnami PHP-FPM Docker Image sends the container logs to the `stdout`. You can configure the containers [logging driver](https://docs.docker.com/engine/reference/run/#logging-drivers-log-driver) using the `--log-driver` option. By defauly the `json-file` driver is used.

To view the logs:

```bash
$ docker logs phpfpm
```

or using Docker Compose:

```bash
$ docker-compose logs phpfpm
```

*The `docker logs` command is only available when the `json-file` or `journald` logging driver is in use.*

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of PHP-FPM, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
$ docker pull bitnami/php-fpm:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/php-fpm:latest`.

### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```bash
$ docker stop php-fpm
```

or using Docker Compose:

```bash
$ docker-compose stop php-fpm
```

Next, take a snapshot of the persistent volume `/path/to/php-fpm-persistence` using:

```bash
$ rsync -a /path/to/php-fpm-persistence /path/to/php-fpm-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

You can use this snapshot to restore the database state should the upgrade fail.

### Step 3: Remove the currently running container

```bash
$ docker rm -v phpfpm
```

or using Docker Compose:

```bash
$ docker-compose rm -v phpfpm
```

### Step 4: Run the new image

Re-create your container from the new image.

```bash
$ docker run --name phpfpm bitnami/php-fpm:latest
```

or using Docker Compose:

```bash
$ docker-compose start phpfpm
```

# Useful Links

- [Create An AMP Development Environment With Bitnami Containers
](https://docs.bitnami.com/containers/how-to/create-amp-environment-containers/)
- [Create An EMP Development Environment With Bitnami Containers
](https://docs.bitnami.com/containers/how-to/create-emp-environment-containers/)

# Notable Changes

## 7.0.6-r0 (2016-05-17)

- All volumes have been merged at `/bitnami/php-fpm`. Now you only need to mount a single volume at `/bitnami/php-fpm` for persistence.
- The logs are always sent to the `stdout` and are no longer collected in the volume.

## 5.5.30-2 (2015-12-07)

- Enables support for imagick extension

## 5.5.30-0-r01 (2015-11-10)

- `php.ini` is now exposed in the volume mounted at `/bitnami/php-fpm/conf/` allowing users to change the defaults as per their requirements.

## 5.5.30-0 (2015-10-06)

- `/app` directory is no longer exported as a volume. This caused problems when building on top of the image, since changes in the volume are not persisted between Dockerfile `RUN` instructions. To keep the previous behavior (so that you can mount the volume in another container), create the container with the `-v /app` option.

# Contributing

We'd love for you to contribute to this Docker image. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-php-fpm/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-php-fpm/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-php-fpm/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# Community

Most real time communication happens in the `#containers` channel at [bitnami-oss.slack.com](http://bitnami-oss.slack.com); you can sign up at [slack.oss.bitnami.com](http://slack.oss.bitnami.com).

Discussions are archived at [bitnami-oss.slackarchive.io](https://bitnami-oss.slackarchive.io).

# License

Copyright (c) 2015-2017 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
