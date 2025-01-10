# Bitnami package for Thanos

## What is Thanos?

> Thanos is a highly available metrics system that can be added on top of existing Prometheus deployments, providing a global query view across all Prometheus installations.

[Overview of Thanos](https://thanos.io/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name thanos bitnami/thanos:latest
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Thanos in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## How to deploy Thanos in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Thanos Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/thanos).

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

#### Step 1: Create a network

```console
docker network create thanos-network --driver bridge
```

#### Step 2: Create a volume for Prometheus data

```console
docker volume create --name prometheus_data
```

#### Step 3: Launch a Prometheus container within your network

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

* `--network <network>` argument to attach the container to the `thanos-network` network.
* `--volume [host-src:]container-dest[:<options>]` argument to mount the configuration file for Prometheus and a data volume to avoid loss of data. As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

```console
docker run -d --name "prometheus" \
  --network "thanos-network" \
  --volume "$(pwd)/prometheus.yml:/opt/bitnami/prometheus/conf/prometheus.yml:ro" \
  --volume "prometheus_data:/opt/bitnami/prometheus/data" \
  bitnami/prometheus
```

#### Step 4: Launch a Thanos sidecar container within your network

Use the `docker run` command to launch the Thanos sidecar container using the argument below and overwriting the default command:

* `--network <network>` argument to attach the container to the `thanos-network` network.
* `--volume [host-src:]container-dest[:<options>]` argument to mount the Prometheus data volume.

```console
docker run -d --name "thanos-sidecar" \
  --network "thanos-network" \
  --volume "prometheus_data:/data" \
  bitnami/thanos sidecar --tsdb.path=/data --prometheus.url=http://prometheus:9090 --grpc-address=0.0.0.0:10901
```

#### Step 5: Launch a Thanos Query container within your network

Use the `docker run` command to launch the Thanos Query container using the argument below and overwriting the default command:

* `--network <network>` argument to attach the container to the `thanos-network` network.
* `--expose [hostPort:containerPort]` argument to expose the port `9090`.

```console
docker run -d --name "thanos-query" \
  --network "thanos-network" \
  --expose "9090:9090" \
  bitnami/thanos query --grpc-address=0.0.0.0:10901 --http-address=0.0.0.0:9090 --store=thanos-sidecar:10901
```

Then you can access your Thanos Query UI at `http://localhost:9090/`

### Using Docker Compose

You can use the **docker-compose-cluster.yml** available on this repository to deploy an architecture like the one below:

```text
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
curl -sSL https://raw.githubusercontent.com/bitnami/containers/main/bitnami/minio/master/docker-compose-cluster.yml > docker-compose.yml
docker-compose up -d
```

## Configuration

Thanos can be configured via command-line flags and, depending on them, the same container image can be used to create components with differentes roles:

* Sidecar: connects to Prometheus, reads its data for query and/or uploads it to cloud storage.
* Store Gateway: serves metrics inside of a cloud storage bucket.
* Compactor: compacts, downsamples and applies retention on the data stored in cloud storage bucket.
* Receiver: receives data from Prometheus’ remote-write WAL, exposes it and/or upload it to cloud storage.
* Ruler/Rule: evaluates recording and alerting rules against data in Thanos for exposition and/or upload.
* Querier/Query: implements Prometheus' v1 API to aggregate data from the underlying components.

For further documentation, please check [Thanos documentation](https://github.com/thanos-io/thanos/tree/master/docs).

## Logging

The Bitnami Thanos Docker image sends the container logs to the `stdout`. To view the logs:

```console
docker logs thanos
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/thanos).

If you detect any issue in the `docker-compose.yaml` file, feel free to report it or contribute with a fix by following our [Contributing Guidelines](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md).

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

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
