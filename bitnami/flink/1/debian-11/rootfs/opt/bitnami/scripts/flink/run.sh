#!/bin/bash

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
declare -a args=()

cd "${FLINK_BASE_DIR}" || exit 1

args=("${@:1}")
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
  return 1
fi

# Running command
if am_i_root; then
    gosu "$FLINK_DAEMON_USER" "${cmd[@]}" "${args[@]}"
else
    exec "${cmd[@]}" "${args[@]}"
fi
