#!/bin/bash
#
# Bitnami Kong library

# shellcheck disable=SC1090
# shellcheck disable=SC1091

# Load generic libraries
. /libfs.sh
. /liblog.sh
. /libnet.sh
. /libos.sh
. /libservice.sh
. /libvalidations.sh

########################
# Load global variables used for Kong configuration.
# Globals:
#   KONG_*
# Arguments:
#   None
# Returns:
#   Series of exports to be used as 'eval' arguments
#########################
kong_env() {
    # Avoid environment settings getting overridden twice
    if [[ -n "${MODULE:-}" ]]; then
        return
    fi

    cat <<"EOF"
# Bitnami debug
export MODULE=kong
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# Paths
export KONG_BASE_DIR="/opt/bitnami/kong"
export KONG_CONF_DIR="${KONG_BASE_DIR}/conf"
export KONG_SERVER_DIR="${KONG_BASE_DIR}/server"

export KONG_CONF_FILE="${KONG_CONF_DIR}/kong.conf"
export KONG_DEFAULT_CONF_FILE="${KONG_CONF_DIR}/kong.conf.default"

# Users
export KONG_DAEMON_USER="${KONG_DAEMON_USER:-kong}"
export KONG_DAEMON_GROUP="${KONG_DAEMON_GROUP:-kong}"

# Cluster settings
export KONG_MIGRATE="${KONG_MIGRATE:-no}"

# Port and service bind configurations for KONG_PROXY_LISTEN and KONG_ADMIN_LISTEN
# By setting these separately, we are consistent with other Bitnami solutions
# However it is still possible to directly set KONG_PROXY_LISTEN and KONG_ADMIN_LISTEN
export KONG_PROXY_LISTEN_ADDRESS="${KONG_PROXY_LISTEN_ADDRESS:-0.0.0.0}"
export KONG_PROXY_HTTP_PORT_NUMBER="${KONG_PROXY_HTTP_PORT_NUMBER:-8000}"
export KONG_PROXY_HTTPS_PORT_NUMBER="${KONG_PROXY_HTTPS_PORT_NUMBER:-8443}"
export KONG_ADMIN_LISTEN_ADDRESS="${KONG_ADMIN_LISTEN_ADDRESS:-127.0.0.1}"
export KONG_ADMIN_HTTP_PORT_NUMBER="${KONG_ADMIN_HTTP_PORT_NUMBER:-8001}"
export KONG_ADMIN_HTTPS_PORT_NUMBER="${KONG_ADMIN_HTTPS_PORT_NUMBER:-8444}"

# Kong configuration
# These environment variables are used by Kong and allow overriding values in its configuration file
export KONG_NGINX_DAEMON="off"
EOF

    if am_i_root; then
        cat <<"EOF"
export KONG_NGINX_USER="${KONG_DAEMON_USER} ${KONG_DAEMON_GROUP}"
EOF
    fi

    if [[ -f "${KONG_CASSANDRA_PASSWORD_FILE:-}" ]]; then
        cat <<"EOF"
export KONG_CASSANDRA_PASSWORD="$(< "${KONG_CASSANDRA_PASSWORD_FILE}")"
EOF
    fi

    if [[ -f "${KONG_POSTGRESQL_PASSWORD_FILE:-}" ]]; then
        cat <<"EOF"
export KONG_PG_PASSWORD="$(< "${KONG_POSTGRESQL_PASSWORD_FILE}")"
EOF
    fi

    # Compound environment variables that form a single Kong configuration entry
    if [[ -n "${KONG_PROXY_LISTEN:-}" ]]; then
        cat <<"EOF"
export KONG_PROXY_LISTEN_OVERRIDE="yes"
EOF
    else
        cat <<"EOF"
export KONG_PROXY_LISTEN="${KONG_PROXY_LISTEN_ADDRESS}:${KONG_PROXY_HTTP_PORT_NUMBER}, ${KONG_PROXY_LISTEN_ADDRESS}:${KONG_PROXY_HTTPS_PORT_NUMBER} ssl"
export KONG_PROXY_LISTEN_OVERRIDE="no"
EOF
    fi
    if [[ -n "${KONG_ADMIN_LISTEN:-}" ]]; then
        cat <<"EOF"
export KONG_ADMIN_LISTEN_OVERRIDE="yes"
EOF
    else
        cat <<"EOF"
export KONG_ADMIN_LISTEN="${KONG_ADMIN_LISTEN_ADDRESS}:${KONG_ADMIN_HTTP_PORT_NUMBER}, ${KONG_ADMIN_LISTEN_ADDRESS}:${KONG_ADMIN_HTTPS_PORT_NUMBER} ssl"
export KONG_ADMIN_LISTEN_OVERRIDE="no"
EOF
    fi
}

########################
# Validate settings in KONG_* environment variables
# Globals:
#   KONG_*
# Arguments:
#   None
# Returns:
#   None
#########################
kong_validate() {
    info "Validating settings in KONG_* env vars"
    local error_code=0

    # Auxiliary functions

    print_validation_error() {
        error "$1"
        error_code="1"
    }

    check_yes_no_value() {
        if ! is_yes_no_value "${!1}"; then
            print_validation_error "The allowed values for ${1} are [yes, no]"
        fi
    }

    check_password_file() {
        if [[ -n "${!1:-}" ]] && ! [[ -f "${!1:-}" ]]; then
            print_validation_error "The variable ${1} is defined but the file ${!1} is not accessible or does not exist"
        fi
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

    check_conflicting_ports() {
        local -r total="$#"
        for i in $(seq 1 "$((total - 1))"); do
            for j in $(seq "$((i + 1))" "$total"); do
                if (( "${!i}" == "${!j}" )); then
                    print_validation_error "${!i} and ${!j} are bound to the same port"
                fi
            done
        done
    }

    check_yes_no_value KONG_MIGRATE

    # Validate some of the supported environment variables used by Kong

    # Database setting validations
    if [[ "${KONG_DATABASE:-postgres}" = "postgres" ]]; then
        # PostgreSQL is the default database type
        check_password_file KONG_POSTGRESQL_PASSWORD_FILE
        [[ -n "${KONG_PG_HOST:-}" ]] && check_resolved_hostname "${KONG_PG_HOST:-}"
        if [[ -n "${!KONG_CASSANDRA_@}" ]]; then
            warn "KONG_DATABASE is empty or set to 'postgres', so the following environment variables will be ignored: ${!KONG_CASSANDRA_@}"
        fi
    elif [[ "${KONG_DATABASE:-}" = "cassandra" ]]; then
        check_password_file KONG_CASSANDRA_PASSWORD_FILE
        for cassandra_contact_point in $(echo "${CASSANDRA_CONTACT_POINTS:-}" | sed -r 's/[, ]+/\n/'); do
            check_resolved_hostname "${cassandra_contact_point}"
        done
        if [[ -n "${!KONG_PG_@}" ]]; then
            warn "KONG_DATABASE is set to 'cassandra', so the following environment variables will be ignored: ${!KONG_PG_@}"
        fi
    elif [[ "${KONG_DATABASE:-}" = "off" ]]; then
        warn "KONG_DATABASE is set to 'off', Kong will run but data will not be persisted"
    else
        print_validation_error "Wrong value '${KONG_DATABASE}' passed to KONG_DATABASE. Valid values: 'off', 'cassandra', 'postgres'"
    fi

    # Listen addresses and port validations
    used_ports=()
    if is_boolean_yes "$KONG_PROXY_LISTEN_OVERRIDE"; then
        warn "KONG_PROXY_LISTEN was set, it will not be validated and the environment variables KONG_PROXY_LISTEN_ADDRESS, KONG_PROXY_HTTP_PORT_NUMBER and KONG_PROXY_HTTPS_PORT_NUMBER will be ignored"
    else
        used_ports+=(KONG_PROXY_HTTP_PORT_NUMBER KONG_PROXY_HTTPS_PORT_NUMBER)
        if [[ "$KONG_PROXY_LISTEN_ADDRESS" != "0.0.0.0" && "$KONG_PROXY_LISTEN_ADDRESS" != "127.0.0.1" ]]; then
            warn "Kong Proxy is set to listen at ${KONG_PROXY_LISTEN_ADDRESS} instead of 0.0.0.0 or 127.0.0.1, this could make Kong inaccessible"
        fi
    fi
    if is_boolean_yes "$KONG_ADMIN_LISTEN_OVERRIDE"; then
        warn "KONG_ADMIN_LISTEN was set, it will not be validated and the environment variables KONG_ADMIN_LISTEN_ADDRESS, KONG_ADMIN_HTTP_PORT_NUMBER and KONG_ADMIN_HTTPS_PORT_NUMBER will be ignored"
    else
        used_ports+=(KONG_ADMIN_HTTP_PORT_NUMBER KONG_ADMIN_HTTPS_PORT_NUMBER)
        if [[ "$KONG_ADMIN_LISTEN_ADDRESS" != "127.0.0.1" ]]; then
            warn "Kong Admin is set to listen at ${KONG_ADMIN_LISTEN_ADDRESS} instead of 127.0.0.1, opening it to the outside could make it insecure"
        fi
    fi
    for port in "${used_ports[@]}"; do
        check_allowed_port "${port}"
    done
    if [[ "${#used_ports[@]}" -ne 0 ]]; then
        check_conflicting_ports "${used_ports[@]}"
    fi

    # Quit if any failures occurred
    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Ensure Kong is initialized
# Globals:
#   KONG_*
# Arguments:
#   None
# Returns:
#   None
#########################
kong_initialize() {
    info "Initializing Kong"

    info "Waiting for database connection to succeed"

    while ! kong_migrations_list_output="$(kong migrations list 2>&1)"; do
        if is_boolean_yes "$KONG_MIGRATE" && [[ "$kong_migrations_list_output" =~ "Database needs bootstrapping"* ]]; then
            break
        fi
        debug "$kong_migrations_list_output"
        debug "Database is still not ready, will retry"
        sleep 1
    done

    if is_boolean_yes "$KONG_MIGRATE"; then
        info "Migrating database"
        kong migrations bootstrap
        while ! kong migrations list; do
            debug "Error during the initial bootstrap for the database, will retry"
            kong migrations up
            kong migrations finish
        done
    fi
}
