#!/bin/bash
# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0


set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Generate new SSH key pairs if they don't exist
if [[ ! -f /etc/ssh/ssh_host_rsa_key ]]; then
    ssh-keygen -q -t rsa -f /etc/ssh/ssh_host_rsa_key -N "" <<<y >/dev/null 2>&1
fi

if [[ ! -f /etc/ssh/ssh_host_ecdsa_key ]]; then
    ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N "" <<<y >/dev/null 2>&1
fi

if [[ ! -f /etc/ssh/ssh_host_ed25519_key ]]; then
    ssh-keygen -q -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N "" <<<y >/dev/null 2>&1
fi

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
