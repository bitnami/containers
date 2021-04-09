#!/bin/bash -e

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page

if [[ "$1" == "nami" && "$2" == "start" ]] || [[ "$1" == "/run.sh" ]]; then
    . /init.sh
    if [ ! $EUID -eq 0 ] && [ -e "$LIBNSS_WRAPPER_PATH" ]; then
    echo "ghost:x:$(id -u):$(id -g):Ghost:/opt/bitnami/ghost:/bin/false" > "$NSS_WRAPPER_PASSWD"
    echo "ghost:x:$(id -g):" > "$NSS_WRAPPER_GROUP"

    export LD_PRELOAD="$LIBNSS_WRAPPER_PATH"
fi

    nami_initialize mysql-client ghost
    info "Starting ghost... "
fi

exec tini -- "$@"
