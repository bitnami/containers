#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Valkey library

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
#   VALKEY_BASE_DIR
# Arguments:
#   $1 - key
#   $2 - conf file
# Returns:
#   None
#########################
valkey_conf_get() {
    local -r key="${1:?missing key}"
    local -r conf_file="${2:-"${VALKEY_BASE_DIR}/etc/valkey.conf"}"

    if grep -q -E "^\s*$key " "$conf_file"; then
        grep -E "^\s*$key " "$conf_file" | awk '{print $2}'
    fi
}

########################
# Set a configuration setting value
# Globals:
#   VALKEY_BASE_DIR
# Arguments:
#   $1 - key
#   $2 - value
# Returns:
#   None
#########################
valkey_conf_set() {
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
        echo "${key} ${value}" >> "${VALKEY_BASE_DIR}/etc/valkey.conf"
    else
        replace_in_file "${VALKEY_BASE_DIR}/etc/valkey.conf" "^#*\s*${key} .*" "${key} ${value}" false
    fi
}

########################
# Unset a configuration setting value
# Globals:
#   VALKEY_BASE_DIR
# Arguments:
#   $1 - key
# Returns:
#   None
#########################
valkey_conf_unset() {
    local -r key="${1:?missing key}"
    remove_in_file "${VALKEY_BASE_DIR}/etc/valkey.conf" "^\s*$key .*" false
}

########################
# Get Valkey version
# Globals:
#   VALKEY_BASE_DIR
# Arguments:
#   None
# Returns:
#   Valkey versoon
#########################
valkey_version() {
    "${VALKEY_BASE_DIR}/bin/valkey-cli" --version | grep -E -o "[0-9]+.[0-9]+.[0-9]+"
}

########################
# Get Valkey major version
# Globals:
#   VALKEY_BASE_DIR
# Arguments:
#   None
# Returns:
#   Valkey major version
#########################
valkey_major_version() {
    valkey_version | grep -E -o "^[0-9]+"
}

########################
# Check if valkey is running
# Globals:
#   VALKEY_BASE_DIR
# Arguments:
#   $1 - pid file
# Returns:
#   Boolean
#########################
is_valkey_running() {
    local pid_file="${1:-"${VALKEY_BASE_DIR}/tmp/valkey.pid"}"
    local pid
    pid="$(get_pid_from_file "$pid_file")"

    if [[ -z "$pid" ]]; then
        false
    else
        is_service_running "$pid"
    fi
}

########################
# Check if valkey is not running
# Globals:
#   VALKEY_BASE_DIR
# Arguments:
#   $1 - pid file
# Returns:
#   Boolean
#########################
is_valkey_not_running() {
    ! is_valkey_running "$@"
}

########################
# Stop Valkey
# Globals:
#   VALKEY_*
# Arguments:
#   None
# Returns:
#   None
#########################
valkey_stop() {
    local pass
    local port
    local args

    ! is_valkey_running && return
    pass="$(valkey_conf_get "requirepass")"
    is_boolean_yes "$VALKEY_TLS_ENABLED" && port="$(valkey_conf_get "tls-port")" || port="$(valkey_conf_get "port")"

    [[ -n "$pass" ]] && args+=("-a" "$pass")
    [[ "$port" != "0" ]] && args+=("-p" "$port")

    debug "Stopping Valkey"
    if am_i_root; then
        run_as_user "$VALKEY_DAEMON_USER" "${VALKEY_BASE_DIR}/bin/valkey-cli" "${args[@]}" shutdown
    else
        "${VALKEY_BASE_DIR}/bin/valkey-cli" "${args[@]}" shutdown
    fi
}

########################
# Validate settings in VALKEY_* env vars.
# Globals:
#   VALKEY_*
# Arguments:
#   None
# Returns:
#   None
#########################
valkey_validate() {
    debug "Validating settings in VALKEY_* env vars.."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    empty_password_enabled_warn() {
        warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD}. For safety reasons, do not use this flag in a production environment."
    }
    empty_password_error() {
        print_validation_error "The $1 environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow the container to be started with blank passwords. This is recommended only for development."
    }

    if is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
        empty_password_enabled_warn
    else
        [[ -z "$VALKEY_PASSWORD" ]] && empty_password_error VALKEY_PASSWORD
    fi
    if [[ -n "$VALKEY_REPLICATION_MODE" ]]; then
        if [[ "$VALKEY_REPLICATION_MODE" = "replica" ]]; then
            if [[ -n "$VALKEY_PRIMARY_PORT_NUMBER" ]]; then
                if ! err=$(validate_port "$VALKEY_PRIMARY_PORT_NUMBER"); then
                    print_validation_error "An invalid port was specified in the environment variable VALKEY_PRIMARY_PORT_NUMBER: $err"
                fi
            fi
            if ! is_boolean_yes "$ALLOW_EMPTY_PASSWORD" && [[ -z "$VALKEY_PRIMARY_PASSWORD" ]]; then
                empty_password_error VALKEY_PRIMARY_PASSWORD
            fi
        elif [[ "$VALKEY_REPLICATION_MODE" != "primary" ]]; then
            print_validation_error "Invalid replication mode. Available options are 'primary/replica'"
        fi
    fi
    if is_boolean_yes "$VALKEY_TLS_ENABLED"; then
        if [[ "$VALKEY_PORT_NUMBER" == "$VALKEY_TLS_PORT_NUMBER" ]] && [[ "$VALKEY_PORT_NUMBER" != "6379" ]]; then
            # If both ports are assigned the same numbers and they are different to the default settings
            print_validation_error "Environment variables VALKEY_PORT_NUMBER and VALKEY_TLS_PORT_NUMBER point to the same port number (${VALKEY_PORT_NUMBER}). Change one of them or disable non-TLS traffic by setting VALKEY_PORT_NUMBER=0"
        fi
        if [[ -z "$VALKEY_TLS_CERT_FILE" ]]; then
            print_validation_error "You must provide a X.509 certificate in order to use TLS"
        elif [[ ! -f "$VALKEY_TLS_CERT_FILE" ]]; then
            print_validation_error "The X.509 certificate file in the specified path ${VALKEY_TLS_CERT_FILE} does not exist"
        fi
        if [[ -z "$VALKEY_TLS_KEY_FILE" ]]; then
            print_validation_error "You must provide a private key in order to use TLS"
        elif [[ ! -f "$VALKEY_TLS_KEY_FILE" ]]; then
            print_validation_error "The private key file in the specified path ${VALKEY_TLS_KEY_FILE} does not exist"
        fi
        if [[ -z "$VALKEY_TLS_CA_FILE" ]]; then
            if [[ -z "$VALKEY_TLS_CA_DIR" ]]; then
                print_validation_error "You must provide either a CA X.509 certificate or a CA certificates directory in order to use TLS"
            elif [[ ! -d "$VALKEY_TLS_CA_DIR" ]]; then
                print_validation_error "The CA certificates directory specified by path ${VALKEY_TLS_CA_DIR} does not exist"
            fi
        elif [[ ! -f "$VALKEY_TLS_CA_FILE" ]]; then
            print_validation_error "The CA X.509 certificate file in the specified path ${VALKEY_TLS_CA_FILE} does not exist"
        fi
        if [[ -n "$VALKEY_TLS_DH_PARAMS_FILE" ]] && [[ ! -f "$VALKEY_TLS_DH_PARAMS_FILE" ]]; then
            print_validation_error "The DH param file in the specified path ${VALKEY_TLS_DH_PARAMS_FILE} does not exist"
        fi
    fi

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Configure Valkey replication
# Globals:
#   VALKEY_BASE_DIR
# Arguments:
#   $1 - Replication mode
# Returns:
#   None
#########################
valkey_configure_replication() {
    info "Configuring replication mode"

    valkey_conf_set replica-announce-ip "${VALKEY_REPLICA_IP:-$(get_machine_ip)}"
    valkey_conf_set replica-announce-port "${VALKEY_REPLICA_PORT:-$VALKEY_PRIMARY_PORT_NUMBER}"
    # Use TLS in the replication connections
    if is_boolean_yes "$VALKEY_TLS_ENABLED"; then
        valkey_conf_set tls-replication yes
    fi
    if [[ "$VALKEY_REPLICATION_MODE" = "primary" ]]; then
        if [[ -n "$VALKEY_PASSWORD" ]]; then
            valkey_conf_set primaryauth "$VALKEY_PASSWORD"
        fi
    elif [[ "$VALKEY_REPLICATION_MODE" = "replica" ]]; then
        if [[ -n "$VALKEY_SENTINEL_HOST" ]]; then
            local -a sentinel_info_command=("valkey-cli" "-h" "${VALKEY_SENTINEL_HOST}" "-p" "${VALKEY_SENTINEL_PORT_NUMBER}")
            is_boolean_yes "$VALKEY_TLS_ENABLED" && sentinel_info_command+=("--tls" "--cert" "${VALKEY_TLS_CERT_FILE}" "--key" "${VALKEY_TLS_KEY_FILE}")
            # shellcheck disable=SC2015
            is_empty_value "$VALKEY_TLS_CA_FILE" && sentinel_info_command+=("--cacertdir" "${VALKEY_TLS_CA_DIR}") || sentinel_info_command+=("--cacert" "${VALKEY_TLS_CA_FILE}")
            sentinel_info_command+=("sentinel" "get-master-addr-by-name" "${VALKEY_SENTINEL_PRIMARY_NAME}")
            read -r -a VALKEY_SENTINEL_INFO <<< "$("${sentinel_info_command[@]}" | tr '\n' ' ')"
            VALKEY_PRIMARY_HOST=${VALKEY_SENTINEL_INFO[0]}
            VALKEY_PRIMARY_PORT_NUMBER=${VALKEY_SENTINEL_INFO[1]}
        fi
        wait-for-port --host "$VALKEY_PRIMARY_HOST" "$VALKEY_PRIMARY_PORT_NUMBER"
        [[ -n "$VALKEY_PRIMARY_PASSWORD" ]] && valkey_conf_set primaryauth "$VALKEY_PRIMARY_PASSWORD"
        valkey_conf_set "replicaof" "$VALKEY_PRIMARY_HOST $VALKEY_PRIMARY_PORT_NUMBER"
    fi
}

########################
# Disable Valkey command(s)
# Globals:
#   VALKEY_BASE_DIR
# Arguments:
#   $1 - Array of commands to disable
# Returns:
#   None
#########################
valkey_disable_unsafe_commands() {
    # The current syntax gets a comma separated list of commands, we split them
    # before passing to valkey_disable_unsafe_commands
    read -r -a disabledCommands <<< "$(tr ',' ' ' <<< "$VALKEY_DISABLE_COMMANDS")"
    debug "Disabling commands: ${disabledCommands[*]}"
    for cmd in "${disabledCommands[@]}"; do
        if grep -E -q "^\s*rename-command\s+$cmd\s+\"\"\s*$" "$VALKEY_CONF_FILE"; then
            debug "$cmd was already disabled"
            continue
        fi
        echo "rename-command $cmd \"\"" >> "$VALKEY_CONF_FILE"
    done
}

########################
# Valkey configure perissions
# Globals:
#   VALKEY_*
# Arguments:
#   None
# Returns:
#   None
#########################
valkey_configure_permissions() {
  debug "Ensuring expected directories/files exist"
  for dir in "${VALKEY_BASE_DIR}" "${VALKEY_DATA_DIR}" "${VALKEY_BASE_DIR}/tmp" "${VALKEY_LOG_DIR}"; do
      ensure_dir_exists "$dir"
      if am_i_root; then
          chown "$VALKEY_DAEMON_USER:$VALKEY_DAEMON_GROUP" "$dir"
      fi
  done
}

########################
# Valkey specific configuration to override the default one
# Globals:
#   VALKEY_*
# Arguments:
#   None
# Returns:
#   None
#########################
valkey_override_conf() {
  if [[ ! -e "${VALKEY_MOUNTED_CONF_DIR}/valkey.conf" ]]; then
      # Configure Replication mode
      if [[ -n "$VALKEY_REPLICATION_MODE" ]]; then
          valkey_configure_replication
      fi
  fi
}

########################
# Ensure Valkey is initialized
# Globals:
#   VALKEY_*
# Arguments:
#   None
# Returns:
#   None
#########################
valkey_initialize() {
  valkey_configure_default
  valkey_override_conf
}

#########################
# Append include directives to valkey.conf
# Globals:
#   VALKEY_*
# Arguments:
#   None
# Returns:
#   None
#########################
valkey_append_include_conf() {
    if [[ -f "$VALKEY_OVERRIDES_FILE" ]]; then
        # Remove all include statements including commented ones
        valkey_conf_set include "$VALKEY_OVERRIDES_FILE"
        valkey_conf_unset "include"
        echo "include $VALKEY_OVERRIDES_FILE" >> "${VALKEY_BASE_DIR}/etc/valkey.conf"
    fi
}

########################
# Configures Valkey permissions and general parameters (also used in valkey-cluster container)
# Globals:
#   VALKEY_*
# Arguments:
#   None
# Returns:
#   None
#########################
valkey_configure_default() {
    info "Initializing Valkey"

    # This fixes an issue where the trap would kill the entrypoint.sh, if a PID was left over from a previous run
    # Exec replaces the process without creating a new one, and when the container is restarted it may have the same PID
    rm -f "$VALKEY_BASE_DIR/tmp/valkey.pid"

    valkey_configure_permissions

    # User injected custom configuration
    if [[ -e "${VALKEY_MOUNTED_CONF_DIR}/valkey.conf" ]]; then
        if [[ -e "$VALKEY_BASE_DIR/etc/valkey-default.conf" ]]; then
            rm "${VALKEY_BASE_DIR}/etc/valkey-default.conf"
        fi
        cp "${VALKEY_MOUNTED_CONF_DIR}/valkey.conf" "${VALKEY_BASE_DIR}/etc/valkey.conf"
    else
        info "Setting Valkey config file"
        if is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
            # Allow remote connections without password
            valkey_conf_set protected-mode no
        fi
        is_boolean_yes "$VALKEY_ALLOW_REMOTE_CONNECTIONS" && valkey_conf_set bind "0.0.0.0 ::" # Allow remote connections
        # Enable AOF https://valkey.io/topics/persistence#append-only-file
        # Leave default fsync (every second)
        valkey_conf_set appendonly "${VALKEY_AOF_ENABLED}"

        #The value stored in $i here is the number of seconds and times of save rules in valkey rdb mode
        if is_empty_value "$VALKEY_RDB_POLICY"; then
            if is_boolean_yes "$VALKEY_RDB_POLICY_DISABLED"; then
                valkey_conf_set save ""
            fi
        else
            for i in ${VALKEY_RDB_POLICY}; do
                valkey_conf_set save "${i//#/ }"
            done
        fi

        valkey_conf_set port "$VALKEY_PORT_NUMBER"
        # TLS configuration
        if is_boolean_yes "$VALKEY_TLS_ENABLED"; then
            if [[ "$VALKEY_PORT_NUMBER" ==  "6379" ]] && [[ "$VALKEY_TLS_PORT_NUMBER" ==  "6379" ]]; then
                # If both ports are set to default values, enable TLS traffic only
                valkey_conf_set port 0
                valkey_conf_set tls-port "$VALKEY_TLS_PORT_NUMBER"
            else
                # Different ports were specified
                valkey_conf_set tls-port "$VALKEY_TLS_PORT_NUMBER"
            fi
            valkey_conf_set tls-cert-file "$VALKEY_TLS_CERT_FILE"
            valkey_conf_set tls-key-file "$VALKEY_TLS_KEY_FILE"
            # shellcheck disable=SC2015
            is_empty_value "$VALKEY_TLS_CA_FILE" && valkey_conf_set tls-ca-cert-dir "$VALKEY_TLS_CA_DIR" || valkey_conf_set tls-ca-cert-file "$VALKEY_TLS_CA_FILE"
            ! is_empty_value "$VALKEY_TLS_KEY_FILE_PASS" && valkey_conf_set tls-key-file-pass "$VALKEY_TLS_KEY_FILE_PASS"
            [[ -n "$VALKEY_TLS_DH_PARAMS_FILE" ]] && valkey_conf_set tls-dh-params-file "$VALKEY_TLS_DH_PARAMS_FILE"
            valkey_conf_set tls-auth-clients "$VALKEY_TLS_AUTH_CLIENTS"
        fi
        # Multithreading configuration
        ! is_empty_value "$VALKEY_IO_THREADS_DO_READS" && valkey_conf_set "io-threads-do-reads" "$VALKEY_IO_THREADS_DO_READS"
        ! is_empty_value "$VALKEY_IO_THREADS" && valkey_conf_set "io-threads" "$VALKEY_IO_THREADS"

        if [[ -n "$VALKEY_PASSWORD" ]]; then
            valkey_conf_set requirepass "$VALKEY_PASSWORD"
        else
            valkey_conf_unset requirepass
        fi
        if [[ -n "$VALKEY_DISABLE_COMMANDS" ]]; then
            valkey_disable_unsafe_commands
        fi
        if [[ -n "$VALKEY_ACLFILE" ]]; then
            valkey_conf_set aclfile "$VALKEY_ACLFILE"
        fi
        valkey_append_include_conf
    fi
}
