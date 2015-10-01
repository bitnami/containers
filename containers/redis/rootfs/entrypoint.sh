#!/bin/bash
set -e
source $BITNAMI_PREFIX/bitnami-utils.sh

print_welcome_page

# We allow the user to pass extra options
if [ "${1:0:1}" = '-' ]; then
  EXTRA_OPTIONS="$@"
  set -- redis-server
fi

if [ ! "$(ls -A $BITNAMI_APP_VOL_PREFIX/conf)" ]; then
  generate_conf_files $BITNAMI_APP_DIR/etc

  if [ "$REDIS_PASSWORD" ]; then
    echo "Setting password in /conf/redis.conf ..."
    echo "# Disabled" > $BITNAMI_APP_DIR/scripts/ctl.sh
    $BITNAMI_APP_DIR/bnconfig --userpassword $REDIS_PASSWORD

    print_app_credentials $BITNAMI_APP_NAME **none** $REDIS_PASSWORD
  fi
else
  print_container_already_initialized $BITNAMI_APP_NAME
fi

chown -R $BITNAMI_APP_USER:$BITNAMI_APP_USER $BITNAMI_APP_VOL_PREFIX/data/ \
  $BITNAMI_APP_VOL_PREFIX/logs/ \
  $BITNAMI_APP_VOL_PREFIX/conf/ || true


# The user can run its own version or redis-server and we still
# will want to log it and run it using the BITNAMI_APP_USER
if [[ "$1" = 'redis-server' ]]; then
  wait_and_tail_logs &
  # Add default configuration
  if [[ "$@" = 'redis-server' ]]; then
    exec gosu $BITNAMI_APP_USER "$@" $BITNAMI_APP_VOL_PREFIX/conf/redis.conf $EXTRA_OPTIONS
  else
    exec gosu $BITNAMI_APP_USER "$@"
  fi
else
  exec "$@"
fi
