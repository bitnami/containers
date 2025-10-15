#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Pgpool-II library

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
pgpool_validate() {
    info "Validating settings in PGPOOL_* env vars..."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    if [[ -z "$PGPOOL_ADMIN_USERNAME" ]] || [[ -z "$PGPOOL_ADMIN_PASSWORD" ]]; then
        print_validation_error "The Pgpool administrator user's credentials are mandatory. Set the environment variables PGPOOL_ADMIN_USERNAME and PGPOOL_ADMIN_PASSWORD with the Pgpool administrator user's credentials."
    fi

    if [[ "$PGPOOL_SR_CHECK_PERIOD" -gt 0 ]] && { [[ -z "$PGPOOL_SR_CHECK_USER" ]] || [[ -z "$PGPOOL_SR_CHECK_PASSWORD" ]]; }; then
        print_validation_error "The Streaming Replication Check credentials are mandatory. Set the environment variables PGPOOL_SR_CHECK_USER and PGPOOL_SR_CHECK_PASSWORD with the Streaming Replication Check credentials."
    fi
    if [[ -z "$PGPOOL_HEALTH_CHECK_USER" ]] || [[ -z "$PGPOOL_HEALTH_CHECK_PASSWORD" ]]; then
        print_validation_error "The PostgreSQL health check credentials are mandatory. Set the environment variables PGPOOL_HEALTH_CHECK_USER and PGPOOL_HEALTH_CHECK_PASSWORD with the PostgreSQL health check credentials."
    fi
    if is_boolean_yes "$PGPOOL_ENABLE_LDAP" && { [[ -z "${LDAP_URI}" ]] || [[ -z "${LDAP_BASE}" ]] || [[ -z "${LDAP_BIND_DN}" ]] || [[ -z "${LDAP_BIND_PASSWORD}" ]]; }; then
        print_validation_error "The LDAP configuration is required when LDAP authentication is enabled. Set the environment variables LDAP_URI, LDAP_BASE, LDAP_BIND_DN and LDAP_BIND_PASSWORD with the LDAP configuration."
    fi

    if is_boolean_yes "$PGPOOL_ENABLE_LDAP" && (! is_boolean_yes "$PGPOOL_ENABLE_POOL_HBA" || ! is_boolean_yes "$PGPOOL_ENABLE_POOL_PASSWD"); then
        print_validation_error "pool_hba.conf authentication and pool password should be enabled for LDAP to work. Keep the PGPOOL_ENABLE_POOL_HBA and PGPOOL_ENABLE_POOL_PASSWD environment variables set to 'yes'."
    fi

    if is_boolean_yes "$PGPOOL_ENABLE_POOL_PASSWD" && { [[ -z "$PGPOOL_POSTGRES_USERNAME" ]] || [[ -z "$PGPOOL_POSTGRES_PASSWORD" ]]; }; then
        print_validation_error "The administrator's database credentials are required. Set the environment variables PGPOOL_POSTGRES_USERNAME and PGPOOL_POSTGRES_PASSWORD with the administrator's database credentials."
    fi

    if [[ -z "$PGPOOL_BACKEND_NODES" ]]; then
        print_validation_error "The list of backend nodes cannot be empty. Set the environment variable PGPOOL_BACKEND_NODES with a comma separated list of backend nodes."
    else
        read -r -a nodes <<<"$(tr ',;' ' ' <<<"${PGPOOL_BACKEND_NODES}")"
        for node in "${nodes[@]}"; do
            read -r -a fields <<<"$(tr ':' ' ' <<<"${node}")"
            if [[ -z "${fields[0]:-}" ]]; then
                print_validation_error "Error checking entry '$node', the field 'backend number' must be set!"
            fi
            if [[ -z "${fields[1]:-}" ]]; then
                print_validation_error "Error checking entry '$node', the field 'host' must be set!"
            fi
        done
    fi

    if is_boolean_yes "$PGPOOL_AUTO_FAILBACK"; then
        if  [[ -z "$PGPOOL_BACKEND_APPLICATION_NAMES" ]]; then
            print_validation_error "The list of backend application names cannot be empty. Set the environment variable PGPOOL_BACKEND_APPLICATION_NAMES with a comma separated list of backend nodes."
        fi

        read -r -a app_name_list <<<"$(tr ',;' ' ' <<<"${PGPOOL_BACKEND_APPLICATION_NAMES}")"
        read -r -a nodes_list <<<"$(tr ',;' ' ' <<<"${PGPOOL_BACKEND_NODES}")"
        if [[ ${#app_name_list[@]} -ne ${#nodes_list[@]} ]]; then
            print_validation_error "PGPOOL_BACKEND_APPLICATION_NAMES and PGPOOL_BACKEND_NODES lists should have the same length"
        fi
    fi

    if [[ -n "$PGPOOL_USER_CONF_FILE" && ! -e "$PGPOOL_USER_CONF_FILE" ]]; then
        print_validation_error "The provided PGPOOL_USER_CONF_FILE: ${PGPOOL_USER_CONF_FILE} must exist."
    fi

    if [[ -n "$PGPOOL_USER_HBA_FILE" && ! -e "$PGPOOL_USER_HBA_FILE" ]]; then
        print_validation_error "The provided PGPOOL_USER_HBA_FILE: ${PGPOOL_USER_HBA_FILE} must exist."
    fi

    local yes_no_values=("PGPOOL_ENABLE_POOL_HBA" "PGPOOL_ENABLE_POOL_PASSWD" "PGPOOL_ENABLE_LOAD_BALANCING" "PGPOOL_ENABLE_STATEMENT_LOAD_BALANCING" "PGPOOL_ENABLE_CONNECTION_CACHE" "PGPOOL_ENABLE_LOG_CONNECTIONS" "PGPOOL_ENABLE_LOG_HOSTNAME" "PGPOOL_ENABLE_LOG_PCP_PROCESSES" "PGPOOL_ENABLE_LOG_PER_NODE_STATEMENT" "PGPOOL_AUTO_FAILBACK")
    for yn in "${yes_no_values[@]}"; do
        if ! is_yes_no_value "${!yn}"; then
            print_validation_error "The values allowed for $yn are: yes or no"
        fi
    done
    local positive_values=("PGPOOL_NUM_INIT_CHILDREN" "PGPOOL_MAX_POOL" "PGPOOL_CHILD_MAX_CONNECTIONS" "PGPOOL_CHILD_LIFE_TIME" "PGPOOL_CONNECTION_LIFE_TIME" "PGPOOL_CLIENT_IDLE_LIMIT" "PGPOOL_HEALTH_CHECK_PERIOD" "PGPOOL_HEALTH_CHECK_TIMEOUT" "PGPOOL_HEALTH_CHECK_MAX_RETRIES" "PGPOOL_HEALTH_CHECK_RETRY_DELAY" "PGPOOL_RESERVED_CONNECTIONS" "PGPOOL_CONNECT_TIMEOUT" "PGPOOL_HEALTH_CHECK_PSQL_TIMEOUT")
    for p in "${positive_values[@]}"; do
        if [[ -n "${!p:-}" ]]; then
            if ! is_positive_int "${!p}"; then
                print_validation_error "The values allowed for $p: integer greater than 0"
            fi
        fi
    done
    if ! [[ "$PGPOOL_DISABLE_LOAD_BALANCE_ON_WRITE" =~ ^(off|transaction|trans_transaction|always)$ ]]; then
        print_validation_error "The values allowed for PGPOOL_DISABLE_LOAD_BALANCE_ON_WRITE: off,transaction,trans_transaction,always"
    fi

    if ! is_yes_no_value "$PGPOOL_ENABLE_TLS"; then
        print_validation_error "The values allowed for PGPOOL_ENABLE_TLS are: yes or no"
    elif is_boolean_yes "$PGPOOL_ENABLE_TLS"; then
        # TLS Checks
        if [[ -z "$PGPOOL_TLS_CERT_FILE" ]]; then
            print_validation_error "You must provide a X.509 certificate in order to use TLS"
        elif [[ ! -f "$PGPOOL_TLS_CERT_FILE" ]]; then
            print_validation_error "The X.509 certificate file in the specified path ${PGPOOL_TLS_CERT_FILE} does not exist"
        fi
        if [[ -z "$PGPOOL_TLS_KEY_FILE" ]]; then
            print_validation_error "You must provide a private key in order to use TLS"
        elif [[ ! -f "$PGPOOL_TLS_KEY_FILE" ]]; then
            print_validation_error "The private key file in the specified path ${PGPOOL_TLS_KEY_FILE} does not exist"
        fi
        if [[ -z "$PGPOOL_TLS_CA_FILE" ]]; then
            warn "A CA X.509 certificate was not provided. Client verification will not be performed in TLS connections"
        elif [[ ! -f "$PGPOOL_TLS_CA_FILE" ]]; then
            print_validation_error "The CA X.509 certificate file in the specified path ${PGPOOL_TLS_CA_FILE} does not exist"
        fi
        if ! is_yes_no_value "$PGPOOL_TLS_PREFER_SERVER_CIPHERS"; then
            print_validation_error "The values allowed for PGPOOL_TLS_PREFER_SERVER_CIPHERS are: yes or no"
        fi
    fi

    # Check for Authentication method
    if ! [[ "$PGPOOL_AUTHENTICATION_METHOD" =~ ^(md5|scram-sha-256|trust)$ ]]; then
        print_validation_error "The values allowed for PGPOOL_AUTHENTICATION_METHOD: md5,scram-sha-256,trust"
    elif [[ "$PGPOOL_AUTHENTICATION_METHOD" = "trust" ]]; then
        warn "You set 'trust' as authentication method. For safety reasons, do not use this method in production environments."
    fi

    # Check for required environment variables for scram-sha-256 based authentication
    if [[ "$PGPOOL_AUTHENTICATION_METHOD" = "scram-sha-256" ]]; then
        # If scram-sha-256 is enabled, pg_pool_password cannot be disabled
        if ! is_boolean_yes "$PGPOOL_ENABLE_POOL_PASSWD"; then
            print_validation_error "PGPOOL_ENABLE_POOL_PASSWD cannot be disabled when PGPOOL_AUTHENTICATION_METHOD=scram-sha-256"
        fi
    fi

    # Custom users validations
    read -r -a custom_users_list <<<"$(tr ',;' ' ' <<<"${PGPOOL_POSTGRES_CUSTOM_USERS}")"
    read -r -a custom_passwords_list <<<"$(tr ',;' ' ' <<<"${PGPOOL_POSTGRES_CUSTOM_PASSWORDS}")"
    if [[ ${#custom_users_list[@]} -ne ${#custom_passwords_list[@]} ]]; then
        print_validation_error "PGPOOL_POSTGRES_CUSTOM_USERS and PGPOOL_POSTGRES_CUSTOM_PASSWORDS lists should have the same length"
    fi

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Returns backend nodes info using PCP
# Globals:
#   PGPOOL_*
# Returns:
#   String with backend nodes info
#########################
pgpool_nodes_info() {
    PCPPASSFILE=$(mktemp /tmp/pcppass-XXXXX)
    export PCPPASSFILE
    echo "localhost:9898:${PGPOOL_ADMIN_USERNAME}:${PGPOOL_ADMIN_PASSWORD}" >"${PCPPASSFILE}"
    pcp_node_info -h localhost -U "${PGPOOL_ADMIN_USERNAME}" -p 9898 -a -w 2> /dev/null
    rm -rf "$PCPPASSFILE"
    unset PCPPASSFILE
}

########################
# Attach a backend node to Pgpool-II
# Globals:
#   PGPOOL_*
# Arguments:
#   $1 - node id
# Returns:
#   None
#########################
pgpool_attach_node() {
    local -r node_id=${1:?node id is missing}

    echo "Attaching backend node..."
    PCPPASSFILE=$(mktemp /tmp/pcppass-XXXXX)
    export PCPPASSFILE
    echo "localhost:9898:${PGPOOL_ADMIN_USERNAME}:${PGPOOL_ADMIN_PASSWORD}" >"${PCPPASSFILE}"
    pcp_attach_node -h localhost -U "${PGPOOL_ADMIN_USERNAME}" -p 9898 -n "${node_id}" -w
    rm -rf "$PCPPASSFILE"
    unset PCPPASSFILE
}

########################
# Check Pgpool-II health and attached offline backends when they are online
# Globals:
#   PGPOOL_*
# Arguments:
#   None
# Returns:
#   0 when healthy
#   1 when unhealthy
#########################
pgpool_healthcheck() {
    local backends node_id node_host node_port

    # Check backend nodes
    if backends="$(pgpool_nodes_info)"; then
        # We're not interested in nodes marked as down|down
        backends="$(grep -v "down down" <<< "$backends")"
        # We should also check whether there are discrepancies between Pgpool-II and the actual primary node
        if grep -e "standby primary" -e "primary standby" <<< "$backends" > /dev/null; then
            echo "Found inconsistencies in pgpool_status"
            return 1
        fi
        # Look up backends that are marked offline but being up
        read -r -a nodes_to_attach <<< "$(grep "down up" <<< "$backends" | awk '{print $1,$2}' | tr ' ' '|' | tr '\n' ' ')"
        for node in "${nodes_to_attach[@]}"; do
            node_host=$(echo "$node" | awk -F '|' '{print $1}')
            node_port=$(echo "$node" | awk -F '|' '{print $2}')
            node_id=$(grep "$node_host" "$PGPOOL_CONF_FILE" | awk '{print $1}' | sed 's/^backend_hostname//')
            if [[ $(PGCONNECT_TIMEOUT=3 PGPASSWORD="${PGPOOL_POSTGRES_PASSWORD}" psql -U "${PGPOOL_POSTGRES_USERNAME}" \
                -d postgres -h "${node_host}" -p "${node_port}" -tA -c "SELECT 1" || true) == 1 ]]; then
                # Attach backend if it has come back online
                pgpool_attach_node "$node_id"
            fi
        done
    else
        echo "unable to list pool nodes"
        return 1
    fi

    # Check if Pgpool-II responds to simple queries
    PGCONNECT_TIMEOUT=$PGPOOL_HEALTH_CHECK_PSQL_TIMEOUT PGPASSWORD="$PGPOOL_POSTGRES_PASSWORD" \
        psql -U "$PGPOOL_POSTGRES_USERNAME" -d postgres -h "$PGPOOL_TMP_DIR" -p "$PGPOOL_PORT_NUMBER" \
        -tA -c "SELECT 1" 2> /dev/null
}

########################
# Create basic pg_hba.conf file
# Globals:
#   PGPOOL_*
# Arguments:
#   None
# Returns:
#   None
#########################
pgpool_create_pghba() {
    local all_authentication="$PGPOOL_AUTHENTICATION_METHOD"
    is_boolean_yes "$PGPOOL_ENABLE_LDAP" && all_authentication="pam pamservice=pgpool"
    local postgres_authentication="scram-sha-256"
    # We avoid using 'trust' for the postgres user even if PGPOOL_AUTHENTICATION_METHOD is set to 'trust'
    [[ "$PGPOOL_AUTHENTICATION_METHOD" = "md5" ]] && postgres_authentication="md5"

    info "Generating pg_hba.conf file..."
    local postgres_auth_line=""
    if is_boolean_yes "$PGPOOL_ENABLE_POOL_PASSWD"; then
        postgres_auth_line="host     all             ${PGPOOL_POSTGRES_USERNAME}       all        ${postgres_authentication}"
    fi
    local sr_check_auth_line=""
    if [[ -n "$PGPOOL_SR_CHECK_USER" ]]; then
        sr_check_auth_line="host     all             ${PGPOOL_SR_CHECK_USER}            all        ${postgres_authentication}"
    fi

    cat >"$PGPOOL_PGHBA_FILE" <<EOF
local    all             all                            trust
EOF

    if ! is_empty_value "$PGPOOL_TLS_CA_FILE"; then
        cat >>"$PGPOOL_PGHBA_FILE" <<EOF
hostssl     all             all             0.0.0.0/0               cert
hostssl     all             all             ::/0                    cert
EOF
    fi

    cat >>"$PGPOOL_PGHBA_FILE" <<EOF
${sr_check_auth_line}
${postgres_auth_line}
host     all             all                all         ${all_authentication}
EOF
}

########################
# Modify the pgpool.conf file by setting a property
# Globals:
#   PGPOOL_*
# Arguments:
#   $1 - property
#   $2 - value
#   $3 - Path to configuration file (default: $PGPOOL_CONF_FILE)
# Returns:
#   None
#########################
pgpool_set_property() {
    local -r property="${1:?missing property}"
    local -r value="${2:-}"
    local -r conf_file="${3:-$PGPOOL_CONF_FILE}"
    replace_in_file "$conf_file" "^#*\s*${property}\s*=.*" "${property} = '${value}'" false
}

########################
# Add a backend configuration to pgpool.conf file
# Globals:
#   PGPOOL_*
# Arguments:
#   None
# Returns:
#   None
#########################
pgpool_create_backend_config() {
    local -r node=${1:?node is missing}
    local -r application="${2:-}"

    # default values
    read -r -a fields <<<"$(tr ':' ' ' <<<"${node}")"
    local -r num="${fields[0]:?field num is needed}"
    local -r host="${fields[1]:?field host is needed}"
    local -r port="${fields[2]:-5432}"
    local -r weight="${fields[3]:-1}"
    local -r dir="${fields[4]:-$PGPOOL_DATA_DIR}"
    local -r flag="${fields[5]:-ALLOW_TO_FAILOVER}"

    debug "Adding '$host' information to the configuration..."
    cat >>"$PGPOOL_CONF_FILE" <<EOF
backend_hostname$num = '$host'
backend_port$num = $port
backend_weight$num = $weight
backend_data_directory$num = '$dir'
backend_flag$num = '$flag'
EOF
    if [[ -n "$application" ]]; then
        cat >>"$PGPOOL_CONF_FILE" <<EOF
backend_application_name$num = '$application'
EOF
    fi
}

########################
# Create basic pgpool.conf file using the example provided in the etc/ folder
# Globals:
#   PGPOOL_*
# Arguments:
#   None
# Returns:
#   None
#########################
pgpool_create_config() {
    local pool_passwd=""
    local i=0

    if is_boolean_yes "$PGPOOL_ENABLE_POOL_PASSWD"; then
        pool_passwd="$PGPOOL_PASSWD_FILE"
    else
        # Specifying '' (empty) disables the use of password file.
        # ref: https://www.pgpool.net/docs/latest/en/html/runtime-config-connection.html#GUC-POOL-PASSWD
        pool_passwd=""
    fi

    info "Generating pgpool.conf file..."
    # Configuring Pgpool-II to use the streaming replication mode since it's the recommended way
    # ref: http://www.pgpool.net/docs/latest/en/html/configuring-pgpool.html
    cp "${PGPOOL_BASE_DIR}/etc/pgpool.conf.sample" "$PGPOOL_CONF_FILE"

    # Connection settings
    # ref: http://www.pgpool.net/docs/latest/en/html/runtime-config-connection.html#RUNTIME-CONFIG-CONNECTION-SETTINGS
    pgpool_set_property "listen_addresses" "*"
    pgpool_set_property "port" "$PGPOOL_PORT_NUMBER"
    pgpool_set_property "unix_socket_directories" "$PGPOOL_TMP_DIR"
    pgpool_set_property "pcp_socket_dir" "$PGPOOL_TMP_DIR"
    # Connection Pooling settings
    # http://www.pgpool.net/docs/latest/en/html/runtime-config-connection-pooling.html
    [[ -n "${PGPOOL_NUM_INIT_CHILDREN:-}" ]] && pgpool_set_property "num_init_children" "$PGPOOL_NUM_INIT_CHILDREN"
    [[ -n "${PGPOOL_RESERVED_CONNECTIONS:-}" ]] && pgpool_set_property "reserved_connections" "$PGPOOL_RESERVED_CONNECTIONS"
    pgpool_set_property "max_pool" "$PGPOOL_MAX_POOL"
    [[ -n "${PGPOOL_CHILD_MAX_CONNECTIONS:-}" ]] && pgpool_set_property "child_max_connections" "$PGPOOL_CHILD_MAX_CONNECTIONS"
    [[ -n "${PGPOOL_CHILD_LIFE_TIME:-}" ]] && pgpool_set_property "child_life_time" "$PGPOOL_CHILD_LIFE_TIME"
    pgpool_set_property "connection_cache" "$(is_boolean_yes "$PGPOOL_ENABLE_CONNECTION_CACHE" && echo "on" || echo "off")"
    [[ -n "${PGPOOL_CONNECTION_LIFE_TIME:-}" ]] && pgpool_set_property "connection_life_time" "$PGPOOL_CONNECTION_LIFE_TIME"
    [[ -n "${PGPOOL_CLIENT_IDLE_LIMIT-}" ]] && pgpool_set_property "client_idle_limit" "$PGPOOL_CLIENT_IDLE_LIMIT"
    # Logging settings
    # https://www.pgpool.net/docs/latest/en/html/runtime-config-logging.html
    pgpool_set_property "log_connections" "$(is_boolean_yes "$PGPOOL_ENABLE_LOG_CONNECTIONS" && echo "on" || echo "off")"
    pgpool_set_property "log_hostname" "$(is_boolean_yes "$PGPOOL_ENABLE_LOG_HOSTNAME" && echo "on" || echo "off")"
    pgpool_set_property "log_pcp_processes" "$(is_boolean_yes "$PGPOOL_ENABLE_LOG_PCP_PROCESSES" && echo "on" || echo "off")"
    pgpool_set_property "log_per_node_statement" "$(is_boolean_yes "$PGPOOL_ENABLE_LOG_PER_NODE_STATEMENT" && echo "on" || echo "off")"
    [[ -n "${PGPOOL_LOG_LINE_PREFIX:-}" ]] && pgpool_set_property "log_line_prefix" "$PGPOOL_LOG_LINE_PREFIX"
    [[ -n "${PGPOOL_CLIENT_MIN_MESSAGES:-}" ]] && pgpool_set_property "client_min_messages" "$PGPOOL_CLIENT_MIN_MESSAGES"
    # Authentication settings
    # ref: http://www.pgpool.net/docs/latest/en/html/runtime-config-connection.html#RUNTIME-CONFIG-AUTHENTICATION-SETTINGS
    pgpool_set_property "enable_pool_hba" "$(is_boolean_yes "$PGPOOL_ENABLE_POOL_HBA" && echo "on" || echo "off")"
    # ref: https://www.pgpool.net/docs/latest/en/html/runtime-config-connection.html#GUC-ALLOW-CLEAR-TEXT-FRONTEND-AUTH
    if ! is_boolean_yes "$PGPOOL_ENABLE_POOL_HBA" || [[ "$PGPOOL_AUTHENTICATION_METHOD" = "trust" ]]; then
        pgpool_set_property "allow_clear_text_frontend_auth" "on"
    else
        pgpool_set_property "allow_clear_text_frontend_auth" "off"
    fi
    pgpool_set_property "pool_passwd" "$pool_passwd"
    pgpool_set_property "authentication_timeout" "30"
    # File Locations settings
    pgpool_set_property "pid_file_name" "$PGPOOL_PID_FILE"
    pgpool_set_property "logdir" "$PGPOOL_LOG_DIR"
    # Load Balancing settings
    # https://www.pgpool.net/docs/latest/en/html/runtime-config-load-balancing.html
    pgpool_set_property "load_balance_mode" "$(is_boolean_yes "$PGPOOL_ENABLE_LOAD_BALANCING" && echo "on" || echo "off")"
    pgpool_set_property "black_function_list" "nextval,setval"
    pgpool_set_property "statement_level_load_balance" "$(is_boolean_yes "$PGPOOL_ENABLE_STATEMENT_LOAD_BALANCING" && echo "on" || echo "off")"
    # Streaming Replication Check settings
    # https://www.pgpool.net/docs/latest/en/html/runtime-streaming-replication-check.html
    pgpool_set_property "sr_check_user" "$PGPOOL_SR_CHECK_USER"
    pgpool_set_property "sr_check_password" "$(pgpool_encrypt_password ${PGPOOL_SR_CHECK_PASSWORD})"
    pgpool_set_property "sr_check_period" "$PGPOOL_SR_CHECK_PERIOD"
    pgpool_set_property "sr_check_database" "$PGPOOL_SR_CHECK_DATABASE"
    # Healthcheck per node settings
    # https://www.pgpool.net/docs/latest/en/html/runtime-config-health-check.html
    pgpool_set_property "health_check_period" "$PGPOOL_HEALTH_CHECK_PERIOD"
    pgpool_set_property "health_check_timeout" "$PGPOOL_HEALTH_CHECK_TIMEOUT"
    pgpool_set_property "health_check_user" "$PGPOOL_HEALTH_CHECK_USER"
    pgpool_set_property "health_check_password" "$(pgpool_encrypt_password ${PGPOOL_HEALTH_CHECK_PASSWORD})"
    pgpool_set_property "health_check_max_retries" "$PGPOOL_HEALTH_CHECK_MAX_RETRIES"
    pgpool_set_property "health_check_retry_delay" "$PGPOOL_HEALTH_CHECK_RETRY_DELAY"
    pgpool_set_property "connect_timeout" "$PGPOOL_CONNECT_TIMEOUT"
    # Failover settings
    pgpool_set_property "failover_command" "echo \">>> Failover - that will initialize new primary node search!\""
    pgpool_set_property "failover_on_backend_error" "$PGPOOL_FAILOVER_ON_BACKEND_ERROR"
    pgpool_set_property "failover_on_backend_shutdown" "$PGPOOL_FAILOVER_ON_BACKEND_SHUTDOWN"
    # Keeps searching for a primary node forever when a failover occurs
    pgpool_set_property "search_primary_node_timeout" "0"
    pgpool_set_property "disable_load_balance_on_write" "$PGPOOL_DISABLE_LOAD_BALANCE_ON_WRITE"
    # SSL settings
    # https://www.pgpool.net/docs/latest/en/html/runtime-ssl.html
    if is_boolean_yes "$PGPOOL_ENABLE_TLS"; then
        chmod 600 "$PGPOOL_TLS_KEY_FILE" || warn "Could not set compulsory permissions (600) on file ${PGPOOL_TLS_KEY_FILE}"
        pgpool_set_property "ssl" "on"
        # Server ciphers are preferred by default
        ! is_boolean_yes "$PGPOOL_TLS_PREFER_SERVER_CIPHERS" && pgpool_set_property "ssl_prefer_server_ciphers" "off"
        [[ -n $PGPOOL_TLS_CA_FILE ]] && pgpool_set_property "ssl_ca_cert" "$PGPOOL_TLS_CA_FILE"
        pgpool_set_property "ssl_cert" "$PGPOOL_TLS_CERT_FILE"
        pgpool_set_property "ssl_key" "$PGPOOL_TLS_KEY_FILE"
    fi

    # Backend settings
    read -r -a nodes <<<"$(tr ',;' ' ' <<<"${PGPOOL_BACKEND_NODES}")"
    if is_boolean_yes "$PGPOOL_AUTO_FAILBACK"; then
        pgpool_set_property "auto_failback" "on"

        read -r -a app_name <<<"$(tr ',;' ' ' <<<"${PGPOOL_BACKEND_APPLICATION_NAMES}")"
    fi

    for node in "${nodes[@]}"; do
        pgpool_create_backend_config "$node" "$(is_boolean_yes "$PGPOOL_AUTO_FAILBACK" && echo "${app_name[i]}")"
        ((i += 1))
    done

    if [[ -f "$PGPOOL_USER_CONF_FILE" ]]; then
        info "Custom configuration '$PGPOOL_USER_CONF_FILE' detected!. Adding it to the configuration file."
        cat "$PGPOOL_USER_CONF_FILE" >>"$PGPOOL_CONF_FILE"
    fi

    if [[ -f "$PGPOOL_USER_HBA_FILE" ]]; then
        info "Custom configuration '$PGPOOL_USER_HBA_FILE' detected!. Overwriting the generated hba file."
        cat "$PGPOOL_USER_HBA_FILE" >"$PGPOOL_PGHBA_FILE"
    fi
}

########################
# Execute postgresql encrypt command
# Globals:
#   PGPOOL_*
# Arguments:
#   $@ - Command to execute
# Returns:
#   String
#########################
pgpool_encrypt_execute() {
    local -a password_encryption_cmd=("pg_md5")

    # If authentication method for 'all' users is 'trust', we still use
    # pg_enc to generate encrypted passwords for 'postgres' and 'sr_check' users
    if [[ "$PGPOOL_AUTHENTICATION_METHOD" =~ ^(scram-sha-256|trust)$ ]]; then
        if is_file_writable "$PGPOOLKEYFILE"; then
            # Creating a PGPOOLKEYFILE as it is writeable
            echo "$PGPOOL_AES_KEY" > "$PGPOOLKEYFILE"
            # Fix permissions for PGPOOLKEYFILE
            chmod 0600 "$PGPOOLKEYFILE"
        fi
        password_encryption_cmd=("pg_enc" "--key-file=${PGPOOLKEYFILE}")
    fi

    "${password_encryption_cmd[@]}" "$@"
}

########################
# Generates a password file for local authentication
# Globals:
#   PGPOOL_*
# Arguments:
#   None
# Returns:
#   None
#########################
pgpool_generate_password_file() {
    if is_boolean_yes "$PGPOOL_ENABLE_POOL_PASSWD"; then
        info "Generating password file for local authentication..."

        debug_execute pgpool_encrypt_execute -m --config-file="$PGPOOL_CONF_FILE" -u "$PGPOOL_POSTGRES_USERNAME" "$PGPOOL_POSTGRES_PASSWORD"
        if [[ -n "$PGPOOL_SR_CHECK_USER" ]]; then
            debug_execute pgpool_encrypt_execute -m --config-file="$PGPOOL_CONF_FILE" -u "$PGPOOL_SR_CHECK_USER" "$PGPOOL_SR_CHECK_PASSWORD"
        fi

        if [[ -n "${PGPOOL_POSTGRES_CUSTOM_USERS}" ]]; then
            read -r -a custom_users_list <<<"$(tr ',;' ' ' <<<"${PGPOOL_POSTGRES_CUSTOM_USERS}")"
            read -r -a custom_passwords_list <<<"$(tr ',;' ' ' <<<"${PGPOOL_POSTGRES_CUSTOM_PASSWORDS}")"

            local index=0
            for user in "${custom_users_list[@]}"; do
                debug_execute pgpool_encrypt_execute -m --config-file="$PGPOOL_CONF_FILE" -u "$user" "${custom_passwords_list[$index]}"
                ((index += 1))
            done
        fi
    else
        info "Skip generating password file due to PGPOOL_ENABLE_POOL_PASSWD = no"
    fi
}

########################
# Encrypts a password
# Globals:
#   PGPOOL_*
# Arguments:
#   $1 - password
# Returns:
#   String
#########################
pgpool_encrypt_password() {
    local -r password="${1:?missing password}"

    if [[ "$PGPOOL_AUTHENTICATION_METHOD" =~ ^(scram-sha-256|trust)$ ]]; then
        pgpool_encrypt_execute "$password" | grep -o -E "AES.+" | tr -d '\n'
    else
        pgpool_encrypt_execute "$password" | tr -d '\n'
    fi
}

########################
# Run custom initialization scripts
# Globals:
#   PGPOOL_*
# Arguments:
#   None
# Returns:
#   None
#########################
pgpool_custom_init_scripts() {
    if [[ -n $(find "$PGPOOL_INITSCRIPTS_DIR/" -type f -name "*.sh") ]]; then
        info "Loading user's custom files from $PGPOOL_INITSCRIPTS_DIR ..."
        find "$PGPOOL_INITSCRIPTS_DIR/" -type f -name "*.sh" | sort | while read -r f; do
            if [[ -x "$f" ]]; then
                debug "Executing $f"
                "$f"
            else
                debug "Sourcing $f"
                . "$f"
            fi
        done
    fi
}

########################
# Generate a password file for pgpool admin user
# Globals:
#   PGPOOL_*
# Arguments:
#   None
# Returns:
#   None
#########################
pgpool_generate_admin_password_file() {
    info "Generating password file for pgpool admin user..."
    local passwd

    passwd=$(pg_md5 "$PGPOOL_ADMIN_PASSWORD")
    cat >>"$PGPOOL_PCP_CONF_FILE" <<EOF
$PGPOOL_ADMIN_USERNAME:$passwd
EOF
}

########################
# Ensure Pgpool is initialized
# Globals:
#   PGPOOL_*
# Arguments:
#   None
# Returns:
#   None
#########################
pgpool_initialize() {
    info "Initializing Pgpool-II..."

    # This fixes an issue where the trap would kill the entrypoint.sh, if a PID was left over from a previous run
    # Exec replaces the process without creating a new one, and when the container is restarted it may have the same PID
    rm -f "$PGPOOL_PID_FILE"

    # Configuring permissions for tmp, logs and data folders
    am_i_root && configure_permissions_ownership "$PGPOOL_TMP_DIR $PGPOOL_LOG_DIR" -u "$PGPOOL_DAEMON_USER" -g "$PGPOOL_DAEMON_GROUP"
    am_i_root && configure_permissions_ownership "$PGPOOL_DATA_DIR" -u "$PGPOOL_DAEMON_USER" -g "$PGPOOL_DAEMON_GROUP" -d "755" -f "644"

    pgpool_create_pghba
    pgpool_create_config
    pgpool_generate_password_file
    pgpool_generate_admin_password_file
}
