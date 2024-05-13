#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh

print_welcome_page

# Configure NSS wrapper
if ! am_i_root; then
    export LNAME="git"
    export LD_PRELOAD="/opt/bitnami/common/lib/libnss_wrapper.so"
    if ! user_exists "$(id -u)" && [[ -f "$LD_PRELOAD" ]]; then
        # shellcheck disable=SC2155
        export NSS_WRAPPER_PASSWD="$(mktemp)"
        # shellcheck disable=SC2155
        export NSS_WRAPPER_GROUP="$(mktemp)"
        echo "git:x:$(id -u):$(id -g):Git:${HOME}:/bin/false" >"$NSS_WRAPPER_PASSWD"
        echo "git:x:$(id -g):" >"$NSS_WRAPPER_GROUP"
    fi
fi

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

[ "$#" -eq 0 ] || exec "$@"
