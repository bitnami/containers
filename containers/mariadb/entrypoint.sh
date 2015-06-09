#!/bin/bash
set -e
source /bitnami-utils.sh
SERVICE_USER=mysql

program_options(){
  echo "--defaults-file=$BITNAMI_APP_DIR/my.cnf --log-error=$BITNAMI_APP_DIR/logs/mysqld.log --basedir=$BITNAMI_APP_DIR --datadir=$BITNAMI_APP_DIR/data --plugin-dir=$BITNAMI_APP_DIR/lib/plugin --user=$SERVICE_USER --socket=$BITNAMI_APP_DIR/tmp/mysql.sock --lower-case-table-names=1 $EXTRA_OPTIONS"
}

# if command starts with an option, prepend mysqld
if [ "${1:0:1}" = '-' ]; then
  EXTRA_OPTIONS="$@"
  set -- mysqld.bin
fi

if [ ! "$(ls -A /conf)" ]; then
  generate_conf_files
fi

if [ "$1" = 'mysqld.bin' ]; then
  set -- $@ `program_options`
  mkdir -p $BITNAMI_APP_DIR/tmp
  chown -R $SERVICE_USER:$SERVICE_USER $BITNAMI_APP_DIR/tmp

  if [ ! "$(ls -A /data)" ]; then
    if [ -z "$MYSQL_PASSWORD" ]; then
      MYSQL_PASSWORD=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c12)
    fi

    echo "Initializing MySQL database..."
    echo ""

    $BITNAMI_APP_DIR/scripts/mysql_install_db --port=3306 --socket=$BITNAMI_APP_DIR/tmp/mysql.sock --basedir=$BITNAMI_APP_DIR --datadir=$BITNAMI_APP_DIR/data > /dev/null
    chown -R $SERVICE_USER:$SERVICE_USER $BITNAMI_APP_DIR/data

    echo "UPDATE mysql.user SET Password=PASSWORD('$MYSQL_PASSWORD') WHERE User='root';" >> /tmp/init_mysql.sql
    echo "FLUSH PRIVILEGES;" >> /tmp/init_mysql.sql
    echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' WITH GRANT OPTION;" >> /tmp/init_mysql.sql

    if [ "$MYSQL_DATABASE" ]; then
      echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;" >> /tmp/init_mysql.sql
    fi

    set -- "$@" --init-file=/tmp/init_mysql.sql

    print_app_credentials $BITNAMI_APP_NAME root $MYSQL_PASSWORD
  else
    print_container_already_initialized $BITNAMI_APP_NAME
  fi

  chown -R $SERVICE_USER:$SERVICE_USER $BITNAMI_APP_DIR/logs
fi

exec "$@"
