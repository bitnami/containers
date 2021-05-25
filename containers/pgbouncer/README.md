
# What is pgbouncer?

> Lightweight connection pooler for PostgreSQL.

[Overview of pgbouncer](https://www.pgbouncer.org)

# TL;DR

```console
$ docker run --name pgbouncer bitnami/pgbouncer:latest
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.

> This [CVE scan report](https://quay.io/repository/bitnami/pgbouncer?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`1`, `1-debian-10`, `1.15.0`, `1.15.0-debian-10-r113`, `latest` (1/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-pgbouncer/blob/1.15.0-debian-10-r113/1/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/pgbouncer GitHub repo](https://github.com/bitnami/bitnami-docker-pgbouncer).

# Get this image

The recommended way to get the Bitnami pgbouncer Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/pgbouncer).

```console
$ docker pull bitnami/pgbouncer:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/pgbouncer/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/pgbouncer:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/pgbouncer:latest 'https://github.com/bitnami/bitnami-docker-pgbouncer.git#master:1/debian-10'
```

# Configuration

## Daemon settings

The following parameters can be set for the PgBouncer daemon:

## Authentication

The authentication mode can be set using the `PGBOUNCER_AUTH_TYPE` variable, which can be set to any of the values available [in the official PgBouncer documentation](https://www.pgbouncer.org/config.html). In the case of the `md5` authentication type (default value), set the backend PostgreSQL credentials as explained in the [Backend PostgreSQL connection section](#backend-postgresql-connection).

## Backend PostgreSQL connection

The Bitnami PgBouncer container requires a running PostgreSQL installation to connect to. This is configured with the following environment variables.

- `POSTGRESQL_USERNAME`: Backend PostgreSQL username. Default: **postgres**.
- `POSTGRESQL_PASSWORD`: Backend PostgreSQL password. No defaults.
- `POSTGRESQL_DATABASE`: Backend PostgreSQL Database name to connect to. Default: **postgres**.
- `POSTGRESQL_HOST`: Backend PostgreSQL hostname. Default: **postgresql**.
- `POSTGRESQL_PORT`: Backend PostgreSQL port. Default: **5432**.

## Port and address binding

The listening port and listening address can be configured with the following environment variables:

- `PGBOUNCER_PORT`: PgBouncer port. Default: **6432**.
- `PGBOUNCER_BIND_ADDRESS`: PgBouncer bind address. Default: **0.0.0.0**.

## Extra arguments to PgBouncer startup

In case you want to add extra flags to the PgBouncer command, use the `PGBOUNCER_EXTRA_ARGS` variable. Example:

```console
$ docker run --name pgbouncer \
  -e PGBOUNCER_EXTRA_ARGS="--verbose" \
  bitnami/pgbouncer:latest
```

## Initializing a new instance

When the container is launched, it will execute the files with extension `.sh` located at `/docker-entrypoint-initdb.d`.

In order to have your custom files inside the docker image you can mount them as a volume.

```console
$ docker run --name pgbouncer \
  -v /path/to/init-scripts:/docker-entrypoint-initdb.d \
  bitnami/pgbouncer:latest
```

Or with docker-compose

```yaml
pgbouncer:
  image: bitnami/pgbouncer:latest
  volumes:
    - /path/to/init-scripts:/docker-entrypoint-initdb.d
```

## Securing PgBouncer traffic

PgBouncer supports the encryption of connections using the SSL/TLS protocol. Should you desire to enable this optional feature, you may use the following environment variables to configure the application:

 - `PGBOUNCER_CLIENT_TLS_SSLMODE`: TLS traffic settings. Defaults to `disable`. Check the [official PgBouncer documentation](https://www.pgbouncer.org/config.html) for the available values for `client_tls_sslmode`.
 - `PGBOUNCER_CLIENT_TLS_CERT_FILE`: File containing the certificate file for the TLS traffic. No defaults.
 - `PGBOUNCER_CLIENT_TLS_KEY_FILE`: File containing the key for certificate. No defaults.
 - `PGBOUNCER_CLIENT_TLS_CA_FILE`: File containing the CA of the certificate. If provided, PgBouncer will authenticate TLS/SSL clients by requesting them a certificate . No defaults.
 - `PGBOUNCER_CLIENT_TLS_CIPHERS`: TLS ciphers to be used. Defaults to `fast`.Check the [official PgBouncer documentation](https://www.pgbouncer.org/config.html) for the available values for `client_tls_ciphers`.

When enabling TLS, PgBouncer will support both standard and encrypted traffic by default, but prefer the latter. Below there are some examples on how to quickly set up TLS traffic:

1. Using `docker run`

    ```console
    $ docker run \
        -v /path/to/certs:/opt/bitnami/pgbouncer/certs \
        -e PGBOUNCER_CLIENT_TLS_SSLMODE=require \
        -e PGBOUNCER_CLIENT_TLS_CERT_FILE=/opt/bitnami/pgbouncer/certs/pgbouncer.crt \
        -e PGBOUNCER_CLIENT_TLS_KEY_FILE=/opt/bitnami/pgbouncer/certs/pgbouncer.key \
        bitnami/pgbouncer:latest
    ```

2. Modifying the `docker-compose.yml` file present in this repository:

    ```yaml
    services:
      pgbouncer:
      ...
        environment:
          ...
          - PGBOUNCER_CLIENT_TLS_SSLMODE=require
          - PGBOUNCER_CLIENT_TLS_CERT_FILE=/opt/bitnami/pgbouncer/certs/pgbouncer.crt
          - PGBOUNCER_CLIENT_TLS_KEY_FILE=/opt/bitnami/pgbouncer/certs/pgbouncer.key
        ...
        volumes:
          ...
          - /path/to/certs:/opt/bitnami/pgbouncer/certs
      ...
    ```

Alternatively, you may also provide this configuration in your [custom](https://github.com/bitnami/bitnami-docker-pgbouncer#configuration-file) configuration file.

## Configuration file

The image looks for `pgbouncer.conf` file in `/opt/bitnami/pgbouncer/conf/`. You can mount a volume at `/bitnami/pgbouncer/conf/` and copy/edit the `pgbouncer.conf` file in the `/path/to/pgbouncer-persistence/conf/`. The default configurations will be populated to the `conf/` directory if it's empty.

```console
/path/to/pgbouncer-persistence/conf/
└── pgbouncer.ini

0 directories, 1 file
```

As PgBouncer image is non-root, you need to set the proper permissions to the mounted directory in your host:
```console
sudo chown 1001:1001 /path/to/pgbouncer-persistence/conf/
```

### Step 1: Run the PgBouncer image

Run the PgBouncer image, mounting a directory from your host.

```console
$ docker run --name pgbouncer \
    -v /path/to/pgbouncer-persistence/conf/:/bitnami/pgbouncer/conf/ \
    bitnami/pgbouncer:latest
```

or using Docker Compose:

```yaml
version: '2'

...

services:
  pgbouncer:
    image: 'bitnami/pgbouncer:latest'
    ports:
      - '6432:6432'
    volumes:
      - /path/to/pgbouncer-persistence/conf/:/bitnami/pgbouncer/conf/
```

### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```console
vi /path/to/pgbouncer-persistence/conf/pgbouncer.ini
```

### Step 3: Restart PgBouncer

After changing the configuration, restart your PgBouncer container for changes to take effect.

```console
$ docker restart pgbouncer
```

or using Docker Compose:

```console
$ docker-compose restart pgbouncer
```

Refer to the [server configuration](https://www.pgbouncer.org/usage.html) manual for the complete list of configuration options.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-pgbouncer/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-pgbouncer/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-pgbouncer/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright 2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
