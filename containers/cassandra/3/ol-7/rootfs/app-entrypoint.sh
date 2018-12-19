#!/bin/bash -e

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page

if [[ "$1" == "nami" && "$2" == "start" ]] || [[ "$1" == "/run.sh" ]]; then
  # Copy mounted configuration files
  PERSIST_CONF_DIR=/bitnami/cassandra/conf
  CONF_DIR=/opt/bitnami/cassandra/conf
  if [[ -d "$PERSIST_CONF_DIR" ]]; then
    mkdir -p $CONF_DIR
    cp $PERSIST_CONF_DIR/* $CONF_DIR 
  fi

  nami_initialize cassandra
  info "Starting cassandra... "
fi

exec tini -- "$@"
