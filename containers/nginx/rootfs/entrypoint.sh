#!/bin/bash

if [ -n "${1}" ]; then
  touch /etc/services.d/$BITNAMI_APP_NAME/down
fi

exec /init "$@"
