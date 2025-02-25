#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Redis library

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
#   REDIS_BASE_DIR
# Arguments:
#   $1 - key
#   $2 - conf file
# Returns:
#   None
#########################
redis_conf_get() {
    local -r key="${1:?missing key}"
    local -r conf_file="${2:-"${REDIS_BASE_DIR}/etc/redis.conf"}"

    if grep -q -E "^\s*$key " "$conf_file"; then
        grep -E "^\s*$key " "$conf_file" | awk '{print $2}'
    fi
}

########################
# Set a configuration setting value
# Globals:
#   REDIS_BASE_DIR
# Arguments:
#   $1 - key
#   $2 - value
# Returns:
#   None
#########################
redis_conf_set() {
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
        echo "${key} ${value}" >> "${REDIS_BASE_DIR}/etc/redis.conf"
    else
        replace_in_file "${REDIS_BASE_DIR}/etc/redis.conf" "^#*\s*${key} .*" "${key} ${value}" false
    fi
}

########################
# Unset a configuration setting value
# Globals:
#   REDIS_BASE_DIR
# Arguments:
#   $1 - key
# Returns:
#   None
#########################
redis_conf_unset() {
    local -r key="${1:?missing key}"
    remove_in_file "${REDIS_BASE_DIR}/etc/redis.conf" "^\s*$key .*" false
}

########################
# Get Redis version
# Globals:
#   REDIS_BASE_DIR
# Arguments:
#   None
# Returns:
#   Redis versoon
#########################
redis_version() {
    "${REDIS_BASE_DIR}/bin/redis-cli" --version | grep -E -o "[0-9]+.[0-9]+.[0-9]+"
}

########################
# Get Redis major version
# Globals:
#   REDIS_BASE_DIR
# Arguments:
#   None
# Returns:
#   Redis major version
#########################
redis_major_version() {
    redis_version | grep -E -o "^[0-9]+"
}

########################
# Check if redis is running
# Globals:
#   REDIS_BASE_DIR
# Arguments:
#   $1 - pid file
# Returns:
#   Boolean
#########################
is_redis_running() {
    local pid_file="${1:-"${REDIS_BASE_DIR}/tmp/redis.pid"}"
    local pid
    pid="$(get_pid_from_file "$pid_file")"

    if [[ -z "$pid" ]]; then
        false
    else
        is_service_running "$pid"
    fi
}

########################
# Check if redis is not running
# Globals:
#   REDIS_BASE_DIR
# Arguments:
#   $1 - pid file
# Returns:
#   Boolean
#########################
is_redis_not_running() {
    ! is_redis_running "$@"
}

########################
# Stop Redis
# Globals:
#   REDIS_*
# Arguments:
#   None
# Returns:
#   None
#########################
redis_stop() {
    local pass
    local port
    local args

    ! is_redis_running && return
    pass="$(redis_conf_get "requirepass")"
    is_boolean_yes "$REDIS_TLS_ENABLED" && port="$(redis_conf_get "tls-port")" || port="$(redis_conf_get "port")"

    [[ -n "$pass" ]] && args+=("-a" "$pass")
    [[ "$port" != "0" ]] && args+=("-p" "$port")

    debug "Stopping Redis"
    if am_i_root; then
        run_as_user "$REDIS_DAEMON_USER" "${REDIS_BASE_DIR}/bin/redis-cli" "${args[@]}" shutdown
    else
        "${REDIS_BASE_DIR}/bin/redis-cli" "${args[@]}" shutdown
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

    empty_password_enabled_warn() {
        warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD}. For safety reasons, do not use this flag in a production environment."
    }
    empty_password_error() {
        print_validation_error "The $1 environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow the container to be started with blank passwords. This is recommended only for development."
    }

    if is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
        empty_password_enabled_warn
    else
        [[ -z "$REDIS_PASSWORD" ]] && empty_password_error REDIS_PASSWORD
    fi
    if [[ -n "$REDIS_REPLICATION_MODE" ]]; then
        if [[ "$REDIS_REPLICATION_MODE" =~ ^(slave|replica)$ ]]; then
            if [[ -n "$REDIS_MASTER_PORT_NUMBER" ]]; then
                if ! err=$(validate_port "$REDIS_MASTER_PORT_NUMBER"); then
                    print_validation_error "An invalid port was specified in the environment variable REDIS_MASTER_PORT_NUMBER: $err"
                fi
            fi
            if ! is_boolean_yes "$ALLOW_EMPTY_PASSWORD" && [[ -z "$REDIS_MASTER_PASSWORD" ]]; then
                empty_password_error REDIS_MASTER_PASSWORD
            fi
        elif [[ "$REDIS_REPLICATION_MODE" != "master" ]]; then
            print_validation_error "Invalid replication mode. Available options are 'master/replica'"
        fi
    fi
    if is_boolean_yes "$REDIS_TLS_ENABLED"; then
        if [[ "$REDIS_PORT_NUMBER" == "$REDIS_TLS_PORT_NUMBER" ]] && [[ "$REDIS_PORT_NUMBER" != "6379" ]]; then
            # If both ports are assigned the same numbers and they are different to the default settings
            print_validation_error "Environment variables REDIS_PORT_NUMBER and REDIS_TLS_PORT_NUMBER point to the same port number (${REDIS_PORT_NUMBER}). Change one of them or disable non-TLS traffic by setting REDIS_PORT_NUMBER=0"
        fi
        if [[ -z "$REDIS_TLS_CERT_FILE" ]]; then
            print_validation_error "You must provide a X.509 certificate in order to use TLS"
        elif [[ ! -f "$REDIS_TLS_CERT_FILE" ]]; then
            print_validation_error "The X.509 certificate file in the specified path ${REDIS_TLS_CERT_FILE} does not exist"
        fi
        if [[ -z "$REDIS_TLS_KEY_FILE" ]]; then
            print_validation_error "You must provide a private key in order to use TLS"
        elif [[ ! -f "$REDIS_TLS_KEY_FILE" ]]; then
            print_validation_error "The private key file in the specified path ${REDIS_TLS_KEY_FILE} does not exist"
        fi
        if [[ -z "$REDIS_TLS_CA_FILE" ]]; then
            if [[ -z "$REDIS_TLS_CA_DIR" ]]; then
                print_validation_error "You must provide either a CA X.509 certificate or a CA certificates directory in order to use TLS"
            elif [[ ! -d "$REDIS_TLS_CA_DIR" ]]; then
                print_validation_error "The CA certificates directory specified by path ${REDIS_TLS_CA_DIR} does not exist"
            fi
        elif [[ ! -f "$REDIS_TLS_CA_FILE" ]]; then
            print_validation_error "The CA X.509 certificate file in the specified path ${REDIS_TLS_CA_FILE} does not exist"
        fi
        if [[ -n "$REDIS_TLS_DH_PARAMS_FILE" ]] && [[ ! -f "$REDIS_TLS_DH_PARAMS_FILE" ]]; then
            print_validation_error "The DH param file in the specified path ${REDIS_TLS_DH_PARAMS_FILE} does not exist"
        fi
    fi

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Configure Redis replication
# Globals:
#   REDIS_BASE_DIR
# Arguments:
#   $1 - Replication mode
# Returns:
#   None
#########################
redis_configure_replication() {
    info "Configuring replication mode"

    redis_conf_set replica-announce-ip "${REDIS_REPLICA_IP:-$(get_machine_ip)}"
    redis_conf_set replica-announce-port "${REDIS_REPLICA_PORT:-$REDIS_MASTER_PORT_NUMBER}"
    # Use TLS in the replication connections
    if is_boolean_yes "$REDIS_TLS_ENABLED"; then
        redis_conf_set tls-replication yes
    fi
    if [[ "$REDIS_REPLICATION_MODE" = "master" ]]; then
        if [[ -n "$REDIS_PASSWORD" ]]; then
            redis_conf_set masterauth "$REDIS_PASSWORD"
        fi
    elif [[ "$REDIS_REPLICATION_MODE" =~ ^(slave|replica)$ ]]; then
        if [[ -n "$REDIS_SENTINEL_HOST" ]]; then
            local -a sentinel_info_command=("redis-cli" "-h" "${REDIS_SENTINEL_HOST}" "-p" "${REDIS_SENTINEL_PORT_NUMBER}")
            is_boolean_yes "$REDIS_TLS_ENABLED" && sentinel_info_command+=("--tls" "--cert" "${REDIS_TLS_CERT_FILE}" "--key" "${REDIS_TLS_KEY_FILE}")
            # shellcheck disable=SC2015
            is_empty_value "$REDIS_TLS_CA_FILE" && sentinel_info_command+=("--cacertdir" "${REDIS_TLS_CA_DIR}") || sentinel_info_command+=("--cacert" "${REDIS_TLS_CA_FILE}")
            sentinel_info_command+=("sentinel" "get-master-addr-by-name" "${REDIS_SENTINEL_MASTER_NAME}")
            read -r -a REDIS_SENTINEL_INFO <<< "$("${sentinel_info_command[@]}" | tr '\n' ' ')"
            REDIS_MASTER_HOST=${REDIS_SENTINEL_INFO[0]}
            REDIS_MASTER_PORT_NUMBER=${REDIS_SENTINEL_INFO[1]}
        fi
        wait-for-port --host "$REDIS_MASTER_HOST" "$REDIS_MASTER_PORT_NUMBER"
        [[ -n "$REDIS_MASTER_PASSWORD" ]] && redis_conf_set masterauth "$REDIS_MASTER_PASSWORD"
        # Starting with Redis 5, use 'replicaof' instead of 'slaveof'. Maintaining both for backward compatibility
        local parameter="replicaof"
        [[ $(redis_major_version) -lt 5 ]] && parameter="slaveof"
        redis_conf_set "$parameter" "$REDIS_MASTER_HOST $REDIS_MASTER_PORT_NUMBER"
    fi
}

########################
# Disable Redis command(s)
# Globals:
#   REDIS_BASE_DIR
# Arguments:
#   $1 - Array of commands to disable
# Returns:
#   None
#########################
redis_disable_unsafe_commands() {
    # The current syntax gets a comma separated list of commands, we split them
    # before passing to redis_disable_unsafe_commands
    read -r -a disabledCommands <<< "$(tr ',' ' ' <<< "$REDIS_DISABLE_COMMANDS")"
    debug "Disabling commands: ${disabledCommands[*]}"
    for cmd in "${disabledCommands[@]}"; do
        if grep -E -q "^\s*rename-command\s+$cmd\s+\"\"\s*$" "$REDIS_CONF_FILE"; then
            debug "$cmd was already disabled"
            continue
        fi
        echo "rename-command $cmd \"\"" >> "$REDIS_CONF_FILE"
    done
}

########################
# Redis configure perissions
# Globals:
#   REDIS_*
# Arguments:
#   None
# Returns:
#   None
#########################
redis_configure_permissions() {
  debug "Ensuring expected directories/files exist"
  for dir in "${REDIS_BASE_DIR}" "${REDIS_DATA_DIR}" "${REDIS_BASE_DIR}/tmp" "${REDIS_LOG_DIR}"; do
      ensure_dir_exists "$dir"
      if am_i_root; then
          chown "$REDIS_DAEMON_USER:$REDIS_DAEMON_GROUP" "$dir"
      fi
  done
}

########################
# Redis specific configuration to override the default one
# Globals:
#   REDIS_*
# Arguments:
#   None
# Returns:
#   None
#########################
redis_override_conf() {
  if [[ ! -e "${REDIS_MOUNTED_CONF_DIR}/redis.conf" ]]; then
      # Configure Replication mode
      if [[ -n "$REDIS_REPLICATION_MODE" ]]; then
          redis_configure_replication
      fi
  fi
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
  redis_configure_default
  redis_override_conf
}

#########################
# Append include directives to redis.conf
# Globals:
#   REDIS_*
# Arguments:
#   None
# Returns:
#   None
#########################
redis_append_include_conf() {
    if [[ -f "$REDIS_OVERRIDES_FILE" ]]; then
        # Remove all include statements including commented ones
        redis_conf_set include "$REDIS_OVERRIDES_FILE"
        redis_conf_unset "include"
        echo "include $REDIS_OVERRIDES_FILE" >> "${REDIS_BASE_DIR}/etc/redis.conf"
    fi
}

########################
# Configures Redis permissions and general parameters (also used in redis-cluster container)
# Globals:
#   REDIS_*
# Arguments:
#   None
# Returns:
#   None
#########################
redis_configure_default() {
    info "Initializing Redis"

    # This fixes an issue where the trap would kill the entrypoint.sh, if a PID was left over from a previous run
    # Exec replaces the process without creating a new one, and when the container is restarted it may have the same PID
    rm -f "$REDIS_BASE_DIR/tmp/redis.pid"

    redis_configure_permissions

    # User injected custom configuration
    if [[ -e "${REDIS_MOUNTED_CONF_DIR}/redis.conf" ]]; then
        if [[ -e "$REDIS_BASE_DIR/etc/redis-default.conf" ]]; then
            rm "${REDIS_BASE_DIR}/etc/redis-default.conf"
        fi
        cp "${REDIS_MOUNTED_CONF_DIR}/redis.conf" "${REDIS_BASE_DIR}/etc/redis.conf"
    else
        info "Setting Redis config file"
        if is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
            # Allow remote connections without password
            redis_conf_set protected-mode no
        fi
        is_boolean_yes "$REDIS_ALLOW_REMOTE_CONNECTIONS" && redis_conf_set bind "0.0.0.0 ::" # Allow remote connections
        # Enable AOF https://redis.io/topics/persistence#append-only-file
        # Leave default fsync (every second)
        redis_conf_set appendonly "${REDIS_AOF_ENABLED}"

        #The value stored in $i here is the number of seconds and times of save rules in redis rdb mode
        if is_empty_value "$REDIS_RDB_POLICY"; then
            if is_boolean_yes "$REDIS_RDB_POLICY_DISABLED"; then
                redis_conf_set save ""
            fi
        else
            for i in ${REDIS_RDB_POLICY}; do
                redis_conf_set save "${i//#/ }"
            done
        fi

        redis_conf_set port "$REDIS_PORT_NUMBER"
        # TLS configuration
        if is_boolean_yes "$REDIS_TLS_ENABLED"; then
            if [[ "$REDIS_PORT_NUMBER" ==  "6379" ]] && [[ "$REDIS_TLS_PORT_NUMBER" ==  "6379" ]]; then
                # If both ports are set to default values, enable TLS traffic only
                redis_conf_set port 0
                redis_conf_set tls-port "$REDIS_TLS_PORT_NUMBER"
            else
                # Different ports were specified
                redis_conf_set tls-port "$REDIS_TLS_PORT_NUMBER"
            fi
            redis_conf_set tls-cert-file "$REDIS_TLS_CERT_FILE"
            redis_conf_set tls-key-file "$REDIS_TLS_KEY_FILE"
            # shellcheck disable=SC2015
            is_empty_value "$REDIS_TLS_CA_FILE" && redis_conf_set tls-ca-cert-dir "$REDIS_TLS_CA_DIR" || redis_conf_set tls-ca-cert-file "$REDIS_TLS_CA_FILE"
            ! is_empty_value "$REDIS_TLS_KEY_FILE_PASS" && redis_conf_set tls-key-file-pass "$REDIS_TLS_KEY_FILE_PASS"
            [[ -n "$REDIS_TLS_DH_PARAMS_FILE" ]] && redis_conf_set tls-dh-params-file "$REDIS_TLS_DH_PARAMS_FILE"
            redis_conf_set tls-auth-clients "$REDIS_TLS_AUTH_CLIENTS"
        fi
        # Multithreading configuration
        ! is_empty_value "$REDIS_IO_THREADS_DO_READS" && redis_conf_set "io-threads-do-reads" "$REDIS_IO_THREADS_DO_READS"
        ! is_empty_value "$REDIS_IO_THREADS" && redis_conf_set "io-threads" "$REDIS_IO_THREADS"

        if [[ -n "$REDIS_PASSWORD" ]]; then
            redis_conf_set requirepass "$REDIS_PASSWORD"
        else
            redis_conf_unset requirepass
        fi
        if [[ -n "$REDIS_DISABLE_COMMANDS" ]]; then
            redis_disable_unsafe_commands
        fi
        if [[ -n "$REDIS_ACLFILE" ]]; then
            redis_conf_set aclfile "$REDIS_ACLFILE"
        fi
        redis_append_include_conf
    fi
}
