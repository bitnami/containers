#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
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

    check_valid_port "PGBOUNCER_PORT"
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

    # HBA Checks
    if [[ "$PGBOUNCER_AUTH_TYPE" == "hba" ]] ; then
        if [[ -z "$PGBOUNCER_AUTH_HBA_FILE" ]]; then
            print_validation_error "A hba file was not provided. You need to set this value when specifying auth_type to hba"
        elif [[ ! -f "$PGBOUNCER_AUTH_HBA_FILE" ]]; then
            print_validation_error "The hba file in the specified path ${PGBOUNCER_AUTH_HBA_FILE} does not exist"
        fi
        if [[ ! -z "$PGBOUNCER_AUTH_IDENT_FILE" ]] && [[ ! -f "$PGBOUNCER_AUTH_IDENT_FILE" ]]; then
            print_validation_error "The ident map file in the specified path ${PGBOUNCER_AUTH_IDENT_FILE} does not exist"
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
    if [[ "$PGBOUNCER_SERVER_TLS_SSLMODE" == "verify-ca" ]] || [[ "$PGBOUNCER_SERVER_TLS_SSLMODE" == "verify-full" ]]; then
        if [[ -z "$PGBOUNCER_SERVER_TLS_CA_FILE" ]]; then
            print_validation_error "A CA X.509 certificate was not provided. You need to set this value when specifying server_tls_sslmode to verify-ca or verify-full"
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
# Output helper for escaped auth fields
# Arguments:
#   $1 - raw username or password
# Returns:
#   None
#########################
pgbouncer_escape_auth() {
    # shellcheck disable=SC2001
    # replace each " with ""
    echo "$1" | sed 's/"/""/g'
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
    if ! retry_while "wait-for-port --host $POSTGRESQL_HOST $POSTGRESQL_PORT" "$PGBOUNCER_INIT_MAX_RETRIES" "$PGBOUNCER_INIT_SLEEP_TIME"; then
        error "Backend $POSTGRESQL_HOST not accessible"
        exit 1
    else
        info "Backend $POSTGRESQL_HOST:$POSTGRESQL_PORT accessible"
    fi

    info "Configuring credentials"
    # Create credentials file
    if ! pgbouncer_is_file_external "userlist.txt"; then
        echo "\"$(pgbouncer_escape_auth "$POSTGRESQL_USERNAME")\" \"$(pgbouncer_escape_auth "$POSTGRESQL_PASSWORD")\"" \
           > "$PGBOUNCER_AUTH_FILE"
        echo "$PGBOUNCER_USERLIST" >> "$PGBOUNCER_AUTH_FILE"
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
        if is_boolean_yes "$PGBOUNCER_SET_DATABASE_PASSWORD"; then
            database_value+=" password=$POSTGRESQL_PASSWORD"
        fi
        if [[ "$PGBOUNCER_DATABASE" != "*" ]]; then
            database_value+=" dbname=$POSTGRESQL_DATABASE"
        fi
        if ! is_empty_value "$PGBOUNCER_AUTH_USER"; then
            database_value+=" auth_user=$PGBOUNCER_AUTH_USER"
        fi
        if ! is_empty_value "$PGBOUNCER_CONNECT_QUERY"; then
            database_value+=" connect_query='${PGBOUNCER_CONNECT_QUERY}'"
        fi
        ini-file set --ignore-inline-comments --section "databases" --key "$PGBOUNCER_DATABASE" --value "$database_value" "$PGBOUNCER_CONF_FILE"

        i=0;
        while true; VAR_NAME="PGBOUNCER_DSN_${i}"; FILE_VAR_NAME="PGBOUNCER_DSN_${i}_FILE";
        do
            if [ -n "${!FILE_VAR_NAME+x}" ]; then
                debug "reading \$$VAR_NAME from file, via \$$FILE_VAR_NAME (${!FILE_VAR_NAME})"
                if [[ -r "${!FILE_VAR_NAME:-}" ]]; then
                    export "${VAR_NAME}=$(< "${!FILE_VAR_NAME}")"
                    unset "${FILE_VAR_NAME}"
                else
                    if [[ "$PGBOUNCER_FAIL_ON_INVALID_DSN_FILE" == "false" ]]; then
                        warn "Skipping export of '${VAR_NAME}'. '${!FILE_VAR_NAME:-}' is not readable."
                    else
                        error "Failed to export \$$VAR_NAME. '${!FILE_VAR_NAME:-}' is not readable."
                        exit 1
                    fi
                fi
            fi

            if [ -n "${!VAR_NAME:-}" ]; then
                dsn=${!VAR_NAME};
                ini-file set --ignore-inline-comments --section databases --key "$(echo "$dsn" | cut -d = -f 1)" --value "$(echo "$dsn" | cut -d = -f 2-)" "$PGBOUNCER_CONF_FILE";
                i=$(( "$i" + 1 ));
            else
                break;
            fi;
        done;

        local -r -a key_value_pairs=(
            "listen_port:${PGBOUNCER_PORT}"
            "listen_addr:${PGBOUNCER_LISTEN_ADDRESS}"
            "unix_socket_dir:${PGBOUNCER_SOCKET_DIR}"
            "unix_socket_mode:${PGBOUNCER_SOCKET_MODE}"
            "unix_socket_group:${PGBOUNCER_SOCKET_GROUP}"
            "auth_file:${PGBOUNCER_AUTH_FILE}"
            "auth_type:${PGBOUNCER_AUTH_TYPE}"
            "auth_hba_file:${PGBOUNCER_AUTH_HBA_FILE}"
            "auth_ident_file:${PGBOUNCER_AUTH_IDENT_FILE}"
            "auth_query:${PGBOUNCER_AUTH_QUERY}"
            "pidfile:${PGBOUNCER_PID_FILE}"
            "logfile:${PGBOUNCER_LOG_FILE}"
            "admin_users:${POSTGRESQL_USERNAME}"
            "stats_users:${PGBOUNCER_STATS_USERS}"
            "client_tls_sslmode:${PGBOUNCER_CLIENT_TLS_SSLMODE}"
            "server_tls_sslmode:${PGBOUNCER_SERVER_TLS_SSLMODE}"
            "server_tls_ca_file:${PGBOUNCER_SERVER_TLS_CA_FILE}"
            "server_tls_cert_file:${PGBOUNCER_SERVER_TLS_CERT_FILE}"
            "server_tls_key_file:${PGBOUNCER_SERVER_TLS_KEY_FILE}"
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
            "reserve_pool_timeout:${PGBOUNCER_RESERVE_POOL_TIMEOUT}"
            "ignore_startup_parameters:${PGBOUNCER_IGNORE_STARTUP_PARAMETERS}"
            "log_connections:${PGBOUNCER_LOG_CONNECTIONS}"
            "log_disconnections:${PGBOUNCER_LOG_DISCONNECTIONS}"
            "log_pooler_errors:${PGBOUNCER_LOG_POOLER_ERRORS}"
            "log_stats:${PGBOUNCER_LOG_STATS}"
            "stats_period:${PGBOUNCER_STATS_PERIOD}"
            "server_round_robin:${PGBOUNCER_SERVER_ROUND_ROBIN}"
            "server_fast_close:${PGBOUNCER_SERVER_FAST_CLOSE}"
            "server_lifetime:${PGBOUNCER_SERVER_LIFETIME}"
            "server_idle_timeout:${PGBOUNCER_SERVER_IDLE_TIMEOUT}"
            "server_connect_timeout:${PGBOUNCER_SERVER_CONNECT_TIMEOUT}"
            "server_login_retry:${PGBOUNCER_SERVER_LOGIN_RETRY}"
            "client_login_timeout:${PGBOUNCER_CLIENT_LOGIN_TIMEOUT}"
            "autodb_idle_timeout:${PGBOUNCER_AUTODB_IDLE_TIMEOUT}"
            "query_timeout:${PGBOUNCER_QUERY_TIMEOUT}"
            "query_wait_timeout:${PGBOUNCER_QUERY_WAIT_TIMEOUT}"
            "client_idle_timeout:${PGBOUNCER_CLIENT_IDLE_TIMEOUT}"
            "max_prepared_statements:${PGBOUNCER_MAX_PREPARED_STATEMENTS}"
            "application_name_add_host:${PGBOUNCER_APPLICATION_NAME_ADD_HOST}"
        )
        for pair in "${key_value_pairs[@]}"; do
            local key value
            key="$(awk -F: '{print $1}' <<<"$pair")"
            value="$(awk -F: '{print $2}' <<<"$pair")"
            ! is_empty_value "${value}" && ini-file set --ignore-inline-comments --section "pgbouncer" --key "${key}" --value "${value}" "$PGBOUNCER_CONF_FILE"
        done
        if [[ "$PGBOUNCER_CLIENT_TLS_SSLMODE" != "disable" ]]; then
            ini-file set --ignore-inline-comments --section "pgbouncer" --key "client_tls_cert_file" --value "$PGBOUNCER_CLIENT_TLS_CERT_FILE" "$PGBOUNCER_CONF_FILE"
            ini-file set --ignore-inline-comments --section "pgbouncer" --key "client_tls_key_file" --value "$PGBOUNCER_CLIENT_TLS_KEY_FILE" "$PGBOUNCER_CONF_FILE"
            ! is_empty_value "$PGBOUNCER_CLIENT_TLS_CA_FILE" && ini-file set --ignore-inline-comments --section "pgbouncer" --key "client_tls_ca_file" --value "$PGBOUNCER_CLIENT_TLS_CA_FILE" "$PGBOUNCER_CONF_FILE"
            ini-file set --ignore-inline-comments --section "pgbouncer" --key "client_tls_ciphers" --value "$PGBOUNCER_CLIENT_TLS_CIPHERS" "$PGBOUNCER_CONF_FILE"
        fi

        if [[ "$PGBOUNCER_SERVER_TLS_SSLMODE" != "disable" ]] || ! is_empty_value "$PGBOUNCER_SERVER_TLS_CERT_FILE" || ! is_empty_value "$PGBOUNCER_SERVER_TLS_KEY_FILE"; then
            ini-file set --ignore-inline-comments --section "pgbouncer" --key "server_tls_ciphers" --value "$PGBOUNCER_SERVER_TLS_CIPHERS" "$PGBOUNCER_CONF_FILE"
            ini-file set --ignore-inline-comments --section "pgbouncer" --key "server_tls_protocols" --value "$PGBOUNCER_SERVER_TLS_PROTOCOLS" "$PGBOUNCER_CONF_FILE"
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
