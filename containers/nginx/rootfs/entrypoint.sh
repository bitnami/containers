#!/bin/bash

if [ "${1}" == "nginx" -o "${1}" == "$(which nginx)" ]; then
  set --
fi

if [ -n "${1}" ]; then
  touch /etc/services.d/$BITNAMI_APP_NAME/down
fi

exec /init "$@"
