#!/bin/bash -e

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page

if [[ "$1" == "nami" && "$2" == "start" ]] || [[ "$1" == "httpd" ]]; then
    . /apache-init.sh
    nami_initialize php apache mysql-client joomla
    info "Starting gosu... "
    . /post-init.sh
fi

exec tini -- "$@"
