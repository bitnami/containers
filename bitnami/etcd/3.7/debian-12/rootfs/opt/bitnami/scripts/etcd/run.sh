#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libetcd.sh

# Load etcd environment variables
. /opt/bitnami/scripts/etcd-env.sh

# We need to unset ETCD_ROOT_PASSWORD otherwise it will be logged by etcd process
unset ETCD_ROOT_PASSWORD
# Load env vars of existing cluster
etcd_safe_load_member_env

declare -a cmd=("etcd")
# If provided, run using configuration file
# Using a configuration file will cause etcd to ignore other flags and environment variables
[[ -f "$ETCD_CONF_FILE" ]] && cmd+=("--config-file" "$ETCD_CONF_FILE")
cmd+=("$@")

info "** Starting etcd **"
if am_i_root; then
    exec_as_user "$ETCD_DAEMON_USER" "${cmd[@]}"
else
    exec "${cmd[@]}"
fi
