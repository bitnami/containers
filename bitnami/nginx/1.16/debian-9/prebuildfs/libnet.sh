#!/bin/bash
#
# Library for network functions

# Functions

########################
# Resolve dns
# Arguments:
#   $1 - Hostname to resolve
# Returns:
#   IP
#########################
dns_lookup() {
    local host="${1:?host is missing}"
    getent ahosts "$host" | awk '/STREAM/ {print $1 }'    
}

########################
# Get machine's IP
# Arguments:
#   None
# Returns:
#   Machine IP
#########################
get_machine_ip() {
    dns_lookup "$(hostname)"
}

########################
# Check if the provided argument is a resolved hostname
# Arguments:
#   $1 - Value to check
# Returns:
#   Boolean
#########################
is_hostname_resolved() {
    local -r host="${1:?missing value}"
    if dns_lookup "$host" > /dev/null; then
        true
    else
        false 
    fi
}
