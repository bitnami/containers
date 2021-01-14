#!/bin/bash
#
# Bitnami Spring Cloud Dataflow Compose Task Runner entrypoint

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libbitnami.sh

# Load Spring Cloud Dataflow Compose Task Runner environment variables
. /opt/bitnami/scripts/scdf-composed-task-runner-env.sh

print_welcome_page

am_i_root && ensure_user_exists "$SCDF_COMPOSED_TASK_RUNNER_DAEMON_USER" "$SCDF_COMPOSED_TASK_RUNNER_DAEMON_GROUP"

info "** Starting Spring Cloud Dataflow Compose Task Runner **"

__run_cmd="java"
__run_flags=($JAVA_OPTS "-jar" "-Duser.home=${HOME}" "${SCDF_COMPOSED_TASK_RUNNER_BASE_DIR}/scdf-composed-task-runner.jar" "$@")

if am_i_root; then
    exec gosu "$SCDF_COMPOSED_TASK_RUNNER_DAEMON_USER" "$__run_cmd" "${__run_flags[@]}"
else
    exec "$__run_cmd" "${__run_flags[@]}"
fi
