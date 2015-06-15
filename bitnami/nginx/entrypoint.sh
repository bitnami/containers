#!/bin/bash
set -e
source $BITNAMI_PREFIX/bitnami-utils.sh

print_welcome_page

generate_conf_files

if [ ! "$(ls -A /app)" ]; then
  cp -r $BITNAMI_APP_DIR/html.defaults/* $BITNAMI_APP_DIR/html
fi

chown -R $BITNAMI_APP_USER:$BITNAMI_APP_USER $BITNAMI_APP_VOL_PREFIX/logs/ $BITNAMI_APP_VOL_PREFIX/conf/ /app/ || true

if [ "$1" = 'nginx' ]; then
  wait_and_tail_logs &
fi

exec "$@"
