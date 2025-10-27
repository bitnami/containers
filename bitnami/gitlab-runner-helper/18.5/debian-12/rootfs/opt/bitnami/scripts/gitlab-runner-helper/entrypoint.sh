#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh

print_welcome_page

# Configure libnss_wrapper based on the UID/GID used to run the container
# This container supports arbitrary UIDs, therefore we have do it dynamically
if ! am_i_root; then
    export LNAME="gitlab-runner"
    export LD_PRELOAD="/opt/bitnami/common/lib/libnss_wrapper.so"
    if [[ -f "$LD_PRELOAD" ]]; then
        info "Configuring libnss_wrapper"
        NSS_WRAPPER_PASSWD="$(mktemp)"
        export NSS_WRAPPER_PASSWD
        NSS_WRAPPER_GROUP="$(mktemp)"
        export NSS_WRAPPER_GROUP
        if [[ "$HOME" == "/" ]]; then
            export HOME=/home/gitlab-runner
        fi
        echo "gitlab-runner:x:$(id -u):$(id -g):GitlabRunner:${HOME}:/bin/false" >"$NSS_WRAPPER_PASSWD"
        echo "gitlab-runner:x:$(id -g):" >"$NSS_WRAPPER_GROUP"
        chmod 400 "$NSS_WRAPPER_PASSWD" "$NSS_WRAPPER_GROUP"
    fi
fi

## Code taken from the upstream gitlab-runner-helper container
## https://gitlab.com/gitlab-org/gitlab-runner/-/blob/main/dockerfiles/runner-helper/helpers/entrypoint

DATA_DIR="/etc/gitlab-runner"
CONFIG_FILE=${CONFIG_FILE:-$DATA_DIR/config.toml}
CA_CERTIFICATES_PATH=${CA_CERTIFICATES_PATH:-$DATA_DIR/certs/ca.crt}
LOCAL_CA_PATH="/usr/local/share/ca-certificates/ca.crt"

update_ca() {
    echo "Updating CA certificates..."
    cp "${CA_CERTIFICATES_PATH}" "${LOCAL_CA_PATH}"
    update-ca-certificates --fresh >/dev/null
}

if [[ -f "${CA_CERTIFICATES_PATH}" ]]; then
    cmp --silent "${CA_CERTIFICATES_PATH}" "${LOCAL_CA_PATH}" || update_ca
fi

exec "$@"
