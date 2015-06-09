#!/bin/bash
set -e
source /bitnami-utils.sh

# if command starts with an option, prepend memcached
if [ "${1:0:1}" = '-' ]; then
  set -- memcached "$@"
fi

if [ "$1" = 'memcached' ]; then
  set -- "$@" -u memcached -S -l 0.0.0.0
fi

if [ "$MEMCACHED_PASSWORD" ]; then
  echo "Setting password..."
  $BITNAMI_APP_DIR/bnconfig --userpassword $MEMCACHED_PASSWORD
  print_app_credentials $BITNAMI_APP_NAME myuser $MEMCACHED_PASSWORD
fi

exec "$@" >> $BITNAMI_VOL_PREFIX/logs/memcached.log 2>&1
