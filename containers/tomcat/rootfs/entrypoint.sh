#!/bin/bash

if [ "${1:0:1}" = '-' ]; then
  export EXTRA_OPTIONS="$@"
  set --
elif [ "${1}" == "catalina.sh" -o "${1}" == "$(which catalina.sh)" ]; then
  export EXTRA_OPTIONS="${@:2}"
  set --
fi

if [ -n "${1}" ]; then
  touch /etc/services.d/$BITNAMI_APP_NAME/down
fi

exec /init "$@"
