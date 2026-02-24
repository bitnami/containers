# Bitnami Secure Image for Redis&reg; Cluster

## What is Redis&reg; Cluster?

> Redis&reg; is an open source, scalable, distributed in-memory cache for applications. It can be used to store and serve data in the form of strings, hashes, lists, sets and sorted sets.

[Overview of Redis&reg; Cluster](https://redis.io)
Disclaimer: Redis is a registered trademark of Redis Ltd. Any rights therein are reserved to Redis Ltd. Any use by Bitnami is for referential purposes only and does not indicate any sponsorship, endorsement, or affiliation between Redis Ltd.

## TL;DR

```console
docker run --name redis-cluster -e ALLOW_EMPTY_PASSWORD=yes bitnami/redis-cluster:latest
```

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

## How to deploy Redis(R) Cluster in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Redis(R) Cluster Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/redis-cluster).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

## Get this image

The recommended way to get the Bitnami Redis(R) Cluster Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/redis-cluster).

```console
docker pull bitnami/redis-cluster:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/redis-cluster/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/redis-cluster:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/redis-cluster).

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami` path. If the mounted directory is empty, it will be initialized on the first run.

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Configuration

### Configuration file

The image looks for configurations in `/opt/bitnami/redis/mounted-etc/redis.conf`. You can overwrite the `redis.conf` file using your own custom configuration file.

Refer to the [Redis(R) configuration](https://redis.io/topics/config) manual for the complete list of configuration options.

### Overriding configuration

Instead of providing a custom `redis.conf`, you may also choose to provide only settings you wish to override. The image will look for `/opt/bitnami/redis/mounted-etc/overrides.conf`. This will be ignored if custom `redis.conf` is provided.

### Environment variables

#### Customizable environment variables

| Name                                    | Description                                                               | Default Value                              |
|-----------------------------------------|---------------------------------------------------------------------------|--------------------------------------------|
| `REDIS_DATA_DIR`                        | Redis data directory                                                      | `${REDIS_VOLUME_DIR}/data`                 |
| `REDIS_OVERRIDES_FILE`                  | Redis config overrides file                                               | `${REDIS_MOUNTED_CONF_DIR}/overrides.conf` |
| `REDIS_DISABLE_COMMANDS`                | Commands to disable in Redis                                              | `nil`                                      |
| `REDIS_DATABASE`                        | Default Redis database                                                    | `redis`                                    |
| `REDIS_AOF_ENABLED`                     | Enable AOF                                                                | `yes`                                      |
| `REDIS_RDB_POLICY`                      | Enable RDB policy persitence                                              | `nil`                                      |
| `REDIS_RDB_POLICY_DISABLED`             | Allows to enable RDB policy persistence                                   | `no`                                       |
| `REDIS_MASTER_HOST`                     | Redis master host (used by slaves)                                        | `nil`                                      |
| `REDIS_MASTER_PORT_NUMBER`              | Redis master host port (used by slaves)                                   | `6379`                                     |
| `REDIS_PORT_NUMBER`                     | Redis port number                                                         | `$REDIS_DEFAULT_PORT_NUMBER`               |
| `REDIS_ALLOW_REMOTE_CONNECTIONS`        | Allow remote connection to the service                                    | `yes`                                      |
| `REDIS_REPLICATION_MODE`                | Redis replication mode (values: master, slave)                            | `nil`                                      |
| `REDIS_REPLICA_IP`                      | The replication announce ip                                               | `nil`                                      |
| `REDIS_REPLICA_PORT`                    | The replication announce port                                             | `nil`                                      |
| `REDIS_EXTRA_FLAGS`                     | Additional flags pass to 'redis-server' commands                          | `nil`                                      |
| `ALLOW_EMPTY_PASSWORD`                  | Allow password-less access                                                | `no`                                       |
| `REDIS_PASSWORD`                        | Password for Redis                                                        | `nil`                                      |
| `REDIS_MASTER_PASSWORD`                 | Redis master node password                                                | `nil`                                      |
| `REDIS_ACLFILE`                         | Redis ACL file                                                            | `nil`                                      |
| `REDIS_IO_THREADS_DO_READS`             | Enable multithreading when reading socket                                 | `nil`                                      |
| `REDIS_IO_THREADS`                      | Number of threads                                                         | `nil`                                      |
| `REDIS_TLS_ENABLED`                     | Enable TLS                                                                | `no`                                       |
| `REDIS_TLS_PORT_NUMBER`                 | Redis TLS port (requires REDIS_ENABLE_TLS=yes)                            | `6379`                                     |
| `REDIS_TLS_CERT_FILE`                   | Redis TLS certificate file                                                | `nil`                                      |
| `REDIS_TLS_CA_DIR`                      | Directory containing TLS CA certificates                                  | `nil`                                      |
| `REDIS_TLS_KEY_FILE`                    | Redis TLS key file                                                        | `nil`                                      |
| `REDIS_TLS_KEY_FILE_PASS`               | Redis TLS key file passphrase                                             | `nil`                                      |
| `REDIS_TLS_CA_FILE`                     | Redis TLS CA file                                                         | `nil`                                      |
| `REDIS_TLS_DH_PARAMS_FILE`              | Redis TLS DH parameter file                                               | `nil`                                      |
| `REDIS_TLS_AUTH_CLIENTS`                | Enable Redis TLS client authentication                                    | `yes`                                      |
| `REDIS_CLUSTER_CREATOR`                 | Launch the cluster bootstrap command                                      | `no`                                       |
| `REDIS_CLUSTER_REPLICAS`                | Number of cluster replicas                                                | `1`                                        |
| `REDIS_CLUSTER_DYNAMIC_IPS`             | Use dynamic IPS for cluster creation                                      | `yes`                                      |
| `REDIS_CLUSTER_ANNOUNCE_IP`             | IP to use for announcing the cluster service                              | `nil`                                      |
| `REDIS_CLUSTER_ANNOUNCE_PORT`           | Client port to use for announcing the cluster service                     | `nil`                                      |
| `REDIS_CLUSTER_ANNOUNCE_BUS_PORT`       | Cluster message bus port to use for announcing the cluster service        | `nil`                                      |
| `REDIS_DNS_RETRIES`                     | Number of retries in order to get an addresable domain name               | `120`                                      |
| `REDIS_NODES`                           | List of Redis cluster nodes                                               | `nil`                                      |
| `REDIS_CLUSTER_SLEEP_BEFORE_DNS_LOOKUP` | Time to wait before the DNS lookup                                        | `0`                                        |
| `REDIS_CLUSTER_DNS_LOOKUP_RETRIES`      | Number of retires for the DNS lookup                                      | `1`                                        |
| `REDIS_CLUSTER_DNS_LOOKUP_SLEEP`        | Time to sleep between DNS lookups                                         | `1`                                        |
| `REDIS_CLUSTER_ANNOUNCE_HOSTNAME`       | Hostname that node should announce, used for non dynamic ip environments. | `nil`                                      |
| `REDIS_CLUSTER_PREFERRED_ENDPOINT_TYPE` | Preferred endpoint type which cluster should use (ip, hostname)           | `ip`                                       |

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

### Cluster Initialization Troubleshooting

Depending on the environment you're deploying into, you might run into issues where the cluster initialization is not completing successfully. One of the issue is related to the DNS lookup of the redis nodes performed during cluster initialization. By default, this DNS lookup is performed as soon as all the redis nodes reply to a successful ping.
However, in some environments such as Kubernetes, it can help to wait some time before performing this DNS lookup in order to prevent getting stale records. To this end, you can increase `REDIS_CLUSTER_SLEEP_BEFORE_DNS_LOOKUP` to a value around `30` which has been found to be good in most cases.

### Securing Redis(R) Cluster traffic

Starting with version 6, Redis(R) adds the support for SSL/TLS connections. Should you desire to enable this optional feature, you may use the aforementioned `REDIS_TLS_*` environment variables to configure the application.

When enabling TLS, conventional standard traffic is disabled by default. However this new feature is not mutually exclusive, which means it is possible to listen to both TLS and non-TLS connection simultaneously. To enable non-TLS traffic, set `REDIS_TLS_PORT_NUMBER` to another port different than `0`.

Alternatively, you may also provide with this configuration in your [custom](https://github.com/bitnami/containers/blob/main/bitnami/redis-cluster#configuration-file) configuration file.

### Enable Redis(R) Cluster RDB persistence

When the value of `REDIS_RDB_POLICY_DISABLED` is `no` (default value) the Redis(R) default persistence strategy will be used. If you want to modify the default strategy, you can configure it through the `REDIS_RDB_POLICY` parameter.

### FIPS configuration in Bitnami Secure Images

The Bitnami Redis&reg; Cluster Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Logging

The Bitnami Redis(R) Cluster Docker image sends the container logs to `stdout`. To view the logs:

```console
docker logs redis-cluster
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Upgrading

### To 5.0.12-debian-10-r48 release, 6.2.1-debian-10-r48 release , 6.0.12-debian-10-r48

The cluster initialization logic has changed. Now the container in charge of initialize the cluster will also be part of the cluster. It will initialize Redis in background, create the cluster and then bring back to foreground the Redis process.

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
