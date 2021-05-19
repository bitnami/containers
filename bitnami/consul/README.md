# What is HashiCorp Consul?

HashiCorp Consul has multiple components, bus as a whole, it is a tool for discovering and configuring services in your infrastructure. It provides several key features:

- Service Discovery
- Health Checking
- KV Store
- Multi Datacenter

HashiCorp Consul is designed to be friendly to both the DevOps community and application developers, making it perfect for modern, elastic infrastructures.

[https://www.consul.io/](https://www.consul.io/)

# TL;DR

```console
$ docker run --name consul bitnami/consul:latest
```

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-consul/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

You can find the available configuration options in the [Environment Variables](#environment-variables) section.

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/consul?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy HashiCorp Consul in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami HashiCorp Consul Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/consul).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`1`, `1-debian-10`, `1.9.5`, `1.9.5-debian-10-r30`, `latest` (1/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-consul/blob/1.9.5-debian-10-r30/1/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/consul GitHub repo](https://github.com/bitnami/bitnami-docker-consul).

# Get this image

The recommended way to get the Bitnami HashiCorp Consul Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/consul).

```console
$ docker pull bitnami/consul:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/consul/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/consul:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/consul:latest 'https://github.com/bitnami/bitnami-docker-consul.git#master:1/debian-10'
```

# Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. The above examples define a docker volume namely `consul_data`. The HashiCorp Consul application state will persist as long as this volume is not removed.

To avoid inadvertent removal of this volume you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

```console
$ docker run -v /path/to/consul-persistence:/bitnami bitnami/consul:latest
```

or using Docker Compose:

```yaml
consul:
  image: bitnami/consul:latest
  volumes:
    - /path/to/consul-persistence:/bitnami
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

### Step 1: Create a network

```console
$ docker network create consul-network --driver bridge
```

### Step 2: Launch the HashiCorp Consul container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `consul-network` network.

```console
$ docker run --name consul-node1 --network consul-network bitnami/consul:latest
```

### Step 3: Run another containers

We can launch another containers using the same flag (`--network NETWORK`) in the `docker run` command. If you also set a name to your container, you will be able to use it as hostname in your network.

## Using Docker Compose

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
$ docker-compose up -d
```

# Setting up a cluster

## Docker Compose

This is the simplest way to run HashiCorp Consul with clustering configuration:

#### Step 1: Add a server node in your `docker-compose.yml`

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

#### Step 2: Add extra nodes to your configuration

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

#### Step 3: Add the volume description

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

# Configuration

## Environment variables

When you start the HashiCorp Consul image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. The following environment values are provided to custom HashiCorp Consul:

- `CONSUL_AGENT_MODE`: Indicates if HashiCorp Consul is running in server or client mode. Valid values: server, client. Default: **server**.
- `CONSUL_SERF_LAN_ADDRESS`: Address used for Serf LAN communications. Default: **0.0.0.0**.
- `CONSUL_CLIENT_LAN_ADDRESS`: Address in which HashiCorp Consul will bind client interfaces. Default: **0.0.0.0**.
- `CONSUL_SERF_LAN_PORT_NUMBER`: Serf LAN port. Defualt: **8301**.
- `CONSUL_HTTP_PORT_NUMBER`: HTTP API port, used also for the UI. Default: **8500**.
- `CONSUL_DNS_PORT_NUMBER`: DNS service port. Default: **8600**.
- `CONSUL_RPC_PORT_NUMBER`: Server RPC port. Default: **8300**.
- `CONSUL_RAFT_MULTIPLIER`: An integer multiplier used by HashiCorp Consul servers to scale key Raft timing parameters. Default: **1**.
- `CONSUL_LOCAL_CONFIG`: Custom user configuration that will be added as a file in the config dir.
- `CONSUL_GOSSIP_ENCRYPTION`: Enable Gossip encryption. Default: **no**.
- `CONSUL_GOSSIP_ENCRYPTION_KEY`: Gossip private simmetric key.
- `CONSUL_GOSSIP_ENCRYPTION_KEY_FILE`: File containing the gossip private simmetric key. If both `CONSUL_GOSSIP_ENCRYPTION_KEY` and `CONSUL_GOSSIP_ENCRYPTION_KEY_FILE` are provided, consul will use the `CONSUL_GOSSIP_ENCRYPTION_KEY_FILE`.
- `CONSUL_DISABLE_KEYRING_FILE`: If set, the keyring will not be persisted to a file. Valid vaules: true, false. Default: **false**.
- `CONSUL_ENABLE_UI`: Enable web user interface. Valid values: true, false. Default: **true**.
- `CONSUL_BOOTSTRAP_EXPECT`: Number of expected nodes in the cluster, including itself. Default: **1**.
- `CONSUL_DOMAIN`: HashiCorp Consul domain name. Default: **consul**.
- `CONSUL_DATACENTER"`: The datacenter in which the agent is running. Default: **dc1**.
- `CONSUL_RETRY_JOIN_ADDRESS`: "Address of another agent to join upon starting up. Default: **127.0.0.1**
- `CONSUL_RETRY_JOIN_WAN_ADDRESS`: "Address of another WAN agent to join upon starting up. Default: **127.0.0.1**
- `CONSUL_BIND_INTERFACE`: The interface that will be bound to for internal cluster communications.
- `CONSUL_DISABLE_HOST_NODE_ID`: Flag to prevent Consul from using information from the host to generate a deterministic node ID. Default: **true**.

### Specifying Environment Variables using Docker Compose

```yaml
consul:
  image: bitnami/consul:latest
  environment:
    - CONSUL_HTTP_PORT_NUMBER=8888
```

### Specifying Environment Variables on the Docker command line

```console
$ docker run -d -e CONSUL_HTTP_PORT_NUMBER=8888 --name consul bitnami/consul:latest
```

## Using custom HashiCorp Consul configuration files

In order to load your own configuration files, you will have to make them available to the container. You can do it doing the following:

- Mounting a volume with your custom configuration
- Adding custom configuration via environment variable.

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

### Configuring environment variables

Configuration can be added by passing the configuration in JSON format via the environment variable `CONSUL_LOCAL_CONFIG`. Then consul will write a `local.json` file in the HashiCorp Consul configuration directory. HashiCorp Consul will load all files within the configuration directory in alphabetical order, so ones with starting with higher letters will prevail.

```console
$ docker run -d -e CONSUL_LOCAL_CONFIG='{
    "datacenter":"us_west",
    "server":true,
    "enable_debug":true
}' \
     --name consul bitnami/consul:latest
```

### Mounting a volume

Check the [Persisting your data](# Persisting your application) section to add custom volumes to the HashiCorp Consul container

## Configuring the Gossip encryption key
Specifies the secret key to use for encryption of HashiCorp Consul network traffic. This key must be 16-bytes that are Base64-encoded. The easiest way to create an encryption key is to use `consul keygen`

```console
$ docker run --name consul bitnami/consul:latest consul keygen
```

This command will generate a keygen, that you can add to your Dockerfile, docker-compose or pass it via command line:

```console
$ docker run -e CONSUL_GOSSIP_ENCRYPTION_KEY=YOUR_GENERATED_KEY --name consul bitnami/consul:latest
```

### Using Docker Compose

```yaml
consul:
  image: bitnami/consul:latest
  volumes:
    - '/local/path/to/your/confDir:/opt/bitnami/consul/conf'
```


The container has a HashiCorp Consul configuration directory set up at /consul/config and the agent will load any configuration files placed here by binding a volume or by composing a new image and adding files. Alternatively, configuration can be added by passing the configuration JSON via environment variable CONSUL_LOCAL_CONFIG. If this is bind mounted then ownership will be changed to the consul user when the container starts.

# Logging

The Bitnami consul Docker image sends the container logs to the `stdout`. To view the logs:

```console
$ docker logs consul
```

or using Docker Compose:

```console
$ docker-compose logs consul
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of consul, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```console
$ docker pull bitnami/consul:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/consul:latest`.

### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
$ docker stop consul
```

or using Docker Compose:

```console
$ docker-compose stop consul
```

Next, take a snapshot of the persistent volume `/path/to/consul-persistence` using:

```console
$ rsync -a /path/to/consul-persistence /path/to/consul-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

You can use this snapshot to restore the database state should the upgrade fail.

### Step 3: Remove the currently running container

```console
$ docker rm -v consul
```

or using Docker Compose:

```console
$ docker-compose rm -v consul
```

### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if necessary.

```console
$ docker run --name consul bitnami/consul:latest
```

or using Docker Compose:

```console
$ docker-compose up consul
```

# Notable Changes

## Debian 1.6.1-r6 and Oracle 1.6.1-r7

Decrease the size of the container. The configuration logic is now based on Bash scripts in the `rootfs/` folder.
Also, some env var changes have been performed maintaining backward compatibility through aliases:

| New value                   | Old value            |
|-----------------------------|----------------------|
| `CONSUL_ENABLE_UI`          | `CONSUL_UI`          |
| `CONSUL_AGENT_MODE`         | `CONSUL_SERVER_MODE` |
| `CONSUL_RETRY_JOIN_ADDRESS` | `CONSUL_RETRY_JOIN`  |


## 1.4.0-r16

- The Consul container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the Consul daemon was started as the `consul` user. From now on, both the container and the Consul daemon run as user `1001`. As a consequence, the data directory must be writable by that user. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-consul/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-consul/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-consul/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License
Copyright 2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
