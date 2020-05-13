#!/bin/bash
#
# Library for managing services

# Functions

########################
# Read the provided pid file and returns a PID
# Arguments:
#   $1 - Pid file
# Returns:
#   PID
#########################
get_pid_from_file() {
    local pid_file="${1:?pid file is missing}"

    if [[ -f "$pid_file" ]]; then
        if [[ -n "$(< "$pid_file")" ]] && [[ "$(< "$pid_file")" -gt 0 ]]; then
            echo "$(< "$pid_file")"
        fi
    fi
}

########################
# Check if a provided PID corresponds to a running service
# Arguments:
#   $1 - PID
# Returns:
#   Boolean
#########################
is_service_running() {
    local pid="${1:?pid is missing}"

    kill -0 "$pid" 2>/dev/null
}

########################
# Stop a service by sending a termination signal to its pid
# Arguments:
#   $1 - Pid file
#   $2 - Signal number (optional)
# Returns:
#   None
#########################
stop_service_using_pid() {
    local pid_file="${1:?pid file is missing}"
    local signal="${2:-}"
    local pid

    pid="$(get_pid_from_file "$pid_file")"
    [[ -z "$pid" ]] || ! is_service_running "$pid" && return

    if [[ -n "$signal" ]]; then
        kill "-${signal}" "$pid"
    else
        kill "$pid"
    fi

    local counter=10
    while [[ "$counter" -ne 0 ]] && is_service_running "$pid"; do
        sleep 1
        counter=$((counter - 1))
    done
}

########################
# Generate a monit configuration file for a given service
# Arguments:
#   $1 - Service name
#   $2 - Pid file
#   $3 - Start command
#   $4 - Stop command
# Returns:
#   None
#########################
generate_monit_conf() {
    local -r service_name="${1:?service name is missing}"
    local -r pid_file="${2:?pid file is missing}"
    local -r start_command="${3:?start command is missing}"
    local -r stop_command="${4:?stop command is missing}"
    local -r monit_conf_dir="/etc/monit/conf.d"

    mkdir -p "$monit_conf_dir"
    cat >"${monit_conf_dir}/${service_name}.conf" <<EOF
check process ${service_name}
  with pidfile "${pid_file}"
  start program = "${start_command}" with timeout 90 seconds
  stop program = "${stop_command}" with timeout 90 seconds
EOF
}

########################
# Generate a logrotate configuration file
# Arguments:
#   $1 - Log path
#   $2 - Period
#   $3 - Number of rotations to store
#   $4 - Extra options (Optional)
# Returns:
#   None
#########################
generate_logrotate_conf() {
    local -r service_name="${1:?service name is missing}"
    local -r log_path="${2:?log path is missing}"
    local -r period="${3:-weekly}"
    local -r rotations="${4:-150}"
    local -r extra_options="${5:-}"
    local -r logrotate_conf_dir="/etc/logrotate.d"

    mkdir -p "$logrotate_conf_dir"
    cat >"${logrotate_conf_dir}/${service_name}" <<EOF
${log_path} {
  ${period}
  rotate ${rotations}
  dateext
  compress
  copytruncate
  missingok
  ${extra_options}
}
EOF
}
