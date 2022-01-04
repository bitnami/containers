#!/bin/bash
#
# Bitnami Pgpool library

# shellcheck disable=SC1090,SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh

########################
# Validate settings in PGPOOL_* env. variables
# Globals:
#   PGPOOL_*
# Arguments:
#   None
# Returns:
#   None
#########################
pgbouncer_validate() {
    info "Validating settings in PGBOUNCER_* env vars..."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }
    trust_enabled_warn() {
        warn "You set the environment variable PGBOUNCER_AUTH_TYPE=${PGBOUNCER_AUTH_TYPE}. For safety reasons, do not use this flag in a production environment."
    }
    check_empty_value() {
        if is_empty_value "${!1}"; then
            print_validation_error "${1} must be set"
        fi
    }
    check_multi_value() {
        if [[ " ${2} " != *" ${!1} "* ]]; then
            print_validation_error "The allowed values for ${1} are: ${2}"
        fi
    }
    check_valid_port() {
        local port_var="${1:?missing port variable}"
        local err
        if ! err="$(validate_port "${!port_var}")"; then
            print_validation_error "An invalid port was specified in the environment variable ${port_var}: ${err}."
        fi
    }

    check_ip_value() {
        if ! validate_ipv4 "${!1}"; then
            if ! is_hostname_resolved "${!1}"; then
                print_validation_error "The value for $1 should be an IPv4 address or it must be a resolvable hostname"
            else
                debug "Hostname resolvable for $1"
            fi
        fi
    }

    check_valid_port "PGBOUNCER_PORT"
    check_ip_value "PGBOUNCER_LISTEN_ADDRESS"
    check_multi_value "PGBOUNCER_AUTH_TYPE" "any cert md5 hba pam plain scram-sha-256 trust"
    ! is_empty_value "$PGBOUNCER_POOL_MODE" && check_multi_value "PGBOUNCER_POOL_MODE" "session statement transaction"
    if [[ "$PGBOUNCER_AUTH_TYPE" = "trust" ]]; then
        trust_enabled_warn
    else
        check_empty_value "POSTGRESQL_PASSWORD"
        if ((${#POSTGRESQL_PASSWORD} > 100)); then
            print_validation_error "The password cannot be longer than 100 characters. Set the environment variable POSTGRESQL_PASSWORD with a shorter value"
        fi
    fi

    # TLS Checks (client)
    if [[ "$PGBOUNCER_CLIENT_TLS_SSLMODE" != "disable" ]]; then
        if [[ -z "$PGBOUNCER_CLIENT_TLS_CERT_FILE" ]]; then
            print_validation_error "You must provide a X.509 certificate in order to use TLS"
        elif [[ ! -f "$PGBOUNCER_CLIENT_TLS_CERT_FILE" ]]; then
            print_validation_error "The X.509 certificate file in the specified path ${PGBOUNCER_CLIENT_TLS_CERT_FILE} does not exist"
        fi
        if [[ -z "$PGBOUNCER_CLIENT_TLS_KEY_FILE" ]]; then
            print_validation_error "You must provide a private key in order to use TLS"
        elif [[ ! -f "$PGBOUNCER_CLIENT_TLS_KEY_FILE" ]]; then
            print_validation_error "The private key file in the specified path ${PGBOUNCER_CLIENT_TLS_KEY_FILE} does not exist"
        fi
        if [[ -z "$PGBOUNCER_CLIENT_TLS_CA_FILE" ]]; then
            warn "A CA X.509 certificate was not provided. Client verification will not be performed in TLS connections"
        elif [[ ! -f "$PGBOUNCER_CLIENT_TLS_CA_FILE" ]]; then
            print_validation_error "The CA X.509 certificate file in the specified path ${PGBOUNCER_CLIENT_TLS_CA_FILE} does not exist"
        fi
    fi

    # TLS Checks (server)
    if [[ "$PGBOUNCER_SERVER_TLS_SSLMODE" != "disable" ]]; then
        if [[ -z "$PGBOUNCER_SERVER_TLS_CERT_FILE" ]]; then
            print_validation_error "You must provide a X.509 certificate in order to use server TLS"
        elif [[ ! -f "$PGBOUNCER_SERVER_TLS_CERT_FILE" ]]; then
            print_validation_error "The X.509 server certificate file in the specified path ${PGBOUNCER_SERVER_TLS_CERT_FILE} does not exist"
        fi
        if [[ -z "$PGBOUNCER_SERVER_TLS_KEY_FILE" ]]; then
            print_validation_error "You must provide a private key in order to use server TLS"
        elif [[ ! -f "$PGBOUNCER_SERVER_TLS_KEY_FILE" ]]; then
            print_validation_error "The server private key file in the specified path ${PGBOUNCER_SERVER_TLS_KEY_FILE} does not exist"
        fi
        if [[ -z "$PGBOUNCER_SERVER_TLS_CA_FILE" ]]; then
            warn "A CA X.509 certificate was not provided. Server verification will not be performed in TLS connections"
        elif [[ ! -f "$PGBOUNCER_SERVER_TLS_CA_FILE" ]]; then
            print_validation_error "The server CA X.509 certificate file in the specified path ${PGBOUNCER_SERVER_TLS_CA_FILE} does not exist"
        fi
    fi

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Configure libnss_wrapper so PgBouncer commands work with a random user.
# Globals:
#   PGBOUNCER_*
# Arguments:
#   None
# Returns:
#   None
#########################
pgbouncer_enable_nss_wrapper() {
    if ! getent passwd "$(id -u)" &>/dev/null && [ -e "$NSS_WRAPPER_LIB" ]; then
        debug "Configuring libnss_wrapper..."
        export LD_PRELOAD="$NSS_WRAPPER_LIB"
        # shellcheck disable=SC2155
        export NSS_WRAPPER_PASSWD="$(mktemp)"
        # shellcheck disable=SC2155
        export NSS_WRAPPER_GROUP="$(mktemp)"
        echo "$PGBOUNCER_DAEMON_USER:x:$(id -u):$(id -g):PgBouncer:$PGBOUNCER_BASE_DIR:/bin/false" >"$NSS_WRAPPER_PASSWD"
        echo "$PGBOUNCER_DAEMON_GROUP:x:$(id -g):" >"$NSS_WRAPPER_GROUP"
    fi
}

########################
# Copy mounted configuration files
# Globals:
#   PGBOUNCER_*
# Arguments:
#   None
# Returns:
#   None
#########################
pgbouncer_copy_mounted_config() {
    if ! is_dir_empty "$PGBOUNCER_MOUNTED_CONF_DIR"; then
        info "Found configuration files in "
        cp -Lr "$PGBOUNCER_MOUNTED_CONF_DIR"/* "$PGBOUNCER_CONF_DIR"
    fi
}

########################
# Check if a given configuration file was mounted externally
# Globals:
#   PGBOUNCER_*
# Arguments:
#   $1 - Filename
# Returns:
#   true if the file was mounted externally, false otherwise
#########################
pgbouncer_is_file_external() {
    local -r filename=$1
    if [[ -d "$PGBOUNCER_MOUNTED_CONF_DIR" ]] && [[ -f "$PGBOUNCER_MOUNTED_CONF_DIR"/"$filename" ]]; then
        return 0
    else
        return 1
    fi
}

########################
# Ensure PgBouncer is initialized
# Globals:
#   PGBOUNCER_*
# Arguments:
#   None
# Returns:
#   None
#########################
pgbouncer_initialize() {
    info "Initializing PgBouncer..."

    # Clean logs, pids and configuration files from previous restarts
    rm -f "$PGBOUNCER_PID_FILE" "$PGBOUNCER_LOG_FILE" "$PGBOUNCER_AUTH_FILE" "$PGBOUNCER_CONF_FILE"

    pgbouncer_copy_mounted_config

    info "Waiting for PostgreSQL backend to be accessible"
    if ! retry_while "wait-for-port --host $POSTGRESQL_HOST $POSTGRESQL_PORT" "$PGBOUNCER_INIT_SLEEP_TIME" "$PGBOUNCER_INIT_MAX_RETRIES"; then
        error "Backend $POSTGRESQL_HOST not accessible"
        exit 1
    else
        info "Backend $POSTGRESQL_HOST:$POSTGRESQL_PORT accessible"
    fi

    info "Configuring credentials"
    # Create credentials file
    if ! pgbouncer_is_file_external "userlist.txt"; then
        echo "\"$POSTGRESQL_USERNAME\" \"$POSTGRESQL_PASSWORD\"" >"$PGBOUNCER_AUTH_FILE"
    else
        debug "User list file mounted externally, skipping configuration"
    fi

    info "Creating configuration file"
    # Create configuration
    if ! pgbouncer_is_file_external "pgbouncer.ini"; then
        # Build DB string based on user preferences
        # Allow for wildcard db config
        local database_value="host=$POSTGRESQL_HOST port=$POSTGRESQL_PORT"
        if is_boolean_yes "$PGBOUNCER_SET_DATABASE_USER"; then
            database_value+=" user=$POSTGRESQL_USERNAME"
        fi
        if [[ "$PGBOUNCER_DATABASE" != "*" ]]; then
            database_value+=" dbname=$POSTGRESQL_DATABASE"
        fi
        ini-file set --section "databases" --key "$PGBOUNCER_DATABASE" --value "$database_value" "$PGBOUNCER_CONF_FILE"
        local -r -a key_value_pairs=(
            "listen_port:${PGBOUNCER_PORT}"
            "listen_addr:${PGBOUNCER_LISTEN_ADDRESS}"
            "auth_file:${PGBOUNCER_AUTH_FILE}"
            "auth_type:${PGBOUNCER_AUTH_TYPE}"
            "pidfile:${PGBOUNCER_PID_FILE}"
            "logfile:${PGBOUNCER_LOG_FILE}"
            "admin_users:${POSTGRESQL_USERNAME}"
            "stats_users:${PGBOUNCER_STATS_USERS}"
            "client_tls_sslmode:${PGBOUNCER_CLIENT_TLS_SSLMODE}"
            "server_tls_sslmode:${PGBOUNCER_SERVER_TLS_SSLMODE}"
            "query_wait_timeout:${PGBOUNCER_QUERY_WAIT_TIMEOUT}"
            "pool_mode:${PGBOUNCER_POOL_MODE}"
            "max_client_conn:${PGBOUNCER_MAX_CLIENT_CONN}"
            "max_db_connections:${PGBOUNCER_MAX_DB_CONNECTIONS}"
            "idle_transaction_timeout:${PGBOUNCER_IDLE_TRANSACTION_TIMEOUT}"
            "server_idle_timeout:${PGBOUNCER_SERVER_IDLE_TIMEOUT}"
            "server_reset_query:${PGBOUNCER_SERVER_RESET_QUERY}"
            "default_pool_size:${PGBOUNCER_DEFAULT_POOL_SIZE}"
            "min_pool_size:${PGBOUNCER_MIN_POOL_SIZE}"
            "reserve_pool_size:${PGBOUNCER_RESERVE_POOL_SIZE}"
            "ignore_startup_parameters:${PGBOUNCER_IGNORE_STARTUP_PARAMETERS}"
        )
        for pair in "${key_value_pairs[@]}"; do
            local key value
            key="$(awk -F: '{print $1}' <<<"$pair")"
            value="$(awk -F: '{print $2}' <<<"$pair")"
            ! is_empty_value "${value}" && ini-file set --section "pgbouncer" --key "${key}" --value "${value}" "$PGBOUNCER_CONF_FILE"
        done
        if [[ "$PGBOUNCER_CLIENT_TLS_SSLMODE" != "disable" ]]; then
            ini-file set --section "pgbouncer" --key "client_tls_cert_file" --value "$PGBOUNCER_CLIENT_TLS_CERT_FILE" "$PGBOUNCER_CONF_FILE"
            ini-file set --section "pgbouncer" --key "client_tls_key_file" --value "$PGBOUNCER_CLIENT_TLS_KEY_FILE" "$PGBOUNCER_CONF_FILE"
            ! is_empty_value "$PGBOUNCER_CLIENT_TLS_CA_FILE" && ini-file set --section "pgbouncer" --key "client_tls_ca_file" --value "$PGBOUNCER_CLIENT_TLS_CA_FILE" "$PGBOUNCER_CONF_FILE"
            ini-file set --section "pgbouncer" --key "client_tls_ciphers" --value "$PGBOUNCER_CLIENT_TLS_CIPHERS" "$PGBOUNCER_CONF_FILE"
        fi

        if [[ "$PGBOUNCER_SERVER_TLS_SSLMODE" != "disable" ]]; then
            ini-file set --section "pgbouncer" --key "server_tls_cert_file" --value "$PGBOUNCER_SERVER_TLS_CERT_FILE" "$PGBOUNCER_CONF_FILE"
            ini-file set --section "pgbouncer" --key "server_tls_key_file" --value "$PGBOUNCER_SERVER_TLS_KEY_FILE" "$PGBOUNCER_CONF_FILE"
            ! is_empty_value "$PGBOUNCER_SERVER_TLS_CA_FILE" && ini-file set --section "pgbouncer" --key "server_tls_ca_file" --value "$PGBOUNCER_SERVER_TLS_CA_FILE" "$PGBOUNCER_CONF_FILE"
            ! is_empty_value "$PGBOUNCER_SERVER_TLS_PROTOCOLS" && ini-file set --section "pgbouncer" --key "server_tls_protocols" --value "$PGBOUNCER_SERVER_TLS_PROTOCOLS" "$PGBOUNCER_CONF_FILE"
            ini-file set --section "pgbouncer" --key "server_tls_ciphers" --value "$PGBOUNCER_SERVER_TLS_CIPHERS" "$PGBOUNCER_CONF_FILE"
        fi
    else
        debug "Configuration file is mounted externally, skipping configuration"
    fi

    # Configuring permissions for tmp and logs folders
    am_i_root && configure_permissions_ownership "$PGBOUNCER_TMP_DIR $PGBOUNCER_LOG_DIR" -u "$PGBOUNCER_DAEMON_USER" -g "$PGBOUNCER_DAEMON_GROUP"

    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Run custom initialization scripts
# Globals:
#   PGBOUNCER_*
# Arguments:
#   None
# Returns:
#   None
#########################
pgbouncer_custom_init_scripts() {
    info "Loading custom scripts..."
    if [[ -d "$PGBOUNCER_INITSCRIPTS_DIR" ]] && [[ -n $(find "$PGBOUNCER_INITSCRIPTS_DIR/" -type f -regex ".*\.sh") ]] && [[ ! -f "$PGBOUNCER_VOLUME_DIR/.user_scripts_initialized" || "$PGBOUNCER_FORCE_INITSCRIPTS" == "true" ]]; then
        info "Loading user's custom files from $PGBOUNCER_INITSCRIPTS_DIR ..."
        find "$PGBOUNCER_INITSCRIPTS_DIR/" -type f -regex ".*\.sh" | sort | while read -r f; do
            case "$f" in
            *.sh)
                if [[ -x "$f" ]]; then
                    debug "Executing $f"
                    "$f"
                else
                    debug "Sourcing $f"
                    . "$f"
                fi
                ;;
            *) debug "Ignoring $f" ;;
            esac
        done
        touch "$PGBOUNCER_VOLUME_DIR"/.user_scripts_initialized
    fi
}
