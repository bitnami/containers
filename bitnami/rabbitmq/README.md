# Bitnami package for RabbitMQ

## What is RabbitMQ?

> RabbitMQ is an open source general-purpose message broker that is designed for consistent, highly-available messaging scenarios (both synchronous and asynchronous).

[Overview of RabbitMQ](https://www.rabbitmq.com)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name rabbitmq bitnami/rabbitmq:latest
```

You can find the default credentials and available configuration options in the [Environment Variables](#environment-variables) section.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use RabbitMQ in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## How to deploy RabbitMQ in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami RabbitMQ Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/rabbitmq).

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

The recommended way to get the Bitnami RabbitMQ Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/rabbitmq).

```console
docker pull bitnami/rabbitmq:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/rabbitmq/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/rabbitmq:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/rabbitmq/mnesia` path. If the mounted directory is empty, it will be initialized on the first run.

```console
docker run \
    -v /path/to/rabbitmq-persistence:/bitnami/rabbitmq/mnesia \
    bitnami/rabbitmq:latest
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a RabbitMQ server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

In this example, we will create a RabbitMQ client instance that will connect to the server instance that is running on the same docker network as the client.

#### Step 1: Create a network

```console
docker network create app-tier --driver bridge
```

#### Step 2: Launch the RabbitMQ server instance

Use the `--network app-tier` argument to the `docker run` command to attach the RabbitMQ container to the `app-tier` network.

```console
docker run -d --name rabbitmq-server \
    --network app-tier \
    bitnami/rabbitmq:latest
```

#### Step 3: Launch your RabbitMQ client instance

Finally we create a new container instance to launch the RabbitMQ client and connect to the server created in the previous step:

```console
docker run -it --rm \
    --network app-tier \
    bitnami/rabbitmq:latest rabbitmqctl -n rabbit@rabbitmq-server status
```

### Using a Docker Compose file

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
docker-compose up -d
```

## Configuration

### Environment variables

#### Customizable environment variables

| Name                                           | Description                                                                                                                                                                                      | Default Value                        |
|------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------|
| `RABBITMQ_CONF_FILE`                           | RabbitMQ configuration file.                                                                                                                                                                     | `${RABBITMQ_CONF_DIR}/rabbitmq.conf` |
| `RABBITMQ_DEFINITIONS_FILE`                    | Whether to load external RabbitMQ definitions. This is incompatible with setting the RabbitMQ password securely.                                                                                 | `/app/load_definition.json`          |
| `RABBITMQ_SECURE_PASSWORD`                     | Whether to set the RabbitMQ password securely. This is incompatible with loading external RabbitMQ definitions.                                                                                  | `no`                                 |
| `RABBITMQ_UPDATE_PASSWORD`                     | Whether to update the password on container restart.                                                                                                                                             | `no`                                 |
| `RABBITMQ_CLUSTER_NODE_NAME`                   | RabbitMQ cluster node name. When specifying this, ensure you also specify a valid hostname as RabbitMQ will fail to start otherwise.                                                             | `nil`                                |
| `RABBITMQ_CLUSTER_PARTITION_HANDLING`          | RabbitMQ cluster partition recovery mechanism.                                                                                                                                                   | `ignore`                             |
| `RABBITMQ_DISK_FREE_RELATIVE_LIMIT`            | Disk relative free space limit of the partition on which RabbitMQ is storing data.                                                                                                               | `1.0`                                |
| `RABBITMQ_DISK_FREE_ABSOLUTE_LIMIT`            | Disk absolute free space limit of the partition on which RabbitMQ is storing data (takes precedence over the relative limit).                                                                    | `nil`                                |
| `RABBITMQ_ERL_COOKIE`                          | Erlang cookie to determine whether different nodes are allowed to communicate with each other.                                                                                                   | `nil`                                |
| `RABBITMQ_VM_MEMORY_HIGH_WATERMARK`            | High memory watermark for RabbitMQ to block publishers and prevent new messages from being enqueued. Can be specified as an absolute or relative value (as percentage or value between 0 and 1). | `nil`                                |
| `RABBITMQ_LOAD_DEFINITIONS`                    | Whether to load external RabbitMQ definitions. This is incompatible with setting the RabbitMQ password securely.                                                                                 | `no`                                 |
| `RABBITMQ_MANAGEMENT_BIND_IP`                  | RabbitMQ management server bind IP address.                                                                                                                                                      | `0.0.0.0`                            |
| `RABBITMQ_MANAGEMENT_PORT_NUMBER`              | RabbitMQ management server port number.                                                                                                                                                          | `15672`                              |
| `RABBITMQ_MANAGEMENT_ALLOW_WEB_ACCESS`         | Allow web access to RabbitMQ management portal for RABBITMQ_USERNAME                                                                                                                             | `false`                              |
| `RABBITMQ_NODE_NAME`                           | RabbitMQ node name.                                                                                                                                                                              | `rabbit@localhost`                   |
| `RABBITMQ_USE_LONGNAME`                        | Whether to use fully qualified names to identify nodes                                                                                                                                           | `false`                              |
| `RABBITMQ_NODE_PORT_NUMBER`                    | RabbitMQ node port number.                                                                                                                                                                       | `5672`                               |
| `RABBITMQ_NODE_TYPE`                           | RabbitMQ node type.                                                                                                                                                                              | `stats`                              |
| `RABBITMQ_VHOST`                               | RabbitMQ vhost.                                                                                                                                                                                  | `/`                                  |
| `RABBITMQ_VHOSTS`                              | List of additional virtual host (vhost).                                                                                                                                                         | `nil`                                |
| `RABBITMQ_CLUSTER_REBALANCE`                   | Rebalance the RabbitMQ Cluster.                                                                                                                                                                  | `false`                              |
| `RABBITMQ_CLUSTER_REBALANCE_ATTEMPTS`          | Max attempts for the rebalance check to run                                                                                                                                                      | `100`                                |
| `RABBITMQ_USERNAME`                            | RabbitMQ user name.                                                                                                                                                                              | `user`                               |
| `RABBITMQ_PASSWORD`                            | RabbitMQ user password.                                                                                                                                                                          | `bitnami`                            |
| `RABBITMQ_FORCE_BOOT`                          | Force a node to start even if it was not the last to shut down                                                                                                                                   | `no`                                 |
| `RABBITMQ_ENABLE_LDAP`                         | Enable the LDAP configuration.                                                                                                                                                                   | `no`                                 |
| `RABBITMQ_LDAP_TLS`                            | Enable secure LDAP configuration.                                                                                                                                                                | `no`                                 |
| `RABBITMQ_LDAP_SERVERS`                        | Comma, semi-colon or space separated list of LDAP server hostnames.                                                                                                                              | `nil`                                |
| `RABBITMQ_LDAP_SERVERS_PORT`                   | LDAP servers port.                                                                                                                                                                               | `389`                                |
| `RABBITMQ_LDAP_USER_DN_PATTERN`                | DN used to bind to LDAP in the form cn=$${username},dc=example,dc=org.                                                                                                                           | `nil`                                |
| `RABBITMQ_NODE_SSL_PORT_NUMBER`                | RabbitMQ node port number for SSL connections.                                                                                                                                                   | `5671`                               |
| `RABBITMQ_SSL_CACERTFILE`                      | Path to the RabbitMQ server SSL CA certificate file.                                                                                                                                             | `nil`                                |
| `RABBITMQ_SSL_CERTFILE`                        | Path to the RabbitMQ server SSL certificate file.                                                                                                                                                | `nil`                                |
| `RABBITMQ_SSL_KEYFILE`                         | Path to the RabbitMQ server SSL certificate key file.                                                                                                                                            | `nil`                                |
| `RABBITMQ_SSL_PASSWORD`                        | RabbitMQ server SSL certificate key password.                                                                                                                                                    | `nil`                                |
| `RABBITMQ_SSL_DEPTH`                           | Maximum number of non-self-issued intermediate certificates that may follow the peer certificate in a valid certification path.                                                                  | `nil`                                |
| `RABBITMQ_SSL_FAIL_IF_NO_PEER_CERT`            | Whether to reject TLS connections if client fails to provide a certificate.                                                                                                                      | `no`                                 |
| `RABBITMQ_SSL_VERIFY`                          | Whether to enable peer SSL certificate verification. Valid values: verify_none, verify_peer.                                                                                                     | `verify_none`                        |
| `RABBITMQ_MANAGEMENT_SSL_PORT_NUMBER`          | RabbitMQ management server port number for SSL/TLS connections.                                                                                                                                  | `15671`                              |
| `RABBITMQ_MANAGEMENT_SSL_CACERTFILE`           | Path to the RabbitMQ management server SSL CA certificate file.                                                                                                                                  | `$RABBITMQ_SSL_CACERTFILE`           |
| `RABBITMQ_MANAGEMENT_SSL_CERTFILE`             | Path to the RabbitMQ server SSL certificate file.                                                                                                                                                | `$RABBITMQ_SSL_CERTFILE`             |
| `RABBITMQ_MANAGEMENT_SSL_KEYFILE`              | Path to the RabbitMQ management server SSL certificate key file.                                                                                                                                 | `$RABBITMQ_SSL_KEYFILE`              |
| `RABBITMQ_MANAGEMENT_SSL_PASSWORD`             | RabbitMQ management server SSL certificate key password.                                                                                                                                         | `$RABBITMQ_SSL_PASSWORD`             |
| `RABBITMQ_MANAGEMENT_SSL_DEPTH`                | Maximum number of non-self-issued intermediate certificates that may follow the peer certificate in a valid certification path, for the RabbitMQ management server.                              | `nil`                                |
| `RABBITMQ_MANAGEMENT_SSL_FAIL_IF_NO_PEER_CERT` | Whether to reject TLS connections if client fails to provide a certificate for the RabbitMQ management server.                                                                                   | `yes`                                |
| `RABBITMQ_MANAGEMENT_SSL_VERIFY`               | Whether to enable peer SSL certificate verification for the RabbitMQ management server. Valid values: verify_none, verify_peer.                                                                  | `verify_peer`                        |

#### Read-only environment variables

| Name                          | Description                                            | Value                                                             |
|-------------------------------|--------------------------------------------------------|-------------------------------------------------------------------|
| `RABBITMQ_VOLUME_DIR`         | Persistence base directory.                            | `/bitnami/rabbitmq`                                               |
| `RABBITMQ_BASE_DIR`           | RabbitMQ installation directory.                       | `/opt/bitnami/rabbitmq`                                           |
| `RABBITMQ_BIN_DIR`            | RabbitMQ executables directory.                        | `${RABBITMQ_BASE_DIR}/sbin`                                       |
| `RABBITMQ_DATA_DIR`           | RabbitMQ data directory.                               | `${RABBITMQ_VOLUME_DIR}/mnesia`                                   |
| `RABBITMQ_CONF_DIR`           | RabbitMQ configuration directory.                      | `${RABBITMQ_BASE_DIR}/etc/rabbitmq`                               |
| `RABBITMQ_DEFAULT_CONF_DIR`   | RabbitMQ default configuration directory.              | `${RABBITMQ_BASE_DIR}/etc/rabbitmq.default`                       |
| `RABBITMQ_CONF_ENV_FILE`      | RabbitMQ configuration file for environment variables. | `${RABBITMQ_CONF_DIR}/rabbitmq-env.conf`                          |
| `RABBITMQ_HOME_DIR`           | RabbitMQ home directory.                               | `${RABBITMQ_BASE_DIR}/.rabbitmq`                                  |
| `RABBITMQ_LIB_DIR`            | RabbitMQ lib directory.                                | `${RABBITMQ_BASE_DIR}/var/lib/rabbitmq`                           |
| `RABBITMQ_INITSCRIPTS_DIR`    | RabbitMQ init scripts directory.                       | `/docker-entrypoint-initdb.d`                                     |
| `RABBITMQ_LOGS_DIR`           | RabbitMQ logs directory.                               | `${RABBITMQ_BASE_DIR}/var/log/rabbitmq`                           |
| `RABBITMQ_PLUGINS_DIR`        | RabbitMQ plugins directory.                            | `${RABBITMQ_BASE_DIR}/plugins`                                    |
| `RABBITMQ_MOUNTED_CONF_DIR`   | RabbitMQ directory for mounted configuration files.    | `${RABBITMQ_VOLUME_DIR}/conf`                                     |
| `RABBITMQ_DAEMON_USER`        | RabbitMQ system user name.                             | `rabbitmq`                                                        |
| `RABBITMQ_DAEMON_GROUP`       | RabbitMQ system user group.                            | `rabbitmq`                                                        |
| `RABBITMQ_MNESIA_BASE`        | Path to RabbitMQ mnesia directory.                     | `$RABBITMQ_DATA_DIR`                                              |
| `RABBITMQ_COMBINED_CERT_PATH` | Path to the RabbitMQ server SSL certificate key file.  | `${RABBITMQ_COMBINED_CERT_PATH:-/tmp/rabbitmq_combined_keys.pem}` |

When you start the rabbitmq image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. If you want to add a new environment variable:

* For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/rabbitmq/docker-compose.yml) file present in this repository: :

```yaml
rabbitmq:
  ...
  environment:
    - RABBITMQ_PASSWORD=my_password
  ...
```

* For manual execution add a `-e` option with each variable and value.

### Setting up a cluster

#### Using Docker Compose

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
      - 'rabbitmqstats_data:/bitnami/rabbitmq/mnesia'
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
      - 'rabbitmqdisc1_data:/bitnami/rabbitmq/mnesia'
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
      - 'rabbitmqram1_data:/bitnami/rabbitmq/mnesia'
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
      - 'rabbitmqstats_data:/bitnami/rabbitmq/mnesia'
  queue-disc1:
    image: bitnami/rabbitmq
    environment:
      - RABBITMQ_NODE_TYPE=queue-disc
      - RABBITMQ_NODE_NAME=rabbit@queue-disc1
      - RABBITMQ_CLUSTER_NODE_NAME=rabbit@stats
      - RABBITMQ_ERL_COOKIE=s3cr3tc00ki3
    volumes:
      - 'rabbitmqdisc1_data:/bitnami/rabbitmq/mnesia'
  queue-ram1:
    image: bitnami/rabbitmq
    environment:
      - RABBITMQ_NODE_TYPE=queue-ram
      - RABBITMQ_NODE_NAME=rabbit@queue-ram1
      - RABBITMQ_CLUSTER_NODE_NAME=rabbit@stats
      - RABBITMQ_ERL_COOKIE=s3cr3tc00ki3
    volumes:
      - 'rabbitmqram1_data:/bitnami/rabbitmq/mnesia'

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

#### Step 1: Write your custom.conf configuation file with the following content

```ini
listeners.tcp.default=1337
```

#### Step 2: Run RabbitMQ mounting your custom.conf configuation file

```console
docker run -d --name rabbitmq-server \
   -v /path/to/custom.conf:/bitnami/rabbitmq/conf/custom.conf:ro \
    bitnami/rabbitmq:latest
```

After that, your changes will be taken into account in the server's behaviour.

## Permission of SSL/TLS certificate and key files

If you bind mount the certificate and key files from your local host to the container, make sure to set proper ownership and permissions of those files:

```console
sudo chown 1001:root <your cert/key files>
sudo chmod 400 <your cert/key files>
```

## Enabling LDAP support

LDAP configuration parameters must be specified if you wish to enable LDAP support for RabbitMQ. The following environment variables are available to configure LDAP support:

* `RABBITMQ_ENABLE_LDAP`: Enable the LDAP configuration. Defaults to `no`.
* `RABBITMQ_LDAP_TLS`: Enable secure LDAP configuration. Defaults to `no`.
* `RABBITMQ_LDAP_SERVERS`: Comma, semi-colon or space separated list of LDAP server hostnames. No defaults.
* `RABBITMQ_LDAP_SERVERS_PORT`: LDAP servers port. Defaults: **389**
* `RABBITMQ_LDAP_USER_DN_PATTERN`: DN used to bind to LDAP in the form `cn=$${username},dc=example,dc=org`.No defaults.

> Note: To escape `$` in `RABBITMQ_LDAP_USER_DN_PATTERN` you need to use `$$`.

Follow these instructions to use the [Bitnami Docker OpenLDAP](https://github.com/bitnami/containers/blob/main/bitnami/openldap) image to create an OpenLDAP server and use it to authenticate users on RabbitMQ:

### Step 1: Create a network and start an OpenLDAP server

```console
docker network create app-tier --driver bridge
docker run --name openldap \
  --env LDAP_ADMIN_USERNAME=admin \
  --env LDAP_ADMIN_PASSWORD=adminpassword \
  --env LDAP_USERS=user01,user02 \
  --env LDAP_PASSWORDS=password1,password2 \
  --network app-tier \
  bitnami/openldap:latest
```

### Step 3: Create an advanced.config file

To configure authorization, you need to create an advanced.config file, following the [clasic config format](https://www.rabbitmq.com/configure.html#erlang-term-config-file), and add your authorization rules. For instance, use the file below to grant all users the ability to use the management plugin, but make none of them administrators:

```text
[{rabbitmq_auth_backend_ldap,[
    {tag_queries, [{administrator, {constant, false}},
                   {management,    {constant, true}}]}
]}].
```

More information at [https://www.rabbitmq.com/ldap.html#authorisation](https://www.rabbitmq.com/ldap.html#authorisation).

### Step 4: Start RabbitMQ with LDAP support

```console
docker run --name rabbitmq \
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
docker logs rabbitmq
```

or using Docker Compose:

```console
docker-compose logs rabbitmq
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Upgrade this application

Bitnami provides up-to-date versions of RabbitMQ, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/rabbitmq:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/rabbitmq:latest`.

#### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
docker stop rabbitmq
```

or using Docker Compose:

```console
docker-compose stop rabbitmq
```

Next, take a snapshot of the persistent volume `/path/to/rabbitmq-persistence` using:

```console
rsync -a /path/to/rabbitmq-persistence /path/to/rabbitmq-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

#### Step 3: Remove the currently running container

```console
docker rm -v rabbitmq
```

or using Docker Compose:

```console
docker-compose rm -v rabbitmq
```

#### Step 4: Run the new image

Re-create your container from the new image.

```console
docker run --name rabbitmq bitnami/rabbitmq:latest
```

or using Docker Compose:

```console
docker-compose up rabbitmq
```

## Notable changes

### 3.8.16-debian-10-r28

* Added several minor changes to make the container compatible with the [RabbitMQ Cluster Operator](https://github.com/rabbitmq/cluster-operator/):
  * Add `/etc/rabbitmq`, `/var/log/rabbitmq` and `/var/lib/rabbitmq` as symlinks to the corresponding folders in `/opt/bitnami/rabbitmq`.
  * Set the `RABBITMQ_SECURE_PASSWORD` password to `no` by default. This does not affect the Bitnami RabbitMQ helm as it sets that variable to `yes` by default.
  * Enable the `rabbitmq-prometheus` plugin by default.

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

| From                       | To                           |
|----------------------------|------------------------------|
| `RABBITMQ_ERLANG_COOKIE`   | `RABBITMQ_ERL_COOKIE`        |
| `RABBITMQ_NODETYPE`        | `RABBITMQ_NODE_TYPE`         |
| `RABBITMQ_NODEPORT`        | `RABBITMQ_NODE_PORT`         |
| `RABBITMQ_NODENAME`        | `RABBITMQ_NODE_NAME`         |
| `RABBITMQ_CLUSTERNODENAME` | `RABBITMQ_CLUSTER_NODE_NAME` |
| `RABBITMQ_MANAGERPORT`     | `RABBITMQ_MANAGER_PORT`      |

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/rabbitmq).

If you detect any issue in the `docker-compose.yaml` file, feel free to report it or contribute with a fix by following our [Contributing Guidelines](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md).

## Contributing

We'd love for you to contribute to this Docker image. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

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
