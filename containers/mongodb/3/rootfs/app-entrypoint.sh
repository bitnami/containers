#!/bin/bash -e
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page
check_for_updates &

if [[ "$1" == "nami" && "$2" == "start" ]] || [[ "$(basename $1)" == "mongod" ]] || [[ "$1" == "/init.sh" ]]; then
  nami_initialize mongodb

  # log output to stdout
  sed -i 's/path: .*\/mongodb.log/path: /' /bitnami/mongodb/conf/mongodb.conf

  if [[ "$(basename $1)" == "mongod" ]]; then
    set -- gosu mongo "$@" --config /opt/bitnami/mongodb/conf/mongodb.conf
  fi
fi

exec tini -- "$@"
