#!/bin/bash
set -e

if [[ "$1" == "harpoon" && "$2" == "start" ]]; then
  status=`harpoon inspect $BITNAMI_APP_NAME`
  if [[ "$status" == *'"lifecycle": "unpacked"'* ]]; then
    harpoon initialize $BITNAMI_APP_NAME \
      ${MARIADB_ROOT_PASSWORD:+--rootPassword $MARIADB_ROOT_PASSWORD} \
      ${MARIADB_USER:+--username $MARIADB_USER} \
      ${MARIADB_PASSWORD:+--password $MARIADB_PASSWORD} \
      ${MARIADB_DATABASE:+--database $MARIADB_DATABASE} \
      ${MARIADB_REPLICATION_MODE:+--replicationMode $MARIADB_REPLICATION_MODE} \
      ${MARIADB_REPLICATION_USER:+--replicationUser $MARIADB_REPLICATION_USER} \
      ${MARIADB_REPLICATION_PASSWORD:+--replicationPassword $MARIADB_REPLICATION_PASSWORD} \
      ${MARIADB_MASTER_HOST:+--masterHost $MARIADB_MASTER_HOST} \
      ${MARIADB_MASTER_PORT:+--masterPort $MARIADB_MASTER_PORT} \
      ${MARIADB_MASTER_USER:+--masterUser $MARIADB_MASTER_USER} \
      ${MARIADB_MASTER_PASSWORD:+--masterPassword $MARIADB_MASTER_PASSWORD}
  fi
  chown $BITNAMI_APP_USER: /bitnami/$BITNAMI_APP_NAME || true
fi

exec /entrypoint.sh "$@"
