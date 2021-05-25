# Bitnami Docker Image for RabbitMQ

## What is RabbitMQ?

> RabbitMQ is an open source message broker software that implements the Advanced Message Queuing Protocol (AMQP).
> The RabbitMQ server is written in the Erlang programming language and is built on the Open Telecom Platform
> framework for clustering and failover. Client libraries to interface with the broker are available for all major
> programming languages.

[https://www.rabbitmq.com/](https://www.rabbitmq.com/)

## TL;DR

```console
$ docker run --name rabbitmq bitnami/rabbitmq:latest
```

### Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-rabbitmq/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

You can find the default credentials and available configuration options in the [Environment Variables](#environment-variables) section.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/rabbitmq?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

## How to deploy RabbitMQ in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami RabbitMQ Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/rabbitmq).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`3.8`, `3.8-debian-10`, `3.8.16`, `3.8.16-debian-10-r17`, `latest` (3.8/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-rabbitmq/blob/3.8.16-debian-10-r17/3.8/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/rabbitmq GitHub repo](https://github.com/bitnami/bitnami-docker-rabbitmq).

## Get this image

The recommended way to get the Bitnami RabbitMQ Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/rabbitmq).

```console
$ docker pull bitnami/rabbitmq:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/rabbitmq/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/rabbitmq:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/rabbitmq:latest 'https://github.com/bitnami/bitnami-docker-rabbitmq.git#master:3.8/debian-10'
```

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami` path. If the mounted directory is empty, it will be initialized on the first run.

```console
$ docker run \
    -v /path/to/rabbitmq-persistence:/bitnami \
    bitnami/rabbitmq:latest
```

You can also do this with a minor change to the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-rabbitmq/blob/master/docker-compose.yml) file present in this repository:

```yaml
rabbitmq:
  ...
  volumes:
    - /path/to/rabbitmq-persistence:/bitnami
  ...
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a RabbitMQ server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

In this example, we will create a RabbitMQ client instance that will connect to the server instance that is running on the same docker network as the client.

#### Step 1: Create a network

```console
$ docker network create app-tier --driver bridge
```

#### Step 2: Launch the RabbitMQ server instance

Use the `--network app-tier` argument to the `docker run` command to attach the RabbitMQ container to the `app-tier` network.

```console
$ docker run -d --name rabbitmq-server \
    --network app-tier \
    bitnami/rabbitmq:latest
```

#### Step 3: Launch your RabbitMQ client instance

Finally we create a new container instance to launch the RabbitMQ client and connect to the server created in the previous step:

```console
$ docker run -it --rm \
    --network app-tier \
    bitnami/rabbitmq:latest rabbitmqctl -n rabbit@rabbitmq-server status
```

### Using Docker Compose

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `app-tier`. In this example we assume that you want to connect to the RabbitMQ server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge

services:
  rabbitmq:
    image: 'bitnami/rabbitmq:latest'
    networks:
      - app-tier
  myapp:
    image: 'YOUR_APPLICATION_IMAGE'
    networks:
      - app-tier
```

> **IMPORTANT**:
>
> 1. Please update the **YOUR_APPLICATION_IMAGE** placeholder in the above snippet with your application image
> 2. In your application container, use the hostname `rabbitmq` to connect to the RabbitMQ server

Launch the containers using:

```console
$ docker-compose up -d
```

## Configuration

### Environment variables

 When you start the rabbitmq image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. If you want to add a new environment variable:

* For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-rabbitmq/blob/master/docker-compose.yml) file present in this repository: :

```yaml
rabbitmq:
  ...
  environment:
    - RABBITMQ_PASSWORD=my_password
  ...
```

* For manual execution add a `-e` option with each variable and value.

Available variables:

#### Node and cluster configuration

* `RABBITMQ_VHOST`: RabbitMQ application vhost. Default: **/**
* `RABBITMQ_USERNAME`: RabbitMQ application username. Default: **user**
* `RABBITMQ_PASSWORD`: RabbitMQ application password. Default: **bitnami**
* `RABBITMQ_SECURE_PASSWORD`: Whether to set the RabbitMQ password securely. This is incompatible with loading external RabbitMQ definitions. Default: **yes**
* `RABBITMQ_LOAD_DEFINITIONS`: Whether to load external RabbitMQ definitions. This is incompatible with setting the RabbitMQ password securely. Default: **no**.
* `RABBITMQ_ERL_COOKIE`: Erlang cookie to determine whether different nodes are allowed to communicate with each other.
* `RABBITMQ_NODE_TYPE`: Node Type. Valid values: *stats*, *queue-ram* or *queue-disc*. Default: **stats**
* `RABBITMQ_NODE_NAME`: Node name and host. E.g.: *node@hostname* or *node* (localhost won't work in cluster topology). Default **rabbit@localhost**. If using this variable, ensure that you specify a valid host name as the container wil fail to start otherwise. If using a fully qualified domain name, `RABBITMQ_USE_LONGNAME` needs to be set to `true` as well.
* `RABBITMQ_USE_LONGNAME`: When set to *true* this will cause RabbitMQ to use fully qualified names to identify nodes. Default: **false**
* `RABBITMQ_FORCE_BOOT`: Force a node to start even if it was not the last to shut down. Default: **no**
* `RABBITMQ_CLUSTER_NODE_NAME`: Node name to cluster with. E.g.: **clusternode@hostname**
* `RABBITMQ_CLUSTER_PARTITION_HANDLING`: Cluster partition recovery mechanism. Default: **ignore**
* `RABBITMQ_NODE_PORT_NUMBER`: Node port. Default: **5672**
* `RABBITMQ_NODE_SSL_PORT_NUMBER`: RabbitMQ node port number for SSL connections. Default: **5671**
* `RABBITMQ_SSL_CACERTFILE`: Path to the RabbitMQ server SSL CA certificate file. No defaults.
* `RABBITMQ_SSL_CERTFILE`: Path to the RabbitMQ server SSL certificate file. No defaults.
* `RABBITMQ_SSL_KEYFILE`: Path to the RabbitMQ server SSL certificate key file. No defaults.
* `RABBITMQ_COMBINED_CERT_PATH`: Cert- and keyfile are combined automatically into one combined file at this file path. If you are using a combined certificate anyways, mount it to the container and set this path to the mounted file. Default: **/tmp/rabbitmq_combined_keys.pem**
* `RABBITMQ_SSL_DEPTH`: Maximum number of non-self-issued intermediate certificates that may follow the peer certificate in a valid certification path. No defaults.
* `RABBITMQ_SSL_FAIL_IF_NO_PEER_CERT`: Whether to reject TLS connections if client fails to provide a certificate. Default: **verify_none**
* `RABBITMQ_SSL_VERIFY`: Whether to enable peer SSL certificate verification. Default: **no**
* `RABBITMQ_PLUGINS`: Comma, semi-colon or space separated list of plugins to enable during the initialization. No defaults.
* `RABBITMQ_COMMUNITY_PLUGINS`: Comma, semi-colon or space separated list of URLs where to download custom plugins during the initialization. No defaults.

#### Management server configuration

* `RABBITMQ_MANAGEMENT_BIND_IP`: RabbitMQ management server bind IP address. Default: **0.0.0.0**
* `RABBITMQ_MANAGEMENT_PORT_NUMBER`: RabbitMQ management server port number. Default: **15672**
* `RABBITMQ_MANAGEMENT_SSL_PORT_NUMBER`: RabbitMQ management server port number for SSL/TLS connections. No defaults.
* `RABBITMQ_MANAGEMENT_SSL_CACERTFILE`: Path to the RabbitMQ management server SSL CA certificate file. No defaults.
* `RABBITMQ_MANAGEMENT_SSL_CERTFILE`: Path to the RabbitMQ management server SSL certificate file. No defaults.
* `RABBITMQ_MANAGEMENT_SSL_KEYFILE`: Path to the RabbitMQ management server SSL certificate key file. No defaults.
* `RABBITMQ_MANAGEMENT_SSL_DEPTH`: Maximum number of non-self-issued intermediate certificates that may follow the peer certificate in a valid certification path, for the RabbitMQ management server. No defaults.
* `RABBITMQ_MANAGEMENT_SSL_FAIL_IF_NO_PEER_CERT`: Whether to reject TLS connections if client fails to provide a certificate for the RabbitMQ management server. Default: **yes**
* `RABBITMQ_MANAGEMENT_SSL_VERIFY`: Whether to enable peer SSL certificate verification for the RabbitMQ management server. Default: **verify_peer**

#### LDAP configuration

* `RABBITMQ_ENABLE_LDAP`: Enable the LDAP configuration. Defaults: **no**
* `RABBITMQ_LDAP_TLS`: Enable secure LDAP configuration. Defaults: **no**
* `RABBITMQ_LDAP_SERVERS`: Comma, semi-colon or space separated list of LDAP server hostnames. No defaults.
* `RABBITMQ_LDAP_SERVERS_PORT`: LDAP servers port. Defaults: **389**
* `RABBITMQ_LDAP_USER_DN_PATTERN`: DN used to bind to LDAP in the form `cn=$${username},dc=example,dc=org`. No defaults.

#### Memory and disk configuration

* `RABBITMQ_VM_MEMORY_HIGH_WATERMARK`: High memory watermark for RabbitMQ to block publishers and prevent new messages from being enqueued. Can be specified as an absolute or relative value (as percentage or value between 0 and 1). No defaults.
* `RABBITMQ_DISK_FREE_RELATIVE_LIMIT`: Disk relative free space limit of the partition on which RabbitMQ is storing data. Default: **1.0**
* `RABBITMQ_DISK_FREE_ABSOLUTE_LIMIT`: Disk absolute free space limit of the partition on which RabbitMQ is storing data (takes precedence over the relative limit). No defaults.
* `RABBITMQ_ULIMIT_NOFILES`: Resources limits: maximum number of open file descriptors. Default: **65536**

### Setting up a cluster

#### Docker Compose

This is the simplest way to run RabbitMQ with clustering configuration:

##### Step 1: Add a stats node in your `docker-compose.yml`

Copy the snippet below into your docker-compose.yml to add a RabbitMQ stats node to your cluster configuration.

```yaml
version: '2'

services:
  stats:
    image: bitnami/rabbitmq
    environment:
      - RABBITMQ_NODE_TYPE=stats
      - RABBITMQ_NODE_NAME=rabbit@stats
      - RABBITMQ_ERL_COOKIE=s3cr3tc00ki3
    ports:
      - '15672:15672'
    volumes:
      - 'rabbitmqstats_data:/bitnami'
```

> **Note:** The name of the service (**stats**) is important so that a node could resolve the hostname to cluster with. (Note that the node name is `rabbit@stats`)

##### Step 2: Add a queue node in your configuration

Update the definitions for nodes you want your RabbitMQ stats node cluster with.

```yaml
  queue-disc1:
    image: bitnami/rabbitmq
    environment:
      - RABBITMQ_NODE_TYPE=queue-disc
      - RABBITMQ_NODE_NAME=rabbit@queue-disc1
      - RABBITMQ_CLUSTER_NODE_NAME=rabbit@stats
      - RABBITMQ_ERL_COOKIE=s3cr3tc00ki3
    volumes:
      - 'rabbitmqdisc1_data:/bitnami'
```

> **Note:** Again, the name of the service (**queue-disc1**) is important so that each node could resolve the hostname of this one.

We are going to add a ram node too:

```yaml
  queue-ram1:
    image: bitnami/rabbitmq
    environment:
      - RABBITMQ_NODE_TYPE=queue-ram
      - RABBITMQ_NODE_NAME=rabbit@queue-ram1
      - RABBITMQ_CLUSTER_NODE_NAME=rabbit@stats
      - RABBITMQ_ERL_COOKIE=s3cr3tc00ki3
    volumes:
      - 'rabbitmqram1_data:/bitnami'
```

##### Step 3: Add the volume description

```yaml
volumes:
  rabbitmqstats_data:
    driver: local
  rabbitmqdisc1_data:
    driver: local
  rabbitmqram1_data:
    driver: local
```

The `docker-compose.yml` will look like this:

```yaml
version: '2'

services:
  stats:
    image: bitnami/rabbitmq
    environment:
      - RABBITMQ_NODE_TYPE=stats
      - RABBITMQ_NODE_NAME=rabbit@stats
      - RABBITMQ_ERL_COOKIE=s3cr3tc00ki3
    ports:
      - '15672:15672'
    volumes:
      - 'rabbitmqstats_data:/bitnami'
  queue-disc1:
    image: bitnami/rabbitmq
    environment:
      - RABBITMQ_NODE_TYPE=queue-disc
      - RABBITMQ_NODE_NAME=rabbit@queue-disc1
      - RABBITMQ_CLUSTER_NODE_NAME=rabbit@stats
      - RABBITMQ_ERL_COOKIE=s3cr3tc00ki3
    volumes:
      - 'rabbitmqdisc1_data:/bitnami'
  queue-ram1:
    image: bitnami/rabbitmq
    environment:
      - RABBITMQ_NODE_TYPE=queue-ram
      - RABBITMQ_NODE_NAME=rabbit@queue-ram1
      - RABBITMQ_CLUSTER_NODE_NAME=rabbit@stats
      - RABBITMQ_ERL_COOKIE=s3cr3tc00ki3
    volumes:
      - 'rabbitmqram1_data:/bitnami'

volumes:
  rabbitmqstats_data:
    driver: local
  rabbitmqdisc1_data:
    driver: local
  rabbitmqram1_data:
    driver: local
```

### Configuration file

A custom `rabbitmq.conf` configuration file can be mounted to the `/bitnami/rabbitmq/conf` directory. If no file is mounted, the container will generate a default one based on the environment variables. You can also mount on this directory your own `advanced.config` (using classic Erlang terms) and `rabbitmq-env.conf` configuration files.

As an alternative, you can also mount a `custom.conf` configuration file and mount it to the `/bitnami/rabbitmq/conf` directory. In this case, the default configuation file will be generated and, later on, the settings available in the `custom.conf` configuration file will be merged with the default ones. For example, in order to override the `listeners.tcp.default` directive:

#### Step 1: Write your custom.conf configuation file with the following content.

```ini
listeners.tcp.default=1337
```

#### Step 2: Run RabbitMQ mounting your custom.conf configuation file

```
$ docker run -d --name rabbitmq-server \
   -v /path/to/custom.conf:/bitnami/rabbitmq/conf/custom.conf:ro \
    bitnami/rabbitmq:latest
```

After that, your changes will be taken into account in the server's behaviour.

## Enabling LDAP support

LDAP configuration parameters must be specified if you wish to enable LDAP support for RabbitMQ. The following environment variables are available to configure LDAP support:

* `RABBITMQ_ENABLE_LDAP`: Enable the LDAP configuration. Defaults to `no`.
* `RABBITMQ_LDAP_TLS`: Enable secure LDAP configuration. Defaults to `no`.
* `RABBITMQ_LDAP_SERVERS`: Comma, semi-colon or space separated list of LDAP server hostnames. No defaults.
* `RABBITMQ_LDAP_SERVERS_PORT`: LDAP servers port. Defaults: **389**
* `RABBITMQ_LDAP_USER_DN_PATTERN`: DN used to bind to LDAP in the form `cn=$${username},dc=example,dc=org`.No defaults.

> Note: To escape `$` in `RABBITMQ_LDAP_USER_DN_PATTERN` you need to use `$$`.

Follow these instructions to use the [Bitnami Docker OpenLDAP](https://github.com/bitnami/bitnami-docker-openldap) image to create an OpenLDAP server and use it to authenticate users on RabbitMQ:

### Step 1: Create a network

```console
$ docker network create app-tier --driver bridge
```

### Step 2: Start an OpenLDAP server

```console
$ docker run --name openldap \
  --env LDAP_ADMIN_USERNAME=admin \
  --env LDAP_ADMIN_PASSWORD=adminpassword \
  --env LDAP_USERS=user01,user02 \
  --env LDAP_PASSWORDS=password1,password2 \
  --network app-tier \
  bitnami/openldap:latest
```

### Step 3: Create an advanced.config file

To configure authorization, you need to create an advanced.config file, following the [clasic config format](https://www.rabbitmq.com/configure.html#erlang-term-config-file), and add your authorization rules. For instance, use the file below to grant all users the ability to use the management plugin, but make none of them administrators:

```
[{rabbitmq_auth_backend_ldap,[
    {tag_queries, [{administrator, {constant, false}},
                   {management,    {constant, true}}]}
]}].
```

More information at [https://www.rabbitmq.com/ldap.html#authorisation](https://www.rabbitmq.com/ldap.html#authorisation).

### Step 4: Start RabbitMQ with LDAP support

```console
$ docker run --name rabbitmq \
  --env RABBITMQ_ENABLE_LDAP=yes \
  --env RABBITMQ_LDAP_TLS=no \
  --env RABBITMQ_LDAP_SERVERS=openldap \
  --env RABBITMQ_LDAP_SERVERS_PORT=1389 \
  --env RABBITMQ_LDAP_USER_DN_PATTERN=cn=$${username},ou=users,dc=example,dc=org \
  --network app-tier \
  -v /path/to/your/advanced.config:/bitnami/rabbitmq/conf/advanced.config:ro \
  bitnami/rabbitmq:latest
```

## Logging

The Bitnami RabbitMQ Docker image sends the container logs to the `stdout`. To view the logs:

```console
$ docker logs rabbitmq
```

or using Docker Compose:

```console
$ docker-compose logs rabbitmq
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Upgrade this application

Bitnami provides up-to-date versions of RabbitMQ, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
$ docker pull bitnami/rabbitmq:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/rabbitmq:latest`.

#### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
$ docker stop rabbitmq
```

or using Docker Compose:

```console
$ docker-compose stop rabbitmq
```

Next, take a snapshot of the persistent volume `/path/to/rabbitmq-persistence` using:

```console
$ rsync -a /path/to/rabbitmq-persistence /path/to/rabbitmq-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

#### Step 3: Remove the currently running container

```console
$ docker rm -v rabbitmq
```

or using Docker Compose:

```console
$ docker-compose rm -v rabbitmq
```

#### Step 4: Run the new image

Re-create your container from the new image.

```console
$ docker run --name rabbitmq bitnami/rabbitmq:latest
```

or using Docker Compose:

```console
$ docker-compose up rabbitmq
```

## Notable changes

### 3.8.9-debian-10-r82

* Add script to be used as preStop hook on K8s environments. It waits until queues have synchronised
  mirror before shutting down.

### 3.8.9-debian-10-r42

* The environment variable `RABBITMQ_HASHED_PASSWORD` has not been used for some time. It is now
  removed from documentation and validation.
* New boolean environment variable `RABBITMQ_LOAD_DEFINITIONS` to get behavior compatible with using
  the `load_definitions` configuration. Initially this means that the password of
  `RABBITMQ_USERNAME` is not changed using `rabbitmqctl change_password`.

### 3.8.3-debian-10-r109

* The default configuration file is created following the "sysctl" or "ini-like" format instead of using Erlang terms. Check [Official documentation](https://www.rabbitmq.com/configure.html#config-file-formats) for more information about supported formats.
* Migrating data/configuration from unsupported locations is not performed anymore.
* New environment variable `RABBITMQ_FORCE_BOOT` to force a node to start even if it was not the last to shut down.
* New environment variable `RABBITMQ_PLUGINS` to indicate a list of plugins to enable during the initialization.
* Add healthcheck scripts to be used on K8s environments.

### 3.8.0-r17, 3.8.0-ol-7-r26

* LDAP authentication

### 3.7.15-r18, 3.7.15-ol-7-r19

* Decrease the size of the container. Node.js is not needed anymore. RabbitMQ configuration logic has been moved to bash scripts in the `rootfs` folder.
* Configuration is not persisted anymore.

### 3.7.7-r35

* The RabbitMQ container includes a new environment variable `RABBITMQ_HASHED_PASSWORD` that allows setting password via SHA256 hash (consult [official documentation](https://www.rabbitmq.com/passwords.html) for more information about password hashes).
* Please note that password hashes must be generated following the [official algorithm](https://www.rabbitmq.com/passwords.html#computing-password-hash). You can use [this Python script](https://gist.githubusercontent.com/anapsix/4c3e8a8685ce5a3f0d7599c9902fd0d5/raw/1203a480fcec1982084b3528415c3cad26541b82/rmq_passwd_hash.py) to generate them.

### 3.7.7-r19

* The RabbitMQ container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the RabbitMQ daemon was started as the `rabbitmq` user. From now on, both the container and the RabbitMQ daemon run as user `1001`. As a consequence, the data directory must be writable by that user. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

### 3.6.5-r2

The following parameters have been renamed:

|            From            |              To              |
|----------------------------|------------------------------|
| `RABBITMQ_ERLANG_COOKIE`   | `RABBITMQ_ERL_COOKIE`        |
| `RABBITMQ_NODETYPE`        | `RABBITMQ_NODE_TYPE`         |
| `RABBITMQ_NODEPORT`        | `RABBITMQ_NODE_PORT`         |
| `RABBITMQ_NODENAME`        | `RABBITMQ_NODE_NAME`         |
| `RABBITMQ_CLUSTERNODENAME` | `RABBITMQ_CLUSTER_NODE_NAME` |
| `RABBITMQ_MANAGERPORT`     | `RABBITMQ_MANAGER_PORT`      |

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an
[issue](https://github.com/bitnami/bitnami-docker-rabbitmq/issues), or submit a
[pull request](https://github.com/bitnami/bitnami-docker-rabbitmq/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an
[issue](https://github.com/bitnami/bitnami-docker-rabbitmq/issues/new). For us to provide better support,
be sure to include the following information in your issue:

* Host OS and version
* Docker version (`docker version`)
* Output of `docker info`
* Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
* The command you used to run the container, and any relevant output you saw (masking any sensitive
information)

## License

Copyright (c) 2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
