# Bitnami package for Pgpool-II

## What is Pgpool-II?

> Pgpool-II is the PostgreSQL proxy. It stands between PostgreSQL servers and their clients providing connection pooling, load balancing, automated failover, and replication.

[Overview of Pgpool-II](https://pgpool.net/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

### Docker Compose

```console
docker run --name pgpool bitnami/pgpool:latest
```

You can find the default credentials and available configuration options in the [Environment Variables](#environment-variables) section.

## ⚠️ Important Notice: Upcoming changes to the Bitnami Catalog

Beginning August 28th, 2025, Bitnami will evolve its public catalog to offer a curated set of hardened, security-focused images under the new [Bitnami Secure Images initiative](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications). As part of this transition:

- Granting community users access for the first time to security-optimized versions of popular container images.
- Bitnami will begin deprecating support for non-hardened, Debian-based software images in its free tier and will gradually remove non-latest tags from the public catalog. As a result, community users will have access to a reduced number of hardened images. These images are published only under the “latest” tag and are intended for development purposes
- Starting August 28th, over two weeks, all existing container images, including older or versioned tags (e.g., 2.50.0, 10.6), will be migrated from the public catalog (docker.io/bitnami) to the “Bitnami Legacy” repository (docker.io/bitnamilegacy), where they will no longer receive updates.
- For production workloads and long-term support, users are encouraged to adopt Bitnami Secure Images, which include hardened containers, smaller attack surfaces, CVE transparency (via VEX/KEV), SBOMs, and enterprise support.

These changes aim to improve the security posture of all Bitnami users by promoting best practices for software supply chain integrity and up-to-date deployments. For more details, visit the [Bitnami Secure Images announcement](https://github.com/bitnami/containers/issues/83267).

## Why use Bitnami Secure Images?

- Bitnami Secure Images and Helm charts are built to make open source more secure and enterprise ready.
- Triage security vulnerabilities faster, with transparency into CVE risks using industry standard Vulnerability Exploitability Exchange (VEX), KEV, and EPSS scores.
- Our hardened images use a minimal OS (Photon Linux), which reduces the attack surface while maintaining extensibility through the use of an industry standard package format.
- Stay more secure and compliant with continuously built images updated within hours of upstream patches.
- Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
- Hardened images come with attestation signatures (Notation), SBOMs, virus scan reports and other metadata produced in an SLSA-3 compliant software factory.

Only a subset of BSI applications are available for free. Looking to access the entire catalog of applications as well as enterprise support? Try the [commercial edition of Bitnami Secure Images today](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/).

## How to deploy Pgpool-II in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami PostgreSQL HA Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/postgresql-ha).

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami Pgpool-II Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/pgpool).

```console
docker pull bitnami/pgpool:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/pgpool/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/pgpool:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

In this example, we will create a PostgreSQL client instance that will connect to the pgpool instance that is running on the same docker network as the client.

#### Step 1: Create a network

```console
docker network create my-network --driver bridge
```

#### Step 2: Launch 2 postgresql-repmgr containers to be used as backend within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `my-network` network.

```console
docker run --detach --rm --name pg-0 \
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
docker run --detach --rm --name pg-1 \
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

#### Step 3: Launch the pgpool container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `my-network` network.

```console
docker run --detach --rm --name pgpool \
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

#### Step 4: Launch your PostgreSQL client instance

Finally we create a new container instance to launch the PostgreSQL client and connect to the server created in the previous step:

```console
docker run -it --rm \
  --network my-network \
  bitnami/postgresql:latest \
  psql -h pgpool -U customuser -d customdatabase
```

### Using a Docker Compose file

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `my-network`. In this example we assume that you want to connect to the Pgpool-II server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  my-network:
    driver: bridge
services:
  pg-0:
    image: bitnami/postgresql-repmgr:latest
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
    image: bitnami/postgresql-repmgr:latest
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
    image: bitnami/pgpool:latest
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
    image: YOUR_APPLICATION_IMAGE
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
docker-compose up -d
```

## Configuration

### Setting up a HA PostgreSQL cluster with Pgpool-II, streaming replication and repmgr

A HA PostgreSQL cluster with Pgpool-II, [Streaming replication](https://www.postgresql.org/docs/10/warm-standby.html#STREAMING-REPLICATION) and [repmgr](https://repmgr.org) can easily be setup with the Bitnami PostgreSQL with Replication Manager and Pgpool-II container images.
In a HA PostgreSQL cluster you can have one primary and zero or more standby nodes. The primary node is in read-write mode, while the standby nodes are in read-only mode. For best performance its advisable to limit the reads to the standby nodes.

#### Step 1: Create a network and the initial primary node

The first step is to start the initial primary node:

```console
docker network create my-network --driver bridge
docker run --detach --name pg-0 \
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

#### Step 2: Create a standby node

Next we start a standby node:

```console
docker run --detach --name pg-1 \
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

#### Step 3: Create the pgpool instance

```console
docker run --detach --rm --name pgpool \
  --network my-network \
  --env PGPOOL_BACKEND_NODES=0:pg-0:5432,1:pg-1:5432 \
  --env PGPOOL_SR_CHECK_USER=postgres \
  --env PGPOOL_SR_CHECK_PASSWORD=adminpassword \
  --env PGPOOL_ENABLE_LDAP=no \
  --env PGPOOL_USERNAME=customuser \
  --env PGPOOL_PASSWORD=custompassword \
  bitnami/pgpool:latest
```

With these three commands you now have a two node PostgreSQL primary-standby streaming replication cluster using Pgpool-II as proxy up and running. You can scale the cluster by adding/removing standby nodes without incurring any downtime.

> **Note**: The cluster replicates the primary in its entirety, which includes all users and databases.

If the master goes down, **repmgr** will ensure any of the standby nodes takes the primary role, guaranteeing high availability.

> **Note**: The configuration of the other nodes in the cluster needs to be updated so that they are aware of them. This would require you to restart the old nodes adapting the `REPMGR_PARTNER_NODES` environment variable. You also need to restart the Pgpoll instance adapting the `PGPOOL_BACKEND_NODES` environment variable.

With Docker Compose the HA PostgreSQL cluster can be setup using the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/pgpool/docker-compose.yml) file present in this repository:

```console
curl -sSL https://raw.githubusercontent.com/bitnami/containers/main/bitnami/pgpool/docker-compose.yml > docker-compose.yml
docker-compose up -d
```

### Initializing with custom scripts

**Everytime the container is started**, it will execute the files with extension `.sh` located at `/docker-entrypoint-initdb.d` after initializing Pgpool-II.

In order to have your custom files inside the docker image you can mount them as a volume. With docker-compose:

```diff
     image: bitnami/pgpool:latest
     ports:
       - 5432:5432
+    volumes:
+      - /path/to/init-scripts:/docker-entrypoint-initdb.d
     environment:
       - PGPOOL_BACKEND_NODES=0:pg-0:5432,1:pg-1:5432
       - PGPOOL_SR_CHECK_USER=customuser
```

### Securing Pgpool-II traffic

Pgpool-II supports the encryption of connections using the SSL/TLS protocol. Should you desire to enable this optional feature, you may use the following environment variables to configure the application:

- `PGPOOL_ENABLE_TLS`: Whether to enable TLS for traffic or not. Defaults to `no`.
- `PGPOOL_TLS_CERT_FILE`: File containing the certificate file for the TLS traffic. No defaults.
- `PGPOOL_TLS_KEY_FILE`: File containing the key for certificate. No defaults.
- `PGPOOL_TLS_CA_FILE`: File containing the CA of the certificate. If provided, Pgpool-II will authenticate TLS/SSL clients by requesting them a certificate (see [ref](https://www.pgpool.net/docs/latest/en/html/runtime-ssl.html)). No defaults.
- `PGPOOL_TLS_PREFER_SERVER_CIPHERS`: Whether to use the server's TLS cipher preferences rather than the client's. Defaults to `yes`.

When enabling TLS, Pgpool-II will support both standard and encrypted traffic by default, but prefer the latter. Below there are some examples on how to quickly set up TLS traffic:

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

Alternatively, you may also provide this configuration in your [custom](https://github.com/bitnami/containers/blob/main/bitnami/pgpool#configuration-file) configuration file.

### Configuration file

You can override the default configuration by providing a configuration file. Set `PGPOOL_USER_CONF_FILE` with the path of the file, and this will be added to the default configuration.
You can override the default hba configuration by providing a hba configuration file. Set `PGPOOL_USER_HBA_FILE` with the path of the file, and this will overwrite the default hba configuration.

### Step 1: Generate the configuration file

```console
$ cat myconf.conf
max_pool='300'
```

#### Step 2: Run the Pgpool-II image

Run the Pgpool-II image, mounting a directory from your host and setting `PGPOOL_USER_CONF_FILE` and `PGPOOL_USER_HBA_FILE`. Using Docker Compose:

```diff
     image: bitnami/pgpool:latest
     ports:
       - 5432:5432
+    volumes:
+      - /path/to/myconf.conf:/config/myconf.conf
+      - /path/to/myhbaconf.conf:/config/myhbaconf.conf
     environment:
+      - PGPOOL_USER_CONF_FILE=/config/myconf.conf
+      - PGPOOL_USER_HBA_FILE=/config/myhbaconf.conf
       - PGPOOL_BACKEND_NODES=0:pg-0:5432,1:pg-1:5432
       - PGPOOL_SR_CHECK_USER=customuser
```

#### Step 3: Start Pgpool-II

Start your Pgpool-II container for changes to take effect.

```console
docker restart pgpool
```

or using Docker Compose:

```console
docker-compose restart pgpool
```

Refer to the [server configuration](http://www.pgpool.net/docs/latest/en/html/runtime-config.html) manual for the complete list of configuration options.

### Re-attaching nodes

Pgpool-II does not reattach nodes automatically, to reattach a node you have to get the `id` of the node and then run the attach command manually.

#### Step 1: Get the node id

To get the node `id` first connect to the pgpool container and open a psql session:

```console
docker exec -it pgpool bash

PGPASSWORD=$PGPOOL_POSTGRES_PASSWORD psql -U $PGPOOL_POSTGRES_USERNAME -h localhost
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

#### Step 2: reattach the node

Now exit psql console and run the following command, `0` is the node id we got in the previous step.

```console
pcp_attach_node -h localhost -U $PGPOOL_ADMIN_USERNAME 0
```

This command will prompt for a password, this password is the one set in the environment variable: `PGPOOL_ADMIN_PASSWORD`

### Environment variables

#### Customizable environment variables

| Name                                     | Description                                                                                                                        | Default Value                       |
|------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------|
| `PGPOOL_USER_CONF_FILE`                  | Custom Pgpool-II configuration file to be appended at Pgpool-II configuration file.                                                | `nil`                               |
| `PGPOOL_USER_HBA_FILE`                   | Custom Pgpool-II host-based authentication configuration to be appended to Pgpool-II host-based authentication configuration file. | `nil`                               |
| `PGPOOL_PASSWD_FILE`                     | Pgpool-II pool password file.                                                                                                      | `pool_passwd`                       |
| `PGPOOL_PORT_NUMBER`                     | Pgpool-II port number.                                                                                                             | `5432`                              |
| `PGPOOL_ENABLE_POOL_HBA`                 | Enable Pgpool-II host-based authentication.                                                                                        | `yes`                               |
| `PGPOOL_ENABLE_POOL_PASSWD`              | Enable Pgpool-II pool password.                                                                                                    | `yes`                               |
| `PGPOOL_ENABLE_LOAD_BALANCING`           | Enable Load-Balancing.                                                                                                             | `yes`                               |
| `PGPOOL_ENABLE_STATEMENT_LOAD_BALANCING` | Enable Statement Load-Balancing.                                                                                                   | `no`                                |
| `PGPOOL_DISABLE_LOAD_BALANCE_ON_WRITE`   | Disable Load-Balancing on write queries.                                                                                           | `transaction`                       |
| `PGPOOL_ENABLE_CONNECTION_CACHE`         | Enable Pgpool-II connection cache.                                                                                                 | `yes`                               |
| `PGPOOL_TIMEOUT`                         | Pgpool-II timeout (in seconds).                                                                                                    | `360`                               |
| `PGPOOL_CONNECT_TIMEOUT`                 | Pgpool-II connection timeout (in milliseconds).                                                                                    | `10000`                             |
| `PGPOOL_MAX_POOL`                        | Pgpool-II maximum number of cached connections.                                                                                    | `15`                                |
| `PGPOOL_HEALTH_CHECK_PERIOD`             | Pgpool-II Health Check period (in seconds).                                                                                        | `30`                                |
| `PGPOOL_HEALTH_CHECK_TIMEOUT`            | Pgpool-II Health Check timeout (in seconds).                                                                                       | `10`                                |
| `PGPOOL_HEALTH_CHECK_MAX_RETRIES`        | Pgpool-II Health Check max retries.                                                                                                | `5`                                 |
| `PGPOOL_HEALTH_CHECK_RETRY_DELAY`        | Pgpool-II Health Check retry delay (in seconds).                                                                                   | `5`                                 |
| `PGPOOL_HEALTH_CHECK_PSQL_TIMEOUT`       | Pgpool-II Health Check psql timeout (in seconds).                                                                                  | `15`                                |
| `PGPOOL_AUTO_FAILBACK`                   | Enable Pgpool-II auto_failback on false primaries detection.                                                                       | `no`                                |
| `PGPOOL_DISCARD_STATUS`                  | Discard Pgpool-II status file on restarts.                                                                                         | `yes`                               |
| `PGPOOL_SR_CHECK_USER`                   | Pgpool-II Streaming Replication Check username.                                                                                    | `nil`                               |
| `PGPOOL_SR_CHECK_PASSWORD`               | Pgpool-II Streaming Replication Check password.                                                                                    | `nil`                               |
| `PGPOOL_SR_CHECK_DATABASE`               | Pgpool-II Streaming Replication Check database.                                                                                    | `postgres`                          |
| `PGPOOL_SR_CHECK_PERIOD`                 | Pgpool-II Streaming Replication Check period (in seconds).                                                                         | `30`                                |
| `PGPOOL_HEALTH_CHECK_USER`               | Pgpool-II Health Check username.                                                                                                   | `$PGPOOL_SR_CHECK_USER`             |
| `PGPOOL_HEALTH_CHECK_PASSWORD`           | Pgpool-II Health Check password.                                                                                                   | `$PGPOOL_SR_CHECK_PASSWORD`         |
| `PGPOOL_ADMIN_USERNAME`                  | Pgpool-II Admin username.                                                                                                          | `nil`                               |
| `PGPOOL_ADMIN_PASSWORD`                  | Pgpool-II Admin password.                                                                                                          | `nil`                               |
| `PGPOOL_POSTGRES_USERNAME`               | PostgreSQL backend admin username.                                                                                                 | `postgres`                          |
| `PGPOOL_POSTGRES_PASSWORD`               | PostgreSQL backend admin password.                                                                                                 | `nil`                               |
| `PGPOOL_POSTGRES_CUSTOM_USERS`           | Comma, semi-colon or space separated list of custom users to create.                                                               | `nil`                               |
| `PGPOOL_POSTGRES_CUSTOM_PASSWORDS`       | Comma, semi-colon or space separated list of passwords for the custom users to create.                                             | `nil`                               |
| `PGPOOL_ENABLE_LDAP`                     | Enable LDAP on Pgpool-II.                                                                                                          | `no`                                |
| `PGPOOL_AUTHENTICATION_METHOD`           | Pgpool-II authentication method.                                                                                                   | `scram-sha-256`                     |
| `PGPOOL_AES_KEY`                         | Pgpool-II AES key.                                                                                                                 | `head -c 20 /dev/urandom \| base64` |
| `PGPOOL_ENABLE_TLS`                      | Enable TLS on Pgpool-II.                                                                                                           | `no`                                |
| `PGPOOL_TLS_CA_FILE`                     | Pgpool-II TLS authentication CA file.                                                                                              | `nil`                               |
| `PGPOOL_TLS_CERT_FILE`                   | Pgpool-II TLS authentication cert file.                                                                                            | `nil`                               |
| `PGPOOL_TLS_KEY_FILE`                    | Pgpool-II TLS authentication key file.                                                                                             | `nil`                               |
| `PGPOOL_TLS_PREFER_SERVER_CIPHERS`       | Prefer server TLS authentication ciphers.                                                                                          | `yes`                               |
| `PGPOOL_ENABLE_LOG_CONNECTIONS`          | Enable Pgpool-II log connections                                                                                                   | `no`                                |
| `PGPOOL_ENABLE_LOG_HOSTNAME`             | Show clients hostnames on Pgpool-II connections logs.                                                                              | `no`                                |
| `PGPOOL_ENABLE_LOG_PCP_PROCESSES`        | Enable PCP processes logging.                                                                                                      | `yes`                               |
| `PGPOOL_ENABLE_LOG_PER_NODE_STATEMENT`   | Enable logging every SQL statement for each DB node separately.                                                                    | `no`                                |
| `PGPOOL_BACKEND_NODES`                   | Comma, semi-colon or space separated list of PostgreSQL backend nodes.                                                             | `nil`                               |
| `PGPOOL_BACKEND_APPLICATION_NAMES`       | Comma, semi-colon or space separated list of PostgreSQL backend application names.                                                 | `nil`                               |
| `PGPOOL_FAILOVER_ON_BACKEND_SHUTDOWN`    | Enable failover recovery on backend shutdown.                                                                                      | `on`                                |
| `PGPOOL_FAILOVER_ON_BACKEND_ERROR`       | Enable failover recovery on backend error.                                                                                         | `off`                               |
| `PGPOOL_DAEMON_USER`                     | Pgpool-II daemon user                                                                                                              | `pgpool`                            |
| `PGPOOL_DAEMON_GROUP`                    | Pgpool-II daemon group                                                                                                             | `pgpool`                            |

#### Read-only environment variables

| Name                      | Description                                             | Value                              |
|---------------------------|---------------------------------------------------------|------------------------------------|
| `PGPOOL_BASE_DIR`         | Pgpool-II installation directory.                       | `${BITNAMI_ROOT_DIR}/pgpool`       |
| `PGPOOL_BIN_DIR`          | Pgpool-II binaries directory.                           | `${PGPOOL_BASE_DIR}/bin`           |
| `PGPOOL_DATA_DIR`         | Pgpool-II data directory.                               | `${PGPOOL_BASE_DIR}/data`          |
| `PGPOOL_DEFAULT_CONF_DIR` | Pgpool-II default configuration directory.              | `${PGPOOL_BASE_DIR}/conf.default`  |
| `PGPOOL_CONF_DIR`         | Pgpool-II configuration directory.                      | `${PGPOOL_BASE_DIR}/conf`          |
| `PGPOOL_DEFAULT_ETC_DIR`  | Pgpool-II default etc directory.                        | `${PGPOOL_BASE_DIR}/etc.default`   |
| `PGPOOL_ETC_DIR`          | Pgpool-II etc directory.                                | `${PGPOOL_BASE_DIR}/etc`           |
| `PGPOOL_LOG_DIR`          | Pgpool-II logs directory.                               | `${PGPOOL_BASE_DIR}/logs`          |
| `PGPOOL_TMP_DIR`          | Pgpool-II temporary directory.                          | `${PGPOOL_BASE_DIR}/tmp`           |
| `PGPOOL_INITSCRIPTS_DIR`  | Pgpool-II init scripts directory.                       | `/docker-entrypoint-initdb.d`      |
| `PGPOOL_CONF_FILE`        | Pgpool-II configuration file.                           | `${PGPOOL_CONF_DIR}/pgpool.conf`   |
| `PGPOOL_PCP_CONF_FILE`    | Performance Co-Pilot (PCP) configuration file.          | `${PGPOOL_ETC_DIR}/pcp.conf`       |
| `PGPOOL_PGHBA_FILE`       | Pgpool-II host-based authentication configuration file. | `${PGPOOL_CONF_DIR}/pool_hba.conf` |
| `PGPOOL_LOG_FILE`         | Pgpool-II log file.                                     | `${PGPOOL_LOG_DIR}/pgpool.log`     |
| `PGPOOL_PID_FILE`         | Pgpool-II pid file.                                     | `${PGPOOL_TMP_DIR}/pgpool.pid`     |
| `PGPOOLKEYFILE`           | Pgpool-II pool key file.                                | `${PGPOOL_CONF_DIR}/.pgpoolkey`    |

### FIPS configuration in Bitnami Secure Images

The Bitnami Pgpool-II Docker image from the [Bitnami Secure Images](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Logging

The Bitnami Pgpool-II Docker image sends the container logs to `stdout`. To view the logs:

```console
docker logs pgpool
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of Pgpool-II, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/pgpool:latest
```

#### Step 2: Stop the running container

Stop the currently running container using the command

```console
docker-compose stop pgpool
```

#### Step 3: Remove the currently running container

```console
docker-compose rm -v pgpool
```

#### Step 4: Run the new image

Re-create your container from the new image.

```console
docker-compose up pgpool
```

## Notable Changes

### 4.3.1-debian-10-r67

- The ENV `PGPOOL_AUTHENTICATION_METHOD` default value has been changed from `md5` to `scram-sha-256` as our `bitnami/postgresql-repmgr:latest` image now uses PSQL v14, which has `scram-sha-256` as the default auth method.

### 4.1.1-debian-10-r35

- The Pgpool container has been migrated to a "non-root" user approach. Previously the container ran as the `root` user and the Pgpool daemon was started as the `pgpool` user. From now on, both the container and the Pgpool daemon run as user `1001`. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.
- No backwards compatibility issues are expected.
- Environment variables related to LDAP configuration were renamed removing the `PGPOOL_` prefix. For instance, to indicate the LDAP URI to use, you must set `LDAP_URI` instead of `PGPOOL_LDAP_URI`.

### 4.1.0-centos-7-r8

- `4.1.0-centos-7-r8` is considered the latest image based on CentOS.
- Standard supported distros: Debian & OEL.

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes.

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
