# Bitnami Docker Image for DokuWiki

## What is DokuWiki?

> DokuWiki is a simple to use and highly versatile Open Source wiki software that doesn't require a database. It is loved by users for its clean and readable syntax. The ease of maintenance, backup and integration makes it an administrator's favorite

[https://www.dokuwiki.org/](https://www.dokuwiki.org/)

## TL;DR

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-dokuwiki/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

You can find the default credentials and available configuration options in the [Environment Variables](#environment-variables) section.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.

> This [CVE scan report](https://quay.io/repository/bitnami/dokuwiki?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`20200729`, `20200729-debian-10`, `20200729.0.0`, `20200729.0.0-debian-10-r259`, `latest` (20200729/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-dokuwiki/blob/20200729.0.0-debian-10-r259/20200729/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/dokuwiki GitHub repo](https://github.com/bitnami/bitnami-docker-dokuwiki).

## Get this image

The recommended way to get the Bitnami DokuWiki Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/dokuwiki).

```console
$ docker pull bitnami/dokuwiki:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/dokuwiki/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/dokuwiki:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/dokuwiki:latest 'https://github.com/bitnami/bitnami-docker-dokuwiki.git#master:20200729/debian-10'
```

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/dokuwiki` path. If the mounted directory is empty, it will be initialized on the first run.

The above examples define the Docker volumes named dokuwiki_data. The DokuWiki application state will persist as long as volumes are not removed.

To avoid inadvertent removal of volumes, you can mount host directories as data volumes. Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-dokuwiki/blob/master/docker-compose.yml) file present in this repository:

```diff
   dokuwiki:
     ...
     volumes:
-      - 'dokuwiki_data:/bitnami/dokuwiki'
+      - /path/to/dokuwiki-persistence:/bitnami/dokuwiki
   ...
-volumes:
-  dokuwiki_data:
-    driver: local
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

### Mount host directories as data volumes using the Docker command line

#### Step 1: Create a network (if it does not exist)

```console
$ docker network create dokuwiki-network
```

#### Step 2. Create the DokuWiki container with host volumes

```console
$ docker run -d --name dokuwiki \
  -p 8080:8080 -p 8443:8443 \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --network dokuwiki-network \
  --volume /path/to/dokuwiki-persistence:/bitnami/dokuwiki \
  bitnami/dokuwiki:latest
```

## Configuration

## Environment variables

When you start the DokuWiki image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. If you want to add a new environment variable:

 * For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-dokuwiki/blob/master/docker-compose.yml) file present in this repository:

```yaml
dokuwiki:
  ...
  environment:
    - DOKUWIKI_PASSWORD=my_password
  ...
```

 * For manual execution add a `--env` option with each variable and value:

  ```console
  $ docker run -d --name dokuwiki -p 80:8080 -p 443:8443 \
    --env DOKUWIKI_PASSWORD=my_password \
    --network dokuwiki-tier \
    --volume /path/to/dokuwiki-persistence:/bitnami/dokuwiki \
    bitnami/dokuwiki:latest
  ```

Available environment variables:

##### User and Site configuration

 - `DOKUWIKI_USERNAME`: Dokuwiki application username. Default: **user**
 - `DOKUWIKI_FULL_NAME`: Dokuwiki application user full name. Default: **Full Name**
 - `DOKUWIKI_PASSWORD`: Dokuwiki application password. Default: **bitnami1**
 - `DOKUWIKI_EMAIL`: Dokuwiki application email. Default: **user@example.com**
 - `DOKUWIKI_WIKI_NAME`: Dokuwiki wiki name. Default: **Bitnami DokuWiki**

##### PHP configuration

- `PHP_ENABLE_OPCACHE`: Enable OPcache for PHP scripts. No default.
- `PHP_EXPOSE_PHP`: Enables HTTP header with PHP version. No default.
- `PHP_MAX_EXECUTION_TIME`: Maximum execution time for PHP scripts. No default.
- `PHP_MAX_INPUT_TIME`: Maximum input time for PHP scripts. No default.
- `PHP_MAX_INPUT_VARS`: Maximum amount of input variables for PHP scripts. No default.
- `PHP_MEMORY_LIMIT`: Memory limit for PHP scripts. Default: **256M**
- `PHP_POST_MAX_SIZE`: Maximum size for PHP POST requests. No default.
- `PHP_UPLOAD_MAX_FILESIZE`: Maximum file size for PHP uploads. No default.

## Logging

The Bitnami DokuWiki Docker image sends the container logs to `stdout`. To view the logs:

```console
$ docker logs dokuwiki
```

Or using Docker Compose:

```console
$ docker-compose logs dokuwiki
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Backing up your container

To backup your data, configuration and logs, follow these simple steps:

#### Step 1: Stop the currently running container

```console
$ docker stop dokuwiki
```

Or using Docker Compose:

```console
$ docker-compose stop dokuwiki
```

#### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```console
$ docker run --rm -v /path/to/dokuwiki-backups:/backups --volumes-from dokuwiki busybox \
  cp -a /bitnami/dokuwiki /backups/latest
```

### Restoring a backup

Restoring a backup is as simple as mounting the backup as volumes in the containers.

For the DokuWiki container:

```diff
 $ docker run -d --name  \
   ...
-  --volume /path/to/-persistence:/bitnami/dokuwiki \
+  --volume /path/to/-backups/latest:/bitnami/dokuwiki \
   bitnami/:latest
```

### Upgrade this image

Bitnami provides up-to-date versions of DokuWiki, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the DokuWiki container.

#### Step 1: Get the updated image

```console
$ docker pull bitnami/dokuwiki:latest
```

#### Step 2: Stop the running container

Stop the currently running container using the command

```console
$ docker-compose stop dokuwiki
```

#### Step 3: Take a snapshot of the application state

Follow the steps in [Backing up your container](#backing-up-your-container) to take a snapshot of the current application state.

#### Step 4: Remove the currently running container

Remove the currently running container by executing the following command:

```console
docker-compose rm -v dokuwiki
```

#### Step 5: Run the new image

Update the image tag in `docker-compose.yml` and re-create your container with the new image:

```console
$ docker-compose up -d
```

## Customize this image

The Bitnami DokuWiki Docker image is designed to be extended so it can be used as the base image for your custom web applications.

### Extend this image

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
ENV APACHE_HTTPS_PORT_NUMBER=8143
EXPOSE 8181 8143
```

Based on the extended image, you can update the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-dokuwiki/blob/master/docker-compose.yml) file present in this repository to add other features:

```diff
   dokuwiki:
-    image: bitnami/dokuwiki:latest
+    build: .
     ports:
-      - '80:8080'
-      - '443:8443'
+      - '80:8181'
+      - '443:8143'
     environment:
+      - PHP_MEMORY_LIMIT=512m
     ...
```

## Notable Changes

### 20200729.0.0-debian-10-r6

- Enabled nice/friendly URLs (#52)

### 20180422.4.0-debian-10-r0

- Changed versionioning to be shorter and more similar to the official version name.

### 0.20180422.202005011246-debian-10-r68

- The size of the container image has been decreased.
- The configuration logic is now based on Bash scripts in the *rootfs/* folder.
- The DokuWiki container image has been migrated to a "non-root" user approach. Previously the container ran as the `root` user and the Apache daemon was started as the `daemon` user. From now on, both the container and the Apache daemon run as user `1001`. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile, or `user: root` in `docker-compose.yml`. Consequences:
  - The HTTP/HTTPS ports exposed by the container are now `8080/8443` instead of `80/443`.
  - Backwards compatibility is not guaranteed when data is persisted using docker or docker-compose. We highly recommend migrating the DokuWiki site by exporting its content, and importing it on a new DokuWiki container. Follow the steps in [Backing up your container](#backing-up-your-container) and [Restoring a backup](#restoring-a-backup) to migrate the data between the old and new container.

### 0.20180422.201901061035-debian-9-r114 and 0.20180422.201901061035-ol-7-r128

- This image has been adapted so it's easier to customize. See the [Customize this image](#customize-this-image) section for more information.
- The Apache configuration volume (`/bitnami/apache`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the Apache configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom Apache configuration files are advised to mount a volume for the configuration at `/opt/bitnami/apache/conf`, or mount specific configuration files individually.
- The PHP configuration volume (`/bitnami/php`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the PHP configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom PHP configuration files are advised to mount a volume for the configuration at `/opt/bitnami/php/conf`, or mount specific configuration files individually.
- Enabling custom Apache certificates by placing them at `/opt/bitnami/apache/certs` has been deprecated, and support for this functionality will be dropped in the near future. Users wanting to enable custom certificates are advised to mount their certificate files on top of the preconfigured ones at `/certs`.

### 0.20170219.201708232029-r3

- Custom smileys, available in `lib/images/smileys/local`, are now persisted.
- Address issue [#40](https://github.com/bitnami/bitnami-docker-dokuwiki/issues/40).
- In order to upgrade your image from previous versions, see the workaround provided on issue [#42](https://github.com/bitnami/bitnami-docker-dokuwiki/issues/42).

### 0.20180422.201805030840-r5

- Custom InterWiki shortcut icons, available in `lib/images/interwiki/`, are now persisted.
- Address issue [#40](https://github.com/bitnami/bitnami-docker-dokuwiki/issues/40).
- In order to upgrade your image from previous versions, see the workaround provided on issue [#42](https://github.com/bitnami/bitnami-docker-dokuwiki/issues/42).

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-dokuwiki/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-dokuwiki/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-dokuwiki/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

## License

Copyright (c) 2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
