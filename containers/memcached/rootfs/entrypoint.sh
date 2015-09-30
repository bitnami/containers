#!/bin/bash
set -e
source $BITNAMI_PREFIX/bitnami-utils.sh

print_welcome_page

if [ "${1:0:1}" = '-' ]; then
  set -- memcached "$@"
fi

if [ "$1" = 'memcached' ]; then
  set -- "$@" -u $BITNAMI_APP_USER -l 0.0.0.0
fi

if [ "$MEMCACHED_PASSWORD" ]; then
  set -- "$@" -S
  echo "Setting password..."
  $BITNAMI_APP_DIR/bnconfig --userpassword $MEMCACHED_PASSWORD
  print_app_credentials $BITNAMI_APP_NAME user $MEMCACHED_PASSWORD
fi

exec "$@" >> $BITNAMI_APP_VOL_PREFIX/logs/memcached.log 2>&1
