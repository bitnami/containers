#!/bin/bash -e

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page

if [[ "$1" == "nami" && "$2" == "start" ]] || [[ "$1" == "/run.sh" ]]; then
  # Copy mounted configuration files
  PERSIST_CONF_DIR=/bitnami/postgresql/conf
  CONF_DIR=/opt/bitnami/postgresql/conf
  if [[ -d "$PERSIST_CONF_DIR" ]]; then
    mkdir -p $CONF_DIR
    cp -r $PERSIST_CONF_DIR/. $CONF_DIR
  fi

  if ! getent passwd "$(id -u)" &> /dev/null && [ -e /usr/lib/libnss_wrapper.so ]; then
    export LD_PRELOAD='/usr/lib/libnss_wrapper.so'
    # shellcheck disable=SC2155
    export NSS_WRAPPER_PASSWD="$(mktemp)"
    # shellcheck disable=SC2155
    export NSS_WRAPPER_GROUP="$(mktemp)"
    echo "postgres:x:$(id -u):$(id -g):PostgreSQL:$PGDATA:/bin/false" > "$NSS_WRAPPER_PASSWD"
    echo "postgres:x:$(id -g):" > "$NSS_WRAPPER_GROUP"
  fi

  if [[ -n $POSTGRESQL_PASSWORD_FILE ]]; then
      declare PASSWORD_AUX
      PASSWORD_AUX="$(< "${POSTGRESQL_PASSWORD_FILE}")"
      export POSTGRESQL_PASSWORD=$PASSWORD_AUX
  fi

  if [[ -n $POSTGRESQL_REPLICATION_PASSWORD_FILE ]]; then
      declare REPLICATION_PASSWORD_AUX
      REPLICATION_PASSWORD_AUX="$(< "${POSTGRESQL_REPLICATION_PASSWORD_FILE}")"
      export POSTGRESQL_REPLICATION_PASSWORD=$REPLICATION_PASSWORD_AUX
  fi

  declareEnvironmentVariableAlias() {
      if env | grep -q "$2"; then
          export $1="${!2}"
      fi
  }

  # Alias created for official postgre image compatibility
  declareEnvironmentVariableAlias POSTGRESQL_PASSWORD POSTGRES_PASSWORD
  declareEnvironmentVariableAlias POSTGRESQL_DATABASE POSTGRES_DB
  declareEnvironmentVariableAlias POSTGRESQL_USERNAME POSTGRES_USER
  declareEnvironmentVariableAlias POSTGRESQL_DATA_DIR PGDATA
  declareEnvironmentVariableAlias POSTGRESQL_INITDB_WALDIR POSTGRES_INITDB_WALDIR
  declareEnvironmentVariableAlias POSTGRESQL_INITDB_ARGS POSTGRES_INITDB_ARGS

  # Alias created for maintain consistency using prefix
  declareEnvironmentVariableAlias POSTGRESQL_CLUSTER_APP_NAME POSTGRES_CLUSTER_APP_NAME
  declareEnvironmentVariableAlias POSTGRESQL_MASTER_HOST POSTGRES_MASTER_HOST
  declareEnvironmentVariableAlias POSTGRESQL_MASTER_PORT_NUMBER POSTGRES_MASTER_PORT_NUMBER
  declareEnvironmentVariableAlias POSTGRESQL_NUM_SYNCHRONOUS_REPLICAS POSTGRES_NUM_SYNCHRONOUS_REPLICAS
  declareEnvironmentVariableAlias POSTGRESQL_PORT_NUMBER POSTGRES_PORT_NUMBER
  declareEnvironmentVariableAlias POSTGRESQL_REPLICATION_MODE POSTGRES_REPLICATION_MODE
  declareEnvironmentVariableAlias POSTGRESQL_REPLICATION_PASSWORD POSTGRES_REPLICATION_PASSWORD
  declareEnvironmentVariableAlias POSTGRESQL_REPLICATION_USER POSTGRES_REPLICATION_USER
  declareEnvironmentVariableAlias POSTGRESQL_SYNCHRONOUS_COMMIT_MODE POSTGRES_SYNCHRONOUS_COMMIT_MODE
  declareEnvironmentVariableAlias POSTGRESQL_PASSWORD_FILE POSTGRES_PASSWORD_FILE
  declareEnvironmentVariableAlias POSTGRESQL_REPLICATION_PASSWORD_FILE POSTGRES_REPLICATION_PASSWORD_FILE

  nami_initialize postgresql
  info "Starting postgresql... "
fi

exec tini -- "$@"
