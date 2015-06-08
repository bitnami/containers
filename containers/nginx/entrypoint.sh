#!/bin/bash
set -e
SERVICE_USER=daemon

cp -nr $BITNAMI_APP_DIR/conf.defaults/* $BITNAMI_APP_DIR/conf

if [ ! "$(ls -A /app)" ]; then
  cp -r $BITNAMI_APP_DIR/html.defaults/* $BITNAMI_APP_DIR/html
fi

chown -R $SERVICE_USER:$SERVICE_USER $BITNAMI_VOL_PREFIX/logs/ $BITNAMI_VOL_PREFIX/conf/ /app/

if [ "$1" = 'nginx' ]; then
  gosu $SERVICE_USER:$SERVICE_USER tail -f $BITNAMI_VOL_PREFIX/logs/* &
fi

echo "#########################################################################"
echo "#                                                                       #"
echo "# Bitnami Nginx container running:                                      #"
echo "#                                                                       #"
echo "#########################################################################"
exec "$@"
