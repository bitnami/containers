#!/bin/bash
set -e

if [[ "$1" == "harpoon" && "$2" == "start" ]]; then
  status=`harpoon inspect $BITNAMI_APP_NAME`
  if [[ "$status" == *'"lifecycle": "unpacked"'* ]]; then
    harpoon initialize $BITNAMI_APP_NAME \
      ${MONGODB_ROOT_PASSWORD:+--rootPassword $MONGODB_ROOT_PASSWORD} \
      ${MONGODB_USER:+--username $MONGODB_USER} \
      ${MONGODB_PASSWORD:+--password $MONGODB_PASSWORD} \
      ${MONGODB_DATABASE:+--database $MONGODB_DATABASE}
  fi
  chown $BITNAMI_APP_USER: /bitnami/$BITNAMI_APP_NAME || true
fi

exec /entrypoint.sh "$@"
