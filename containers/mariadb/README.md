# Bitnami MariaDB Docker Stack

## Usage

### Running a MySQL server
```
docker run --name mysql-server \
  -v /my-data:/data \
  -v /my-conf:/conf \
  -d bitnami/mariadb
```

### Running the MySQL client
```
docker run -it --link mysql-server:mysql bitnami/mariadb mysql -h mysql -P 3306 -u root -p
```

## Persistence

Map a volume on your host to `/data` to persist your database when the container is removed.

If the volume is empty, the database will be initialized in your volume and the root password will
be printed to stdout.

## Configuration

### Pass custom arguments/flags to mysqld

For example, you can run the server on a different port by specifying the port option.

```
docker run --name mysql-server -d bitnami/mariadb --port=4000
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

If you would like to log to a file instead, you can mount a volume at `/logs`.
