#!/bin/bash -e

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page

if [[ "$1" == "nami" && "$2" == "start" ]] || [[ "$1" == "/run.sh" ]]; then
    . /suitecrm-init.sh
    nami_initialize apache php mysql-client suitecrm
    info "Starting suitecrm... "
    . /post-init.sh
fi

exec tini -- "$@"
