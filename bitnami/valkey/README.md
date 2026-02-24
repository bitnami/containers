# Bitnami Secure Image for Valkey

## What is Valkey?

> Valkey is a high-performance data structure server that primarily serves key/value workloads. It supports a wide range of native structures and an extensible plugin system for adding new data structures and access patterns.

[Overview of Valkey](https://valkey.io/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name valkey -e ALLOW_EMPTY_PASSWORD=yes bitnami/valkey:latest
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

## How to deploy Valkey  in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Valkey Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/valkey).

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

## Get this image

The recommended way to get the Bitnami Valkey Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/valkey).

```console
docker pull bitnami/valkey:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/valkey/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/valkey:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/valkey).

## Persisting your database

Valkey provides a different range of [persistence options](https://valkey.io/docs/topics/persistence.html). This contanier uses *AOF persistence by default* but it is easy to overwrite that configuration in a `docker-compose.yaml` file with this entry `command: /opt/bitnami/scripts/valkey/run.sh --appendonly no`. Alternatively, you may use the `VALKEY_AOF_ENABLED` env variable as explained in [Disabling AOF persistence](https://github.com/bitnami/containers/blob/main/bitnami/valkey#disabling-aof-persistence).

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami` path. If the mounted directory is empty, it will be initialized on the first run.

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a Valkey server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Configuration

### Environment variables

#### Customizable environment variables

| Name                              | Description                                        | Default Value                               |
|-----------------------------------|----------------------------------------------------|---------------------------------------------|
| `VALKEY_DATA_DIR`                 | Valkey data directory                              | `${VALKEY_VOLUME_DIR}/data`                 |
| `VALKEY_OVERRIDES_FILE`           | Valkey config overrides file                       | `${VALKEY_MOUNTED_CONF_DIR}/overrides.conf` |
| `VALKEY_DISABLE_COMMANDS`         | Commands to disable in Valkey                      | `nil`                                       |
| `VALKEY_DATABASE`                 | Default Valkey database                            | `valkey`                                    |
| `VALKEY_AOF_ENABLED`              | Enable AOF                                         | `yes`                                       |
| `VALKEY_RDB_POLICY`               | Enable RDB policy persitence                       | `nil`                                       |
| `VALKEY_RDB_POLICY_DISABLED`      | Allows to enable RDB policy persistence            | `no`                                        |
| `VALKEY_PRIMARY_HOST`             | Valkey primary host (used by replicas)             | `nil`                                       |
| `VALKEY_PRIMARY_PORT_NUMBER`      | Valkey primary host port (used by replicas)        | `6379`                                      |
| `VALKEY_PORT_NUMBER`              | Valkey port number                                 | `$VALKEY_DEFAULT_PORT_NUMBER`               |
| `VALKEY_ALLOW_REMOTE_CONNECTIONS` | Allow remote connection to the service             | `yes`                                       |
| `VALKEY_REPLICATION_MODE`         | Valkey replication mode (values: primary, replica) | `nil`                                       |
| `VALKEY_REPLICA_IP`               | The replication announce ip                        | `nil`                                       |
| `VALKEY_REPLICA_PORT`             | The replication announce port                      | `nil`                                       |
| `VALKEY_EXTRA_FLAGS`              | Additional flags pass to 'valkey-server' commands  | `nil`                                       |
| `ALLOW_EMPTY_PASSWORD`            | Allow password-less access                         | `no`                                        |
| `VALKEY_PASSWORD`                 | Password for Valkey                                | `nil`                                       |
| `VALKEY_PRIMARY_PASSWORD`         | Valkey primary node password                       | `nil`                                       |
| `VALKEY_ACLFILE`                  | Valkey ACL file                                    | `nil`                                       |
| `VALKEY_IO_THREADS_DO_READS`      | Enable multithreading when reading socket          | `nil`                                       |
| `VALKEY_IO_THREADS`               | Number of threads                                  | `nil`                                       |
| `VALKEY_TLS_ENABLED`              | Enable TLS                                         | `no`                                        |
| `VALKEY_TLS_PORT_NUMBER`          | Valkey TLS port (requires VALKEY_ENABLE_TLS=yes)   | `6379`                                      |
| `VALKEY_TLS_CERT_FILE`            | Valkey TLS certificate file                        | `nil`                                       |
| `VALKEY_TLS_CA_DIR`               | Directory containing TLS CA certificates           | `nil`                                       |
| `VALKEY_TLS_KEY_FILE`             | Valkey TLS key file                                | `nil`                                       |
| `VALKEY_TLS_KEY_FILE_PASS`        | Valkey TLS key file passphrase                     | `nil`                                       |
| `VALKEY_TLS_CA_FILE`              | Valkey TLS CA file                                 | `nil`                                       |
| `VALKEY_TLS_DH_PARAMS_FILE`       | Valkey TLS DH parameter file                       | `nil`                                       |
| `VALKEY_TLS_AUTH_CLIENTS`         | Enable Valkey TLS client authentication            | `yes`                                       |
| `VALKEY_SENTINEL_PRIMARY_NAME`    | Valkey Sentinel primary name                       | `nil`                                       |
| `VALKEY_SENTINEL_HOST`            | Valkey Sentinel host                               | `nil`                                       |
| `VALKEY_SENTINEL_PORT_NUMBER`     | Valkey Sentinel host port (used by replicas)       | `26379`                                     |

#### Read-only environment variables

| Name                         | Description                            | Value                            |
|------------------------------|----------------------------------------|----------------------------------|
| `VALKEY_VOLUME_DIR`          | Persistence base directory             | `/bitnami/valkey`                |
| `VALKEY_BASE_DIR`            | Valkey installation directory          | `${BITNAMI_ROOT_DIR}/valkey`     |
| `VALKEY_CONF_DIR`            | Valkey configuration directory         | `${VALKEY_BASE_DIR}/etc`         |
| `VALKEY_DEFAULT_CONF_DIR`    | Valkey default configuration directory | `${VALKEY_BASE_DIR}/etc.default` |
| `VALKEY_MOUNTED_CONF_DIR`    | Valkey mounted configuration directory | `${VALKEY_BASE_DIR}/mounted-etc` |
| `VALKEY_CONF_FILE`           | Valkey configuration file              | `${VALKEY_CONF_DIR}/valkey.conf` |
| `VALKEY_LOG_DIR`             | Valkey logs directory                  | `${VALKEY_BASE_DIR}/logs`        |
| `VALKEY_LOG_FILE`            | Valkey log file                        | `${VALKEY_LOG_DIR}/valkey.log`   |
| `VALKEY_TMP_DIR`             | Valkey temporary directory             | `${VALKEY_BASE_DIR}/tmp`         |
| `VALKEY_PID_FILE`            | Valkey PID file                        | `${VALKEY_TMP_DIR}/valkey.pid`   |
| `VALKEY_BIN_DIR`             | Valkey executables directory           | `${VALKEY_BASE_DIR}/bin`         |
| `VALKEY_DAEMON_USER`         | Valkey system user                     | `valkey`                         |
| `VALKEY_DAEMON_GROUP`        | Valkey system group                    | `valkey`                         |
| `VALKEY_DEFAULT_PORT_NUMBER` | Valkey port number (Build time)        | `6379`                           |

### Disabling Valkey commands

For security reasons, you may want to disable some commands. You can specify them by using the following environment variable on the first run:

- `VALKEY_DISABLE_COMMANDS`: Comma-separated list of Valkey commands to disable. Defaults to empty.

### Passing extra command-line flags to valkey-server startup

Passing extra command-line flags to the valkey service command is possible by adding them as arguments to *run.sh* script:

```console
docker run --name valkey -e ALLOW_EMPTY_PASSWORD=yes bitnami/valkey:latest /opt/bitnami/scripts/valkey/run.sh --maxmemory 100mb
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/valkey/docker-compose.yml) file present in this repository:

```yaml
services:
  valkey:
  ...
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    command: /opt/bitnami/scripts/valkey/run.sh --maxmemory 100mb
  ...
```

### Setting the server password on first run

Passing the `VALKEY_PASSWORD` environment variable when running the image for the first time will set the Valkey server password to the value of `VALKEY_PASSWORD` (or the content of the file specified in `VALKEY_PASSWORD_FILE`).

**NOTE**: The at sign (`@`) is not supported for `VALKEY_PASSWORD`.

**Warning** The Valkey database is always configured with remote access enabled. It's suggested that the `VALKEY_PASSWORD` env variable is always specified to set a password. In case you want to access the database without a password set the environment variable `ALLOW_EMPTY_PASSWORD=yes`. **This is recommended only for development**.

### Allowing empty passwords

By default the Valkey image expects all the available passwords to be set. In order to allow empty passwords, it is necessary to set the `ALLOW_EMPTY_PASSWORD=yes` env variable. This env variable is only recommended for testing or development purposes. We strongly recommend specifying the `VALKEY_PASSWORD` for any other scenario.

### Disabling AOF persistence

Valkey offers different [options](https://valkey.io/docs/topics/persistence.html) when it comes to persistence. By default, this image is set up to use the AOF (Append Only File) approach. Should you need to change this behaviour, setting the `VALKEY_AOF_ENABLED=no` env variable will disable this feature.

### Enabling Access Control List

Valkey offers [ACL](https://valkey.io/docs/topics/acl.html) which allows certain connections to be limited in terms of the commands that can be executed and the keys that can be accessed. We strongly recommend enabling ACL in production by specifiying the `VALKEY_ACLFILE`.

```console
docker run -name valkey -e VALKEY_ACLFILE=/opt/bitnami/valkey/mounted-etc/users.acl -v /path/to/users.acl:/opt/bitnami/valkey/mounted-etc/users.acl bitnami/valkey:latest
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/valkey/docker-compose.yml) file present in this repository:

```yaml
services:
  valkey:
  ...
    environment:
      - VALKEY_ACLFILE=/opt/bitnami/valkey/mounted-etc/users.acl
    volumes:
      - /path/to/users.acl:/opt/bitnami/valkey/mounted-etc/users.acl
  ...
```

### Setting up a standalone instance

By default, this image is set up to launch Valkey in standalone mode on port 6379. Should you need to change this behavior, setting the `VALKEY_PORT_NUMBER` environment variable will modify the port number. This is not to be confused with `VALKEY_PRIMARY_PORT_NUMBER` or `VALKEY_REPLICA_PORT` environment variables that are applicable in replication mode.

### Setting up replication

A replication cluster can easily be setup with the Bitnami Valkey Docker Image using the following environment variables:

- `VALKEY_REPLICATION_MODE`: The replication mode. Possible values `primary`/`replica`. No defaults.
- `VALKEY_REPLICA_IP`: The replication announce ip. Defaults to `$(get_machine_ip)` which return the ip of the container.
- `VALKEY_REPLICA_PORT`: The replication announce port. Defaults to `VALKEY_PRIMARY_PORT_NUMBER`.
- `VALKEY_PRIMARY_HOST`: Hostname/IP of replication primary (replica node parameter). No defaults.
- `VALKEY_PRIMARY_PORT_NUMBER`: Server port of the replication primaty (replica node parameter). Defaults to `6379`.
- `VALKEY_PRIMARY_PASSWORD`: Password to authenticate with the primary (replica node parameter). No defaults. As an alternative, you can mount a file with the password and set the `VALKEY_PRIMARY_PASSWORD_FILE` variable.

In a replication cluster you can have one primary and zero or more replicas. When replication is enabled the primary node is in read-write mode, while the replicas are in read-only mode. For best performance its advisable to limit the reads to the replicas.

### Securing Valkey traffic

Valkey adds the support for SSL/TLS connections. Should you desire to enable this optional feature, you may use the following environment variables to configure the application:

- `VALKEY_TLS_ENABLED`: Whether to enable TLS for traffic or not. Defaults to `no`.
- `VALKEY_TLS_PORT_NUMBER`: Port used for TLS secure traffic. Defaults to `6379`.
- `VALKEY_TLS_CERT_FILE`: File containing the certificate file for the TLS traffic. No defaults.
- `VALKEY_TLS_KEY_FILE`: File containing the key for certificate. No defaults.
- `VALKEY_TLS_CA_FILE`: File containing the CA of the certificate (takes precedence over `VALKEY_TLS_CA_DIR`). No defaults.
- `VALKEY_TLS_CA_DIR`: Directory containing the CA certificates. No defaults.
- `VALKEY_TLS_DH_PARAMS_FILE`: File containing DH params (in order to support DH based ciphers). No defaults.
- `VALKEY_TLS_AUTH_CLIENTS`: Whether to require clients to authenticate or not. Defaults to `yes`.

When enabling TLS, conventional standard traffic is disabled by default. However this new feature is not mutually exclusive, which means it is possible to listen to both TLS and non-TLS connection simultaneously. To enable non-TLS traffic, set `VALKEY_TLS_PORT_NUMBER` to another port different than `0`.

Alternatively, you may also provide with this configuration in your [custom](https://github.com/bitnami/containers/blob/main/bitnami/valkey#configuration-file) configuration file.

### Configuration file

The image looks for configurations in `/opt/bitnami/valkey/mounted-etc/valkey.conf`. You can overwrite the `valkey.conf` file using your own custom configuration file.

```console
docker run --name valkey \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -v /path/to/your_valkey.conf:/opt/bitnami/valkey/mounted-etc/valkey.conf \
    -v /path/to/valkey-data-persistence:/bitnami/valkey/data \
    bitnami/valkey:latest
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/valkey/docker-compose.yml) file present in this repository:

```yaml
services:
  valkey:
  ...
    volumes:
      - /path/to/your_valkey.conf:/opt/bitnami/valkey/mounted-etc/valkey.conf
      - /path/to/valkey-persistence:/bitnami/valkey/data
  ...
```

### Overriding configuration

Instead of providing a custom `valkey.conf`, you may also choose to provide only settings you wish to override. The image will look for `/opt/bitnami/valkey/mounted-etc/overrides.conf`. This will be ignored if custom `valkey.conf` is provided.

```console
docker run --name valkey \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -v /path/to/overrides.conf:/opt/bitnami/valkey/mounted-etc/overrides.conf \
    bitnami/valkey:latest
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/valkey/docker-compose.yml) file present in this repository:

```yaml
services:
  valkey:
  ...
    volumes:
      - /path/to/overrides.conf:/opt/bitnami/valkey/mounted-etc/overrides.conf
  ...
```

### Enable Valkey RDB persistence

When the value of `VALKEY_RDB_POLICY_DISABLED` is `no` (default value) the Valkey default persistence strategy will be used. If you want to modify the default strategy, you can configure it through the `VALKEY_RDB_POLICY` parameter.

### FIPS configuration in Bitnami Secure Images

The Bitnami Valkey Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Logging

The Bitnami Valkey Docker image sends the container logs to the `stdout`. To view the logs:

```console
docker logs valkey
```

or using Docker Compose:

```console
docker-compose logs valkey
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Notable Changes

### Starting October 20, 2024

- All the references have been updated from `master/slave` to `primary/replica` to follow the upstream project strategy. Environment variables previously prefixed as `VALKEY_MASTER` or `VALKEY_SENTINEL_MASTER` use `VALKEY_PRIMARY` and `VALKEY_SENTINEL_PRIMARY` now.

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
