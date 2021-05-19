# What is MariaDB?

> MariaDB is a fast, reliable, scalable, and easy to use open-source relational database system. MariaDB Server is intended for mission-critical, heavy-load production systems as well as for embedding into mass-deployed software.

[https://mariadb.com/](https://mariadb.com/)

# TL;DR

```console
$ docker run --name mariadb -e ALLOW_EMPTY_PASSWORD=yes bitnami/mariadb:latest
```

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-mariadb/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/mariadb?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy MariaDB in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami MariaDB Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/mariadb).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`10.5`, `10.5-debian-10`, `10.5.10`, `10.5.10-debian-10-r10`, `latest` (10.5/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-mariadb/blob/10.5.10-debian-10-r10/10.5/debian-10/Dockerfile)
* [`10.4`, `10.4-debian-10`, `10.4.19`, `10.4.19-debian-10-r10` (10.4/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-mariadb/blob/10.4.19-debian-10-r10/10.4/debian-10/Dockerfile)
* [`10.3`, `10.3-debian-10`, `10.3.29`, `10.3.29-debian-10-r10` (10.3/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-mariadb/blob/10.3.29-debian-10-r10/10.3/debian-10/Dockerfile)
* [`10.2`, `10.2-debian-10`, `10.2.38`, `10.2.38-debian-10-r10` (10.2/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-mariadb/blob/10.2.38-debian-10-r10/10.2/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/mariadb GitHub repo](https://github.com/bitnami/bitnami-docker-mariadb).

# Get this image

The recommended way to get the Bitnami MariaDB Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/mariadb).

```console
$ docker pull bitnami/mariadb:latest
```

To use a specific version, you can pull a versioned tag. You can view the
[list of available versions](https://hub.docker.com/r/bitnami/mariadb/tags/)
in the Docker Hub Registry.

```console
$ docker pull bitnami/mariadb:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
$ git clone https://github.com/bitnami/bitnami-docker-mariadb.git
$ cd bitnami-docker-mariadb/VERSION/OPERATING-SYSTEM
$ docker build -t bitnami/mariadb:latest .
```

# Persisting your database

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/mariadb` path. If the mounted directory is empty, it will be initialized on the first run.

```console
$ docker run \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -v /path/to/mariadb-persistence:/bitnami/mariadb \
    bitnami/mariadb:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-mariadb/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  mariadb:
  ...
    volumes:
      - /path/to/mariadb-persistence:/bitnami/mariadb
  ...
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

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
$ docker run -d --name mariadb-server \
    -e ALLOW_EMPTY_PASSWORD=yes \
    --network app-tier \
    bitnami/mariadb:latest
```

### Step 3: Launch your MariaDB client instance

Finally we create a new container instance to launch the MariaDB client and connect to the server created in the previous step:

```console
$ docker run -it --rm \
    --network app-tier \
    bitnami/mariadb:latest mysql -h mariadb-server -u root
```

## Using Docker Compose

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `app-tier`. In this example we assume that you want to connect to the MariaDB server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge

services:
  mariadb:
    image: 'bitnami/mariadb:latest'
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

Take into account those scripts are treated differently depending on the extension. While the `.sh` scripts are executed in all the nodes; the `.sql` and `.sql.gz` scripts are only executed in the master nodes. The reason behind this differentiation is that the `.sh` scripts allow adding conditions to determine what is the node running the script, while these conditions can't be set using `.sql` nor `sql.gz` files. This way it is possible to cover different use cases depending on their needs.

## Passing extra command-line flags to mysqld startup

Passing extra command-line flags to the mysqld service command is possible through the following env var:

- `MARIADB_EXTRA_FLAGS`: Flags to be appended to the startup command. No defaults

```console
$ docker run --name mariadb -e ALLOW_EMPTY_PASSWORD=yes -e MARIADB_EXTRA_FLAGS='--max-connect-errors=1000 --max_connections=155' bitnami/mariadb:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-mariadb/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  mariadb:
  ...
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - MARIADB_EXTRA_FLAGS=--max-connect-errors=1000 --max_connections=155
  ...
```

## Setting character set and collation

It is possible to configure the character set and collation used by default by the database with the following environment variables:

- `MARIADB_CHARACTER_SET`: The default character set to use. Default: `utf8`
- `MARIADB_COLLATE`: The default collation to use. Default: `utf8_general_ci`

## Setting the root password on first run

The root user and password can easily be setup with the Bitnami MariaDB Docker image using the following environment variables:

 - `MARIADB_ROOT_USER`: The database admin user. Defaults to `root`.
 - `MARIADB_ROOT_PASSWORD`: The database admin user password. No defaults.
 - `MARIADB_ROOT_PASSWORD_FILE`: Path to a file that contains the admin user password. This will override the value specified in `MARIADB_ROOT_PASSWORD`. No defaults.

Passing the `MARIADB_ROOT_PASSWORD` environment variable when running the image for the first time will set the password of the `MARIADB_ROOT_USER` user to the value of `MARIADB_ROOT_PASSWORD`.

```console
$ docker run --name mariadb -e MARIADB_ROOT_PASSWORD=password123 bitnami/mariadb:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-mariadb/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  mariadb:
  ...
    environment:
      - MARIADB_ROOT_PASSWORD=password123
  ...
```

**Warning** The `MARIADB_ROOT_USER` user is always created with remote access. It's suggested that the `MARIADB_ROOT_PASSWORD` env variable is always specified to set a password for the `MARIADB_ROOT_USER` user. In case you want to allow the `MARIADB_ROOT_USER` user to access the database without a password set the environment variable `ALLOW_EMPTY_PASSWORD=yes`. **This is recommended only for development**.

## Allowing empty passwords

By default the MariaDB image expects all the available passwords to be set. In order to allow empty passwords, it is necessary to set the `ALLOW_EMPTY_PASSWORD=yes` env variable. This env variable is only recommended for testing or development purposes. We strongly recommend specifying the `MARIADB_ROOT_PASSWORD` for any other scenario.

```console
$ docker run --name mariadb -e ALLOW_EMPTY_PASSWORD=yes bitnami/mariadb:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-mariadb/blob/master/docker-compose.yml) file present in this repository:


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
    bitnami/mariadb:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-mariadb/blob/master/docker-compose.yml) file present in this repository:

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

You can create a restricted database user that only has permissions for the database created with the [`MARIADB_DATABASE`](#creating-a-database-on-first-run) environment variable. To do this, provide the `MARIADB_USER` environment variable and to set a password for the database user provide the `MARIADB_PASSWORD` variable (alternatively, you can set the `MARIADB_PASSWORD_FILE` with the path to a file that contains the user password). MariaDB supports different authentication mechanisms, such as `pam` or `mysql_native_password`. To set it, use the `MARIADB_AUTHENTICATION_PLUGIN` variable.

```console
$ docker run --name mariadb \
  -e ALLOW_EMPTY_PASSWORD=yes \
  -e MARIADB_USER=my_user \
  -e MARIADB_PASSWORD=my_password \
  -e MARIADB_DATABASE=my_database \
  bitnami/mariadb:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-mariadb/blob/master/docker-compose.yml) file present in this repository:

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

## Slow filesystems

In some platforms, the filesystem used for persistence could be slow. That could cause the database to take extra time to be ready. If that's the case, you can configure the `MARIADB_INIT_SLEEP_TIME` environment variable to make the initialization script to wait extra time (in seconds) before proceeding with the configuration operations.


## Setting up a replication cluster

A **zero downtime** MariaDB master-slave [replication](https://dev.mysql.com/doc/refman/5.7/en/server-option-variable-reference.html) cluster can easily be setup with the Bitnami MariaDB Docker image using the following environment variables:

 - `MARIADB_REPLICATION_MODE`: The replication mode. Possible values `master`/`slave`. No defaults.
 - `MARIADB_REPLICATION_USER`: The replication user created on the master on first run. No defaults.
 - `MARIADB_REPLICATION_PASSWORD`: The replication users password. No defaults.
 - `MARIADB_REPLICATION_PASSWORD_FILE`: Path to a file that contains the replication user password. This will override the value specified in `MARIADB_REPLICATION_PASSWORD`. No defaults.
 - `MARIADB_MASTER_HOST`: Hostname/IP of replication master (slave parameter). No defaults.
 - `MARIADB_MASTER_PORT_NUMBER`: Server port of the replication master (slave parameter). Defaults to `3306`.
 - `MARIADB_MASTER_ROOT_USER`: User on replication master with access to `MARIADB_DATABASE` (slave parameter). Defaults to `root`
 - `MARIADB_MASTER_ROOT_PASSWORD`: Password of user on replication master with access to `MARIADB_DATABASE` (slave parameter). No defaults.
 - `MARIADB_MASTER_ROOT_PASSWORD_FILE`: Path to a file that contains the password of user on replication master with access to `MARIADB_DATABASE`. This will override the value specified in `MARIADB_MASTER_ROOT_PASSWORD`. No defaults.

In a replication cluster you can have one master and zero or more slaves. When replication is enabled the master node is in read-write mode, while the slaves are in read-only mode. For best performance its advisable to limit the reads to the slaves.

### Step 1: Create the replication master

The first step is to start the MariaDB master.

```console
$ docker run --name mariadb-master \
  -e MARIADB_ROOT_PASSWORD=master_root_password \
  -e MARIADB_REPLICATION_MODE=master \
  -e MARIADB_REPLICATION_USER=my_repl_user \
  -e MARIADB_REPLICATION_PASSWORD=my_repl_password \
  -e MARIADB_USER=my_user \
  -e MARIADB_PASSWORD=my_password \
  -e MARIADB_DATABASE=my_database \
  bitnami/mariadb:latest
```

In the above command the container is configured as the `master` using the `MARIADB_REPLICATION_MODE` parameter. A replication user is specified using the `MARIADB_REPLICATION_USER` and `MARIADB_REPLICATION_PASSWORD` parameters.

### Step 2: Create the replication slave

Next we start a MariaDB slave container.

```console
$ docker run --name mariadb-slave --link mariadb-master:master \
  -e MARIADB_REPLICATION_MODE=slave \
  -e MARIADB_REPLICATION_USER=my_repl_user \
  -e MARIADB_REPLICATION_PASSWORD=my_repl_password \
  -e MARIADB_MASTER_HOST=master \
  -e MARIADB_MASTER_ROOT_PASSWORD=master_root_password \
  bitnami/mariadb:latest
```

In the above command the container is configured as a `slave` using the `MARIADB_REPLICATION_MODE` parameter. The `MARIADB_MASTER_HOST`, `MARIADB_MASTER_ROOT_USER` and `MARIADB_MASTER_ROOT_PASSWORD` parameters are used by the slave to connect to the master. It also takes a dump of the existing data in the master server. The replication user credentials are specified using the `MARIADB_REPLICATION_USER` and `MARIADB_REPLICATION_PASSWORD` parameters and should be the same as the one specified on the master.

You now have a two node MariaDB master/slave replication cluster up and running. You can scale the cluster by adding/removing slaves without incurring any downtime.

With Docker Compose the master/slave replication can be setup using:

```yaml
version: '2'

services:
  mariadb-master:
    image: 'bitnami/mariadb:latest'
    ports:
      - '3306'
    volumes:
      - /path/to/mariadb-persistence:/bitnami/mariadb
    environment:
      - MARIADB_REPLICATION_MODE=master
      - MARIADB_REPLICATION_USER=repl_user
      - MARIADB_REPLICATION_PASSWORD=repl_password
      - MARIADB_ROOT_PASSWORD=master_root_password
      - MARIADB_USER=my_user
      - MARIADB_PASSWORD=my_password
      - MARIADB_DATABASE=my_database
  mariadb-slave:
    image: 'bitnami/mariadb:latest'
    ports:
      - '3306'
    depends_on:
      - mariadb-master
    environment:
      - MARIADB_REPLICATION_MODE=slave
      - MARIADB_REPLICATION_USER=repl_user
      - MARIADB_REPLICATION_PASSWORD=repl_password
      - MARIADB_MASTER_HOST=mariadb-master
      - MARIADB_MASTER_PORT_NUMBER=3306
      - MARIADB_MASTER_ROOT_PASSWORD=master_root_password
```

Scale the number of slaves using:

```console
$ docker-compose up --detach --scale mariadb-master=1 --scale mariadb-slave=3
```

The above command scales up the number of slaves to `3`. You can scale down in the same manner.

> **Note**: You should not scale up/down the number of master nodes. Always have only one master node running.

## Configuration file

The image looks for user-defined configurations in `/opt/bitnami/mariadb/conf/my_custom.cnf`. Create a file named `my_custom.cnf` and mount it at `/opt/bitnami/mariadb/conf/my_custom.cnf`.

For example, in order to override the `max_allowed_packet` directive:

### Step 1: Write your `my_custom.cnf` file with the following content.

```config
[mysqld]
max_allowed_packet=32M
```

### Step 2: Run the mariaDB image with the designed volume attached.

```console
$ docker run --name mariadb \
    -p 3306:3306 \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -v /path/to/my_custom.cnf:/opt/bitnami/mariadb/conf/my_custom.cnf:ro \
    -v /path/to/mariadb-persistence:/bitnami/mariadb \
    bitnami/mariadb:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-mariadb/blob/master/docker-compose.yml) file present in this repository:

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

Refer to the [MariaDB server option and variable reference guide](https://dev.mysql.com/doc/refman/5.7/en/server-option-variable-reference.html) for the complete list of configuration options.

### Overwrite the main Configuration file

It is also possible to use your custom `my.cnf` and overwrite the main configuration file.

```console
$ docker run --name mariadb  -e ALLOW_EMPTY_PASSWORD=yes -v /path/to/my.cnf:/opt/bitnami/mariadb/conf/my.cnf:ro bitnami/mariadb:latest
```

# Customize this image

The Bitnami MariaDB Docker image is designed to be extended so it can be used as the base image for your custom configuration.

## Extend this image

Before extending this image, please note there are certain configuration settings you can modify using the original image:

- Settings that can be adapted using environment variables. For instance, you can change the ports used by MariaDB, by setting the environment variables `MARIADB_PORT_NUMBER` or the character set using `MARIADB_CHARACTER_SET` respectively.

If your desired customizations cannot be covered using the methods mentioned above, extend the image. To do so, create your own image using a Dockerfile with the format below:

```Dockerfile
FROM bitnami/mariadb
## Put your customizations below
...
```

Here is an example of extending the image with the following modifications:

- Install the `vim` editor
- Modify the MariaDB configuration file
- Modify the ports used by MariaDB
- Change the user that runs the container

```Dockerfile
FROM bitnami/mariadb
LABEL maintainer "Bitnami <containers@bitnami.com>"

## Change user to perform privileged actions
USER 0
## Install 'vim'
RUN install_packages vim
## Revert to the original non-root user
USER 1001

## modify configuration file.
RUN ini-file set --section "mysqld" --key "collation-server" --value "utf8_general_ci" "/opt/bitnami/mariadb/conf/my.cnf"

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
      - /path/to/my_custom.cnf:/opt/bitnami/mariadb/conf/my_custom.cnf:ro
      - data:/bitnami/mariadb/data
volumes:
  data:
    driver: local
```

# Logging

The Bitnami MariaDB Docker image sends the container logs to the `stdout`. To view the logs:

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
$ docker pull bitnami/mariadb:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/mariadb:latest`.

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
$ docker run --name mariadb bitnami/mariadb:latest
```

or using Docker Compose:

```console
$ docker-compose up mariadb
```

# Useful Links

- [Create An AMP Development Environment With Bitnami Containers
](https://docs.bitnami.com/containers/how-to/create-amp-environment-containers/)
- [Create An EMP Development Environment With Bitnami Containers
](https://docs.bitnami.com/containers/how-to/create-emp-environment-containers/)

# Notable Changes

## 10.4.13-debian-10-r12, 10.3.23-debian-10-r14, 10.2.32-debian-10-r14 and 10.1.45-debian-10-r15

- This image has been adapted so it's easier to customize. See the [Customize this image](#customize-this-image) section for more information.

## 10.1.36-r14 and 10.2.27-r36

- Decrease the size of the container. It is not necessary Node.js anymore. MariaDB configuration moved to bash scripts in the `rootfs/` folder.
- The recommended mount point to persist data changes to `/bitnami/mariadb`.
- The MariaDB configuration files are not persisted in a volume anymore. Now, they can be found at `/opt/bitnami/mariadb/conf`.
- Backwards compatibility is not guaranteed when data is persisted using docker-compose. You can use the workaround below to overcome it:

```console
$ docker-compose down
# Change the mount point
sed -i -e 's#mariadb_data:/bitnami#mariadb_data:/bitnami/mariadb#g' docker-compose.yml
# Pull the latest bitnami/mariadb image
$ docker pull bitnami/mariadb:latest
$ docker-compose up -d
```

## 10.1.28-r2 and 10.2.16-r2

- The MariaDB container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the MariaDB daemon was started as the `mysql` user. From now on, both the container and the MariaDB daemon run as user `1001`. As a consequence, the data directory must be writable by that user. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

## 10.2.14-r2 and 10.1.32-r1
- The mariadb conf file is not in a persistent volume by default.
- The user is able to specify a custom file in the default location '/opt/bitnami/mariadb/conf/my.cnf'.

## 10.1.28-r2

- The mariadb container has been migrated to a non-root container approach. Previously the container run as root user and the mariadb daemon was started as mysql user. From now own, both the container and the mariadb daemon run as user 1001. As a consequence, the configuration files are writable by the user running the mariadb process.

## 10.1.24-r2

- `VOLUME` instruction has been removed from the `Dockerfile`.

## 10.1.21-r2

- `MARIADB_MASTER_USER` has been renamed to `MARIADB_MASTER_ROOT_USER`
- `MARIADB_MASTER_PASSWORD` has been renamed to `MARIADB_MASTER_ROOT_PASSWORD`
- `MARIADB_ROOT_USER` has been added to the available env variables. It can be used to specify the admin user.
- `ALLOW_EMPTY_PASSWORD` has been added to the available env variables. It can be used to allow blank passwords for MariaDB.
- By default the MariaDB image requires a root password to start. You can specify it using the `MARIADB_ROOT_PASSWORD` env variable or disable this requirement by setting the `ALLOW_EMPTY_PASSWORD`  env variable to `yes` (testing or development scenarios).

## 10.1.13-r0

- All volumes have been merged at `/bitnami/mariadb`. Now you only need to mount a single volume at `/bitnami/mariadb` for persistence.
- The logs are always sent to the `stdout` and are no longer collected in the volume.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-mariadb/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-mariadb/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-mariadb/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright (c) 2015-2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
