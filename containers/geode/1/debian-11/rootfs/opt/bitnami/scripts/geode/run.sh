#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libgeode.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libservice.sh

# Load Apache Geode environment
. /opt/bitnami/scripts/geode-env.sh

declare -a start_flags
read -r -a start_flags <<< "$(geode_start_flags)"
start_flags+=("$@")

info "** Starting Apache Geode **"
if am_i_root; then
    if [[ "$GEODE_NODE_TYPE" = "locator" ]] && is_mounted_dir_empty "$GEODE_DATA_DIR"; then
        gosu "$GEODE_DAEMON_USER" gfsh -e "start $GEODE_NODE_TYPE ${start_flags[*]}" -e "$GEODE_LOCATOR_START_COMMAND"
    else
        gosu "$GEODE_DAEMON_USER" gfsh -e "start $GEODE_NODE_TYPE ${start_flags[*]}"
    fi
else
    if [[ "$GEODE_NODE_TYPE" = "locator" ]] && is_mounted_dir_empty "$GEODE_DATA_DIR"; then
        gfsh -e "start $GEODE_NODE_TYPE ${start_flags[*]}" -e "$GEODE_LOCATOR_START_COMMAND"
    else
        gfsh -e "start $GEODE_NODE_TYPE ${start_flags[*]}"
    fi
fi
info "** Apache Geode started! **"

# The 'gfsh start ...' command creates a new JAVA process in
# background. We need to tail the log file to avoid the container
# to exit while this process is up
info "** Tailing ${GEODE_NODE_TYPE}.log **"
declare pid_file="${GEODE_DATA_DIR}/vf.gf.${GEODE_NODE_TYPE}.pid"
exec tail -c+1 --pid="$(get_pid_from_file "$pid_file")" -f "${GEODE_LOGS_DIR}/${GEODE_NODE_TYPE}.log"
