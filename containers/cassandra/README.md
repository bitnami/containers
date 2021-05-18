# What is Cassandra?

> [Apache Cassandra](http://cassandra.apache.org) is a free and open-source distributed database management system designed to handle large amounts of data across many commodity servers, providing high availability with no single point of failure. Cassandra offers robust support for clusters spanning multiple datacenters, with asynchronous masterless replication allowing low latency operations for all clients.

# TL;DR

```console
$ docker run --name cassandra bitnami/cassandra:latest
```

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-cassandra/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

You can find the default credentials and available configuration options in the [Environment Variables](#environment-variables) section.

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/cassandra?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# How to deploy Cassandra in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Cassandra Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/cassandra).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`3`, `3-debian-10`, `3.11.10`, `3.11.10-debian-10-r98`, `latest` (3/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-cassandra/blob/3.11.10-debian-10-r98/3/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/cassandra GitHub repo](https://github.com/bitnami/bitnami-docker-cassandra).

# Get this image

The recommended way to get the Bitnami Cassandra Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/cassandra).

```console
$ docker pull bitnami/cassandra:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/cassandra/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/cassandra:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/cassandra:latest 'https://github.com/bitnami/bitnami-docker-cassandra.git#master:3/debian-10'
```

# Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami` path. If the mounted directory is empty, it will be initialized on the first run.

```console
$ docker run \
    -v /path/to/cassandra-persistence:/bitnami \
    bitnami/cassandra:latest
```

or using Docker Compose:

```yaml
cassandra:
  image: bitnami/cassandra:latest
  volumes:
    - /path/to/cassandra-persistence:/bitnami
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a Cassandra server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

In this example, we will create a Cassandra client instance that will connect to the server instance that is running on the same docker network as the client.

### Step 1: Create a network

```console
$ docker network create app-tier --driver bridge
```

### Step 2: Launch the Cassandra server instance

Use the `--network app-tier` argument to the `docker run` command to attach the Cassandra container to the `app-tier` network.

```console
$ docker run -d --name cassandra-server \
    --network app-tier \
    bitnami/cassandra:latest
```

### Step 3: Launch your Cassandra client instance

Finally we create a new container instance to launch the Cassandra client and connect to the server created in the previous step:

```console
$ docker run -it --rm \
    --network app-tier \
    bitnami/cassandra:latest cqlsh --username cassandra --password cassandra cassandra-server
```

## Using Docker Compose

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `app-tier`. In this example we assume that you want to connect to the Cassandra server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge

services:
  cassandra:
    image: 'bitnami/cassandra:latest'
    networks:
      - app-tier
  myapp:
    image: 'YOUR_APPLICATION_IMAGE'
    networks:
      - app-tier
```

> **IMPORTANT**:
>
> 1. Please update the **YOUR_APPLICATION_IMAGE_** placeholder in the above snippet with your application image
> 2. In your application container, use the hostname `cassandra` to connect to the Cassandra server

Launch the containers using:

```console
$ docker-compose up -d
```

# Configuration

## Environment variables

 When you start the cassandra image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. If you want to add a new environment variable:

 * For docker-compose add the variable name and value under the application section:
```yaml
cassandra:
  image: bitnami/cassandra:latest
  environment:
    - CASSANDRA_TRANSPORT_PORT_NUMBER=7000
```

 * For manual execution add a `-e` option with each variable and value:

```console
 $ docker run --name cassandra -d -p 7000:7000 --network=cassandra_network \
    -e CASSANDRA_TRANSPORT_PORT_NUMBER=7000 \
    -v /your/local/path/bitnami/cassandra:/bitnami \
    bitnami/cassandra
```

**In case you do not mount custom configuration files**, the following variables are available for configuring cassandra:

 - `CASSANDRA_TRANSPORT_PORT_NUMBER`: Inter-node cluster communication port. Default: **7000**
 - `CASSANDRA_JMX_PORT_NUMBER`: JMX connections port. Default: **7199**
 - `CASSANDRA_CQL_PORT_NUMBER`: Client port. Default: **9042**.
 - `CASSANDRA_USER`: Cassandra user name. Defaults: **cassandra**
 - `CASSANDRA_PASSWORD_SEEDER`: Password seeder will change the Cassandra default credentials at initialization. In clusters, only one node should be marked as password seeder. Default: **no**
 - `CASSANDRA_PASSWORD`: Cassandra user password. Default: **cassandra**
 - `CASSANDRA_NUM_TOKENS`: Number of tokens for the node. Default: **256**.
 - `CASSANDRA_HOST`: Hostname used to configure Cassandra. It can be either an IP or a domain. If left empty, it will be resolved to the machine IP.
 - `CASSANDRA_CLUSTER_NAME`: Cluster name to configure Cassandra.. Defaults: **My Cluster**
 - `CASSANDRA_SEEDS`: Hosts that will act as Cassandra seeds. No defaults.
 - `CASSANDRA_ENDPOINT_SNITCH`: Snitch name (which determines which data centers and racks nodes belong to). Default **SimpleSnitch**
 - `CASSANDRA_ENABLE_RPC`: Enable the thrift RPC endpoint. Default :**true**
 - `CASSANDRA_DATACENTER`: Datacenter name for the cluster. Ignored in **SimpleSnitch** endpoint snitch. Default: **dc1**.
 - `CASSANDRA_RACK`: Rack name for the cluster. Ignored in **SimpleSnitch** endpoint snitch. Default: **rack1**.
 - `CASSANDRA_ENABLE_USER_DEFINED_FUNCTIONS`: User defined functions. Default: **false**.
 - `CASSANDRA_BROADCAST_ADDRESS`: The public IP address this node uses to broadcast to other nodes outside the network or across regions in multiple-region EC2 deployments. This option is commented out by default (if not provided, Cassandra will use "listen_address"). No defaults.
 - `CASSANDRA_COMMITLOG_DIR`: Directory where the commit logs will be stored. Default: **/bitnami/cassandra/data/commitlog**

Additionally, any environment variable beginning with the following prefix will be mapped to its corresponding Cassandra key in the proper file:

- `CASSANDRA_CFG_ENV_`: Will add the corresponding key and the provided value to `cassandra-env.sh`.
- `CASSANDRA_CFG_RACKDC_`: Will add the corresponding key and the provided value to `cassandra-rackdc.properties`.
- `CASSANDRA_CFG_COMMITLOG_`: Will add the corresponding key and the provided value to `commitlog_archiving.properties`.

For example, use `CASSANDRA_CFG_RACKDC_PREFER_LOCAL` in order to configure `prefer_local` in `cassandra-rackdc.properties`:

```console
$ docker run --name cassandra -e CASSANDRA_CFG_RACKDC_PREFER_LOCAL=true bitnami/cassandra:latest
```

or modifying the `docker-compose.yaml` with:

```
cassandra:
  ...
  environment:
    - CASSANDRA_CFG_RACKDC_PREFER_LOCAL=true
  ...
```

## Configuration file

The image looks for configurations in `/opt/bitnami/cassandra/conf/`. You can mount a volume at `/bitnami/cassandra/conf/` and copy/edit the configurations in the `/path/to/cassandra-persistence/conf/`. The default configurations will be populated to the `conf/` directory if it's empty.

For example, in order to override the `cassandra.yaml` configuration file:

### Step 1: Write your custom `cassandra.yaml` file
You can download the basic cassandra.yaml file like follows

```console
wget https://raw.githubusercontent.com/apache/cassandra/trunk/conf/cassandra.yaml
```

Perform any desired modifications in that file

### Step 2: Run the Cassandra image with the designed volume attached.

```console
$ docker run --name cassandra \
    -p 7000:7000  \
    -e CASSANDRA_TRANSPORT_PORT_NUMBER=7000 \
    -v /path/to/cassandra.yaml:/bitnami/cassandra/conf/cassandra.yaml:ro \
    -v /your/local/path/bitnami/cassandra:/bitnami \
    bitnami/cassandra:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  cassandra:
    image: bitnami/cassandra:latest
    environment:
      - CASSANDRA_TRANSPORT_PORT_NUMBER=7000
    volumes:
      - /path/to/cassandra.yaml:/bitnami/cassandra/conf/cassandra.yaml:ro
      - /your/local/path/bitnami/cassandra:/bitnami
```

After that, your changes will be taken into account in the server's behaviour. Note that you can override any other Cassandra configuration file, such as `rack-dc.properties`.

Refer to the [Cassandra configuration reference](https://docs.datastax.com/en/cassandra/3.0/cassandra/configuration/configCassandra_yaml.html) for the complete list of configuration options.


## Setting the server password on first run

Passing the `CASSANDRA_PASSWORD` environment variable along with `CASSANDRA_PASSWORD_SEEDER=yes` when running the image for the first time will set the Cassandra server password to the value of `CASSANDRA_PASSWORD`.

```console
$ docker run --name cassandra \
    -e CASSANDRA_PASSWORD_SEEDER=yes \
    -e CASSANDRA_PASSWORD=password123 \
    bitnami/cassandra:latest
```

or using Docker Compose:

```yaml
cassandra:
  image: bitnami/cassandra:latest
  environment:
    - CASSANDRA_PASSWORD_SEEDER=yes
    - CASSANDRA_PASSWORD=password123
```

## Setting up a cluster

A cluster can easily be setup with the Bitnami Cassandra Docker Image. **In case you do not mount custom configuration files**, you can use the following environment variables:

 - `CASSANDRA_HOST`: Hostname used to configure Cassandra. It can be either an IP or a domain. If left empty, it will be resolved to the machine IP.
 - `CASSANDRA_CLUSTER_NAME`: Cluster name to configure Cassandra. Defaults: **My Cluster**
 - `CASSANDRA_SEEDS`: Hosts that will act as Cassandra seeds. No defaults.
 - `CASSANDRA_ENDPOINT_SNITCH`: Snitch name (which determines which data centers and racks nodes belong to). Default **SimpleSnitch**
 - `CASSANDRA_PASSWORD_SEEDER`: Password seeder will change the Cassandra default credentials at initialization. Only one node should be marked as password seeder. Default: **no**
 - `CASSANDRA_PASSWORD`: Cassandra user password. Default: **cassandra**

Cassandra is a resource-intensive application. Depending on the target system, the initialization can take long. The container has internal timeouts when checking the initialization process. You can use the following environment variables to address that:

- `CASSANDRA_INIT_MAX_RETRIES`: Maximum retries for checking that Cassandra is initialized. Default: **100**.
- `CASSANDRA_INIT_SLEEP_TIME`: Sleep time (in seconds) between retries for checking that Cassandra is initialized. Default: **5**.
- `CASSANDRA_CQL_MAX_RETRIES`: Maximum retries for checking that the Cassandra client can access the database in localhost. Default: **20**.
- `CASSANDRA_CQL_SLEEP_TIME`: Sleep time (in seconds) between retries for checking that the Cassandra client can access the database in localhost. Default: **5**.
- `CASSANDRA_PEER_CQL_MAX_RETRIES`: Maximum retries for checking that the Cassandra client can access the database located in a peer host. This is used for ensuring that all of the peers are initialized before changing the database credentials. Default: **100**.
- `CASSANDRA_PEER_CQL_SLEEP_TIME`: Sleep time (in seconds) between retries for checking that the Cassandra client can access the database in a peer host. Default: **5**.

### Step 1: Create a new network.

```console
$ docker network create cassandra_network
```

### Step 2: Create a first node.

```console
$ docker run --name cassandra-node1 \
  --net=cassandra_network \
  -p 9042:9042 \
  -e CASSANDRA_CLUSTER_NAME=cassandra-cluster \
  -e CASSANDRA_SEEDS=cassandra-node1,cassandra-node2 \
  -e CASSANDRA_PASSWORD_SEEDER=yes \
  -e CASSANDRA_PASSWORD=mypassword \
  bitnami/cassandra:latest
```
In the above command the container is added to a cluster named `cassandra-cluster` using the `CASSANDRA_CLUSTER_NAME`. The `CASSANDRA_CLUSTER_HOSTS` parameter set the name of the nodes that set the cluster so we will need to launch other container for the second node. Finally the `CASSANDRA_NODE_NAME` parameter allows to indicate a known name for the node, otherwise cassandra will generate a randon one.

### Step 3: Create a second node

```console
$ docker run --name cassandra-node2 \
  --net=cassandra_network \
  -e CASSANDRA_CLUSTER_NAME=cassandra-cluster \
  -e CASSANDRA_SEEDS=cassandra-node1,cassandra-node2 \
  -e CASSANDRA_PASSWORD=mypassword \
  bitnami/cassandra:latest
```

In the above command a new cassandra node is being added to the cassandra cluster indicated by `CASSANDRA_CLUSTER_NAME`.

You now have a two node Cassandra cluster up and running which can be scaled by adding/removing nodes.

With Docker Compose the cluster configuration can be setup using:

```yaml
version: '2'
services:
  cassandra-node1:
    image: bitnami/cassandra:latest
    environment:
      - CASSANDRA_CLUSTER_NAME=cassandra-cluster
      - CASSANDRA_SEEDS=cassandra-node1,cassandra-node2
      - CASSANDRA_PASSWORD_SEEDER=yes
      - CASSANDRA_PASSWORD=password123

  cassandra-node2:
    image: bitnami/cassandra:latest
    environment:
      - CASSANDRA_CLUSTER_NAME=cassandra-cluster
      - CASSANDRA_SEEDS=cassandra-node1,cassandra-node2
      - CASSANDRA_PASSWORD=password123
```
## Initializing with custom scripts

When the container is executed for the first time, it will execute the files with extensions `.sh`, `.cql` or `.cql.gz` located at `/docker-entrypoint-initdb.d` in sort'ed order by filename. This behavior can be skipped by setting the environment variable `CASSANDRA_IGNORE_INITDB_SCRIPTS` to a value other than `yes` or `true`.

In order to have your custom files inside the docker image you can mount them as a volume.

```console
$ docker run --name cassandra \
  -v /path/to/init-scripts:/docker-entrypoint-initdb.d \
  -v /path/to/cassandra-persistence:/bitnami
  bitnami/cassandra:latest
```
Or with docker-compose

```yaml
cassandra:
  image: bitnami/cassandra:latest
  volumes:
    - /path/to/init-scripts:/docker-entrypoint-initdb.d
    - /path/to/cassandra-persistence:/bitnami
```

## Configuration file

The image looks for configurations in `/bitnami/cassandra/conf/`. As mentioned in [Persisting your application](#persisting-your-application) you can mount a volume at `/bitnami` and copy/edit the configurations in the `/path/to/cassandra-persistence/cassandra/conf/`. The default configurations will be populated to the `conf/` directory if it's empty.

### Step 1: Run the Cassandra image

Run the Cassandra image, mounting a directory from your host.

```console
$ docker run --name cassandra \
    -v /path/to/cassandra-persistence:/bitnami \
    bitnami/cassandra:latest
```

or using Docker Compose:

```yaml
cassandra:
  image: bitnami/cassandra:latest
  volumes:
    - /path/to/cassandra-persistence:/bitnami
```

### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```console
vi /path/to/cassandra-persistence/cassandra/conf/cassandra.yaml
```

### Step 3: Restart Cassandra

After changing the configuration, restart your Cassandra container for changes to take effect.

```console
$ docker restart cassandra
```

or using Docker Compose:

```console
$ docker-compose restart cassandra
```

Refer to the [configuration](http://docs.datastax.com/en/cassandra/3.x/cassandra/configuration/configTOC.html) manual for the complete list of configuration options.

# TLS Encryption
The Bitnami Cassandra Docker image allows configuring TLS encryption between nodes and between server-client. This is done by mounting in `/bitnami/cassandra/secrets` two files:

 - `keystore`: File with the server keystore
 - `truststore`: File with the server truststore

Apart from that, the following environment variables must be set:

 - `CASSANDRA_KEYSTORE_PASSWORD`: Password for accessing the keystore.
 - `CASSANDRA_TRUSTSTORE_PASSWORD`: Password for accessing the truststore.
 - `CASSANDRA_INTERNODE_ENCRYPTION`: Sets the type of encryption between nodes. The default value is `none`. Can be set to `all`, `none`, `dc` or `rack`.
 - `CASSANDRA_CLIENT_ENCRYPTION`: Enables client-server encryption. The default value is `false`.

# Logging

The Bitnami Cassandra Docker image sends the container logs to the `stdout`. To view the logs:

```console
$ docker logs cassandra
```

or using Docker Compose:

```console
$ docker-compose logs cassandra
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of Cassandra, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```console
$ docker pull bitnami/cassandra:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/cassandra:latest`.

### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
$ docker stop cassandra
```

or using Docker Compose:

```console
$ docker-compose stop cassandra
```

Next, take a snapshot of the persistent volume `/path/to/cassandra-persistence` using:

```console
$ rsync -a /path/to/cassandra-persistence /path/to/cassandra-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

### Step 3: Remove the currently running container

```console
$ docker rm -v cassandra
```

or using Docker Compose:

```console
$ docker-compose rm -v cassandra
```

### Step 4: Run the new image

Re-create your container from the new image.

```console
$ docker run --name cassandra bitnami/cassandra:latest
```

or using Docker Compose:

```console
$ docker-compose up cassandra
```

# Notable Changes

## 3.11.4-debian-9-r188 and 3.11.4-ol-7-r201

- Decrease the size of the container. The configuration logic is now based on Bash scripts in the `rootfs/` folder.

## 3.11.3-r129

-The Cassandra container now adds the possibility to inject custom initialization scripts by mounting cql and sh files in `/docker-entrypoint-initdb.d`. See [this section](#initializing-with-custom-scripts) for more information.

## 3.11.2-r22

- The Cassandra container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the Cassandra daemon was started as the `cassandra` user. From now on, both the container and the Cassandra daemon run as user `1001`. As a consequence, the data directory must be writable by that user. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-cassandra/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-cassandra/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-cassandra/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License
Copyright (c) 2016-2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
