#!/bin/bash
set -e
SERVICE_USER=daemon

if [ ! "$(ls -A /conf)" ]; then
  cp -r $BITNAMI_APP_DIR/conf.defaults/* $BITNAMI_APP_DIR/conf
fi

if [ ! "$(ls -A /app)" ]; then
  cp -r $BITNAMI_APP_DIR/html.defaults/* $BITNAMI_APP_DIR/html
fi

chown -R $SERVICE_USER:$SERVICE_USER /logs/ /conf/ /app/

if [ "$1" = 'nginx' ]; then
  gosu $SERVICE_USER:$SERVICE_USER tail -f /logs/* &
fi

echo "#########################################################################"
echo "#                                                                       #"
echo "# Bitnami Nginx container running:                                      #"
echo "#                                                                       #"
echo "#########################################################################"
exec "$@"
