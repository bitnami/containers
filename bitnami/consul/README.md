# Bitnami package for HashiCorp Consul

## What is HashiCorp Consul?

> HashiCorp Consul is a tool for discovering and configuring services in your infrastructure.

[Overview of HashiCorp Consul](https://consul.io)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name consul bitnami/consul:latest
```

You can find the available configuration options in the [Environment Variables](#environment-variables) section.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use HashiCorp Consul in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## How to deploy HashiCorp Consul in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami HashiCorp Consul Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/consul).

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

## Get this image

The recommended way to get the Bitnami HashiCorp Consul Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/consul).

```console
docker pull bitnami/consul:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/consul/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/consul:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. The above examples define a docker volume namely `consul_data`. The HashiCorp Consul application state will persist as long as this volume is not removed.

To avoid inadvertent removal of this volume you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

```console
docker run -v /path/to/consul-persistence:/bitnami bitnami/consul:latest
```

or using Docker Compose:

```yaml
consul:
  image: bitnami/consul:latest
  volumes:
    - /path/to/consul-persistence:/bitnami
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

#### Step 1: Create a network

```console
docker network create consul-network --driver bridge
```

#### Step 2: Launch the HashiCorp Consul container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `consul-network` network.

```console
docker run --name consul-node1 --network consul-network bitnami/consul:latest
```

#### Step 3: Run another containers

We can launch another containers using the same flag (`--network NETWORK`) in the `docker run` command. If you also set a name to your container, you will be able to use it as hostname in your network.

### Using a Docker Compose file

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new bridge network named consul-network.

```yaml
version: '2'

networks:
  consul-network:
    driver: bridge

services:
  consul:
    image: bitnami/consul:latest
    networks:
      - consul-network
    ports:
      - '8300:8300'
      - '8301:8301'
      - '8301:8301/udp'
      - '8500:8500'
      - '8600:8600'
      - '8600:8600/udp'
```

Then, launch the containers using:

```console
docker-compose up -d
```

## Setting up a cluster using Docker Compose

This is the simplest way to run HashiCorp Consul with clustering configuration:

### Step 1: Add a server node in your `docker-compose.yml`

Copy the snippet below into your docker-compose.yml to add a HashiCorp Consul server node to your cluster configuration.

```yaml
version: '2'

services:
  consul-node1:
    image: bitnami/consul
    environment:
      - CONSUL_BOOTSTRAP_EXPECT=3
      - CONSUL_CLIENT_LAN_ADDRESS=0.0.0.0
      - CONSUL_DISABLE_KEYRING_FILE=true
      - CONSUL_RETRY_JOIN_ADDRESS=consul-node1
    ports:
      - '8300:8300'
      - '8301:8301'
      - '8301:8301/udp'
      - '8500:8500'
      - '8600:8600'
      - '8600:8600/udp'
    volumes:
      - 'consul-node1_data:/bitnami'
```

> **Note:** The value of the **CONSUL_BOOTSTRAP_EXPECT** should reflect the total number of nodes the cluster will have.

### Step 2: Add extra nodes to your configuration

Update the definitions for nodes you want your HashiCorp Consul node cluster with. If it is a remote WAN node, use `CONSUL_RETRY_JOIN_WAN_ADDRESS`.

```yaml
consul-node2:
  image: bitnami/consul
  environment:
    - CONSUL_BOOTSTRAP_EXPECT=3
    - CONSUL_CLIENT_LAN_ADDRESS=0.0.0.0
    - CONSUL_DISABLE_KEYRING_FILE=true
    - CONSUL_RETRY_JOIN_ADDRESS=consul-node1
    - CONSUL_ENABLE_UI=false
  volumes:
    - 'consul-node2_data:/bitnami'

consul-node3:
  image: bitnami/consul
  environment:
    - CONSUL_BOOTSTRAP_EXPECT=3
    - CONSUL_CLIENT_LAN_ADDRESS=0.0.0.0
    - CONSUL_DISABLE_KEYRING_FILE=true
    - CONSUL_RETRY_JOIN_ADDRESS=consul-node1
    - CONSUL_ENABLE_UI=false
  volumes:
    - 'consul-node3_data:/bitnami'
```

### Step 3: Add the volume description

```yaml
volumes:
  consul-node1_data:
    driver: local
  consul-node2_data:
    driver: local
  consul-node3_data:
    driver: local
```

The final `docker-compose.yml` will look like this:

```yaml
version: '2'

services:
  consul-node1:
    image: bitnami/consul
    environment:
      - CONSUL_BOOTSTRAP_EXPECT=3
      - CONSUL_CLIENT_LAN_ADDRESS=0.0.0.0
      - CONSUL_DISABLE_KEYRING_FILE=true
      - CONSUL_RETRY_JOIN_ADDRESS=consul-node1
    ports:
      - '8300:8300'
      - '8301:8301'
      - '8301:8301/udp'
      - '8500:8500'
      - '8600:8600'
      - '8600:8600/udp'
    volumes:
      - 'consul-node1_data:/bitnami'

  consul-node2:
    image: bitnami/consul
    environment:
      - CONSUL_BOOTSTRAP_EXPECT=3
      - CONSUL_CLIENT_LAN_ADDRESS=0.0.0.0
      - CONSUL_DISABLE_KEYRING_FILE=true
      - CONSUL_RETRY_JOIN_ADDRESS=consul-node1
      - CONSUL_ENABLE_UI=false
    volumes:
      - 'consul-node2_data:/bitnami'

  consul-node3:
    image: bitnami/consul
    environment:
      - CONSUL_BOOTSTRAP_EXPECT=3
      - CONSUL_CLIENT_LAN_ADDRESS=0.0.0.0
      - CONSUL_DISABLE_KEYRING_FILE=true
      - CONSUL_RETRY_JOIN_ADDRESS=consul-node1
      - CONSUL_ENABLE_UI=false
    volumes:
      - 'consul-node3_data:/bitnami'

volumes:
  consul-node1_data:
    driver: local
  consul-node2_data:
    driver: local
  consul-node3_data:
    driver: local
```

## Configuration

### Environment variables

#### Customizable environment variables

| Name                            | Description                                         | Default Value |
|---------------------------------|-----------------------------------------------------|---------------|
| `CONSUL_RPC_PORT_NUMBER`        | Consul RPC port number.                             | `8300`        |
| `CONSUL_HTTP_PORT_NUMBER`       | Consul RPC port number.                             | `8500`        |
| `CONSUL_DNS_PORT_NUMBER`        | Consul DNS port number.                             | `8600`        |
| `CONSUL_DNS_PORT_NUMBER`        | Consul DNS port number.                             | `8600`        |
| `CONSUL_AGENT_MODE`             | Consul agent mode.                                  | `server`      |
| `CONSUL_DISABLE_KEYRING_FILE`   | Disable keyring file in Consul.                     | `false`       |
| `CONSUL_SERF_LAN_ADDRESS`       | LAN address for Serf daemon.                        | `0.0.0.0`     |
| `CONSUL_SERF_LAN_PORT_NUMBER`   | LAN port for Serf daemon.                           | `8301`        |
| `CONSUL_CLIENT_LAN_ADDRESS`     | LAN address for Consul clients.                     | `0.0.0.0`     |
| `CONSUL_RETRY_JOIN_ADDRESS`     | Consul node retry join address.                     | `127.0.0.1`   |
| `CONSUL_RETRY_JOIN_WAN_ADDRESS` | Consul retry join WAN address.                      | `127.0.0.1`   |
| `CONSUL_BIND_INTERFACE`         | Consul bind interface.                              | `nil`         |
| `CONSUL_BIND_ADDR`              | Consul bind address.                                | `nil`         |
| `CONSUL_ENABLE_UI`              | Enable User Interface in Consul.                    | `true`        |
| `CONSUL_BOOTSTRAP_EXPECT`       | Expect bootstrap in Consul.                         | `1`           |
| `CONSUL_RAFT_MULTIPLIER`        | Consul Raft multiplier.                             | `1`           |
| `CONSUL_LOCAL_CONFIG`           | Consul local configuration.                         | `nil`         |
| `CONSUL_GOSSIP_ENCRYPTION`      | Use gossip encryption in Consul.                    | `no`          |
| `CONSUL_GOSSIP_ENCRYPTION_KEY`  | Base64-encoded Consul gossip private symmetric key. | `nil`         |
| `CONSUL_DATACENTER`             | Consul datacenter name.                             | `dc1`         |
| `CONSUL_DOMAIN`                 | Consul domain.                                      | `consul`      |
| `CONSUL_NODE_NAME`              | Consul domain name.                                 | `nil`         |
| `CONSUL_DISABLE_HOST_NODE_ID`   | Disable host node ID.                               | `true`        |

#### Read-only environment variables

| Name                           | Description                                 | Value                                      |
|--------------------------------|---------------------------------------------|--------------------------------------------|
| `CONSUL_BASE_DIR`              | Consul installation directory.              | `${BITNAMI_ROOT_DIR}/consul`               |
| `CONSUL_CONF_DIR`              | Consul configuration directory.             | `${CONSUL_BASE_DIR}/conf`                  |
| `CONSUL_DEFAULT_CONF_DIR`      | Consul default configuration directory.     | `${CONSUL_BASE_DIR}/conf.default`          |
| `CONSUL_BIN_DIR`               | Consul binary directory.                    | `${CONSUL_BASE_DIR}/bin`                   |
| `CONSUL_CONF_FILE`             | Consul configuration file.                  | `${CONSUL_CONF_DIR}/consul.json`           |
| `CONSUL_ENCRYPT_FILE`          | Consul encrytion configuration file.        | `${CONSUL_CONF_DIR}/encrypt.json`          |
| `CONSUL_LOCAL_FILE`            | Consul local configuration file.            | `${CONSUL_CONF_DIR}/local.json`            |
| `CONSUL_LOG_DIR`               | Directory where Consul logs are stored.     | `${CONSUL_BASE_DIR}/logs`                  |
| `CONSUL_LOG_FILE`              | Consul log file.                            | `${CONSUL_LOG_DIR}/consul.log`             |
| `CONSUL_VOLUME_DIR`            | Consul persistence directory.               | `/bitnami/consul`                          |
| `CONSUL_DATA_DIR`              | Consul directory where data is stored.      | `${CONSUL_VOLUME_DIR}`                     |
| `CONSUL_SSL_DIR`               | Consul SSL directory.                       | `${CONSUL_BASE_DIR}/certificates`          |
| `CONSUL_TMP_DIR`               | Consul temporary directory.                 | `${CONSUL_BASE_DIR}/tmp`                   |
| `CONSUL_PID_FILE`              | Path to the PID file for Consul.            | `${CONSUL_TMP_DIR}/consul.pid`             |
| `CONSUL_TEMPLATES_DIR`         | Consul templates directory.                 | `${CONSUL_BASE_DIR}/templates`             |
| `CONSUL_CONFIG_TEMPLATE_FILE`  | Consul configuration template file.         | `${CONSUL_TEMPLATES_DIR}/consul.json.tpl`  |
| `CONSUL_ENCRYPT_TEMPLATE_FILE` | Consul encrypt configuration template file. | `${CONSUL_TEMPLATES_DIR}/encrypt.json.tpl` |
| `CONSUL_LOCAL_TEMPLATE_FILE`   | Consul local configuration template file.   | `${CONSUL_TEMPLATES_DIR}/local.json.tpl`   |
| `CONSUL_INITSCRIPTS_DIR`       | Consul directory for init scripts.          | `/docker-entrypoint-initdb.d`              |
| `CONSUL_DAEMON_USER`           | Consul system user.                         | `consul`                                   |
| `CONSUL_DAEMON_GROUP`          | Consul system group.                        | `consul`                                   |

#### Specifying Environment Variables using Docker Compose

```yaml
consul:
  image: bitnami/consul:latest
  environment:
    - CONSUL_HTTP_PORT_NUMBER=8888
```

#### Specifying Environment Variables on the Docker command line

```console
docker run -d -e CONSUL_HTTP_PORT_NUMBER=8888 --name consul bitnami/consul:latest
```

### Using custom HashiCorp Consul configuration files

In order to load your own configuration files, you will have to make them available to the container. You can do it doing the following:

* Mounting a volume with your custom configuration
* Adding custom configuration via environment variable.

By default, the configuration of HashiCorp Consul is written to `/opt/bitnami/consul/consul.json` file  and persisted with the following content:

```json
{
    "datacenter":"dc1",
    "domain":"consul",
    "data_dir":"/opt/bitnami/consul/data",
    "pid_file":"/opt/bitnami/consul/tmp/consul.pid",
    "server":true,
    "ui":true,
    "bootstrap_expect":1,
    "addresses": {
        "http":"0.0.0.0"
    },
    "retry_join": ["127.0.0.1"],
    "ports": {
        "http":8500,
        "dns":8600,
        "serf_lan":8301,
        "server":8300
    },
    "serf_lan":"0.0.0.0"
}
```

#### Configuring environment variables

Configuration can be added by passing the configuration in JSON format via the environment variable `CONSUL_LOCAL_CONFIG`. Then consul will write a `local.json` file in the HashiCorp Consul configuration directory. HashiCorp Consul will load all files within the configuration directory in alphabetical order, so ones with starting with higher letters will prevail.

```console
docker run -d -e CONSUL_LOCAL_CONFIG='{
    "datacenter":"us_west",
    "server":true,
    "enable_debug":true
}' \
     --name consul bitnami/consul:latest
```

#### Mounting a volume

Check the [Persisting your data](# Persisting your application) section to add custom volumes to the HashiCorp Consul container

### Configuring the Gossip encryption key

Specifies the secret key to use for encryption of HashiCorp Consul network traffic. This key must be 16-bytes that are Base64-encoded. The easiest way to create an encryption key is to use `consul keygen`

```console
docker run --name consul bitnami/consul:latest consul keygen
```

This command will generate a keygen, that you can add to your Dockerfile, docker-compose or pass it via command line:

```console
docker run -e CONSUL_GOSSIP_ENCRYPTION_KEY=YOUR_GENERATED_KEY --name consul bitnami/consul:latest
```

#### Deploying a Docker Compose file

```yaml
consul:
  image: bitnami/consul:latest
  volumes:
    - '/local/path/to/your/confDir:/opt/bitnami/consul/conf'
```

The container has a HashiCorp Consul configuration directory set up at /consul/config and the agent will load any configuration files placed here by binding a volume or by composing a new image and adding files. Alternatively, configuration can be added by passing the configuration JSON via environment variable CONSUL_LOCAL_CONFIG. If this is bind mounted then ownership will be changed to the consul user when the container starts.

## Logging

The Bitnami consul Docker image sends the container logs to the `stdout`. To view the logs:

```console
docker logs consul
```

or using Docker Compose:

```console
docker-compose logs consul
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of consul, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/consul:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/consul:latest`.

#### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
docker stop consul
```

or using Docker Compose:

```console
docker-compose stop consul
```

Next, take a snapshot of the persistent volume `/path/to/consul-persistence` using:

```console
rsync -a /path/to/consul-persistence /path/to/consul-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

You can use this snapshot to restore the database state should the upgrade fail.

#### Step 3: Remove the currently running container

```console
docker rm -v consul
```

or using Docker Compose:

```console
docker-compose rm -v consul
```

#### Step 4: Run the new image

Re-create your container from the new image, restoring your backup if necessary.

```console
docker run --name consul bitnami/consul:latest
```

or using Docker Compose:

```console
docker-compose up consul
```

## Notable Changes

### Debian 1.6.1-r6 and Oracle 1.6.1-r7

Decrease the size of the container. The configuration logic is now based on Bash scripts in the `rootfs/` folder.
Also, some env var changes have been performed maintaining backward compatibility through aliases:

| New value                   | Old value            |
|-----------------------------|----------------------|
| `CONSUL_ENABLE_UI`          | `CONSUL_UI`          |
| `CONSUL_AGENT_MODE`         | `CONSUL_SERVER_MODE` |
| `CONSUL_RETRY_JOIN_ADDRESS` | `CONSUL_RETRY_JOIN`  |

### 1.4.0-r16

* The Consul container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the Consul daemon was started as the `consul` user. From now on, both the container and the Consul daemon run as user `1001`. As a consequence, the data directory must be writable by that user. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/consul).

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
