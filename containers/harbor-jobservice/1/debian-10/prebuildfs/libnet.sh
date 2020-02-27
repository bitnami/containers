#!/bin/bash
#
# Library for network functions

# Load Generic Libraries
. /liblog.sh

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
    if [[ -n "$(dns_lookup "$host")" ]]; then
        true
    else
        false
    fi
}

########################
# Parse URL
# Globals:
#   None
# Arguments:
#   $1 - uri - String
#   $2 - component to obtain. Valid options (scheme, authority, userinfo, host, port, path, query or fragment) - String
# Returns:
#   String
parse_uri() {
    local uri="${1:?uri is missing}"
    local component="${2:?component is missing}"

    # Solution based on https://tools.ietf.org/html/rfc3986#appendix-B with
    # additional sub-expressions to split authority into userinfo, host and port
    # Credits to Patryk Obara (see https://stackoverflow.com/a/45977232/6694969)
    local -r URI_REGEX='^(([^:/?#]+):)?(//((([^@/?#]+)@)?([^:/?#]+)(:([0-9]+))?))?(/([^?#]*))?(\?([^#]*))?(#(.*))?'
    #                    ||            |  |||            |         | |            | |         |  |        | |
    #                    |2 scheme     |  ||6 userinfo   7 host    | 9 port       | 11 rpath  |  13 query | 15 fragment
    #                    1 scheme:     |  |5 userinfo@             8 :...         10 path     12 ?...     14 #...
    #                                  |  4 authority
    #                                  3 //...
    local index=0
    case "$component" in
        scheme)
            index=2
            ;;
        authority)
            index=4
            ;;
        userinfo)
            index=6
            ;;
        host)
            index=7
            ;;
        port)
            index=9
            ;;
        path)
            index=10
            ;;
        query)
            index=13
            ;;
        fragment)
            index=14
            ;;
        *)
            stderr_print "unrecognized component $component"
            return 1
            ;;
    esac
    [[ "$uri" =~ $URI_REGEX ]] && echo "${BASH_REMATCH[${index}]}"
}
