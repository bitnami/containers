#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libcassandra.sh
. /opt/bitnami/scripts/libos.sh

# Load Cassandra environment variables
. /opt/bitnami/scripts/cassandra-env.sh

# As we cannot use "local" we will use "readonly" for read-only variables.
# The scope of "readonly" is global, so we attach "__run_" to avoid conflicts
# with other variables in libcassandra.sh

info "** Starting Cassandra **"

# During the startup logic, we bootstap Cassandra. This is because Cassandra seeder nodes
# need to be able to connect to each other, and after that authentication can be configured.
# However, some applications may detect at this point that the database is ready.
# While in other bitnami containers we would stop the database and run it in foreground,
# we prefer keeping it running in this case.
# So, in this run.sh script, we first check if Cassandra was already running in
# one of the two cases:
#
#  1) Initial cluster initialization
#  2) Init scripts
#
# If none of the two cases apply, we assume it is an error and exit
if is_cassandra_running; then
    __run_pid="$(get_pid_from_file "$DB_PID_FILE")"
    running_log_file=""

    if [[ -f "$DB_FIRST_BOOT_LOG_FILE" ]]; then
        running_log_file="$DB_FIRST_BOOT_LOG_FILE"
        info "Cassandra already running with PID $__run_pid because of the initial cluster setup"
    elif [[ -f "$DB_INITSCRIPTS_BOOT_LOG_FILE" ]]; then
        running_log_file="$DB_INITSCRIPTS_BOOT_LOG_FILE"
        info "Cassandra already running PID $__run_pid because of the init scripts execution"
    else
        error "Cassandra is already running for an unexpected reason. Exiting"
        exit 1
    fi

    info "Tailing $running_log_file"
    __run_tail_cmd="$(which tail)"
    readonly __run_tail_flags=("--pid=${__run_pid}" "-n" "1000" "-f" "$running_log_file")

    if am_i_root; then
        exec_as_user "$DB_DAEMON_USER" "${__run_tail_cmd}" "${__run_tail_flags[@]}"
    else
        exec "${__run_tail_cmd}" "${__run_tail_flags[@]}"
    fi
else
    readonly __run_cmd="${DB_BIN_DIR}/cassandra"
    readonly __run_flags=("-p $DB_PID_FILE" "-R" "-f")
    if am_i_root; then
        exec_as_user "$DB_DAEMON_USER" "${__run_cmd}" "${__run_flags[@]}"
    else
        exec "${__run_cmd}" "${__run_flags[@]}"
    fi
fi
