#!/bin/bash
set -e

if [[ "$1" == "nami" && "$2" == "start" ]]; then
  status=`nami inspect $BITNAMI_APP_NAME`
  if [[ "$status" == *'"lifecycle": "unpacked"'* ]]; then
    nami initialize $BITNAMI_APP_NAME \
      ${MEMCACHED_USER:+--username $MEMCACHED_USER} \
      ${MEMCACHED_PASSWORD:+--password $MEMCACHED_PASSWORD}
  fi
  chown $BITNAMI_APP_USER: /bitnami/$BITNAMI_APP_NAME || true
fi

exec /entrypoint.sh "$@"
