# PgBouncer packaged by Bitnami

## What is PgBouncer?

> PgBouncer is a connection pooler for PostgreSQL. It reduces performance overhead by rotating client connections to PostgreSQL databases. It supports PostgreSQL databases located on different hosts.

[Overview of PgBouncer](https://www.pgbouncer.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
$ docker run --name pgbouncer bitnami/pgbouncer:latest
```

### Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/containers/main/bitnami/pgbouncer/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

**Warning**: This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options in the [Configuration](#configuration) section for a more secure deployment.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami pgbouncer Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/pgbouncer).

```console
$ docker pull bitnami/pgbouncer:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/pgbouncer/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/pgbouncer:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
$ git clone https://github.com/bitnami/containers.git
$ cd bitnami/APP/VERSION/OPERATING-SYSTEM
$ docker build -t bitnami/APP:latest .
```

## Configuration

### Daemon settings

The following parameters can be set for the PgBouncer daemon:

### Authentication

The authentication mode can be set using the `PGBOUNCER_AUTH_TYPE` variable, which can be set to any of the values available [in the official PgBouncer documentation](https://www.pgbouncer.org/config.html). In the case of the `md5` authentication type (default value), set the backend PostgreSQL credentials as explained in the [Backend PostgreSQL connection section](#backend-postgresql-connection).

### Backend PostgreSQL connection

The Bitnami PgBouncer container requires a running PostgreSQL installation to connect to. This is configured with the following environment variables.

- `POSTGRESQL_USERNAME`: Backend PostgreSQL username. Default: **postgres**.
- `POSTGRESQL_PASSWORD`: Backend PostgreSQL password. No defaults.
- `POSTGRESQL_DATABASE`: Backend PostgreSQL Database name to connect to. Default: **postgres**.
- `POSTGRESQL_HOST`: Backend PostgreSQL hostname. Default: **postgresql**.
- `POSTGRESQL_PORT`: Backend PostgreSQL port. Default: **5432**.
- `PGBOUNCER_SET_DATABASE_USER`: Whether to include the backend PostgreSQL username in the database string. Default **no**.
- `PGBOUNCER_SET_DATABASE_PASSWORD`: Whether to include the backend PostgreSQL password in the database string. Default **no**.
- `PGBOUNCER_CONNECT_QUERY`: Query which will be executed after a connection is established. No Defaults.

### Port and address binding

The listening port and listening address can be configured with the following environment variables:

- `PGBOUNCER_PORT`: PgBouncer port. Default: **6432**.
- `PGBOUNCER_BIND_ADDRESS`: PgBouncer bind address. Default: **0.0.0.0**.

### Extra arguments to PgBouncer startup

In case you want to add extra flags to the PgBouncer command, use the `PGBOUNCER_EXTRA_FLAGS` variable. Example:

```console
$ docker run --name pgbouncer \
  -e PGBOUNCER_EXTRA_FLAGS="--verbose" \
  bitnami/pgbouncer:latest
```

### Exposed database

- `PGBOUNCER_DATABASE`: PgBouncer exposed database. Default: **postgres**.

In case you'd like pgbouncer to expose your database with a different name, you can use the `PGBOUNCER_DATABASE` variable.
To expose the same database name as the backend, set `PGBOUNCER_DATABASE="$POSTGRESQL_DATABASE"`.

### Other options

- `PGBOUNCER_AUTH_USER`: PgBouncer will use this user to connect to the database and query the PostgreSQL backend for a user and password. No defaults.
- `PGBOUNCER_AUTH_QUERY`: PgBouncer will use this query to connect to the database and query the PostgreSQL backend for a user and password. No defaults.
- `PGBOUNCER_POOL_MODE` : PgBouncer pool mode. Allowed values: session, transaction and statement. Default: **session**.
- `PGBOUNCER_INIT_SLEEP_TIME` : PgBouncer initialization sleep time. Default: **10**.
- `PGBOUNCER_INIT_MAX_RETRIES` : PgBouncer initialization maximum retries. Default: **10**.
- `PGBOUNCER_QUERY_WAIT_TIMEOUT` : PgBouncer maximum time queries are allowed to spend waiting for execution. Default: **120**.
- `PGBOUNCER_MAX_CLIENT_CONN` : PgBouncer maximum number of client connections allowed. Default: **120**.
- `PGBOUNCER_MAX_DB_CONNECTIONS` : PgBouncer maximum number of database connections allowed. Default: **0 (unlimited)**.
- `PGBOUNCER_IDLE_TRANSACTION_TIMEOUT` : PgBouncer maximum time for a client to be in "idle in transaction" state. Default: **0.0**.
- `PGBOUNCER_DEFAULT_POOL_SIZE` : PgBouncer maximum server connections to allow per user/database pair. Default: **20**.
- `PGBOUNCER_MIN_POOL_SIZE` : PgBouncer has at least this amount of open connections. Default: **0 (disabled)**.
- `PGBOUNCER_RESERVE_POOL_SIZE` : PgBouncer allows this amount of additional connections. Default: **0 (disabled)**.
- `PGBOUNCER_IGNORE_STARTUP_PARAMETERS`: you can use this to set `ignore_startup_parameters` in the auto-generated `pgbouncer.ini`. This can be useful for solving certain connection issues. See https://www.pgbouncer.org/config.html for more details.
- `PGBOUNCER_SERVER_IDLE_TIMEOUT`: PgBouncer maximum time in seconds a server connection can be idle. If 0 then the timeout is disabled. Default: **600**
- `PGBOUNCER_SERVER_RESET_QUERY`: PgBouncer query sent to server on connection release before making it available to other clients. Default: **DISCARD ALL**
- `PGBOUNCER_STATS_USERS`: PgBouncer comma-separated list of database users that are allowed to connect and run read-only queries. No defaults.

### Initializing a new instance

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

### Securing PgBouncer traffic

PgBouncer supports the encryption of connections using the SSL/TLS protocol. Should you desire to enable this optional feature, you may use the following environment variables to configure the application:

 - `PGBOUNCER_CLIENT_TLS_SSLMODE`: TLS traffic settings. Defaults to `disable`. Check the [official PgBouncer documentation](https://www.pgbouncer.org/config.html) for the available values for `client_tls_sslmode`.
 - `PGBOUNCER_CLIENT_TLS_CERT_FILE`: File containing the certificate file for the TLS traffic. No defaults.
 - `PGBOUNCER_CLIENT_TLS_KEY_FILE`: File containing the key for certificate. No defaults.
 - `PGBOUNCER_CLIENT_TLS_CA_FILE`: File containing the CA of the certificate. If provided, PgBouncer will authenticate TLS/SSL clients by requesting them a certificate . No defaults.
 - `PGBOUNCER_CLIENT_TLS_CIPHERS`: TLS ciphers to be used. Defaults to `fast`.Check the [official PgBouncer documentation](https://www.pgbouncer.org/config.html) for the available values for `client_tls_ciphers`.

 - `PGBOUNCER_SERVER_TLS_SSLMODE`: Server TLS traffic settings. Defaults to `disable`. Check the [official PgBouncer documentation](https://www.pgbouncer.org/config.html) for the available values for `server_tls_sslmode`.
 - `PGBOUNCER_SERVER_TLS_KEY_FILE`: File containing the key to authenticate against PostgreSQL server. No defaults.
 - `PGBOUNCER_SERVER_TLS_CERT_FILE`: File containing the certificate associated to previous private key. PostgreSQL server can validate it. No defaults.
 - `PGBOUNCER_SERVER_TLS_CA_FILE`: File containing the CA of the server certificate. If provided, PgBouncer will authenticate TLS/SSL clients by requesting them a certificate . No defaults.
 - `PGBOUNCER_SERVER_TLS_PROTOCOLS`: TLS protocols to be used in server connection. Defaults to `secure`. Check the [official PgBouncer documentation](https://www.pgbouncer.org/config.html) for the available values for `server_tls_protocols`.
 - `PGBOUNCER_SERVER_TLS_CIPHERS`: TLS ciphers to be used in server connection. Defaults to `fast`. Check the [official PgBouncer documentation](https://www.pgbouncer.org/config.html) for the available values for `server_tls_ciphers`.

When enabling TLS, PgBouncer will support both standard and encrypted traffic by default but prefer the latter. Below there are some examples of how to quickly set up client TLS traffic:

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

Alternatively, you may also provide this configuration in your [custom](https://github.com/bitnami/containers/blob/main/bitnami/pgbouncer#configuration-file) configuration file.

### Configuration file

The image looks for `pgbouncer.ini` file in `/opt/bitnami/pgbouncer/conf/`. You can mount a volume at `/bitnami/pgbouncer/conf/` and copy/edit the `pgbouncer.ini` file in the `/path/to/pgbouncer-persistence/conf/`. The default configurations will be populated to the `conf/` directory if it's empty.

```console
/path/to/pgbouncer-persistence/conf/
└── pgbouncer.ini

0 directories, 1 file
```

As PgBouncer image is non-root, you need to set the proper permissions to the mounted directory in your host:
```console
sudo chown 1001:1001 /path/to/pgbouncer-persistence/conf/
```

#### Step 1: Run the PgBouncer image

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

#### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```console
vi /path/to/pgbouncer-persistence/conf/pgbouncer.ini
```

#### Step 3: Restart PgBouncer

After changing the configuration, restart your PgBouncer container for changes to take effect.

```console
$ docker restart pgbouncer
```

or using Docker Compose:

```console
$ docker-compose restart pgbouncer
```

Refer to the [server configuration](https://www.pgbouncer.org/usage.html) manual for the complete list of configuration options.

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/containers/issues/new/choose). For us to provide better support, be sure to fill the issue template.

## License

Copyright &copy; 2023 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
