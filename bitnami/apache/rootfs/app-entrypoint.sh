#!/bin/bash
set -e

if [[ "$1" == "nami" && "$2" == "start" ]]; then
  status=`nami inspect $BITNAMI_APP_NAME`
  if [[ "$status" == *'"lifecycle": "unpacked"'* ]]; then
    nami initialize $BITNAMI_APP_NAME
  fi
  chown -R :$BITNAMI_APP_USER /bitnami/$BITNAMI_APP_NAME || true
fi

exec /entrypoint.sh "$@"
