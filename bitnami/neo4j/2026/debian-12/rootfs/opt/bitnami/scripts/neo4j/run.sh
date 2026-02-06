#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Neo4j environment
. /opt/bitnami/scripts/neo4j-env.sh

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libneo4j.sh

info "** Starting Neo4j **"
if am_i_root; then
    run_as_user "$NEO4J_DAEMON_USER" "${NEO4J_BASE_DIR}/bin/neo4j" "start" "$@"
else
    "${NEO4J_BASE_DIR}/bin/neo4j" "start" "$@"
fi

## Neo4j start command does not have the option to start as foreground, and neo4j console does not integrate correctly
## with the Neo4j CLI (status, stop, and others) so we need to track the log file
## Source: https://neo4j.com/docs/operations-manual/current/configuration/cli-commands/

pid="$(get_pid_from_file "$NEO4J_PID_FILE")"

info "Tailing ${NEO4J_LOG_FILE}"
cmd="$(which tail)"
flags=("--pid=${pid}" "-n" "1000" "-f" "$NEO4J_LOG_FILE")

if am_i_root; then
    exec_as_user "$NEO4J_DAEMON_USER" "$cmd" "${flags[@]}"
else
    exec "$cmd" "${flags[@]}"
fi
