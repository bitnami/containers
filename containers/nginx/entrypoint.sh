#!/bin/bash
set -e
source /bitnami-utils.sh

print_welcome_page

generate_conf_files

if [ ! "$(ls -A /app)" ]; then
  cp -r $BITNAMI_APP_DIR/html.defaults/* $BITNAMI_APP_DIR/html
fi

chown -R $BITNAMI_APP_USER:$BITNAMI_APP_USER $BITNAMI_APP_VOL_PREFIX/logs/ $BITNAMI_APP_VOL_PREFIX/conf/ /app/

if [ "$1" = 'nginx' ]; then
  gosu $BITNAMI_APP_USER:$BITNAMI_APP_USER tail -f $BITNAMI_APP_VOL_PREFIX/logs/* &
fi

exec "$@"
