# Bitnami Secure Image for PostgreSQL HA

## What is PostgreSQL HA?

> This PostgreSQL cluster solution includes the PostgreSQL replication manager, an open-source tool for managing replication and failover on PostgreSQL clusters.

[Overview of PostgreSQL HA](https://www.postgresql.org)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name postgresql-repmgr bitnami/postgresql-repmgr:latest
```

You can find the default credentials and available configuration options in the [Environment Variables](#environment-variables) section.

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

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## How to deploy Postgresql-repmgr in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami PostgreSQL HA Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/postgresql-ha).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

## Get this image

The recommended way to get the Bitnami PostgreSQL HA Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/postgresql-repmgr).

```console
docker pull bitnami/postgresql-repmgr:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/postgresql-repmgr/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/postgresql-repmgr:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/postgresql-ha).

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/postgresql` path. If the mounted directory is empty, it will be initialized on the first run.

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a PostgreSQL server running inside a container can easily be accessed by your application containers and vice-versa.

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
| `REPMGR_DATA_DIR`                          | Replication Manager data directory                                                                   | `${REPMGR_VOLUME_DIR}/repmgr/data`         |
| `REPMGR_SKIP_SETUP`                        | Skip Replication manager (and PostgreSQL) setup.                                                     | `no`                                       |
| `REPMGR_NODE_ID`                           | Replication Manager node identifier                                                                  | `nil`                                      |
| `REPMGR_NODE_ID_START_SEED`                | Replication Manager node identifier start seed                                                       | `1000`                                     |
| `REPMGR_NODE_NAME`                         | Replication Manager node name                                                                        | `$(hostname)`                              |
| `REPMGR_NODE_NETWORK_NAME`                 | Replication Manager node network name                                                                | `nil`                                      |
| `REPMGR_NODE_PRIORITY`                     | Replication Manager node priority                                                                    | `100`                                      |
| `REPMGR_NODE_LOCATION`                     | Replication Manager node location                                                                    | `default`                                  |
| `REPMGR_NODE_TYPE`                         | Replication Manager node type                                                                        | `data`                                     |
| `REPMGR_PORT_NUMBER`                       | Replication Manager port number                                                                      | `5432`                                     |
| `REPMGR_LOG_LEVEL`                         | Replication Manager logging level                                                                    | `NOTICE`                                   |
| `REPMGR_USE_PGREWIND`                      | (Experimental) Use pg_rewind to synchronize from primary node                                        | `no`                                       |
| `REPMGR_START_OPTIONS`                     | Options to add when starting the node                                                                | `nil`                                      |
| `REPMGR_CONNECT_TIMEOUT`                   | Replication Manager node connection timeout (in seconds)                                             | `5`                                        |
| `REPMGR_RECONNECT_ATTEMPTS`                | Number of attempts to connect to the cluster before failing                                          | `3`                                        |
| `REPMGR_RECONNECT_INTERVAL`                | Replication Manager node reconnect interval (in seconds)                                             | `5`                                        |
| `REPMGR_PARTNER_NODES`                     | List of other Replication Manager nodes in the cluster                                               | `nil`                                      |
| `REPMGR_PRIMARY_HOST`                      | Replication Manager cluster primary node                                                             | `nil`                                      |
| `REPMGR_PRIMARY_PORT`                      | Replication Manager cluster primary node port                                                        | `5432`                                     |
| `REPMGR_USE_REPLICATION_SLOTS`             | Replication Manager replication slots                                                                | `1`                                        |
| `REPMGR_MASTER_RESPONSE_TIMEOUT`           | Time (in seconds) to wait for the master to reply                                                    | `20`                                       |
| `REPMGR_PRIMARY_VISIBILITY_CONSENSUS`      | Replication Manager flag to enable consult each other to build a quorum                              | `false`                                    |
| `REPMGR_MONITORING_HISTORY`                | Replication Manager flag to enable monitoring history                                                | `no`                                       |
| `REPMGR_MONITOR_INTERVAL_SECS`             | Replication Manager interval at which to write monitoring data                                       | `2`                                        |
| `REPMGR_DEGRADED_MONITORING_TIMEOUT`       | Replication Manager degraded monitoring timeout                                                      | `5`                                        |
| `REPMGR_UPGRADE_EXTENSION`                 | Replication Manager upgrade extension                                                                | `no`                                       |
| `REPMGR_FENCE_OLD_PRIMARY`                 | Replication Manager fence old primary                                                                | `no`                                       |
| `REPMGR_FAILOVER`                          | Replication failover mode                                                                            | `automatic`                                |
| `REPMGR_CHILD_NODES_CHECK_INTERVAL`        | Replication Manager time interval to check nodes                                                     | `5`                                        |
| `REPMGR_CHILD_NODES_CONNECTED_MIN_COUNT`   | Replication Manager minimal connected nodes                                                          | `1`                                        |
| `REPMGR_CHILD_NODES_DISCONNECT_TIMEOUT`    | Replication Manager disconnected nodes timeout                                                       | `30`                                       |
| `REPMGR_SWITCH_ROLE`                       | Flag to switch current node role                                                                     | `no`                                       |
| `REPMGR_CURRENT_PRIMARY_HOST`              | Current primary host                                                                                 | `nil`                                      |
| `REPMGR_USERNAME`                          | Replication manager username                                                                         | `repmgr`                                   |
| `REPMGR_DATABASE`                          | Replication manager database                                                                         | `repmgr`                                   |
| `REPMGR_PGHBA_TRUST_ALL`                   | Add trust all in Replication Manager pg_hba.conf                                                     | `no`                                       |
| `REPMGR_PASSWORD`                          | Replication manager password                                                                         | `nil`                                      |
| `REPMGR_USE_PASSFILE`                      | Use PGPASSFILE instead of PGPASSWORD                                                                 | `nil`                                      |
| `REPMGR_PASSFILE_PATH`                     | Path to store passfile                                                                               | `$REPMGR_CONF_DIR/.pgpass`                 |
| `PGCONNECT_TIMEOUT`                        | PostgreSQL connection timeout                                                                        | `10`                                       |

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
| `REPMGR_BASE_DIR`                            | Replication Manager installation directory                      | `/opt/bitnami/repmgr`                         |
| `REPMGR_CONF_DIR`                            | Replication Manager configuration directory                     | `$REPMGR_BASE_DIR/conf`                       |
| `REPMGR_VOLUME_DIR`                          | Persistence base directory                                      | `/bitnami/repmgr`                             |
| `REPMGR_MOUNTED_CONF_DIR`                    | Replication Manager mounted configuration directory             | `$REPMGR_VOLUME_DIR/conf`                     |
| `REPMGR_TMP_DIR`                             | Replication Manager temporary directory                         | `$REPMGR_BASE_DIR/tmp`                        |
| `REPMGR_EVENTS_DIR`                          | Replication Manager events directory                            | `$REPMGR_BASE_DIR/events`                     |
| `REPMGR_LOCK_DIR`                            | Replication Manager lock files directory                        | `$POSTGRESQL_VOLUME_DIR/lock`                 |
| `REPMGR_PRIMARY_ROLE_LOCK_FILE_NAME`         | Replication Manager lock file for the primary role              | `$REPMGR_LOCK_DIR/master.lock`                |
| `REPMGR_STANDBY_ROLE_LOCK_FILE_NAME`         | Replication Manager lock file for the standby node              | `$REPMGR_LOCK_DIR/standby.lock`               |
| `REPMGR_BIN_DIR`                             | Replication Manager executables directory                       | `$REPMGR_BASE_DIR/bin`                        |
| `REPMGR_CONF_FILE`                           | Replication Manager configuration file                          | `$REPMGR_CONF_DIR/repmgr.conf`                |
| `REPMGR_PID_FILE`                            | Replication Manager PID file.                                   | `${REPMGR_TMP_DIR}/repmgr.pid`                |
| `REPMGR_CURRENT_PRIMARY_PORT`                | Current primary host port                                       | `$REPMGR_PRIMARY_PORT`                        |
| `POSTGRESQL_REPLICATION_USER`                | PostgreSQL replication user                                     | `$REPMGR_USERNAME`                            |
| `POSTGRESQL_REPLICATION_PASSWORD`            | Password for the PostgreSQL replication user                    | `$REPMGR_PASSWORD`                            |
| `POSTGRESQL_REPLICATION_USE_PASSFILE`        | Use PGPASSFILE instead of PGPASSWORD                            | `$REPMGR_USE_PASSFILE`                        |
| `POSTGRESQL_REPLICATION_PASSFILE_PATH`       | Path to store passfile                                          | `$REPMGR_PASSFILE_PATH`                       |
| `POSTGRESQL_MASTER_HOST`                     | PostgreSQL master host                                          | `$REPMGR_PRIMARY_HOST`                        |
| `POSTGRESQL_MASTER_PORT_NUMBER`              | PostgreSQL master host port                                     | `$REPMGR_PRIMARY_PORT`                        |

### Initializing a new instance

When the container is executed for the first time, it will execute the files with extensions `.sh`, `.sql` and `.sql.gz` located at `/docker-entrypoint-initdb.d`.

In order to have your custom files inside the docker image you can mount them as a volume.

### Setting the root and repmgr passwords on first run

In the above commands you may have noticed the use of the `POSTGRESQL_PASSWORD` and `REPMGR_PASSWORD` environment variables. Passing the `POSTGRESQL_PASSWORD` environment variable when running the image for the first time will set the password of the `postgres` user to the value of `POSTGRESQL_PASSWORD` (or the content of the file specified in `POSTGRESQL_PASSWORD_FILE`). In the same way, passing the `REPMGR_PASSWORD` environment variable sets the password of the `repmgr` user to the value of `REPMGR_PASSWORD` (or the content of the file specified in `REPMGR_PASSWORD_FILE`).

> NOTE: Both `postgres` and `repmgr` users are superusers and have full administrative access to the PostgreSQL database.

Refer to [Creating a database user on first run](#creating-a-database-user-on-first-run) if you want to set an unprivileged user and a password for the `postgres` user.

### Creating a database on first run

By passing the `POSTGRESQL_DATABASE` environment variable when running the image for the first time, a database will be created. This is useful if your application requires that a database already exists, saving you from having to manually create the database using the PostgreSQL client.

### Creating a database user on first run

You can also create a restricted database user that only has permissions for the database created with the [`POSTGRESQL_DATABASE`](#creating-a-database-on-first-run) environment variable. To do this, provide the `POSTGRESQL_USERNAME` environment variable.

> NOTE: When `POSTGRESQL_USERNAME` is specified, the `postgres` user is not assigned a password and as a result you cannot login remotely to the PostgreSQL server as the `postgres` user. If you still want to have access with the user `postgres`, please set the `POSTGRESQL_POSTGRES_PASSWORD` environment variable (or the content of the file specified in `POSTGRESQL_POSTGRES_PASSWORD_FILE`).

### Setting up a HA PostgreSQL cluster with streaming replication and repmgr

A HA PostgreSQL cluster with [Streaming replication](https://www.postgresql.orgdocs/10/warm-standby.html#STREAMING-REPLICATION) and [repmgr](https://repmgr.org) can easily be setup with the Bitnami PostgreSQL HA Docker Image using the following environment variables:

- `POSTGRESQL_PASSWORD`: Password for `postgres` user. No defaults.
- `POSTGRESQL_PASSWORD_FILE`: Path to a file that contains the `postgres` user password. This will override the value specified in `POSTGRESQL_PASSWORD`. No defaults.
- `REPMGR_USERNAME`: Username for `repmgr` user. Defaults to `repmgr`.
- `REPMGR_PASSWORD_FILE`: Path to a file that contains the `repmgr` user password. This will override the value specified in `REPMGR_PASSWORD`. No defaults.
- `REPMGR_PASSWORD`: Password for `repmgr` user. No defaults.
- `REPMGR_USE_PASSFILE`: Configure repmgr to use `passfile` and `PGPASSFILE` instead of plain-text password in its configuration.
- `REPMGR_PASSFILE_PATH`: Location of the passfile, if it doesn't exist it will be created using REPMGR credentials.
- `REPMGR_PRIMARY_HOST`: Hostname of the initial primary node. No defaults.
- `REPMGR_PARTNER_NODES`: Comma separated list of partner nodes in the cluster.  No defaults.
- `REPMGR_NODE_NAME`: Node name. No defaults.
- `REPMGR_NODE_TYPE`: Node type. Defaults to `data`. Allowed values: `data` for data nodes (master or replicas), `witness` for witness nodes.
- `REPMGR_NODE_NETWORK_NAME`: Node hostname. No defaults.
- `REPMGR_PGHBA_TRUST_ALL`: This will set the auth-method in the generated pg_hba.conf. Set it to `yes` only if you are using pgpool with LDAP authentication. Default to `no`.

In a HA PostgreSQL cluster you can have one primary and zero or more standby nodes. The primary node is in read-write mode, while the standby nodes are in read-only mode. For best performance its advisable to limit the reads to the standby nodes.

> NOTE: REPMGR_USE_PASSFILE and REPMGR_PASSFILE_PATH will be ignored for Postgresql prior to version 9.6.
>
> When mounting an external passfile using REPMGR_PASSFILE_PATH, it is necessary to also configure REPMGR_PASSWORD and REPMGR_USERNAME accordingly.

### Securing PostgreSQL traffic

PostgreSQL supports the encryption of connections using the SSL/TLS protocol. Should you desire to enable this optional feature, you may use the following environment variables to configure the application:

- `POSTGRESQL_ENABLE_TLS`: Whether to enable TLS for traffic or not. Defaults to `no`.
- `POSTGRESQL_TLS_CERT_FILE`: File containing the certificate file for the TLS traffic. No defaults.
- `POSTGRESQL_TLS_KEY_FILE`: File containing the key for certificate. No defaults.
- `POSTGRESQL_TLS_CA_FILE`: File containing the CA of the certificate. If provided, PostgreSQL will authenticate TLS/SSL clients by requesting them a certificate (see [ref](https://www.postgresql.orgdocs/9.6/auth-methods.html)). No defaults.
- `POSTGRESQL_TLS_CRL_FILE`: File containing a Certificate Revocation List. No defaults.
- `POSTGRESQL_TLS_PREFER_SERVER_CIPHERS`: Whether to use the server's TLS cipher preferences rather than the client's. Defaults to `yes`.

When enabling TLS, PostgreSQL will support both standard and encrypted traffic by default, but prefer the latter.

Alternatively, you may also provide this configuration in your [custom](https://github.com/bitnami/containers/tree/main/bitnami/postgresql-repmgr) configuration file.

### Configuration file

The image looks for the `repmgr.conf`, `postgresql.conf` and `pg_hba.conf` files in `/opt/bitnami/repmgr/conf/` and `/opt/bitnami/postgresql/conf/`. You can mount a volume at `/bitnami/repmgr/conf/` and copy/edit the configuration files in the `/path/to/custom-conf/`. The default configurations will be populated to the `conf/` directories if `/bitnami/repmgr/conf/` is empty.

Refer to the [server configuration](http://www.postgresql.org/docs/10/static/runtime-config.html) manual for the complete list of configuration options.

#### Allow settings to be loaded from files other than the default `postgresql.conf`

Apart of using a custom `repmgr.conf`, `postgresql.conf` or `pg_hba.conf`, you can include files ending in `.conf` from the `conf.d` directory in the volume at `/bitnami/postgresql/conf/`.

### Adding extra services to base docker-compose.yaml

It is possible to add extra services to the provided `docker-compose.yaml` file, like [a witness node](https://repmgr.org/docs/4.3/repmgrd-witness-server.html). When adding the new service, please take into account the cluster set up process relays on the `REPMGR_NODE_ID_START_SEED` environment variable plus the service ID in the name (if present, or zero (`0`) by default) to assign cluster's ID to each service/node involved on it. In the case of docker-compose based clusters, this may lead to collisions in the internal IDs in case two or more services share the same ID in their names, making the service initialization process to fail. This isn't an issue on Kubernetes environments, as the Kubernetes controller enumerates the pods with different ID numbers by default.

We recommend setting a different value for the `REPMGR_NODE_ID_START_SEED` in those nodes, or ensuring no services names use repeated numbers.

Refer to [issues/27124](https://github.com/bitnami/containers/issues/27124) for further details on this.

### FIPS configuration in Bitnami Secure Images

The Bitnami PostgreSQL HA Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Logging

The Bitnami PostgreSQL HA Docker image sends the container logs to `stdout`. To view the logs:

```console
docker logs pg-0
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Notable Changes

### 9.6.16-centos-7-r71, 10.11.0-centos-7-r71, 11.6.0-centos-7-r67, and 12.1.0-centos-7-r67

- `9.6.16-centos-7-r71`, `10.11.0-centos-7-r71`, `11.6.0-centos-7-r67`, and `12.1.0-centos-7-r67` are considered the latest images based on CentOS.
- Standard supported distros: Debian & OEL.

### 9.6.15-r18, 9.6.15-ol-7-r23, 9.6.15-centos-7-r23, 10.10.0-r18, 10.10.0-ol-7-r23, 10.10.0-centos-7-r23, 11.5.0-r19, 11.5.0-centos-7-r23, 11.5.0-ol-7-r23

- Adds Postgis extension to postgresql, version 2.3.x to Postgresiql 9.6 and version 2.5 to 10, 11 and 12.

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
