#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libelasticsearch.sh
. /opt/bitnami/scripts/libos.sh

# Load environment
. /opt/bitnami/scripts/elasticsearch-env.sh

# Constants
EXEC=$(command -v elasticsearch)
ARGS=("-p" "$DB_PID_FILE")
[[ -z "${DB_EXTRA_FLAGS:-}" ]] || ARGS=("${ARGS[@]}" "${DB_EXTRA_FLAGS[@]}")

ARGS+=("$@")

info "** Starting Elasticsearch **"
if am_i_root; then
    exec_as_user "$DB_DAEMON_USER" "$EXEC" "${ARGS[@]}"
else
    exec "$EXEC" "${ARGS[@]}"
fi
