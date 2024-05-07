#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libkong.sh

# Load Kong environment variables
. /opt/bitnami/scripts/kong-env.sh

# In case we are working with root containers, we need to set the KONG_NGINX_USER environment variable
# before running Kong

if am_i_root && [[ -z "${KONG_NGINX_USER:-}" ]]; then
    export KONG_NGINX_USER="${KONG_DAEMON_USER} ${KONG_DAEMON_GROUP}"
fi

if is_boolean_yes "$KONG_EXIT_AFTER_MIGRATE"; then
    info "** Container configured to just perform the database migration (KONG_EXIT_AFTER_MIGRATE=yes). Exiting now **"
    exit 0
else
    info "** Starting Kong **"
    if am_i_root; then
        exec_as_user "$KONG_DAEMON_USER" kong start -c "$KONG_CONF_FILE" -p "$KONG_PREFIX"
    else
        exec kong start -c "$KONG_CONF_FILE" -p "$KONG_PREFIX"
    fi
fi
