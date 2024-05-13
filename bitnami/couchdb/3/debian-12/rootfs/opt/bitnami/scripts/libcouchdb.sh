#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami CouchDB library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh

# Functions

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
    if is_boolean_yes "${ALLOW_ANONYMOUS_LOGIN:-}"; then
        print_validation_error "The usage of 'ALLOW_ANONYMOUS_LOGIN' is deprecated. Please, specify a password for the admin user '${COUCHDB_USER}' by setting the 'COUCHDB_PASSWORD' environment variable."
    elif ! is_empty_value "${ALLOW_ANONYMOUS_LOGIN:-}"; then
        warn "The usage of 'ALLOW_ANONYMOUS_LOGIN' is deprecated. It won't be taken into account."
    fi
    if [[ "$COUCHDB_PASSWORD" = "couchdb" ]]; then
        warn "You set the environment variable COUCHDB_PASSWORD=couchdb. This is the default value when bootstrapping CouchDB and should not be used in production environments."
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
    couchdb_conf_set "admins" "$COUCHDB_USER" "$COUCHDB_PASSWORD" "${COUCHDB_CONF_DIR}/local.ini"
    couchdb_conf_set "chttpd" "require_valid_user" "true"
    couchdb_conf_set "couch_httpd_auth" "require_valid_user" "true"
    couchdb_conf_set "httpd" "WWW-Authenticate" 'Basic realm="administrator"'
    is_empty_value "$COUCHDB_SECRET" || couchdb_conf_set "couch_httpd_auth" "secret" "$COUCHDB_SECRET"
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
    couchdb_vm_args_set "-setcookie" "$COUCHDB_SECRET"
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
    local vm_args_content

    if ! is_empty_value "$value"; then
        if grep -q -E "^\s*${key}\s+.*$" "${COUCHDB_CONF_DIR}/vm.args"; then
            vm_args_content="$(sed -E "s/^\s*${key}\s+.*$/${key} ${value}/" "${COUCHDB_CONF_DIR}/vm.args")"
            echo "$vm_args_content" >"${COUCHDB_CONF_DIR}/vm.args"
        else
            echo "${key} ${value}" >>"${COUCHDB_CONF_DIR}/vm.args"
        fi
    fi
}

########################
# Set property in the configuration file
# Globals:
#   COUCHDB_*
# Arguments:
#   $1 - section
#   $2 - key
#   $3 - value
#   $4 - file
# Returns:
#   None
#########################
couchdb_conf_set() {
    local -r section="${1:?section is required}"
    local -r key="${2:?key is required}"
    local -r value="${3:?value is required}"
    local -r file="${4:-${COUCHDB_CONF_FILE}}"

    ini-file set --section "$section" --key "$key" --value "$value" "$file"
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
    am_i_root && start_command=("run_as_user" "$COUCHDB_DAEMON_USER" "${start_command[@]}")
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
    wait-for-port --state free "${COUCHDB_CLUSTER_PORT_NUMBER:-9100}"
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
        local query=("curl" "--request" "PUT" "http://127.0.0.1:${COUCHDB_PORT_NUMBER:-5984}/${db}" "--user" "${COUCHDB_USER}:${COUCHDB_PASSWORD}")
        debug "Creating database '${db}'"
        debug_execute "${query[@]}"
    done
}

########################
# Check if CouchDB is running
# Globals:
#   COUCHDB_PID_FILE
# Arguments:
#   None
# Returns:
#   Whether CouchDB is running
########################
is_couchdb_running() {
    local pid
    pid="$(get_pid_from_file "$COUCHDB_PID_FILE")"
    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if CouchDB is not running
# Globals:
#   COUCHDB_PID_FILE
# Arguments:
#   None
# Returns:
#   Whether CouchDB is not running
########################
is_couchdb_not_running() {
    ! is_couchdb_running
}
