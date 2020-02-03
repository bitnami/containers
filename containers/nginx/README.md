# What is NGINX Open Source?

> NGINX (pronounced "engine-x") is an open source reverse proxy server for HTTP, HTTPS, SMTP, POP3 and IMAP protocols, as well as a load balancer, HTTP cache, and a web server (origin server).

[http://nginx.org/](http://nginx.org/)

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
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DTC)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/nginx?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy NGINX Open Source in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami NGINX Open Source Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/nginx).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/containers/how-to/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

> NOTE: Debian 9 images have been deprecated in favor of Debian 10 images. Bitnami will not longer publish new Docker images based on Debian 9.

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/).


* [`1.16-ol-7`, `1.16.1-ol-7-r189` (1.16/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-nginx/blob/1.16.1-ol-7-r189/1.16/ol-7/Dockerfile)
* [`1.16-debian-10`, `1.16.1-debian-10-r9`, `1.16`, `1.16.1`, `latest` (1.16/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-nginx/blob/1.16.1-debian-10-r9/1.16/debian-10/Dockerfile)

# Get this image

The recommended way to get the Bitnami NGINX Open Source Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/nginx).

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
$ docker build -t bitnami/nginx:latest 'https://github.com/bitnami/bitnami-docker-nginx.git#master:1.16/debian-10'
```

# Hosting a static website

This NGINX Open Source image exposes a volume at `/app`. Content mounted here is served by the default catch-all server block.

```bash
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

```bash
$ docker run --name nginx -P bitnami/nginx:latest
```

Run `docker port` to determine the random ports Docker assigned.

```bash
$ docker port nginx
8080/tcp -> 0.0.0.0:32769
```

You can also manually specify the ports you want forwarded from your host to the container.

```bash
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

```bash
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

```bash
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

```bash
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


```bash
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

```
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

```bash
$ docker logs nginx
```

or using Docker Compose:

```bash
$ docker-compose logs nginx
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Understand the structure of this image

The Bitnami NGINX Open Source Docker image is built using a Dockerfile with the structure below:

```Dockerfile
FROM bitnami/minideb-extras-base
...
# Install required system packages and dependencies
RUN install_packages xxx yyy zzz
RUN . ./libcomponent.sh && component_unpack "nginx" "a.b.c-0"
...
COPY rootfs /
RUN /postunpack.sh
...
ENV BITNAMI_APP_NAME="nginx" ...
EXPOSE 8080 8443
WORKDIR /app
USER 1001
...
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
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
- Modify the Apache configuration file
- Modify the ports used by Apache
- Change the user that runs the container

```Dockerfile
FROM bitnami/nginx
LABEL maintainer "Bitnami <containers@bitnami.com>"

## Install 'vim'
USER 0 # Required to perform privileged actions
RUN install_packages vim
USER 1001 # Revert to the original non-root user

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

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of NGINX Open Source, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

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

- [Create An EMP Development Environment With Bitnami Containers](https://docs.bitnami.com/containers/how-to/create-emp-environment-containers/)

# Notable Changes

## 1.16.1-centos-7-r173

- `1.16.1-centos-7-r173` is considered the latest image based on CentOS.
- Standard supported distros: Debian & OEL.

## 1.16.0-r3

- This image has been adapted so it's easier to customize. See the [Customize this image](#customize-this-image) section for more information.
- The recommended mount point for adding custom server blocks changes from `/opt/bitnami/nginx/conf/vhosts` to `/opt/bitnami/nginx/conf/server_blocks`. Remember to update your Docker Compose files to user the new mount point.

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

Copyright (c) 2015-2020 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
