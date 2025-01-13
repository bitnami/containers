# Bitnami package for Valkey Cluster

## What is Valkey Cluster?

> Valkey is an open source (BSD) high-performance key/value datastore that supports a variety workloads such as caching, message queues, and can act as a primary database.

[Overview of Valkey Cluster](https://valkey.io/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name valkey-cluster -e ALLOW_EMPTY_PASSWORD=yes bitnami/valkey-cluster:latest
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Valkey Cluster in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## How to deploy Valkey Cluster in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Valkey Cluster Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/valkey-cluster).

Bitnami containers can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

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

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami` path. If the mounted directory is empty, it will be initialized on the first run.

```console
docker run \
    -e ALLOW_EMPTY_PASSWORD=yes
    -v /path/to/valkey-cluster-persistence:/bitnami \
    bitnami/valkey-cluster:latest
```

You can also do this with a minor change to the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/valkey-cluster/docker-compose.yml) file present in this repository:

```yaml
valkey-cluster:
  ...
  volumes:
    - /path/to/valkey-cluster-persistence:/bitnami
  ...
```

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

#### Step 1: Create a network

```console
docker network create valkey-cluster-network --driver bridge
```

#### Step 2: Launch the Valkey Cluster container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `valkey-cluster-network` network.

```console
docker run -e ALLOW_EMPTY_PASSWORD=yes --name valkey-cluster-node1 --network valkey-cluster-network bitnami/valkey-cluster:latest
```

#### Step 3: Run another containers

We can launch another containers using the same flag (`--network NETWORK`) in the `docker run` command. If you also set a name to your container, you will be able to use it as hostname in your network.

## Configuration

### Configuration file

The image looks for configurations in `/opt/bitnami/valkey/mounted-etc/valkey.conf`. You can overwrite the `valkey.conf` file using your own custom configuration file.

```console
docker run --name valkey-cluster \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -v /path/to/your_valkey.conf:/opt/bitnami/valkey/mounted-etc/valkey.conf \
    -v /path/to/valkey-data-persistence:/bitnami/valkey/data \
    bitnami/valkey-cluster:latest
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/valkey-cluster/docker-compose.yml) file present in this repository:

```yaml
services:
  valkey-node-0:
  ...
    volumes:
      - /path/to/your_valkey.conf:/opt/bitnami/valkey/mounted-etc/valkey.conf
      - /path/to/valkey-persistence:/bitnami/valkey/data
  ...
```

Refer to the [Valkey configuration](https://valkey.io//docs) manual for the complete list of configuration options.

### Overriding configuration

Instead of providing a custom `valkey.conf`, you may also choose to provide only settings you wish to override. The image will look for `/opt/bitnami/valkey/mounted-etc/overrides.conf`. This will be ignored if custom `valkey.conf` is provided.

```console
docker run --name valkey-cluster \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -v /path/to/overrides.conf:/opt/bitnami/valkey/mounted-etc/overrides.conf \
    bitnami/valkey:latest
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/valkey-cluster/docker-compose.yml) file present in this repository:

```yaml
services:
  valkey:
  ...
    volumes:
      - /path/to/overrides.conf:/opt/bitnami/valkey/mounted-etc/overrides.conf
  ...
```

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

1. Using `docker run`

    ```console
    $ docker run --name valkey-cluster \
        -v /path/to/certs:/opt/bitnami/valkey/certs \
        -v /path/to/valkey-cluster-persistence:/bitnami \
        -e ALLOW_EMPTY_PASSWORD=yes \
        -e VALKEY_TLS_ENABLED=yes \
        -e VALKEY_TLS_CERT_FILE=/opt/bitnami/valkey/certs/valkey.crt \
        -e VALKEY_TLS_KEY_FILE=/opt/bitnami/valkey/certs/valkey.key \
        -e VALKEY_TLS_CA_FILE=/opt/bitnami/valkey/certs/valkeyCA.crt \
        bitnami/valkey-cluster:latest
    ```

2. Modifying the `docker-compose.yml` file present in this repository:

    ```yaml
      valkey-cluster:
      ...
        environment:
          ...
          - VALKEY_TLS_ENABLED=yes
          - VALKEY_TLS_CERT_FILE=/opt/bitnami/valkey/certs/valkey.crt
          - VALKEY_TLS_KEY_FILE=/opt/bitnami/valkey/certs/valkey.key
          - VALKEY_TLS_CA_FILE=/opt/bitnami/valkey/certs/valkeyCA.crt
        ...
        volumes:
          - /path/to/certs:/opt/bitnami/valkey/certs
        ...
      ...
    ```

Alternatively, you may also provide with this configuration in your [custom](https://github.com/bitnami/containers/blob/main/bitnami/valkey-cluster#configuration-file) configuration file.

### Enable Valkey Cluster RDB persistence

When the value of `VALKEY_RDB_POLICY_DISABLED` is `no` (default value) the Valkey default persistence strategy will be used. If you want to modify the default strategy, you can configure it through the `VALKEY_RDB_POLICY` parameter. Here is a demonstration of modifying the default persistence strategy

1. Using `docker run`

    ```console
    $ docker run --name valkey-cluster \
        -v /path/to/valkey-cluster-persistence:/bitnami \
        -e ALLOW_EMPTY_PASSWORD=yes \
        -e VALKEY_RDB_POLICY_DISABLED=no
        -e VALKEY_RDB_POLICY="900#1 600#5 300#10 120#50 60#1000 30#10000"
        bitnami/valkey-cluster:latest
    ```

2. Modifying the `docker-compose.yml` file present in this repository:

    ```yaml
      valkey-cluster:
      ...
        environment:
          ...
          - VALKEY_TLS_ENABLED=yes
          - VALKEY_RDB_POLICY_DISABLED=no
          - VALKEY_RDB_POLICY="900#1 600#5 300#10 120#50 60#1000 30#10000"
        ...
      ...
    ```

## Logging

The Bitnami Valkey Cluster Docker image sends the container logs to `stdout`. To view the logs:

```console
docker logs valkey-cluster
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of Valkey Cluster, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/valkey-cluster:latest
```

#### Step 2: Stop the running container

Stop the currently running container using the command

```console
docker stop valkey-cluster
```

#### Step 3: Remove the currently running container

```console
docker rm -v valkey-cluster
```

#### Step 4: Run the new image

Re-create your container from the new image.

```console
docker run --name valkey-cluster bitnami/valkey-cluster:latest
```

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/valkey-cluster).

If you detect any issue in the `docker-compose.yaml` file, feel free to report it or contribute with a fix by following our [Contributing Guidelines](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md).

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Notable Changes

### Starting October 20, 2024

* All the references have been updated from `master/slave` to `primary/replica` to follow the upstream project strategy. Environment variables previously prefixed as `VALKEY_MASTER` or `VALKEY_SENTINEL_MASTER` use `VALKEY_PRIMARY` and `VALKEY_SENTINEL_PRIMARY` now.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/containers/issues/new/choose). For us to provide better support, be sure to fill the issue template.

## License

Copyright &copy; 2025 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
