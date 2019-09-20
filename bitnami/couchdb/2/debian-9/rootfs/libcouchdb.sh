#!/bin/bash
#
# Bitnami CouchDB library

# shellcheck disable=SC1090
# shellcheck disable=SC1091

# Load Generic Libraries
. /liblog.sh
. /libos.sh
. /libvalidations.sh

# Functions

########################
# Load global variables used on CouchDB configuration
# Globals:
#   COUCHDB_*
# Arguments:
#   None
# Returns:
#   Series of exports to be used as 'eval' arguments
#########################
couchdb_env() {
    cat <<"EOF"
# Format log messages
export MODULE="couchdb"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"
# Paths
export COUCHDB_BASE_DIR="/opt/bitnami/couchdb"
export COUCHDB_VOLUME_DIR="/bitnami/couchdb"
export COUCHDB_BIN_DIR="${COUCHDB_BASE_DIR}/bin"
export COUCHDB_DATA_DIR="${COUCHDB_VOLUME_DIR}/data"
export COUCHDB_CONF_DIR="${COUCHDB_BASE_DIR}/etc"
export COUCHDB_CONF_FILE="${COUCHDB_CONF_DIR}/default.d/10-bitnami.ini"
# Users
export COUCHDB_DAEMON_USER="couchdb"
export COUCHDB_DAEMON_GROUP="couchdb"
# CouchDB settings
export COUCHDB_NODENAME="${COUCHDB_NODENAME:-}"
export COUCHDB_PORT_NUMBER="${COUCHDB_PORT_NUMBER:-}"
export COUCHDB_CLUSTER_PORT_NUMBER="${COUCHDB_CLUSTER_PORT_NUMBER:-}"
export COUCHDB_BIND_ADDRESS="${COUCHDB_BIND_ADDRESS:-}"
export COUCHDB_CREATE_DATABASES="${COUCHDB_CREATE_DATABASES:-yes}"
# Authentication
export ALLOW_ANONYMOUS_LOGIN="${ALLOW_ANONYMOUS_LOGIN:-no}"
export COUCHDB_USER="${COUCHDB_USER:-}"
EOF
    if [[ -f "${COUCHDB_PASSWORD_FILE:-}" ]]; then
        cat <<"EOF"
export COUCHDB_PASSWORD="$(< "${COUCHDB_PASSWORD_FILE}")"
EOF
    else
        cat <<"EOF"
export COUCHDB_PASSWORD="${COUCHDB_PASSWORD:-}"
EOF
    fi
    if [[ -f "${COUCHDB_SECRET_FILE:-}" ]]; then
        cat <<"EOF"
export COUCHDB_SECRET="$(< "${COUCHDB_SECRET_FILE}")"
EOF
    else
        cat <<"EOF"
export COUCHDB_SECRET="${COUCHDB_SECRET:-}"
EOF
    fi
}

########################
# Validate settings in COUCHDB_* env vars
# Globals:
#   COUCHDB_*
# Arguments:
#   None
# Returns:
#   None
#########################
couchdb_validate() {
    local error_code=0
    debug "Validating settings in COUCHDB_* env vars..."

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    check_password_file() {
        if ! is_empty_value "${!1:-}" && ! [[ -f "${!1:-}" ]]; then
            print_validation_error "The variable $1 is defined but the file ${!1} is not accessible or does not exist."
        fi
    }

    # CouchDB secret files validations
    check_password_file COUCHDB_PASSWORD_FILE
    check_password_file COUCHDB_SECRET_FILE

    # CouchDB authentication validations
    if ! is_yes_no_value "$ALLOW_ANONYMOUS_LOGIN"; then
        print_validation_error "The allowed values for ALLOW_ANONYMOUS_LOGIN are [yes, no]"
    elif is_boolean_yes "$ALLOW_ANONYMOUS_LOGIN"; then
        warn "You have set the environment variable ALLOW_ANONYMOUS_LOGIN=${ALLOW_ANONYMOUS_LOGIN}. For safety reasons, do not use this flag in a production environment."
    else
        if is_empty_value "$COUCHDB_PASSWORD"; then
            print_validation_error "ALLOW_ANONYMOUS_LOGIN is set to 'no'. Please, specify a password for the admin user by setting the 'COUCHDB_PASSWORD' or 'COUCHDB_PASSWORD_FILE' environment variables."
        fi
        if is_empty_value "$COUCHDB_USER"; then
            print_validation_error "ALLOW_ANONYMOUS_LOGIN is set to 'no'. Please, specify an admin username by setting the 'COUCHDB_USER' environment variable."
        fi
    fi

    # CouchDB port validations
    for p in COUCHDB_PORT_NUMBER COUCHDB_CLUSTER_PORT_NUMBER; do
        if ! is_empty_value "${!p}" && ! err=$(validate_port -unprivileged "${!p}"); then
            print_validation_error "An invalid port was specified in the environment variable ${p}: ${err}"
        fi
    done

    # CouchDB create database validations
    if ! is_yes_no_value "$COUCHDB_CREATE_DATABASES"; then
        print_validation_error "The allowed values for COUCHDB_CREATE_DATABASES are [yes, no]"
    fi
    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Ensure CouchDB is initialized
# Globals:
#   COUCHDB_*
# Arguments:
#   None
# Returns:
#   None
#########################
couchdb_initialize() {
    info "Initializing CouchDB..."
    if [[ -w "$COUCHDB_CONF_FILE" ]]; then
        info "Updating '${COUCHDB_CONF_FILE}' based on user configuration..."
        couchdb_update_conf_file
    else
        warn "'${COUCHDB_CONF_FILE}' is not writable by the current user. Skipping modifications..."
    fi
    if [[ -w "${COUCHDB_CONF_DIR}/vm.args" ]]; then
        info "Updating '${COUCHDB_CONF_DIR}/vm.args' based on user configuration..."
        couchdb_update_vm_args_file
    else
        warn "'${COUCHDB_CONF_DIR}/vm.args' is not writable by the current user. Skipping modifications..."
    fi

    if is_dir_empty "$COUCHDB_DATA_DIR"; then
        info "Deploying CouchDB from scratch"
        if is_boolean_yes "$COUCHDB_CREATE_DATABASES"; then
            couchdb_start_bg
            couchdb_create_initial_databases
            couchdb_stop
        fi
    else
        info "Deploying CouchDB with persisted data"
    fi
}

########################
# Update the CouchDB configuration file with the user inputs
# Globals:
#   COUCHDB_*
# Arguments:
#   None
# Returns:
#   None
#########################
couchdb_update_conf_file() {
    is_empty_value "$COUCHDB_PORT_NUMBER" || couchdb_conf_set "chttpd" "port" "$COUCHDB_PORT_NUMBER"
    is_empty_value "$COUCHDB_BIND_ADDRESS" || couchdb_conf_set "chttpd" "bind_address" "$COUCHDB_BIND_ADDRESS"
    if ! is_boolean_yes "$ALLOW_ANONYMOUS_LOGIN"; then
        couchdb_conf_set "admins" "$COUCHDB_USER" "$COUCHDB_PASSWORD"
        couchdb_conf_set "chttpd" "require_valid_user" "true"
        couchdb_conf_set "couch_httpd_auth" "require_valid_user" "true"
        couchdb_conf_set "httpd" "WWW-Authenticate" 'Basic realm="administrator"'
        is_empty_value "$COUCHDB_SECRET" || couchdb_conf_set "couch_httpd_auth" "secret" "$COUCHDB_SECRET"
    fi
}

########################
# Update the Erlang configuration file with the user inputs
# Globals:
#   COUCHDB_*
# Arguments:
#   None
# Returns:
#   None
#########################
couchdb_update_vm_args_file() { # TODO Confirm that works
    couchdb_vm_args_set "-name" "$COUCHDB_NODENAME"
    couchdb_vm_args_set "-kernel inet_dist_listen_min" "$COUCHDB_CLUSTER_PORT_NUMBER"
    couchdb_vm_args_set "-kernel inet_dist_listen_max" "$COUCHDB_CLUSTER_PORT_NUMBER"
}

########################
# Set property in the Erlang configuration file
# Globals:
#   COUCHDB_*
# Arguments:
#   - key
#   - value
# Returns:
#   None
#########################
couchdb_vm_args_set() {
    local -r key="${1:?key is required}"
    local -r value="${2:-}"

    if ! is_empty_value "$value"; then
        if grep -q -E "^\s*${key}\s+.*$" "${COUCHDB_CONF_DIR}/vm.args"; then
            sed -i -E "s/^\s*${key}\s+.*$/${key} ${value}/" "${COUCHDB_CONF_DIR}/vm.args"
        else
            echo "${key} ${value}" >> "${COUCHDB_CONF_DIR}/vm.args"
        fi
    fi
}

########################
# Set property in the local.ini configuration file
# Globals:
#   COUCHDB_*
# Arguments:
#   $1 - section
#   $2 - key
#   $3 - value
# Returns:
#   None
#########################
couchdb_conf_set() {
    local -r section="${1:?section is required}"
    local -r key="${2:?key is required}"
    local -r value="${3:?value is required}"

    ini-file set --section "$section" --key "$key" --value "$value" "$COUCHDB_CONF_FILE"
}

########################
# Start CouchDB in background mode and waits until it's ready
# Globals:
#   COUCHDB_*
# Arguments:
#   None
# Returns:
#   None
#########################
couchdb_start_bg() {
    info "Starting CouchDB in background..."
    local start_command=("${COUCHDB_BIN_DIR}/couchdb")
    am_i_root && start_command=("gosu" "$COUCHDB_DAEMON_USER" "${start_command[@]}")
    debug_execute "${start_command[@]}" &
    wait-for-port "${COUCHDB_PORT_NUMBER:-5984}"
    wait-for-port "${COUCHDB_CLUSTER_PORT_NUMBER:-9100}"
}

########################
# Stop CouchDB
# Globals:
#   COUCHDB_*
# Arguments:
#   None
# Returns:
#   None
#########################
couchdb_stop() {
    info "Stopping CouchDB..."
    pkill --full --signal TERM "$COUCHDB_BASE_DIR"
    wait-for-port --state free "${COUCHDB_PORT_NUMBER:-5984}"
    wait-for-port --state free  "${COUCHDB_CLUSTER_PORT_NUMBER:-9100}"
}

########################
# Create initial databases for CouchDB
# Globals:
#   COUCHDB_*
# Arguments:
#   None
# Returns:
#   None
#########################
couchdb_create_initial_databases() {
    info "Creating initial databases..."
    for db in _users _replicator _global_changes; do
        local query=("curl" "--request" "PUT" "http://127.0.0.1:${COUCHDB_PORT_NUMBER:-5984}/${db}")
        is_boolean_yes "$ALLOW_ANONYMOUS_LOGIN" || query+=("--user" "${COUCHDB_USER}:${COUCHDB_PASSWORD}")
        debug "Creating database '${db}'"
        debug_execute "${query[@]}"
    done
}
