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
. /opt/bitnami/scripts/libkeycloak.sh
. /opt/bitnami/scripts/libos.sh

# Load keycloak environment variables
. /opt/bitnami/scripts/keycloak-env.sh

info "** Starting keycloak **"
# Use only basename
conf_file="${KEYCLOAK_CONF_DIR}/${KEYCLOAK_CONF_FILE}"

is_boolean_yes "$KEYCLOAK_PRODUCTION" && start_param="start" || start_param="start-dev"

start_command=("${KEYCLOAK_BIN_DIR}/kc.sh" "-cf" "$conf_file")

# Prepend extra args
if [[ -n "$KEYCLOAK_EXTRA_ARGS_PREPENDED" ]]; then
    read -r -a extra_args_prepended <<<"$KEYCLOAK_EXTRA_ARGS_PREPENDED"
    start_command+=("${extra_args_prepended[@]}")
fi

start_command+=("$start_param")

# Add extra args
if [[ -n "$KEYCLOAK_EXTRA_ARGS" ]]; then
    read -r -a extra_args <<<"$KEYCLOAK_EXTRA_ARGS"
    start_command+=("${extra_args[@]}")
fi

if am_i_root; then
    exec_as_user "$KEYCLOAK_DAEMON_USER" /bin/bash -c "${start_command[*]}"
else
    exec /bin/bash -c "${start_command[*]}"
fi
