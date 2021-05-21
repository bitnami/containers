# What is NGINX LDAP Auth Daemon?

> [Nginx LDAP Auth Daemon](https://github.com/username/nginx-ldap-auth-daemon) is a reference implementation of a method for authenticating users who request protected resources from servers proxied by NGINX.

# TL;DR

```bash
$ docker run --name nginx-ldap-auth-daemon bitnami/nginx-ldap-auth-daemon:latest
```

## Docker Compose

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-nginx-ldap-auth-daemon/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/containers/how-to/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/).


* [`0`, `0-debian-10`, `0.20200116.0`, `0.20200116.0-debian-10-r347`, `latest` (0/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-nginx-ldap-auth-daemon/blob/0.20200116.0-debian-10-r347/0/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/nginx-ldap-auth-daemon GitHub repo](https://github.com/bitnami/bitnami-docker-nginx-ldap-auth-daemon).

# Get this image

The recommended way to get the Bitnami NGINX LDAP Auth daemon Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/nginx-ldap-auth-daemon).

```bash
$ docker pull bitnami/nginx-ldap-auth-daemon:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/nginx-ldap-auth-daemon/tags/) in the Docker Hub Registry.

```bash
$ docker pull bitnami/nginx-ldap-auth-daemon:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/nginx-ldap-auth-daemon:latest 'https://github.com/bitnami/bitnami-docker-nginx-ldap-auth-daemon.git#master:0/debian-10'
```

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

In this example, we will use a nginx http server to serve a example page, and a openldap server to authenticate the users.

### Step 1: Create the sample page

```console
$ mkdir app

$ cat << EOF > app/index.html
<html>
<body>
<h1>Hello world!.</h1>
</body>
</html>
EOF
```

### Step 2: Create a nginx configuration file

```console
$ mkdir conf

$ cat << EOF > conf/ldap_nginx.conf
    server {
      listen 0.0.0.0:8080;

      location = / {
         auth_request /auth-proxy;
      }

      location = /auth-proxy {
         internal;

         proxy_pass http://nginx-ldap:8888;

         # URL and port for connecting to the LDAP server
         proxy_set_header X-Ldap-URL "ldap://openldap:1389";

         # Base DN
         proxy_set_header X-Ldap-BaseDN "dc=example,dc=org";

         # Bind DN
         proxy_set_header X-Ldap-BindDN "cn=admin,dc=example,dc=org";

         # Bind password
         proxy_set_header X-Ldap-BindPass "adminpassword";
      }
   }
```

### Step 3: Create a network

```console
$ docker network create my-network --driver bridge
```

### Step 4: Launch the NGINX LDAP auth daemon container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `my-network` network.

```console
$ docker run --detach --rm --name nginx-ldap \
  --network my-network \
  bitnami/nginx-ldap-auth-daemon:latest
```

### Step 5: Launch the OpenLDAP server instance

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `my-network` network.

```console
$ docker run --detach --rm --name openldap \
  --network my-network \
  --env LDAP_ADMIN_USERNAME=admin \
  --env LDAP_ADMIN_PASSWORD=adminpassword \
  --env LDAP_USERS=customuser \
  --env LDAP_PASSWORDS=custompassword \
  bitnami/openldap:latest
```

### Step 6: Launch the NGINX server instance

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `my-network` network.

```console
$ docker run --detach --rm --name nginx \
  --network my-network \
  -p 8080:8080 \
  -v $PWD/app:/app \
  -v $PWD/conf/ldap_nginx.conf:/opt/bitnami/nginx/conf/server_blocks/ldap_nginx.conf \
  bitnami/nginx:latest
```

### Step 7: Launch the NGINX server instance

Browse to `http://locahost:8080/` , it will ask for credentials. Introduce `customuser` / `custompassword` and you will get the `Hello world` greetings.

## Using Docker Compose

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `my-network`. In this example we assume that you want to connect to the NGINX LDAP auth daemon server from your own custom nginx server which is identified in the following snippet by the service name `mynginx`.

```yaml
version: '2'

services:
  nginx-ldap:
    image: bitnami/nginx-ldap-auth-daemon
    ports:
      - 8888:8888
  nginx:
    image: bitnami/nginx
    ports:
     - 8080:8080
    volumes:
     - ./app:/app
     - ./conf/ldap_nginx.conf:/opt/bitnami/nginx/conf/server_blocks/ldap_nginx.conf
  openldap:
    image: bitnami/openldap
    ports:
      - '1389:1389'
      - '1636:1636'
    environment:
      - LDAP_ADMIN_USERNAME=admin
      - LDAP_ADMIN_PASSWORD=adminpassword
      - LDAP_USERS=customuser
      - LDAP_PASSWORDS=custompassword
```

# Configuration

The Bitnami Docker NGINX LDAP auth daemon can be easily setup with the following environment variables, these variables will be ignored if a custom server block is mounted defining the corresponding values.

- `NGINXLDAP_PORT_NUMBER`: The port where NGINX LDAP auth daemon is listening for requests. Default: **8888** (non privileged port)
- `NGINXLDAP_LDAP_URI`: LDAP URL beginning in the form `ldap[s]:/<hostname>:<port>`. No defaults.
- `NGINXLDAP_LDAP_BASE_DN`: LDAP search base DN. No defaults.
- `NGINXLDAP_LDAP_BIND_DN`: LDAP bind DN. No defaults.
- `NGINXLDAP_LDAP_BIND_PASSWORD`: LDAP bind password. No defaults.
- `NGINXLDAP_LDAP_FILTER`: LDAP search filter. Defaults to `(cn=%(username)s)`
- `NGINXLDAP_HTTP_REALM`: HTTP auth realm. Defaults to `Restricted`.
- `NGINXLDAP_HTTP_COOKIE_NAME`: HTTP cookie name. No defaults.

# Logging

The Bitnami NGINX LDAP auth daemon Docker image sends the container logs to `stdout`. To view the logs:

```bash
$ docker logs nginx-ldap-auth-daemon
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of NGINX LDAP auth daemon, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
$ docker pull bitnami/nginx-ldap-auth-daemon:latest
```

### Step 2: Stop the running container

Stop the currently running container using the command

```bash
$ docker stop nginx-ldap-auth-daemon
```

### Step 3: Remove the currently running container

```bash
$ docker rm -v nginx-ldap-auth-daemon
```

### Step 4: Run the new image

Re-create your container from the new image.

```bash
$ docker run --name nginx-ldap-auth-daemon bitnami/nginx-ldap-auth-daemon:latest
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-nginx-ldap-auth-daemon/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-nginx-ldap-auth-daemon/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-nginx-ldap-auth-daemon/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

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
