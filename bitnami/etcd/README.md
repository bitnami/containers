# Bitnami package for Etcd

## What is Etcd?

> etcd is a distributed key-value store designed to securely store data across a cluster. etcd is widely used in production on account of its reliability, fault-tolerance and ease of use.

[Overview of Etcd](https://etcd.io/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run -it --name etcd bitnami/etcd:latest
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Etcd in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## How to deploy Etcd in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Etcd Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/etcd).

Bitnami containers can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

> Please note ARM support in branch 3.4 is experimental/unstable according to [upstream docs](https://github.com/etcd-io/website/blob/main/content/en/docs/v3.4/op-guide/supported-platform.md), therefore branch 3.4 is only supported for AMD archs while branch 3.5 supports multiarch (AMD and ARM)

## Prerequisites

To run this application you need [Docker Engine](https://www.docker.com/products/docker-engine) >= `1.10.0`. [Docker Compose](https://docs.docker.com/compose/) is recommended with a version `1.6.0` or later.

## Get this image

The recommended way to get the Bitnami Etcd Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/etcd).

```console
docker pull bitnami/etcd:latest
```

To use a specific version, you can pull a versioned tag. You can view the
[list of available versions](https://hub.docker.com/r/bitnami/etcd/tags/)
in the Docker Hub Registry.

```console
docker pull bitnami/etcd:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a Etcd server running inside a container can easily be accessed by your application containers using a Etcd client.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

In this example, we will create a Etcd client instance that will connect to the server instance that is running on the same docker network as the client.

#### Step 1: Create a network

```console
docker network create app-tier --driver bridge
```

#### Step 2: Launch the Etcd server instance

Use the `--network app-tier` argument to the `docker run` command to attach the Etcd container to the `app-tier` network.

```console
docker run -d --name Etcd-server \
    --network app-tier \
    --publish 2379:2379 \
    --publish 2380:2380 \
    --env ALLOW_NONE_AUTHENTICATION=yes \
    --env ETCD_ADVERTISE_CLIENT_URLS=http://etcd-server:2379 \
    bitnami/etcd:latest
```

#### Step 3: Launch your Etcd client instance

Finally we create a new container instance to launch the Etcd client and connect to the server created in the previous step:

```console
docker run -it --rm \
    --network app-tier \
    --env ALLOW_NONE_AUTHENTICATION=yes \
    bitnami/etcd:latest etcdctl --endpoints http://etcd-server:2379 put /message Hello
```

### Using a Docker Compose file

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `app-tier`. In this example we assume that you want to connect to the Etcd server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge

services:
  Etcd:
    image: 'bitnami/etcd:latest'
    environment:
      - ALLOW_NONE_AUTHENTICATION=yes
      - ETCD_ADVERTISE_CLIENT_URLS=http://etcd:2379
    ports:
      - 2379:2379
      - 2380:2380
    networks:
      - app-tier
  myapp:
    image: 'YOUR_APPLICATION_IMAGE'
    networks:
      - app-tier
```

> **IMPORTANT**:
>
> 1. Please update the placeholder `YOUR_APPLICATION_IMAGE` in the above snippet with your application image
> 2. In your application container, use the hostname `etcd` to connect to the Etcd server

Launch the containers using:

```console
docker-compose up -d
```

## Configuration

The configuration can easily be setup by mounting your own configuration file on the directory `/opt/bitnami/etcd/conf`:

```console
docker run --name Etcd -v /path/to/Etcd.conf.yml:/opt/bitnami/Etcd/conf/etcd.conf.yml bitnami/etcd:latest
```

After that, your configuration will be taken into account in the server's behaviour.

You can also do this by changing the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/etcd/docker-compose.yml) file present in this repository:

```yaml
Etcd:
  ...
  volumes:
    - /path/to/Etcd.conf.yml:/opt/bitnami/etcd/conf/etcd.conf.yml
  ...
```

You can find a sample configuration file on this [link](https://github.com/coreos/etcd/blob/master/etcd.conf.yml.sample)

### Environment variables

Apart from providing your custom configuration file, you can also modify the server behavior via configuration as environment variables.

#### Customizable environment variables

| Name                               | Description                                                                                  | Default Value           |
|------------------------------------|----------------------------------------------------------------------------------------------|-------------------------|
| `ETCD_SNAPSHOTS_DIR`               | etcd snaphots directory (used on "disaster recovery" feature).                               | `/snapshots`            |
| `ETCD_SNAPSHOT_HISTORY_LIMIT`      | etcd snaphots history limit.                                                                 | `1`                     |
| `ETCD_INIT_SNAPSHOTS_DIR`          | etcd init snaphots directory (used on "init from snapshot" feature).                         | `/init-snapshot`        |
| `ALLOW_NONE_AUTHENTICATION`        | Allow accessing etcd without any password.                                                   | `no`                    |
| `ETCD_ROOT_PASSWORD`               | Password for the etcd root user.                                                             | `nil`                   |
| `ETCD_CLUSTER_DOMAIN`              | Domain to use to discover other etcd members.                                                | `nil`                   |
| `ETCD_START_FROM_SNAPSHOT`         | Whether etcd should start from an existing snapshot or not.                                  | `no`                    |
| `ETCD_DISASTER_RECOVERY`           | Whether etcd should try or not to recover from snapshots when the cluste disastrously fails. | `no`                    |
| `ETCD_ON_K8S`                      | Whether etcd is running on a K8s environment or not.                                         | `no`                    |
| `ETCD_INIT_SNAPSHOT_FILENAME`      | Existing snapshot filename to start the etcd cluster from.                                   | `nil`                   |
| `ETCDCTL_API`                      | etcdctl API version.                                                                         | `3`                     |
| `ETCD_NAME`                        | etcd member name.                                                                            | `nil`                   |
| `ETCD_LOG_LEVEL`                   | etcd log level.                                                                              | `info`                  |
| `ETCD_LISTEN_CLIENT_URLS`          | List of URLs to listen on for client traffic.                                                | `http://0.0.0.0:2379`   |
| `ETCD_ADVERTISE_CLIENT_URLS`       | List of this member client URLs to advertise to the rest of the cluster.                     | `http://127.0.0.1:2379` |
| `ETCD_INITIAL_CLUSTER`             | Initial list of members to bootstrap a cluster.                                              | `nil`                   |
| `ETCD_LISTEN_PEER_URLS`            | List of URLs to listen on for peers traffic.                                                 | `nil`                   |
| `ETCD_INITIAL_ADVERTISE_PEER_URLS` | List of this member peer URLs to advertise to the rest of the cluster while bootstrapping.   | `nil`                   |
| `ETCD_INITIAL_CLUSTER_TOKEN`       | Unique initial cluster token used for bootstrapping.                                         | `nil`                   |
| `ETCD_AUTO_TLS`                    | Use generated certificates for TLS communications with clients.                              | `false`                 |
| `ETCD_CERT_FILE`                   | Path to the client server TLS cert file.                                                     | `nil`                   |
| `ETCD_KEY_FILE`                    | Path to the client server TLS key file.                                                      | `nil`                   |
| `ETCD_TRUSTED_CA_FILE`             | Path to the client server TLS trusted CA cert file.                                          | `nil`                   |
| `ETCD_CLIENT_CERT_AUTH`            | Enable client cert authentication                                                            | `false`                 |
| `ETCD_PEER_AUTO_TLS`               | Use generated certificates for TLS communications with peers.                                | `false`                 |
| `ETCD_EXTRA_AUTH_FLAGS`            | Comma separated list of authentication flags to append to etcdctl                            | `nil`                   |

#### Read-only environment variables

| Name                        | Description                                                          | Value                              |
|-----------------------------|----------------------------------------------------------------------|------------------------------------|
| `ETCD_BASE_DIR`             | etcd installation directory.                                         | `/opt/bitnami/etcd`                |
| `ETCD_VOLUME_DIR`           | Persistence base directory.                                          | `/bitnami/etcd`                    |
| `ETCD_BIN_DIR`              | etcd executables directory.                                          | `${ETCD_BASE_DIR}/bin`             |
| `ETCD_DATA_DIR`             | etcd data directory.                                                 | `${ETCD_VOLUME_DIR}/data`          |
| `ETCD_CONF_DIR`             | etcd configuration directory.                                        | `${ETCD_BASE_DIR}/conf`            |
| `ETCD_DEFAULT_CONF_DIR`     | etcd default configuration directory.                                | `${ETCD_BASE_DIR}/conf.default`    |
| `ETCD_TMP_DIR`              | Directory where ETCD temporary files are stored.                     | `${ETCD_BASE_DIR}/tmp`             |
| `ETCD_CONF_FILE`            | ETCD configuration file.                                             | `${ETCD_CONF_DIR}/etcd.yaml`       |
| `ETCD_NEW_MEMBERS_ENV_FILE` | File containining the etcd environment to use after adding a member. | `${ETCD_DATA_DIR}/new_member_envs` |
| `ETCD_DAEMON_USER`          | etcd system user name.                                               | `etcd`                             |
| `ETCD_DAEMON_GROUP`         | etcd system user group.                                              | `etcd`                             |

Additionally, you can configure etcd using the upstream env variables [here](https://etcd.io/docs/v3.4/op-guide/configuration/)

## Notable Changes

### 3.5.17-debian-12-r4

* Drop support for non-Helm cluster deployment. Upgrading of any kind including increasing replica count must also be done with `helm upgrade` exclusively. CD automation tools that respect Helm hooks such as ArgoCD can also be used.
* Remove `prestop.sh` script. Hence, container should no longer define lifecycle prestop hook.
* Add `preupgrade.sh` script which should be run as a pre-upgrade Helm hook. This replaces the prestop hook as a more reliable mechanism to remove stale members when replica count is decreased.
* Stop storing member ID in a local file which is unreliable. The container now check the member ID from the data dir instead.
* Stop storing/checking for member removal from a local file. The container now check with other members in the cluster instead.

### 3.4.15-debian-10-r7

* The container now contains the needed logic to deploy the Etcd container on Kubernetes using the [Bitnami Etcd Chart](https://github.com/bitnami/charts/tree/master/bitnami/etcd).

### 3.4.13-debian-10-r7

* Arbitrary user ID(s) are supported again, see <https://github.com/etcd-io/etcd/issues/12158> for more information abut the changes in the upstream source code

### 3.4.10-debian-10-r0

* Arbitrary user ID(s) when running the container with a non-privileged user are not supported (only `1001` UID is allowed).

## Further documentation

For further documentation, please check [Etcd documentation](https://coreos.com/etcd/docs/latest/) or its [GitHub repository](https://github.com/coreos/etcd)

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/etcd).

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
