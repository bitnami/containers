#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Library for logging functions

# Constants
RESET='\033[0m'
RED='\033[38;5;1m'
GREEN='\033[38;5;2m'
YELLOW='\033[38;5;3m'
MAGENTA='\033[38;5;5m'
CYAN='\033[38;5;6m'

# Functions

########################
# Print to STDERR
# Arguments:
#   Message to print
# Returns:
#   None
#########################
stderr_print() {
    # 'is_boolean_yes' is defined in libvalidations.sh, but depends on this file so we cannot source it
    local bool="${BITNAMI_QUIET:-false}"
    # comparison is performed without regard to the case of alphabetic characters
    shopt -s nocasematch
    if ! [[ "$bool" = 1 || "$bool" =~ ^(yes|true)$ ]]; then
        printf "%b\\n" "${*}" >&2
    fi
}

########################
# Log message
# Arguments:
#   Message to log
# Returns:
#   None
#########################
log() {
    local prefix=""
    local suffix=""
    local color_check="${BITNAMI_COLOR:-true}"
    if [[ "$color_check" =~ ^(yes|true)$ ]]; then
        prefix="${CYAN}${MODULE:-} ${MAGENTA}$(date "+%T.%2N ")${RESET}"
        suffix="${RESET}"
    else
        prefix="${MODULE:-} $(date "+%T.%2N ")"
    fi
    stderr_print "${prefix}${*}${suffix}"
}
########################
# Log an 'info' message
# Arguments:
#   Message to log
# Returns:
#   None
#########################
info() {
    local msg_color="$GREEN"
    local reset_color="$RESET"
    local color_check="${BITNAMI_COLOR:-true}"
    if ! [[ "$color_check" =~ ^(yes|true)$ ]]; then
        msg_color=""
        reset_color=""
    fi
    log "${msg_color}INFO ${reset_color} ==> ${*}"
}
########################
# Log message
# Arguments:
#   Message to log
# Returns:
#   None
#########################
warn() {
    local msg_color="$YELLOW"
    local reset_color="$RESET"
    local color_check="${BITNAMI_COLOR:-true}"
    if ! [[ "$color_check" =~ ^(yes|true)$ ]]; then
        msg_color=""
        reset_color=""
    fi
    log "${msg_color}WARN ${reset_color} ==> ${*}"
}
########################
# Log an 'error' message
# Arguments:
#   Message to log
# Returns:
#   None
#########################
error() {
    local msg_color="$RED"
    local reset_color="$RESET"
    local color_check="${BITNAMI_COLOR:-true}"
    if ! [[ "$color_check" =~ ^(yes|true)$ ]]; then
        msg_color=""
        reset_color=""
    fi
    log "${msg_color}ERROR${reset_color} ==> ${*}"
}
########################
# Log an 'errorX' message
# Arguments:
#   Message to log
# Returns:
#   None
#########################
errorX() {
    local msg_color="$RED"
    local reset_color="$RESET"
    local color_check="${BITNAMI_COLOR:-true}"
    if ! [[ "$color_check" =~ ^(yes|true)$ ]]; then
        msg_color=""
        reset_color=""
    fi
    log "${msg_color}ERROR${reset_color} ==> ${*}"
    exit 1
}
########################
# Log a 'debug' message
# Globals:
#   BITNAMI_DEBUG
# Arguments:
#   None
# Returns:
#   None
#########################
debug() {
    local msg_color="$MAGENTA"
    local reset_color="$RESET"
    local color_check="${BITNAMI_COLOR:-true}"
    if ! [[ "$color_check" =~ ^(yes|true)$ ]]; then
        msg_color=""
        reset_color=""
    fi
    # comparison is performed without regard to the case of alphabetic characters
    shopt -s nocasematch
    local debug_bool="${BITNAMI_DEBUG:-false}"
    if [[ "$debug_bool" = 1 || "$debug_bool" =~ ^(yes|true)$ ]]; then
        log "${msg_color}DEBUG${reset_color} ==> ${*}"
    fi
}
########################
# Indent a string
# Arguments:
#   $1 - string
#   $2 - number of indentation characters (default: 4)
#   $3 - indentation character (default: " ")
# Returns:
#   None
#########################
indent() {
    local string="${1:-}"
    local num="${2:?missing num}"
    local char="${3:-" "}"
    # Build the indentation unit string
    local indent_unit=""
    for ((i = 0; i < num; i++)); do
        indent_unit="${indent_unit}${char}"
    done
    # shellcheck disable=SC2001
    # Complex regex, see https://github.com/koalaman/shellcheck/wiki/SC2001#exceptions
    echo "$string" | sed "s/^/${indent_unit}/"
}
