# What is Pgpool-II?

> [Pgpool-II](http://pgpool.net) is a PostgreSQL proxy. It stands between PostgreSQL servers and their clients providing connection pooling, load balancing, automated failover, and replication.

# TL;DR

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-pgpool/master/docker-compose.yml > docker-compose.yml
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

> This [CVE scan report](https://quay.io/repository/bitnami/pgpool?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy Pgpool-II in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami PostgreSQL HA Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/postgresql-ha).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`4`, `4-debian-10`, `4.2.3`, `4.2.3-debian-10-r0`, `latest` (4/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-pgpool/blob/4.2.3-debian-10-r0/4/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/pgpool GitHub repo](https://github.com/bitnami/bitnami-docker-pgpool).

# Get this image

The recommended way to get the Bitnami Pgpool-II Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/pgpool).

```console
$ docker pull bitnami/pgpool:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/pgpool/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/pgpool:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/pgpool:latest 'https://github.com/bitnami/bitnami-docker-pgpool.git#master:4/debian-10'
```

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

In this example, we will create a PostgreSQL client instance that will connect to the pgpool instance that is running on the same docker network as the client.

### Step 1: Create a network

```console
$ docker network create my-network --driver bridge
```

### Step 2: Launch 2 postgresql-repmgr containers to be used as backend within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `my-network` network.

```console
$ docker run --detach --rm --name pg-0 \
  --network my-network \
  --env REPMGR_PARTNER_NODES=pg-0,pg-1 \
  --env REPMGR_NODE_NAME=pg-0 \
  --env REPMGR_NODE_NETWORK_NAME=pg-0 \
  --env REPMGR_PRIMARY_HOST=pg-0 \
  --env REPMGR_PASSWORD=repmgrpass \
  --env POSTGRESQL_POSTGRES_PASSWORD=adminpassword \
  --env POSTGRESQL_USERNAME=customuser \
  --env POSTGRESQL_PASSWORD=custompassword \
  --env POSTGRESQL_DATABASE=customdatabase \
  bitnami/postgresql-repmgr:latest
$ docker run --detach --rm --name pg-1 \
  --network my-network \
  --env REPMGR_PARTNER_NODES=pg-0,pg-1 \
  --env REPMGR_NODE_NAME=pg-1 \
  --env REPMGR_NODE_NETWORK_NAME=pg-1 \
  --env REPMGR_PRIMARY_HOST=pg-0 \
  --env REPMGR_PASSWORD=repmgrpass \
  --env POSTGRESQL_POSTGRES_PASSWORD=adminpassword \
  --env POSTGRESQL_USERNAME=customuser \
  --env POSTGRESQL_PASSWORD=custompassword \
  --env POSTGRESQL_DATABASE=customdatabase \
  bitnami/postgresql-repmgr:latest
```

### Step 3: Launch the pgpool container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `my-network` network.

```console
$ docker run --detach --rm --name pgpool \
  --network my-network \
  --env PGPOOL_BACKEND_NODES=0:pg-0:5432,1:pg-1:5432 \
  --env PGPOOL_SR_CHECK_USER=customuser \
  --env PGPOOL_SR_CHECK_PASSWORD=custompassword \
  --env PGPOOL_ENABLE_LDAP=no \
  --env PGPOOL_POSTGRES_USERNAME=postgres \
  --env PGPOOL_POSTGRES_PASSWORD=adminpassword \
  --env PGPOOL_ADMIN_USERNAME=admin \
  --env PGPOOL_ADMIN_PASSWORD=adminpassword \
  bitnami/pgpool:latest
```

### Step 4: Launch your PostgreSQL client instance

Finally we create a new container instance to launch the PostgreSQL client and connect to the server created in the previous step:

```console
$ docker run -it --rm \
  --network my-network \
  bitnami/postgresql:10 \
  psql -h pgpool -U customuser -d customdatabase
```

## Using Docker Compose

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `my-network`. In this example we assume that you want to connect to the Pgpool server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  my-network:
    driver: bridge
services:
  pg-0:
    image: bitnami/postgresql-repmgr:11
    ports:
      - 5432
    volumes:
      - pg_0_data:/bitnami/postgresql
    environment:
      - POSTGRESQL_POSTGRES_PASSWORD=adminpassword
      - POSTGRESQL_USERNAME=customuser
      - POSTGRESQL_PASSWORD=custompassword
      - POSTGRESQL_DATABASE=customdatabase
      - REPMGR_PASSWORD=repmgrpassword
      - REPMGR_PRIMARY_HOST=pg-0
      - REPMGR_PARTNER_NODES=pg-0,pg-1
      - REPMGR_NODE_NAME=pg-0
      - REPMGR_NODE_NETWORK_NAME=pg-0
  pg-1:
    image: bitnami/postgresql-repmgr:11
    ports:
      - 5432
    volumes:
      - pg_1_data:/bitnami/postgresql
    environment:
      - POSTGRESQL_POSTGRES_PASSWORD=adminpassword
      - POSTGRESQL_USERNAME=customuser
      - POSTGRESQL_PASSWORD=custompassword
      - POSTGRESQL_DATABASE=customdatabase
      - REPMGR_PASSWORD=repmgrpassword
      - REPMGR_PRIMARY_HOST=pg-0
      - REPMGR_PARTNER_NODES=pg-0,pg-1
      - REPMGR_NODE_NAME=pg-1
      - REPMGR_NODE_NETWORK_NAME=pg-1
  pgpool:
    image: bitnami/pgpool:4
    ports:
      - 5432:5432
    environment:
      - PGPOOL_BACKEND_NODES=0:pg-0:5432,1:pg-1:5432
      - PGPOOL_SR_CHECK_USER=customuser
      - PGPOOL_SR_CHECK_PASSWORD=custompassword
      - PGPOOL_ENABLE_LDAP=no
      - PGPOOL_POSTGRES_USERNAME=postgres
      - PGPOOL_POSTGRES_PASSWORD=adminpassword
      - PGPOOL_ADMIN_USERNAME=admin
      - PGPOOL_ADMIN_PASSWORD=adminpassword
    healthcheck:
      test: ["CMD", "/opt/bitnami/scripts/pgpool/healthcheck.sh"]
      interval: 10s
      timeout: 5s
      retries: 5
  myapp:
    image: 'YOUR_APPLICATION_IMAGE'
    networks:
      - my-network
volumes:
  pg_0_data:
    driver: local
  pg_1_data:
    driver: local
```

> **IMPORTANT**:
>
> 1. Please update the **YOUR_APPLICATION_IMAGE_** placeholder in the above snippet with your application image
> 2. In your application container, use the hostname `pgpool` to connect to the PostgreSQL server

Launch the containers using:

```console
$ docker-compose up -d
```

# Configuration

## Setting up a HA PostgreSQL cluster with pgpool, streaming replication and repmgr

A HA PostgreSQL cluster with Pgpool, [Streaming replication](https://www.postgresql.org/docs/10/warm-standby.html#STREAMING-REPLICATION) and [repmgr](https://repmgr.org) can easily be setup with the Bitnami PostgreSQL with Replication Manager and Pgpool Docker Images using the following environment variables:

Pgpool configuration:

- `PGPOOL_PASSWORD_FILE`: Path to a file that contains the password for the custom user set in the `PGPOOL_USERNAME` environment variable. This will override the value specified in `PGPOOL_PASSWORD`. No defaults.
- `PGPOOL_SR_CHECK_PERIOD`: Specifies the time interval in seconds to check the streaming replication delay. Defaults to `30`.
- `PGPOOL_SR_CHECK_USER`: Username to use to perform streaming checks. No defaults.
- `PGPOOL_SR_CHECK_PASSWORD`: Password to use to perform streaming checks. No defaults.
- `PGPOOL_SR_CHECK_PASSWORD_FILE`: Path to a file that contains the password to use to perform streaming checks. This will override the value specified in `PGPOOL_SR_CHECK_PASSWORD`. No defaults.
- `PGPOOL_SR_CHECK_DATABASE`: Database to use to perform streaming checks. Defaults to `postgres`.
- `PGPOOL_BACKEND_NODES`: Comma separated list of backend nodes in the cluster. No defaults.
- `PGPOOL_ENABLE_LDAP`: Whether to enable LDAP authentication. Defaults to `no`.
- `PGPOOL_DISABLE_LOAD_BALANCE_ON_WRITE`: Specify load balance behavior after write queries appear ('off', 'transaction', 'trans_transaction', 'always'). Defaults to 'transaction'
- `PGPOOL_ENABLE_LOAD_BALANCING`: Whether to enable Load-Balancing mode. Defaults to `yes`.
- `PGPOOL_ENABLE_STATEMENT_LOAD_BALANCING`:  Whether to decide the load balancing node for each read query. Defaults to `no`.
- `PGPOOL_ENABLE_POOL_HBA`: Whether to use the pool_hba.conf authentication. Defaults to `yes`.
- `PGPOOL_ENABLE_POOL_PASSWD`: Whether to use a password file specified by `PGPOOL_PASSWD_FILE` for authentication. Defaults to `yes`.
- `PGPOOL_PASSWD_FILE`: The password file for authentication. Defaults to `pool_passwd`.
- `PGPOOL_NUM_INIT_CHILDREN`: The number of preforked Pgpool-II server processes. It is also the concurrent connections limit to Pgpool-II from clients. Defaults to `32`.
- `PGPOOL_MAX_POOL`: The maximum number of cached connections in each child process. Defaults to `15`.
- `PGPOOL_CHILD_MAX_CONNECTIONS`: The maximum number of client connections in each child process. Defaults to `0` which turns off the feature.
- `PGPOOL_CHILD_LIFE_TIME`: The time in seconds to terminate a Pgpool-II child process if it remains idle. Defaults to `300`.
- `PGPOOL_CLIENT_IDLE_LIMIT`: The time in seconds to disconnect a client if it remains idle since the last query. Defaults to `0` which turns off the feature.
- `PGPOOL_CONNECTION_LIFE_TIME`: The time in seconds to terminate the cached connections to the PostgreSQL backend. Defaults to `0` which turns off the feature.
- `PGPOOL_ENABLE_LOG_PER_NODE_STATEMENT`: Log every SQL statement for each DB node separately. Defaults to `no`.
- `PGPOOL_ENABLE_LOG_CONNECTIONS`: Log all client connections. Defaults to `no`.
- `PGPOOL_ENABLE_LOG_HOSTNAME`: Log the client hostname instead of IP address. Defaults to `no`.
- `PGPOOL_LOG_LINE_PREFIX`: Define the format of the log entry lines. Find in the [official Pgpool documentation](https://www.pgpool.net/docs/latest/en/html/runtime-config-logging.html) the string parameters. No defaults.
- `PGPOOL_CLIENT_MIN_MESSAGES`: Set the minimum message levels are sent to the client. Find in the [official Pgpool documentation](https://www.pgpool.net/docs/latest/en/html/runtime-config-logging.html) the supported values. Defaults to `notice`.
- `PGPOOL_POSTGRES_USERNAME`: Postgres administrator user name, this will be use to allow postgres admin authentication through Pgpool.
- `PGPOOL_POSTGRES_PASSWORD`: Password for the user set in `PGPOOL_POSTGRES_USERNAME` environment variable. No defaults.
- `PGPOOL_ADMIN_USERNAME`: Username for the pgpool administrator. No defaults.
- `PGPOOL_ADMIN_PASSWORD`: Password for the user set in `PGPOOL_ADMIN_USERNAME` environment variable. No defaults.
- `PGPOOL_HEALTH_CHECK_USER`: Specifies the PostgreSQL user name to perform health check. Defaults to value set in `PGPOOL_SR_CHECK_USER`.
- `PGPOOL_HEALTH_CHECK_PASSWORD`: Specifies the PostgreSQL user password to perform health check. Defaults to value set in `PGPOOL_SR_CHECK_PASSWORD`.
- `PGPOOL_HEALTH_CHECK_PERIOD`: Specifies the interval between the health checks in seconds. Defaults to `30`.
- `PGPOOL_HEALTH_CHECK_TIMEOUT`: Specifies the timeout in seconds to give up connecting to the backend PostgreSQL if the TCP connect does not succeed within this time. Defaults to `10`.
- `PGPOOL_HEALTH_CHECK_MAX_RETRIES`: Specifies the maximum number of retries to do before giving up and initiating failover when health check fails. Defaults to `5`.
- `PGPOOL_HEALTH_CHECK_RETRY_DELAY`: Specifies the amount of time in seconds to sleep between failed health check retries. Defaults to `5`.
- `PGPOOL_USER_CONF_FILE`: Configuration file to be added to the generated config file. This allow to override configuration set by the initializacion process. No defaults.
- `PGPOOL_POSTGRES_CUSTOM_USERS`: List of comma or semicolon separeted list of postgres usernames. This will create entries in `pgpool_passwd`. No defaults.
- `PGPOOL_POSTGRES_CUSTOM_PASSWORDS`: List of comma or semicolon separated list for postgresql user passwords. These are the corresponding passwords for the users in `PGPOOL_POSTGRES_CUSTOM_USERS`. No defaults.
- `PGPOOL_AUTO_FAILBACK`: Enables pgpool `[auto_failback](https://www.pgpool.net/docs/latest/en/html/runtime-config-failover.html)`. Default to `no`.
- `PGPOOL_BACKEND_APPLICATION_NAMES`: Comma separated list of backend nodes `application_name`. No defaults.

PostgreSQL with Replication Manager:

- `POSTGRESQL_POSTGRES_PASSWORD`: Password for `postgres` user. No defaults.
- `POSTGRESQL_POSTGRES_PASSWORD_FILE`: Path to a file that contains the `postgres` user password. This will override the value specified in `POSTGRESQL_POSTGRES_PASSWORD`. No defaults.
- `POSTGRESQL_USERNAME`: Custom user to access the database. No defaults.
- `POSTGRESQL_DATABASE`: Custom database to be created on first run. No defaults.
- `POSTGRESQL_PASSWORD`: Password for the custom user set in the `POSTGRESQL_USERNAME` environment variable. No defaults.
- `POSTGRESQL_PASSWORD_FILE`: Path to a file that contains the password for the custom user set in the `POSTGRESQL_USERNAME` environment variable. This will override the value specified in `POSTGRESQL_PASSWORD`. No defaults.
- `REPMGR_USERNAME`: Username for `repmgr` user. Defaults to `repmgr`.
- `REPMGR_PASSWORD_FILE`: Path to a file that contains the `repmgr` user password. This will override the value specified in `REPMGR_PASSWORD`. No defaults.
- `REPMGR_PASSWORD`: Password for `repmgr` user. No defaults.
- `REPMGR_PRIMARY_HOST`: Hostname of the initial primary node. No defaults.
- `REPMGR_PARTNER_NODES`: Comma separated list of partner nodes in the cluster.  No defaults.
- `REPMGR_NODE_NAME`: Node name. No defaults.
- `REPMGR_NODE_NETWORK_NAME`: Node hostname. No defaults.
- `POSTGRESQL_CLUSTER_APP_NAME`: Node `application_name`. In the case you are enabling auto_failback, each node needs a different name. Defaults to `walreceiver`.

In a HA PostgreSQL cluster you can have one primary and zero or more standby nodes. The primary node is in read-write mode, while the standby nodes are in read-only mode. For best performance its advisable to limit the reads to the standby nodes.

### Step 1: Create a network

```console
$ docker network create my-network --driver bridge
```

### Step 2: Create the initial primary node

The first step is to start the initial primary node:

```console
$ docker run --detach --name pg-0 \
  --network my-network \
  --env REPMGR_PARTNER_NODES=pg-0,pg-1 \
  --env REPMGR_NODE_NAME=pg-0 \
  --env REPMGR_NODE_NETWORK_NAME=pg-0 \
  --env REPMGR_PRIMARY_HOST=pg-0 \
  --env REPMGR_PASSWORD=repmgrpass \
  --env POSTGRESQL_POSTGRES_PASSWORD=adminpassword \
  --env POSTGRESQL_USERNAME=customuser \
  --env POSTGRESQL_PASSWORD=custompassword \
  --env POSTGRESQL_DATABASE=customdatabase \
  bitnami/postgresql-repmgr:latest
```

### Step 3: Create a standby node

Next we start a standby node:

```console
$ docker run --detach --name pg-1 \
  --network my-network \
  --env REPMGR_PARTNER_NODES=pg-0,pg-1 \
  --env REPMGR_NODE_NAME=pg-1 \
  --env REPMGR_NODE_NETWORK_NAME=pg-1 \
  --env REPMGR_PRIMARY_HOST=pg-0 \
  --env REPMGR_PASSWORD=repmgrpass \
  --env REPMGR_PASSWORD=repmgrpass \
  --env POSTGRESQL_POSTGRES_PASSWORD=adminpassword \
  --env POSTGRESQL_USERNAME=customuser \
  --env POSTGRESQL_PASSWORD=custompassword \
  --env POSTGRESQL_DATABASE=customdatabase \
  bitnami/postgresql-repmgr:latest
```

### Step 4: Create the pgpool instance

```console
$ docker run --detach --rm --name pgpool \
  --network my-network \
  --env PGPOOL_BACKEND_NODES=0:pg-0:5432,1:pg-1:5432 \
  --env PGPOOL_SR_CHECK_USER=postgres \
  --env PGPOOL_SR_CHECK_PASSWORD=adminpassword \
  --env PGPOOL_ENABLE_LDAP=no \
  --env PGPOOL_USERNAME=customuser \
  --env PGPOOL_PASSWORD=custompassword \
  bitnami/pgpool:latest
```

With these three commands you now have a two node PostgreSQL primary-standby streaming replication cluster using Pgpool as proxy up and running. You can scale the cluster by adding/removing standby nodes without incurring any downtime.

> **Note**: The cluster replicates the primary in its entirety, which includes all users and databases.

If the master goes down, **repmgr** will ensure any of the standby nodes takes the primary role, guaranteeing high availability.

> **Note**: The configuration of the other nodes in the cluster needs to be updated so that they are aware of them. This would require you to restart the old nodes adapting the `REPMGR_PARTNER_NODES` environment variable. You also need to restart the Pgpoll instance adapting the `PGPOOL_BACKEND_NODES` environment variable.

With Docker Compose the HA PostgreSQL cluster can be setup using the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-pgpool/blob/master/docker-compose.yml) file present in this repository:

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-pgpool/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

## Initializing with custom scripts

**Everytime the container is started**, it will execute the files with extension `.sh` located at `/docker-entrypoint-initdb.d` after initializing Pgpool.

In order to have your custom files inside the docker image you can mount them as a volume. With docker-compose:

```diff
     image: bitnami/pgpool:4
     ports:
       - 5432:5432
+    volumes:
+      - /path/to/init-scripts:/docker-entrypoint-initdb.d
     environment:
       - PGPOOL_BACKEND_NODES=0:pg-0:5432,1:pg-1:5432
       - PGPOOL_SR_CHECK_USER=customuser
```

## Securing Pgpool traffic

Pgpool supports the encryption of connections using the SSL/TLS protocol. Should you desire to enable this optional feature, you may use the following environment variables to configure the application:

 - `PGPOOL_ENABLE_TLS`: Whether to enable TLS for traffic or not. Defaults to `no`.
 - `PGPOOL_TLS_CERT_FILE`: File containing the certificate file for the TLS traffic. No defaults.
 - `PGPOOL_TLS_KEY_FILE`: File containing the key for certificate. No defaults.
 - `PGPOOL_TLS_CA_FILE`: File containing the CA of the certificate. If provided, Pgpool will authenticate TLS/SSL clients by requesting them a certificate (see [ref](https://www.pgpool.net/docs/latest/en/html/runtime-ssl.html)). No defaults.
 - `PGPOOL_TLS_PREFER_SERVER_CIPHERS`: Whether to use the server's TLS cipher preferences rather than the client's. Defaults to `yes`.

When enabling TLS, Pgpool will support both standard and encrypted traffic by default, but prefer the latter. Below there are some examples on how to quickly set up TLS traffic:

1. Using `docker run`

    ```console
    $ docker run \
        -v /path/to/certs:/opt/bitnami/pgpool/certs \
        -e ALLOW_EMPTY_PASSWORD=yes \
        -e PGPOOL_ENABLE_TLS=yes \
        -e PGPOOL_TLS_CERT_FILE=/opt/bitnami/pgpool/certs/postgres.crt \
        -e PGPOOL_TLS_KEY_FILE=/opt/bitnami/pgpool/certs/postgres.key \
        bitnami/pgpool:latest
    ```

2. Modifying the `docker-compose.yml` file present in this repository:

    ```yaml
    services:
      pgpool:
      ...
        environment:
          ...
          - PGPOOL_ENABLE_TLS=yes
          - PGPOOL_TLS_CERT_FILE=/opt/bitnami/pgpool/certs/postgres.crt
          - PGPOOL_TLS_KEY_FILE=/opt/bitnami/pgpool/certs/postgres.key
        ...
        volumes:
          ...
          - /path/to/certs:/opt/bitnami/pgpool/certs
      ...
    ```

Alternatively, you may also provide this configuration in your [custom](https://github.com/bitnami/bitnami-docker-pgpool#configuration-file) configuration file.

## Configuration file

You can override the default configuration by providing a configuration file. Set `PGPOOL_USER_CONF_FILE` with the path of the file, and this will be added to the default configuration.

## Step 1: Generate the configuration file.

```console
$ cat myconf.conf
max_pool='300'
```

### Step 2: Run the Pgpool image

Run the Pgpool image, mounting a directory from your host and setting `PGPOOL_USER_CONF_FILE`. Using Docker Compose:

```diff
     image: bitnami/pgpool:4
     ports:
       - 5432:5432
+    volumes:
+      - /path/to/myconf.conf:/config/myconf.conf
     environment:
+      - PGPOOL_USER_CONF_FILE=/config/myconf.conf
       - PGPOOL_BACKEND_NODES=0:pg-0:5432,1:pg-1:5432
       - PGPOOL_SR_CHECK_USER=customuser
```

### Step 3: Start Pgpool

Start your Pgpool container for changes to take effect.

```console
$ docker restart pgpool
```

or using Docker Compose:

```console
$ docker-compose restart pgpool
```

Refer to the [server configuration](http://www.pgpool.net/docs/latest/en/html/runtime-config.html) manual for the complete list of configuration options.

## Re-attaching nodes

Pgpool does not reattach nodes automatically, to reattach a node you have to get the `id` of the node and then run the attach command manually.

### Step 1: Get the node id

To get the node `id` first connect to the pgpool container and open a psql session:

```console
$ docker exec -it pgpool bash

$ PGPASSWORD=$PGPOOL_POSTGRES_PASSWORD psql -U $PGPOOL_POSTGRES_USERNAME -h localhost
```

and run: `show pool_nodes;`

```console
postgres=# show pool_nodes;
 node_id | hostname | port | status | lb_weight |  role   | select_cnt | load_balance_node | replication_delay | replication_state | replication_sync_state | last_status_change
---------+----------+------+--------+-----------+---------+------------+-------------------+-------------------+-------------------+------------------------+---------------------
 0       | pg-0     | 5432 | down     | 0.500000  | standby | 0          | true              | 0                 |                   |                        | 2020-07-09 15:50:41
 1       | pg-1     | 5432 | up       | 0.500000  | primary | 0          | false             | 0                 |                   |                        | 2020-07-09 15:48:31
(2 rows)
```

In this example pg-0 is the node we want to reattach, we will use node `0`.

### Step 2: reattach the node.

Now exit psql console and run the following command, `0` is the node id we got in the previous step.

```console
$ pcp_attach_node -h localhost -U $PGPOOL_ADMIN_USERNAME 0
```

This command will prompt for a password, this password is the one set in the environment variable: `PGPOOL_ADMIN_PASSWORD`

## Environment variables

Please see the list of environment variables available in the Bitnami Pgpool container in the next table:

| Environment Variable                | Default value |
|:------------------------------------|:--------------|
| PGPOOL_BACKEND_NODES                | `nil`         |
| PGPOOL_PORT_NUMBER                  | `5432`        |
| PGPOOL_SR_CHECK_USER                | `nil`         |
| PGPOOL_SR_CHECK_PASSWORD            | `nil`         |
| PGPOOL_SR_CHECK_PASSWORD_FILE       | `nil`         |
| PGPOOL_POSTGRES_USERNAME            | `nil`         |
| PGPOOL_POSTGRES_PASSWORD            | `nil`         |
| PGPOOL_PASSWORD_FILE                | `nil`         |
| PGPOOL_TIMEOUT                      | `360`         |
| PGPOOL_ENABLE_LDAP                  | `no`          |
| PGPOOL_ADMIN_USERNAME=admin         | `nil`         |
| PGPOOL_ADMIN_PASSWORD=adminpassword | `nil`         |
| PGPOOL_ENABLE_LOAD_BALANCING        | `yes`         |
| PGPOOL_ENABLE_POOL_HBA              | `yes`         |
| PGPOOL_ENABLE_POOL_PASSWD           | `yes`         |
| PGPOOL_PASSWD_FILE                  | `pool_passwd` |
| PGPOOL_MAX_POOL                     | `15`          |
| PGPOOL_NUM_INIT_CHILDREN            | `32`          |
| PGPOOL_POSTGRES_CUSTOM_USERS        | nil           |
| PGPOOL_POSTGRES_CUSTOM_PASSWORDS    | nil           |

# Logging

The Bitnami Pgpool-II Docker image sends the container logs to `stdout`. To view the logs:

```console
$ docker logs pgpool
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of Pgpool-II, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```console
$ docker pull bitnami/pgpool:latest
```

### Step 2: Stop the running container

Stop the currently running container using the command

```console
$ docker-compose stop pgpool
```

### Step 3: Remove the currently running container

```console
$ docker-compose rm -v pgpool
```

### Step 4: Run the new image

Re-create your container from the new image.

```console
$ docker-compose up pgpool
```

# Notable Changes

## 4.1.1-debian-10-r35

- The Pgpool container has been migrated to a "non-root" user approach. Previously the container ran as the `root` user and the Pgpool daemon was started as the `pgpool` user. From now on, both the container and the Pgpool daemon run as user `1001`. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.
- No backwards compatibility issues are expected.
- Environment variables related to LDAP configuration were renamed removing the `PGPOOL_` prefix. For instance, to indicate the LDAP URI to use, you must set `LDAP_URI` instead of `PGPOOL_LDAP_URI`.

## 4.1.0-centos-7-r8

- `4.1.0-centos-7-r8` is considered the latest image based on CentOS.
- Standard supported distros: Debian & OEL.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-pgpool/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-pgpool/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-pgpool/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container
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
