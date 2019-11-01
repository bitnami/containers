#!/bin/bash -e

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page

if [[ "$1" == "nami" && "$2" == "start" ]] || [[ "$1" == "/run.sh" ]]; then
    . /apache-init.sh
    . /matomo-init.sh
    nami_initialize apache php mysql-client matomo
    info "Starting matomo... "
    . /post-init.sh
fi

exec tini -- "$@"
