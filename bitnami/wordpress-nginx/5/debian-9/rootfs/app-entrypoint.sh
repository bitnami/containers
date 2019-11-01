#!/bin/bash -e

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page

if [[ "$1" == "nami" && "$2" == "start" ]] || [[ "$1" == "/run.sh" ]]; then
    . /wordpress-init.sh
    nami_initialize php nginx mysql-client wordpress
    info "Starting wordpress... "
    . /post-init.sh
fi

exec tini -- "$@"
