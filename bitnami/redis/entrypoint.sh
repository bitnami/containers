#!/bin/bash
set -e

SERVICE_USER=redis

if [ ! "$(ls -A /conf)" ]; then
  cp -r $BITNAMI_APP_DIR/etc/conf.defaults/* $BITNAMI_APP_DIR/etc/conf

  if [ "$REDIS_PASSWORD" ]; then
    echo "Setting password in /conf/redis.conf ..."
    # TODO, move to bnconfig once password supported
    sed -i -e 's:\W*\s*requirepass \S*:requirepass '$REDIS_PASSWORD':' /conf/redis.conf

    echo "#########################################################################"
    echo "#                                                                       #"
    echo "# Credentials for redis:                                                #"
    echo "# password: $REDIS_PASSWORD                                                #"
    echo "#                                                                       #"
    echo "#########################################################################"
  fi
else
  echo "#########################################################################"
  echo "#                                                                       #"
  echo "# Container already initialized, skipping setup.                        #"
  echo "#                                                                       #"
  echo "#########################################################################"
fi

chown -R $SERVICE_USER:$SERVICE_USER /data/ /logs/ /conf/

if [ "$1" = 'redis-server' ]; then
  gosu $SERVICE_USER:$SERVICE_USER tail -f /logs/* &
	exec gosu $SERVICE_USER "$@"
fi

exec "$@"
