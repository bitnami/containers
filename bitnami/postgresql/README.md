# Bitnami Secure Image for PostgreSQL

## What is PostgreSQL?

> PostgreSQL (Postgres) is an open source object-relational database known for reliability and data integrity. ACID-compliant, it supports foreign keys, joins, views, triggers and stored procedures.

[Overview of PostgreSQL](https://www.postgresql.org)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name postgresql bitnami/postgresql:latest
```

**Warning**: This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options in the [Configuration](#configuration) section for a more secure deployment.

## Why use Bitnami Secure Images?

Those are hardened, minimal CVE images built and maintained by Bitnami. Bitnami Secure Images are based on the cloud-optimized, security-hardened enterprise [OS Photon Linux](https://vmware.github.io/photon/). Why choose BSI images?

- Hardened secure images of popular open source software with Near-Zero Vulnerabilities
- Vulnerability Triage & Prioritization with VEX Statements, KEV and EPSS Scores
- Compliance focus with FIPS, STIG, and air-gap options, including secure bill of materials (SBOM)
- Software supply chain provenance attestation through in-toto
- First class support for the internet’s favorite Helm charts

Each image comes with valuable security metadata. You can view the metadata in [our public catalog here](https://app-catalog.vmware.com/bitnami/apps). Note: Some data is only available with [commercial subscriptions to BSI](https://bitnami.com/).

![Alt text](https://github.com/bitnami/containers/blob/main/BSI%20UI%201.png?raw=true "Application details")
![Alt text](https://github.com/bitnami/containers/blob/main/BSI%20UI%202.png?raw=true "Packaging report")

If you are looking for our previous generation of images based on Debian Linux, please see the [Bitnami Legacy registry](https://hub.docker.com/u/bitnamilegacy).

## How to deploy PostgreSQL in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami PostgreSQL Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/postgresql).

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

## Get this image

The recommended way to get the Bitnami PostgreSQL Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/postgresql).

```console
docker pull bitnami/postgresql:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/postgresql/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/postgresql:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Persisting your database

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/postgresql` path. If the mounted directory is empty, it will be initialized on the first run.

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a PostgreSQL server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Configuration

### Environment variables

#### Customizable environment variables

| Name                                       | Description                                                                                          | Default Value                              |
|--------------------------------------------|------------------------------------------------------------------------------------------------------|--------------------------------------------|
| `POSTGRESQL_VOLUME_DIR`                    | Persistence base directory                                                                           | `/bitnami/postgresql`                      |
| `POSTGRESQL_DATA_DIR`                      | PostgreSQL data directory                                                                            | `${POSTGRESQL_VOLUME_DIR}/data`            |
| `POSTGRESQL_EXTRA_FLAGS`                   | Extra flags for PostgreSQL initialization                                                            | `nil`                                      |
| `POSTGRESQL_INIT_MAX_TIMEOUT`              | Maximum initialization waiting timeout                                                               | `60`                                       |
| `POSTGRESQL_PGCTLTIMEOUT`                  | Maximum waiting timeout for pg_ctl commands                                                          | `60`                                       |
| `POSTGRESQL_SHUTDOWN_MODE`                 | Default mode for pg_ctl stop command                                                                 | `fast`                                     |
| `POSTGRESQL_CLUSTER_APP_NAME`              | Replication cluster default application name                                                         | `walreceiver`                              |
| `POSTGRESQL_DATABASE`                      | Default PostgreSQL database                                                                          | `postgres`                                 |
| `POSTGRESQL_INITDB_ARGS`                   | Optional args for PostreSQL initdb operation                                                         | `nil`                                      |
| `ALLOW_EMPTY_PASSWORD`                     | Allow password-less access                                                                           | `no`                                       |
| `POSTGRESQL_INITDB_WAL_DIR`                | Optional init db wal directory                                                                       | `nil`                                      |
| `POSTGRESQL_MASTER_HOST`                   | PostgreSQL master host (used by slaves)                                                              | `nil`                                      |
| `POSTGRESQL_MASTER_PORT_NUMBER`            | PostgreSQL master host port (used by slaves)                                                         | `5432`                                     |
| `POSTGRESQL_NUM_SYNCHRONOUS_REPLICAS`      | Number of PostgreSQL replicas that should use synchronous replication                                | `0`                                        |
| `POSTGRESQL_SYNCHRONOUS_REPLICAS_MODE`     | PostgreSQL synchronous replication mode (values: empty, FIRST, ANY)                                  | `nil`                                      |
| `POSTGRESQL_PORT_NUMBER`                   | PostgreSQL port number                                                                               | `5432`                                     |
| `POSTGRESQL_ALLOW_REMOTE_CONNECTIONS`      | Modify pg_hba settings so users can access from the outside                                          | `yes`                                      |
| `POSTGRESQL_REPLICATION_MODE`              | PostgreSQL replication mode (values: master, slave)                                                  | `master`                                   |
| `POSTGRESQL_REPLICATION_USER`              | PostgreSQL replication user                                                                          | `nil`                                      |
| `POSTGRESQL_REPLICATION_USE_PASSFILE`      | Use PGPASSFILE instead of PGPASSWORD                                                                 | `no`                                       |
| `POSTGRESQL_REPLICATION_PASSFILE_PATH`     | Path to store passfile                                                                               | `${POSTGRESQL_CONF_DIR}/.pgpass`           |
| `POSTGRESQL_SR_CHECK`                      | Create user on PostgreSQL for Stream Replication Check                                               | `no`                                       |
| `POSTGRESQL_SR_CHECK_USERNAME`             | Stream Replication Check user                                                                        | `sr_check_user`                            |
| `POSTGRESQL_SR_CHECK_DATABASE`             | Stream Replication Check database                                                                    | `postgres`                                 |
| `POSTGRESQL_SYNCHRONOUS_COMMIT_MODE`       | Enable synchronous replication in slaves (number defined by POSTGRESQL_NUM_SYNCHRONOUS_REPLICAS)     | `on`                                       |
| `POSTGRESQL_FSYNC`                         | Enable fsync in write ahead logs                                                                     | `on`                                       |
| `POSTGRESQL_USERNAME`                      | PostgreSQL default username                                                                          | `postgres`                                 |
| `POSTGRESQL_ENABLE_LDAP`                   | Enable LDAP for PostgreSQL authentication                                                            | `no`                                       |
| `POSTGRESQL_LDAP_URL`                      | PostgreSQL LDAP server url (requires POSTGRESQL_ENABLE_LDAP=yes)                                     | `nil`                                      |
| `POSTGRESQL_LDAP_PREFIX`                   | PostgreSQL LDAP prefix (requires POSTGRESQL_ENABLE_LDAP=yes)                                         | `nil`                                      |
| `POSTGRESQL_LDAP_SUFFIX`                   | PostgreSQL LDAP suffix (requires POSTGRESQL_ENABLE_LDAP=yes)                                         | `nil`                                      |
| `POSTGRESQL_LDAP_SERVER`                   | PostgreSQL LDAP server (requires POSTGRESQL_ENABLE_LDAP=yes)                                         | `nil`                                      |
| `POSTGRESQL_LDAP_PORT`                     | PostgreSQL LDAP port (requires POSTGRESQL_ENABLE_LDAP=yes)                                           | `nil`                                      |
| `POSTGRESQL_LDAP_SCHEME`                   | PostgreSQL LDAP scheme (requires POSTGRESQL_ENABLE_LDAP=yes)                                         | `nil`                                      |
| `POSTGRESQL_LDAP_TLS`                      | PostgreSQL LDAP tls setting (requires POSTGRESQL_ENABLE_LDAP=yes)                                    | `nil`                                      |
| `POSTGRESQL_LDAP_BASE_DN`                  | PostgreSQL LDAP base DN settings (requires POSTGRESQL_ENABLE_LDAP=yes)                               | `nil`                                      |
| `POSTGRESQL_LDAP_BIND_DN`                  | PostgreSQL LDAP bind DN settings (requires POSTGRESQL_ENABLE_LDAP=yes)                               | `nil`                                      |
| `POSTGRESQL_LDAP_BIND_PASSWORD`            | PostgreSQL LDAP bind password (requires POSTGRESQL_ENABLE_LDAP=yes)                                  | `nil`                                      |
| `POSTGRESQL_LDAP_SEARCH_ATTR`              | PostgreSQL LDAP search attribute (requires POSTGRESQL_ENABLE_LDAP=yes)                               | `nil`                                      |
| `POSTGRESQL_LDAP_SEARCH_FILTER`            | PostgreSQL LDAP search filter (requires POSTGRESQL_ENABLE_LDAP=yes)                                  | `nil`                                      |
| `POSTGRESQL_INITSCRIPTS_USERNAME`          | Username for the psql scripts included in /docker-entrypoint.initdb                                  | `$POSTGRESQL_USERNAME`                     |
| `POSTGRESQL_PASSWORD`                      | Password for the PostgreSQL created user                                                             | `nil`                                      |
| `POSTGRESQL_POSTGRES_PASSWORD`             | Password for the PostgreSQL postgres user                                                            | `nil`                                      |
| `POSTGRESQL_REPLICATION_PASSWORD`          | Password for the PostgreSQL replication user                                                         | `nil`                                      |
| `POSTGRESQL_SR_CHECK_PASSWORD`             | Password for the Stream Replication Check user                                                       | `nil`                                      |
| `POSTGRESQL_INITSCRIPTS_PASSWORD`          | Password for the PostgreSQL init scripts user                                                        | `$POSTGRESQL_PASSWORD`                     |
| `POSTGRESQL_ENABLE_TLS`                    | Whether to enable TLS for traffic or not                                                             | `no`                                       |
| `POSTGRESQL_TLS_CERT_FILE`                 | File containing the certificate for the TLS traffic                                                  | `nil`                                      |
| `POSTGRESQL_TLS_KEY_FILE`                  | File containing the key for certificate                                                              | `nil`                                      |
| `POSTGRESQL_TLS_CA_FILE`                   | File containing the CA of the certificate                                                            | `nil`                                      |
| `POSTGRESQL_TLS_CRL_FILE`                  | File containing a Certificate Revocation List                                                        | `nil`                                      |
| `POSTGRESQL_TLS_PREFER_SERVER_CIPHERS`     | Whether to use the server TLS cipher preferences rather than the client                              | `yes`                                      |
| `POSTGRESQL_SHARED_PRELOAD_LIBRARIES`      | List of libraries to preload at PostgreSQL initialization                                            | `pgaudit`                                  |
| `POSTGRESQL_PGAUDIT_LOG`                   | Comma-separated list of actions to log with pgaudit                                                  | `nil`                                      |
| `POSTGRESQL_PGAUDIT_LOG_CATALOG`           | Enable pgaudit log catalog (pgaudit.log_catalog setting)                                             | `nil`                                      |
| `POSTGRESQL_PGAUDIT_LOG_PARAMETER`         | Enable pgaudit log parameter (pgaudit.log_parameter setting)                                         | `nil`                                      |
| `POSTGRESQL_LOG_CONNECTIONS`               | Add a log entry per user connection                                                                  | `nil`                                      |
| `POSTGRESQL_LOG_DISCONNECTIONS`            | Add a log entry per user disconnection                                                               | `nil`                                      |
| `POSTGRESQL_LOG_HOSTNAME`                  | Log the client host name when accessing                                                              | `nil`                                      |
| `POSTGRESQL_CLIENT_MIN_MESSAGES`           | Set log level of errors to send to the client                                                        | `error`                                    |
| `POSTGRESQL_LOG_LINE_PREFIX`               | Set the format of the log lines                                                                      | `nil`                                      |
| `POSTGRESQL_LOG_TIMEZONE`                  | Set the log timezone                                                                                 | `nil`                                      |
| `POSTGRESQL_TIMEZONE`                      | Set the timezone                                                                                     | `nil`                                      |
| `POSTGRESQL_MAX_CONNECTIONS`               | Set the maximum amount of connections                                                                | `nil`                                      |
| `POSTGRESQL_TCP_KEEPALIVES_IDLE`           | Set the TCP keepalive idle time                                                                      | `nil`                                      |
| `POSTGRESQL_TCP_KEEPALIVES_INTERVAL`       | Set the TCP keepalive interval time                                                                  | `nil`                                      |
| `POSTGRESQL_TCP_KEEPALIVES_COUNT`          | Set the TCP keepalive count                                                                          | `nil`                                      |
| `POSTGRESQL_STATEMENT_TIMEOUT`             | Set the SQL statement timeout                                                                        | `nil`                                      |
| `POSTGRESQL_PGHBA_REMOVE_FILTERS`          | Comma-separated list of strings for removing pg_hba.conf lines (example: md5, local)                 | `nil`                                      |
| `POSTGRESQL_USERNAME_CONNECTION_LIMIT`     | Set the user connection limit                                                                        | `nil`                                      |
| `POSTGRESQL_POSTGRES_CONNECTION_LIMIT`     | Set the postgres user connection limit                                                               | `nil`                                      |
| `POSTGRESQL_WAL_LEVEL`                     | Set the write-ahead log level                                                                        | `replica`                                  |
| `POSTGRESQL_DEFAULT_TOAST_COMPRESSION`     | Set the postgres default compression                                                                 | `nil`                                      |
| `POSTGRESQL_PASSWORD_ENCRYPTION`           | Set the passwords encryption method                                                                  | `nil`                                      |
| `POSTGRESQL_DEFAULT_TRANSACTION_ISOLATION` | Set transaction isolation                                                                            | `nil`                                      |
| `POSTGRESQL_REPLICATION_NODES`             | Override value for synchronous_standby_names in postgresql.conf. Should be set if `REPMGR_NODE_NAME` | `nil`                                      |
| `POSTGRESQL_PERFORM_RESTORE`               | Flag to skip deletion of `recovery.signal` file to enable native recovery. e.g by using `wal-g`      | `no`                                       |
| `POSTGRESQL_AUTOCTL_CONF_DIR`              | Path to the configuration dir for the pg_autoctl command                                             | `${POSTGRESQL_AUTOCTL_VOLUME_DIR}/.config` |
| `POSTGRESQL_AUTOCTL_MODE`                  | pgAutoFailover node type, valid values [monitor, postgres]                                           | `postgres`                                 |
| `POSTGRESQL_AUTOCTL_MONITOR_HOST`          | Hostname for the monitor component                                                                   | `monitor`                                  |
| `POSTGRESQL_AUTOCTL_HOSTNAME`              | Hostname by which postgres is reachable                                                              | `$(hostname --fqdn)`                       |

#### Read-only environment variables

| Name                                         | Description                                                     | Value                                         |
|----------------------------------------------|-----------------------------------------------------------------|-----------------------------------------------|
| `POSTGRESQL_BASE_DIR`                        | PostgreSQL installation directory                               | `/opt/bitnami/postgresql`                     |
| `POSTGRESQL_DEFAULT_CONF_DIR`                | PostgreSQL configuration directory                              | `$POSTGRESQL_BASE_DIR/conf.default`           |
| `POSTGRESQL_CONF_DIR`                        | PostgreSQL configuration directory                              | `$POSTGRESQL_BASE_DIR/conf`                   |
| `POSTGRESQL_MOUNTED_CONF_DIR`                | PostgreSQL mounted configuration directory                      | `$POSTGRESQL_VOLUME_DIR/conf`                 |
| `POSTGRESQL_CONF_FILE`                       | PostgreSQL configuration file                                   | `$POSTGRESQL_CONF_DIR/postgresql.conf`        |
| `POSTGRESQL_PGHBA_FILE`                      | PostgreSQL pg_hba file                                          | `$POSTGRESQL_CONF_DIR/pg_hba.conf`            |
| `POSTGRESQL_RECOVERY_FILE`                   | PostgreSQL recovery file                                        | `$POSTGRESQL_DATA_DIR/recovery.conf`          |
| `POSTGRESQL_LOG_DIR`                         | PostgreSQL logs directory                                       | `$POSTGRESQL_BASE_DIR/logs`                   |
| `POSTGRESQL_LOG_FILE`                        | PostgreSQL log file                                             | `$POSTGRESQL_LOG_DIR/postgresql.log`          |
| `POSTGRESQL_TMP_DIR`                         | PostgreSQL temporary directory                                  | `$POSTGRESQL_BASE_DIR/tmp`                    |
| `POSTGRESQL_PID_FILE`                        | PostgreSQL PID file                                             | `$POSTGRESQL_TMP_DIR/postgresql.pid`          |
| `POSTGRESQL_BIN_DIR`                         | PostgreSQL executables directory                                | `$POSTGRESQL_BASE_DIR/bin`                    |
| `POSTGRESQL_INITSCRIPTS_DIR`                 | Init scripts directory                                          | `/docker-entrypoint-initdb.d`                 |
| `POSTGRESQL_PREINITSCRIPTS_DIR`              | Pre-init scripts directory                                      | `/docker-entrypoint-preinitdb.d`              |
| `POSTGRESQL_DAEMON_USER`                     | PostgreSQL system user                                          | `postgres`                                    |
| `POSTGRESQL_DAEMON_GROUP`                    | PostgreSQL system group                                         | `postgres`                                    |
| `POSTGRESQL_USE_CUSTOM_PGHBA_INITIALIZATION` | Initialize PostgreSQL with the custom, mounted pg_hba.conf file | `no`                                          |
| `POSTGRESQL_AUTOCTL_VOLUME_DIR`              | The pg_autoctl home directory                                   | `${POSTGRESQL_VOLUME_DIR}/pgautoctl`          |
| `POSTGRESQL_PGBACKREST_VOLUME_DIR`           | The pgbackrest home directory                                   | `${POSTGRESQL_VOLUME_DIR}/pgbackrest`         |
| `POSTGRESQL_PGBACKREST_LOGS_DIR`             | The pgbackrest logs directory                                   | `${POSTGRESQL_PGBACKREST_VOLUME_DIR}/logs`    |
| `POSTGRESQL_PGBACKREST_BACKUPS_DIR`          | The pgbackrest backups directory                                | `${POSTGRESQL_PGBACKREST_VOLUME_DIR}/backups` |
| `POSTGRESQL_PGBACKREST_SPOOL_DIR`            | The pgbackrest spool directory                                  | `${POSTGRESQL_PGBACKREST_VOLUME_DIR}/spool`   |
| `POSTGRESQL_PGBACKREST_CONF_FILE`            | The pgbackrest configuration file                               | `${POSTGRESQL_DATA_DIR}/pgbackrest.conf`      |
| `POSTGRESQL_FIRST_BOOT`                      | Flag for startup (necessary for repmgr)                         | `yes`                                         |
| `NSS_WRAPPER_LIB`                            | Flag for startup (necessary for repmgr)                         | `/opt/bitnami/common/lib/libnss_wrapper.so`   |

### On container start

When the container is executed, it will execute the files with extension `.sh` located at `/docker-entrypoint-preinitdb.d` before initializing or starting postgresql.

In order to have your custom files inside the docker image you can mount them as a volume.

### Passing extra command-line flags to PostgreSQL

Passing extra command-line flags to the postgresql service command is possible through the following env var:

- `POSTGRESQL_EXTRA_FLAGS`: Flags to be appended to the `postgres` startup command. No defaults

### Initializing a new instance

When the container is executed for the first time, it will execute the files with extensions `.sh`, `.sql` and `.sql.gz` located at `/docker-entrypoint-initdb.d`.

In order to have your custom files inside the docker image you can mount them as a volume.

### Auditing

The Bitnami PostgreSQL Image comes with the pgAudit module enabled by default. Thanks to this, audit information can be enabled in the container by using the PGAUDIT env vars listed above.

### LDAP authentication

In order to use LDAP authentication you need to enable it setting the environment variable `POSTGRESQL_ENABLE_LDAP` to  `yes`. Please check the LDAP-related variables above.

For more information refer to [Postgresql LDAP auth configuration documentation](https://www.postgresql.org/docs/current/auth-ldap.html).

### Securing PostgreSQL traffic

PostgreSQL supports the encryption of connections using the SSL/TLS protocol. Should you desire to enable this optional feature, you may use the following environment variables to configure the application:

- `POSTGRESQL_ENABLE_TLS`: Whether to enable TLS for traffic or not. Defaults to `no`.
- `POSTGRESQL_TLS_CERT_FILE`: File containing the certificate file for the TLS traffic. No defaults.
- `POSTGRESQL_TLS_KEY_FILE`: File containing the key for certificate. No defaults.
- `POSTGRESQL_TLS_CA_FILE`: File containing the CA of the certificate. If provided, PostgreSQL will authenticate TLS/SSL clients by requesting them a certificate (see [ref](https://www.postgresql.org/docs/9.6/auth-methods.html)). No defaults.
- `POSTGRESQL_TLS_CRL_FILE`: File containing a Certificate Revocation List. No defaults.
- `POSTGRESQL_TLS_PREFER_SERVER_CIPHERS`: Whether to use the server's TLS cipher preferences rather than the client's. Defaults to `yes`.

When enabling TLS, PostgreSQL will support both standard and encrypted traffic by default, but prefer the latter.

Alternatively, you may also provide this configuration in your [custom](https://github.com/bitnami/containers/tree/main/bitnami/postgresql#configuration-file) configuration file.

### Configuration file

The image looks for `postgresql.conf` file in `/opt/bitnami/postgresql/conf/`. You can mount a volume at `/bitnami/postgresql/conf/` and copy/edit the `postgresql.conf` file in the `/path/to/postgresql-persistence/conf/`. The default configurations will be populated to the `conf/` directory if it's empty.

```console
/path/to/postgresql-persistence/conf/
└── postgresql.conf

0 directories, 1 file
```

Refer to the [server configuration](https://www.postgresql.org/docs/9.4/static/runtime-config.html) manual for the complete list of configuration options.

#### Allow settings to be loaded from files other than the default `postgresql.conf`

Apart of using a custom `postgresql.conf`, you can include files ending in `.conf` from the `conf.d` directory in the volume at `/bitnami/postgresql/conf/`.
For this purpose, the default `postgresql.conf` contains the following section:

```config
##------------------------------------------------------------------------------
## CONFIG FILE INCLUDES
##------------------------------------------------------------------------------

## These options allow settings to be loaded from files other than the
## default postgresql.conf.

include_dir = 'conf.d'  # Include files ending in '.conf' from directory 'conf.d'
```

In your host, you should create the extended configuration file under the `conf.d` directory:

```console
mkdir -p /path/to/postgresql-persistence/conf/conf.d/
vi /path/to/postgresql-persistence/conf/conf.d/extended.conf
```

If you are using your custom `postgresql.conf`, you should create (or uncomment) the above section in your config file, in this case the `/path/to/postgresql-persistence/conf/` structure should be something like

```console
/path/to/postgresql-persistence/conf/
├── conf.d
│   └── extended.conf
└── postgresql.conf

1 directory, 2 files
```

### Specifying initdb arguments

Specifying extra initdb arguments can easily be done using the following environment variables:

- `POSTGRESQL_INITDB_ARGS`: Specifies extra arguments for the initdb command. No defaults.
- `POSTGRESQL_INITDB_WAL_DIR`: Defines a custom location for the transaction log. No defaults.

### Stopping settings

You can control the parameters used to stop postgresql in the initialization process by using:

- `POSTGRESQL_PGCTLTIMEOUT` that will set the timeout for the `pg_ctl` command.
- `POSTGRESQL_SHUTDOWN_MODE` that will indicate the [shutdown mode](https://www.postgresql.org/docs/11/app-pg-ctl.html) used.

### Installing extra locales

The Dockerfile provides two arguments to configure extra locales at build time:

- `WITH_ALL_LOCALES`: Enable all supported locales. Default: no
- `EXTRA_LOCALES`: Comma separated list of extra locales to enable. No defaults

For example, to build an image with support for the `es_ES.UTF-8 UTF-8` locale, you can add the following argument to your build command:

```console
docker build --build-arg EXTRA_LOCALES="es_ES.UTF-8 UTF-8" ...
```

### Environment variables aliases

The Bitnami PostgreSQL container allows two different sets of environment variables. Please see the list of environment variable aliases in the next table:

| Environment Variable                 | Alias                              |
|:-------------------------------------|:-----------------------------------|
| POSTGRESQL_USERNAME                  | POSTGRES_USER                      |
| POSTGRESQL_DATABASE                  | POSTGRES_DB                        |
| POSTGRESQL_PASSWORD                  | POSTGRES_PASSWORD                  |
| POSTGRESQL_PASSWORD_FILE             | POSTGRES_PASSWORD_FILE             |
| POSTGRESQL_POSTGRES_PASSWORD         | POSTGRES_POSTGRES_PASSWORD         |
| POSTGRESQL_POSTGRES_PASSWORD_FILE    | POSTGRES_POSTGRES_PASSWORD_FILE    |
| POSTGRESQL_PORT_NUMBER               | POSTGRES_PORT_NUMBER               |
| POSTGRESQL_INITDB_ARGS               | POSTGRES_INITDB_ARGS               |
| POSTGRESQL_INITDB_WAL_DIR            | POSTGRES_INITDB_WAL_DIR            |
| POSTGRESQL_DATA_DIR                  | PGDATA                             |
| POSTGRESQL_REPLICATION_USER          | POSTGRES_REPLICATION_USER          |
| POSTGRESQL_REPLICATION_MODE          | POSTGRES_REPLICATION_MODE          |
| POSTGRESQL_REPLICATION_PASSWORD      | POSTGRES_REPLICATION_PASSWORD      |
| POSTGRESQL_REPLICATION_PASSWORD_FILE | POSTGRES_REPLICATION_PASSWORD_FILE |
| POSTGRESQL_CLUSTER_APP_NAME          | POSTGRES_CLUSTER_APP_NAME          |
| POSTGRESQL_MASTER_HOST               | POSTGRES_MASTER_HOST               |
| POSTGRESQL_MASTER_PORT_NUMBER        | POSTGRES_MASTER_PORT_NUMBER        |
| POSTGRESQL_NUM_SYNCHRONOUS_REPLICAS  | POSTGRES_NUM_SYNCHRONOUS_REPLICAS  |
| POSTGRESQL_SYNCHRONOUS_COMMIT_MODE   | POSTGRES_SYNCHRONOUS_COMMIT_MODE   |
| POSTGRESQL_SHUTDOWN_MODE             | POSTGRES_SHUTDOWN_MODE             |

> *IMPORTANT*: Changing the `POSTGRES_USER` will not change the owner of the database that will continue being the `postgres` user. In order to change the database owner, please access using `postgres` as user (`$ psql -U postgres ...`) and execute the following command:

```console
alter database POSTGRES_DATABASE owner to POSTGRES_USER;
```

It is possible to change the user that PostgreSQL will use to execute the init scripts. To do so, use the following environment variables:

| Environment variable            | Description                                                       |
|---------------------------------|-------------------------------------------------------------------|
| POSTGRESQL_INITSCRIPTS_USERNAME | User that will be used to execute the init scripts                |
| POSTGRESQL_INITSCRIPTS_PASSWORD | Password for the user specified in POSTGRESQL_INITSCRIPT_USERNAME |

### Default toast compression

The default toast compression is `pglz`, but you can modify it by setting the environment variable `POSTGRES_DEFAULT_COMPRESSION` with the desired value. For example: `POSTGRES_DEFAULT_COMPRESSION='lz4'`.

### FIPS configuration in Bitnami Secure Images

The Bitnami PostgreSQL Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Logging

The Bitnami PostgreSQL Docker image sends the container logs to the `stdout`. To view the logs:

```console
docker logs postgresql
```

or using Docker Compose:

```console
docker-compose logs postgresql
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Notable Changes

### 9.6.16-centos-7-r71, 10.11.0-centos-7-r72, 11.6.0-centos-7-r71, and 12.1.0-centos-7-r72

- `9.6.16-centos-7-r71`, `10.11.0-centos-7-r72`, `11.6.0-centos-7-r71`, and `12.1.0-centos-7-r72` are considered the latest images based on CentOS.
- Standard supported distros: Debian & OEL.

### 9.6.15-r93, 9.6.15-ol-7-r108, 9.6.15-centos-7-r107, 10.10.0-r923, 10.10.0-ol-7-r106, 10.10.0-centos-7-r107, 11.5.0-r89, 11.5.0-centos-7-r103, 11.5.0-ol-7-r108, 12.0.0-r21, 12.0.0-centos-7-r34 and 12.0.0-ol-7-r32

- Adds LDAP authentication support

### 9.6.15-r82, 9.6.15-ol-7-r92, 9.6.15-centos-7-r91, 10.10.0-r82, 10.10.0-ol-7-r90, 10.10.0-centos-7-r91, 11.5.0-r80, 11.5.0-centos-7-r87, 11.5.0-ol-7-r92, 12.0.0-r11, 12.0.0-centos-7-r17 and 12.0.0-ol-7-r17

- Adds Postgis extension to postgresql, version 2.3.x to Postgresiql 9.6 and version 2.5 to 10, 11 and 12.

### 9.6.12-r70, 9.6.12-ol-7-r72, 10.7.0-r69, 10.7.0-ol-7-r71, 11.2.0-r69 and 11.2.0-ol-7-r71

- Decrease the size of the container. It is not necessary Node.js anymore. PostgreSQL configuration moved to bash scripts in the rootfs/ folder.
- This container is backwards compatible with the previous versions, as the mount folders remain unchanged.
- The `POSTGRESQL_PASSWORD` variable must be passed to the slaves so they generate the proper `pg_hba.conf` admission rules.

### 9.6.11-r66, 9.6.11-ol-7-r83, 10.6.0-r68, 10.6.0-ol-7-r83, 11.1.0-r62 and 11.1.0-ol-7-r79

- The PostgreSQL container can be configured using two sets of environment variables. For more information, check [Environment variables aliases](#environment-variables-aliases)

### 9.6.11-r38, 10.6.0-r39 and 11.1.0-r34

- The PostgreSQL container now contains options to easily configure synchronous commits between slaves. This provides more data stability, but must be configured with caution as it also has a cost in performance. For more information, check [Synchronous Commits](#synchronous-commits).

### 9.6.9-r19 and 10.4.0-r19

- The PostgreSQL container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the PostgreSQL daemon was started as the `postgres` user. From now on, both the container and the PostgreSQL daemon run as user `1001`. As a consequence, the data directory must be writable by that user. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

### 9.5.3-r5

- The `POSTGRES_` prefix on environment variables is now replaced by `POSTGRESQL_`
- `POSTGRES_USER` parameter has been renamed to `POSTGRESQL_USERNAME`.
- `POSTGRES_DB` parameter has been renamed to `POSTGRESQL_DATABASE`.
- `POSTGRES_MODE` parameter has been renamed to `POSTGRESQL_REPLICATION_MODE`.

### 9.5.3-r0

- All volumes have been merged at `/bitnami/postgresql`. Now you only need to mount a single volume at `/bitnami/postgresql` for persistence.
- The logs are always sent to the `stdout` and are no longer collected in the volume.

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/postgresql).

## License

Copyright &copy; 2026 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
