#!/bin/bash
set -e

if [[ "$1" == "harpoon" && "$2" == "start" ]]; then
  status=`harpoon inspect php`
  if [[ "$status" == *'"lifecycle": "unpacked"'* ]]; then
    harpoon initialize php
  fi
fi

chown $BITNAMI_APP_USER: /bitnami/$BITNAMI_APP_NAME || true

exec /entrypoint.sh "$@"
