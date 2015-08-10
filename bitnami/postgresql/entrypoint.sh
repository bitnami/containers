#!/bin/bash
set -e
source $BITNAMI_PREFIX/bitnami-utils.sh

print_welcome_page

# if command starts with an option, prepend mysqld
if [ "${1:0:1}" = '-' ]; then
  EXTRA_OPTIONS="$@"
  set -- postgres
elif [ "${1}" == "postgres" -o "${1}" == "$BITNAMI_APP_DIR/bin/postgres" ]; then
  EXTRA_OPTIONS="${@:2}"
  set -- postgres
fi

if [ "$1" = 'postgres' ]; then
  set -- $@ $PROGRAM_OPTIONS $EXTRA_OPTIONS

  if [ ! -f $BITNAMI_APP_VOL_PREFIX/data/PG_VERSION ]; then
    export LD_LIBRARY_PATH=$BITNAMI_PREFIX/common/lib

    initialize_database

    create_custom_database

    create_postgresql_user

    print_app_credentials $BITNAMI_APP_NAME $POSTGRESQL_USER `print_postgresql_password` `print_postgresql_database`
  else
    print_container_already_initialized $BITNAMI_APP_NAME
  fi
  chown -R $BITNAMI_APP_USER:$BITNAMI_APP_USER \
    $BITNAMI_APP_VOL_PREFIX/data/ \
    $BITNAMI_APP_VOL_PREFIX/logs/ || true

  wait_and_tail_logs &
  exec gosu $BITNAMI_APP_USER "$@"
else
  exec "$@"
fi

