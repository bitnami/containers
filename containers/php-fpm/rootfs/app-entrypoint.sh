#!/bin/bash
set -e

if [ -f composer.json  ]; then
  composer install
fi

if [[ "$1" == "harpoon" && "$2" == "start" ]]; then
  status=`harpoon inspect php`
  if [[ "$status" == *'"lifecycle": "unpacked"'* ]]; then
    harpoon initialize php
  fi
  chown -R :$BITNAMI_APP_USER /bitnami/$BITNAMI_APP_NAME || true
fi

exec /entrypoint.sh "$@"
