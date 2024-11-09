#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami KeyDB library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh

# Functions

########################
# Retrieve a configuration setting value
# Globals:
#   KEYDB_CONF_FILE
# Arguments:
#   $1 - key
# Returns:
#   None
#########################
keydb_conf_get() {
    local -r key="${1:?missing key}"

    if grep -q -E "^\s*$key " "$KEYDB_CONF_FILE"; then
        grep -E "^\s*$key " "$KEYDB_CONF_FILE" | awk '{print $2}'
    fi
}

########################
# Set a configuration setting value
# Globals:
#   KEYDB_CONF_FILE
# Arguments:
#   $1 - key
#   $2 - value
# Returns:
#   None
#########################
keydb_conf_set() {
    local -r key="${1:?missing key}"
    local value="${2:-}"

    # Sanitize inputs
    value="${value//\\/\\\\}"
    value="${value//&/\\&}"
    value="${value//\?/\\?}"
    value="${value//[$'\t\n\r']}"
    [[ "$value" = "" ]] && value="\"$value\""

    # Determine whether to enable the configuration for RDB persistence, if yes, do not enable the replacement operation
    if [ "${key}" == "save" ]; then
        echo "${key} ${value}" >> "$KEYDB_CONF_FILE"
    else
        replace_in_file "$KEYDB_CONF_FILE" "^#*\s*${key} .*" "${key} ${value}" false
    fi
}

########################
# Unset a configuration setting value
# Globals:
#   KEYDB_CONF_FILE
# Arguments:
#   $1 - key
# Returns:
#   None
#########################
keydb_conf_unset() {
    local -r key="${1:?missing key}"
    remove_in_file "$KEYDB_CONF_FILE" "^\s*$key .*" false
}

########################
# Check if KeyDB is running
# Globals:
#   KEYDB_PID_FILE
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_keydb_running() {
    local pid
    pid="$(get_pid_from_file "$KEYDB_PID_FILE")"

    if [[ -z "$pid" ]]; then
        false
    else
        is_service_running "$pid"
    fi
}

########################
# Check if KeyDB is not running
# Globals:
#   KEYDB_BASE_DIR
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_keydb_not_running() {
    ! is_keydb_running
}

########################
# Stop KeyDB
# Globals:
#   KEYDB_*
# Arguments:
#   None
# Returns:
#   None
#########################
keydb_stop() {
    local pass
    local port
    local args

    ! is_keydb_running && return
    pass="$(keydb_conf_get "requirepass")"
    is_boolean_yes "$KEYDB_TLS_ENABLED" && port="$(keydb_conf_get "tls-port")" || port="$(keydb_conf_get "port")"

    [[ -n "$pass" ]] && args+=("-a" "$pass")
    [[ "$port" != "0" ]] && args+=("-p" "$port")

    debug "Stopping KeyDB"
    if am_i_root; then
        run_as_user "$KEYDB_DAEMON_USER" "${KEYDB_BIN_DIR}/keydb-cli" "${args[@]}" shutdown
    else
        "${KEYDB_BIN_DIR}/keydb-cli" "${args[@]}" shutdown
    fi
}

########################
# Prepare default KeyDB configuration
# Globals:
#   KEYDB_*
# Arguments:
#   None
# Returns:
#   None
########################
keydb_default_config() {
    mv "${KEYDB_CONF_DIR}/keydb-default.conf" "$KEYDB_CONF_FILE"
    chmod g+rw "$KEYDB_CONF_FILE"

    info "Setting KeyDB config file..."
    keydb_conf_set port "$KEYDB_DEFAULT_PORT_NUMBER"
    keydb_conf_set dir "$KEYDB_DATA_DIR"
    keydb_conf_set pidfile "$KEYDB_PID_FILE"
    keydb_conf_set daemonize yes
    # Log to stdout
    keydb_conf_set logfile "" 
    # Disable RDB persistence, AOF persistence already enabled.
    # Ref: https://docs.keydb.dev/docs/persistence/#rdb-disadvantages
    keydb_conf_set save ""

    # Copy all initially generated configuration files to the default directory
    # (this is to avoid breaking when entrypoint is being overridden)
    cp -r "${KEYDB_CONF_DIR}/"* "$KEYDB_DEFAULT_CONF_DIR"
}

########################
# Validate settings in KEYDB_* env vars.
# Globals:
#   KEYDB_*
# Arguments:
#   None
# Returns:
#   None
#########################
keydb_validate() {
    debug "Validating settings in KEYDB_* env vars.."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }
    empty_password_error() {
        print_validation_error "The $1 environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow the container to be started with blank passwords. This is recommended only for development."
    }
    check_yes_no_value() {
        if ! is_yes_no_value "${!1}" && ! is_true_false_value "${!1}"; then
            print_validation_error "The allowed values for ${1} are: yes no"
        fi
    }

    check_yes_no_value "KEYDB_AOF_ENABLED"
    check_yes_no_value "KEYDB_ALLOW_REMOTE_CONNECTIONS"
    check_yes_no_value "KEYDB_ACTIVE_REPLICA"
    check_yes_no_value "KEYDB_TLS_ENABLED"
    check_yes_no_value "KEYDB_TLS_AUTH_CLIENTS"

    if is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
        warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD}. For safety reasons, do not use this flag in a production environment."
    else
        [[ -z "$KEYDB_PASSWORD" ]] && empty_password_error KEYDB_PASSWORD
    fi
    if [[ -n "$KEYDB_REPLICATION_MODE" ]]; then
        if [[ "$KEYDB_REPLICATION_MODE" = "replica" ]]; then
            read -r -a hosts_list <<< "$(tr ',;' ' ' <<< "$KEYDB_MASTER_HOSTS")"
            if [[ "${#hosts_list[@]}" -eq 0 ]]; then
                print_validation_error "You need to provide at least one host to replicate from in the environment variable KEYDB_MASTER_HOSTS"
            fi
            if [[ "${#hosts_list[@]}" -gt 1 ]] && ! is_boolean_yes "$KEYDB_ACTIVE_REPLICA"; then
                print_validation_error "You can only specify more than one host in KEYDB_MASTER_HOSTS if KEYDB_ACTIVE_REPLICA is set to 'yes'"
            fi
            if [[ -n "$KEYDB_MASTER_PORT_NUMBER" ]]; then
                if ! err=$(validate_port "$KEYDB_MASTER_PORT_NUMBER"); then
                    print_validation_error "An invalid port was specified in the environment variable KEYDB_MASTER_PORT_NUMBER: $err"
                fi
            fi
            if ! is_boolean_yes "$ALLOW_EMPTY_PASSWORD" && [[ -z "$KEYDB_MASTER_PASSWORD" ]]; then
                empty_password_error KEYDB_MASTER_PASSWORD
            fi
        elif [[ "$KEYDB_REPLICATION_MODE" != "master" ]]; then
            print_validation_error "Invalid replication mode. Available options are 'master/replica'"
        fi
    fi
    if is_boolean_yes "$KEYDB_TLS_ENABLED"; then
        if [[ "$KEYDB_PORT_NUMBER" == "$KEYDB_TLS_PORT_NUMBER" ]] && [[ "$KEYDB_PORT_NUMBER" != "6379" ]]; then
            # If both ports are assigned the same numbers and they are different to the default settings
            print_validation_error "Environment variables KEYDB_PORT_NUMBER and KEYDB_TLS_PORT_NUMBER point to the same port number (${KEYDB_PORT_NUMBER}). Change one of them or disable non-TLS traffic by setting KEYDB_PORT_NUMBER=0"
        fi
        if [[ -z "$KEYDB_TLS_CERT_FILE" ]]; then
            print_validation_error "You must provide a X.509 certificate in order to use TLS"
        elif [[ ! -f "$KEYDB_TLS_CERT_FILE" ]]; then
            print_validation_error "The X.509 certificate file in the specified path ${KEYDB_TLS_CERT_FILE} does not exist"
        fi
        if [[ -z "$KEYDB_TLS_KEY_FILE" ]]; then
            print_validation_error "You must provide a private key in order to use TLS"
        elif [[ ! -f "$KEYDB_TLS_KEY_FILE" ]]; then
            print_validation_error "The private key file in the specified path ${KEYDB_TLS_KEY_FILE} does not exist"
        fi
        if [[ -z "$KEYDB_TLS_CA_FILE" ]]; then
            if [[ -z "$KEYDB_TLS_CA_DIR" ]]; then
                print_validation_error "You must provide either a CA X.509 certificate or a CA certificates directory in order to use TLS"
            elif [[ ! -d "$KEYDB_TLS_CA_DIR" ]]; then
                print_validation_error "The CA certificates directory specified by path ${KEYDB_TLS_CA_DIR} does not exist"
            fi
        elif [[ ! -f "$KEYDB_TLS_CA_FILE" ]]; then
            print_validation_error "The CA X.509 certificate file in the specified path ${KEYDB_TLS_CA_FILE} does not exist"
        fi
        if [[ -n "$KEYDB_TLS_DH_PARAMS_FILE" ]] && [[ ! -f "$KEYDB_TLS_DH_PARAMS_FILE" ]]; then
            print_validation_error "The DH param file in the specified path ${KEYDB_TLS_DH_PARAMS_FILE} does not exist"
        fi
    fi

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Configure KeyDB replication
# Globals:
#   KEYDB_BASE_DIR
# Arguments:
#   $1 - Replication mode
# Returns:
#   None
#########################
keydb_configure_replication() {
    info "Configuring replication mode"

    keydb_conf_set replica-announce-ip "${KEYDB_REPLICA_IP:-$(get_machine_ip)}"
    keydb_conf_set replica-announce-port "${KEYDB_REPLICA_PORT:-$KEYDB_MASTER_PORT_NUMBER}"
    # Use TLS in the replication connections
    if is_boolean_yes "$KEYDB_TLS_ENABLED"; then
        keydb_conf_set tls-replication yes
    fi

    if [[ "$KEYDB_REPLICATION_MODE" = "master" ]]; then
        if [[ -n "$KEYDB_PASSWORD" ]]; then
            keydb_conf_set masterauth "$KEYDB_PASSWORD"
        fi
    elif [[ "$KEYDB_REPLICATION_MODE" = "replica" ]]; then
        [[ -n "$KEYDB_MASTER_PASSWORD" ]] && keydb_conf_set masterauth "$KEYDB_MASTER_PASSWORD"
        read -r -a hosts_list <<< "$(tr ',;' ' ' <<< "$KEYDB_MASTER_HOSTS")"
        if is_boolean_yes "$KEYDB_ACTIVE_REPLICA"; then
            keydb_conf_set active-replica yes
            [[ "${#hosts_list[@]}" -gt 1 ]] && keydb_conf_set multi-master yes
        fi
        # Wait for master replicas to be ready
        for host in "${hosts_list[@]}"; do
            wait-for-port --host "$host" "$KEYDB_MASTER_PORT_NUMBER"
        done
        # We can't use keydb_conf_set here given we must ensure 'active-replica'
        # is set before any 'replicaof' directive
        for host in "${hosts_list[@]}"; do
            echo "replicaof ${host} ${KEYDB_MASTER_PORT_NUMBER}" >> "$KEYDB_CONF_FILE"
        done
    fi
}

########################
# Disable KeyDB command(s)
# Globals:
#   KEYDB_BASE_DIR
# Arguments:
#   $1 - Array of commands to disable
# Returns:
#   None
#########################
keydb_disable_unsafe_commands() {
    # The current syntax gets a comma separated list of commands, we split them
    # before passing to keydb_disable_unsafe_commands
    read -r -a disabledCommands <<< "$(tr ',' ' ' <<< "$KEYDB_DISABLE_COMMANDS")"
    debug "Disabling commands: ${disabledCommands[*]}"
    for cmd in "${disabledCommands[@]}"; do
        if grep -E -q "^\s*rename-command\s+$cmd\s+\"\"\s*$" "$KEYDB_CONF_FILE"; then
            debug "$cmd was already disabled"
            continue
        fi
        echo "rename-command $cmd \"\"" >> "$KEYDB_CONF_FILE"
    done
}

########################
# KeyDB configure permissions
# Globals:
#   KEYDB_*
# Arguments:
#   None
# Returns:
#   None
#########################
keydb_configure_permissions() {
    debug "Ensuring expected directories/files exist"
    for dir in "$KEYDB_BASE_DIR" "$KEYDB_DATA_DIR" "$KEYDB_TMP_DIR"; do
        ensure_dir_exists "$dir"
        if am_i_root; then
            chown "$KEYDB_DAEMON_USER:$KEYDB_DAEMON_GROUP" "$dir"
        fi
    done
}

#########################
# Append include directives to keydb.conf
# Globals:
#   KEYDB_*
# Arguments:
#   None
# Returns:
#   None
#########################
keydb_append_include_conf() {
    if [[ -f "$KEYDB_OVERRIDES_FILE" ]]; then
        # Remove all include statements including commented ones
        keydb_conf_set include "$KEYDB_OVERRIDES_FILE"
        keydb_conf_unset "include"
        echo "include $KEYDB_OVERRIDES_FILE" >> "${KEYDB_BASE_DIR}/etc/keydb.conf"
    fi
}

########################
# Configures KeyDB
# Globals:
#   KEYDB_*
# Arguments:
#   None
# Returns:
#   None
#########################
keydb_configure() {
    # User injected custom configuration
    if [[ -e "${KEYDB_MOUNTED_CONF_DIR}/keydb.conf" ]]; then
        cp "${KEYDB_MOUNTED_CONF_DIR}/keydb.conf" "$KEYDB_CONF_FILE"
    else
        info "Setting KeyDB config file"
        if is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
            # Allow remote connections without password
            keydb_conf_set protected-mode no
        fi

        keydb_conf_set port "$KEYDB_PORT_NUMBER"
        # Allow remote connections
        is_boolean_yes "$KEYDB_ALLOW_REMOTE_CONNECTIONS" && keydb_conf_set bind "0.0.0.0 ::"
        # Enable AOF https://docs.keydb.dev/docs/persistence/#append-only-file
        # Leave default fsync (every second)
        keydb_conf_set appendonly "$KEYDB_AOF_ENABLED"

        if is_empty_value "$KEYDB_RDB_POLICY"; then
            if is_boolean_yes "$KEYDB_RDB_POLICY_DISABLED"; then
                keydb_conf_set save ""
            fi
        else
            # The value stored in $i here is the number of seconds and times of save rules in keydb rdb mode
            for i in ${KEYDB_RDB_POLICY}; do
                keydb_conf_set save "${i//#/ }"
            done
        fi
        
        # TLS configuration
        if is_boolean_yes "$KEYDB_TLS_ENABLED"; then
            if [[ "$KEYDB_PORT_NUMBER" ==  "6379" ]] && [[ "$KEYDB_TLS_PORT_NUMBER" ==  "6379" ]]; then
                # If both ports are set to default values, enable TLS traffic only
                keydb_conf_set port 0
                keydb_conf_set tls-port "$KEYDB_TLS_PORT_NUMBER"
            else
                # Different ports were specified
                keydb_conf_set tls-port "$KEYDB_TLS_PORT_NUMBER"
            fi
            keydb_conf_set tls-cert-file "$KEYDB_TLS_CERT_FILE"
            keydb_conf_set tls-key-file "$KEYDB_TLS_KEY_FILE"
            # shellcheck disable=SC2015
            is_empty_value "$KEYDB_TLS_CA_FILE" && keydb_conf_set tls-ca-cert-dir "$KEYDB_TLS_CA_DIR" || keydb_conf_set tls-ca-cert-file "$KEYDB_TLS_CA_FILE"
            ! is_empty_value "$KEYDB_TLS_KEY_FILE_PASS" && keydb_conf_set tls-key-file-pass "$KEYDB_TLS_KEY_FILE_PASS"
            [[ -n "$KEYDB_TLS_DH_PARAMS_FILE" ]] && keydb_conf_set tls-dh-params-file "$KEYDB_TLS_DH_PARAMS_FILE"
            keydb_conf_set tls-auth-clients "$KEYDB_TLS_AUTH_CLIENTS"
        fi
        # Multithreading configuration
        ! is_empty_value "$KEYDB_IO_THREADS_DO_READS" && keydb_conf_set "io-threads-do-reads" "$KEYDB_IO_THREADS_DO_READS"
        ! is_empty_value "$KEYDB_IO_THREADS" && keydb_conf_set "io-threads" "$KEYDB_IO_THREADS"

        if [[ -n "$KEYDB_PASSWORD" ]]; then
            keydb_conf_set requirepass "$KEYDB_PASSWORD"
        else
            keydb_conf_unset requirepass
        fi
        if [[ -n "$KEYDB_DISABLE_COMMANDS" ]]; then
            keydb_disable_unsafe_commands
        fi
        if [[ -n "$KEYDB_ACL_FILE" ]]; then
            keydb_conf_set aclfile "$KEYDB_ACL_FILE"
        fi
        keydb_append_include_conf

        # Configure Replication mode
        if [[ -n "$KEYDB_REPLICATION_MODE" ]]; then
            keydb_configure_replication
        fi
    fi

    # Avoid exit code from previous conditions to affect the result of this function
    true
}

########################
# Ensure KeyDB is initialized
# Globals:
#   KEYDB_*
# Arguments:
#   None
# Returns:
#   None
#########################
keydb_initialize() {
    info "Initializing KeyDB"

    # This fixes an issue where the trap would kill the entrypoint.sh, if a PID was left over from a previous run
    # Exec replaces the process without creating a new one, and when the container is restarted it may have the same PID
    rm -f "$KEYDB_BASE_DIR/tmp/keydb.pid"

    # Ensure the KeyDB directories have proper permissions
    keydb_configure_permissions
    # Configure KeyDB
    keydb_configure
}
