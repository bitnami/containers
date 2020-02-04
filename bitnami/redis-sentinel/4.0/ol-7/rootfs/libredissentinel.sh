#!/bin/bash
#
# Bitnami Redis Sentinel library

# shellcheck disable=SC1091

# Load Generic Libraries
. /libfile.sh
. /liblog.sh
. /libnet.sh
. /libos.sh
. /libvalidations.sh

# Functions

########################
# Set a configuration setting value
# Globals:
#   REDIS_SENTINEL_CONF_FILE
# Arguments:
#   $1 - key
#   $2 - value
# Returns:
#   None
#########################
redis_conf_set() {
    # TODO: improve this. Substitute action?
    local key="${1:?missing key}"
    local value="${2:-}"

    # Sanitize inputs
    value="${value//\\/\\\\}"
    value="${value//&/\\&}"
    value="${value//\?/\\?}"
    [[ "$value" = "" ]] && value="\"$value\""

    if grep -q "^\s*$key .*" "$REDIS_SENTINEL_CONF_FILE"; then
        replace_in_file "$REDIS_SENTINEL_CONF_FILE" "^\s*${key} .*" "${key} ${value}" false
    else
        printf '\n%s %s' "$key" "$value" >> "$REDIS_SENTINEL_CONF_FILE"
    fi
}

########################
# Load global variables used on Redis configuration.
# Globals:
#   REDIS_*
# Arguments:
#   None
# Returns:
#   Series of exports to be used as 'eval' arguments
#########################
redis_env() {
    cat <<"EOF"
# Bitnami debug
export MODULE=redis-sentinel
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# Paths
export REDIS_SENTINEL_BASE_DIR="/opt/bitnami/redis-sentinel"
export REDIS_SENTINEL_VOLUME_DIR="/bitnami/redis-sentinel"
export REDIS_SENTINEL_CONF_DIR="${REDIS_SENTINEL_BASE_DIR}/etc"
export REDIS_SENTINEL_LOG_DIR="${REDIS_SENTINEL_BASE_DIR}/logs"
export REDIS_SENTINEL_TMP_DIR="${REDIS_SENTINEL_BASE_DIR}/tmp"
export REDIS_SENTINEL_CONF_FILE="${REDIS_SENTINEL_CONF_DIR}/sentinel.conf"
export REDIS_SENTINEL_LOG_FILE="${REDIS_SENTINEL_LOG_DIR}/redis-sentinel.log"
export REDIS_SENTINEL_PID_FILE="${REDIS_SENTINEL_TMP_DIR}/redis-sentinel.pid"

# Users
export REDIS_SENTINEL_DAEMON_USER="redis"
export REDIS_SENTINEL_DAEMON_GROUP="redis"

# Configuration
export REDIS_MASTER_HOST="${REDIS_MASTER_HOST:-redis}"
export REDIS_MASTER_PASSWORD="${REDIS_MASTER_PASSWORD:-}"
export REDIS_MASTER_PORT_NUMBER="${REDIS_MASTER_PORT_NUMBER:-6379}"
export REDIS_MASTER_SET="${REDIS_MASTER_SET:-mymaster}"
export REDIS_SENTINEL_PORT_NUMBER="${REDIS_SENTINEL_PORT_NUMBER:-26379}"
export REDIS_SENTINEL_QUORUM="${REDIS_SENTINEL_QUORUM:-2}"
export REDIS_SENTINEL_DOWN_AFTER_MILLISECONDS="${REDIS_SENTINEL_DOWN_AFTER_MILLISECONDS:-60000}"
export REDIS_SENTINEL_FAILOVER_TIMEOUT="${REDIS_SENTINEL_FAILOVER_TIMEOUT:-180000}"
export REDIS_SENTINEL_PASSWORD="${REDIS_SENTINEL_PASSWORD:-}"
EOF
    if [[ -f "${REDIS_MASTER_PASSWORD_FILE:-}" ]]; then
        cat <<"EOF"
export REDIS_MASTER_PASSWORD="$(< "${REDIS_MASTER_PASSWORD_FILE}")"
EOF
    fi
    if [[ -f "${REDIS_SENTINEL_PASSWORD_FILE:-}" ]]; then
        cat <<"EOF"
export REDIS_SENTINEL_PASSWORD="$(< "${REDIS_SENTINEL_PASSWORD_FILE}")"
EOF
    fi
}

########################
# Validate settings in REDIS_* env vars.
# Globals:
#   REDIS_*
# Arguments:
#   None
# Returns:
#   None
#########################
redis_validate() {
    debug "Validating settings in REDIS_* env vars.."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    check_resolved_hostname() {
        if ! is_hostname_resolved "$1"; then
            warn "Hostname ${1} could not be resolved, this could lead to connection issues"
        fi
    }

    check_allowed_port() {
        local validate_port_args=()
        ! am_i_root && validate_port_args+=("-unprivileged")
        if ! err="$(validate_port "${validate_port_args[@]}" "${!1}")"; then
            print_validation_error "An invalid port was specified in the environment variable ${1}: ${err}"
        fi
    }

    [[ -w "$REDIS_SENTINEL_CONF_FILE" ]] || print_validation_error "The configuration file ${REDIS_SENTINEL_CONF_FILE} is not writable"

    is_positive_int "$REDIS_SENTINEL_QUORUM" || print_validation_error "Invalid quorum value (only positive integers allowed)"
    is_positive_int "$REDIS_SENTINEL_DOWN_AFTER_MILLISECONDS" || print_validation_error "Invalid down-after-milliseconds value (only positive integers allowed)"
    is_positive_int "$REDIS_SENTINEL_FAILOVER_TIMEOUT" || print_validation_error "Invalid failover-timeout value (only positive integers allowed)"

    check_allowed_port REDIS_SENTINEL_PORT_NUMBER
    check_resolved_hostname "$REDIS_MASTER_HOST"

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Ensure Redis is initialized
# Globals:
#   REDIS_*
# Arguments:
#   None
# Returns:
#   None
#########################
redis_initialize() {
    info "Initializing Redis Sentinel..."

    # Give the daemon user appropriate permissions
    if am_i_root; then
        for dir in "$REDIS_SENTINEL_CONF_DIR" "$REDIS_SENTINEL_LOG_DIR" "$REDIS_SENTINEL_TMP_DIR" "$REDIS_SENTINEL_VOLUME_DIR"; do
            chown "${REDIS_SENTINEL_DAEMON_USER}:${REDIS_SENTINEL_DAEMON_GROUP}" "$dir"
        done
    fi

    if [[ ! -f "${REDIS_SENTINEL_VOLUME_DIR}/conf/sentinel.conf" ]]; then
        info "Configuring Redis Sentinel..."

        # Service
        redis_conf_set "port" "$REDIS_SENTINEL_PORT_NUMBER"
        redis_conf_set "bind" "0.0.0.0"
        redis_conf_set "daemonize" "yes"
        redis_conf_set "pidfile" "$REDIS_SENTINEL_PID_FILE"
        redis_conf_set "logfile" "$REDIS_SENTINEL_LOG_FILE"
        [[ -z "$REDIS_SENTINEL_PASSWORD" ]] || redis_conf_set "requirepass" "$REDIS_SENTINEL_PASSWORD"

        # Master set
        redis_conf_set "sentinel monitor" "${REDIS_MASTER_SET} ${REDIS_MASTER_HOST} ${REDIS_MASTER_PORT_NUMBER} ${REDIS_SENTINEL_QUORUM}"
        redis_conf_set "sentinel down-after-milliseconds" "${REDIS_MASTER_SET} ${REDIS_SENTINEL_DOWN_AFTER_MILLISECONDS}"
        redis_conf_set "sentinel failover-timeout" "${REDIS_MASTER_SET} ${REDIS_SENTINEL_FAILOVER_TIMEOUT}"
        redis_conf_set "sentinel parallel-syncs" "${REDIS_MASTER_SET} 1"
        [[ -z "$REDIS_MASTER_PASSWORD" ]] || redis_conf_set "sentinel auth-pass" "${REDIS_MASTER_SET} ${REDIS_MASTER_PASSWORD}"

        cp -f "$REDIS_SENTINEL_CONF_FILE" "${REDIS_SENTINEL_VOLUME_DIR}/conf/sentinel.conf"
    else
        info "Persisted files detected, restoring..."
    fi

    rm -rf "$REDIS_SENTINEL_CONF_DIR"
    ln -sf "${REDIS_SENTINEL_VOLUME_DIR}/conf" "$REDIS_SENTINEL_CONF_DIR"
}
