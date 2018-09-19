[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-apache/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-apache/tree/master)

# What is Apache?

> The Apache HTTP Server Project is an effort to develop and maintain an open-source HTTP server for modern operating systems including UNIX and Windows NT. The goal of this project is to provide a secure, efficient and extensible server that provides HTTP services in sync with the current HTTP standards.

[http://httpd.apache.org/](http://httpd.apache.org/)

# TL;DR;

```bash
$ docker run --name apache bitnami/apache:latest
```

## Docker Compose

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-apache/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* Bitnami images are built on CircleCI and automatically pushed to the Docker Hub.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/containers/how-to/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

> NOTE: Debian 8 images have been deprecated in favor of Debian 9 images. Bitnami will not longer publish new Docker images based on Debian 8.

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/).


* [`2.4-rhel-7`, `2.4.34-rhel-7-r1` (2.4/rhel-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-wordpress/blob/2.4.34-rhel-7-r1/2.4/rhel-7/Dockerfile)
* [`2.4-ol-7`, `2.4.34-ol-7-r57` (2.4/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-wordpress/blob/2.4.34-ol-7-r57/2.4/ol-7/Dockerfile)
* [`2.4-debian-9`, `2.4.34-debian-9-r54`, `2.4`, `2.4.34`, `2.4.34-r54`, `latest` (2.4/debian-9/Dockerfile)](https://github.com/bitnami/bitnami-docker-wordpress/blob/2.4.34-debian-9-r54/2.4/debian-9/Dockerfile)

# Get this image

The recommended way to get the Bitnami Apache Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/apache).

```bash
$ docker pull bitnami/apache:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/apache/tags/) in the Docker Hub Registry.

```bash
$ docker pull bitnami/apache:[TAG]
```

If you wish, you can also build the image yourself.

```bash
$ docker build -t bitnami/apache:latest https://github.com/bitnami/bitnami-docker-apache.git
```

# Hosting a static website

The `/app` path is configured as the Apache [DocumentRoot](https://httpd.apache.org/docs/2.4/urlmapping.html#documentroot). Content mounted here is served by the default catch-all virtual host.

```bash
$ docker run --name apache -v /path/to/app:/app bitnami/apache:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  apache:
    image: 'bitnami/apache:latest'
    ports:
      - '80:8080'
      - '443:8443'
    volumes:
      - /path/to/app:/app
```

# Accessing your server from the host

To access your web server from your host machine you can ask Docker to map a random port on your host to ports `8080` and `8443` exposed in the container.

```bash
$ docker run --name apache -P bitnami/apache:latest
```

Run `docker port` to determine the random ports Docker assigned.

```bash
$ docker port apache
8443/tcp -> 0.0.0.0:32768
8080/tcp -> 0.0.0.0:32769
```

You can also manually specify the ports you want forwarded from your host to the container.

```bash
$ docker run -p 8080:8080 -p 8443:8443 bitnami/apache:latest
```

Access your web server in the browser by navigating to [http://localhost:8080](http://localhost:8080/).

# Configuration

## Environment variables

When you start the Apache image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the docker run command line. If you want to add a new environment variable:

 * For docker-compose add the variable name and value under the application section:

```yaml
version: '2'

services:
  apache:
    image: 'bitnami/apache:latest'
    labels:
      kompose.service.type: nodeport
    ports:
      - '80:8081'
      - '443:8443'
    environment:
      - APACHE_HTTP_PORT_NUMBER=8081
    volumes:
      - 'apache_data:/bitnami'
volumes:
  apache_data:
    driver: local
```

 * For manual execution add a `-e` option with each variable and value:

```bash
$ docker run -d --name apache -p 80:8081 -p 443:443 \
  --network apache-tier \
  --e APACHE_HTTP_PORT_NUMBER=8081 \
  --volume /path/to/apache-persistence:/bitnami \
  bitnami/apache:latest
```

Available variables:

 - `APACHE_HTTP_PORT_NUMBER`: Port used by Apache for HTTP. Default: **8080**
 - `APACHE_HTTPS_PORT_NUMBER`: Port used by Apache for HTTPS. Default: **8443**

## Adding custom virtual hosts

The default `httpd.conf` includes virtual hosts placed in `/bitnami/apache/conf/vhosts/`. You can mount a `my_vhost.conf` file containing your custom virtual hosts at this location.

For example, in order add a vhost for `www.example.com`:

# Step 1: Write your `my_vhost.conf` file with the following content.

```apache
<VirtualHost *:8080>
  ServerName www.example.com
  DocumentRoot "/app"
  <Directory "/app">
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
  </Directory>
</VirtualHost>
```

# Step 2: Mount the configuration as a volume.

```bash
$ docker run --name apache \
  -v /path/to/my_vhost.conf:/bitnami/apache/conf/vhosts/my_vhost.conf:ro \
  bitnami/apache:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  apache:
    image: 'bitnami/apache:latest'
    ports:
      - '80:8080'
      - '443:8443'
    volumes:
      - /path/to/my_vhost.conf:/bitnami/apache/conf/vhosts/my_vhost.conf:ro
```

## Using custom SSL certificates

*NOTE:* The steps below assume that you are using a custom domain name and that you have already configured the custom domain name to point to your server.

This container comes with SSL support already pre-configured and with a dummy certificate in place (`server.crt` and `server.key` files in `/bitnami/apache/conf/bitnami/certs`). If you want to use your own certificate (`.crt`) and certificate key (`.key`) files, follow the steps below:

### Step 1: Prepare your certificate files

In your local computer, create a folder called `certs` and put your certificates files. Make sure you rename both files to `server.crt` and `server.key` respectively:

```bash
$ mkdir /path/to/apache-persistence/apache/conf/bitnami/certs -p
$ cp /path/to/certfile.crt /path/to/apache-persistence/apache/conf/bitnami/certs/server.crt
$ cp /path/to/keyfile.key  /path/to/apache-persistence/apache/conf/bitnami/certs/server.key
```

### Step 2: Run the Apache image

Run the Apache image, mounting the certificates directory from your host.

```bash
$ docker run --name apache \
  -v /path/to/apache-persistence/apache/conf/bitnami/certs:/bitnami/apache/conf/bitnami/certs \
  bitnami/apache:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  apache:
    image: 'bitnami/apache:latest'
    ports:
      - '80:8080'
      - '443:8443'
    volumes:
      - /path/to/apache-persistence/apache/conf/bitnami/certs:/bitnami/apache/conf/bitnami/certs
```

## Full configuration

The image looks for configurations in `/bitnami/apache/conf/`. You can mount a volume at `/bitnami` and copy/edit the configurations in the `/bitnami/apache/conf/`. The default configurations will be populated in the `conf/` directory if it's empty.

### Step 1: Run the Apache image

Run the Apache image, mounting a directory from your host.

```bash
$ docker run --name apache \
  -v /path/to/apache-persistence:/bitnami \
  bitnami/apache:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  apache:
    image: 'bitnami/apache:latest'
    ports:
      - '80:8080'
      - '443:8443'
    volumes:
      - /path/to/apache-persistence:/bitnami
```

### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```bash
$ vi /path/to/apache-persistence/apache/conf/httpd.conf
```

### Step 4: Restart Apache

After changing the configuration, restart your Apache container for the changes to take effect.

```bash
$ docker restart apache
```

or using Docker Compose:

```bash
$ docker-compose restart apache
```

# Reverse proxy to other containers

Apache can be used to reverse proxy to other containers using Docker's linking system. This is particularly useful if you want to serve dynamic content through an Apache frontend.

**Further Reading:**

  - [mod_proxy documentation](http://httpd.apache.org/docs/2.2/mod/mod_proxy.html#forwardreverse)

# Logging

The Bitnami Apache Docker image sends the container logs to the `stdout`. To view the logs:

```bash
$ docker logs apache
```

or using Docker Compose:

```bash
$ docker-compose logs apache
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of Apache, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
$ docker pull bitnami/apache:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/apache:latest`.

### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```bash
$ docker stop apache
```

or using Docker Compose:

```bash
$ docker-compose stop apache
```

Next, take a snapshot of the persistent volume `/path/to/apache-persistence` using:

```bash
$ rsync -a /path/to/apache-persistence /path/to/apache-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

You can use this snapshot to restore the database state should the upgrade fail.

### Step 3: Remove the currently running container

```bash
$ docker rm -v apache
```

or using Docker Compose:

```bash
$ docker-compose rm -v apache
```

### Step 4: Run the new image

Re-create your container from the new image.

```bash
$ docker run --name apache bitnami/apache:latest
```

or using Docker Compose:

```bash
$ docker-compose up apache
```

# Useful Links

- [Create An AMP Development Environment With Bitnami Containers
](https://docs.bitnami.com/containers/how-to/create-amp-environment-containers/)

# Notable Changes

## 2.4.34-r8

- The Apache container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the Apache daemon was started as the `apache` user. From now on, both the container and the Apache daemon run as user `1001`. As a consequence, the HTTP/HTTPS ports exposed by the container are now 8080/8443 instead of 80/443. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

## 2.4.18-r0

- The configuration volume has been moved to `/bitnami/apache`. Now you only need to mount a single volume at `/bitnami/apache` for persisting configuration. `/app` is still used for serving content by the default virtual host.
- The logs are always sent to the `stdout` and are no longer collected in the volume.

## 2.4.12-4-r01

- The `/app` directory is no longer exported as a volume. This caused problems when building on top of the image, since changes in the volume are not persisted between Dockerfile `RUN` instructions. To keep the previous behavior (so that you can mount the volume in another container), create the container with the `-v /app` option.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-apache/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-apache/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-apache/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright (c) 2015-2018 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
