# PostgreSQL Utility functions
PROGRAM_OPTIONS="-D $BITNAMI_APP_DIR/data --config_file=$BITNAMI_APP_DIR/conf/postgresql.conf --hba_file=$BITNAMI_APP_DIR/conf/pg_hba.conf --ident_file=$BITNAMI_APP_DIR/conf/pg_ident.conf"

POSTGRESQL_REPLICATION_MODE=${POSTGRESQL_REPLICATION_MODE:-master}

set_pg_param() {
  local key=${1}
  local value=${2}

  if [[ -n ${value} ]]; then
    local current=$(sed -n -e "s/^\(${key} = '\)\([^ ']*\)\(.*\)$/\2/p" $BITNAMI_APP_DIR/conf/postgresql.conf)
    if [[ "${current}" != "${value}" ]]; then
      value="$(echo "${value}" | sed 's|[&]|\\&|g')"
      s6-setuidgid $BITNAMI_APP_USER sed -i "s|^[#]*[ ]*${key} = .*|${key} = '${value}'|" $BITNAMI_APP_DIR/conf/postgresql.conf
    fi
  fi
}

set_hba_param() {
  local value=${1}
  if ! grep -q "$(sed "s| | \\\+|g" <<< ${value})" $BITNAMI_APP_DIR/conf/pg_hba.conf; then
    echo "${value}" >> $BITNAMI_APP_DIR/conf/pg_hba.conf
  fi
}

set_recovery_param() {
  local key=${1}
  local value=${2}

  if [[ -n ${value} ]]; then
    local current=$(sed -n -e "s/^\(${key} = '\)\([^ ']*\)\(.*\)$/\2/p" $BITNAMI_APP_DIR/data/recovery.conf)
    if [[ "${current}" != "${value}" ]]; then
      value="$(echo "${value}" | sed 's|[&]|\\&|g')"
      s6-setuidgid $BITNAMI_APP_USER sed -i "s|^[#]*[ ]*${key} = .*|${key} = '${value}'|" $BITNAMI_APP_DIR/data/recovery.conf
    fi
  fi
}

discover_replication_parameters() {
  case $POSTGRESQL_REPLICATION_MODE in
    master) ;;
    slave)
      echo "==> Trying to fetch replication parameters exposed by docker links..."
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
      ;;
    *)
      echo "Replication mode \"$POSTGRESQL_REPLICATION_MODE\" not supported!"
      echo ""
      exit -1
      ;;
  esac
}

initialize_database() {
  case "$POSTGRESQL_REPLICATION_MODE" in
    master)
      echo "==> Initializing database..."
      echo ""
      s6-setuidgid $BITNAMI_APP_USER $BITNAMI_APP_DIR/bin/initdb -D $BITNAMI_APP_DIR/data \
        -U $BITNAMI_APP_USER -E unicode -A trust >/dev/null
      ;;
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
  esac
  rm -rf $BITNAMI_APP_DIR/data/{pg_hba.conf,pg_ident.conf,postgresql.conf}

  echo "==> Setting up hot_standby..."
  echo ""
  set_pg_param "wal_level" "hot_standby"
  set_pg_param "max_wal_senders" "16"
  set_pg_param "checkpoint_segments" "8"
  set_pg_param "wal_keep_segments" "32"
  set_pg_param "hot_standby" "on"
}

create_custom_database() {
  if [ "$POSTGRESQL_REPLICATION_MODE" == "master" ]; then
    if [ "$POSTGRESQL_DATABASE" ]; then
      echo "==> Creating database $POSTGRESQL_DATABASE..."
      echo ""
      echo "CREATE DATABASE \"$POSTGRESQL_DATABASE\";" | \
        s6-setuidgid $BITNAMI_APP_USER $BITNAMI_APP_DIR/bin/postgres --single $PROGRAM_OPTIONS >/dev/null
    fi
  fi
}

create_postgresql_user() {
  if [ "$POSTGRESQL_REPLICATION_MODE" == "master" ]; then
    POSTGRESQL_USER=${POSTGRESQL_USER:-postgres}
    if [ "$POSTGRESQL_USER" != "postgres" ]; then
      if [ ! $POSTGRESQL_PASSWORD ]; then
        echo "In order to use a custom POSTGRESQL_USER you need to provide the POSTGRESQL_PASSWORD as well"
        echo ""
        exit -1
      fi

      if [ ! $POSTGRESQL_DATABASE ]; then
        echo "In order to use a custom POSTGRESQL_USER you need to provide the POSTGRESQL_DATABASE as well"
        echo ""
        exit -1
      fi
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
  if [ "$POSTGRESQL_REPLICATION_USER" ]; then
    if [ ! $POSTGRESQL_REPLICATION_PASSWORD ]; then
      echo "In order to create a replication user you need to provide the POSTGRESQL_REPLICATION_PASSWORD as well"
      echo ""
      exit -1
    fi

    if [ "$POSTGRESQL_REPLICATION_MODE" == "master" ]; then
      echo ""
      echo "==> Creating replication user $POSTGRESQL_REPLICATION_USER..."
      echo "CREATE ROLE \"$POSTGRESQL_REPLICATION_USER\" REPLICATION LOGIN ENCRYPTED PASSWORD '$POSTGRESQL_REPLICATION_PASSWORD';" | \
        s6-setuidgid $BITNAMI_APP_USER $BITNAMI_APP_DIR/bin/postgres --single $PROGRAM_OPTIONS >/dev/null
    fi

    set_hba_param "host replication $POSTGRESQL_REPLICATION_USER 0.0.0.0/0 md5"
  fi
}

configure_recovery() {
  if [ "$POSTGRESQL_REPLICATION_MODE" == "slave" ]; then
    echo "==> Setting up streaming replication slave..."
    echo ""

    s6-setuidgid $BITNAMI_APP_USER cp -a $BITNAMI_APP_DIR/share/recovery.conf.sample $BITNAMI_APP_DIR/data/recovery.conf
    set_recovery_param "standby_mode" "on"
    set_recovery_param "primary_conninfo" "host=${POSTGRESQL_MASTER_HOST} port=${POSTGRESQL_MASTER_PORT} user=${POSTGRESQL_REPLICATION_USER} password=${POSTGRESQL_REPLICATION_PASSWORD}"
    set_recovery_param "trigger_file" "/tmp/postgresql.trigger.5432"
  fi
}

print_postgresql_password() {
  case "$POSTGRESQL_REPLICATION_MODE" in
    master)
      if [ -z $POSTGRESQL_PASSWORD ]; then
        echo "**none**"
      else
        echo $POSTGRESQL_PASSWORD
      fi
      ;;
    slave)
      echo "**replication**"
      ;;
  esac
}

print_postgresql_database() {
  case "$POSTGRESQL_REPLICATION_MODE" in
    master)
      if [ $POSTGRESQL_DATABASE ]; then
        echo "Database: $POSTGRESQL_DATABASE"
      fi
      ;;
    slave)
      echo "**replication**"
      ;;
  esac
}
