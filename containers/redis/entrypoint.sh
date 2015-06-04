#!/bin/bash
set -e

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

chown -R redis:redis /data/ /logs/ /conf/

if [ "$1" = 'redis-server' ]; then
  tail -f /logs/* &
	exec gosu redis "$@"
fi

exec "$@"
