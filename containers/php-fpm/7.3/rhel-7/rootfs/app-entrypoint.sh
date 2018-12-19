#!/bin/bash -e

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page

if [[ "$1" == "nami" && "$2" == "start" ]] || [[ "$1" == "php-fpm" ]]; then
  nami_initialize php
  info "Starting php... "
fi

exec tini -- "$@"
