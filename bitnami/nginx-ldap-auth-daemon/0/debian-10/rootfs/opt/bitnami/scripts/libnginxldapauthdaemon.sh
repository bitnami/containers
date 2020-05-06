#!/bin/bash
#
# Bitnami Nginx LDAP Auth Daemon library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libvalidations.sh

########################
# Load global variables used on Nginx LDAP Auth Daemon configuration
# Globals:
#   NGIXNGINXLDAP_*
# Arguments:
#   None
# Returns:
#   Series of exports to be used as 'eval' arguments
#########################
nginxldap_env() {
    cat << "EOF"
# Paths
export NGINXLDAP_BASE_DIR="/opt/bitnami/nginx-ldap-auth-daemon"
export NGINXLDAP_SCRIPT_FILE="${NGINXLDAP_BASE_DIR}/nginx-ldap-auth-daemon.py"
export NGINXLDAP_PYTHON_BIN_DIR="${NGINXLDAP_BASE_DIR}/venv/bin"
export PATH="${NGINXLDAP_PYTHON_BIN_DIR}:$PATH"
# Settings
export NGINXLDAP_HOSTNAME="${NGINXLDAP_HOSTNAME:-0.0.0.0}"
export NGINXLDAP_PORT_NUMBER="${NGINXLDAP_PORT_NUMBER:-8888}"
export NGINXLDAP_LDAP_URI="${NGINXLDAP_LDAP_URI:-}"
export NGINXLDAP_LDAP_BASE_DN="${NGINXLDAP_LDAP_BASE_DN:-}"
export NGINXLDAP_LDAP_BIND_DN="${NGINXLDAP_LDAP_BIND_DN:-}"
export NGINXLDAP_LDAP_BIND_PASSWORD="${NGINXLDAP_LDAP_BIND_PASSWORD:-}"
export NGINXLDAP_LDAP_FILTER="${NGINXLDAP_LDAP_FILTER:-}"
export NGINXLDAP_HTTP_REALM="${NGINXLDAP_HTTP_REALM:-}"
export NGINXLDAP_HTTP_COOKIE_NAME="${NGINXLDAP_HTTP_COOKIE_NAME:-}"
EOF
}

########################
# Validate settings in NGINXLDAP_* environment variables
# Globals:
#   NGINXLDAP_*
# Arguments:
#   None
# Returns:
#   None
#########################
nginxldap_validate() {
    info "Validating settings in NGINXLDAP_* env vars"
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }
    check_allowed_port() {
        local port_var="${1:?missing port variable}"
        local validate_port_args=()
        ! am_i_root && validate_port_args+=("-unprivileged")
        if ! err=$(validate_port "${validate_port_args[@]}" "${!port_var}"); then
            print_validation_error "An invalid port was specified in the environment variable ${port_var}: ${err}."
        fi
    }

    [[ -n "$NGINXLDAP_PORT_NUMBER" ]] && check_allowed_port NGINXLDAP_PORT_NUMBER

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}
