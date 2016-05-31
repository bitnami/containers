#!/bin/bash
set -e

WILDFLY_PASSWORD=${WILDFLY_PASSWORD:-password}

if [[ "$1" == "harpoon" && "$2" == "start" ]]; then
  status=`harpoon inspect $BITNAMI_APP_NAME`
  if [[ "$status" == *'"lifecycle": "unpacked"'* ]]; then
    harpoon initialize $BITNAMI_APP_NAME \
      ${WILDFLY_USER:+--username $WILDFLY_USER} \
      ${WILDFLY_PASSWORD:+--password $WILDFLY_PASSWORD}
  fi
  chown $BITNAMI_APP_USER: /bitnami/$BITNAMI_APP_NAME || true
fi

exec /entrypoint.sh "$@"
