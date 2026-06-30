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
    _exec_elasticsearch() { exec_as_user "$DB_DAEMON_USER" "$EXEC" "${ARGS[@]}"; }
else
    _exec_elasticsearch() { exec "$EXEC" "${ARGS[@]}"; }
fi

# In FIPS restricted mode ES 9.x reads the keystore password from stdin
# (Terminal.readSecret()). ES_KEYSTORE_PASSPHRASE is auto-populated from
# ES_KEYSTORE_PASSPHRASE_FILE by the Bitnami framework; supplying it via
# a here-string avoids an interactive TTY.
if [[ "${ELASTICSEARCH_ENABLE_FIPS_MODE:-false}" == "true" ]] && \
   [[ "${JAVA_TOOL_OPTIONS:-}" == *"java.security.restricted"* ]] && \
   [[ -n "${ES_KEYSTORE_PASSPHRASE:-}" ]]; then
    _exec_elasticsearch <<< "${ES_KEYSTORE_PASSPHRASE}"
else
    _exec_elasticsearch
fi
