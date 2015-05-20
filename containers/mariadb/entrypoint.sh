#!/bin/bash

# if command starts with an option, prepend mysqld
if [ "${1:0:1}" = '-' ]; then
  EXTRA_OPTIONS=" $@"
  set -- mysqld.bin
fi


if [ "$1" = 'mysqld.bin' ]; then
  set -- "$@" --defaults-file=/opt/bitnami/mysql/my.cnf --basedir=/opt/bitnami/mysql --datadir=/opt/bitnami/mysql/data --plugin-dir=/opt/bitnami/mysql/lib/plugin --user=mysql --socket=/opt/bitnami/mysql/tmp/mysql.sock$EXTRA_OPTIONS

  if [ ! "$(ls -A /data)" ]; then
    su mysql -c "sh /opt/bitnami/mysql/scripts/myscript.sh /opt/bitnami/mysql bitnami"
    /opt/bitnami/mysql/scripts/ctl.sh stop mysql > /dev/null
  fi
fi

exec "$@"
