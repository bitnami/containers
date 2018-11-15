#!/bin/bash -e

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page

if [[ "$1" == "nami" && "$2" == "start" ]] || [[ "$1" == "/run.sh" ]]; then
    if ! getent passwd "$(id -u)" &> /dev/null && [ -e /usr/lib/libnss_wrapper.so ]; then
    export LD_PRELOAD='/usr/lib/libnss_wrapper.so'
    # shellcheck disable=SC2155
    export NSS_WRAPPER_PASSWD="$(mktemp)"
    # shellcheck disable=SC2155
    export NSS_WRAPPER_GROUP="$(mktemp)"
    echo "postgres:x:$(id -u):$(id -g):PostgreSQL:$PGDATA:/bin/false" > "$NSS_WRAPPER_PASSWD"
    echo "postgres:x:$(id -g):" > "$NSS_WRAPPER_GROUP"
  fi

  nami_initialize postgresql
  info "Starting postgresql... "
fi

exec tini -- "$@"
