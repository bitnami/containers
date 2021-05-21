# What is Thanos?

> Thanos is a highly available metrics system that can be added on top of existing Prometheus deployments, providing a global query view across all Prometheus installations.

[https://thanos.io/](https://thanos.io/)

# TL;DR

```console
$ docker run --name thanos bitnami/thanos:latest
```

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-thanos/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.

> This [CVE scan report](https://quay.io/repository/bitnami/thanos?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy Thanos in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Thanos Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/thanos).

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`0`, `0-scratch`, `0.20.2`, `0.20.2-scratch-r0`, `latest` (0/scratch/Dockerfile)](https://github.com/bitnami/bitnami-docker-thanos/blob/0.20.2-scratch-r0/0/scratch/Dockerfile)

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

### Step 1: Create a network

```console
$ docker network create thanos-network --driver bridge
```

### Step 2: Create a volume for Prometheus data

```console
$ docker volume create --name prometheus_data
```

### Step 3: Launch a Prometheus container within your network

Create a configuration file **prometheus.yml** for Prometheus as the one below:

```yaml
global:
  scrape_interval: 5s
  # mandatory
  # used by Thanos Query to filter out store APIs to touch during query requests
  external_labels:
    foo: bar
scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets:
          - localhost:9090
```

Use the `docker run` command to launch the Prometheus containers using the arguments below:

- `--network <network>` argument to attach the container to the `thanos-network` network.
- `--volume [host-src:]container-dest[:<options>]` argument to mount the configuration file for Prometheus and a data volume to avoid loss of data. As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

```console
$ docker run -d --name "prometheus" \
  --network "thanos-network" \
  --volume "$(pwd)/prometheus.yml:/opt/bitnami/prometheus/conf/prometheus.yml:ro" \
  --volume "prometheus_data:/opt/bitnami/prometheus/data" \
  bitnami/prometheus
```

### Step 4: Launch a Thanos sidecar container within your network

Use the `docker run` command to launch the Thanos sidecar container using the argument below and overwriting the default command:

- `--network <network>` argument to attach the container to the `thanos-network` network.
- `--volume [host-src:]container-dest[:<options>]` argument to mount the Prometheus data volume.

```console
$ docker run -d --name "thanos-sidecar" \
  --network "thanos-network" \
  --volume "prometheus_data:/data" \
  bitnami/thanos sidecar --tsdb.path=/data --prometheus.url=http://prometheus:9090 --grpc-address=0.0.0.0:10901
```

### Step 5: Launch a Thanos Query container within your network

Use the `docker run` command to launch the Thanos Query container using the argument below and overwriting the default command:

- `--network <network>` argument to attach the container to the `thanos-network` network.
- `--expose [hostPort:containerPort]` argument to expose the port `9090`.

```console
$ docker run -d --name "thanos-query" \
  --network "thanos-network" \
  --expose "9090:9090" \
  bitnami/thanos query --grpc-address=0.0.0.0:10901 --http-address=0.0.0.0:9090 --store=thanos-sidecar:10901
```

Then you can access your Thanos Query UI at http://localhost:9090/

## Using Docker Compose

You can use the **docker-compose-cluster.yml** available on this repository to deploy an architecture like the one below:

```
 ┌──────────────┐                  ┌──────────────┐             ┌──────────────┐       ┌──────────────┐
 │     Node     │                  │    Thanos    │───────────▶ │ Thanos Store │       │    Thanos    │
 │   Exporter   │                  │     Query    │──┐          │    Gateway   │       │   Compactor  │
 └──────────────┘                  └──────────────┘  │          └──────────────┘       └──────────────┘
        ▲                                            │                 │                      │
        │ gather hardware                            │ query           │ storages             │ Compact & downsample
        │ & OS metrics                               │ metrics         │ query metrics        │ blocks
        │                                            │                 │                      │
┌ ── ── ── ── ── ── ── ── ── ── ── ──┐               |                 |                      |
│┌──────────────┐    ┌──────────────┐│               │                 ▼                      │
││  Prometheus  │ ─▶ │    Thanos    ││ ◀─────────────┘          ┌──────────────┐              │
││              │ ◀─ │    Sidecar   ││                          │    MinIO     │◀─────────────┘
│└──────────────┘    └──────────────┘│                          │              │
└ ── ── ── ── ── ── ── ── ── ── ── ──┘                          └──────────────┘
```

Under the [configuration section](#configuration) you can find more information about each component's role.
The unique "mandatory" components are Prometheus, Thanos Sidecar and Thanos Query. The rest of components are optional.

To do so, run the commands below:

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-minio/master/docker-compose-cluster.yml > docker-compose.yml
$ docker-compose up -d
```

# Configuration

Thanos can be configured via command-line flags and, depending on them, the same container image can be used to create components with differentes roles:

- Sidecar: connects to Prometheus, reads its data for query and/or uploads it to cloud storage.
- Store Gateway: serves metrics inside of a cloud storage bucket.
- Compactor: compacts, downsamples and applies retention on the data stored in cloud storage bucket.
- Receiver: receives data from Prometheus’ remote-write WAL, exposes it and/or upload it to cloud storage.
- Ruler/Rule: evaluates recording and alerting rules against data in Thanos for exposition and/or upload.
- Querier/Query: implements Prometheus' v1 API to aggregate data from the underlying components.

For further documentation, please check [Thanos documentation](https://github.com/thanos-io/thanos/tree/master/docs).

# Logging

The Bitnami Thanos Docker image sends the container logs to the `stdout`. To view the logs:

```console
$ docker logs thanos
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-thanos/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-thanos/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-thanos/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
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
