#!/bin/bash

if [ "${1:0:1}" = '-' ]; then
  export EXTRA_OPTIONS="$@"
  set --
elif [ "${1}" == "mysqld.bin" -o "${1}" == "$(which mysqld.bin)" ]; then
  export EXTRA_OPTIONS="${@:2}"
  set --
fi

exec /init "$@"
