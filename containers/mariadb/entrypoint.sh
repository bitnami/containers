#!/bin/bash

# if command starts with an option, prepend mysqld
if [ "${1:0:1}" = '-' ]; then
  EXTRA_OPTIONS=" $@"
  set -- mysqld.bin
fi

if [ ! "$(ls -A /conf)" ]; then
  echo "Copying default configuration to /conf/my.cnf..."
  echo ""
  cp -r /opt/bitnami/mysql/conf.defaults/* /opt/bitnami/mysql/conf
fi

if [ "$1" = 'mysqld.bin' ]; then
  set -- "$@" --defaults-file=/opt/bitnami/mysql/my.cnf --log-error=/opt/bitnami/mysql/logs/mysqld.log --basedir=/opt/bitnami/mysql --datadir=/opt/bitnami/mysql/data --plugin-dir=/opt/bitnami/mysql/lib/plugin --user=mysql --socket=/opt/bitnami/mysql/tmp/mysql.sock$EXTRA_OPTIONS

  if [ ! "$(ls -A /data)" ]; then
    if [ -z "$MYSQL_PASSWORD" ]; then
      MYSQL_PASSWORD=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c12)
    fi

    echo "Initializing MySQL database..."
    echo ""
    echo "#########################################################################"
    echo "#                                                                       #"
    echo "#             Setting MySQL root password to '${MYSQL_PASSWORD}'             #"
    echo "#                                                                       #"
    echo "#########################################################################"
    echo ""

    chown mysql:mysql /data
    su mysql -c "sh /opt/bitnami/mysql/scripts/myscript.sh /opt/bitnami/mysql $MYSQL_PASSWORD"
    /opt/bitnami/mysql/scripts/ctl.sh stop mysql > /dev/null
  fi

  chown mysql:mysql -R /opt/bitnami/mysql/logs
fi

exec "$@"
