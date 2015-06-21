#!/bin/bash
set -e
source $BITNAMI_PREFIX/bitnami-utils.sh

print_welcome_page

sudo chown -R $BITNAMI_APP_USER:$BITNAMI_APP_USER \
  $BITNAMI_APP_VOL_PREFIX/conf/ \
  $BITNAMI_APP_VOL_PREFIX/logs/ \
  /app || true

if [ ! "$(ls -A $BITNAMI_APP_VOL_PREFIX/conf)" ]; then
  generate_conf_files $BITNAMI_APP_DIR/etc
fi

exec "$@"
