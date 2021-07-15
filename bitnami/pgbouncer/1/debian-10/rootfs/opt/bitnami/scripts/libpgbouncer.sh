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
    empty_password_error() {
        print_validation_error "The $1 environment variable is empty or not set. Set the environment variable PGBOUNCER_AUTH_TYPE=trust to allow the container to be started with blank passwords. This is recommended only for development."
    }

    check_allowed_port() {
        local port_var="${1:?missing port variable}"
        local -a validate_port_args=()
        ! am_i_root && validate_port_args+=("-unprivileged")
        validate_port_args+=("${!port_var}")
        if ! err=$(validate_port "${validate_port_args[@]}"); then
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

    if [[ "$PGBOUNCER_AUTH_TYPE" == "trust" ]]; then
        trust_enabled_warn
    else
        if [[ -z "$POSTGRESQL_PASSWORD" ]]; then
            empty_password_error "POSTGRESQL_PASSWORD"
        fi
        if ((${#POSTGRESQL_PASSWORD} > 100)); then
            print_validation_error "The password cannot be longer than 100 characters. Set the environment variable POSTGRESQL_PASSWORD with a shorter value"
        fi
        if [[ -n "$POSTGRESQL_USERNAME" ]] && [[ -z "$POSTGRESQL_PASSWORD" ]]; then
            empty_password_error "POSTGRESQL_PASSWORD"
        fi
    fi

    if [[ "$PGBOUNCER_CLIENT_TLS_SSLMODE" != "disable" ]]; then
        # TLS Checks
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

    check_allowed_port PGBOUNCER_PORT
    check_ip_value PGBOUNCER_LISTEN_ADDRESS

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
        ini-file set --section "databases" --key "$PGBOUNCER_DATABASE" --value "host=$POSTGRESQL_HOST port=$POSTGRESQL_PORT dbname=$POSTGRESQL_DATABASE" "$PGBOUNCER_CONF_FILE"
        ini-file set --section "pgbouncer" --key "listen_port" --value "$PGBOUNCER_PORT" "$PGBOUNCER_CONF_FILE"
        ini-file set --section "pgbouncer" --key "listen_addr" --value "$PGBOUNCER_LISTEN_ADDRESS" "$PGBOUNCER_CONF_FILE"
        ini-file set --section "pgbouncer" --key "auth_file" --value "$PGBOUNCER_AUTH_FILE" "$PGBOUNCER_CONF_FILE"
        ini-file set --section "pgbouncer" --key "auth_type" --value "$PGBOUNCER_AUTH_TYPE" "$PGBOUNCER_CONF_FILE"
        ini-file set --section "pgbouncer" --key "pidfile" --value "$PGBOUNCER_PID_FILE" "$PGBOUNCER_CONF_FILE"
        ini-file set --section "pgbouncer" --key "logfile" --value "$PGBOUNCER_LOG_FILE" "$PGBOUNCER_CONF_FILE"
        ini-file set --section "pgbouncer" --key "admin_users" --value "$POSTGRESQL_USERNAME" "$PGBOUNCER_CONF_FILE"
        ini-file set --section "pgbouncer" --key "client_tls_sslmode" --value "$PGBOUNCER_CLIENT_TLS_SSLMODE" "$PGBOUNCER_CONF_FILE"
        if [[ "$PGBOUNCER_CLIENT_TLS_SSLMODE" != "disable" ]]; then
            ini-file set --section "pgbouncer" --key "client_tls_cert_file" --value "$PGBOUNCER_CLIENT_TLS_CERT_FILE" "$PGBOUNCER_CONF_FILE"
            ini-file set --section "pgbouncer" --key "client_tls_key_file" --value "$PGBOUNCER_CLIENT_TLS_KEY_FILE" "$PGBOUNCER_CONF_FILE"
            ! is_empty_value "$PGBOUNCER_CLIENT_TLS_CA_FILE" && ini-file set --section "pgbouncer" --key "client_tls_ca_file" --value "$PGBOUNCER_CLIENT_TLS_CA_FILE" "$PGBOUNCER_CONF_FILE"
            ini-file set --section "pgbouncer" --key "client_tls_ciphers" --value "$PGBOUNCER_CLIENT_TLS_CIPHERS" "$PGBOUNCER_CONF_FILE"
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
    if [[ -d "$PGBOUNCER_INITSCRIPTS_DIR" ]] && [[ -n $(find "$PGBOUNCER_INITSCRIPTS_DIR/" -type f -regex ".*\.sh") ]] && [[ ! -f "$PGBOUNCER_VOLUME_DIR/.user_scripts_initialized" ]]; then
        info "Loading user's custom files from $PGBOUNCER_INITSCRIPTS_DIR ..."
        postgresql_start_bg
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
