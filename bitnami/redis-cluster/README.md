# What is Redis(TM) Cluster packaged by Bitnami?

Disclaimer: REDIS(r) is a registered trademark of Redis Labs Ltd.Any rights therein are reserved to Redis Labs Ltd. Any use by Bitnami is for referential
purposes only and does not indicate any sponsorship, endorsement, or affiliation between Redis Labs Ltd.

> Redis(TM) is an advanced key-value cache and store. It is often referred to as a data structure server since keys can contain strings, hashes, lists, sets, sorted sets, bitmaps and hyperloglogs.

[Redis.io](https://redis.io/)

# TL;DR

```console
$ docker run --name redis-cluster -e ALLOW_EMPTY_PASSWORD=yes bitnami/redis-cluster:latest
```

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-redis-cluster/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.

> This [CVE scan report](https://quay.io/repository/bitnami/redis-cluster?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy Redis(TM) Cluster in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Redis(TM) Cluster Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/redis-cluster).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`6.2`, `6.2-debian-10`, `6.2.3`, `6.2.3-debian-10-r13`, `latest` (6.2/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-redis-cluster/blob/6.2.3-debian-10-r13/6.2/debian-10/Dockerfile)
* [`6.0`, `6.0-debian-10`, `6.0.13`, `6.0.13-debian-10-r14` (6.0/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-redis-cluster/blob/6.0.13-debian-10-r14/6.0/debian-10/Dockerfile)
* [`5.0`, `5.0-debian-10`, `5.0.12`, `5.0.12-debian-10-r73` (5.0/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-redis-cluster/blob/5.0.12-debian-10-r73/5.0/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/redis-cluster GitHub repo](https://github.com/bitnami/bitnami-docker-redis-cluster).

# Get this image

The recommended way to get the Bitnami Redis(TM) Cluster Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/redis-cluster).

```console
$ docker pull bitnami/redis-cluster:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/redis-cluster/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/redis-cluster:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/redis-cluster:latest 'https://github.com/bitnami/bitnami-docker-redis-cluster.git#master:6.2/debian-10'
```

# Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami` path. If the mounted directory is empty, it will be initialized on the first run.

```console
$ docker run \
    -e ALLOW_EMPTY_PASSWORD=yes
    -v /path/to/redis-cluster-persistence:/bitnami \
    bitnami/redis-cluster:latest
```

You can also do this with a minor change to the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-redis-cluster/blob/master/docker-compose.yml) file present in this repository:

```yaml
redis-cluster:
  ...
  volumes:
    - /path/to/redis-cluster-persistence:/bitnami
  ...
```

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

### Step 1: Create a network

```console
$ docker network create redis-cluster-network --driver bridge
```

### Step 2: Launch the Redis(TM) Cluster container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `redis-cluster-network` network.

```console
$ docker run -e ALLOW_EMPTY_PASSWORD=yes --name redis-cluster-node1 --network redis-cluster-network bitnami/redis-cluster:latest
```

### Step 3: Run another containers

We can launch another containers using the same flag (`--network NETWORK`) in the `docker run` command. If you also set a name to your container, you will be able to use it as hostname in your network.

# Configuration

## Configuration file

The image looks for configurations in `/opt/bitnami/redis/mounted-etc/redis.conf`. You can overwrite the `redis.conf` file using your own custom configuration file.

```console
$ docker run --name redis \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -v /path/to/your_redis.conf:/opt/bitnami/redis/mounted-etc/redis.conf \
    -v /path/to/redis-data-persistence:/bitnami/redis/data \
    bitnami/redis-cluster:latest
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-redis/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  redis-node-0:
  ...
    volumes:
      - /path/to/your_redis.conf:/opt/bitnami/redis/mounted-etc/redis.conf
      - /path/to/redis-persistence:/bitnami/redis/data
  ...
```

Refer to the [Redis(TM) configuration](http://redis.io/topics/config) manual for the complete list of configuration options.

The following env vars are supported for this container:

| Name                                    | Description                                                                                                                                                                            |
|-----------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `REDIS_DISABLE_COMMANDS`                | Disables the specified Redis(TM) commands                                                                                                                                              |
| `REDIS_PORT_NUMBER`                     | Set the Redis(TM) port. Default=: `6379`                                                                                                                                               |
| `REDIS_PASSWORD`                        | Set the Redis(TM) password. Default: `bitnami`                                                                                                                                         |
| `ALLOW_EMPTY_PASSWORD`                  | Enables access without password                                                                                                                                                        |
| `REDIS_DNS_RETRIES`                     | Number of retries to get the IPs of the provided `REDIS_NODES`. It will wait 5 seconds between retries                                                                                 |
| `REDISCLI_AUTH`                         | Provide the same value as the configured `REDIS_PASSWORD` for the redis-cli tool to authenticate                                                                                       |
| `REDIS_CLUSTER_CREATOR`                 | Set to `yes` if the container will be the one on charge of initialize the cluster. This node will also be part of the cluster.                                                         |
| `REDIS_CLUSTER_REPLICAS`                | Number of replicas for every master that the cluster will have.                                                                                                                        |
| `REDIS_NODES`                           | String delimited by spaces containing the hostnames of all of the nodes that will be part of the cluster                                                                               |
| `REDIS_CLUSTER_ANNOUNCE_IP`             | IP that the node should announce, used for non dynamic ip environents                                                                                                                  |
| `REDIS_CLUSTER_DYNAMIC_IPS`             | Set to `no` if your Redis(TM) cluster will be created with statical IPs. Default: `yes`                                                                                                |
| `REDIS_TLS_ENABLED`                     | Whether to enable TLS for traffic or not. Defaults to `no`.                                                                                                                            |
| `REDIS_TLS_PORT`                        | Port used for TLS secure traffic. Defaults to `6379`.                                                                                                                                  |
| `REDIS_TLS_CERT_FILE`                   | File containing the certificate file for the TSL traffic. No defaults.                                                                                                                 |
| `REDIS_TLS_KEY_FILE`                    | File containing the key for certificate. No defaults.                                                                                                                                  |
| `REDIS_TLS_CA_FILE`                     | File containing the CA of the certificate. No defaults.                                                                                                                                |
| `REDIS_TLS_DH_PARAMS_FILE`              | File containing DH params (in order to support DH based ciphers). No defaults.                                                                                                         |
| `REDIS_TLS_AUTH_CLIENTS`                | Whether to require clients to authenticate or not. Defaults to `yes`.                                                                                                                  |
| `REDIS_CLUSTER_SLEEP_BEFORE_DNS_LOOKUP` | Number of seconds to wait before initializing the cluster. Set this to a higher value if you sometimes have issues with initial cluster creation. Defaults to `0`.                     |
| `REDIS_CLUSTER_DNS_LOOKUP_RETRIES`      | Number of retries for the node's DNS lookup during the initial cluster creation. Defaults to `5`.                                                                                      |
| `REDIS_CLUSTER_DNS_LOOKUP_SLEEP`        | Number of seconds to wait between each node's DNS lookup during the initial cluster creation. Defaults to `1`.                                                                         |

Once all the Redis(TM) nodes are running you need to execute command like the following to initiate the cluster:

```console
redis-cli --cluster create node1:port node2:port --cluster-replicas 1 --cluster-yes
```

Where you can add all the `node:port` that you want. The `--cluster-replicas` parameters indicates how many replicas you want to have for every master.

## Cluster Initialization Troubleshooting

Depending on the environment you're deploying into, you might run into issues where the cluster initialization
is not completing successfully. One of the issue is related to the DNS lookup of the redis nodes performed during
cluster initialization. By default, this DNS lookup is performed as soon as all the redis nodes reply to
a successful ping. However, in some environments such as Kubernetes, it can help to wait some time before
performing this DNS lookup in order to prevent getting stale records. To this end, you can increase
`REDIS_CLUSTER_SLEEP_BEFORE_DNS_LOOKUP` to a value around `30` which has been found to be good in most cases. You can
check the discussion regarding this [here](https://github.com/bitnami/bitnami-docker-redis-cluster/pull/16#pullrequestreview-540706903).

## Securing Redis(TM) Cluster traffic

Starting with version 6, Redis(TM) adds the support for SSL/TLS connections. Should you desire to enable this optional feature, you may use the aforementioned `REDIS_TLS_*` environment variables to configure the application.

When enabling TLS, conventional standard traffic is disabled by default. However this new feature is not mutually exclusive, which means it is possible to listen to both TLS and non-TLS connection simultaneously. To enable non-TLS traffic, set `REDIS_TLS_PORT` to another port different than `0`.

1. Using `docker run`

    ```console
    $ docker run --name redis-cluster \
        -v /path/to/certs:/opt/bitnami/redis/certs \
        -v /path/to/redis-cluster-persistence:/bitnami \
        -e ALLOW_EMPTY_PASSWORD=yes \
        -e REDIS_TLS_ENABLED=yes \
        -e REDIS_TLS_CERT_FILE=/opt/bitnami/redis/certs/redis.crt \
        -e REDIS_TLS_KEY_FILE=/opt/bitnami/redis/certs/redis.key \
        -e REDIS_TLS_CA_FILE=/opt/bitnami/redis/certs/redisCA.crt \
        bitnami/redis-cluster:latest
    ```

2. Modifying the `docker-compose.yml` file present in this repository:

    ```yaml
      redis-cluster:
      ...
        environment:
          ...
          - REDIS_TLS_ENABLED=yes
          - REDIS_TLS_CERT_FILE=/opt/bitnami/redis/certs/redis.crt
          - REDIS_TLS_KEY_FILE=/opt/bitnami/redis/certs/redis.key
          - REDIS_TLS_CA_FILE=/opt/bitnami/redis/certs/redisCA.crt
        ...
        volumes:
          - /path/to/certs:/opt/bitnami/redis/certs
        ...
      ...
    ```
Alternatively, you may also provide with this configuration in your [custom](https://github.com/bitnami/bitnami-docker-redis-cluster#configuration-file) configuration file.

# Logging

The Bitnami Redis(TM) Cluster Docker image sends the container logs to `stdout`. To view the logs:

```console
$ docker logs redis-cluster
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of Redis(TM) Cluster, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```console
$ docker pull bitnami/redis-cluster:latest
```

### Step 2: Stop the running container

Stop the currently running container using the command

```console
$ docker stop redis-cluster
```

### Step 3: Remove the currently running container

```console
$ docker rm -v redis-cluster
```

### Step 4: Run the new image

Re-create your container from the new image.

```console
$ docker run --name redis-cluster bitnami/redis-cluster:latest
```

# Upgrading

## To 5.0.12-debian-10-r48 release, 6.2.1-debian-10-r48 release , 6.0.12-debian-10-r48

The cluster initialization logic has changed. Now the container in charge of initialize the cluster will also be part of the cluster. It will initialize Redis in background, create the cluster and then bring back to foreground the Redis process.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-redis-cluster/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-redis-cluster/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-redis-cluster/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright (c) 2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
