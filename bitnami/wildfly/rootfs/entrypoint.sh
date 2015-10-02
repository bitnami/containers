#!/bin/bash

if [ "${1:0:1}" = '-' ]; then
  export EXTRA_OPTIONS="$@"
  set --
elif [ "${1}" == "standalone.sh" -o "${1}" == "$(which standalone.sh)" ]; then
  export EXTRA_OPTIONS="${@:2}"
  set --
elif [ "${1}" == "domain.sh" -o "${1}" == "$(which domain.sh)" ]; then
  export BITNAMI_APP_DAEMON=domain.sh
  export EXTRA_OPTIONS="${@:2}"
  set --
fi

exec /init "$@"
