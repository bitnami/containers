#!/bin/bash -e
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page
check_for_updates &

if [[ "$1" == "nami" && "$2" == "start" ]] || [[ "$(basename $1)" == "nginx" ]] || [[ "$1" == "/init.sh" ]]; then
  nami_initialize nginx

  # redirect nginx logs to stdout/stderr
  ln -sf /dev/stdout /opt/bitnami/nginx/logs/access.log
  ln -sf /dev/stderr /opt/bitnami/nginx/logs/error.log

  # ensure nginx is not daemonized
  if [[ "$(basename $1)" == "nginx" ]]; then
    set -- "$@" -g 'daemon off;'
  fi

  chown -R :daemon /bitnami/nginx || true
fi

exec tini -- "$@"
