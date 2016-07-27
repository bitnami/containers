[![Build Status](http://bitnami-container-builds.bitnamiapp.com/jenkins/buildStatus/icon?job=docker-nginx)](http://bitnami-container-builds.bitnamiapp.com/jenkins/job/docker-nginx/)

# What is nginx?

> nginx (pronounced "engine-x") is an open source reverse proxy server for HTTP, HTTPS, SMTP, POP3 and IMAP protocols, as well as a load balancer, HTTP cache, and a web server (origin server).

[http://nginx.org/](nginx.org)

# TLDR

```bash
docker run --name nginx bitnami/nginx:latest
```

## Docker Compose

```yaml
nginx:
  image: bitnami/nginx:latest
```

# Get this image

The recommended way to get the Bitnami nginx Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/nginx).

```bash
docker pull bitnami/nginx:latest
```

To use a specific version, you can pull a versioned tag. You can view the
[list of available versions](https://hub.docker.com/r/bitnami/nginx/tags/)
in the Docker Hub Registry.

```bash
docker pull bitnami/nginx:[TAG]
```

If you wish, you can also build the image yourself.

```bash
docker build -t bitnami/nginx:latest https://github.com/bitnami/bitnami-docker-nginx.git
```

# Hosting a static website

This nginx image exposes a volume at `/app`. Content mounted here is served by the default catch-all virtual host.

```bash
docker run -v /path/to/app:/app bitnami/nginx:latest
```

or using Docker Compose:

```yaml
nginx:
  image: bitnami/nginx:latest
  volumes:
    - /path/to/app:/app
```

# Accessing your server from the host

To access your web server from your host machine you can ask Docker to map a random port on your host to ports `80` and `443` exposed in the container.

```bash
docker run --name nginx -P bitnami/nginx:latest
```

Run `docker port` to determine the random ports Docker assigned.

```bash
$ docker port nginx
443/tcp -> 0.0.0.0:32768
80/tcp -> 0.0.0.0:32769
```

You can also manually specify the ports you want forwarded from your host to the container.

```bash
docker run -p 8080:80 -p 8443:443 bitnami/nginx:latest
```

Access your web server in the browser by navigating to [http://localhost:8080](http://localhost:8080/).

# Configuration

## Adding custom virtual hosts

The default nginx.conf includes virtual hosts placed in `/bitnami/nginx/conf/vhosts/*.conf`. You can mount a directory at `/bitnami/nginx/conf/vhosts` from your host containing your custom virtual hosts.

```bash
docker run -v /path/to/nginx-persistence/vhosts:/bitnami/nginx/conf/vhosts bitnami/nginx:latest
```

or using Docker Compose:

```yaml
nginx:
  image: bitnami/nginx:latest
  volumes:
    - /path/to/nginx-persistence/vhosts:/bitnami/nginx/conf/vhosts
```

## Full configuration

This container looks for configuration in `/bitnami/nginx/conf`. You can mount a directory at `/bitnami/nginx/` with your own configuration, or the default configuration will be copied to your directory at `conf/` if it's empty.

### Step 1: Run the nginx image

Run the nginx image, mounting a directory from your host.

```bash
docker run --name nginx -v /path/to/nginx-persistence:/bitnami/nginx bitnami/nginx:latest
```

or using Docker Compose:

```yaml
nginx:
  image: bitnami/nginx:latest
  volumes:
    - /path/to/nginx-persistence:/bitnami/nginx
```

### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```bash
vi /path/to/nginx-persistence/conf/nginx.conf
```

### Step 4: Restart nginx

After changing the configuration, restart your nginx container for changes to take effect.

```bash
docker restart nginx
```

or using Docker Compose:

```bash
docker-compose restart nginx
```

## Enabling Pagespeed module

This image includes the Pagespeed module for nginx.

In order to activate it, mount the configuration volume following the steps in [Full Configuration](#full-configuration) section above and edit the file located at `/path/to/nginx-persistence/conf/bitnami/bitnami.conf` adding the following snippet inside the `server` directive:

```
    pagespeed on;
    # needs to exist and be writable by nginx
    pagespeed FileCachePath /installdir/nginx/var/ngx_pagespeed_cache;
    location ~ "\.pagespeed\.([a-z]\.)?[a-z]{2}\.[^.]{10}\.[^.]+" { add_header "" ""; }
    location ~ "^/ngx_pagespeed_static/" { }
    location ~ "^/ngx_pagespeed_beacon$" { }
    location /ngx_pagespeed_statistics { allow 127.0.0.1; deny all; }
    location /ngx_pagespeed_message { allow 127.0.0.1; deny all; }
```

Then, restart nginx or reload its configuration following the steps in the [Restart nginx](#step-4-restart-nginx) section.

# Reverse proxy to other containers

nginx can be used to reverse proxy to other containers using Docker's linking system. This is particularly useful if you want to serve dynamic content through an nginx frontend. Bitnami provides example virtual hosts for all of our runtime containers in `/bitnami/nginx/conf/vhosts/`.

**Further Reading:**

  - [nginx reverse proxy](http://nginx.com/resources/admin-guide/reverse-proxy/)

# Logging

The Bitnami nginx Docker image sends the container logs to the `stdout`. To view the logs:

```bash
docker logs nginx
```

or using Docker Compose:

```bash
docker-compose logs nginx
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Backing up your container

To backup your nginx configurations, follow these simple steps:

### Step 1: Stop the currently running container

```bash
docker stop nginx
```

or using Docker Compose:

```bash
docker-compose stop nginx
```

### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```bash
docker run --rm -v /path/to/nginx-backups:/backups \
  --volumes-from nginx busybox:latest \
    cp -a /bitnami/nginx /backups/latest
```

or using Docker Compose:

```bash
docker run --rm -v /path/to/nginx-backups:/backups \
  --volumes-from `docker-compose ps -q nginx` busybox:latest \
    cp -a /bitnami/nginx /backups/latest
```

## Restoring a backup

Restoring a backup is as simple as mounting the backup as volumes in the container.

```bash
docker run -v /path/to/nginx-backups/latest:/bitnami/nginx bitnami/nginx:latest
```

or using Docker Compose:

```yaml
nginx:
  image: bitnami/nginx:latest
  volumes:
    - /path/to/nginx-backups/latest:/bitnami/nginx
```

## Upgrade this image

Bitnami provides up-to-date versions of nginx, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
docker pull bitnami/nginx:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/nginx:latest`.

### Step 2: Stop and backup the currently running container

Before continuing, you should backup your container's configuration and logs.

Follow the steps on [creating a backup](#backing-up-your-container).

### Step 3: Remove the currently running container

```bash
docker rm -v nginx
```

or using Docker Compose:

```bash
docker-compose rm -v nginx
```

### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if necessary.

```bash
docker run --name nginx bitnami/nginx:latest
```

or using Docker Compose:

```bash
docker-compose start nginx
```

# Testing

This image is tested for expected runtime behavior, using the [Bats](https://github.com/sstephenson/bats) testing framework. You can run the tests on your machine using the `bats` command.

```
bats test.sh
```

# Notable Changes

## 1.10.0-r0

- All volumes have been merged at `/bitnami/nginx`. Now you only need to mount a single volume at `/bitnami/nginx` for persistence.
- The logs are always sent to the `stdout` and are no longer collected in the volume.

## 1.8.0-4-r01 (2015-10-05)

- `/app` directory is no longer exported as a volume. This caused problems when building on top of the image, since changes in the volume are not persisted between Dockerfile `RUN` instructions. To keep the previous behavior (so that you can mount the volume in another container), create the container with the `-v /app` option.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-nginx/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-nginx/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-nginx/issues). For us to provide better support, be sure to include the following information in your issue:

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
