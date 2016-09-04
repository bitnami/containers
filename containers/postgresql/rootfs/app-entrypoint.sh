#!/bin/bash
set -e

if [[ "$1" == "nami" && "$2" == "start" ]]; then
  status=`nami inspect $BITNAMI_APP_NAME`
  if [[ "$status" == *'"lifecycle": "unpacked"'* ]]; then
    nami initialize $BITNAMI_APP_NAME \
      ${POSTGRES_USER:+--username $POSTGRES_USER} \
      ${POSTGRES_PASSWORD:+--password $POSTGRES_PASSWORD} \
      ${POSTGRES_DB:+--database $POSTGRES_DB} \
      ${POSTGRES_MODE:+--replicationMode $POSTGRES_MODE} \
      ${POSTGRES_REPLICATION_USER:+--replicationUser $POSTGRES_REPLICATION_USER} \
      ${POSTGRES_REPLICATION_PASSWORD:+--replicationPassword $POSTGRES_REPLICATION_PASSWORD} \
      ${POSTGRES_MASTER_HOST:+--masterHost $POSTGRES_MASTER_HOST} \
      ${POSTGRES_MASTER_PORT:+--masterPort $POSTGRES_MASTER_PORT} \
      ${POSTGRES_MASTER_USER:+--masterUser $POSTGRES_MASTER_USER} \
      ${POSTGRES_MASTER_PASSWORD:+--masterPassword $POSTGRES_MASTER_PASSWORD}
  fi
  chown $BITNAMI_APP_USER: /bitnami/$BITNAMI_APP_NAME || true
fi

exec /entrypoint.sh "$@"
