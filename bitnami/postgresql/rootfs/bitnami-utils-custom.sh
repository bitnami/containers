# PostgreSQL Utility functions
PROGRAM_OPTIONS="-D $BITNAMI_APP_DIR/data --config_file=$BITNAMI_APP_DIR/conf/postgresql.conf --hba_file=$BITNAMI_APP_DIR/conf/pg_hba.conf --ident_file=$BITNAMI_APP_DIR/conf/pg_ident.conf"

POSTGRES_MODE=${POSTGRES_MODE:-master}

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
  case $POSTGRES_MODE in
    master) ;;
    slave)
      echo "==> Trying to fetch replication parameters exposed by docker links..."
      echo ""

      POSTGRES_MASTER_HOST=${POSTGRES_MASTER_HOST:-$MASTER_PORT_5432_TCP_ADDR}
      POSTGRES_MASTER_PORT=${POSTGRES_MASTER_PORT:-$MASTER_PORT_5432_TCP_PORT}
      POSTGRES_REPLICATION_USER=${POSTGRES_REPLICATION_USER:-$MASTER_ENV_POSTGRES_REPLICATION_USER}
      POSTGRES_REPLICATION_PASSWORD=${POSTGRES_REPLICATION_PASSWORD:-$MASTER_ENV_POSTGRES_REPLICATION_PASSWORD}

      if [ ! $POSTGRES_MASTER_HOST ]; then
        echo "In order to setup a replication slave you need to provide the POSTGRES_MASTER_HOST as well"
        echo ""
        exit -1
      fi

      if [ ! $POSTGRES_MASTER_PORT ]; then
        echo "POSTGRES_MASTER_PORT not specified. Defaulting to 5432"
        echo ""
        POSTGRES_MASTER_PORT=${POSTGRES_MASTER_PORT:-5432}
      fi

      if [ ! $POSTGRES_REPLICATION_USER ]; then
        echo "In order to setup a replication slave you need to provide the POSTGRES_REPLICATION_USER as well"
        echo ""
        exit -1
      fi

      if [ ! $POSTGRES_REPLICATION_PASSWORD ]; then
        echo "In order to setup a replication slave you need to provide the POSTGRES_REPLICATION_PASSWORD as well"
        echo ""
        exit -1
      fi
      ;;
    *)
      echo "Replication mode \"$POSTGRES_MODE\" not supported!"
      echo ""
      exit -1
      ;;
  esac
}

initialize_database() {
  case "$POSTGRES_MODE" in
    master)
      echo "==> Initializing database..."
      echo ""
      s6-setuidgid $BITNAMI_APP_USER $BITNAMI_APP_DIR/bin/initdb -D $BITNAMI_APP_DIR/data \
        -U $BITNAMI_APP_USER -E unicode -A trust >/dev/null
      ;;
    slave)
      echo "==> Waiting for replication master to accept connections (60s timeout)..."
      echo ""
      timeout=60
      while ! $BITNAMI_APP_DIR/bin/pg_isready -h $POSTGRES_MASTER_HOST -p $POSTGRES_MASTER_PORT -t 1 >/dev/null 2>&1
      do
        timeout=$(expr $timeout - 1)
        if [[ $timeout -eq 0 ]]; then
          echo "Could not connect to replication master"
          echo ""
          exit -1
        fi
        sleep 1
      done

      echo "==> Replicating the initial database..."
      echo ""
      sudo -Hu $BITNAMI_APP_USER \
        PGPASSWORD=$POSTGRES_REPLICATION_PASSWORD $BITNAMI_APP_DIR/bin/pg_basebackup -D $BITNAMI_APP_DIR/data \
          -h ${POSTGRES_MASTER_HOST} -p ${POSTGRES_MASTER_PORT} -U ${POSTGRES_REPLICATION_USER} -X stream -w -v -P >/dev/null 2>&1
      ;;
  esac
  rm -rf $BITNAMI_APP_DIR/data/{pg_hba.conf,pg_ident.conf,postgresql.conf}
}

create_custom_database() {
  if [ "$POSTGRES_MODE" == "master" ]; then
    if [ "$POSTGRES_DB" ]; then
      echo "==> Creating database $POSTGRES_DB..."
      echo ""
      echo "CREATE DATABASE \"$POSTGRES_DB\";" | \
        s6-setuidgid $BITNAMI_APP_USER $BITNAMI_APP_DIR/bin/postgres --single $PROGRAM_OPTIONS >/dev/null
    fi
  fi
}

create_postgresql_user() {
  if [ "$POSTGRES_MODE" == "master" ]; then
    POSTGRES_USER=${POSTGRES_USER:-$BITNAMI_APP_USER}
    if [ "$POSTGRES_USER" != "$BITNAMI_APP_USER" ]; then
      if [ ! $POSTGRES_PASSWORD ]; then
        echo "In order to use a custom POSTGRES_USER you need to provide the POSTGRES_PASSWORD as well"
        echo ""
        exit -1
      fi

      if [ ! $POSTGRES_DB ]; then
        echo "In order to use a custom POSTGRES_USER you need to provide the POSTGRES_DB as well"
        echo ""
        exit -1
      fi
    fi

    if [ "$POSTGRES_USER" = $BITNAMI_APP_USER ]; then
      echo "==> Creating $BITNAMI_APP_USER user with unrestricted access..."
      echo "ALTER ROLE $POSTGRES_USER WITH PASSWORD '$POSTGRES_PASSWORD';" | \
        s6-setuidgid $BITNAMI_APP_USER $BITNAMI_APP_DIR/bin/postgres --single $PROGRAM_OPTIONS >/dev/null
    else
      echo "==> Creating user $POSTGRES_USER..."
      echo ""
      echo "CREATE ROLE \"$POSTGRES_USER\" WITH LOGIN CREATEDB PASSWORD '$POSTGRES_PASSWORD';" | \
        s6-setuidgid $BITNAMI_APP_USER $BITNAMI_APP_DIR/bin/postgres --single $PROGRAM_OPTIONS >/dev/null

      echo "==> Granting access to $POSTGRES_USER to the database $POSTGRES_DB..."
      echo ""
      echo "GRANT ALL PRIVILEGES ON DATABASE \"$POSTGRES_DB\" to \"$POSTGRES_USER\";" | \
        s6-setuidgid $BITNAMI_APP_USER $BITNAMI_APP_DIR/bin/postgres --single $PROGRAM_OPTIONS >/dev/null
    fi
  fi
}

create_replication_user() {
  if [ "$POSTGRES_MODE" == "master" ]; then
    if [ "$POSTGRES_REPLICATION_USER" ]; then
      if [ ! $POSTGRES_REPLICATION_PASSWORD ]; then
        echo "In order to create a replication user you need to provide the POSTGRES_REPLICATION_PASSWORD as well"
        echo ""
        exit -1
      fi

      echo "==> Creating replication user $POSTGRES_REPLICATION_USER..."
      echo ""
      echo "CREATE ROLE \"$POSTGRES_REPLICATION_USER\" REPLICATION LOGIN ENCRYPTED PASSWORD '$POSTGRES_REPLICATION_PASSWORD';" | \
        s6-setuidgid $BITNAMI_APP_USER $BITNAMI_APP_DIR/bin/postgres --single $PROGRAM_OPTIONS >/dev/null
    fi
  fi
}

configure_recovery() {
  if [ "$POSTGRES_MODE" == "slave" ]; then
    echo "==> Setting up streaming replication slave..."
    echo ""

    s6-setuidgid $BITNAMI_APP_USER cp -a $BITNAMI_APP_DIR/share/recovery.conf.sample $BITNAMI_APP_DIR/data/recovery.conf
    set_recovery_param "standby_mode" "on"
    set_recovery_param "primary_conninfo" "host=${POSTGRES_MASTER_HOST} port=${POSTGRES_MASTER_PORT} user=${POSTGRES_REPLICATION_USER} password=${POSTGRES_REPLICATION_PASSWORD}"
    set_recovery_param "trigger_file" "/tmp/postgresql.trigger.5432"
  fi
}

print_postgresql_password() {
  case "$POSTGRES_MODE" in
    master)
      if [ -z $POSTGRES_PASSWORD ]; then
        echo "**none**"
      else
        echo $POSTGRES_PASSWORD
      fi
      ;;
    slave)
      echo "**replication**"
      ;;
  esac
}

print_postgresql_database() {
  case "$POSTGRES_MODE" in
    master)
      if [ $POSTGRES_DB ]; then
        echo "Database: $POSTGRES_DB"
      fi
      ;;
    slave)
      echo "**replication**"
      ;;
  esac
}
