# Bitnami package for PgBouncer

## What is PgBouncer?

> PgBouncer is a connection pooler for PostgreSQL. It reduces performance overhead by rotating client connections to PostgreSQL databases. It supports PostgreSQL databases located on different hosts.

[Overview of PgBouncer](https://www.pgbouncer.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name pgbouncer bitnami/pgbouncer:latest
```

**Warning**: This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options in the [Configuration](#configuration) section for a more secure deployment.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use PgBouncer in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami pgbouncer Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/pgbouncer).

```console
docker pull bitnami/pgbouncer:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/pgbouncer/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/pgbouncer:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Configuration

### Environment variables

#### Customizable environment variables

| Name                                  | Description                                                                | Default Value                        |
|---------------------------------------|----------------------------------------------------------------------------|--------------------------------------|
| `PGBOUNCER_LOG_FILE`                  | PgBouncer log file.                                                        | `${PGBOUNCER_LOG_DIR}/pgbouncer.log` |
| `PGBOUNCER_DATABASE`                  | PgBouncer advertised database.                                             | `postgres`                           |
| `PGBOUNCER_PORT`                      | PgBouncer port                                                             | `6432`                               |
| `PGBOUNCER_LISTEN_ADDRESS`            | PgBouncer listen address                                                   | `0.0.0.0`                            |
| `PGBOUNCER_AUTH_TYPE`                 | PgBouncer authentication type                                              | `scram-sha-256`                      |
| `PGBOUNCER_INIT_SLEEP_TIME`           | PgBouncer initialization sleep time                                        | `10`                                 |
| `PGBOUNCER_INIT_MAX_RETRIES`          | PgBouncer initialization maximum retries                                   | `10`                                 |
| `PGBOUNCER_IGNORE_STARTUP_PARAMETERS` | Ignore startup parameters in PgBouncer                                     | `extra_float_digits`                 |
| `PGBOUNCER_STATS_PERIOD`              | PgBouncer stats period                                                     | `60`                                 |
| `PGBOUNCER_FAIL_ON_INVALID_DSN_FILE`  | Whether init process should fail if any DSN_FILE is not found.             | `false`                              |
| `PGBOUNCER_CLIENT_TLS_SSLMODE`        | PgBouncer authentication type                                              | `disable`                            |
| `PGBOUNCER_CLIENT_TLS_CIPHERS`        | PgBouncer TLS authentication ciphers                                       | `fast`                               |
| `PGBOUNCER_SERVER_TLS_SSLMODE`        | PgBouncer server authentication type                                       | `disable`                            |
| `PGBOUNCER_SERVER_TLS_PROTOCOLS`      | PgBouncer server TLS authentication protocol                               | `secure`                             |
| `PGBOUNCER_SERVER_TLS_CIPHERS`        | PgBouncer server TLS authentication ciphers                                | `fast`                               |
| `POSTGRESQL_USERNAME`                 | PostgreSQL backend default username                                        | `postgres`                           |
| `POSTGRESQL_DATABASE`                 | Default PostgreSQL database                                                | `${PGBOUNCER_DATABASE}`              |
| `POSTGRESQL_HOST`                     | PostgreSQL backend hostname                                                | `postgresql`                         |
| `POSTGRESQL_PORT`                     | PostgreSQL backend port                                                    | `5432`                               |
| `PGBOUNCER_SET_DATABASE_USER`         | Whether to include the backend PostgreSQL username in the database string. | `no`                                 |
| `PGBOUNCER_SET_DATABASE_PASSWORD`     | Whether to include the backend PostgreSQL password in the database string. | `no`                                 |
| `PGBOUNCER_FORCE_INITSCRIPTS`         | Force the init scripts running even if it is not in the first start.       | `false`                              |
| `PGBOUNCER_SOCKET_DIR`                | PgBouncer socket dir                                                       | `/tmp/`                              |
| `PGBOUNCER_SOCKET_MODE`               | PgBouncer socket mode                                                      | `0777`                               |
| `PGBOUNCER_DAEMON_USER`               | PostgreSQL daemon user                                                     | `pgbouncer`                          |
| `PGBOUNCER_DAEMON_GROUP`              | PostgreSQL daemon group                                                    | `pgbouncer`                          |

#### Read-only environment variables

| Name                         | Description                                            | Value                                       |
|------------------------------|--------------------------------------------------------|---------------------------------------------|
| `PGBOUNCER_BASE_DIR`         | PgBouncer installation directory.                      | `${BITNAMI_ROOT_DIR}/pgbouncer`             |
| `PGBOUNCER_CONF_DIR`         | PgBouncer configuration directory.                     | `${PGBOUNCER_BASE_DIR}/conf`                |
| `PGBOUNCER_LOG_DIR`          | PgBouncer logs directory.                              | `${PGBOUNCER_BASE_DIR}/logs`                |
| `PGBOUNCER_TMP_DIR`          | PgBouncer temporary directory.                         | `${PGBOUNCER_BASE_DIR}/tmp`                 |
| `PGBOUNCER_PID_FILE`         | PgBouncer pid file.                                    | `${PGBOUNCER_TMP_DIR}/pgbouncer.pid`        |
| `PGBOUNCER_CONF_FILE`        | PgBouncer configuration file.                          | `${PGBOUNCER_CONF_DIR}/pgbouncer.ini`       |
| `PGBOUNCER_AUTH_FILE`        | PgBouncer authentication file.                         | `${PGBOUNCER_CONF_DIR}/userlist.txt`        |
| `PGBOUNCER_VOLUME_DIR`       | PgBouncer volume directory.                            | `${BITNAMI_VOLUME_DIR}/pgbouncer`           |
| `PGBOUNCER_MOUNTED_CONF_DIR` | PgBouncer mounted configuration directory.             | `${PGBOUNCER_VOLUME_DIR}/conf`              |
| `PGBOUNCER_INITSCRIPTS_DIR`  | PgBouncer init scripts directory.                      | `/docker-entrypoint-initdb.d`               |
| `NSS_WRAPPER_LIB`            | Flag for startup (necessary for the postgresql client) | `/opt/bitnami/common/lib/libnss_wrapper.so` |

### Daemon settings

The following parameters can be set for the PgBouncer daemon:

### Authentication

The authentication mode can be set using the `PGBOUNCER_AUTH_TYPE` variable, which can be set to any of the values available [in the official PgBouncer documentation](https://www.pgbouncer.org/config.html). In the case of the `scram-sha-256` authentication type (default value), set the backend PostgreSQL credentials as using the variables described in the [Environment Variables](#environment-variables) table.

### Extra arguments to PgBouncer startup

In case you want to add extra flags to the PgBouncer command, use the `PGBOUNCER_EXTRA_FLAGS` variable. Example:

```console
docker run --name pgbouncer \
  -e PGBOUNCER_EXTRA_FLAGS="--verbose" \
  bitnami/pgbouncer:latest
```

### Exposed database

* `PGBOUNCER_DATABASE`: PgBouncer exposed database. Default: **postgres**.

In case you'd like pgbouncer to expose your database with a different name, you can use the `PGBOUNCER_DATABASE` variable.
To expose the same database name as the backend, set `PGBOUNCER_DATABASE="$POSTGRESQL_DATABASE"`.
To expose a ["fallback database" (wildcard that matches any)](https://www.pgbouncer.org/config.html#section-databases)), set `PGBOUNCER_DATABASE="*"`.

### Initializing a new instance

When the container is launched, it will execute the files with extension `.sh` located at `/docker-entrypoint-initdb.d`.

In order to have your custom files inside the docker image you can mount them as a volume.

```console
docker run --name pgbouncer \
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

* `PGBOUNCER_CLIENT_TLS_SSLMODE`: TLS traffic settings. Defaults to `disable`. Check the [official PgBouncer documentation](https://www.pgbouncer.org/config.html) for the available values for `client_tls_sslmode`.
* `PGBOUNCER_CLIENT_TLS_CERT_FILE`: File containing the certificate file for the TLS traffic. No defaults.
* `PGBOUNCER_CLIENT_TLS_KEY_FILE`: File containing the key for certificate. No defaults.
* `PGBOUNCER_CLIENT_TLS_CA_FILE`: File containing the CA of the certificate. If provided, PgBouncer will authenticate TLS/SSL clients by requesting them a certificate . No defaults.
* `PGBOUNCER_CLIENT_TLS_CIPHERS`: TLS ciphers to be used. Defaults to `fast`.Check the [official PgBouncer documentation](https://www.pgbouncer.org/config.html) for the available values for `client_tls_ciphers`.

* `PGBOUNCER_SERVER_TLS_SSLMODE`: Server TLS traffic settings. Defaults to `disable`. Check the [official PgBouncer documentation](https://www.pgbouncer.org/config.html) for the available values for `server_tls_sslmode`.
* `PGBOUNCER_SERVER_TLS_KEY_FILE`: File containing the key to authenticate against PostgreSQL server. No defaults.
* `PGBOUNCER_SERVER_TLS_CERT_FILE`: File containing the certificate associated to previous private key. PostgreSQL server can validate it. No defaults.
* `PGBOUNCER_SERVER_TLS_CA_FILE`: File containing the CA of the server certificate. If provided, PgBouncer will authenticate TLS/SSL clients by requesting them a certificate . No defaults.
* `PGBOUNCER_SERVER_TLS_PROTOCOLS`: TLS protocols to be used in server connection. Defaults to `secure`. Check the [official PgBouncer documentation](https://www.pgbouncer.org/config.html) for the available values for `server_tls_protocols`.
* `PGBOUNCER_SERVER_TLS_CIPHERS`: TLS ciphers to be used in server connection. Defaults to `fast`. Check the [official PgBouncer documentation](https://www.pgbouncer.org/config.html) for the available values for `server_tls_ciphers`.

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
docker run --name pgbouncer \
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
docker restart pgbouncer
```

or using Docker Compose:

```console
docker-compose restart pgbouncer
```

Refer to the [server configuration](https://www.pgbouncer.org/usage.html) manual for the complete list of configuration options.

### How to connect with multiple PostgreSQL servers

It is possible to connect a single PgBouncer instance with multiple PostgreSQL backends. By using as many `PGBOUNCER_DSN_${i}` environment variables (with `i` starting at zero, `0`) as needed, and the `PGBOUNCER_USERLIST_FILE` variable pointing to a mounted volume with the required credentials for any extra PostgreSQL database in the format `"<postgresql-user>" "<password>"`.

The PgBouncer initialization process requires one PostgreSQL backend to be configured using the different `POSTGRESQL_*` variables listed in the [Environment Variables](#environment-variables) section, but the rest of backends connections can be provided using the method explained in this section. An example `docker-compose.yaml` for this scenario can be found below

```yaml
  pg1:
    image: docker.io/bitnami/postgresql:14
    volumes:
      - 'pg1_data:/bitnami/postgresql'
    environment:
      - POSTGRESQL_PASSWORD=password1
      - POSTGRESQL_DATABASE=db1

  pg2:
    image: docker.io/bitnami/postgresql:15
    volumes:
      - 'pg2_data:/bitnami/postgresql'
    environment:
      - POSTGRESQL_PASSWORD=password2
      - POSTGRESQL_DATABASE=db2

  pg3:
    image: docker.io/bitnami/postgresql:14
    volumes:
      - 'pg3_data:/bitnami/postgresql'
    environment:
      - POSTGRESQL_PASSWORD=password3
      - POSTGRESQL_DATABASE=db3

  pgbouncer:
    image: docker.io/bitnami/pgbouncer:1
    ports:
      - 6432:6432
    volumes:
      - './userlists.txt:/bitnami/userlists.txt'
    environment:
      - POSTGRESQL_HOST=pg1
      - POSTGRESQL_PASSWORD=password1
      - POSTGRESQL_DATABASE=db1
      - PGBOUNCER_AUTH_TYPE=trust
      - PGBOUNCER_USERLIST_FILE=/bitnami/userlists.txt
      - PGBOUNCER_DSN_0=pg1=host=pg1 port=5432 dbname=db1
      - PGBOUNCER_DSN_1=pg2=host=pg2 port=5432 dbname=db2
      - PGBOUNCER_DSN_2=pg3=host=pg3 port=5432 dbname=db3
volumes:
  pg1_data:
    driver: local
  pg2_data:
    driver: local
  pg3_data:
    driver: local
```

And this is the content of the `userlists.txt` file:

```text
"postgres" "password1"
"postgres" "password2"
"postgres" "password3"
```

Once initialized, the scenario above provides access to three diferent PostgreSQL backends from a single PgBouncer instance. As an example, you can request the PostgreSQL version of the backend server number two (notice it is the only running PostgreSQL 15.x in this scenario):

```bash
$ docker exec -it -u root debian-11-pgbouncer-1 psql -p 6432 -U postgres pg2 -c "show server_version;"
 server_version
 ----------------
  15.4
  (1 row)
```

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes.

If you detect any issue in the `docker-compose.yaml` file, feel free to report it or contribute with a fix by following our [Contributing Guidelines](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md).

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/containers/issues/new/choose). For us to provide better support, be sure to fill the issue template.

## License

Copyright &copy; 2024 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
