# MariaDB Utility functions
PROGRAM_OPTIONS="--defaults-file=$BITNAMI_APP_DIR/my.cnf --log-error=$BITNAMI_APP_DIR/logs/mysqld.log --basedir=$BITNAMI_APP_DIR --datadir=$BITNAMI_APP_DIR/data --plugin-dir=$BITNAMI_APP_DIR/lib/plugin --user=$SERVICE_USER --socket=$BITNAMI_APP_DIR/tmp/mysql.sock --lower-case-table-names=1 $EXTRA_OPTIONS"

initialize_database() {
    echo "==> Initializing MySQL database..."
    echo ""
    $BITNAMI_APP_DIR/scripts/mysql_install_db --port=3306 --socket=$BITNAMI_APP_DIR/tmp/mysql.sock --basedir=$BITNAMI_APP_DIR --datadir=$BITNAMI_APP_DIR/data > /dev/null
    chown -R $SERVICE_USER:$SERVICE_USER $BITNAMI_APP_DIR/data
}

create_custom_database() {
  if [ "$MYSQL_DATABASE" ]; then
    echo "==> Creating database $MYSQL_DATABASE..."
    echo ""
    echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;" >> /tmp/init_mysql.sql
  fi
}

create_mysql_user() {
  if [ ! "$MYSQL_USER" ]; then
    MYSQL_USER=root
  fi

  if [ "$MYSQL_USER" != "root" ] && [ ! $MYSQL_DATABASE ]; then
    echo "In order to use a custom MYSQL_USER you need to provide the MYSQL_DATABASE as well"
    echo ""
    exit -1
  fi

  echo "==> Creating user $MYSQL_USER..."
  echo ""

  echo "DELETE FROM mysql.user ;" >> /tmp/init_mysql.sql
  echo "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}' ;" >> /tmp/init_mysql.sql

  if [ "$MYSQL_USER" = root ]; then
    echo "==> Creating root user with unrestricted access..."
    echo "GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION ;" >> /tmp/init_mysql.sql
  else
    echo "==> Granting acces to $MYSQL_USER to the database $MYSQL_DATABASE..."
    echo ""
    echo "GRANT ALL ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%' ;" >> /tmp/init_mysql.sql
  fi

  echo "FLUSH PRIVILEGES ;" >> /tmp/init_mysql.sql
}

print_mysql_password() {
  if [ -z $MYSQL_PASSWORD ]; then
    echo "**none**"
  else
    echo $MYSQL_PASSWORD
  fi
}

print_mysql_database() {
 if [ $MYSQL_DATABASE ]; then
  echo "Database: $MYSQL_DATABASE"
 fi
}
