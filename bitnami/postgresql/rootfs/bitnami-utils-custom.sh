# PostgreSQL Utility functions
PROGRAM_OPTIONS="-D $BITNAMI_APP_DIR/data --config_file=$BITNAMI_APP_DIR/conf/postgresql.conf --hba_file=$BITNAMI_APP_DIR/conf/pg_hba.conf --ident_file=$BITNAMI_APP_DIR/conf/pg_ident.conf"

initialize_replication_parameters() {
  if [ "$POSTGRESQL_REPLICATION_MODE" == "slave" ]; then
    echo "==> Trying to fetch replication parameters from the master link..."
    echo ""
    POSTGRESQL_MASTER_HOST=${POSTGRESQL_MASTER_HOST:-$MASTER_PORT_5432_TCP_ADDR}
    POSTGRESQL_MASTER_PORT=${POSTGRESQL_MASTER_PORT:-$MASTER_PORT_5432_TCP_PORT}
    POSTGRESQL_REPLICATION_USER=${POSTGRESQL_REPLICATION_USER:-$MASTER_ENV_POSTGRESQL_REPLICATION_USER}
    POSTGRESQL_REPLICATION_PASSWORD=${POSTGRESQL_REPLICATION_PASSWORD:-$MASTER_ENV_POSTGRESQL_REPLICATION_PASSWORD}

    if [ ! $POSTGRESQL_MASTER_HOST ]; then
      echo "In order to setup a replication slave you need to provide the POSTGRESQL_MASTER_HOST as well"
      echo ""
      exit -1
    fi

    if [ ! $POSTGRESQL_MASTER_PORT ]; then
      echo "POSTGRESQL_MASTER_PORT not specified. Defaulting to 5432"
      echo ""
      POSTGRESQL_MASTER_PORT=${POSTGRESQL_MASTER_PORT:-5432}
    fi

    if [ ! $POSTGRESQL_REPLICATION_USER ]; then
      echo "In order to setup a replication slave you need to provide the POSTGRESQL_REPLICATION_USER as well"
      echo ""
      exit -1
    fi

    if [ ! $POSTGRESQL_REPLICATION_PASSWORD ]; then
      echo "In order to setup a replication slave you need to provide the POSTGRESQL_REPLICATION_PASSWORD as well"
      echo ""
      exit -1
    fi
  fi
}

initialize_database() {
  chmod 0700 $BITNAMI_APP_DIR/data
  chown -R $BITNAMI_APP_USER:$BITNAMI_APP_USER $BITNAMI_APP_DIR/data
  case "$POSTGRESQL_REPLICATION_MODE" in
    slave)
      echo "==> Waiting for replication master to accept connections (60s timeout)..."
      timeout=60
      while ! $BITNAMI_APP_DIR/bin/pg_isready -h $POSTGRESQL_MASTER_HOST -p $POSTGRESQL_MASTER_PORT -t 1 >/dev/null 2>&1
      do
        timeout=$(expr $timeout - 1)
        if [[ $timeout -eq 0 ]]; then
          echo "Could not connect to replication master"
          echo ""
          exit -1
        fi
        sleep 1
      done
      echo ""

      echo "==> Replicating the initial database..."
      echo ""
      sudo -Hu $BITNAMI_APP_USER \
        PGPASSWORD=$POSTGRESQL_REPLICATION_PASSWORD $BITNAMI_APP_DIR/bin/pg_basebackup -D $BITNAMI_APP_DIR/data \
        -h ${POSTGRESQL_MASTER_HOST} -p ${POSTGRESQL_MASTER_PORT} -U ${POSTGRESQL_REPLICATION_USER} -X stream -w -v -P >/dev/null 2>&1
      ;;
    master|*)
      echo "==> Initializing database..."
      echo ""
      s6-setuidgid $BITNAMI_APP_USER $BITNAMI_APP_DIR/bin/initdb -D $BITNAMI_APP_DIR/data \
        -U $BITNAMI_APP_USER -E unicode -A trust >/dev/null
      ;;
  esac
  rm -rf $BITNAMI_APP_DIR/data/{pg_hba.conf,pg_ident.conf,postgresql.conf}

  case "$POSTGRESQL_REPLICATION_MODE" in
    master|slave)
      echo "==> Setting up streaming replication..."
      echo ""
      s6-setuidgid $BITNAMI_APP_USER sed -i "s|^[#]*[ ]*wal_level = .*|wal_level = hot_standby|" $BITNAMI_APP_DIR/conf/postgresql.conf
      s6-setuidgid $BITNAMI_APP_USER sed -i "s|^[#]*[ ]*max_wal_senders = .*|max_wal_senders = 16|" $BITNAMI_APP_DIR/conf/postgresql.conf
      s6-setuidgid $BITNAMI_APP_USER sed -i "s|^[#]*[ ]*checkpoint_segments = .*|checkpoint_segments = 8|" $BITNAMI_APP_DIR/conf/postgresql.conf
      s6-setuidgid $BITNAMI_APP_USER sed -i "s|^[#]*[ ]*wal_keep_segments = .*|wal_keep_segments = 32|" $BITNAMI_APP_DIR/conf/postgresql.conf
      s6-setuidgid $BITNAMI_APP_USER sed -i "s|^[#]*[ ]*hot_standby = .*|hot_standby = on|" $BITNAMI_APP_DIR/conf/postgresql.conf
      ;;
  esac
}

create_custom_database() {
  if [ "$POSTGRESQL_REPLICATION_MODE" != "slave" ]; then
    if [ "$POSTGRESQL_DATABASE" ]; then
      echo "==> Creating database $POSTGRESQL_DATABASE..."
      echo ""
      echo "CREATE DATABASE \"$POSTGRESQL_DATABASE\";" | \
        s6-setuidgid $BITNAMI_APP_USER $BITNAMI_APP_DIR/bin/postgres --single $PROGRAM_OPTIONS >/dev/null
    fi
  fi
}

create_postgresql_user() {
  if [ "$POSTGRESQL_REPLICATION_MODE" != "slave" ]; then
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
        s6-setuidgid $BITNAMI_APP_USER $BITNAMI_APP_DIR/bin/postgres --single $PROGRAM_OPTIONS >/dev/null
    else
      echo "==> Creating user $POSTGRESQL_USER..."
      echo ""
      echo "CREATE ROLE \"$POSTGRESQL_USER\" WITH LOGIN CREATEDB PASSWORD '$POSTGRESQL_PASSWORD';" | \
        s6-setuidgid $BITNAMI_APP_USER $BITNAMI_APP_DIR/bin/postgres --single $PROGRAM_OPTIONS >/dev/null

      echo "==> Granting access to $POSTGRESQL_USER to the database $POSTGRESQL_DATABASE..."
      echo ""
      echo "GRANT ALL PRIVILEGES ON DATABASE \"$POSTGRESQL_DATABASE\" to \"$POSTGRESQL_USER\";" | \
        s6-setuidgid $BITNAMI_APP_USER $BITNAMI_APP_DIR/bin/postgres --single $PROGRAM_OPTIONS >/dev/null
    fi
  fi
}

create_replication_user() {
  case "$POSTGRESQL_REPLICATION_MODE" in
    master|slave)
      if [ ! $POSTGRESQL_REPLICATION_USER ]; then
        echo "In order to setup a replication master you need to provide the POSTGRESQL_REPLICATION_USER as well"
        echo ""
        exit -1
      fi

      if [ ! $POSTGRESQL_REPLICATION_PASSWORD ]; then
        echo "In order to setup a replication master you need to provide the POSTGRESQL_REPLICATION_PASSWORD as well"
        echo ""
        exit -1
      fi

      if [ "$POSTGRESQL_REPLICATION_MODE" == "master" ]; then
        echo "==> Creating replication user $POSTGRESQL_REPLICATION_USER..."
        echo ""

        echo "CREATE ROLE \"$POSTGRESQL_REPLICATION_USER\" REPLICATION LOGIN ENCRYPTED PASSWORD '$POSTGRESQL_REPLICATION_PASSWORD';" | \
          s6-setuidgid $BITNAMI_APP_USER $BITNAMI_APP_DIR/bin/postgres --single $PROGRAM_OPTIONS >/dev/null
      fi

      cat >> $BITNAMI_APP_DIR/conf/pg_hba.conf <<EOF
host    replication     $POSTGRESQL_REPLICATION_USER       0.0.0.0/0               md5
EOF
      ;;
  esac
}

configure_replication_slave() {
  if [ "$POSTGRESQL_REPLICATION_MODE" == "slave" ]; then
    echo "==> Setting up streaming replication slave..."
    echo ""
    if [ ! -f $BITNAMI_APP_DIR/data/recovery.conf ]; then
      s6-setuidgid $BITNAMI_APP_USER cp $BITNAMI_APP_DIR/share/recovery.conf.sample $BITNAMI_APP_DIR/data/recovery.conf
    fi
    s6-setuidgid $BITNAMI_APP_USER sed -i "s|^[#]*[ ]*standby_mode = .*|standby_mode = on|" $BITNAMI_APP_DIR/data/recovery.conf
    s6-setuidgid $BITNAMI_APP_USER sed -i "s|^[#]*[ ]*primary_conninfo = .*|primary_conninfo = 'host=${POSTGRESQL_MASTER_HOST} port=${POSTGRESQL_MASTER_PORT} user=${POSTGRESQL_REPLICATION_USER} password=${POSTGRESQL_REPLICATION_PASSWORD}'|" $BITNAMI_APP_DIR/data/recovery.conf
    s6-setuidgid $BITNAMI_APP_USER sed -i "s|^[#]*[ ]*trigger_file = .*|trigger_file = '/tmp/postgresql.trigger.5432'|" $BITNAMI_APP_DIR/data/recovery.conf
  fi
}

print_postgresql_password() {
  case "$POSTGRESQL_REPLICATION_MODE" in
    slave)
      echo "**replication**"
      ;;
    master|*)
      if [ -z $POSTGRESQL_PASSWORD ]; then
        echo "**none**"
      else
        echo $POSTGRESQL_PASSWORD
      fi
      ;;
  esac
}

print_postgresql_database() {
  case "$POSTGRESQL_REPLICATION_MODE" in
    slave)
      echo "**replication**"
      ;;
    master|*)
      if [ $POSTGRESQL_DATABASE ]; then
        echo "Database: $POSTGRESQL_DATABASE"
      fi
      ;;
  esac
}
