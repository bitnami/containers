
# What is DokuWiki?

> DokuWiki is a simple to use and highly versatile Open Source wiki software that doesn't require a database. It is loved by users for its clean and readable syntax. The ease of maintenance, backup and integration makes it an administrator's favorite

https://www.dokuwiki.org/

# TL;DR;

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-dokuwiki/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DTC)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/dokuwiki?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy DokuWiki in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami DokuWiki Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/dokuwiki).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`0-debian-10`, `0.20180422.202005011246-debian-10-r4`, `0`, `0.20180422.202005011246`, `latest` (0/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-dokuwiki/blob/0.20180422.202005011246-debian-10-r4/0/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/dokuwiki GitHub repo](https://github.com/bitnami/bitnami-docker-dokuwiki).


# Prerequisites

To run this application you need Docker Engine 1.10.0. Docker Compose is recomended with a version 1.6.0 or later.

# How to use this image

### Run the application using Docker Compose

The main folder of this repository contains a functional [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-dokuwiki/blob/master/docker-compose.yml) file. Run the application using it as shown below:

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-dokuwiki/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

### Run the application manually

If you want to run the application manually instead of using docker-compose, these are the basic steps you need to run:

1. Create a new network for the application :

  ```console
  $ docker network create dokuwiki-tier
  ```

2. Run the Dokuwiki container:

  ```console
  $ docker run -d \
    -p 80:80 -p 443:443 --name dokuwiki --net dokuwiki-tier \
    bitnami/dokuwiki:latest
  ```

Then you can access your application at http://your-ip/

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. The above examples define a docker volume namely `dokuwiki_data`. The DokuWiki application state will persist as long as this volume is not removed.

To avoid inadvertent removal of this volume you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount persistent folders in the host using docker-compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-dokuwiki/blob/master/docker-compose.yml) file present in this repository:

```yaml
dokuwiki:
  ...
  volumes:
    - '/path/to/dokuwiki-persistence:/bitnami'
  ...
```

### Mount persistent folders manually

In this case you need to specify the directories to mount on the run command. The process is the same than the one previously shown:

1. If you haven't done this before, create a new network for the application :

  ```console
  $ docker network create dokuwiki-tier
  ```

2. Run the Dokuwiki container:

  ```console
  $ docker run -d -p 80:80 -p 443:443 --name dokuwiki \
    --net dokuwiki-tier \
    --volume /path/to/dokuwiki-persistence:/bitnami \
    bitnami/dokuwiki:latest
  ```

# Upgrade this application

Bitnami provides up-to-date versions of Dokuwiki, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the Dokuwiki container.

1. Get the updated images:

```console
$ docker pull bitnami/dokuwiki:latest
```

2. Stop your container

 * For docker-compose: `$ docker-compose stop dokuwiki`
 * For manual execution: `$ docker stop dokuwiki`

3. Take a snapshot of the application state

```console
$ rsync -a /path/to/dokuwiki-persistence /path/to/dokuwiki-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

You can use this snapshot to restore the application state should the upgrade fail.

4. Remove the stopped container

 * For docker-compose: `$ docker-compose rm -v dokuwiki`
 * For manual execution: `$ docker rm -v dokuwiki`

5. Run the new image

 * For docker-compose: `$ docker-compose up dokuwiki`
 * For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name dokuwiki bitnami/dokuwiki:latest`

# Configuration

## Environment variables

When you start the DokuWiki image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. If you want to add a new environment variable:

 * Modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-dokuwiki/blob/master/docker-compose.yml) file present in this repository:

  ```yaml
  dokuwiki:
    ...
    environment:
      - DOKUWIKI_PASSWORD=my_password
    ...
  ```

 * For manual execution add a `-e` option with each variable and value:

  ```console
  $ docker run -d -p 80:80 -p 443:443 --name dokuwiki \
    -e DOKUWIKI_PASSWORD=my_password \
    --net dokuwiki-tier \
    --volume /path/to/dokuwiki-persistence:/bitnami/dokuwiki \
    bitnami/dokuwiki:latest
  ```

Available variables:

 - `DOKUWIKI_USERNAME`: Dokuwiki application SuperUser name. Default: **superuser**
 - `DOKUWIKI_FULL_NAME`: Dokuwiki SuperUser Full Name. Default: **Full Name**
 - `DOKUWIKI_PASSWORD`: Dokuwiki application password. Default: **bitnami1**
 - `DOKUWIKI_EMAIL`: Dokuwiki application email. Default: **user@example.com**
 - `DOKUWIKI_WIKI_NAME`: Dokuwiki wiki name. Default: **Bitnami DokuWiki**
 - `PHP_MEMORY_LIMIT`: Memory limit for PHP. Default: **256M**

# Customize this image

The Bitnami Dokuwiki Docker image is designed to be extended so it can be used as the base image for your custom web applications.

## Extend this image

Before extending this image, please note there are certain configuration settings you can modify using the original image:

- Settings that can be adapted using environment variables. For instance, you can change the ports used by Apache for HTTP and HTTPS, by setting the environment variables `APACHE_HTTP_PORT_NUMBER` and `APACHE_HTTPS_PORT_NUMBER` respectively.
- [Adding custom virtual hosts](https://github.com/bitnami/bitnami-docker-apache#adding-custom-virtual-hosts).
- [Replacing the 'httpd.conf' file](https://github.com/bitnami/bitnami-docker-apache#full-configuration).
- [Using custom SSL certificates](https://github.com/bitnami/bitnami-docker-apache#using-custom-ssl-certificates).

If your desired customizations cannot be covered using the methods mentioned above, extend the image. To do so, create your own image using a Dockerfile with the format below:

```Dockerfile
FROM bitnami/dokuwiki
## Put your customizations below
...
```

Here is an example of extending the image with the following modifications:

- Install the `vim` editor
- Modify the Apache configuration file
- Modify the ports used by Apache

```Dockerfile
FROM bitnami/dokuwiki
LABEL maintainer "Bitnami <containers@bitnami.com>"

## Install 'vim'
RUN install_packages vim

## Enable mod_ratelimit module
RUN sed -i -r 's/#LoadModule ratelimit_module/LoadModule ratelimit_module/' /opt/bitnami/apache/conf/httpd.conf

## Modify the ports used by Apache by default
# It is also possible to change these environment variables at runtime
ENV APACHE_HTTP_PORT_NUMBER=8181 
ENV APACHE_HTTPS_PORT_NUMBER=8143
EXPOSE 8181 8143
```

Based on the extended image, you can use a Docker Compose file like the one below to add other features:

```yaml
version: '2'
services:
  dokuwiki:
    build: .
    ports:
      - '80:8181'
      - '443:8143'
    volumes:
      - 'dokuwiki_data:/bitnami'
volumes:
  dokuwiki_data:
    driver: local
```
 
# Notable Changes

## 0.20180422.201901061035-debian-9-r114 and 0.20180422.201901061035-ol-7-r128

- This image has been adapted so it's easier to customize. See the [Customize this image](#customize-this-image) section for more information.
- The Apache configuration volume (`/bitnami/apache`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the Apache configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom Apache configuration files are advised to mount a volume for the configuration at `/opt/bitnami/apache/conf`, or mount specific configuration files individually.
- The PHP configuration volume (`/bitnami/php`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the PHP configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom PHP configuration files are advised to mount a volume for the configuration at `/opt/bitnami/php/conf`, or mount specific configuration files individually. 
- Enabling custom Apache certificates by placing them at `/opt/bitnami/apache/certs` has been deprecated, and support for this functionality will be dropped in the near future. Users wanting to enable custom certificates are advised to mount their certificate files on top of the preconfigured ones at `/certs`. 

## 0.20170219.201708232029-r3

- Custom smileys, available in `lib/images/smileys/local`, are now persisted.
- Address issue [#40](https://github.com/bitnami/bitnami-docker-dokuwiki/issues/40).
- In order to upgrade your image from previous versions, see the workaround provided on issue [#42](https://github.com/bitnami/bitnami-docker-dokuwiki/issues/42).

## 0.20180422.201805030840-r5

- Custom InterWiki shortcut icons, available in `lib/images/interwiki/`, are now persisted.
- Address issue [#40](https://github.com/bitnami/bitnami-docker-dokuwiki/issues/40).
- In order to upgrade your image from previous versions, see the workaround provided on issue [#42](https://github.com/bitnami/bitnami-docker-dokuwiki/issues/42).

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-dokuwiki/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-dokuwiki/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-dokuwiki/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`$ docker version`)
- Output of `$ docker info`
- Version of this container (`$ echo $BITNAMI_APP_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright 2016-2020 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
