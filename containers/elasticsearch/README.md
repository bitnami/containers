# What is Elasticsearch?

> Elasticsearch is a highly scalable open-source full-text search and analytics engine. It allows you to store, search, and analyze big volumes of data quickly and in near real time

[elastic.co/products/elasticsearch](https://www.elastic.co/products/elasticsearch)

## TL;DR

```console
$ docker run --name elasticsearch bitnami/elasticsearch:latest
```

### Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-elasticsearch/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

You can find the available configuration options in the [Environment Variables](#environment-variables) section.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/elasticsearch?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

## How to deploy Elasticsearch in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Elasticsearch Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/elasticsearch).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`7`, `7-debian-10`, `7.12.1`, `7.12.1-debian-10-r23`, `latest` (7/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-elasticsearch/blob/7.12.1-debian-10-r23/7/debian-10/Dockerfile)
* [`7.10.2`, `7.10.2-debian-10`, `7.10.2-debian-10-r113` (7.10.2/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-elasticsearch/blob/7.10.2-debian-10-r113/7.10.2/debian-10/Dockerfile)
* [`6`, `6-debian-10`, `6.8.15`, `6.8.15-debian-10-r49` (6/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-elasticsearch/blob/6.8.15-debian-10-r49/6/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/elasticsearch GitHub repo](https://github.com/bitnami/bitnami-docker-elasticsearch).
## Get this image

The recommended way to get the Bitnami Elasticsearch Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/elasticsearch).

```console
$ docker pull bitnami/elasticsearch:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/elasticsearch/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/elasticsearch:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/elasticsearch:latest 'https://github.com/bitnami/bitnami-docker-elasticsearch.git#master:7/debian-10'
```

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the application will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami` path. If the mounted directory is empty, it will be initialized on the first run.

```console
$ docker run \
    -v /path/to/elasticsearch-data-persistence:/bitnami/elasticsearch/data \
    bitnami/elasticsearch:latest
```

or by making a minor change to the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-elasticsearch/blob/master/docker-compose.yml) file present in this repository:

```yaml
elasticsearch:
  ...
  volumes:
    - /path/to/elasticsearch-data-persistence:/bitnami/elasticsearch/data
  ...
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

It is also possible to use multiple volumes for data persistence by using the `ELASTICSEARCH_DATA_DIR_LIST` environment variable:

```yaml
elasticsearch:
  ...
  volumes:
    - /path/to/elasticsearch-data-persistence-1:/elasticsearch/data-1
    - /path/to/elasticsearch-data-persistence-2:/elasticsearch/data-2
  environment:
    - ELASTICSEARCH_DATA_DIR_LIST=/elasticsearch/data-1,/elasticsearch/data-2
  ...
```

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a Elasticsearch server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

#### Step 1: Create a network

```console
$ docker network create app-tier --driver bridge
```

#### Step 2: Launch the Elasticsearch server instance

Use the `--network app-tier` argument to the `docker run` command to attach the Elasticsearch container to the `app-tier` network.

```console
$ docker run -d --name elasticsearch-server \
    --network app-tier \
    bitnami/elasticsearch:latest
```

#### Step 3: Launch your application container

```console
$ docker run -d --name myapp \
    --network app-tier \
    YOUR_APPLICATION_IMAGE
```

> **IMPORTANT**:
>
> 1. Please update the **YOUR_APPLICATION_IMAGE_** placeholder in the above snippet with your application image
> 2. In your application container, use the hostname `elasticsearch-server` to connect to the Elasticsearch server

### Using Docker Compose

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `app-tier`. In this example we assume that you want to connect to the Elasticsearch server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge

services:
  elasticsearch:
    image: 'bitnami/elasticsearch:latest'
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
> 2. In your application container, use the hostname `elasticsearch` to connect to the Elasticsearch server

Launch the containers using:

```console
$ docker-compose up -d
```

## Configuration

### Environment variables

When you start the elasticsearch image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. If you want to add a new environment variable:

* For Docker Compose, add the variable name and value under the application section:

```yaml
elasticsearch:
  ...
  environment:
    - ELASTICSEARCH_PORT_NUMBER=9201
  ...
```

* For manual execution add a `-e` option with each variable and value:

```console
 $ docker run -d --name elasticsearch \
    -p 9201:9201 --network=elasticsearch_network \
    -e ELASTICSEARCH_PORT_NUMBER=9201 \
    -v /path/to/elasticsearch-data-persistence:/bitnami/elasticsearch/data \
    bitnami/elasticsearch
```

Available variables:

* `BITNAMI_DEBUG`: Increase verbosity on initialization logs. Default **false**
* `ELASTICSEARCH_EXTRA_FLAGS`: Extra command-line arguments for the `elasticsearch` daemon
* `ELASTICSEARCH_CLUSTER_NAME`: The Elasticsearch Cluster Name. Default: **elasticsearch-cluster**
* `ELASTICSEARCH_CLUSTER_HOSTS`: List of elasticsearch hosts to set the cluster. Available separators are ' ', ',' and ';'. No defaults.
* `ELASTICSEARCH_CLUSTER_MASTER_HOSTS`: List of elasticsearch master-eligible hosts. Available separators are ' ', ',' and ';'. If no values are provided, it will have the same value than `ELASTICSEARCH_CLUSTER_HOSTS`.
* `ELASTICSEARCH_IS_DEDICATED_NODE`: Elasticsearch node to behave as a 'dedicated node'. Default: **no**
* `ELASTICSEARCH_NODE_TYPE`: Elasticsearch node type when behaving as a 'dedicated node'. Valid values: *master*, *data*, *coordinating* or *ingest*.
* `ELASTICSEARCH_NODE_NAME`: Elasticsearch node name. No defaults.
* `ELASTICSEARCH_BIND_ADDRESS`: Address/interface to bind by Elasticsearch. Default: **0.0.0.0**
* `ELASTICSEARCH_PORT_NUMBER`: Elasticsearch port. Default: **9200**
* `ELASTICSEARCH_NODE_PORT_NUMBER`: Elasticsearch Node to Node port. Default: **9300**
* `ELASTICSEARCH_PLUGINS`: Comma, semi-colon or space separated list of plugins to install at initialization. No defaults.
* `ELASTICSEARCH_KEYS`: Comma, semi-colon or space separated list of key-value pairs (key=value) to store. No defaults.
* `ELASTICSEARCH_HEAP_SIZE`: Memory used for the Xmx and Xms java heap values. Default: **1024m**
* `ELASTICSEARCH_FS_SNAPSHOT_REPO_PATH`: Elasticsearch file system snapshot repository path. No defaults.
* `ELASTICSEARCH_DATA_DIR_LIST`: Comma, semi-colon or space separated list of directories to use for data storage. No defaults.

### Setting up a cluster

A cluster can easily be setup with the Bitnami Elasticsearch Docker Image using the following environment variables:

* `ELASTICSEARCH_CLUSTER_NAME`: The Elasticsearch Cluster Name. Default: **elasticsearch-cluster**
* `ELASTICSEARCH_CLUSTER_HOSTS`: List of elasticsearch hosts to set the cluster. Available separators are ' ', ',' and ';'. No defaults.
* `ELASTICSEARCH_CLIENT_NODE`: Elasticsearch node to behave as a 'smart router' for Kibana app. Default: **false**
* `ELASTICSEARCH_NODE_NAME`: Elasticsearch node name. No defaults.
* `ELASTICSEARCH_MINIMUM_MASTER_NODES`: Minimum Elasticsearch master nodes for quorum. No defaults.

For larger cluster, you can setup 'dedicated nodes' using the following environment variables:

* `ELASTICSEARCH_IS_DEDICATED_NODE`: Elasticsearch node to behave as a 'dedicated node'. Default: **no**
* `ELASTICSEARCH_NODE_TYPE`: Elasticsearch node type when behaving as a 'dedicated node'. Valid values: *master*, *data*, *coordinating* or *ingest*.
* `ELASTICSEARCH_CLUSTER_MASTER_HOSTS`: List of elasticsearch master-eligible hosts. Available separators are ' ', ',' and ';'. If no values are provided, it will have the same value than `ELASTICSEARCH_CLUSTER_HOSTS`.
* `ELASTICSEARCH_TOTAL_NODES`: Number of master + data nodes, it's used to calculate `gateway.expected_nodes` and `gateway.recover_after_nodes` parameters. If not set, those parameters are calculated using `ELASTICSEARCH_CLUSTER_HOSTS`. No defaults.

Find more information about 'dedicated nodes' in the [official documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-node.html).

#### Step 1: Create a new network.

```console
$ docker network create elasticsearch_network
```

#### Step 2: Create a first node.

```console
$ docker run --name elasticsearch-node1 \
  --net=elasticsearch_network \
  -p 9200:9200 \
  -e ELASTICSEARCH_CLUSTER_NAME=elasticsearch-cluster \
  -e ELASTICSEARCH_CLUSTER_HOSTS=elasticsearch-node1,elasticsearch-node2 \
  -e ELASTICSEARCH_NODE_NAME=elastic-node1 \
  bitnami/elasticsearch:latest
```

In the above command the container is added to a cluster named `elasticsearch-cluster` using the `ELASTICSEARCH_CLUSTER_NAME`. The `ELASTICSEARCH_CLUSTER_HOSTS` parameter set the name of the nodes that set the cluster so we will need to launch other container for the second node. Finally the `ELASTICSEARCH_NODE_NAME` parameter allows to indicate a known name for the node, otherwise elasticsearch will generate a randon one.

#### Step 3: Create a second node

```console
$ docker run --name elasticsearch-node2 \
  --link elasticsearch-node1:elasticsearch-node1 \
  --net=elasticsearch_network \
  -e ELASTICSEARCH_CLUSTER_NAME=elasticsearch-cluster \
  -e ELASTICSEARCH_CLUSTER_HOSTS=elasticsearch-node1,elasticsearch-node2 \
  -e ELASTICSEARCH_NODE_NAME=elastic-node2 \
  bitnami/elasticsearch:latest
```

In the above command a new elasticsearch node is being added to the elasticsearch cluster indicated by `ELASTICSEARCH_CLUSTER_NAME`.

You now have a two node Elasticsearch cluster up and running which can be scaled by adding/removing nodes.

With Docker Compose the cluster configuration can be setup using:

```yaml
version: '2'
services:
  elasticsearch-node1:
    image: bitnami/elasticsearch:latest
    environment:
      - ELASTICSEARCH_CLUSTER_NAME=elasticsearch-cluster
      - ELASTICSEARCH_CLUSTER_HOSTS=elasticsearch-node1,elasticsearch-node2
      - ELASTICSEARCH_NODE_NAME=elastic-node1

  elasticsearch-node2:
    image: bitnami/elasticsearch:latest
    environment:
      - ELASTICSEARCH_CLUSTER_NAME=elasticsearch-cluster
      - ELASTICSEARCH_CLUSTER_HOSTS=elasticsearch-node1,elasticsearch-node2
      - ELASTICSEARCH_NODE_NAME=elastic-node2
```

### Configuration file

In order to use a custom configuration file instead of the default one provided out of the box, you can create a file named `elasticsearch.yml` and mount it at `/opt/bitnami/elasticsearch/config/elasticsearch.yml` to overwrite the default configuration:

```console
$ docker run -d --name elasticsearch \
    -p 9201:9201 \
    -v /path/to/elasticsearch.yml:/opt/bitnami/elasticsearch/config/elasticsearch.yml \
    -v /path/to/elasticsearch-data-persistence:/bitnami/elasticsearch/data \
    bitnami/elasticsearch:latest
```

or by changing the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-elasticsearch/blob/master/docker-compose.yml) file present in this repository:

```yaml
elasticsearch:
  ...
  volumes:
    - /path/to/elasticsearch.yml:/opt/bitnami/elasticsearch/config/elasticsearch.yml
    - /path/to/elasticsearch-data-persistence:/bitnami/elasticsearch/data
  ...
```

Please, note that the whole configuration file will be replaced by the provided, default one; ensure that the syntax and fields you provide are properly set and exhaustive.

If you would rather extend than replace the default configuration with your settings, mount your custom configuration file at `/opt/bitnami/elasticsearch/config/my_elasticsearch.yml`.

### Plugins

The Bitnami Elasticsearch Docker image comes with the [S3 Repository plugin](https://www.elastic.co/guide/en/elasticsearch/plugins/current/repository-s3.html) installed by default.

You can add extra plugins by setting the `ELASTICSEARCH_PLUGINS` environment variable. To specify multiple plugins, separate them by spaces, commas or semicolons. When the container is initialized it will install all of the specified plugins before starting Elasticsearch.

```console
$ docker run -d --name elasticsearch \
    -e ELASTICSEARCH_PLUGINS=analysis-icu \
    bitnami/elasticsearch:latest
```

The Bitnami Elasticsearch Docker image will also install plugin `.zip` files mounted at the `/bitnami/elasticsearch/plugins` directory inside the container, making it possible to install them from disk without requiring Internet access.

#### Adding plugins at build time (persisting plugins)

The Bitnami Elasticsearch image provides a way to create your custom image installing plugins on build time. This is the preferred way to persist plugins when using ElasticSearch, as they will not be installed every time the container is started but just once at build time.

To create your own image providing plugins execute the flowing command:

```
docker build --build-arg ELASTICSEARCH_PLUGINS=<plugin1,plugin2,...> https://github.com/bitnami/bitnami-docker-elasticsearch.git#:7/debian-10 -t my-elasticsearch
```

The command above will build the image providing this GitHub repository as build context, and will pass the list of plugins to install to the build logic.

### Initializing a new instance

When the container is executed for the first time, it will execute the files with extension `.sh` located at `/docker-entrypoint-initdb.d`.

In order to have your custom files inside the Docker image, you can mount them as a volume.

## Logging

The Bitnami Elasticsearch Docker image sends the container logs to the `stdout`. To view the logs:

```console
$ docker logs elasticsearch
```

or using Docker Compose:

```console
$ docker-compose logs elasticsearch
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

Additionally, in case you'd like to modify Elasticsearch logging configuration, it can be done by overwriting the file `/opt/bitnami/elasticsearch/config/log4j2.properties`.
The syntax of this file can be found in Elasticsearch [logging documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/logging.html).

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of Elasticsearch, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
$ docker pull bitnami/elasticsearch:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/elasticsearch:latest`.

#### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
$ docker stop elasticsearch
```

or using Docker Compose:

```console
$ docker-compose stop elasticsearch
```

Next, take a snapshot of the persistent volume `/path/to/elasticsearch-data-persistence` using:

```console
$ rsync -a /path/to/elasticsearch-data-persistence /path/to/elasticsearch-data-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

You can use this snapshot to restore the application state should the upgrade fail.

#### Step 3: Remove the currently running container

```console
$ docker rm -v elasticsearch
```

or using Docker Compose:

```console
$ docker-compose rm -v elasticsearch
```

#### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if necessary.

```console
$ docker run --name elasticsearch bitnami/elasticsearch:latest
```

or using Docker Compose:

```console
$ docker-compose up elasticsearch
```

## Notable Changes

### 7.12.0-debian-10-r0

* Elasticsearch 7.12.0 version or later are licensed under the Elastic License that is not currently accepted as an Open Source license by the Open Source Initiative (OSI).
* Elasticsearch 7.12.0 version or later are including x-pack plugin installed by default. Follow official documentation to use it.

### 6.8.5-debian-9-r0, 6.8.5-ol-7-r1, 7.4.2-debian-9-r10, 7.4.2-ol-7-r27

* Arbitrary user ID(s) when running the container with a non-privileged user are not supported (only `1001` UID is allowed).
* This is temporary solution while Elasticsearch maintainers address an issue with ownership/permissions when installing plugins. Issue reported at: https://github.com/bitnami/bitnami-docker-elasticsearch/issues/50

### 6.8.2-debian-9-r36, 6.8.2-ol-7-r36, 7.3.1-debian-9-r8, 7.3.1-ol-7-r13

* Updated OpenJDK to version 11

### 6.6.1-debian-9-r12, 6.6.1-ol-7-r13, 6.6.1-rhel-7-r13, 5.6.15-debian-9-r12 and 5.6.15-ol-7-r13

* Deprecate the use of `elasticsearch_custom.yml` in favor of replacing the whole `elasticsearch.yml` file.

### 6.4.0-debian-9-r19, 6.4.0-ol-7-r18, 5.6.4-debian-9-r54, and 5.6.4-ol-7-r60

* Decrease the size of the container. It is not necessary Node.js anymore. Elasticsearch configuration moved to bash scripts in the `rootfs/` folder.
* The recommended mount point to persist data changes to `/bitnami/elasticsearch/data`.
* The Elasticsearch configuration files are not persisted in a volume anymore. Now, they can be found at `/opt/bitnami/elasticsearch/config`.
* Elasticsearch `plugins` and `modules` are not persisted anymore. It's necessary to indicate what plugins to install using the env. variable `ELASTICSEARCH_PLUGINS`
* Backwards compatibility is not guaranteed when data is persisted using docker-compose. You can use the workaround below to overcome it:

```console
$ docker-compose down
# Change the mount point
sed -i -e 's#elasticsearch_data:/bitnami#elasticsearch_data:/bitnami/elasticsearch/data#g' docker-compose.yml
# Pull the latest bitnami/elasticsearch image
$ docker pull bitnami/elasticsearch:latest
$ docker-compose up -d
```

### 6.2.3-r7 & 5.6.4-r18

* The Elasticsearch container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the Elasticsearch daemon was started as the `elasticsearch` user. From now on, both the container and the Elasticsearch daemon run as user `1001`. As a consequence, the data directory must be writable by that user. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

### 6.2.3-r2 & 5.6.4-r6

* Elasticsearch container can be configured as a dedicated node with 4 different types: *master*, *data*, *coordinating* or *ingest*.
  Previously it was only achievable by using a custom `elasticsearch_custom.yml` file. From now on, you can use the environment variables `ELASTICSEARCH_IS_DEDICATED_NODE` & `ELASTICSEARCH_NODE_TYPE` to configure it.

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-elasticsearch/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-elasticsearch/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-elasticsearch/issues/new). For us to provide better support, be sure to include the following information in your issue:

* Host OS and version
* Docker version (`docker version`)
* Output of `docker info`
* Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
* The command you used to run the container, and any relevant output you saw (masking any sensitive information)

## License

Copyright 2016-2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
