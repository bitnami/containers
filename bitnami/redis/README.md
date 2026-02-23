# Bitnami Secure Image for Redis&reg;

## What is Redis&reg;?

> Redis&reg; is an open source, advanced key-value store. It is often referred to as a data structure server since keys can contain strings, hashes, lists, sets and sorted sets.

[Overview of Redis&reg;](https://redis.io)
Disclaimer: Redis is a registered trademark of Redis Ltd. Any rights therein are reserved to Redis Ltd. Any use by Bitnami is for referential purposes only and does not indicate any sponsorship, endorsement, or affiliation between Redis Ltd.

## TL;DR

```console
docker run --name redis -e ALLOW_EMPTY_PASSWORD=yes bitnami/redis:latest
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

## How to deploy Redis(R) in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Redis(R) Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/redis).

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

## Get this image

The recommended way to get the Bitnami Redis(R) Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/redis).

```console
docker pull bitnami/redis:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/redis/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/redis:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/redis).

## Persisting your database

Redis(R) provides a different range of [persistence options](https://redis.io/topics/persistence). This contanier uses *AOF persistence by default* but it is easy to overwrite that configuration in a `docker-compose.yaml` file with this entry `command: /opt/bitnami/scripts/redis/run.sh --appendonly no`. Alternatively, you may use the `REDIS_AOF_ENABLED` env variable as explained in [Disabling AOF persistence](https://github.com/bitnami/containers/blob/main/bitnami/redis#disabling-aof-persistence).

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami` path. If the mounted directory is empty, it will be initialized on the first run.

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a Redis(R) server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Configuration

### Environment variables

#### Customizable environment variables

| Name                             | Description                                      | Default Value                              |
|----------------------------------|--------------------------------------------------|--------------------------------------------|
| `REDIS_DATA_DIR`                 | Redis data directory                             | `${REDIS_VOLUME_DIR}/data`                 |
| `REDIS_OVERRIDES_FILE`           | Redis config overrides file                      | `${REDIS_MOUNTED_CONF_DIR}/overrides.conf` |
| `REDIS_DISABLE_COMMANDS`         | Commands to disable in Redis                     | `nil`                                      |
| `REDIS_DATABASE`                 | Default Redis database                           | `redis`                                    |
| `REDIS_AOF_ENABLED`              | Enable AOF                                       | `yes`                                      |
| `REDIS_RDB_POLICY`               | Enable RDB policy persitence                     | `nil`                                      |
| `REDIS_RDB_POLICY_DISABLED`      | Allows to enable RDB policy persistence          | `no`                                       |
| `REDIS_MASTER_HOST`              | Redis master host (used by slaves)               | `nil`                                      |
| `REDIS_MASTER_PORT_NUMBER`       | Redis master host port (used by slaves)          | `6379`                                     |
| `REDIS_PORT_NUMBER`              | Redis port number                                | `$REDIS_DEFAULT_PORT_NUMBER`               |
| `REDIS_ALLOW_REMOTE_CONNECTIONS` | Allow remote connection to the service           | `yes`                                      |
| `REDIS_REPLICATION_MODE`         | Redis replication mode (values: master, slave)   | `nil`                                      |
| `REDIS_REPLICA_IP`               | The replication announce ip                      | `nil`                                      |
| `REDIS_REPLICA_PORT`             | The replication announce port                    | `nil`                                      |
| `REDIS_EXTRA_FLAGS`              | Additional flags pass to 'redis-server' commands | `nil`                                      |
| `ALLOW_EMPTY_PASSWORD`           | Allow password-less access                       | `no`                                       |
| `REDIS_PASSWORD`                 | Password for Redis                               | `nil`                                      |
| `REDIS_MASTER_PASSWORD`          | Redis master node password                       | `nil`                                      |
| `REDIS_ACLFILE`                  | Redis ACL file                                   | `nil`                                      |
| `REDIS_IO_THREADS_DO_READS`      | Enable multithreading when reading socket        | `nil`                                      |
| `REDIS_IO_THREADS`               | Number of threads                                | `nil`                                      |
| `REDIS_TLS_ENABLED`              | Enable TLS                                       | `no`                                       |
| `REDIS_TLS_PORT_NUMBER`          | Redis TLS port (requires REDIS_ENABLE_TLS=yes)   | `6379`                                     |
| `REDIS_TLS_CERT_FILE`            | Redis TLS certificate file                       | `nil`                                      |
| `REDIS_TLS_CA_DIR`               | Directory containing TLS CA certificates         | `nil`                                      |
| `REDIS_TLS_KEY_FILE`             | Redis TLS key file                               | `nil`                                      |
| `REDIS_TLS_KEY_FILE_PASS`        | Redis TLS key file passphrase                    | `nil`                                      |
| `REDIS_TLS_CA_FILE`              | Redis TLS CA file                                | `nil`                                      |
| `REDIS_TLS_DH_PARAMS_FILE`       | Redis TLS DH parameter file                      | `nil`                                      |
| `REDIS_TLS_AUTH_CLIENTS`         | Enable Redis TLS client authentication           | `yes`                                      |
| `REDIS_SENTINEL_MASTER_NAME`     | Redis Sentinel master name                       | `nil`                                      |
| `REDIS_SENTINEL_HOST`            | Redis Sentinel host                              | `nil`                                      |
| `REDIS_SENTINEL_PORT_NUMBER`     | Redis Sentinel host port (used by slaves)        | `26379`                                    |

#### Read-only environment variables

| Name                        | Description                           | Value                           |
|-----------------------------|---------------------------------------|---------------------------------|
| `REDIS_VOLUME_DIR`          | Persistence base directory            | `/bitnami/redis`                |
| `REDIS_BASE_DIR`            | Redis installation directory          | `${BITNAMI_ROOT_DIR}/redis`     |
| `REDIS_CONF_DIR`            | Redis configuration directory         | `${REDIS_BASE_DIR}/etc`         |
| `REDIS_DEFAULT_CONF_DIR`    | Redis default configuration directory | `${REDIS_BASE_DIR}/etc.default` |
| `REDIS_MOUNTED_CONF_DIR`    | Redis mounted configuration directory | `${REDIS_BASE_DIR}/mounted-etc` |
| `REDIS_CONF_FILE`           | Redis configuration file              | `${REDIS_CONF_DIR}/redis.conf`  |
| `REDIS_LOG_DIR`             | Redis logs directory                  | `${REDIS_BASE_DIR}/logs`        |
| `REDIS_LOG_FILE`            | Redis log file                        | `${REDIS_LOG_DIR}/redis.log`    |
| `REDIS_TMP_DIR`             | Redis temporary directory             | `${REDIS_BASE_DIR}/tmp`         |
| `REDIS_PID_FILE`            | Redis PID file                        | `${REDIS_TMP_DIR}/redis.pid`    |
| `REDIS_BIN_DIR`             | Redis executables directory           | `${REDIS_BASE_DIR}/bin`         |
| `REDIS_DAEMON_USER`         | Redis system user                     | `redis`                         |
| `REDIS_DAEMON_GROUP`        | Redis system group                    | `redis`                         |
| `REDIS_DEFAULT_PORT_NUMBER` | Redis port number (Build time)        | `6379`                          |

### Disabling Redis(R) commands

For security reasons, you may want to disable some commands. You can specify them by using the following environment variable on the first run:

- `REDIS_DISABLE_COMMANDS`: Comma-separated list of Redis(R) commands to disable. Defaults to empty.

### Passing extra command-line flags to redis-server startup

Passing extra command-line flags to the redis service command is possible by adding them as arguments to *run.sh* script:

```console
docker run --name redis -e ALLOW_EMPTY_PASSWORD=yes bitnami/redis:latest /opt/bitnami/scripts/redis/run.sh --maxmemory 100mb
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/redis/docker-compose.yml) file present in this repository:

```yaml
services:
  redis:
  ...
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    command: /opt/bitnami/scripts/redis/run.sh --maxmemory 100mb
  ...
```

Refer to the [Redis(R) documentation](https://redis.io/topics/config#passing-arguments-via-the-command-line) for the complete list of arguments.

### Setting the server password on first run

Passing the `REDIS_PASSWORD` environment variable when running the image for the first time will set the Redis(R) server password to the value of `REDIS_PASSWORD` (or the content of the file specified in `REDIS_PASSWORD_FILE`).

**NOTE**: The at sign (`@`) is not supported for `REDIS_PASSWORD`.

**Warning** The Redis(R) database is always configured with remote access enabled. It's suggested that the `REDIS_PASSWORD` env variable is always specified to set a password. In case you want to access the database without a password set the environment variable `ALLOW_EMPTY_PASSWORD=yes`. **This is recommended only for development**.

### Allowing empty passwords

By default the Redis(R) image expects all the available passwords to be set. In order to allow empty passwords, it is necessary to set the `ALLOW_EMPTY_PASSWORD=yes` env variable. This env variable is only recommended for testing or development purposes. We strongly recommend specifying the `REDIS_PASSWORD` for any other scenario.

### Enabling/Setting multithreading

Redis 6.0 features a [new multi-threading model](https://segmentfault.com/a/1190000040376111/en). You can set both `io-threads` and `io-threads-do-reads` though the env vars `REDIS_IO_THREADS` and `REDIS_IO_THREADS_DO_READS`

### Disabling AOF persistence

Redis(R) offers different [options](https://redis.io/topics/persistence) when it comes to persistence. By default, this image is set up to use the AOF (Append Only File) approach. Should you need to change this behaviour, setting the `REDIS_AOF_ENABLED=no` env variable will disable this feature.

### Enabling Access Control List

Redis(R) offers [ACL](https://redis.io/topics/acl) since 6.0 which allows certain connections to be limited in terms of the commands that can be executed and the keys that can be accessed. We strongly recommend enabling ACL in production by specifiying the `REDIS_ACLFILE`.

```console
docker run -name redis -e REDIS_ACLFILE=/opt/bitnami/redis/mounted-etc/users.acl -v /path/to/users.acl:/opt/bitnami/redis/mounted-etc/users.acl bitnami/redis:latest
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/redis/docker-compose.yml) file present in this repository:

```yaml
services:
  redis:
  ...
    environment:
      - REDIS_ACLFILE=/opt/bitnami/redis/mounted-etc/users.acl
    volumes:
      - /path/to/users.acl:/opt/bitnami/redis/mounted-etc/users.acl
  ...
```

### Setting up replication

A [replication](https://redis.io/topics/replication) cluster can easily be setup with the Bitnami Redis(R) Docker Image using the following environment variables:

- `REDIS_REPLICATION_MODE`: The replication mode. Possible values `master`/`slave`. No defaults.
- `REDIS_REPLICA_IP`: The replication announce ip. Defaults to `$(get_machine_ip)` which return the ip of the container.
- `REDIS_REPLICA_PORT`: The replication announce port. Defaults to `REDIS_MASTER_PORT_NUMBER`.
- `REDIS_MASTER_HOST`: Hostname/IP of replication master (replica node parameter). No defaults.
- `REDIS_MASTER_PORT_NUMBER`: Server port of the replication master (replica node parameter). Defaults to `6379`.
- `REDIS_MASTER_PASSWORD`: Password to authenticate with the master (replica node parameter). No defaults. As an alternative, you can mount a file with the password and set the `REDIS_MASTER_PASSWORD_FILE` variable.

In a replication cluster you can have one master and zero or more replicas. When replication is enabled the master node is in read-write mode, while the replicas are in read-only mode. For best performance its advisable to limit the reads to the replicas.

### Securing Redis(R) traffic

Starting with version 6, Redis(R) adds the support for SSL/TLS connections. Should you desire to enable this optional feature, you may use the following environment variables to configure the application:

- `REDIS_TLS_ENABLED`: Whether to enable TLS for traffic or not. Defaults to `no`.
- `REDIS_TLS_PORT_NUMBER`: Port used for TLS secure traffic. Defaults to `6379`.
- `REDIS_TLS_CERT_FILE`: File containing the certificate file for the TLS traffic. No defaults.
- `REDIS_TLS_KEY_FILE`: File containing the key for certificate. No defaults.
- `REDIS_TLS_CA_FILE`: File containing the CA of the certificate (takes precedence over `REDIS_TLS_CA_DIR`). No defaults.
- `REDIS_TLS_CA_DIR`: Directory containing the CA certificates. No defaults.
- `REDIS_TLS_DH_PARAMS_FILE`: File containing DH params (in order to support DH based ciphers). No defaults.
- `REDIS_TLS_AUTH_CLIENTS`: Whether to require clients to authenticate or not. Defaults to `yes`.

When enabling TLS, conventional standard traffic is disabled by default. However this new feature is not mutually exclusive, which means it is possible to listen to both TLS and non-TLS connection simultaneously. To enable non-TLS traffic, set `REDIS_TLS_PORT_NUMBER` to another port different than `0`.

Alternatively, you may also provide with this configuration in your [custom](https://github.com/bitnami/containers/blob/main/bitnami/redis#configuration-file) configuration file.

### Configuration file

The image looks for configurations in `/opt/bitnami/redis/mounted-etc/redis.conf`. You can overwrite the `redis.conf` file using your own custom configuration file.

```console
docker run --name redis \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -v /path/to/your_redis.conf:/opt/bitnami/redis/mounted-etc/redis.conf \
    -v /path/to/redis-data-persistence:/bitnami/redis/data \
    bitnami/redis:latest
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/redis/docker-compose.yml) file present in this repository:

```yaml
services:
  redis:
  ...
    volumes:
      - /path/to/your_redis.conf:/opt/bitnami/redis/mounted-etc/redis.conf
      - /path/to/redis-persistence:/bitnami/redis/data
  ...
```

Refer to the [Redis(R) configuration](https://redis.io/topics/config) manual for the complete list of configuration options.

### Overriding configuration

Instead of providing a custom `redis.conf`, you may also choose to provide only settings you wish to override. The image will look for `/opt/bitnami/redis/mounted-etc/overrides.conf`. This will be ignored if custom `redis.conf` is provided.

```console
docker run --name redis \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -v /path/to/overrides.conf:/opt/bitnami/redis/mounted-etc/overrides.conf \
    bitnami/redis:latest
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/redis/docker-compose.yml) file present in this repository:

```yaml
services:
  redis:
  ...
    volumes:
      - /path/to/overrides.conf:/opt/bitnami/redis/mounted-etc/overrides.conf
  ...
```

### Enable Redis(R) RDB persistence

When the value of `REDIS_RDB_POLICY_DISABLED` is `no` (default value) the Redis(R) default persistence strategy will be used. If you want to modify the default strategy, you can configure it through the `REDIS_RDB_POLICY` parameter.

### FIPS configuration in Bitnami Secure Images

The Bitnami Redis&reg; Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Logging

The Bitnami Redis(R) Docker image sends the container logs to the `stdout`. To view the logs:

```console
docker logs redis
```

or using Docker Compose:

```console
docker-compose logs redis
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Notable Changes

### 5.0.8-debian-10-r24

- The recommended mount point to use a custom `redis.conf` changes from `/opt/bitnami/redis/etc/` to `/opt/bitnami/redis/mounted-etc/`.

### 5.0.0-r0

- Starting with Redis(R) 5.0 the command [REPLICAOF](https://redis.io/commands/replicaof) is available in favor of `SLAVEOF`. For backward compatibility with previous versions, `slave` replication mode is still supported. We encourage the use of the `REPLICAOF` command if you are using Redis(R) 5.0.

### 4.0.1-r24

- Decrease the size of the container. It is not necessary Node.js anymore. Redis(R) configuration moved to bash scripts in the `rootfs/` folder.
- The recommended mount point to persist data changes to `/bitnami/redis/data`.
- The main `redis.conf` file is not persisted in a volume. The path is `/opt/bitnami/redis/mounted-etc/redis.conf`.
- Backwards compatibility is not guaranteed when data is persisted using docker-compose. You can use the workaround below to overcome it:

```bash
docker-compose down
## Locate your volume and modify the file tree
VOLUME=$(docker volume ls | grep "redis_data" | awk '{print $2}')
docker run --rm -i -v=${VOLUME}:/tmp/redis busybox find /tmp/redis/data -maxdepth 1 -exec mv {} /tmp/redis \;
docker run --rm -i -v=${VOLUME}:/tmp/redis busybox rm -rf /tmp/redis/{data,conf,.initialized}
## Change the mount point
sed -i -e 's#redis_data:/bitnami/redis#redis_data:/bitnami/redis/data#g' docker-compose.yml
## Pull the latest bitnami/redis image
docker pull bitnami/redis:latest
docker-compose up -d
```

### 4.0.1-r1

- The redis container has been migrated to a non-root container approach. Previously the container run as `root` user and the redis daemon was started as `redis` user. From now own, both the container and the redis daemon run as user `1001`.
  As a consequence, the configuration files are writable by the user running the redis process.

### 3.2.0-r0

- All volumes have been merged at `/bitnami/redis`. Now you only need to mount a single volume at `/bitnami/redis` for persistence.
- The logs are always sent to the `stdout` and are no longer collected in the volume.

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
