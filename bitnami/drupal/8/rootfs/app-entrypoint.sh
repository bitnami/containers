#!/bin/bash -e
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page
check_for_updates &

if [[ "$1" == "nami" && "$2" == "start" ]] || [[ "$(basename $1)" == "httpd" ]] || [[ "$1" == "/init.sh" ]]; then
  nami_initialize apache php drupal

  if [[ "$(basename $1)" == "httpd" ]]; then
    # drupal initialization leaves a running httpd instance
    apachectl stop

    # redirect apache logs to stdout/stderr
    ln -sf /dev/stdout /opt/bitnami/apache/logs/access_log
    ln -sf /dev/stdout /opt/bitnami/apache/logs/error_log

    set -- "$@" -f /opt/bitnami/apache/conf/httpd.conf -D FOREGROUND
  fi
fi

exec tini -- "$@"
