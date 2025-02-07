# Bitnami package for KeyDB

## What is KeyDB?

> KeyDB is a high performance fork of Redis with a focus on multithreading, memory efficiency, and high throughput.

[Overview of KeyDB](https://github.com/Snapchat/KeyDB)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name keydb -e ALLOW_EMPTY_PASSWORD=yes bitnami/keydb:latest
```

**Warning**: These quick setups are only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options in the [Configuration](#configuration) section for a more secure deployment.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use KeyDB in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

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

The recommended way to get the Bitnami KeyDB Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/keydb).

```console
docker pull bitnami/keydb:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/keydb/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/keydb:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Persisting your database

KeyDB provides a different range of [persistence options](https://keydb.io/docs/topics/persistence.html). This contanier uses *AOF persistence by default* but it is easy to overwrite that configuration in a `docker-compose.yaml` file with this entry `command: /opt/bitnami/scripts/keydb/run.sh --appendonly no`. Alternatively, you may use the `KEYDB_AOF_ENABLED` env variable as explained in [Disabling AOF persistence](https://github.com/bitnami/containers/blob/main/bitnami/keydb#disabling-aof-persistence).

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami` path. If the mounted directory is empty, it will be initialized on the first run.

```console
docker run \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -v /path/to/keydb-persistence:/bitnami/keydb/data \
    bitnami/keydb:latest
```

You can also do this by modifying the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/keydb/docker-compose.yml) file present in this repository:

```yaml
services:
  keydb:
  ...
    volumes:
      - /path/to/keydb-persistence:/bitnami/keydb/data
  ...
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a KeyDB server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

In this example, we will create a KeyDB client instance that will connect to the server instance that is running on the same docker network as the client.

#### Step 1: Create a network

```console
docker network create app-tier --driver bridge
```

#### Step 2: Launch the KeyDB server instance

Use the `--network app-tier` argument to the `docker run` command to attach the KeyDB container to the `app-tier` network.

```console
docker run -d --name keydb-server \
    -e ALLOW_EMPTY_PASSWORD=yes \
    --network app-tier \
    bitnami/keydb:latest
```

#### Step 3: Launch your KeyDB client instance

Finally we create a new container instance to launch the KeyDB client and connect to the server created in the previous step:

```console
docker run -it --rm \
    --network app-tier \
    bitnami/keydb:latest keydb-cli -h keydb-server
```

### Using a Docker Compose file

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `app-tier`. In this example we assume that you want to connect to the KeyDB server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge

services:
  keydb:
    image: 'bitnami/keydb:latest'
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
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
> 2. In your application container, use the hostname `keydb` to connect to the KeyDB server

Launch the containers using:

```console
docker-compose up -d
```

## Configuration

### Environment variables

#### Customizable environment variables

| Name                             | Description                                                                         | Default Value                              |
|----------------------------------|-------------------------------------------------------------------------------------|--------------------------------------------|
| `KEYDB_DATA_DIR`                 | KeyDB data directory.                                                               | `${KEYDB_VOLUME_DIR}/data`                 |
| `KEYDB_OVERRIDES_FILE`           | KeyDB config overrides file.                                                        | `${KEYDB_MOUNTED_CONF_DIR}/overrides.conf` |
| `KEYDB_DISABLE_COMMANDS`         | Commands to disable.                                                                | `nil`                                      |
| `KEYDB_DATABASE`                 | Default database.                                                                   | `keydb`                                    |
| `KEYDB_AOF_ENABLED`              | Enable AOF.                                                                         | `yes`                                      |
| `KEYDB_RDB_POLICY`               | Enable RDB policy persistence.                                                      | `nil`                                      |
| `KEYDB_RDB_POLICY_DISABLED`      | Allows to enable RDB policy persistence.                                            | `no`                                       |
| `KEYDB_PORT_NUMBER`              | KeyDB port number.                                                                  | `$KEYDB_DEFAULT_PORT_NUMBER`               |
| `KEYDB_ALLOW_REMOTE_CONNECTIONS` | Allow remote connection to the service.                                             | `yes`                                      |
| `KEYDB_EXTRA_FLAGS`              | Additional flags pass to 'keydb-server' command.                                    | `nil`                                      |
| `ALLOW_EMPTY_PASSWORD`           | Allow password-less access.                                                         | `no`                                       |
| `KEYDB_PASSWORD`                 | KeyDB password.                                                                     | `nil`                                      |
| `KEYDB_ACL_FILE`                 | KeyDB ACL file.                                                                     | `nil`                                      |
| `KEYDB_IO_THREADS_DO_READS`      | Enable multithreading when reading socket.                                          | `nil`                                      |
| `KEYDB_IO_THREADS`               | Number of threads.                                                                  | `nil`                                      |
| `KEYDB_REPLICATION_MODE`         | Replication mode (values: master, replica).                                         | `nil`                                      |
| `KEYDB_ACTIVE_REPLICA`           | Configure KeyDB node as active-replica.                                             | `no`                                       |
| `KEYDB_MASTER_HOSTS`             | Comma separated list of hostnames of the KeyDB master instances to be a replica of. | `nil`                                      |
| `KEYDB_MASTER_PORT_NUMBER`       | Port number of the KeyDB master instances to be a replica of.                       | `6379`                                     |
| `KEYDB_MASTER_PASSWORD`          | Password to authenticate against the KeyDB master instance to be a replica of.      | `nil`                                      |
| `KEYDB_REPLICA_IP`               | The replication announce ip.                                                        | `nil`                                      |
| `KEYDB_REPLICA_PORT`             | The replication announce port.                                                      | `nil`                                      |
| `KEYDB_TLS_ENABLED`              | Enable TLS                                                                          | `no`                                       |
| `KEYDB_TLS_PORT_NUMBER`          | TLS port number.                                                                    | `6379`                                     |
| `KEYDB_TLS_CERT_FILE`            | TLS certificate file.                                                               | `nil`                                      |
| `KEYDB_TLS_CA_DIR`               | Directory containing TLS CA certificates.                                           | `nil`                                      |
| `KEYDB_TLS_KEY_FILE`             | TLS key file.                                                                       | `nil`                                      |
| `KEYDB_TLS_KEY_FILE_PASS`        | TLS key file passphrase.                                                            | `nil`                                      |
| `KEYDB_TLS_CA_FILE`              | TLS CA file.                                                                        | `nil`                                      |
| `KEYDB_TLS_DH_PARAMS_FILE`       | TLS DH parameter file.                                                              | `nil`                                      |
| `KEYDB_TLS_AUTH_CLIENTS`         | Enable TLS client authentication.                                                   | `yes`                                      |

#### Read-only environment variables

| Name                        | Description                            | Value                           |
|-----------------------------|----------------------------------------|---------------------------------|
| `KEYDB_VOLUME_DIR`          | KeyDB persistence base directory.      | `/bitnami/keydb`                |
| `KEYDB_BASE_DIR`            | KeyDB installation directory.          | `${BITNAMI_ROOT_DIR}/keydb`     |
| `KEYDB_CONF_DIR`            | KeyDB configuration directory.         | `${KEYDB_BASE_DIR}/etc`         |
| `KEYDB_DEFAULT_CONF_DIR`    | KeyDB default configuration directory. | `${KEYDB_BASE_DIR}/etc.default` |
| `KEYDB_MOUNTED_CONF_DIR`    | KeyDB mounted configuration directory. | `${KEYDB_BASE_DIR}/mounted-etc` |
| `KEYDB_CONF_FILE`           | KeyDB configuration file.              | `${KEYDB_CONF_DIR}/keydb.conf`  |
| `KEYDB_TMP_DIR`             | KeyDB temporary directory.             | `${KEYDB_BASE_DIR}/tmp`         |
| `KEYDB_PID_FILE`            | KeyDB PID file.                        | `${KEYDB_TMP_DIR}/keydb.pid`    |
| `KEYDB_BIN_DIR`             | KeyDB executables directory.           | `${KEYDB_BASE_DIR}/bin`         |
| `KEYDB_DAEMON_USER`         | KeyDB system user.                     | `keydb`                         |
| `KEYDB_DAEMON_GROUP`        | KeyDB system group.                    | `keydb`                         |
| `KEYDB_DEFAULT_PORT_NUMBER` | KeyDB port number (Build time).        | `6379`                          |

### Disabling KeyDB commands

For security reasons, you may want to disable some commands. You can specify them by using the following environment variable on the first run:

* `KEYDB_DISABLE_COMMANDS`: Comma-separated list of KeyDB commands to disable. Defaults to empty.

```console
docker run --name keydb -e KEYDB_DISABLE_COMMANDS=FLUSHDB,FLUSHALL,CONFIG bitnami/keydb:latest
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/keydb/docker-compose.yml) file present in this repository:

```yaml
services:
  keydb:
  ...
    environment:
      - KEYDB_DISABLE_COMMANDS=FLUSHDB,FLUSHALL,CONFIG
  ...
```

As specified in the docker-compose, `FLUSHDB` and `FLUSHALL` commands are disabled. Comment out or remove the
environment variable if you don't want to disable any commands:

```yaml
services:
  keydb:
  ...
    environment:
      # - KEYDB_DISABLE_COMMANDS=FLUSHDB,FLUSHALL
  ...
```

### Passing extra command-line flags to keydb-server startup

Passing extra command-line flags to the keydb service command is possible by adding them as arguments to *run.sh* script:

```console
docker run --name keydb -e ALLOW_EMPTY_PASSWORD=yes bitnami/keydb:latest /opt/bitnami/scripts/keydb/run.sh --maxmemory 100mb
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/keydb/docker-compose.yml) file present in this repository:

```yaml
services:
  keydb:
  ...
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    command: /opt/bitnami/scripts/keydb/run.sh --maxmemory 100mb
  ...
```

### Setting the server password on first run

Passing the `KEYDB_PASSWORD` environment variable when running the image for the first time will set the KeyDB server password to the value of `KEYDB_PASSWORD` (or the content of the file specified in `KEYDB_PASSWORD_FILE`).

```console
docker run --name keydb -e KEYDB_PASSWORD=password123 bitnami/keydb:latest
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/keydb/docker-compose.yml) file present in this repository:

```yaml
services:
  keydb:
  ...
    environment:
      - KEYDB_PASSWORD=password123
  ...
```

**NOTE**: The at sign (`@`) is not supported for `KEYDB_PASSWORD`.

**Warning** The KeyDB database is always configured with remote access enabled. It's suggested that the `KEYDB_PASSWORD` env variable is always specified to set a password. In case you want to access the database without a password set the environment variable `ALLOW_EMPTY_PASSWORD=yes`. **This is recommended only for development**.

### Allowing empty passwords

By default the KeyDB image expects all the available passwords to be set. In order to allow empty passwords, it is necessary to set the `ALLOW_EMPTY_PASSWORD=yes` env variable. This env variable is only recommended for testing or development purposes. We strongly recommend specifying the `KEYDB_PASSWORD` for any other scenario.

```console
docker run --name keydb -e ALLOW_EMPTY_PASSWORD=yes bitnami/keydb:latest
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/keydb/docker-compose.yml) file present in this repository:

```yaml
services:
  keydb:
  ...
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
  ...
```

### Disabling AOF persistence

KeyDB offers different [options](https://keydb.io/docs/topics/persistence.html) when it comes to persistence. By default, this image is set up to use the AOF (Append Only File) approach. Should you need to change this behaviour, setting the `KEYDB_AOF_ENABLED=no` env variable will disable this feature.

```console
docker run --name keydb -e KEYDB_AOF_ENABLED=no bitnami/keydb:latest
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/keydb/docker-compose.yml) file present in this repository:

```yaml
services:
  keydb:
  ...
    environment:
      - KEYDB_AOF_ENABLED=no
  ...
```

### Enabling Access Control List

KeyDB offers [ACL](https://keydb.io/docs/topics/acl.html) which allows certain connections to be limited in terms of the commands that can be executed and the keys that can be accessed. We strongly recommend enabling ACL in production by specifying the `KEYDB_ACL_FILE`.

```console
docker run -name keydb -e KEYDB_ACL_FILE=/opt/bitnami/keydb/mounted-etc/users.acl -v /path/to/users.acl:/opt/bitnami/keydb/mounted-etc/users.acl bitnami/keydb:latest
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/keydb/docker-compose.yml) file present in this repository:

```yaml
services:
  keydb:
  ...
    environment:
      - KEYDB_ACL_FILE=/opt/bitnami/keydb/mounted-etc/users.acl
    volumes:
      - /path/to/users.acl:/opt/bitnami/keydb/mounted-etc/users.acl
  ...
```

### Setting up a standalone instance

By default, this image is set up to launch KeyDB in standalone mode on port 6379. Should you need to change this behavior, setting the `KEYDB_PORT_NUMBER` environment variable will modify the port number. This is not to be confused with `KEYDB_MASTER_PORT_NUMBER` or `KEYDB_REPLICA_PORT` environment variables that are applicable in replication mode.

```console
docker run --name keydb -e KEYDB_PORT_NUMBER=7000 -p 7000:7000 bitnami/keydb:latest
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/keydb/docker-compose.yml) file present in this repository:

```yaml
services:
  keydb:
  ...
    environment:
      - KEYDB_PORT_NUMBER=7000
    ...
    ports:
      - '7000:7000'
  ....
```

### Setting up replication

A replication cluster can easily be setup with the Bitnami KeyDB Docker Image using the following environment variables:

* `KEYDB_REPLICATION_MODE`: The replication mode. Possible values `master`/`replica`. No defaults.
* `KEYDB_ACTIVE_REPLICA`: Configure Replica node as active-replica. Defaults to `no`.
* `KEYDB_REPLICA_IP`: The replication announce ip. Defaults to `$(get_machine_ip)` which return the ip of the container.
* `KEYDB_REPLICA_PORT`: The replication announce port. Defaults to `KEYDB_MASTER_PORT_NUMBER`.
* `KEYDB_MASTER_HOSTS`: Comma separated list of Hostnames/IPs of KeyDB master instances to be a replica of (multiple hosts only supported if active-replica is enabled). No defaults.
* `KEYDB_MASTER_PORT_NUMBER`: Port number of the KeyDB master instances to be a replica of. Defaults to `6379`.
* `KEYDB_MASTER_PASSWORD`: Password to authenticate against the KeyDB master instances to be a replica of. No defaults.

There are three main architectures for replication in KeyDB:

* **Master/Replica**: In this architecture, a single KeyDB instance acts as the master, and one or more KeyDB instances act as replicas. The master is responsible for all write operations, while the replicas replicate the write operations from the master and serve read operations.
* **Active Replication**: In this architecture, a single KeyDB instance acts as the master, and one or more KeyDB instances act as active replicas. All instances can accept write operations and replicate them to the rest of the instances.
* **Multi Master Replication**: In this architecture, two or more KeyDB instances act as master, and replicas are configured to replicate from multiple masters. A replica with multiple masters will contain a superset of the data of all its masters. If two masters have a value with the same key it is undefined which key will be taken. If a master deletes a key that exists on another master the replica will no longer contain a copy of that key.

#### Step 1: Create the replication master

The first step is to start the KeyDB master.

```console
docker run --name keydb-master \
  -e KEYDB_REPLICATION_MODE=master \
  -e KEYDB_PASSWORD=masterpassword123 \
  bitnami/keydb:latest
```

In the above command the container is configured as the `master` using the `KEYDB_REPLICATION_MODE` parameter. The `KEYDB_PASSWORD` parameter enables authentication on the KeyDB master.

#### Step 2: Create the replica node

Next we start a KeyDB replica container.

```console
docker run --name keydb-replica \
  --link keydb-master:master \
  -e KEYDB_REPLICATION_MODE=replica \
  -e KEYDB_MASTER_HOSTS=master \
  -e KEYDB_MASTER_PORT_NUMBER=6379 \
  -e KEYDB_MASTER_PASSWORD=masterpassword123 \
  -e KEYDB_PASSWORD=password123 \
  bitnami/keydb:latest
```

In the above command the container is configured as a `replica` using the `KEYDB_REPLICATION_MODE` parameter. The `KEYDB_MASTER_HOSTS`, `KEYDB_MASTER_PORT_NUMBER` and `KEYDB_MASTER_PASSWORD` parameters are used connect and authenticate with the KeyDB master. The `KEYDB_PASSWORD` parameter enables authentication on the KeyDB replica.

You now have a two node KeyDB master/replica replication cluster up and running which can be scaled by adding/removing replicas.

If the KeyDB master goes down you can reconfigure a replica to become a master using:

```console
docker exec keydb-replica keydb-cli -a password123 REPLICAOF NO ONE
```

> **Note**: The configuration of the other replicas in the cluster needs to be updated so that they are aware of the new master. In our example, this would involve restarting the other replicas with `--link keydb-replica:master`.

With Docker Compose the master/replica mode can be setup using:

```yaml
version: '2'

services:
  keydb-master:
    image: 'bitnami/keydb:latest'
    ports:
      - '6379'
    environment:
      - KEYDB_REPLICATION_MODE=master
      - KEYDB_PASSWORD=my_master_password
    volumes:
      - '/path/to/keydb-persistence:/bitnami'

  keydb-replica:
    image: 'bitnami/keydb:latest'
    ports:
      - '6379'
    depends_on:
      - keydb-master
    environment:
      - KEYDB_REPLICATION_MODE=replica
      - KEYDB_MASTER_HOSTS=keydb-master
      - KEYDB_MASTER_PORT_NUMBER=6379
      - KEYDB_MASTER_PASSWORD=my_master_password
      - KEYDB_PASSWORD=my_replica_password
```

Scale the number of replicas using:

```console
docker-compose up --detach --scale keydb-master=1 --scale keydb-replica=3
```

The above command scales up the number of replicas to `3`. You can scale down in the same way.

> **Note**: You should not scale up/down the number of master nodes. Always have only one master node running.

### Securing KeyDB traffic

KeyDB adds the support for SSL/TLS connections. Should you desire to enable this optional feature, you may use the following environment variables to configure the application:

* `KEYDB_TLS_ENABLED`: Whether to enable TLS for traffic or not. Defaults to `no`.
* `KEYDB_TLS_PORT_NUMBER`: Port used for TLS secure traffic. Defaults to `6379`.
* `KEYDB_TLS_CERT_FILE`: File containing the certificate file for the TLS traffic. No defaults.
* `KEYDB_TLS_KEY_FILE`: File containing the key for certificate. No defaults.
* `KEYDB_TLS_CA_FILE`: File containing the CA of the certificate (takes precedence over `KEYDB_TLS_CA_DIR`). No defaults.
* `KEYDB_TLS_CA_DIR`: Directory containing the CA certificates. No defaults.
* `KEYDB_TLS_DH_PARAMS_FILE`: File containing DH params (in order to support DH based ciphers). No defaults.
* `KEYDB_TLS_AUTH_CLIENTS`: Whether to require clients to authenticate or not. Defaults to `yes`.

When enabling TLS, conventional standard traffic is disabled by default. However this new feature is not mutually exclusive, which means it is possible to listen to both TLS and non-TLS connection simultaneously. To enable non-TLS traffic, set `KEYDB_TLS_PORT_NUMBER` to another port different than `0`.

1. Using `docker run`

    ```console
    $ docker run --name keydb \
        -v /path/to/certs:/opt/bitnami/keydb/certs \
        -v /path/to/keydb-data-persistence:/bitnami/keydb/data \
        -e ALLOW_EMPTY_PASSWORD=yes \
        -e KEYDB_TLS_ENABLED=yes \
        -e KEYDB_TLS_CERT_FILE=/opt/bitnami/keydb/certs/keydb.crt \
        -e KEYDB_TLS_KEY_FILE=/opt/bitnami/keydb/certs/keydb.key \
        -e KEYDB_TLS_CA_FILE=/opt/bitnami/keydb/certs/keydbCA.crt \
        bitnami/keydb:latest
    ```

2. Modifying the `docker-compose.yml` file present in this repository:

    ```yaml
    services:
      keydb:
      ...
        environment:
          ...
          - KEYDB_TLS_ENABLED=yes
          - KEYDB_TLS_CERT_FILE=/opt/bitnami/keydb/certs/keydb.crt
          - KEYDB_TLS_KEY_FILE=/opt/bitnami/keydb/certs/keydb.key
          - KEYDB_TLS_CA_FILE=/opt/bitnami/keydb/certs/keydbCA.crt
        ...
        volumes:
          - /path/to/certs:/opt/bitnami/keydb/certs
          - /path/to/keydb-persistence:/bitnami/keydb/data
      ...
    ```

Alternatively, you may also provide with this configuration in your [custom](https://github.com/bitnami/containers/blob/main/bitnami/keydb#configuration-file) configuration file.

### Configuration file

The image looks for configurations in `/opt/bitnami/keydb/mounted-etc/keydb.conf`. You can overwrite the `keydb.conf` file using your own custom configuration file.

```console
docker run --name keydb \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -v /path/to/your_keydb.conf:/opt/bitnami/keydb/mounted-etc/keydb.conf \
    -v /path/to/keydb-data-persistence:/bitnami/keydb/data \
    bitnami/keydb:latest
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/keydb/docker-compose.yml) file present in this repository:

```yaml
services:
  keydb:
  ...
    volumes:
      - /path/to/your_keydb.conf:/opt/bitnami/keydb/mounted-etc/keydb.conf
      - /path/to/keydb-persistence:/bitnami/keydb/data
  ...
```

### Overriding configuration

Instead of providing a custom `keydb.conf`, you may also choose to provide only settings you wish to override. The image will look for `/opt/bitnami/keydb/mounted-etc/overrides.conf`. This will be ignored if custom `keydb.conf` is provided.

```console
docker run --name keydb \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -v /path/to/overrides.conf:/opt/bitnami/keydb/mounted-etc/overrides.conf \
    bitnami/keydb:latest
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/keydb/docker-compose.yml) file present in this repository:

```yaml
services:
  keydb:
  ...
    volumes:
      - /path/to/overrides.conf:/opt/bitnami/keydb/mounted-etc/overrides.conf
  ...
```

### Enable KeyDB RDB persistence

When the value of `KEYDB_RDB_POLICY_DISABLED` is `no` (default value) the KeyDB default persistence strategy will be used. If you want to modify the default strategy, you can configure it through the `KEYDB_RDB_POLICY` parameter. Here is a demonstration of modifying the default persistence strategy

1. Using `docker run`

    ```console
    $ docker run --name keydb \
        -v /path/to/keydb-data-persistence:/bitnami/keydb/data \
        -e ALLOW_EMPTY_PASSWORD=yes \
        -e KEYDB_RDB_POLICY_DISABLED=no
        -e KEYDB_RDB_POLICY="900#1 600#5 300#10 120#50 60#1000 30#10000"
        bitnami/keydb:latest
    ```

2. Modifying the `docker-compose.yml` file present in this repository:

    ```yaml
      keydb:
      ...
        environment:
          ...
          - KEYDB_RDB_POLICY_DISABLED=no
          - KEYDB_RDB_POLICY="900#1 600#5 300#10 120#50 60#1000 30#10000"
        ...
      ...
    ```

## Logging

The Bitnami KeyDB Docker image sends the container logs to the `stdout`. To view the logs:

```console
docker logs keydb
```

or using Docker Compose:

```console
docker-compose logs keydb
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of KeyDB, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/keydb:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/keydb:latest`.

#### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
docker stop keydb
```

or using Docker Compose:

```console
docker-compose stop keydb
```

Next, take a snapshot of the persistent volume `/path/to/keydb-persistence` using:

```console
rsync -a /path/to/keydb-persistence /path/to/keydb-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

#### Step 3: Remove the currently running container

```console
docker rm -v keydb
```

or using Docker Compose:

```console
docker-compose rm -v keydb
```

#### Step 4: Run the new image

Re-create your container from the new image.

```console
docker run --name keydb bitnami/keydb:latest
```

or using Docker Compose:

```console
docker-compose up keydb
```

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/keydb).

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
