#!/bin/bash

# if command starts with an option, prepend mysqld
if [ "${1:0:1}" = '-' ]; then
  EXTRA_OPTIONS="$@"
  set -- mysqld.bin
fi

if [ ! "$(ls -A /conf)" ]; then
  echo "Copying default configuration to /conf/my.cnf..."
  echo ""
  cp -r /usr/local/bitnami/mysql/conf.defaults/* /usr/local/bitnami/mysql/conf
fi

if [ "$1" = 'mysqld.bin' ]; then
  set -- "$@" --defaults-file=/usr/local/bitnami/mysql/my.cnf --log-error=/usr/local/bitnami/mysql/logs/mysqld.log --basedir=/usr/local/bitnami/mysql --datadir=/usr/local/bitnami/mysql/data --plugin-dir=/usr/local/bitnami/mysql/lib/plugin --user=mysql --socket=/usr/local/bitnami/mysql/tmp/mysql.sock "--lower-case-table-names=1" $EXTRA_OPTIONS

  mkdir -p /usr/local/bitnami/mysql/tmp
  chown -R mysql:mysql /usr/local/bitnami/mysql/tmp

  if [ ! "$(ls -A /data)" ]; then
    if [ -z "$MYSQL_PASSWORD" ]; then
      MYSQL_PASSWORD=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c12)
      RANDOM_PASSW=1
    fi


    echo "Initializing MySQL database..."
    echo ""

    /usr/local/bitnami/mysql/scripts/mysql_install_db --port=3306 --socket=/usr/local/bitnami/mysql/tmp/mysql.sock --basedir=/usr/local/bitnami/mysql --datadir=/usr/local/bitnami/mysql/data > /dev/null
    chown -R mysql:mysql /usr/local/bitnami/mysql/data

    echo "UPDATE mysql.user SET Password=PASSWORD('$MYSQL_PASSWORD') WHERE User='root';" >> /tmp/init_mysql.sql
    echo "FLUSH PRIVILEGES;" >> /tmp/init_mysql.sql
    echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' WITH GRANT OPTION;" >> /tmp/init_mysql.sql

    if [ "$MYSQL_DATABASE" ]; then
      echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;" >> /tmp/init_mysql.sql
    fi

    set -- "$@" --init-file=/tmp/init_mysql.sql

    echo "#########################################################################"
    echo "#                                                                       #"
    echo "# Credentials for mariadb:                                              #"
    echo "# username: root                                                        #"
    echo "# password: $MYSQL_PASSWORD                                                #"
    echo "#                                                                       #"

    if [ $RANDOM_PASSW ]; then
      echo "# The password was generated automatically, if you want to use          #"
      echo "# your own password please set the MYSQL_PASSWORD environment           #"
      echo "# variable when running the container.                                  #"
      echo "#                                                                       #"
    fi
    echo "#########################################################################"
    echo ""
  else
    echo "#########################################################################"
    echo "#                                                                       #"
    echo "# Credentials for mariadb:                                              #"
    echo "# The MYSQL_PASSWORD was set on first boot.                             #"
    echo "# If you want to regenerate the password recreate this container.       #"
    echo "#                                                                       #"
    echo "#########################################################################"
    echo ""
  fi

  chown -R mysql:mysql /usr/local/bitnami/mysql/logs
fi

exec "$@"
