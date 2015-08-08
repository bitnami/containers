# PostgreSQL Utility functions
PROGRAM_OPTIONS="-D $BITNAMI_APP_DIR/data --config_file=$BITNAMI_APP_DIR/data/postgresql.conf"

initialize_database() {
  echo "==> Initializing PostgreSQL database..."
  echo ""
  gosu $BITNAMI_APP_USER $BITNAMI_APP_DIR/bin/initdb -D $BITNAMI_APP_DIR/data \
    -U $BITNAMI_APP_USER -E unicode -A trust >/dev/null

  echo "==> Configuring PostgreSQL to listen on all interfaces..."
  echo ""
  cat >> $BITNAMI_APP_DIR/data/postgresql.conf <<EOF
listen_addresses='*'
EOF

  echo "==> Enabling remote connections to PostgreSQL server..."
  echo ""
  cat >> $BITNAMI_APP_DIR/data/pg_hba.conf <<EOF
host    all             all             0.0.0.0/0               md5
EOF

  chown -R $BITNAMI_APP_USER:$BITNAMI_APP_USER $BITNAMI_APP_DIR/data
}

create_custom_database() {
  if [ "$POSTGRESQL_DATABASE" ]; then
    echo "==> Creating database $POSTGRESQL_DATABASE..."
    echo ""
    echo "CREATE DATABASE $POSTGRESQL_DATABASE;" | \
      gosu $BITNAMI_APP_USER $BITNAMI_APP_DIR/bin/postgres --single $PROGRAM_OPTIONS >/dev/null
  fi
}

create_postgresql_user() {
  if [ ! "$POSTGRESQL_USER" ]; then
    POSTGRESQL_USER=postgres
  fi

  if [ "$POSTGRESQL_USER" != "postgres" ] && [ ! $POSTGRESQL_DATABASE ]; then
    echo "In order to use a custom POSTGRESQL_USER you need to provide the POSTGRESQL_DATABASE as well"
    echo ""
    exit -1
  fi

  if [ "$POSTGRESQL_USER" = postgres ]; then
    echo "==> Creating postgres user with unrestricted access..."
    echo "ALTER ROLE $POSTGRESQL_USER WITH PASSWORD '$POSTGRESQL_PASSWORD';" | \
      gosu $BITNAMI_APP_USER $BITNAMI_APP_DIR/bin/postgres --single $PROGRAM_OPTIONS >/dev/null
  else
    echo "==> Creating user $POSTGRESQL_USER..."
    echo ""
    echo "CREATE ROLE $POSTGRESQL_USER WITH LOGIN CREATEDB PASSWORD '$POSTGRESQL_PASSWORD';" | \
      gosu $BITNAMI_APP_USER $BITNAMI_APP_DIR/bin/postgres --single $PROGRAM_OPTIONS >/dev/null

    echo "==> Granting access to $POSTGRESQL_USER to the database $POSTGRESQL_DATABASE..."
    echo ""
    echo "GRANT ALL PRIVILEGES ON DATABASE $POSTGRESQL_DATABASE to $POSTGRESQL_USER;" | \
      gosu $BITNAMI_APP_USER $BITNAMI_APP_DIR/bin/postgres --single $PROGRAM_OPTIONS >/dev/null
  fi
}

print_postgresql_password() {
  if [ -z $POSTGRESQL_PASSWORD ]; then
    echo "**none**"
  else
    echo $POSTGRESQL_PASSWORD
  fi
}

print_postgresql_database() {
 if [ $POSTGRESQL_DATABASE ]; then
  echo "Database: $POSTGRESQL_DATABASE"
 fi
}
