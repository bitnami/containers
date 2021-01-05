#!/bin/bash
#
# Library for operating system actions

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/liblog.sh

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
    getent group "$group" >/dev/null 2>&1
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
    fi

    if [[ -n "$group" ]]; then
        ensure_group_exists "$group"
        usermod -a -G "$group" "$user" >/dev/null 2>&1
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

########################
# Get machine size depending on specified memory
# Globals:
#   None
# Arguments:
#   None
# Flags:
#   --memory - memory size (optional)
# Returns:
#   Detected instance size
#########################
get_machine_size() {
    local memory=""
    # Validate arguments
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            --memory)
                shift
                memory="${1:?missing memory}"
                ;;
            *)
                echo "Invalid command line flag $1" >&2
                return 1
                ;;
        esac
        shift
    done
    if [[ -z "$memory" ]]; then
        debug "Memory was not specified, detecting available memory automatically"
        memory="$(get_total_memory)"
    fi
    sanitized_memory=$(convert_to_mb "$memory")
    if [[ "$sanitized_memory" -gt 26000 ]]; then
        echo 2xlarge
    elif [[ "$sanitized_memory" -gt 13000 ]]; then
        echo xlarge
    elif [[ "$sanitized_memory" -gt 6000 ]]; then
        echo large
    elif [[ "$sanitized_memory" -gt 3000 ]]; then
        echo medium
    elif [[ "$sanitized_memory" -gt 1500 ]]; then
        echo small
    else
        echo micro
    fi
}

########################
# Get machine size depending on specified memory
# Globals:
#   None
# Arguments:
#   $1 - memory size (optional)
# Returns:
#   Detected instance size
#########################
get_supported_machine_sizes() {
    echo micro small medium large xlarge 2xlarge
}

########################
# Convert memory size from string to amount of megabytes (i.e. 2G -> 2048)
# Globals:
#   None
# Arguments:
#   $1 - memory size
# Returns:
#   Result of the conversion
#########################
convert_to_mb() {
    local amount="${1:-}"
    if [[ $amount =~ ^([0-9]+)(m|M|g|G) ]]; then
        size="${BASH_REMATCH[1]}"
        unit="${BASH_REMATCH[2]}"
        if [[ "$unit" = "g" || "$unit" = "G" ]]; then
           amount="$((size * 1024))"
        else
            amount="$size"
        fi
    fi
    echo "$amount"
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
# Retries a command a given number of times
# Arguments:
#   $1 - cmd (as a string)
#   $2 - max retries. Default: 12
#   $3 - sleep between retries (in seconds). Default: 5
# Returns:
#   Boolean
#########################
retry_while() {
    local cmd="${1:?cmd is missing}"
    local retries="${2:-12}"
    local sleep_time="${3:-5}"
    local return_value=1

    read -r -a command <<< "$cmd"
    for ((i = 1 ; i <= retries ; i+=1 )); do
        "${command[@]}" && return_value=0 && break
        sleep "$sleep_time"
    done
    return $return_value
}

########################
# Generate a random string
# Arguments:
#   -t|--type - String type (ascii, alphanumeric, numeric), defaults to ascii
#   -c|--count - Number of characters, defaults to 32
# Arguments:
#   None
# Returns:
#   None
# Returns:
#   String
#########################
generate_random_string() {
    local type="ascii"
    local count="32"
    local filter
    local result
    # Validate arguments
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            -t|--type)
                shift
                type="$1"
                ;;
            -c|--count)
                shift
                count="$1"
                ;;
            *)
                echo "Invalid command line flag $1" >&2
                return 1
                ;;
        esac
        shift
    done
    # Validate type
    case "$type" in
        ascii)
            filter="[:print:]"
            ;;
        alphanumeric)
            filter="a-zA-Z0-9"
            ;;
        numeric)
            filter="0-9"
            ;;
        *)
        echo "Invalid type ${type}" >&2
        return 1
    esac
    # Obtain count + 10 lines from /dev/urandom to ensure that the resulting string has the expected size
    # Note there is a very small chance of strings starting with EOL character
    # Therefore, the higher amount of lines read, this will happen less frequently
    result="$(head -n "$((count + 10))" /dev/urandom | tr -dc "$filter" | head -c "$count")"
    echo "$result"
}

########################
# Create md5 hash from a string
# Arguments:
#   $1 - string
# Returns:
#   md5 hash - string
#########################
generate_md5_hash() {
  local -r str="${1:?missing input string}"
  echo -n "$str" | md5sum | awk '{print $1}'
}
