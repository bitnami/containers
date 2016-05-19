#!/bin/bash
set -e

if [[ "$1" == "harpoon" && "$2" == "start" ]]; then
  status=`harpoon inspect $BITNAMI_APP_NAME`
  if [[ "$status" == *'"lifecycle": "unpacked"'* ]]; then
    harpoon initialize $BITNAMI_APP_NAME \
      ${REDIS_PASSWORD:+--password $REDIS_PASSWORD} \
      ${REDIS_REPLICATION_MODE:+--replicationMode $REDIS_REPLICATION_MODE} \
      ${REDIS_MASTER_HOST:+--masterHost $REDIS_MASTER_HOST} \
      ${REDIS_MASTER_PORT:+--masterPort $REDIS_MASTER_PORT} \
      ${REDIS_MASTER_PASSWORD:+--masterPassword $REDIS_MASTER_PASSWORD}
  fi
  chown $BITNAMI_APP_USER: /bitnami/$BITNAMI_APP_NAME || true
fi

exec /entrypoint.sh "$@"
