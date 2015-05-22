#!/bin/bash

# if command starts with an option, prepend mysqld
if [ "${1:0:1}" = '-' ]; then
  EXTRA_OPTIONS="$@"
  set -- mysqld.bin
fi

if [ ! "$(ls -A /conf)" ]; then
  echo "Copying default configuration to /conf/my.cnf..."
  echo ""
  cp -r /opt/bitnami/mysql/conf.defaults/* /opt/bitnami/mysql/conf
fi

if [ "$1" = 'mysqld.bin' ]; then
  set -- "$@" --defaults-file=/opt/bitnami/mysql/my.cnf --log-error=/opt/bitnami/mysql/logs/mysqld.log --basedir=/opt/bitnami/mysql --datadir=/opt/bitnami/mysql/data --plugin-dir=/opt/bitnami/mysql/lib/plugin --user=mysql --socket=/opt/bitnami/mysql/tmp/mysql.sock "--lower-case-table-names=1" $EXTRA_OPTIONS

  if [ ! "$(ls -A /data)" ]; then
    if [ -z "$MYSQL_PASSWORD" ]; then
      MYSQL_PASSWORD=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c12)
    fi

    echo "#########################################################################"
    echo "#                                                                       #"
    echo "#             Setting MySQL root password to '${MYSQL_PASSWORD}'             #"
    echo "#                                                                       #"
    echo "#########################################################################"
    echo ""
    echo "Initializing MySQL database..."
    echo ""

    /opt/bitnami/mysql/scripts/mysql_install_db --port=3306 --socket=/opt/bitnami/mysql/tmp/mysql.sock --basedir=/opt/bitnami/mysql --datadir=/opt/bitnami/mysql/data > /dev/null
    chown -R mysql:mysql /opt/bitnami/mysql/data

    echo "UPDATE mysql.user SET Password=PASSWORD('$MYSQL_PASSWORD') WHERE User='root';" >> /tmp/init_mysql.sql
    echo "FLUSH PRIVILEGES;" >> /tmp/init_mysql.sql
    echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' WITH GRANT OPTION;" >> /tmp/init_mysql.sql

    if [ "$MYSQL_DATABASE" ]; then
      echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;" >> /tmp/init_mysql.sql
    fi

    set -- "$@" --init-file=/tmp/init_mysql.sql
  fi

  chown -R mysql:mysql /opt/bitnami/mysql/logs
fi

exec "$@"
