#!/bin/bash
#
# Bitnami Memcached library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh

# Functions

########################
# Validate settings in MEMCACHED_* env vars
# Globals:
#   MEMCACHED_PORT_NUMBER
# Arguments:
#   None
# Returns:
#   None
#########################
memcached_validate() {
    local error_code=0
    debug "Validating settings in MEMCACHED_* env vars"

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    # Memcached port validation
    local validate_port_args=()
    validate_port_args+=("-unprivileged")
    if ! err=$(validate_port "${validate_port_args[@]}" "${MEMCACHED_PORT_NUMBER}"); then
        print_validation_error "An invalid port was specified in the environment variable MEMCACHED_PORT_NUMBER: $err"
    fi

    # Memcached Cache Size validation
    if [[ -n "${MEMCACHED_CACHE_SIZE}" ]] && ! is_positive_int "${MEMCACHED_CACHE_SIZE}"; then
        print_validation_error "The variable MEMCACHED_CACHE_SIZE must be positive integer"
    fi

    # Memcached Max Connections validation
    if [[ -n "${MEMCACHED_MAX_CONNECTIONS}" ]] && ! is_positive_int "${MEMCACHED_MAX_CONNECTIONS}"; then
        print_validation_error "The variable MEMCACHED_MAX_CONNECTIONS must be positive integer"
    fi

    # Memcached Threads validation
    if [[ -n "${MEMCACHED_THREADS}" ]] && ! is_positive_int "${MEMCACHED_THREADS}"; then
        print_validation_error "The variable MEMCACHED_THREADS must be positive integer"
    fi

    [[ "${error_code}" -eq 0 ]] || exit "${error_code}"
}

########################
# Ensure Memcached is initialized
# Globals:
#   MEMCACHED_USERNAME
#   MEMCACHED_PASSWORD
# Arguments:
#   None
# Returns:
#   None
#########################
memcached_initialize() {
    info "Initializing Memcached"

    if [[ ! -f "${SASL_CONF_FILE}" && -n "${MEMCACHED_PASSWORD}" ]]; then
        info "Enabling authentication"
        memcached_enable_authentication "${MEMCACHED_USERNAME}" "${MEMCACHED_PASSWORD}"
    fi
}

########################
# Create SASL user
# Globals:
#   SASL_DB_FILE
# Arguments:
#   $1 - username
#   $2 - password
# Returns:
#   None
#########################
memcached_create_user() {
    local user="${1:?user is required}"
    local password="${2:?password is required}"
    debug "Creating memcached user '${user}'"
    echo "${password}" | saslpasswd2 -f "${SASL_DB_FILE}" -a "memcached" -c "${user}" -p
    # The SASL database file is created with 0640 permissions and owned by the creation user
    # In order to Memcached having write privileges over the file, only the group will be set
    ! am_i_root || chgrp "${MEMCACHED_DAEMON_GROUP}" "${SASL_DB_FILE}"
}

########################
# Enable authentication for Memcached
# Globals:
#   SASL_CONF_FILE
#   SASL_DB_FILE
# Arguments:
#   $1 - username
#   $2 - password
# Returns:
#   None
#########################
memcached_enable_authentication() {
    local user="${1:?user is required}"
    local password="${2:?password is required}"

    memcached_create_user "${user}" "${password}"

    debug "Generating config file '${SASL_CONF_FILE}'"
    cat > "${SASL_CONF_FILE}" <<EOF
mech_list: plain
sasldb_path: ${SASL_DB_FILE}
EOF
}

########################
# Check if Memcached is running
# Globals:
#   MEMCACHED_PID_FILE
# Arguments:
#   None
# Returns:
#   Whether memcached is running
#########################
is_memcached_running() {
    local pid
    pid="$(get_pid_from_file "${MEMCACHED_PID_FILE}")"
    if [[ -n "${pid}" ]]; then
        is_service_running "${pid}"
    else
        false
    fi
}

########################
# Check if Memcached is not running
# Globals:
#   MEMCACHED_PID_FILE
# Arguments:
#   None
# Returns:
#   Whether memcached is not running
#########################
is_memcached_not_running() {
    ! is_memcached_running
}

########################
# Stop memcached
# Globals:
#   MEMCACHED_PID_FILE
# Arguments:
#   None
# Returns:
#   Whether memcached was stopped or not
#########################
memcached_stop() {
    local pid
    pid="$(get_pid_from_file "${MEMCACHED_PID_FILE}")"
    if is_memcached_running; then
        kill "${pid}" 2>/dev/null
    fi
}
