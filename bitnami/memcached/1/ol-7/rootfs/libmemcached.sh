#!/bin/bash
#
# Bitnami Memcached library

# shellcheck disable=SC1091

# Load Generic Libraries
. /libfs.sh
. /liblog.sh
. /libos.sh
. /libvalidations.sh

# Functions

########################
# Load global variables used on Memcached configuration
# Globals:
#   MEMCACHED_*
# Arguments:
#   None
# Returns:
#   Series of exports to be used as 'eval' arguments
#########################
memcached_env() {
    cat <<"EOF"
# Format log messages
export MODULE="memcached"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# Paths
export MEMCACHED_BASE_DIR="/opt/bitnami/memcached"
export MEMCACHED_CONF_DIR="${MEMCACHED_BASE_DIR}/conf"
export MEMCACHED_BIN_DIR="${MEMCACHED_BASE_DIR}/bin"

# SASL
export SASL_CONF_PATH="${MEMCACHED_CONF_DIR}/sasl2"
export SASL_CONF_FILE="${SASL_CONF_PATH}/memcached.conf"
export SASL_DB_FILE="${SASL_CONF_PATH}/memcachedsasldb"

# Users
export MEMCACHED_DAEMON_USER="memcached"
export MEMCACHED_DAEMON_GROUP="memcached"

# Memcached configuration
export MEMCACHED_CACHE_SIZE="${MEMCACHED_CACHE_SIZE:-64}"
export MEMCACHED_PORT_NUMBER="${MEMCACHED_PORT_NUMBER:-11211}"
export MEMCACHED_USERNAME="${MEMCACHED_USERNAME:-root}"
EOF
    if [[ -n "${MEMCACHED_PASSWORD_FILE:-}" ]]; then
        cat <<"EOF"
export MEMCACHED_PASSWORD="$(< "${MEMCACHED_PASSWORD_FILE}")"
EOF
    else
        cat <<"EOF"
export MEMCACHED_PASSWORD="${MEMCACHED_PASSWORD:-}"
EOF
    fi
}

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
    if ! is_positive_int "${MEMCACHED_CACHE_SIZE}"; then
        print_validation_error "The variable MEMCACHED_CACHE_SIZE must be positive integer"
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

    # Ensure Memcached user and group exist when running as 'root'
    if am_i_root; then
        debug "Ensuring Memcached daemon user/group exists"
        ensure_user_exists "${MEMCACHED_DAEMON_USER}" "${MEMCACHED_DAEMON_GROUP}"
    fi

    debug "Ensuring expected directories/files exist"
    for dir in "${MEMCACHED_CONF_DIR}" "${SASL_CONF_PATH}"; do
        ensure_dir_exists "${dir}"
        am_i_root && chown -R "${MEMCACHED_DAEMON_USER}:${MEMCACHED_DAEMON_GROUP}" "${dir}"
    done

    if is_dir_empty "${SASL_CONF_PATH}"; then
        info "No configuration files found. Rendering default configuration file"
        if [[ -n "${MEMCACHED_PASSWORD}" ]]; then
            memcached_enable_authentication "${MEMCACHED_USERNAME}" "${MEMCACHED_PASSWORD}"
        fi
    else
        info "Deploying Memcached with persisted data"
        if [[ ! -f "${SASL_CONF_FILE}" ]]; then
            info "No injected configuration files found. Creating default config files"
            if [[ -n "${MEMCACHED_PASSWORD}" ]]; then
                memcached_enable_authentication "${MEMCACHED_USERNAME}" "${MEMCACHED_PASSWORD}"
            fi
        else
            info "Configuration files found. Skipping default configuration"
        fi
    fi
}

########################
# Configure memcached debug flags
# Globals:
#   BITNAMI_DEBUG
# Arguments:
#   None
# Returns:
#   Array with verbosity flags to use
#########################
memcached_debug_flags() {
    local debugFlags
    if is_boolean_yes "${BITNAMI_DEBUG}"; then
        debugFlags=("-vv")
    else
        debugFlags=("-v")
    fi
    echo "${debugFlags[@]}"
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

    info "Enabling authentication"
    memcached_create_user "${user}" "${password}"

    debug "Generating config file '${SASL_CONF_FILE}'"
    cat > "${SASL_CONF_FILE}" <<EOF
mech_list: plain
sasldb_path: ${SASL_DB_FILE}
EOF
}
