#!/bin/bash
set -e
source $BITNAMI_PREFIX/bitnami-utils.sh

print_welcome_page

# We allow the user to pass extra options
if [ "${1:0:1}" = '-' ]; then
  EXTRA_OPTIONS="$@"
  set -- mongod
fi

if [ ! "$(ls -A $BITNAMI_APP_VOL_PREFIX/conf)" ]; then
  generate_conf_files
fi

# The user can run its own version or mongod and we still
# will want to log it and run it using the BITNAMI_APP_USER
if [[ "$1" = 'mongod' ]]; then
  if [ ! -f $BITNAMI_APP_VOL_PREFIX/data/storage.bson ]; then
    create_mongodb_user
    print_app_credentials $BITNAMI_APP_NAME `print_mongo_user` `print_mongo_password` `print_mongo_database`
  else
    print_container_already_initialized $BITNAMI_APP_NAME
  fi

  rm -rf $BITNAMI_APP_VOL_PREFIX/data/mongod.lock
  chown -R $BITNAMI_APP_USER:$BITNAMI_APP_USER $BITNAMI_APP_VOL_PREFIX/data/ \
    $BITNAMI_APP_VOL_PREFIX/logs/ \
    $BITNAMI_APP_VOL_PREFIX/conf/ || true

  wait_and_tail_logs &

  # Add default configuration
  if [[ "$@" = 'mongod' ]]; then
    exec gosu $BITNAMI_APP_USER "$@" $PROGRAM_OPTIONS ${MONGODB_PASSWORD:+--auth} $EXTRA_OPTIONS
  else
    exec gosu $BITNAMI_APP_USER "$@"
  fi
else
  exec "$@"
fi
