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
. /opt/bitnami/scripts/libflink.sh

# Load Apache Flink environment variables
. /opt/bitnami/scripts/flink-env.sh

# Declare commands env vars
export COMMAND_STANDALONE="standalone-job"
export COMMAND_HISTORY_SERVER="history-server"

declare cmd
declare -a args=("")

cd "${FLINK_BASE_DIR}" || exit 1

# If nothing is provided as '$@', this assignation throws
# an unbound variable error for Bash versions < 4.4.
# https://git.savannah.gnu.org/cgit/bash.git/tree/CHANGES?id=3ba697465bc74fab513a26dea700cc82e9f4724e#n878
if [[ "$#" -gt 0 ]]; then
    args=("${@:1}")
fi

if [[ "$FLINK_MODE" = "help" ]]; then
    # shellcheck disable=SC2059
    printf "Available flink modes: $(basename "$0") jobmanager,${COMMAND_STANDALONE},taskmanager,${COMMAND_HISTORY_SERVER}\n"
    # shellcheck disable=SC2059
    printf "Usage: FLINK_MODE=(jobmanager|${COMMAND_STANDALONE}|taskmanager|${COMMAND_HISTORY_SERVER})\n\n"
    printf "By default, the Apache Flink Packaged by Bitnami  image will run in jobmanager mode.\n"
    printf "Also, by default, Apache Flink Packaged by Bitnami image adopts jemalloc as default memory allocator. This behavior can be disabled by setting the 'DISABLE_JEMALLOC' environment variable to 'true'.\n"
    exit 0
elif [[ "$FLINK_MODE" = "jobmanager" ]]; then

    info "** Starting Apache Flink Job Manager"

    cmd="$FLINK_HOME/bin/jobmanager.sh"
    args=("start-foreground" "${args[@]}")
elif [[ "$FLINK_MODE" = "${COMMAND_STANDALONE}" ]]; then

    info "** Starting Apache Flink Job Manager"

    cmd="$FLINK_HOME/bin/standalone-job.sh"
    args=("start-foreground" "${args[@]}")
elif [[ "$FLINK_MODE" = "${COMMAND_HISTORY_SERVER}" ]]; then

    info "** Starting Apache Flink History Server"

    cmd="$FLINK_HOME/bin/historyserver.sh"
    args=("start-foreground" "${args[@]}")
elif [[ "$FLINK_MODE" = "taskmanager" ]]; then

    info "** Starting Apache Flink Task Manager"

    cmd="$FLINK_HOME/bin/taskmanager.sh"
    args=("start-foreground" "${args[@]}")
else
  error "Flink mode not recognized"
  exit 1
fi

# Running command
if am_i_root; then
    exec_as_user "$FLINK_DAEMON_USER" "${cmd[@]}" "${args[@]}"
else
    exec "${cmd[@]}" "${args[@]}"
fi
