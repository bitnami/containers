#!/bin/bash
#
# Library for operating system actions

# Functions

########################
# Check if an user exists in the system
# Arguments:
#   $1 - user
# Returns:
#   Boolean
#########################
user_exists() {
    local user="${1:?user is missing}"
    id "$user" >/dev/null 2>&1
}

########################
# Check if a group exists in the system
# Arguments:
#   $1 - group
# Returns:
#   Boolean
#########################
group_exists() {
    local group="${1:?group is missing}"
    getent group "$group"
}

########################
# Create a group in the system if it does not exist already
# Arguments:
#   $1 - group
# Returns:
#   None
#########################
ensure_group_exists() {
    local group="${1:?group is missing}"

    if ! group_exists "$group"; then
        groupadd "$group" >/dev/null 2>&1
    fi
}

########################
# Create an user in the system if it does not exist already
# Arguments:
#   $1 - user
#   $2 - group
# Returns:
#   None
#########################
ensure_user_exists() {
    local user="${1:?user is missing}"
    local group="${2:-}"

    if ! user_exists "$user"; then
	useradd "$user" >/dev/null 2>&1
        if [[ -n "$group" ]]; then
            ensure_group_exists "$group"
            usermod -a -G "$group" "$user" >/dev/null 2>&1
        fi
    fi
}

########################
# Check if the script is currently running as root
# Arguments:
#   $1 - user
#   $2 - group
# Returns:
#   Boolean
#########################
am_i_root() {
    if [[ "$(id -u)" = "0" ]]; then
        true
    else
	false
    fi
}

########################
# Get total memory available
# Arguments:
#   None
# Returns:
#   Memory in bytes
#########################
get_total_memory() {
    echo $(($(grep MemTotal /proc/meminfo | awk '{print $2}') / 1024))
}

#########################
# Redirects output to /dev/null if debug mode is disabled
# Globals:
#   BITNAMI_DEBUG
# Arguments:
#   $@ - Command to execute
# Returns:
#   None
#########################
debug_execute() {
    if ${BITNAMI_DEBUG:-false}; then
        "$@"
    else
        "$@" >/dev/null 2>&1
    fi
}

########################
# Retries a command until timeout
# Arguments:
#   $1 - cmd (as a string)
#   $2 - timeout (in seconds). Default: 60
#   $3 - step (in seconds). Default: 5
# Returns:
#   Boolean
#########################
retry_while() {
    local -r cmd="${1:?cmd is missing}"
    local -r timeout="${2:-60}"
    local -r step="${3:-5}"
    local return_value=1

    read -r -a command <<< "$cmd"
    for ((i = 0 ; i <= timeout ; i+=step )); do
        "${command[@]}" && return_value=0 && break
        sleep "$step"
    done
    return $return_value
}
