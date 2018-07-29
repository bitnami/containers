[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-nginx/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-nginx/tree/master)

# What is nginx?

> nginx (pronounced "engine-x") is an open source reverse proxy server for HTTP, HTTPS, SMTP, POP3 and IMAP protocols, as well as a load balancer, HTTP cache, and a web server (origin server).

[http://nginx.org/](nginx.org)

# TL;DR;

```bash
$ docker run --name nginx bitnami/nginx:latest
```

## Docker Compose

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-nginx/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* Bitnami images are built on CircleCI and automatically pushed to the Docker Hub.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.

# Supported tags and respective `Dockerfile` links

> NOTE: Debian 8 images have been deprecated in favor of Debian 9 images. Bitnami will not longer publish new Docker images based on Debian 8.


* [`1.14-rhel-7`, `1.14.0-rhel-7-r6` (1.14/rhel-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-nginx/blob/1.14.0-rhel-7-r6/1.14/rhel-7/Dockerfile)
* [`1.14-ol-7`, `1.14.0-ol-7-r43` (1.14/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-nginx/blob/1.14.0-ol-7-r43/1.14/ol-7/Dockerfile)
* [`1.14-debian-9`, `1.14.0-debian-9-r22`, `1.14`, `1.14.0`, `1.14.0-r22`, `latest` (1.14/Dockerfile)](https://github.com/bitnami/bitnami-docker-nginx/blob/1.14.0-debian-9-r22/1.14/Dockerfile)
* [`1.14-bash-debian-9`, `1.14.0-bash-debian-9-r0`, `1.14-bash`, `1.14.0-bash`, `1.14.0-bash-r0` (1.14-bash/Dockerfile)](https://github.com/bitnami/bitnami-docker-nginx/blob/1.14.0-bash-debian-9-r0/1.14-bash/Dockerfile)

# Get this image

The recommended way to get the Bitnami nginx Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/nginx).

```bash
$ docker pull bitnami/nginx:latest
```

To use a specific version, you can pull a versioned tag. You can view the
[list of available versions](https://hub.docker.com/r/bitnami/nginx/tags/)
in the Docker Hub Registry.

```bash
$ docker pull bitnami/nginx:[TAG]
```

If you wish, you can also build the image yourself.

```bash
$ docker build -t bitnami/nginx:latest https://github.com/bitnami/bitnami-docker-nginx.git
```

# Hosting a static website

This nginx image exposes a volume at `/app`. Content mounted here is served by the default catch-all virtual host.

```bash
$ docker run -v /path/to/app:/app bitnami/nginx:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  nginx:
    image: 'bitnami/nginx:latest'
    ports:
      - '80:8080'
      - '443:8443'
    volumes:
      - /path/to/app:/app
```

# Accessing your server from the host

To access your web server from your host machine you can ask Docker to map a random port on your host to ports `8080` and `8443` exposed in the container.

```bash
$ docker run --name nginx -P bitnami/nginx:latest
```

Run `docker port` to determine the random ports Docker assigned.

```bash
$ docker port nginx
8443/tcp -> 0.0.0.0:32768
8080/tcp -> 0.0.0.0:32769
```

You can also manually specify the ports you want forwarded from your host to the container.

```bash
$ docker run -p 9000:8080 -p 9443:8443 bitnami/nginx:latest
```

Access your web server in the browser by navigating to [http://localhost:9000](http://localhost:9000/).

# Configuration

## Adding custom virtual hosts

The default `nginx.conf` includes virtual hosts placed in `/bitnami/nginx/conf/vhosts/`. You can mount a `my_vhost.conf` file containing your custom virtual hosts at this location.

For example, in order add a vhost for `www.example.com`:

# Step 1: Write your `my_vhost.conf` file with the following content.

```nginx
server {
  listen 0.0.0.0:8080;
  server_name www.example.com;
  root /app;
  index index.htm index.html;
}
```

# Step 2: Mount the configuration as a volume.

```bash
$ docker run --name nginx \
  -v /path/to/my_vhost.conf:/bitnami/nginx/conf/vhosts/my_vhost.conf:ro \
  bitnami/nginx:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  mariadb:
    image: 'bitnami/nginx:latest'
    ports:
      - '80:8080'
      - '443:8443'
    volumes:
      - /path/to/my_vhost.conf:/bitnami/nginx/conf/vhosts/my_vhost.conf:ro
```

## Using custom SSL certificates

*NOTE:* The steps below assume that you are using a custom domain name and that you have already configured the custom domain name to point to your server.

This container comes with SSL support already pre-configured and with a dummy certificate in place (`server.crt` and `server.key` files in `/bitnami/nginx/conf/bitnami/certs`). If you want to use your own certificate (`.crt`) and certificate key (`.key`) files, follow the steps below:

### Step 1: Prepare your certificate files

In your local computer, create a folder called `certs` and put your certificates files. Make sure you rename both files to `server.crt` and `server.key` respectively:

```bash
$ mkdir /path/to/nginx-persistence/nginx/conf/bitnami/certs -p
$ cp /path/to/certfile.crt /path/to/nginx-persistence/nginx/conf/bitnami/certs/server.crt
$ cp /path/to/keyfile.key  /path/to/nginx-persistence/nginx/conf/bitnami/certs/server.key
```

### Step 2: Run the Nginx image

Run the Nginx image, mounting the certificates directory from your host.

```bash
$ docker run --name nginx \
  -v /path/to/nginx-persistence/nginx/conf/bitnami/certs:/bitnami/nginx/conf/bitnami/certs \
  bitnami/nginx:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  nginx:
    image: 'bitnami/nginx:latest'
    ports:
    - '80:8080'
    - '443:8443'
    volumes:
    - /path/to/nginx-persistence/nginx/conf/bitnami/certs:/bitnami/nginx/conf/bitnami/certs
```

## Full configuration

The image looks for configurations in `/bitnami/nginx/conf/`. You can mount a volume at `/bitnami` and copy/edit the configurations in the `/bitnami/nginx/conf/`. The default configurations will be populated in the `conf/` directory if it's empty.

### Step 1: Run the nginx image

Run the nginx image, mounting a directory from your host.

```bash
$ docker run --name nginx \
  -v /path/to/nginx-persistence:/bitnami \
  bitnami/nginx:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  nginx:
    image: 'bitnami/nginx:latest'
    ports:
      - '80:8080'
      - '443:8443'
    volumes:
      - /path/to/nginx-persistence:/bitnami
```

### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```bash
$ vi /path/to/nginx-persistence/nginx/conf/nginx.conf
```

### Step 4: Restart nginx

After changing the configuration, restart your nginx container for changes to take effect.

```bash
$ docker restart nginx
```

or using Docker Compose:

```bash
$ docker-compose restart nginx
```

# Reverse proxy to other containers

nginx can be used to reverse proxy to other containers using Docker's linking system. This is particularly useful if you want to serve dynamic content through an nginx frontend. Bitnami provides example virtual hosts for all of our runtime containers in `/bitnami/nginx/conf/vhosts/`.

**Further Reading:**

  - [nginx reverse proxy](http://nginx.com/resources/admin-guide/reverse-proxy/)

# Logging

The Bitnami nginx Docker image sends the container logs to the `stdout`. To view the logs:

```bash
$ docker logs nginx
```

or using Docker Compose:

```bash
$ docker-compose logs nginx
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of nginx, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
$ docker pull bitnami/nginx:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/nginx:latest`.

### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```bash
$ docker stop nginx
```

or using Docker Compose:

```bash
$ docker-compose stop nginx
```

Next, take a snapshot of the persistent volume `/path/to/nginx-persistence` using:

```bash
$ rsync -a /path/to/nginx-persistence /path/to/nginx-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

You can use this snapshot to restore the database state should the upgrade fail.

### Step 3: Remove the currently running container

```bash
$ docker rm -v nginx
```

or using Docker Compose:

```bash
$ docker-compose rm -v nginx
```

### Step 4: Run the new image

Re-create your container from the new image.

```bash
$ docker run --name nginx bitnami/nginx:latest
```

or using Docker Compose:

```bash
$ docker-compose up nginx
```

# Useful Links

- [Create An EMP Development Environment With Bitnami Containers
](https://docs.bitnami.com/containers/how-to/create-emp-environment-containers/)

# Notable Changes

## 1.12.1-r2

- The nginx container has been migrated to a non-root container approach. Previously the container run as `root` user and the nginx daemon was started as `nginx` user. From now on, both the container and the nginx daemon run as user `1001`.
  As a consequence, the configuration files are writable by the user running the nginx process.

## 1.10.0-r0

- The configuration volume has been moved to `/bitnami/nginx`. Now you only need to mount a single volume at `/bitnami/nginx` for persisting configuration. `/app` is still used for serving content by the default virtual host.
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
