#!/bin/bash
set -e
source $BITNAMI_PREFIX/bitnami-utils.sh

if [ "${1:0:1}" = '-' ]; then
  set -- memcached "$@"
fi

if [ "$1" = 'memcached' ]; then
  set -- "$@" -u $BITNAMI_APP_USER -S -l 0.0.0.0
fi

if [ "$MEMCACHED_PASSWORD" ]; then
  echo "Setting password..."
  $BITNAMI_APP_DIR/bnconfig --userpassword $MEMCACHED_PASSWORD
  print_app_credentials $BITNAMI_APP_NAME **none** $MEMCACHED_PASSWORD
fi

print_welcome_page
exec "$@" >> $BITNAMI_APP_VOL_PREFIX/logs/memcached.log 2>&1
