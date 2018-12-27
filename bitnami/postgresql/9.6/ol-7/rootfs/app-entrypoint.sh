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

  if ! getent passwd "$(id -u)" &> /dev/null && [ -e /usr/lib64/libnss_wrapper.so ]; then
    export LD_PRELOAD='/usr/lib64/libnss_wrapper.so'
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

  nami_initialize postgresql
  info "Starting postgresql... "
fi

exec tini -- "$@"
