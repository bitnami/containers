#!/bin/bash
set -e

if [[ "$1" == "harpoon" && "$2" == "start" ]]; then
  status=`harpoon inspect $BITNAMI_APP_NAME`
  if [[ "$status" == *'"lifecycle": "unpacked"'* ]]; then
    harpoon initialize $BITNAMI_APP_NAME \
      ${MONGODB_ROOT_PASSWORD:+--rootPassword $MONGODB_ROOT_PASSWORD} \
      ${MONGODB_USER:+--username $MONGODB_USER} \
      ${MONGODB_PASSWORD:+--password $MONGODB_PASSWORD} \
      ${MONGODB_DATABASE:+--database $MONGODB_DATABASE} \
      ${MONGODB_REPLICASET_MODE:+--replicaSetMode $MONGODB_REPLICASET_MODE} \
      ${MONGODB_REPLICASET_NAME:+--replicaSetName $MONGODB_REPLICASET_NAME} \
      ${MONGODB_PRIMARY_HOST:+--primaryHost $MONGODB_PRIMARY_HOST} \
      ${MONGODB_PRIMARY_PORT:+--primaryPort $MONGODB_PRIMARY_PORT} \
      ${MONGODB_PRIMARY_USER:+--primaryUser $MONGODB_PRIMARY_USER} \
      ${MONGODB_PRIMARY_PASSWORD:+--primaryPassword $MONGODB_PRIMARY_PASSWORD}
  fi
  chown $BITNAMI_APP_USER: /bitnami/$BITNAMI_APP_NAME || true
fi

exec /entrypoint.sh "$@"
