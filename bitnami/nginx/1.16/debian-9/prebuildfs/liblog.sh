#!/bin/bash
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
    printf "%b\\n" "${*}" >&2
}

########################
# Log message
# Arguments:
#   Message to log
# Returns:
#   None
#########################
log() {
    stderr_print "${NAMI_DEBUG:+${CYAN}${MODULE} ${MAGENTA}$(date "+%T.%2N ")}${RESET}${*}"
}
########################
# Log an 'info' message
# Arguments:
#   Message to log
# Returns:
#   None
#########################
info() {
    log "${GREEN}INFO ${RESET} ==> ${*}"
}
########################
# Log message
# Arguments:
#   Message to log
# Returns:
#   None
#########################
warn() {
    log "${YELLOW}WARN ${RESET} ==> ${*}"
}
########################
# Log an 'error' message
# Arguments:
#   Message to log
# Returns:
#   None
#########################
error() {
    log "${RED}ERROR${RESET} ==> ${*}"
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
    if [[ "${BITNAMI_DEBUG:-false}" = true ]]; then
	log "${MAGENTA}DEBUG${RESET} ==> ${*}"
    fi
}
