#!/bin/bash


set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

if ! getent passwd "$(id -u)" &>/dev/null && [ -e "$NSS_WRAPPER_LIB" ]; then
    export LD_PRELOAD="$NSS_WRAPPER_LIB"
    # shellcheck disable=SC2155
    export NSS_WRAPPER_PASSWD="$(mktemp)"
    # shellcheck disable=SC2155
    export NSS_WRAPPER_GROUP="$(mktemp)"
    echo "git:x:$(id -u):$(id -g):Git:${HOME}:/bin/false" >"$NSS_WRAPPER_PASSWD"
    echo "git:x:$(id -g):" >"$NSS_WRAPPER_GROUP"
fi

[ "$#" -eq 0 ] || exec "$@"
