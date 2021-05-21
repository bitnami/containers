# What is Apache?

> The Apache HTTP Server Project is an effort to develop and maintain an open-source HTTP server for modern operating systems including UNIX and Windows NT. The goal of this project is to provide a secure, efficient and extensible server that provides HTTP services in sync with the current HTTP standards.

[http://httpd.apache.org/](http://httpd.apache.org/)

# TL;DR

```console
$ docker run --name apache bitnami/apache:latest
```

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-apache/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

You can find the available configuration options in the [Environment Variables](#environment-variables) section.

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.

> This [CVE scan report](https://quay.io/repository/bitnami/apache?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy Apache in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Apache Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/apache).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`2.4`, `2.4-debian-10`, `2.4.46`, `2.4.46-debian-10-r259`, `latest` (2.4/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-apache/blob/2.4.46-debian-10-r259/2.4/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/apache GitHub repo](https://github.com/bitnami/bitnami-docker-apache).

# Get this image

The recommended way to get the Bitnami Apache Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/apache).

```console
$ docker pull bitnami/apache:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/apache/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/apache:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/apache:latest 'https://github.com/bitnami/bitnami-docker-apache.git#master:2.4/debian-10'
```

# Hosting a static website

The `/app` path is configured as the Apache [DocumentRoot](https://httpd.apache.org/docs/2.4/urlmapping.html#documentroot). Content mounted here is served by the default catch-all virtual host.

```console
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

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

# Accessing your server from the host

To access your web server from your host machine you can ask Docker to map a random port on your host to ports `8080` and `8443` exposed in the container.

```console
$ docker run --name apache -P bitnami/apache:latest
```

Run `docker port` to determine the random ports Docker assigned.

```console
$ docker port apache
8443/tcp -> 0.0.0.0:32768
8080/tcp -> 0.0.0.0:32769
```

You can also manually specify the ports you want forwarded from your host to the container.

```console
$ docker run -p 8080:8080 -p 8443:8443 bitnami/apache:latest
```

Access your web server in the browser by navigating to [http://localhost:8080](http://localhost:8080/).

# Configuration

## Environment variables

When you start the Apache image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. If you want to add a new environment variable:

 * For docker-compose add the variable name and value under the application section:

```yaml
version: '2'

services:
  apache:
    image: 'bitnami/apache:latest'
    ports:
      - '80:8081'
      - '443:8443'
    environment:
      - APACHE_HTTP_PORT_NUMBER=8081
```

 * For manual execution add a `-e` option with each variable and value:

```console
$ docker run -d --name apache -p 80:8081 -p 443:443 \
  --network apache-tier \
  --e APACHE_HTTP_PORT_NUMBER=8081 \
  bitnami/apache:latest
```

Available variables:

 - `APACHE_HTTP_PORT_NUMBER`: Port used by Apache for HTTP. Default: **8080**
 - `APACHE_HTTPS_PORT_NUMBER`: Port used by Apache for HTTPS. Default: **8443**

## Adding custom virtual hosts

The default `httpd.conf` includes virtual hosts placed in `/opt/bitnami/apache/conf/vhosts/`. You can mount a `my_vhost.conf` file containing your custom virtual hosts at the `/vhosts` folder.

For example, in order add a vhost for `www.example.com`:

### Step 1: Write your `my_vhost.conf` file with the following content.

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

### Step 2: Mount the configuration as a volume.

```console
$ docker run --name apache \
  -v /path/to/my_vhost.conf:/vhosts/my_vhost.conf:ro \
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
      - /path/to/my_vhost.conf:/vhosts/my_vhost.conf:ro
```

## Using custom SSL certificates

*NOTE:* The steps below assume that you are using a custom domain name and that you have already configured the custom domain name to point to your server.

This container comes with SSL support already pre-configured and with a dummy certificate in place (`server.crt` and `server.key` files in `/certs`). If you want to use your own certificate (`.crt`) and certificate key (`.key`) files, follow the steps below:

### Step 1: Prepare your certificate files

In your local computer, create a folder called `certs` and put your certificates files. Make sure you rename both files to `server.crt` and `server.key` respectively:

```console
$ mkdir /path/to/apache-certs -p
$ cp /path/to/certfile.crt /path/to/apache-certs/server.crt
$ cp /path/to/keyfile.key  /path/to/apache-certs/server.key
```

### Step 2: Run the Apache image

Run the Apache image, mounting the certificates directory from your host.

```console
$ docker run --name apache \
  -v /path/to/apache-certs:/certs \
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
      - /path/to/apache-certs:/certs
```

## Full configuration

The image looks for configurations in `/opt/bitnami/apache/conf`. You can overwrite the `httpd.conf` file using your own custom configuration file.

```console
$ docker run --name apache \
  -v /path/to/httpd.conf:/opt/bitnami/apache/conf/httpd.conf \
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
      - /path/to/httpd.conf:/opt/bitnami/apache/conf/httpd.conf
```

# Reverse proxy to other containers

Apache can be used to reverse proxy to other containers using Docker's linking system. This is particularly useful if you want to serve dynamic content through an Apache frontend.

**Further Reading:**

  - [mod_proxy documentation](http://httpd.apache.org/docs/2.2/mod/mod_proxy.html#forwardreverse)

# Logging

The Bitnami Apache Docker image sends the container logs to the `stdout`. To view the logs:

```console
$ docker logs apache
```

or using Docker Compose:

```console
$ docker-compose logs apache
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Understand the structure of this image

The Bitnami Apache Docker image is built using a Dockerfile with the structure below:

```Dockerfile
FROM bitnami/minideb
...
# Install required system packages and dependencies
RUN install_packages xxx yyy zzz
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "apache" "aa.bb.cc-dd"
...
COPY rootfs /

ENV ...

EXPOSE 8080 8443

WORKDIR /app
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/apache/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/apache/run.sh" ]
```

The Dockerfile has several sections related to:

- Components installation
- Components static configuration
- Environment variables
- Volumes
- Ports to be exposed
- Working directory and user
  - Note that once the user is set to 1001, unprivileged commands cannot be executed any longer.
- Entrypoint and command
  - Take into account that these actions are not executed until the container is started.

# Customize this image

The Bitnami Apache Docker image is designed to be extended so it can be used as the base image for your custom web applications.

> Note: Read the [previous section](#understand-the-structure-of-this-image) to understand the Dockerfile structure before extending this image.

## Extend this image

Before extending this image, please note there are certain configuration settings you can modify using the original image:

- Settings that can be adapted using environment variables. For instance, you can change the ports used by Apache for HTTP and HTTPS, by setting the environment variables `APACHE_HTTP_PORT_NUMBER` and `APACHE_HTTPS_PORT_NUMBER` respectively.
- [Adding custom virtual hosts](#adding-custom-virtual-hosts).
- [Replacing the 'httpd.conf' file](#full-configuration).
- [Using custom SSL certificates](#using-custom-ssl-certificates).

If your desired customizations cannot be covered using the methods mentioned above, extend the image. To do so, create your own image using a Dockerfile with the format below:

```Dockerfile
FROM bitnami/apache
## Put your customizations below
...
```

Here is an example of extending the image with the following modifications:

- Install the `vim` editor
- Modify the Apache configuration file
- Modify the ports used by Apache
- Change the user that runs the container

```Dockerfile
FROM bitnami/apache
LABEL maintainer "Bitnami <containers@bitnami.com>"

## Change user to perform privileged actions
USER 0
## Install 'vim'
RUN install_packages vim
## Revert to the original non-root user
USER 1001

## Enable mod_ratelimit module
RUN sed -i -r 's/#LoadModule ratelimit_module/LoadModule ratelimit_module/' /opt/bitnami/apache/conf/httpd.conf

## Modify the ports used by Apache by default
# It is also possible to change these environment variables at runtime
ENV APACHE_HTTP_PORT_NUMBER=8181
EXPOSE 8181 8443

## Modify the default container user
USER 1002
```

Based on the extended image, you can use a Docker Compose file like the one below to add other features:

- Add a custom virtual host
- Add custom certificates
- Clone your web application and serve it through Apache

```yaml
version: '2'

services:
  apache:
    build: .
    ports:
      - '80:8181'
      - '443:8443'
    depends_on:
      - cloner
    volumes:
      - ./config/my_vhost.conf:/vhosts/my_vhost.conf:ro
      - ./certs:/certs
      - data:/app
  cloner:
    image: 'bitnami/git:latest'
    command:
      - clone
      - https://github.com/cloudacademy/static-website-example
      - /app
    volumes:
      - data:/app
volumes:
  data:
    driver: local
```

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of Apache, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```console
$ docker pull bitnami/apache:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/apache:latest`.

### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
$ docker stop apache
```

or using Docker Compose:

```console
$ docker-compose stop apache
```

Next, take a snapshot of the persistent volume `/path/to/apache-persistence` using:

```console
$ rsync -a /path/to/apache-persistence /path/to/apache-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

You can use this snapshot to restore the database state should the upgrade fail.

### Step 3: Remove the currently running container

```console
$ docker rm -v apache
```

or using Docker Compose:

```console
$ docker-compose rm -v apache
```

### Step 4: Run the new image

Re-create your container from the new image.

```console
$ docker run --name apache bitnami/apache:latest
```

or using Docker Compose:

```console
$ docker-compose up apache
```

# Useful Links

- [Create An AMP Development Environment With Bitnami Containers
](https://docs.bitnami.com/containers/how-to/create-amp-environment-containers/)

# Notable Changes

## 2.4.43-debian-10-r66

- Included [Apache PageSpeed Module (`mod_pagespeed`)](https://developers.google.com/speed/pagespeed/module). It is disabled by default. To enable it, uncomment the following lines in `httpd.conf`:

```
#Include conf/pagespeed.conf
#Include conf/pagespeed_libraries.conf
```

- Included [ModSecurity](https://github.com/SpiderLabs/ModSecurity) and [ModSecurity v3 Apache Connector (`mod_security3`)](https://github.com/SpiderLabs/ModSecurity-apache). It is disabled by default. To enable it, mount and enable your custom ModSecurity rules for the virtual hosts, and uncomment the following line in `httpd.conf`:

```
#LoadModule security3_module modules/mod_security3.so
```

## 2.4.41-debian-9-r40 and 2.4.41-ol-7-r42

- Decrease the size of the container. The configuration logic is now based on Bash scripts in the `rootfs/` folder.

## 2.4.39-debian-9-r40 and 2.4.39-ol-7-r50

- This image has been adapted so it's easier to customize. See the [Customize this image](#customize-this-image) section for more information.
- The Apache configuration volume (`/bitnami/apache`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the Apache configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom Apache configuration files are advised to mount a volume for the configuration at `/opt/bitnami/apache/conf`, or mount specific configuration files individually.
- Enabling custom Apache certificates by placing them at `/opt/bitnami/apache/certs` has been deprecated, and support for this functionality will be dropped in the near future. Users wanting to enable custom certificates are advised to mount their certificate files on top of the preconfigured ones at `/certs`. Find an example at [Using custom SSL certificates](#using-custom-ssl-certificates).

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

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-apache/issues/new). For us to provide better support, be sure to include the following information in your issue:

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
