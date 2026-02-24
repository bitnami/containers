# Bitnami Secure Image for Valkey Cluster

## What is Valkey Cluster?

> Valkey is an open source (BSD) high-performance key/value datastore that supports a variety workloads such as caching, message queues, and can act as a primary database.

[Overview of Valkey Cluster](https://valkey.io/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name valkey-cluster -e ALLOW_EMPTY_PASSWORD=yes bitnami/valkey-cluster:latest
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

## How to deploy Valkey Cluster in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Valkey Cluster Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/valkey-cluster).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

## Get this image

The recommended way to get the Bitnami Valkey Cluster Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/valkey-cluster).

```console
docker pull bitnami/valkey-cluster:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/valkey-cluster/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/valkey-cluster:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/valkey-cluster).

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami` path. If the mounted directory is empty, it will be initialized on the first run.

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Overriding configuration

Instead of providing a custom `valkey.conf`, you may also choose to provide only settings you wish to override. The image will look for `/opt/bitnami/valkey/mounted-etc/overrides.conf`. This will be ignored if custom `valkey.conf` is provided.

### Environment variables

#### Customizable environment variables

| Name                                     | Description                                                               | Default Value                               |
|------------------------------------------|---------------------------------------------------------------------------|---------------------------------------------|
| `VALKEY_DATA_DIR`                        | Valkey data directory                                                     | `${VALKEY_VOLUME_DIR}/data`                 |
| `VALKEY_OVERRIDES_FILE`                  | Valkey config overrides file                                              | `${VALKEY_MOUNTED_CONF_DIR}/overrides.conf` |
| `VALKEY_DISABLE_COMMANDS`                | Commands to disable in Valkey                                             | `nil`                                       |
| `VALKEY_DATABASE`                        | Default Valkey database                                                   | `valkey`                                    |
| `VALKEY_AOF_ENABLED`                     | Enable AOF                                                                | `yes`                                       |
| `VALKEY_RDB_POLICY`                      | Enable RDB policy persitence                                              | `nil`                                       |
| `VALKEY_RDB_POLICY_DISABLED`             | Allows to enable RDB policy persistence                                   | `no`                                        |
| `VALKEY_PRIMARY_HOST`                    | Valkey primary host (used by replicas)                                    | `nil`                                       |
| `VALKEY_PRIMARY_PORT_NUMBER`             | Valkey primary host port (used by replicas)                               | `6379`                                      |
| `VALKEY_PORT_NUMBER`                     | Valkey port number                                                        | `$VALKEY_DEFAULT_PORT_NUMBER`               |
| `VALKEY_ALLOW_REMOTE_CONNECTIONS`        | Allow remote connection to the service                                    | `yes`                                       |
| `VALKEY_REPLICATION_MODE`                | Valkey replication mode (values: primary, replica)                        | `nil`                                       |
| `VALKEY_REPLICA_IP`                      | The replication announce ip                                               | `nil`                                       |
| `VALKEY_REPLICA_PORT`                    | The replication announce port                                             | `nil`                                       |
| `VALKEY_EXTRA_FLAGS`                     | Additional flags pass to 'valkey-server' commands                         | `nil`                                       |
| `ALLOW_EMPTY_PASSWORD`                   | Allow password-less access                                                | `no`                                        |
| `VALKEY_PASSWORD`                        | Password for Valkey                                                       | `nil`                                       |
| `VALKEY_PRIMARY_PASSWORD`                | Valkey primary node password                                              | `nil`                                       |
| `VALKEY_ACLFILE`                         | Valkey ACL file                                                           | `nil`                                       |
| `VALKEY_IO_THREADS_DO_READS`             | Enable multithreading when reading socket                                 | `nil`                                       |
| `VALKEY_IO_THREADS`                      | Number of threads                                                         | `nil`                                       |
| `VALKEY_TLS_ENABLED`                     | Enable TLS                                                                | `no`                                        |
| `VALKEY_TLS_PORT_NUMBER`                 | Valkey TLS port (requires VALKEY_ENABLE_TLS=yes)                          | `6379`                                      |
| `VALKEY_TLS_CERT_FILE`                   | Valkey TLS certificate file                                               | `nil`                                       |
| `VALKEY_TLS_CA_DIR`                      | Directory containing TLS CA certificates                                  | `nil`                                       |
| `VALKEY_TLS_KEY_FILE`                    | Valkey TLS key file                                                       | `nil`                                       |
| `VALKEY_TLS_KEY_FILE_PASS`               | Valkey TLS key file passphrase                                            | `nil`                                       |
| `VALKEY_TLS_CA_FILE`                     | Valkey TLS CA file                                                        | `nil`                                       |
| `VALKEY_TLS_DH_PARAMS_FILE`              | Valkey TLS DH parameter file                                              | `nil`                                       |
| `VALKEY_TLS_AUTH_CLIENTS`                | Enable Valkey TLS client authentication                                   | `yes`                                       |
| `VALKEY_CLUSTER_CREATOR`                 | Launch the cluster bootstrap command                                      | `no`                                        |
| `VALKEY_CLUSTER_REPLICAS`                | Number of cluster replicas                                                | `1`                                         |
| `VALKEY_CLUSTER_DYNAMIC_IPS`             | Use dynamic IPS for cluster creation                                      | `yes`                                       |
| `VALKEY_CLUSTER_ANNOUNCE_IP`             | IP to use for announcing the cluster service                              | `nil`                                       |
| `VALKEY_CLUSTER_ANNOUNCE_PORT`           | Client port to use for announcing the cluster service                     | `nil`                                       |
| `VALKEY_CLUSTER_ANNOUNCE_BUS_PORT`       | Cluster message bus port to use for announcing the cluster service        | `nil`                                       |
| `VALKEY_DNS_RETRIES`                     | Number of retries in order to get an addresable domain name               | `120`                                       |
| `VALKEY_NODES`                           | List of Valkey cluster nodes                                              | `nil`                                       |
| `VALKEY_CLUSTER_SLEEP_BEFORE_DNS_LOOKUP` | Time to wait before the DNS lookup                                        | `0`                                         |
| `VALKEY_CLUSTER_DNS_LOOKUP_RETRIES`      | Number of retires for the DNS lookup                                      | `1`                                         |
| `VALKEY_CLUSTER_DNS_LOOKUP_SLEEP`        | Time to sleep between DNS lookups                                         | `1`                                         |
| `VALKEY_CLUSTER_ANNOUNCE_HOSTNAME`       | Hostname that node should announce, used for non dynamic ip environments. | `nil`                                       |
| `VALKEY_CLUSTER_PREFERRED_ENDPOINT_TYPE` | Preferred endpoint type which cluster should use (ip, hostname)           | `ip`                                        |

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

Once all the Valkey nodes are running you need to execute command like the following to initiate the cluster:

```console
valkey-cli --cluster create node1:port node2:port --cluster-replicas 1 --cluster-yes
```

Where you can add all the `node:port` that you want. The `--cluster-replicas` parameters indicates how many replicas you want to have for every primary.

### Cluster Initialization Troubleshooting

Depending on the environment you're deploying into, you might run into issues where the cluster initialization is not completing successfully. One of the issue is related to the DNS lookup of the valkey nodes performed during cluster initialization. By default, this DNS lookup is performed as soon as all the valkey nodes reply to a successful ping.
However, in some environments such as Kubernetes, it can help to wait some time before performing this DNS lookup in order to prevent getting stale records. To this end, you can increase `VALKEY_CLUSTER_SLEEP_BEFORE_DNS_LOOKUP` to a value around `30` which has been found to be good in most cases.

### Securing Valkey Cluster traffic

Valkey adds the support for SSL/TLS connections, to enable this optional feature, you may use the aforementioned `VALKEY_TLS_*` environment variables to configure the application.

When enabling TLS, conventional standard traffic is disabled by default. However this new feature is not mutually exclusive, which means it is possible to listen to both TLS and non-TLS connection simultaneously. To enable non-TLS traffic, set `VALKEY_TLS_PORT_NUMBER` to another port different than `0`.

Alternatively, you may also provide with this configuration in your [custom](https://github.com/bitnami/containers/blob/main/bitnami/valkey-cluster#configuration-file) configuration file.

### Enable Valkey Cluster RDB persistence

When the value of `VALKEY_RDB_POLICY_DISABLED` is `no` (default value) the Valkey default persistence strategy will be used. If you want to modify the default strategy, you can configure it through the `VALKEY_RDB_POLICY` parameter.

### FIPS configuration in Bitnami Secure Images

The Bitnami Valkey Cluster Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Logging

The Bitnami Valkey Cluster Docker image sends the container logs to `stdout`. To view the logs:

```console
docker logs valkey-cluster
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
