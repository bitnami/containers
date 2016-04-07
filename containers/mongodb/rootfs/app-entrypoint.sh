#!/bin/bash
set -e

chown $BITNAMI_APP_USER: $BITNAMI_APP_VOL_PREFIX || true

if [[ "$1" == "harpoon" && "$2" == "start" ]]; then
  status=`harpoon inspect $BITNAMI_APP_NAME`
  if [[ "$status" == *'"lifecycle": "unpacked"'* ]]; then
    harpoon initialize $BITNAMI_APP_NAME \
      ${MONGODB_USER:+--username $MONGODB_USER} \
      ${MONGODB_PASSWORD:+--password $MONGODB_PASSWORD}
  fi
fi

exec /entrypoint.sh "$@"
