#!/bin/bash -e

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page

if [[ "$1" == "nami" && "$2" == "start" ]] || [[ "$1" == "httpd" ]]; then
  nami_initialize apache php libphp dreamfactory
  info "Starting dreamfactory... "
fi

exec tini -- "$@"
