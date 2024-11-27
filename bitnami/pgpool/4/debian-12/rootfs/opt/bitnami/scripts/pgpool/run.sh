#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Pgpool run

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libldapclient.sh
. /opt/bitnami/scripts/libpgpool.sh

# Load Pgpool env. variables
eval "$(pgpool_env)"
# Load LDAP environment variables
eval "$(ldap_env)"

command="$(command -v pgpool)"
flags=("-n" "--config-file=${PGPOOL_CONF_FILE}" "--hba-file=${PGPOOL_PGHBA_FILE}")
is_boolean_yes "$PGPOOL_DISCARD_STATUS" && flags+=("-D")
[[ -z "${PGPOOL_EXTRA_FLAGS:-}" ]] || flags=("${flags[@]}" "${PGPOOL_EXTRA_FLAGS[@]}")

is_boolean_yes "$PGPOOL_ENABLE_LDAP" && ldap_start_nslcd_bg
info "** Starting Pgpool-II **"
if am_i_root; then
    exec_as_user "$PGPOOL_DAEMON_USER" "${command}" "${flags[@]}"
else
    exec "${command}" "${flags[@]}"
fi
