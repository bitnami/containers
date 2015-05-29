# Bitnami MariaDB Docker Container

## Introduction to Bitnami containers
Bitnami provides easy-to-use, consistently configured, and always up-to-date container images. [Click here](https://bitnami.com) for more information on our packaging approach.

## What is MariaDB?
MariaDB is a fast, reliable, scalable, and easy to use open-source relational database system. MariaDB Server is intended for mission-critical, heavy-load production systems as well as for embedding into mass-deployed software.

## Usage
You can instantiate a Bitnami MariaDB container by doing:

```
HOST_MARIADB_CONF_DIR=`pwd`/conf
HOST_MARIADB_DATA_DIR=`pwd`/data
CONTAINER_MARIADB_SERVER_NAME=mariadb
docker run -it \
  -v $HOST_MARIADB_CONF_DIR:/conf \
  -v $HOST_MARIADB_DATA_DIR:/data \
  --name $CONTAINER_MARIADB_SERVER_NAME
  bitnami/mariadb
```

## Data
MariaDB data lives in $HOST_MARIADB_DATA_DIR on the host. Mapping an empty directory to `/data` inside the container will initialize the database.

## Configuration

### my.cnf
MariaDB configuration files live in $HOST_MARIADB_CONF_DIR on the host. You can edit the default or place your own `my.cnf` file in there.

### Custom arguments/options
You can specify custom arguments or options to the MariaDB server command, e.g., specifying a different port:

```
docker run ... bitnami/mariadb --port=4000
```
The following options cannot be overridden:

```
--defaults-file=/opt/bitnami/mysql/my.cnf
--log-error=/opt/bitnami/mysql/logs/mysqld.log
--basedir=/opt/bitnami/mysql
--datadir=/opt/bitnami/mysql/data
--plugin-dir=/opt/bitnami/mysql/lib/plugin
--user=mysql
--socket=/opt/bitnami/mysql/tmp/mysql.sock
```

Anything else is fair game, you can see a full list of options here:
https://dev.mysql.com/doc/refman/5.1/en/server-options.html

### Environment variables

You can specify the `MARIADB_PASSWORD` and the `MARIADB_DATABASE` environment variables to specify a password and database to create when mounting an empty volume at `/data`.

## Linking

You can start up a MariaDB client by running:

```
CONTAINER_MARIADB_LINK_NAME=mariadb
docker run --rm -it \
    --link $CONTAINER_MARIADB_SERVER_NAME:$CONTAINER_MARIADB_LINK_NAME bitnami/mariadb \
    mysql -h $CONTAINER_MARIADB_LINK_NAME -u root -p
```
The client connects to the server we started in the previous command using a docker link. This exposes the `$CONTAINER_MARIADB_LINK_NAME` as the hostname for the link inside the container. We set the `-h` argument in the MariaDB client command to tell it to connect to the server running in the other container.

Similarly, you can link the MariaDB to a container running your application, e.g., using the Bitnami node container:

```
CONTAINER_MARIADB_LINK_NAME=mariadb
docker run --rm -it \
    --link $CONTAINER_MARIADB_SERVER_NAME:$CONTAINER_MARIADB_LINK_NAME bitnami/node \
    npm start --production
```
Inside your application, use the value of $CONTAINER_MARIADB_LINK_NAME when setting the MariaDB host.

## Logging

The container is set up to log to stdout, which means logs can be obtained as follows:

```
docker logs mariadb
```

If you would like to log to a file instead, you can mount a volume at `/logs`.
