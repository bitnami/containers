# Bitnami MariaDB Docker Stack

## Usage

### Running a mysql server
```
docker run --name mysql-server \
  -v /my-data:/data \
  -v /my-conf:/conf \
  -d bitnami/mariadb
```

### Running the mysql client
```
docker run --link mysql-server:mysql bitnami/mariadb \
  sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" \
  -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD"'
```

## Persistence

Map a volume on your host to `/data` to persist your database when the container is removed.

If the volume is empty, the database will be initialized in your volume.

## Configuration

### Pass custom arguments/flags to mysqld

For example, you can run the server on a different port by specifying the port option.

```
docker run --name mysql-server -d bitnami/mariadb --port=4000
```

### my.cnf

Map a volume on your host to `/config` with your custom `my.cnf` inside it, to configure MariaDB.

If the volume is empty, the default configuration will be copied to your volume.

### MySQL root password

To specify a custom password, you can pass the `MYSQL_PASSWORD` environment variable when run with
an empty data volume. This will initialize the database with your chosen password.

## Logging

The container is set up to log to stdout, which means logs can be obtained as follows:
```
docker logs mysql-server
```
