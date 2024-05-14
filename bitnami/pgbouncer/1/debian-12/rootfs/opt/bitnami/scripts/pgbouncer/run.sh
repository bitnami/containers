#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load pgbouncer environment
. /opt/bitnami/scripts/pgbouncer-env.sh

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libpgbouncer.sh

flags=("$PGBOUNCER_CONF_FILE")
cmd=$(command -v pgbouncer)

if [[ -n "${PGBOUNCER_EXTRA_FLAGS:-}" ]]; then
    read -r -a extra_flags <<<"$PGBOUNCER_EXTRA_FLAGS"
    flags+=("${extra_flags[@]}")
fi

flags+=("$@")

info "** Starting PgBouncer **"
if am_i_root; then
    exec_as_user "$PGBOUNCER_DAEMON_USER" "$cmd" "${flags[@]}"
else
    exec "$cmd" "${flags[@]}"
fi
