# What is NGINX Open Source?

> NGINX (pronounced "engine-x") is an open source reverse proxy server for HTTP, HTTPS, SMTP, POP3 and IMAP protocols, as well as a load balancer, HTTP cache, and a web server (origin server).

[http://nginx.org/](http://nginx.org/)

# TL;DR

```console
$ docker run --name nginx bitnami/nginx:latest
```

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-nginx/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/nginx?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy NGINX Open Source in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami NGINX Open Source Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/nginx).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`1.20`, `1.20-debian-10`, `1.20.0`, `1.20.0-debian-10-r24` (1.20/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-nginx/blob/1.20.0-debian-10-r24/1.20/debian-10/Dockerfile)
* [`1.19`, `1.19-debian-10`, `1.19.10`, `1.19.10-debian-10-r31`, `latest` (1.19/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-nginx/blob/1.19.10-debian-10-r31/1.19/debian-10/Dockerfile)
* [`1.18`, `1.18-debian-10`, `1.18.0`, `1.18.0-debian-10-r349` (1.18/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-nginx/blob/1.18.0-debian-10-r349/1.18/debian-10/Dockerfile)

# Get this image

The recommended way to get the Bitnami NGINX Open Source Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/nginx).

```console
$ docker pull bitnami/nginx:latest
```

To use a specific version, you can pull a versioned tag. You can view the
[list of available versions](https://hub.docker.com/r/bitnami/nginx/tags/)
in the Docker Hub Registry.

```console
$ docker pull bitnami/nginx:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/nginx:latest 'https://github.com/bitnami/bitnami-docker-nginx.git#master:1.19/debian-10'
```

# Hosting a static website

This NGINX Open Source image exposes a volume at `/app`. Content mounted here is served by the default catch-all server block.

```console
$ docker run -v /path/to/app:/app bitnami/nginx:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-nginx/blob/master/docker-compose.yml) file present in this repository:


```yaml
services:
  nginx:
  ...
    volumes:
      - /path/to/app:/app
  ...
```

# Accessing your server from the host

To access your web server from your host machine you can ask Docker to map a random port on your host to ports `8080` and `8443` exposed in the container.

```console
$ docker run --name nginx -P bitnami/nginx:latest
```

Run `docker port` to determine the random ports Docker assigned.

```console
$ docker port nginx
8080/tcp -> 0.0.0.0:32769
```

You can also manually specify the ports you want forwarded from your host to the container.

```console
$ docker run -p 9000:8080 bitnami/nginx:latest
```

Access your web server in the browser by navigating to [http://localhost:9000](http://localhost:9000/).

# Configuration

## Adding custom server blocks

The default `nginx.conf` includes server blocks placed in `/opt/bitnami/nginx/conf/server_blocks/`. You can mount a `my_server_block.conf` file containing your custom server block at this location.

For example, in order add a server block for `www.example.com`:

# Step 1: Write your `my_server_block.conf` file with the following content.

```nginx
server {
  listen 0.0.0.0:8080;
  server_name www.example.com;
  root /app;
  index index.htm index.html;
}
```

# Step 2: Mount the configuration as a volume.

```console
$ docker run --name nginx \
  -v /path/to/my_server_block.conf:/opt/bitnami/nginx/conf/server_blocks/my_server_block.conf:ro \
  bitnami/nginx:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-nginx/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  nginx:
  ...
    volumes:
      - /path/to/my_server_block.conf:/opt/bitnami/nginx/conf/server_blocks/my_server_block.conf:ro
  ...
```

## Using custom SSL certificates

*NOTE:* The steps below assume that you are using a custom domain name and that you have already configured the custom domain name to point to your server.

### Step 1: Prepare your certificate files

In your local computer, create a folder called `certs` and put your certificates files. Make sure you rename both files to `server.crt` and `server.key` respectively:

```console
$ mkdir -p /path/to/nginx-persistence/certs
$ cp /path/to/certfile.crt /path/to/nginx-persistence/certs/server.crt
$ cp /path/to/keyfile.key  /path/to/nginx-persistence/certs/server.key
```

### Step 2: Provide a custom Server Block for SSL connections

Write your `my_server_block.conf` file with the SSL configuration and the relative path to the certificates:

```nginx
  server {
    listen       8443 ssl;

    ssl_certificate      bitnami/certs/server.crt;
    ssl_certificate_key  bitnami/certs/server.key;

    ssl_session_cache    shared:SSL:1m;
    ssl_session_timeout  5m;

    ssl_ciphers  HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers  on;

    location / {
      root   html;
      index  index.html index.htm;
    }
  }
```

### Step 3: Run the NGINX Open Source image and open the SSL port

Run the NGINX Open Source image, mounting the certificates directory from your host.

```console
$ docker run --name nginx \
  -v /path/to/my_server_block.conf:/opt/bitnami/nginx/conf/server_blocks/my_server_block.conf:ro \
  -v /path/to/nginx-persistence/certs:/certs \
  bitnami/nginx:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-nginx/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  nginx:
  ...
    volumes:
    - /path/to/nginx-persistence/certs:/certs
    - /path/to/my_server_block.conf:/opt/bitnami/nginx/conf/server_blocks/my_server_block.conf:ro
  ...
```

## Full configuration

The image looks for configurations in `/opt/bitnami/nginx/conf/nginx.conf`. You can overwrite the `nginx.conf` file using your own custom configuration file.


```console
$ docker run --name nginx \
  -v /path/to/your_nginx.conf:/opt/bitnami/nginx/conf/nginx.conf:ro \
  bitnami/nginx:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-nginx/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  nginx:
  ...
    volumes:
      - /path/to/your_nginx.conf:/opt/bitnami/nginx/conf/nginx.conf:ro
  ...
```

# Reverse proxy to other containers

NGINX can be used to reverse proxy to other containers using Docker's linking system. This is particularly useful if you want to serve dynamic content through an NGINX frontend. To do so, [add a server block](#adding-custom-server-blocks) like the following in the `/opt/bitnami/nginx/conf/server_blocks/` folder:

```nginx
server {
    listen 0.0.0.0:8080;
    server_name yourapp.com;
    access_log /opt/bitnami/nginx/logs/yourapp_access.log;
    error_log /opt/bitnami/nginx/logs/yourapp_error.log;

    location / {
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header HOST $http_host;
        proxy_set_header X-NginX-Proxy true;

        proxy_pass http://[your_container_alias]:[your_container_port];
        proxy_redirect off;
    }
}
```

**Further Reading:**

  - [NGINX reverse proxy](http://nginx.com/resources/admin-guide/reverse-proxy/)

# Logging

The Bitnami NGINX Open Source Docker image sends the container logs to the `stdout`. To view the logs:

```console
$ docker logs nginx
```

or using Docker Compose:

```console
$ docker-compose logs nginx
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Understand the structure of this image

The Bitnami NGINX Open Source Docker image is built using a Dockerfile with the structure below:

```Dockerfile
FROM bitnami/minideb
...
# Install required system packages and dependencies
RUN install_packages xxx yyy zzz
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "nginx" "a.b.c-0"
...
COPY rootfs /
RUN /opt/bitnami/scripts/nginx/postunpack.sh
...
ENV BITNAMI_APP_NAME="nginx" ...
EXPOSE 8080 8443
WORKDIR /app
USER 1001
...
ENTRYPOINT [ "/opt/bitnami/scripts/nginx/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/nginx/run.sh" ]
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

The Bitnami NGINX Open Source Docker image is designed to be extended so it can be used as the base image for your custom web applications.

> Note: Read the [previous section](#understand-the-structure-of-this-image) to understand the Dockerfile structure before extending this image.

## Extend this image

Before extending this image, please note there are certain configuration settings you can modify using the original image:

- Settings that can be adapted using environment variables. For instance, you can change the port used by NGINX for HTTP setting the environment variable `NGINX_HTTP_PORT_NUMBER`.
- [Adding custom server blocks](#adding-custom-server-blocks).
- [Replacing the 'nginx.conf' file](#full-configuration).
- [Using custom SSL certificates](#using-custom-ssl-certificates).

If your desired customizations cannot be covered using the methods mentioned above, extend the image. To do so, create your own image using a Dockerfile with the format below:

```Dockerfile
FROM bitnami/nginx
## Put your customizations below
...
```

Here is an example of extending the image with the following modifications:

- Install the `vim` editor
- Modify the NGINX configuration file
- Modify the ports used by NGINX
- Change the user that runs the container

```Dockerfile
FROM bitnami/nginx
LABEL maintainer "Bitnami <containers@bitnami.com>"

## Change user to perform privileged actions
USER 0
## Install 'vim'
RUN install_packages vim
## Revert to the original non-root user
USER 1001

## Modify 'worker_connections' on NGINX config file to '512'
RUN sed -i -r "s#(\s+worker_connections\s+)[0-9]+;#\1512;#" /opt/bitnami/nginx/conf/nginx.conf

## Modify the ports used by NGINX by default
ENV NGINX_HTTP_PORT_NUMBER=8181 # It is also possible to change this environment variable at runtime
EXPOSE 8181 8143

## Modify the default container user
USER 1002
```

Based on the extended image, you can use a Docker Compose file like the one below to add other features:

- Add a custom server block
- Add custom certificates
- Clone your web application and serve it through NGINX

```yaml
version: '2'

services:
  nginx:
    build: .
    ports:
      - '80:8181'
      - '443:8443'
    depends_on:
      - cloner
    volumes:
      - ./config/my_server_block.conf:/opt/bitnami/nginx/conf/conf.d/server_blocks/my_server_block.conf:ro
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

### Adding custom NGINX modules

To add a custom NGINX module, it is necessary to compile NGINX with that module and copy over the appropriate files to the Bitnami image.

#### Example

Below is an example Dockerfile to build and install the NGINX Perl module (`ngx_http_perl_module`) over to the Bitnami image:

```Dockerfile
ARG NGINX_VERSION=1.19.6
ARG BITNAMI_NGINX_REVISION=r0
ARG BITNAMI_NGINX_TAG=${NGINX_VERSION}-debian-10-${BITNAMI_NGINX_REVISION}

FROM bitnami/nginx:${BITNAMI_NGINX_TAG} AS builder
USER root
# Redeclare NGINX_VERSION so it can be used as a parameter inside this build stage
ARG NGINX_VERSION
# Install required packages and build dependencies
RUN install_packages dirmngr gpg gpg-agent curl build-essential libpcre3-dev zlib1g-dev libperl-dev
# Add trusted NGINX PGP key for tarball integrity verification
RUN gpg --keyserver pgp.mit.edu --recv-key 520A9993A1C052F8
# Download NGINX, verify integrity and extract
RUN cd /tmp && \
    curl -O http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    curl -O http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz.asc && \
    gpg --verify nginx-${NGINX_VERSION}.tar.gz.asc nginx-${NGINX_VERSION}.tar.gz && \
    tar xzf nginx-${NGINX_VERSION}.tar.gz
# Compile NGINX with desired module
RUN cd /tmp/nginx-${NGINX_VERSION} && \
    rm -rf /opt/bitnami/nginx && \
    ./configure --prefix=/opt/bitnami/nginx --with-compat --with-http_perl_module=dynamic && \
    make && \
    make install

FROM bitnami/nginx:${BITNAMI_NGINX_TAG}
USER root
# Install ngx_http_perl_module system package dependencies
RUN install_packages libperl-dev
# Install ngx_http_perl_module files
COPY --from=builder /usr/local/lib/x86_64-linux-gnu/perl /usr/local/lib/x86_64-linux-gnu/perl
COPY --from=builder /opt/bitnami/nginx/modules/ngx_http_perl_module.so /opt/bitnami/nginx/modules/ngx_http_perl_module.so
# Enable module
RUN echo "load_module modules/ngx_http_perl_module.so;" | cat - /opt/bitnami/nginx/conf/nginx.conf > /tmp/nginx.conf && \
    cp /tmp/nginx.conf /opt/bitnami/nginx/conf/nginx.conf
# Set the container to be run as a non-root user by default
USER 1001
```

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of NGINX Open Source, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```console
$ docker pull bitnami/nginx:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/nginx:latest`.

### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
$ docker stop nginx
```

or using Docker Compose:

```console
$ docker-compose stop nginx
```

### Step 3: Remove the currently running container

```console
$ docker rm -v nginx
```

or using Docker Compose:

```console
$ docker-compose rm -v nginx
```

### Step 4: Run the new image

Re-create your container from the new image.

```console
$ docker run --name nginx bitnami/nginx:latest
```

or using Docker Compose:

```console
$ docker-compose up nginx
```

# Useful Links

- [Create An EMP Development Environment With Bitnami Containers](https://docs.bitnami.com/containers/how-to/create-emp-environment-containers/)

# Notable Changes

## 1.18.0-debian-10-r210 and 1.19.6-debian-10-r1

- Added support for enabling dynamic modules.

## 1.16.1-centos-7-r173

- `1.16.1-centos-7-r173` is considered the latest image based on CentOS.
- Standard supported distros: Debian & OEL.

## 1.16.0-r3

- This image has been adapted so it's easier to customize. See the [Customize this image](#customize-this-image) section for more information.
- The recommended mount point for adding custom server blocks changes from `/opt/bitnami/nginx/conf/vhosts` to `/opt/bitnami/nginx/conf/server_blocks`. Remember to update your Docker Compose files to user the new mount point.

# Branch Deprecation Notice

NGINX Open Source's branch 1.18 is no longer maintained by upstream and is now internally tagged as to be deprecated. This branch will no longer be released in our catalog a month after this notice is published, but already released container images will still persist in the registries. Valid to be removed starting on: 05-27-2021

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-nginx/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-nginx/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-nginx/issues/new). For us to provide better support, be sure to include the following information in your issue:

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
