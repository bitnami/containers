#!/bin/bash
set -e
source $BITNAMI_PREFIX/bitnami-utils.sh
source $BITNAMI_APP_DIR/scripts/setenv.sh

print_welcome_page

# if command starts with an option, prepend 'standalone.sh run'
if [ "${1:0:1}" = '-' ]; then
  EXTRA_OPTIONS="$@"
  set -- standalone.sh
fi

chown -R $BITNAMI_APP_USER:$BITNAMI_APP_USER $BITNAMI_APP_VOL_PREFIX/logs/ || true

if [ "$1" = 'standalone.sh' ]; then
  set -- $@ $PROGRAM_OPTIONS $EXTRA_OPTIONS
  exec gosu $BITNAMI_APP_USER "$@"
else
  exec "$@"
fi
