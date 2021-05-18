# What is EJBCA?

> [EJBCA](https://www.ejbca.org/) is a free software public key infrastructure certificate authority software package.

# TL;DR

```console
$ docker run --name ejbca bitnami/ejbca:latest
```

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-ejbca/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.

> This [CVE scan report](https://quay.io/repository/bitnami/ejbca?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/containers/how-to/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/).


* [`6`, `6-debian-10`, `6.15.2-6`, `6.15.2-6-debian-10-r251`, `latest` (6/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-ejbca/blob/6.15.2-6-debian-10-r251/6/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/ejbca GitHub repo](https://github.com/bitnami/bitnami-docker-ejbca).

# Get this image

The recommended way to get the Bitnami EJBCA Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/ejbca).

```console
$ docker pull bitnami/ejbca:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/ejbca/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/ejbca:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/ejbca:latest 'https://github.com/bitnami/bitnami-docker-ejbca.git#master:6/debian-10'
```

# How to use this image

EJBCA requires access to a MySQL or MariaDB database to store information. We'll use our very own [MariaDB image](https://www.github.com/bitnami/bitnami-docker-mariadb) for the database requirements.

## Run the application using Docker Compose

The main folder of this repository contains a functional [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-ejbca/blob/master/docker-compose.yml) file. Run the application using it as shown below:

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-ejbca/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

## Using the Docker Command Line

If you want to run the application manually instead of using `docker-compose`, these are the basic steps you need to run:

### Step 1: Create a network

```console
$ docker network create ejbca-network
```

### Step 2: Create a volume for MariaDB persistence and create a MariaDB container

```console
$ docker volume create --name mariadb_data
$ docker run -d --name mariadb \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MARIADB_USER=bn_ejbca \
  --env MARIADB_PASSWORD=Bitnami1234 \
  --env MARIADB_DATABASE=bitnami_ejbca \
  --network ejbca-network \
  --volume mariadb_data:/bitnami/mariadb \
  bitnami/mariadb:latest
```

### Step 3: Create volumes for EJBCA persistence and launch the container

```console
$ docker volume create --name ejbca_data
$ docker run -d --name ejbca \
  -p 8080:8080 -p 8443:8443 \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env EJBCA_DATABASE_USERNAME=bn_ejbca \
  --env EJBCA_DATABASE_PASSWORD=Bitnami1234 \
  --env EJBCA_DATABASE_HOST=mariadb \
  --env EJBCA_DATABASE_NAME=bitnami_ejbca \
  --network ejbca-network \
  --volume ejbca_data:/bitnami/ejbca \
  bitnami/ejbca:latest
```

Access your application at http://your-ip:8080/ejbca/

# Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/ejbca` path. If the mounted directory is empty, it will be initialized on the first run.

```console
$ docker run \
    -v /path/to/ejbca-persistence:/bitnami/ejbca \
    bitnami/ejbca:latest
```

You can also do this with a minor change to the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-ejbca/blob/master/docker-compose.yml) file present in this repository:

```diff
   ejbca:
     ...
     volumes:
-      - 'ejbca_data:/bitnami/ejbca'
+      - /path/to/ejbca-persistence:/bitnami/ejbca
   ...
-volumes:
-  ejbca_data:
-    driver: local
```

# Configuration

The EJBCA instance can be customized by specifying environment variables on the first run. The following environment variables are available:

- `EJBCA_HTTP_PORT_NUMBER`: HTTP port number. Defaults to `8080`.
- `EJBCA_HTTPS_PORT_NUMBER`: HTTPS port number. Default to `8443`.
- `EJBCA_HTTPS_ADVERTISED_PORT_NUMBER`: Port number used in the rendered URLs for the admistrator login. Default to `8443`.
- `EJBCA_ADMIN_USERNAME`: EJBCA administrator username. Defaults to `superadmin`.
- `EJBCA_ADMIN_PASSWORD`: EJBCA administrator password. Defaults to `Bitnami1234`.
- `EJBCA_DATABASE_HOST`: Database hostname. No defaults.
- `EJBCA_DATABASE_PORT`: Database port name. Defaults to `3306`.
- `EJBCA_DATABASE_NAME`: Database name. No defaults.
- `EJBCA_DATABASE_USERNAME`: Database username. No defaults.
- `EJBCA_DATABASE_PASSWORD`: Database password. No defaults.
- `EJBCA_BASE_DN`: Base DN for the CA. Defaults to `O=Example CA,C=SE,UID=c-XXXXXXX`, where `XXXXXXX` is a random generated ID.
- `EJBCA_CA_NAME`: CA Name. Defaults to `ManagementCA`
- `JAVA_OPTS`: Java options. Defaults to `-Xms2048m -Xmx2048m -XX:MetaspaceSize=192M -XX:MaxMetaspaceSize=256m -Djava.net.preferIPv4Stack=true -Dhibernate.dialect=org.hibernate.dialect.MySQL5Dialect -Dhibernate.dialect.storage_engine=innodb`.
- `EJBCA_SERVER_CERT_FILE`: User provided keystore file. No defaults.
- `EJBCA_SERVER_CERT_PASSWORD`: User provided keystore file password. No defaults.

# Logging

The Bitnami EJBCA Docker image sends the container logs to `stdout`. To view the logs:

```console
$ docker logs ejbca
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of EJBCA, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```console
$ docker pull bitnami/ejbca:latest
```

### Step 2: Stop the running container

Stop the currently running container using the command

```console
$ docker stop ejbca
```

### Step 3: Remove the currently running container

```console
$ docker rm -v ejbca
```

### Step 4: Run the new image

Re-create your container from the new image.

```console
$ docker run --name ejbca bitnami/ejbca:latest
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-ejbca/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-ejbca/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-ejbca/issues). For us to provide better support, be sure to include the following information in your issue:

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
