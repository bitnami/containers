# What is MariaDB Galera?

> MariaDB Galera is a multi-master database cluster solution for synchronous replication and high availability.

[https://mariadb.com/kb/en/library/galera-cluster/](https://mariadb.com/kb/en/library/galera-cluster/)

# TL;DR

```console
$ docker run --name mariadb \
  -e ALLOW_EMPTY_PASSWORD=yes \
  bitnami/mariadb-galera:latest
```

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-mariadb-galera/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.

> This [CVE scan report](https://quay.io/repository/bitnami/mariadb-galera?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy MariaDB Galera in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami MariaDB Galera Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/mariadb-galera).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

> NOTE: Debian 9 and Oracle Linux 7 images have been deprecated in favor of Debian 10 images. Bitnami will not longer publish new Docker images based on Debian 9 or Oracle Linux 7.

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`10.5`, `10.5-debian-10`, `10.5.10`, `10.5.10-debian-10-r10`, `latest` (10.5/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-mariadb-galera/blob/10.5.10-debian-10-r10/10.5/debian-10/Dockerfile)
* [`10.4`, `10.4-debian-10`, `10.4.19`, `10.4.19-debian-10-r11` (10.4/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-mariadb-galera/blob/10.4.19-debian-10-r11/10.4/debian-10/Dockerfile)
* [`10.3`, `10.3-debian-10`, `10.3.29`, `10.3.29-debian-10-r11` (10.3/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-mariadb-galera/blob/10.3.29-debian-10-r11/10.3/debian-10/Dockerfile)
* [`10.2`, `10.2-debian-10`, `10.2.38`, `10.2.38-debian-10-r11` (10.2/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-mariadb-galera/blob/10.2.38-debian-10-r11/10.2/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/mariadb-galera GitHub repo](https://github.com/bitnami/bitnami-docker-mariadb-galera).

# Get this image

The recommended way to get the Bitnami MariaDB Galera Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/mariadb-galera).

```console
$ docker pull bitnami/mariadb-galera:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/mariadb-galera/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/mariadb-galera:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
$ git clone https://github.com/bitnami/bitnami-docker-mariadb-galera.git
$ cd bitnami-docker-mariadb/VERSION/OPERATING-SYSTEM
$ docker build -t bitnami/mariadb-galera:latest .
```

# Persisting your database

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/mariadb` path. If the mounted directory is empty, it will be initialized on the first run.

```console
$ docker run \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -v /path/to/mariadb-persistence:/bitnami/mariadb \
    bitnami/mariadb-galera:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-mariadb-galera/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  mariadb:
  ...
    volumes:
      - /path/to/mariadb-persistence:/bitnami/mariadb
  ...
```

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a MariaDB server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

In this example, we will create a MariaDB client instance that will connect to the server instance that is running on the same docker network as the client.

### Step 1: Create a network

```console
$ docker network create app-tier --driver bridge
```

### Step 2: Launch the MariaDB server instance

Use the `--network app-tier` argument to the `docker run` command to attach the MariaDB container to the `app-tier` network.

```console
$ docker run -d --name mariadb-galera \
    -e ALLOW_EMPTY_PASSWORD=yes \
    --network app-tier \
    bitnami/mariadb-galera:latest
```

### Step 3: Launch your MariaDB client instance

Finally we create a new container instance to launch the MariaDB client and connect to the server created in the previous step:

```console
$ docker run -it --rm \
    --network app-tier \
    bitnami/mariadb-galera:latest mysql -h mariadb-galera -u root
```

## Using Docker Compose

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `app-tier`. In this example we assume that you want to connect to the MariaDB server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge

services:
  mariadb-galera:
    image: 'bitnami/mariadb-galera:latest'
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
> 1. Please update the `YOUR_APPLICATION_IMAGE` placeholder in the above snippet with your application image
> 2. In your application container, use the hostname `mariadb` to connect to the MariaDB server

Launch the containers using:

```console
$ docker-compose up -d
```

# Configuration

## Initializing a new instance

When the container is executed for the first time, it will execute the files with extensions `.sh`, `.sql` and `.sql.gz` located at `/docker-entrypoint-initdb.d`.

In order to have your custom files inside the docker image you can mount them as a volume.

Take into account those scripts are treated differently depending on the extension. While the `.sh` scripts are executed in all the nodes; the `.sql` and `.sql.gz` scripts are only executed in the bootstrap node. The reason behind this differentiation is that the `.sh` scripts allow adding conditions to determine what is the node running the script, while these conditions can't be set using `.sql` nor `sql.gz` files. This way it is possible to cover different use cases depending on their needs.

## Passing extra command-line flags to mysqld startup

Passing extra command-line flags to the mysqld service command is possible through the following env var:

- `MARIADB_EXTRA_FLAGS`: Flags to be appended to the startup command. No defaults

```console
$ docker run --name mariadb \
  -e ALLOW_EMPTY_PASSWORD=yes \
  -e MARIADB_EXTRA_FLAGS='--max-connect-errors=1000 --max_connections=155' \
    bitnami/mariadb-galera:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-mariadb-galera/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  mariadb:
  ...
    environment:
      - MARIADB_EXTRA_FLAGS=--max-connect-errors=1000 --max_connections=155
  ...
```

## Setting character set and collation

It is possible to configure the character set and collation used by default by the database with the following environment variables:

- `MARIADB_CHARACTER_SET`: The default character set to use. Default: `utf8`
- `MARIADB_COLLATE`: The default collation to use. Default: `utf8_general_ci`

## Setting the root password on first run

The root user and password can easily be setup with the Bitnami MariaDB Galera Docker image using the following environment variables:

 - `MARIADB_ROOT_USER`: The database admin user. Defaults to `root`.
 - `MARIADB_ROOT_PASSWORD`: The database admin user password. No defaults.

Passing the `MARIADB_ROOT_PASSWORD` environment variable when running the image for the first time will set the password of the `MARIADB_ROOT_USER` user to the value of `MARIADB_ROOT_PASSWORD`.

```console
$ docker run --name mariadb \
  -e MARIADB_ROOT_PASSWORD=password123 \
  bitnami/mariadb-galera:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-mariadb-galera/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  mariadb:
  ...
    environment:
      - MARIADB_ROOT_PASSWORD=password123
  ...
```

**Warning** The `MARIADB_ROOT_USER` user is always created with remote access. It's suggested that the `MARIADB_ROOT_PASSWORD` env variable is always specified to set a password for the `MARIADB_ROOT_USER` user. In case you want to allow the `MARIADB_ROOT_USER` user to access the database without a password set the environment variable `ALLOW_EMPTY_PASSWORD=yes`. **This is suggested only for development or testing environments**.

## Allowing empty passwords

By default the MariaDB Galera image expects all the available passwords to be set. In order to allow empty passwords, it is necessary to set the `ALLOW_EMPTY_PASSWORD=yes` env variable. This env variable is only suggested for testing or development purposes. We strongly recommend specifying the `MARIADB_ROOT_PASSWORD` for any other scenario.

```console
$ docker run --name mariadb \
  -e ALLOW_EMPTY_PASSWORD=yes \
  bitnami/mariadb-galera:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-mariadb-galera/blob/master/docker-compose.yml) file present in this repository:


```yaml
services:
  mariadb:
  ...
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
  ...
```

## Creating a database on first run

By passing the `MARIADB_DATABASE` environment variable when running the image for the first time, a database will be created. This is useful if your application requires that a database already exists, saving you from having to manually create the database using the MySQL client.

```console
$ docker run --name mariadb \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MARIADB_DATABASE=my_database \
    bitnami/mariadb-galera:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-mariadb-galera/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  mariadb:
  ...
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - MARIADB_DATABASE=my_database
  ...
```

## Creating a database user on first run

You can create a restricted database user that only has permissions for the database created with the [`MARIADB_DATABASE`](#creating-a-database-on-first-run) environment variable. To do this, provide the `MARIADB_USER` environment variable and to set a password for the database user provide the `MARIADB_PASSWORD` variable.

```console
$ docker run --name mariadb \
  -e ALLOW_EMPTY_PASSWORD=yes \
  -e MARIADB_USER=my_user \
  -e MARIADB_PASSWORD=my_password \
  -e MARIADB_DATABASE=my_database \
  bitnami/mariadb-galera:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-mariadb-galera/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  mariadb:
  ...
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - MARIADB_USER=my_user
      - MARIADB_PASSWORD=my_password
      - MARIADB_DATABASE=my_database
  ...
```

**Note!** The `root` user will be created with remote access and without a password if `ALLOW_EMPTY_PASSWORD` is enabled. Please provide the `MARIADB_ROOT_PASSWORD` env variable instead if you want to set a password for the `root` user.

## Enabling LDAP support

LDAP configuration parameters must be specified if you wish to enable LDAP support for your MariaDB Galera cluster. The following environment variables are available to configure LDAP support:

- `MARIADB_ENABLE_LDAP`: Whether to enable LDAP authentication. Defaults to `no`.
- `LDAP_URI`: LDAP URL beginning in the form `ldap[s]:/<hostname>:<port>`. No defaults.
- `LDAP_BASE`: LDAP base DN. No defaults.
- `LDAP_BIND_DN`: LDAP bind DN. No defaults.
- `LDAP_BIND_PASSWORD`: LDAP bind password. No defaults.
- `LDAP_BASE_LOOKUP`: LDAP base lookup (Optional). No defaults.
- `LDAP_NSS_INITGROUPS_IGNOREUSERS`: LDAP ignored users. Defaults to `root,nslcd`.
- `LDAP_SCOPE`: LDAP search scope (Optional). No defaults.
- `LDAP_SEARCH_FILTER`: LDAP search filter on posix users (Optional). No defaults.
- `LDAP_SEARCH_MAP`: LDAP custom search attribute to be looked up on posix users (Optional). No defaults.
- `LDAP_TLS_REQCERT`: LDAP TLS check on server certificates (Optional). No defaults.

### Step 1: Start MariaDB Galera with LDAP support

```console
$ docker run --name mariadb \
  -e ALLOW_EMPTY_PASSWORD=yes \
  -e MARIADB_ENABLE_LDAP=yes \
  -e LDAP_URI=ldap://ldap.example.org/ \
  -e LDAP_BASE=dc=example,dc=org \
  -e LDAP_BIND_DN=cn=admin,dc=example,dc=org \
  -e LDAP_BIND_PASSWORD=admin \
  bitnami/mariadb-galera:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-mariadb-galera/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  mariadb:
  ...
    environment:
      - MARIADB_ENABLE_LDAP=yes
      - LDAP_URI=ldap://ldap.example.org/
      - LDAP_BASE=dc=example,dc=org
      - LDAP_BIND_DN=cn=admin,dc=example,dc=org
      - LDAP_BIND_PASSWORD=admin
  ...
```

**Note**: The LDAP connection parameters can be fine tuned by specifying the `LDAP_BASE_LOOKUP`, `LDAP_SCOPE` and `LDAP_TLS_REQCERT` environment variables.

### Step 2: Configure PAM authenticated LDAP users

Login to the MariaDB server using the `root` credentials and configure the LDAP users you wish to have access to the MariaDB Galera cluster.

```console
$ mysql -uroot -e "CREATE USER 'foo'@'localhost' IDENTIFIED VIA pam USING 'mariadb';"
```

The above command configures the database user `foo` to authenticate itself with the LDAP credentials to log in to MariaDB Galera server.

Refer to the [OpenLDAP Administrator's Guide](https://www.openldap.org/doc/admin24/) to learn more about LDAP.

## Securing Galera cluster traffic

To secure the traffic you must mount the certificates files and set the following environment variables in all the cluster members:

- `MARIADB_ENABLE_TLS`: Whether to enable TLS for traffic. Defaults to `no`.
- `MARIADB_TLS_CERT_FILE`: File containing the certificate file for the TSL traffic. No defaults.
- `MARIADB_TLS_KEY_FILE`: File containing the key for certificate. No defaults.
- `MARIADB_TLS_CA_FILE`: File containing the CA of the certificate. No defaults.

### Start MariaDB Galera with secured traffic

```console
$ docker run --name mariadb \
  -v /path/to/cert.pem:/bitnami/mariadb/certs/cert.pem:ro
  -v /path/to/key.pem:/bitnami/mariadb/certs/key.pem:ro
  -v /path/to/ca.pem:/bitnami/mariadb/certs/ca.pem:ro
  -e ALLOW_EMPTY_PASSWORD=yes \
  -e MARIADB_ENABLE_SSL=yes \
  -e MARIADB_TLS_CERT_FILE=/bitnami/mariadb/certs/cert.pem \
  -e MARIADB_TLS_KEY_FILE=/bitnami/mariadb/certs/key.pem \
  -e MARIADB_TLS_CA_FILE=/bitnami/mariadb/certs/ca.pem \
  bitnami/mariadb-galera:latest
```

### Connecting over TLS

To connect to the server using TLS you need to mount the CA certificate file and start the client using the `--ssl-ca` parameter

```console
$ docker run -it --rm \
    -v /path/to/ca.pem:/bitnami/mariadb/certs/ca.pem:ro \
    --network app-tier \
    bitnami/mariadb-galera:latest mysql -h mariadb-galera -u root --ssl-ca=/bitnami/mariadb/certs/ca.pem
```

## Setting up a multi-master cluster

A **zero downtime** MariaDB Galera [replication](https://dev.mysql.com/doc/refman/5.7/en/server-option-variable-reference.html) cluster can easily be setup with the Bitnami MariaDB Galera Docker image by starting additional MariaDB Galera nodes. The following environment variables are available to configure the cluster:

- `MARIADB_GALERA_CLUSTER_BOOTSTRAP`: Whether node is first node of the cluster. No defaults.
- `MARIADB_GALERA_CLUSTER_NAME`: Galera cluster name. Default to `galera`.
- `MARIADB_GALERA_CLUSTER_ADDRESS`: Galera cluster address to join. Defaults to `gcomm://` on a bootstrap node.
- `MARIADB_GALERA_NODE_ADDRESS`: Node address to report to the Galera cluster. Defaults to eth0 address inside container.
- `MARIADB_GALERA_MARIABACKUP_USER`: [mariabackup](https://mariadb.com/kb/en/library/mariabackup-overview/) username for [State Snapshot Transfer(SST)](https://galeracluster.com/library/documentation/glossary.html#term-state-snapshot-transfer). Defaults to `mariabackup`.
- `MARIADB_GALERA_MARIABACKUP_PASSWORD`: [mariabackup](https://mariadb.com/kb/en/library/mariabackup-overview/) password for SST. No defaults.
- `MARIADB_REPLICATION_USER`: mariadb replication username. Defaults to `monitor`.
- `MARIADB_REPLICATION_PASSWORD`: mariadb replication user password. Defaults to `monitor`.

In a MariaDB Galera cluster the first node should be a bootstrap node (started with `MARIADB_GALERA_CLUSTER_BOOTSTRAP=yes`). The other nodes in the cluster should not be started with this environment variable, instead the `MARIADB_GALERA_CLUSTER_ADDRESS` variable should be specified. All the nodes in the MariaDB Galera cluster are in read-write mode and therefore offers high availability for high traffic applications.

### Step 1: Bootstrap the cluster

The first step is to start the MariaDB Galera bootstrap node.

```console
$ docker run -d --name mariadb-galera-0 \
  -e MARIADB_GALERA_CLUSTER_NAME=my_galera \
  -e MARIADB_GALERA_MARIABACKUP_USER=my_mariabackup_user \
  -e MARIADB_GALERA_MARIABACKUP_PASSWORD=my_mariabackup_password \
  -e MARIADB_ROOT_PASSWORD=my_root_password \
  -e MARIADB_USER=my_user \
  -e MARIADB_PASSWORD=my_password \
  -e MARIADB_DATABASE=my_database \
  -e MARIADB_REPLICATION_USER=my_replication_user \
  -e MARIADB_REPLICATION_PASSWORD=my_replication_password \
  bitnami/mariadb-galera:latest
```

In the above command the container is configured as the bootstrap node by specifying the `MARIADB_GALERA_CLUSTER_BOOTSTRAP` parameter. The SST user is specified using the `MARIADB_GALERA_MARIABACKUP_USER` and `MARIADB_GALERA_MARIABACKUP_PASSWORD` parameters and a cluster name is specified using the `MARIADB_GALERA_CLUSTER_NAME` parameter.

### Step 2: Add nodes to the cluster

Next we add a new node to the cluster.

```console
$ docker run -d --name mariadb-galera-1 --link mariadb-galera-0:mariadb-galera \
  -e MARIADB_GALERA_CLUSTER_NAME=my_galera \
  -e MARIADB_GALERA_CLUSTER_ADDRESS=gcomm://mariadb-galera:4567,0.0.0.0:4567 \
  -e MARIADB_GALERA_MARIABACKUP_USER=my_mariabackup_user \
  -e MARIADB_GALERA_MARIABACKUP_PASSWORD=my_mariabackup_password \
  -e MARIADB_ROOT_PASSWORD=my_root_password \
  -e MARIADB_REPLICATION_USER=my_replication_user \
  -e MARIADB_REPLICATION_PASSWORD=my_replication_password \
  bitnami/mariadb-galera:latest
```

In the above command a new node is created and configured to join the bootstrapped MariaDB Galera cluster by specifying the `MARIADB_GALERA_CLUSTER_ADDRESS` parameter. The `MARIADB_GALERA_CLUSTER_NAME`, `MARIADB_GALERA_MARIABACKUP_USER` and `MARIADB_GALERA_MARIABACKUP_PASSWORD` are also specified for the Snapshot State Transfer (SST).

You now have a two node MariaDB Galera cluster up and running. Write to any node of the cluster are automatically propagated to every node. You can scale the cluster by adding/removing slaves without incurring any downtime.

> **Important**: If you need to stop the MariaDB Galera cluster, ensure you stop the bootstrap node only after you have stopped all other nodes in the cluster. This ensure you do not loose any write that may have occurred while the nodes were being stopped.

## Slow filesystems

In some platforms, the filesystem used for persistence could be slow. That could cause the database to take extra time to be ready. If that's the case, you can configure the `MARIADB_INIT_SLEEP_TIME` environment variable to make the initialization script to wait extra time (in seconds) before proceeding with the configuration operations.

## Configuration file

The image looks for user-defined configurations in `/opt/bitnami/mariadb/conf/my_custom.cnf`. Create a file named `my_custom.cnf` and mount it at `/opt/bitnami/mariadb/conf/my_custom.cnf`.

For example, in order to override the `max_allowed_packet` directive:

### Step 1: Write your `my_custom.cnf` file with the following content.

```config
[mysqld]
max_allowed_packet=32M
```

### Step 2: Run the MariaDB Galera image with the designed volume attached.

```console
$ docker run --name mariadb \
    -p 3306:3306 \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -v /path/to/my_custom.cnf:/opt/bitnami/mariadb/conf/my_custom.cnf:ro \
    -v /path/to/mariadb-persistence:/bitnami/mariadb \
    bitnami/mariadb-galera:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-mariadb-galera/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  mariadb:
  ...
    volumes:
      - /path/to/my_custom.cnf:/opt/bitnami/mariadb/conf/my_custom.cnf:ro
      - /path/to/mariadb-persistence:/bitnami/mariadb
  ...
```

After that, your changes will be taken into account in the server's behaviour.

Refer to the [MySQL server option and variable reference guide](https://dev.mysql.com/doc/refman/5.7/en/server-option-variable-reference.html) for the complete list of configuration options.

## Overwrite the main Configuration file

It is also possible to use your custom `my.cnf` and overwrite the main configuration file.

```console
$ docker run --name mariadb \
  -e ALLOW_EMPTY_PASSWORD=yes \
  -v /path/to/my.cnf:/opt/bitnami/mariadb/conf/my.cnf:ro \
  bitnami/mariadb-galera:latest
```

# Customize this image

The Bitnami MariaDB Galera Docker image is designed to be extended so it can be used as the base image for your custom configuration.

## Extend this image

Before extending this image, please note there are certain configuration settings you can modify using the original image:

- Settings that can be adapted using environment variables. For instance, you can change the ports used by MariaDB, by setting the environment variables `MARIADB_PORT_NUMBER` or the character set using `MARIADB_CHARACTER_SET` respectively.

If your desired customizations cannot be covered using the methods mentioned above, extend the image. To do so, create your own image using a Dockerfile with the format below:

```Dockerfile
FROM bitnami/mariadb-galera
## Put your customizations below
...
```

Here is an example of extending the image with the following modifications:

- Install the `vim` editor
- Modify the MariaDB configuration file
- Modify the ports used by MariaDB
- Change the user that runs the container

```Dockerfile
FROM bitnami/mariadb-galera
LABEL maintainer "Bitnami <containers@bitnami.com>"

## Change user to perform privileged actions
USER 0
## Install 'vim'
RUN install_packages vim
## Revert to the original non-root user
USER 1001

## modify configuration file.
RUN ini-file set --section "mysqld" --key "collation-server" --value "utf8_general_ci" "/opt/bitnami/mariadb-galera/conf/my.cnf"

## Modify the ports used by MariaDB by default
# It is also possible to change these environment variables at runtime
ENV MARIADB_PORT_NUMBER=3307
EXPOSE 3307

## Modify the default container user
USER 1002
```

Based on the extended image, you can use a Docker Compose file like the one below to add other features:

- Add a custom configuration

```yaml
version: '2'

services:
  mariadb:
    build: .
    ports:
      - '3306:3307'
    volumes:
      - /path/to/my_custom.cnf:/opt/bitnami/mariadb-galera/conf/my_custom.cnf:ro
      - data:/bitnami/mariadb-galera/data
volumes:
  data:
    driver: local
```

# Logging

The Bitnami MariaDB Galera Docker image sends the container logs to `stdout`. To view the logs:

```console
$ docker logs mariadb
```

or using Docker Compose:

```console
$ docker-compose logs mariadb
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of MariaDB, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```console
$ docker pull bitnami/mariadb-galera:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/mariadb-galera:latest`.

### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
$ docker stop mariadb
```

or using Docker Compose:

```console
$ docker-compose stop mariadb
```

Next, take a snapshot of the persistent volume `/path/to/mariadb-persistence` using:

```console
$ rsync -a /path/to/mariadb-persistence /path/to/mariadb-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

You can use this snapshot to restore the database state should the upgrade fail.

### Step 3: Remove the currently running container

```console
$ docker rm -v mariadb
```

or using Docker Compose:

```console
$ docker-compose rm -v mariadb
```

### Step 4: Run the new image

Re-create your container from the new image.

```console
$ docker run --name mariadb bitnami/mariadb-galera:latest
```

or using Docker Compose:

```console
$ docker-compose up mariadb
```

# Useful Links

- [Create An AMP Development Environment With Bitnami Containers](https://docs.bitnami.com/containers/how-to/create-amp-environment-containers/)
- [Create An EMP Development Environment With Bitnami Containers](https://docs.bitnami.com/containers/how-to/create-emp-environment-containers/)

# Notable Changes

## 10.4.13-debian-10-r12, 10.3.23-debian-10-r14, 10.2.32-debian-10-r14 and 10.1.45-debian-10-r15

- This image has been adapted so it's easier to customize. See the [Customize this image](#customize-this-image) section for more information.

## 10.4.12-debian-10-r53, 10.3.22-debian-10-r54, 10.2.31-debian-10-r53, and 10.1.44-debian-10-r53

- The MariaDB Galera container has been migrated to a "non-root" user approach. Previously the container ran as the `root` user, and the MySQL daemon was started as the `mysql` user. From now on, both the container and the MySQL daemon run as user `1001`. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.
- Consequences:
  - Backwards compatibility is not guaranteed when data is persisted using docker or docker-compose. We highly recommend migrating the data site by creating a backup of the databse, and restoring it on a new MariaDB Galera container. In the link below you can find a guide that explain the whole process:
    - [Create And Restore MySQL/MariaDB Backups](https://docs.bitnami.com/general/infrastructure/mariadb/administration/backup-restore-mysql-mariadb/)
- Environment variables related to LDAP configuration were renamed removing the `MARIADB_` prefix. For instance, to indicate the LDAP URI to use, you must set `LDAP_URI` instead of `MARIADB_LDAP_URI`.

## 10.1.43-centos-7-r78, 10.2.30-centos-7-r40, 10.3.21-centos-7-r41, and 10.4.11-centos-7-r32

- `10.1.43-centos-7-r78`, `10.2.30-centos-7-r40`, `10.3.21-centos-7-r41`, and `10.4.11-centos-7-r32` are considered the latest images based on CentOS.
- Standard supported distros: Debian & OEL.


# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-mariadb-galera/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-mariadb-galera/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-mariadb-galera/issues/new). For us to provide better support, be sure to include the following information in your issue:

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
