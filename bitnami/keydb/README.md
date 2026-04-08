# Bitnami Secure Image for KeyDB

> KeyDB is a high performance fork of Redis with a focus on multithreading, memory efficiency, and high throughput.

[Overview of KeyDB](https://github.com/Snapchat/KeyDB)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name keydb -e ALLOW_EMPTY_PASSWORD=yes bitnami/keydb:latest
```

**Warning**: These quick setups are only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options in the [Configuration](#configuration) section for a more secure deployment.

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

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

## Get this image

The Bitnami KeyDB Docker image is only available to [Bitnami Secure Images](https://bitnami.com) customers.

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/keydb).

## Persisting your database

KeyDB provides a different range of [persistence options](https://keydb.io/docs/topics/persistence.html). This contanier uses *AOF persistence by default* but it is easy to overwrite that configuration in a `docker-compose.yaml` file with this entry `command: /opt/bitnami/scripts/keydb/run.sh --appendonly no`. Alternatively, you may use the `KEYDB_AOF_ENABLED` env variable as explained in [Disabling AOF persistence](https://github.com/bitnami/containers/blob/main/bitnami/keydb#disabling-aof-persistence).

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami` path. If the mounted directory is empty, it will be initialized on the first run.

> **NOTE** As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a KeyDB server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Configuration

The following section describes the supported environment variables

### Environment variables

The following tables list the main variables you can set.

#### Customizable environment variables

| Name                             | Description                                                                         | Default Value                              |
|----------------------------------|-------------------------------------------------------------------------------------|--------------------------------------------|
| `KEYDB_DATA_DIR`                 | KeyDB data directory.                                                               | `${KEYDB_VOLUME_DIR}/data`                 |
| `KEYDB_OVERRIDES_FILE`           | KeyDB config overrides file.                                                        | `${KEYDB_MOUNTED_CONF_DIR}/overrides.conf` |
| `KEYDB_DISABLE_COMMANDS`         | Commands to disable.                                                                | `nil`                                      |
| `KEYDB_DATABASE`                 | Default database.                                                                   | `keydb`                                    |
| `KEYDB_AOF_ENABLED`              | Enable AOF.                                                                         | `yes`                                      |
| `KEYDB_RDB_POLICY`               | Enable RDB policy persistence.                                                      | `nil`                                      |
| `KEYDB_RDB_POLICY_DISABLED`      | Allows to enable RDB policy persistence.                                            | `no`                                       |
| `KEYDB_PORT_NUMBER`              | KeyDB port number.                                                                  | `$KEYDB_DEFAULT_PORT_NUMBER`               |
| `KEYDB_ALLOW_REMOTE_CONNECTIONS` | Allow remote connection to the service.                                             | `yes`                                      |
| `KEYDB_EXTRA_FLAGS`              | Additional flags pass to 'keydb-server' command.                                    | `nil`                                      |
| `ALLOW_EMPTY_PASSWORD`           | Allow password-less access.                                                         | `no`                                       |
| `KEYDB_PASSWORD`                 | KeyDB password.                                                                     | `nil`                                      |
| `KEYDB_ACL_FILE`                 | KeyDB ACL file.                                                                     | `nil`                                      |
| `KEYDB_IO_THREADS_DO_READS`      | Enable multithreading when reading socket.                                          | `nil`                                      |
| `KEYDB_IO_THREADS`               | Number of threads.                                                                  | `nil`                                      |
| `KEYDB_REPLICATION_MODE`         | Replication mode (values: master, replica).                                         | `nil`                                      |
| `KEYDB_ACTIVE_REPLICA`           | Configure KeyDB node as active-replica.                                             | `no`                                       |
| `KEYDB_MASTER_HOSTS`             | Comma separated list of hostnames of the KeyDB master instances to be a replica of. | `nil`                                      |
| `KEYDB_MASTER_PORT_NUMBER`       | Port number of the KeyDB master instances to be a replica of.                       | `6379`                                     |
| `KEYDB_MASTER_PASSWORD`          | Password to authenticate against the KeyDB master instance to be a replica of.      | `nil`                                      |
| `KEYDB_REPLICA_IP`               | The replication announce ip.                                                        | `nil`                                      |
| `KEYDB_REPLICA_PORT`             | The replication announce port.                                                      | `nil`                                      |
| `KEYDB_TLS_ENABLED`              | Enable TLS                                                                          | `no`                                       |
| `KEYDB_TLS_PORT_NUMBER`          | TLS port number.                                                                    | `6379`                                     |
| `KEYDB_TLS_CERT_FILE`            | TLS certificate file.                                                               | `nil`                                      |
| `KEYDB_TLS_CA_DIR`               | Directory containing TLS CA certificates.                                           | `nil`                                      |
| `KEYDB_TLS_KEY_FILE`             | TLS key file.                                                                       | `nil`                                      |
| `KEYDB_TLS_KEY_FILE_PASS`        | TLS key file passphrase.                                                            | `nil`                                      |
| `KEYDB_TLS_CA_FILE`              | TLS CA file.                                                                        | `nil`                                      |
| `KEYDB_TLS_DH_PARAMS_FILE`       | TLS DH parameter file.                                                              | `nil`                                      |
| `KEYDB_TLS_AUTH_CLIENTS`         | Enable TLS client authentication.                                                   | `yes`                                      |

#### Read-only environment variables

| Name                        | Description                            | Value                           |
|-----------------------------|----------------------------------------|---------------------------------|
| `KEYDB_VOLUME_DIR`          | KeyDB persistence base directory.      | `/bitnami/keydb`                |
| `KEYDB_BASE_DIR`            | KeyDB installation directory.          | `${BITNAMI_ROOT_DIR}/keydb`     |
| `KEYDB_CONF_DIR`            | KeyDB configuration directory.         | `${KEYDB_BASE_DIR}/etc`         |
| `KEYDB_DEFAULT_CONF_DIR`    | KeyDB default configuration directory. | `${KEYDB_BASE_DIR}/etc.default` |
| `KEYDB_MOUNTED_CONF_DIR`    | KeyDB mounted configuration directory. | `${KEYDB_BASE_DIR}/mounted-etc` |
| `KEYDB_CONF_FILE`           | KeyDB configuration file.              | `${KEYDB_CONF_DIR}/keydb.conf`  |
| `KEYDB_TMP_DIR`             | KeyDB temporary directory.             | `${KEYDB_BASE_DIR}/tmp`         |
| `KEYDB_PID_FILE`            | KeyDB PID file.                        | `${KEYDB_TMP_DIR}/keydb.pid`    |
| `KEYDB_BIN_DIR`             | KeyDB executables directory.           | `${KEYDB_BASE_DIR}/bin`         |
| `KEYDB_DAEMON_USER`         | KeyDB system user.                     | `keydb`                         |
| `KEYDB_DAEMON_GROUP`        | KeyDB system group.                    | `keydb`                         |
| `KEYDB_DEFAULT_PORT_NUMBER` | KeyDB port number (Build time).        | `6379`                          |

### Disabling KeyDB commands

For security reasons, you may want to disable some commands. You can specify them by using the following environment variable on the first run:

- `KEYDB_DISABLE_COMMANDS`: Comma-separated list of KeyDB commands to disable. Defaults to empty.

### Passing extra command-line flags to keydb-server startup

Passing extra command-line flags to the keydb service command is possible by adding them as arguments to *run.sh* script:

```console
docker run --name keydb -e ALLOW_EMPTY_PASSWORD=yes bitnami/keydb:latest /opt/bitnami/scripts/keydb/run.sh --maxmemory 100mb
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/keydb/docker-compose.yml) file present in this repository:

```yaml
services:
  keydb:
  ...
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    command: /opt/bitnami/scripts/keydb/run.sh --maxmemory 100mb
  ...
```

### Setting the server password on first run

Passing the `KEYDB_PASSWORD` environment variable when running the image for the first time will set the KeyDB server password to the value of `KEYDB_PASSWORD` (or the content of the file specified in `KEYDB_PASSWORD_FILE`).

**NOTE**: The at sign (`@`) is not supported for `KEYDB_PASSWORD`.

**Warning** The KeyDB database is always configured with remote access enabled. It's suggested that the `KEYDB_PASSWORD` env variable is always specified to set a password. In case you want to access the database without a password set the environment variable `ALLOW_EMPTY_PASSWORD=yes`. **This is recommended only for development**.

### Allowing empty passwords

By default the KeyDB image expects all the available passwords to be set. In order to allow empty passwords, it is necessary to set the `ALLOW_EMPTY_PASSWORD=yes` env variable. This env variable is only recommended for testing or development purposes. We strongly recommend specifying the `KEYDB_PASSWORD` for any other scenario.

### Disabling AOF persistence

KeyDB offers different [options](https://keydb.io/docs/topics/persistence.html) when it comes to persistence. By default, this image is set up to use the AOF (Append Only File) approach. Should you need to change this behaviour, setting the `KEYDB_AOF_ENABLED=no` env variable will disable this feature.

### Enabling Access Control List

KeyDB offers [ACL](https://keydb.io/docs/topics/acl.html) which allows certain connections to be limited in terms of the commands that can be executed and the keys that can be accessed. We strongly recommend enabling ACL in production by specifying the `KEYDB_ACL_FILE`.

```console
docker run -name keydb -e KEYDB_ACL_FILE=/opt/bitnami/keydb/mounted-etc/users.acl -v /path/to/users.acl:/opt/bitnami/keydb/mounted-etc/users.acl bitnami/keydb:latest
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/keydb/docker-compose.yml) file present in this repository:

```yaml
services:
  keydb:
  ...
    environment:
      - KEYDB_ACL_FILE=/opt/bitnami/keydb/mounted-etc/users.acl
    volumes:
      - /path/to/users.acl:/opt/bitnami/keydb/mounted-etc/users.acl
  ...
```

### Setting up a standalone instance

By default, this image is set up to launch KeyDB in standalone mode on port 6379. Should you need to change this behavior, setting the `KEYDB_PORT_NUMBER` environment variable will modify the port number. This is not to be confused with `KEYDB_MASTER_PORT_NUMBER` or `KEYDB_REPLICA_PORT` environment variables that are applicable in replication mode.

### Setting up replication

A replication cluster can easily be setup with the Bitnami KeyDB Docker Image using the following environment variables:

- `KEYDB_REPLICATION_MODE`: The replication mode. Possible values `master`/`replica`. No defaults.
- `KEYDB_ACTIVE_REPLICA`: Configure Replica node as active-replica. Defaults to `no`.
- `KEYDB_REPLICA_IP`: The replication announce ip. Defaults to `$(get_machine_ip)` which return the ip of the container.
- `KEYDB_REPLICA_PORT`: The replication announce port. Defaults to `KEYDB_MASTER_PORT_NUMBER`.
- `KEYDB_MASTER_HOSTS`: Comma separated list of Hostnames/IPs of KeyDB master instances to be a replica of (multiple hosts only supported if active-replica is enabled). No defaults.
- `KEYDB_MASTER_PORT_NUMBER`: Port number of the KeyDB master instances to be a replica of. Defaults to `6379`.
- `KEYDB_MASTER_PASSWORD`: Password to authenticate against the KeyDB master instances to be a replica of. No defaults.

There are three main architectures for replication in KeyDB:

- **Master/Replica**: In this architecture, a single KeyDB instance acts as the master, and one or more KeyDB instances act as replicas. The master is responsible for all write operations, while the replicas replicate the write operations from the master and serve read operations.
- **Active Replication**: In this architecture, a single KeyDB instance acts as the master, and one or more KeyDB instances act as active replicas. All instances can accept write operations and replicate them to the rest of the instances.
- **Multi Master Replication**: In this architecture, two or more KeyDB instances act as master, and replicas are configured to replicate from multiple masters. A replica with multiple masters will contain a superset of the data of all its masters. If two masters have a value with the same key it is undefined which key will be taken. If a master deletes a key that exists on another master the replica will no longer contain a copy of that key.

### Securing KeyDB traffic

KeyDB adds the support for SSL/TLS connections. Should you desire to enable this optional feature, you may use the following environment variables to configure the application:

- `KEYDB_TLS_ENABLED`: Whether to enable TLS for traffic or not. Defaults to `no`.
- `KEYDB_TLS_PORT_NUMBER`: Port used for TLS secure traffic. Defaults to `6379`.
- `KEYDB_TLS_CERT_FILE`: File containing the certificate file for the TLS traffic. No defaults.
- `KEYDB_TLS_KEY_FILE`: File containing the key for certificate. No defaults.
- `KEYDB_TLS_CA_FILE`: File containing the CA of the certificate (takes precedence over `KEYDB_TLS_CA_DIR`). No defaults.
- `KEYDB_TLS_CA_DIR`: Directory containing the CA certificates. No defaults.
- `KEYDB_TLS_DH_PARAMS_FILE`: File containing DH params (in order to support DH based ciphers). No defaults.
- `KEYDB_TLS_AUTH_CLIENTS`: Whether to require clients to authenticate or not. Defaults to `yes`.

When enabling TLS, conventional standard traffic is disabled by default. However this new feature is not mutually exclusive, which means it is possible to listen to both TLS and non-TLS connection simultaneously. To enable non-TLS traffic, set `KEYDB_TLS_PORT_NUMBER` to another port different than `0`.

Alternatively, you may also provide with this configuration in your [custom](https://github.com/bitnami/containers/blob/main/bitnami/keydb#configuration-file) configuration file.

### Configuration file

The image looks for configurations in `/opt/bitnami/keydb/mounted-etc/keydb.conf`. You can overwrite the `keydb.conf` file using your own custom configuration file.

### Overriding configuration

Instead of providing a custom `keydb.conf`, you may also choose to provide only settings you wish to override. The image will look for `/opt/bitnami/keydb/mounted-etc/overrides.conf`. This will be ignored if custom `keydb.conf` is provided.

### Enable KeyDB RDB persistence

When the value of `KEYDB_RDB_POLICY_DISABLED` is `no` (default value) the KeyDB default persistence strategy will be used. If you want to modify the default strategy, you can configure it through the `KEYDB_RDB_POLICY` parameter.

### FIPS configuration in Bitnami Secure Images

The Bitnami KeyDB Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Logging

The Bitnami KeyDB Docker image sends the container logs to the `stdout`. To view the logs:

```console
docker logs keydb
```

or using Docker Compose:

```console
docker-compose logs keydb
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

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
