# Bitnami package for NGINX Open Source

## What is NGINX Open Source?

> NGINX Open Source is a web server that can be also used as a reverse proxy, load balancer, and HTTP cache. Recommended for high-demanding sites due to its ability to provide faster content.

[Overview of NGINX Open Source](http://nginx.org)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name nginx bitnami/nginx:latest
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use NGINX Open Source in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## How to deploy NGINX Open Source in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami NGINX Open Source Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/nginx).

Bitnami containers can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami NGINX Open Source Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/nginx).

```console
docker pull bitnami/nginx:latest
```

To use a specific version, you can pull a versioned tag. You can view the
[list of available versions](https://hub.docker.com/r/bitnami/nginx/tags/)
in the Docker Hub Registry.

```console
docker pull bitnami/nginx:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Hosting a static website

This NGINX Open Source image exposes a volume at `/app`. Content mounted here is served by the default catch-all server block.

```console
docker run -v /path/to/app:/app bitnami/nginx:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/nginx/docker-compose.yml) file present in this repository:

```yaml
services:
  nginx:
  ...
    volumes:
      - /path/to/app:/app
  ...
```

## Accessing your server from the host

To access your web server from your host machine you can ask Docker to map a random port on your host to ports `8080` and `8443` exposed in the container.

```console
docker run --name nginx -P bitnami/nginx:latest
```

Run `docker port` to determine the random ports Docker assigned.

```console
$ docker port nginx
8080/tcp -> 0.0.0.0:32769
```

You can also manually specify the ports you want forwarded from your host to the container.

```console
docker run -p 9000:8080 bitnami/nginx:latest
```

Access your web server in the browser by navigating to `http://localhost:9000`.

## Configuration

### Adding custom server blocks

The default `nginx.conf` includes server blocks placed in `/opt/bitnami/nginx/conf/server_blocks/`. You can mount a `my_server_block.conf` file containing your custom server block at this location.

For example, in order add a server block for `www.example.com`:

## Step 1: Write your `my_server_block.conf` file with the following content

```nginx
server {
  listen 0.0.0.0:8080;
  server_name www.example.com;
  root /app;
  index index.htm index.html;
}
```

## Step 2: Mount the server block as a volume

```console
docker run --name nginx \
  -v /path/to/my_server_block.conf:/opt/bitnami/nginx/conf/server_blocks/my_server_block.conf:ro \
  bitnami/nginx:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/nginx/docker-compose.yml) file present in this repository:

```yaml
services:
  nginx:
  ...
    volumes:
      - /path/to/my_server_block.conf:/opt/bitnami/nginx/conf/server_blocks/my_server_block.conf:ro
  ...
```

### Adding custom stream server blocks

Similar to server blocks, you can include server blocks for the [NGINX Stream Core Module](https://nginx.org/en/docs/stream/ngx_stream_core_module.html) mounting them at `/opt/bitnami/nginx/conf/stream_server_blocks/`. In order to do so, it's also necessary to set the `NGINX_ENABLE_STREAM` environment variable to `yes`.

## Step 1: Write your `my_stream_server_block.conf` file with the following content

```nginx
upstream backend {
    hash $remote_addr consistent;

    server backend1.example.com:12345 weight=5;
    server 127.0.0.1:12345            max_fails=3 fail_timeout=30s;
    server unix:/tmp/backend3;
}

server {
    listen 12345;
    proxy_connect_timeout 1s;
    proxy_timeout 3s;
    proxy_pass backend;
}
```

## Step 2: Mount the stream server block as a volume

```console
docker run --name nginx \
  -e NGINX_ENABLE_STREAM=yes \
  -v /path/to/my_stream_server_block.conf:/opt/bitnami/nginx/conf/stream_server_blocks/my_stream_server_block.conf:ro \
  bitnami/nginx:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/nginx/docker-compose.yml) file present in this repository:

```yaml
services:
  nginx:
  ...
    environment:
      - NGINX_ENABLE_STREAM=yes
  ...
    volumes:
      - /path/to/my_stream_server_block.conf:/opt/bitnami/nginx/conf/stream_server_blocks/my_stream_server_block.conf:ro
  ...
```

### Using custom SSL certificates

*NOTE:* The steps below assume that you are using a custom domain name and that you have already configured the custom domain name to point to your server.

#### Step 1: Prepare your certificate files

In your local computer, create a folder called `certs` and put your certificates files. Make sure you rename both files to `server.crt` and `server.key` respectively:

```console
mkdir -p /path/to/nginx-persistence/certs
cp /path/to/certfile.crt /path/to/nginx-persistence/certs/server.crt
cp /path/to/keyfile.key  /path/to/nginx-persistence/certs/server.key
```

#### Step 2: Provide a custom Server Block for SSL connections

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

#### Step 3: Run the NGINX Open Source image and open the SSL port

Run the NGINX Open Source image, mounting the certificates directory from your host.

```console
docker run --name nginx \
  -v /path/to/my_server_block.conf:/opt/bitnami/nginx/conf/server_blocks/my_server_block.conf:ro \
  -v /path/to/nginx-persistence/certs:/certs \
  bitnami/nginx:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/nginx/docker-compose.yml) file present in this repository:

```yaml
services:
  nginx:
  ...
    volumes:
    - /path/to/nginx-persistence/certs:/certs
    - /path/to/my_server_block.conf:/opt/bitnami/nginx/conf/server_blocks/my_server_block.conf:ro
  ...
```

### Solving redirection issues

By default redirections issued by NGINX Open Source image will be relative. If you need to activate absolute redirections you can set `NGINX_ENABLE_ABSOLUTE_REDIRECT` to `yes`. You should pay attention to the port where the container is listening, because it won't appear in redirections unless you set also `NGINX_ENABLE_PORT_IN_REDIRECT` to `yes`.

In the following lines you can see different examples what explain how redirections work. All of them will assume that we have the following content in the server block `my_redirect_server_block.conf`:

```nginx
server {
  listen 0.0.0.0:8080;
  server_name www.example.com;
  root /app;
  index index.htm index.html;
  location /test/ {
    return 301 /index.html;
  }
}
```

#### Default configuration

```console
docker run --name nginx --rm -p 9000:8080 \
  -v /path/to/my_redirect_server_block.conf:/opt/bitnami/nginx/conf/server_blocks/my_redirect.conf:ro \
  bitnami/nginx:latest
```

As mentioned, default redirections issued by NGINX Open Source image will be relative. The client should build the final URL

```console
$ curl -kI http://localhost:9000/test/
HTTP/1.1 301 Moved Permanently
...
Location: /index.html
...
$ curl -w %{redirect_url}\\n -o /dev/null http://localhost:9000/test/
http://localhost:9000/index.html
```

Please keep in mind that some old clients could be not compatible with relative redirections.

#### Absolute redirect enabled

```console
docker run --name nginx --rm -p 9000:8080 \
  -v /path/to/my_redirect_server_block.conf:/opt/bitnami/nginx/conf/server_blocks/my_redirect.conf:ro \
  -e NGINX_ENABLE_ABSOLUTE_REDIRECT=yes \
  bitnami/nginx:latest
```

As result, the container will reply with a full URL in the `Location` header but it doesn't have the port. This is useful if you are exposing the container in standard ports (80 or 443)

```console
$ curl -kI http://localhost:9000/test/
HTTP/1.1 301 Moved Permanently
...
Location: http://localhost/index.html
...
```

#### Port in redirect enabled

```console
docker run --name nginx --rm -p 9000:8080 \
  -v /path/to/my_redirect_server_block.conf:/opt/bitnami/nginx/conf/server_blocks/my_redirect.conf:ro \
  -e NGINX_ENABLE_ABSOLUTE_REDIRECT=yes \
  -e NGINX_ENABLE_PORT_IN_REDIRECT=yes \
  bitnami/nginx:latest
```

In this case the container will include the port where it is listening to in redirections, not the port where it is exposed (in the example `8080` vs `9000`)

```console
$ curl -kI http://localhost:9000/test/
HTTP/1.1 301 Moved Permanently
...
Location: http://localhost:8080/index.html
...
```

To amend this situation and build reachable URLs, you have to run the container listening in the same port that you are exposing

```console
docker run --name nginx --rm -p 9000:9000 \
  -v /path/to/my_redirect_server_block.conf:/opt/bitnami/nginx/conf/server_blocks/my_redirect.conf:ro \
  -e NGINX_ENABLE_ABSOLUTE_REDIRECT=yes \
  -e NGINX_ENABLE_PORT_IN_REDIRECT=yes \
  -e NGINX_HTTP_PORT_NUMBER=9000
  bitnami/nginx:latest
```

### Full configuration

The image looks for configurations in `/opt/bitnami/nginx/conf/nginx.conf`. You can overwrite the `nginx.conf` file using your own custom configuration file.

```console
docker run --name nginx \
  -v /path/to/your_nginx.conf:/opt/bitnami/nginx/conf/nginx.conf:ro \
  bitnami/nginx:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/nginx/docker-compose.yml) file present in this repository:

```yaml
services:
  nginx:
  ...
    volumes:
      - /path/to/your_nginx.conf:/opt/bitnami/nginx/conf/nginx.conf:ro
  ...
```

## Reverse proxy to other containers

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

* [NGINX reverse proxy](http://nginx.com/resources/admin-guide/reverse-proxy/)

## Logging

The Bitnami NGINX Open Source Docker image sends the container logs to the `stdout`. To view the logs:

```console
docker logs nginx
```

or using Docker Compose:

```console
docker-compose logs nginx
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Customize this image

The Bitnami NGINX Open Source Docker image is designed to be extended so it can be used as the base image for your custom web applications.

### Extend this image

Before extending this image, please note there are certain configuration settings you can modify using the original image:

* Settings that can be adapted using environment variables. For instance, you can change the port used by NGINX for HTTP setting the environment variable `NGINX_HTTP_PORT_NUMBER`.
* [Adding custom server blocks](#adding-custom-server-blocks).
* [Replacing the 'nginx.conf' file](#full-configuration).
* [Using custom SSL certificates](#using-custom-ssl-certificates).
* [Solving redirection issues](#solving-redirection-issues).

If your desired customizations cannot be covered using the methods mentioned above, extend the image. To do so, create your own image using a Dockerfile with the format below:

```Dockerfile
FROM bitnami/nginx
### Put your customizations below
...
```

Here is an example of extending the image with the following modifications:

* Install the `vim` editor
* Modify the NGINX configuration file
* Modify the ports used by NGINX
* Change the user that runs the container

```Dockerfile
FROM bitnami/nginx

### Change user to perform privileged actions
USER 0
### Install 'vim'
RUN install_packages vim
### Revert to the original non-root user
USER 1001

### Modify 'worker_connections' on NGINX config file to '512'
RUN sed -i -r "s#(\s+worker_connections\s+)[0-9]+;#\1512;#" /opt/bitnami/nginx/conf/nginx.conf

### Modify the ports used by NGINX by default
ENV NGINX_HTTP_PORT_NUMBER=8181 # It is also possible to change this environment variable at runtime
EXPOSE 8181 8143

### Modify the default container user
USER 1002
```

Based on the extended image, you can use a Docker Compose file like the one below to add other features:

* Add a custom server block
* Add custom certificates
* Clone your web application and serve it through NGINX

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

#### NGINX HTTP DAV module

The [module ngx_http_dav_module](https://nginx.org/en/docs/http/ngx_http_dav_module.html) is intended for file management automation via the WebDAV protocol. In current Bitnami images, this module is built as a dynamic module located under the `/opt/bitnami/nginx/modules` directory. You will need to load it in your NGINX configuration for you to be able to use its directives.

```text
load_module /opt/bitnami/nginx/modules/ngx_http_dav_module.so;
```

#### Adding custom NGINX modules

To add a custom NGINX module, it is necessary to compile NGINX with that module and copy over the appropriate files to the Bitnami image.

##### Example

Below is an example Dockerfile to build and install the NGINX Perl module (`ngx_http_perl_module`) over to the Bitnami image:

```Dockerfile
ARG NGINX_VERSION=1.25.0
ARG BITNAMI_NGINX_REVISION=r0
ARG BITNAMI_NGINX_TAG=${NGINX_VERSION}-debian-12-${BITNAMI_NGINX_REVISION}

FROM bitnami/nginx:${BITNAMI_NGINX_TAG} AS builder
USER root
## Redeclare NGINX_VERSION so it can be used as a parameter inside this build stage
ARG NGINX_VERSION
## Install required packages and build dependencies
RUN install_packages dirmngr gpg gpg-agent curl build-essential libpcre3-dev zlib1g-dev libperl-dev
## Add trusted NGINX PGP key for tarball integrity verification
RUN gpg --keyserver pgp.mit.edu --recv-key 520A9993A1C052F8
## Download NGINX, verify integrity and extract
RUN cd /tmp && \
    curl -O http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    curl -O http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz.asc && \
    gpg --verify nginx-${NGINX_VERSION}.tar.gz.asc nginx-${NGINX_VERSION}.tar.gz && \
    tar xzf nginx-${NGINX_VERSION}.tar.gz
## Compile NGINX with desired module
RUN cd /tmp/nginx-${NGINX_VERSION} && \
    rm -rf /opt/bitnami/nginx && \
    ./configure --prefix=/opt/bitnami/nginx --with-compat --with-http_perl_module=dynamic && \
    make && \
    make install

FROM bitnami/nginx:${BITNAMI_NGINX_TAG}
USER root
## Install ngx_http_perl_module system package dependencies
RUN install_packages libperl-dev
## Install ngx_http_perl_module files
COPY --from=builder /usr/local/lib/x86_64-linux-gnu/perl /usr/local/lib/x86_64-linux-gnu/perl
COPY --from=builder /opt/bitnami/nginx/modules/ngx_http_perl_module.so /opt/bitnami/nginx/modules/ngx_http_perl_module.so
## Enable module
RUN echo "load_module modules/ngx_http_perl_module.so;" | cat - /opt/bitnami/nginx/conf/nginx.conf > /tmp/nginx.conf && \
    cp /tmp/nginx.conf /opt/bitnami/nginx/conf/nginx.conf
## Set the container to be run as a non-root user by default
USER 1001
```

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of NGINX Open Source, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/nginx:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/nginx:latest`.

#### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
docker stop nginx
```

or using Docker Compose:

```console
docker-compose stop nginx
```

#### Step 3: Remove the currently running container

```console
docker rm -v nginx
```

or using Docker Compose:

```console
docker-compose rm -v nginx
```

#### Step 4: Run the new image

Re-create your container from the new image.

```console
docker run --name nginx bitnami/nginx:latest
```

or using Docker Compose:

```console
docker-compose up nginx
```

## Useful Links

* [Create An EMP Development Environment With Bitnami Containers](https://docs.bitnami.com/containers/how-to/create-emp-environment-containers/)

## Notable Changes

### Starting February 10, 2025

* The [module ngx_http_dav_module](http://nginx.org/en/docs/http/ngx_http_dav_module.html), WebDAV protocol, has been converted into a dynamic module.

### 1.24.0-debian-11-r142 and 1.25.2-debian-11-r33

* Added support for [Module ngx_http_dav_module](http://nginx.org/en/docs/http/ngx_http_dav_module.html), WebDAV protocol.

### 1.18.0-debian-10-r210 and 1.19.6-debian-10-r1

* Added support for enabling dynamic modules.

### 1.16.1-centos-7-r173

* `1.16.1-centos-7-r173` is considered the latest image based on CentOS.
* Standard supported distros: Debian & OEL.

### 1.16.0-r3

* This image has been adapted so it's easier to customize. See the [Customize this image](#customize-this-image) section for more information.
* The recommended mount point for adding custom server blocks changes from `/opt/bitnami/nginx/conf/vhosts` to `/opt/bitnami/nginx/conf/server_blocks`. Remember to update your Docker Compose files to user the new mount point.

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/nginx).

If you detect any issue in the `docker-compose.yaml` file, feel free to report it or contribute with a fix by following our [Contributing Guidelines](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md).

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/containers/issues/new/choose). For us to provide better support, be sure to fill the issue template.

## License

Copyright &copy; 2025 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
