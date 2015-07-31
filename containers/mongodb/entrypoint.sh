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
else
  print_container_already_initialized $BITNAMI_APP_NAME
fi

chown -R $BITNAMI_APP_USER:$BITNAMI_APP_USER $BITNAMI_APP_VOL_PREFIX/data/ \
  $BITNAMI_APP_VOL_PREFIX/logs/ \
  $BITNAMI_APP_VOL_PREFIX/conf/ || true

# The user can run its own version or mongod and we still
# will want to log it and run it using the BITNAMI_APP_USER
if [[ "$1" = 'mongod' ]]; then
  wait_and_tail_logs &

  # Add default configuration
  if [[ "$@" = 'mongod' ]]; then
    exec gosu $BITNAMI_APP_USER "$@" \
      --config $BITNAMI_APP_VOL_PREFIX/conf/mongodb.conf --dbpath $BITNAMI_APP_DIR/data $EXTRA_OPTIONS
  else
    exec gosu $BITNAMI_APP_USER "$@"
  fi
else
  exec "$@"
fi
