#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libopensearch.sh
. /opt/bitnami/scripts/libos.sh

# Load environment
. /opt/bitnami/scripts/opensearch-env.sh

# Constants
EXEC=$(command -v opensearch)
ARGS=("-p" "$DB_PID_FILE")
[[ -z "${DB_EXTRA_FLAGS:-}" ]] || ARGS=("${ARGS[@]}" "${DB_EXTRA_FLAGS[@]}")
# JAVA_HOME to be deprecated, see warning:
#   warning: usage of JAVA_HOME is deprecated, use ES_JAVA_HOME
export JAVA_HOME=/opt/bitnami/java
export OPENSEARCH_JAVA_HOME=/opt/bitnami/java
if is_boolean_yes "${OPENSEARCH_SET_CGROUP:-}"; then
    # Taken from upstream OpenSearch container
    # https://github.com/opensearch-project/opensearch-build/blob/main/docker/release/config/opensearch/opensearch-docker-entrypoint.sh
    export OPENSEARCH_JAVA_OPTS="-Dopensearch.cgroups.hierarchy.override=/ ${OPENSEARCH_JAVA_OPTS:-}"
fi

ARGS+=("$@")

info "** Starting Opensearch **"
if am_i_root; then
    exec_as_user "$DB_DAEMON_USER" "$EXEC" "${ARGS[@]}"
else
    exec "$EXEC" "${ARGS[@]}"
fi
