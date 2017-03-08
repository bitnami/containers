#!/bin/bash -e
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page
check_for_updates &

if [[ "$1" == "nami" && "$2" == "start" ]] || [[ "$(basename $1)" == "redis-server" ]] || [[ "$1" == "/init.sh" ]]; then
  nami_initialize redis

  # ensure redis-server is running in the foreground
  if [[ "$(basename $1)" == "redis-server" ]]; then
    set -- gosu redis "$@" /opt/bitnami/redis/conf/redis.conf --daemonize no
  fi
fi

exec tini -- "$@"
