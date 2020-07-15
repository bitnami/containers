#!/bin/bash
#
# Bitnami RabbitMQ library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh

# Functions

########################
# Load global variables used on RabbitMQ configuration.
# Globals:
#   RABBITMQ_*
# Arguments:
#   None
# Returns:
#   Series of exports to be used as 'eval' arguments
#########################
rabbitmq_env() {
    cat <<"EOF"
# Paths
export RABBITMQ_VOLUME_DIR="/bitnami/rabbitmq"
export RABBITMQ_BASE_DIR="/opt/bitnami/rabbitmq"
export RABBITMQ_BIN_DIR="${RABBITMQ_BASE_DIR}/sbin"
export RABBITMQ_DATA_DIR="${RABBITMQ_VOLUME_DIR}/mnesia"
export RABBITMQ_CONF_DIR="${RABBITMQ_BASE_DIR}/etc/rabbitmq"
export RABBITMQ_CONF_FILE="${RABBITMQ_CONF_DIR}/rabbitmq.conf"
export RABBITMQ_CONF_ENV_FILE="${RABBITMQ_CONF_DIR}/rabbitmq-env.conf"
export RABBITMQ_HOME_DIR="${RABBITMQ_BASE_DIR}/.rabbitmq"
export RABBITMQ_LIB_DIR="${RABBITMQ_BASE_DIR}/var/lib/rabbitmq"
export RABBITMQ_LOG_DIR="${RABBITMQ_BASE_DIR}/var/log/rabbitmq"
export RABBITMQ_PLUGINS_DIR="${RABBITMQ_BASE_DIR}/plugins"
export RABBITMQ_MOUNTED_CONF_DIR="${RABBITMQ_MOUNTED_CONF_DIR:-${RABBITMQ_VOLUME_DIR}/conf}"
export PATH="${RABBITMQ_BIN_DIR}:${PATH}"

# OS
export RABBITMQ_DAEMON_USER="rabbitmq"
export RABBITMQ_DAEMON_GROUP="rabbitmq"

# RabbitMQ locations
export RABBITMQ_MNESIA_BASE="${RABBITMQ_DATA_DIR}"

# Settings
export RABBITMQ_CLUSTER_NODE_NAME="${RABBITMQ_CLUSTER_NODE_NAME:-}"
export RABBITMQ_CLUSTER_PARTITION_HANDLING="${RABBITMQ_CLUSTER_PARTITION_HANDLING:-ignore}"
export RABBITMQ_DISK_FREE_RELATIVE_LIMIT="${RABBITMQ_DISK_FREE_RELATIVE_LIMIT:-1.0}"
export RABBITMQ_DISK_FREE_ABSOLUTE_LIMIT="${RABBITMQ_DISK_FREE_ABSOLUTE_LIMIT:-}"
export RABBITMQ_ERL_COOKIE="${RABBITMQ_ERL_COOKIE:-}"
export RABBITMQ_HASHED_PASSWORD="${RABBITMQ_HASHED_PASSWORD:-}"
export RABBITMQ_MANAGER_BIND_IP="${RABBITMQ_MANAGER_BIND_IP:-0.0.0.0}"
export RABBITMQ_MANAGER_PORT_NUMBER="${RABBITMQ_MANAGER_PORT_NUMBER:-15672}"
export RABBITMQ_NODE_NAME="${RABBITMQ_NODE_NAME:-rabbit@localhost}"
export RABBITMQ_NODE_PORT_NUMBER="${RABBITMQ_NODE_PORT_NUMBER:-5672}"
export RABBITMQ_NODE_TYPE="${RABBITMQ_NODE_TYPE:-stats}"
export RABBITMQ_PASSWORD="${RABBITMQ_PASSWORD:-bitnami}"
export RABBITMQ_USERNAME="${RABBITMQ_USERNAME:-user}"
export RABBITMQ_VHOST="${RABBITMQ_VHOST:-/}"
# Force boot cluster
export RABBITMQ_FORCE_BOOT="${RABBITMQ_FORCE_BOOT:-no}"
# Print all log messages to standard output
export RABBITMQ_LOGS="${RABBITMQ_LOGS:--}"
# LDAP
export RABBITMQ_ENABLE_LDAP="${RABBITMQ_ENABLE_LDAP:-no}"
export RABBITMQ_LDAP_TLS="${RABBITMQ_LDAP_TLS:-no}"
export RABBITMQ_LDAP_SERVERS="${RABBITMQ_LDAP_SERVERS:-}"
export RABBITMQ_LDAP_SERVERS_PORT="${RABBITMQ_LDAP_SERVERS_PORT:-389}"
export RABBITMQ_LDAP_USER_DN_PATTERN="${RABBITMQ_LDAP_USER_DN_PATTERN:-}"
EOF
}

########################
# Validate settings in RABBITMQ_* environment variables
# Globals:
#   RABBITMQ_*
# Arguments:
#   None
# Returns:
#   None
#########################
rabbitmq_validate() {
    info "Validating settings in RABBITMQ_* env vars.."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    if [[ -z "$RABBITMQ_PASSWORD" && -z "$RABBITMQ_HASHED_PASSWORD" ]]; then
        print_validation_error "You must indicate a password or a hashed password."
    fi

    if [[ -n "$RABBITMQ_PASSWORD" && -n "$RABBITMQ_HASHED_PASSWORD" ]]; then
        warn "You initialized RabbitMQ indicating both a password and a hashed password. Please note only the hashed password will be considered."
    fi

    if ! is_yes_no_value "$RABBITMQ_ENABLE_LDAP"; then
        print_validation_error "An invalid value was specified in the environment variable RABBITMQ_ENABLE_LDAP. Valid values are: yes or no"
    fi

    if is_boolean_yes "$RABBITMQ_ENABLE_LDAP" && ( [[ -z "${RABBITMQ_LDAP_SERVERS}" ]] || [[ -z "${RABBITMQ_LDAP_USER_DN_PATTERN}" ]] ); then
        print_validation_error "The LDAP configuration is required when LDAP authentication is enabled. Set the environment variables RABBITMQ_LDAP_SERVERS and RABBITMQ_LDAP_USER_DN_PATTERN."
        if !  is_yes_no_value "$RABBITMQ_LDAP_TLS"; then
            print_validation_error "An invalid value was specified in the environment variable RABBITMQ_LDAP_TLS. Valid values are: yes or no"
        fi
    fi

    if [[ "$RABBITMQ_NODE_TYPE" = "stats" ]]; then
        if ! validate_ipv4 "$RABBITMQ_MANAGER_BIND_IP"; then
            print_validation_error "An invalid IP was specified in the environment variable RABBITMQ_MANAGER_BIND_IP."
        fi

        local validate_port_args=()
        ! am_i_root && validate_port_args+=("-unprivileged")
        if ! err=$(validate_port "${validate_port_args[@]}" "$RABBITMQ_MANAGER_PORT_NUMBER"); then
            print_validation_error "An invalid port was specified in the environment variable RABBITMQ_MANAGER_PORT_NUMBER: ${err}."
        fi

        if [[ -n "$RABBITMQ_CLUSTER_NODE_NAME" ]]; then
            warn "This node will not be clustered. Use type queue-* instead."
        fi
    elif [[ "$RABBITMQ_NODE_TYPE" = "queue-disc" ]] || [[ "$RABBITMQ_NODE_TYPE" = "queue-ram" ]]; then
        if [[ -z "$RABBITMQ_CLUSTER_NODE_NAME" ]]; then
            warn "You did not define any node to cluster with."
        fi
    else
        print_validation_error "${RABBITMQ_NODE_TYPE} is not a valid type. You can use 'stats', 'queue-disc' or 'queue-ram'."
    fi

    [[ "$error_code" -eq 0 ]] || return "$error_code"
}

########################
# Creates RabbitMQ configuration file
# Globals:
#   RABBITMQ_CONF_FILE
# Arguments:
#   None
# Returns:
#   None
#########################
rabbitmq_create_config_file() {
    debug "Creating configuration file..."

    cat > "$RABBITMQ_CONF_FILE" <<EOF
## Networking
listeners.tcp.default = $RABBITMQ_NODE_PORT_NUMBER

## On first start RabbitMQ will create a vhost and a user. These
## config items control what gets created
default_vhost = $RABBITMQ_VHOST
default_user = $RABBITMQ_USERNAME
default_permissions.configure = .*
default_permissions.read = .*
default_permissions.write = .*

## Clustering
cluster_partition_handling = $RABBITMQ_CLUSTER_PARTITION_HANDLING
EOF

    if [[ -n "$RABBITMQ_DISK_FREE_ABSOLUTE_LIMIT" ]]; then
        cat >> "$RABBITMQ_CONF_FILE" <<EOF
## Set an absolute disk free space limit
disk_free_limit.absolute = $RABBITMQ_DISK_FREE_ABSOLUTE_LIMIT
EOF
    else
        cat >> "$RABBITMQ_CONF_FILE" <<EOF
## Set a limit relative to total available RAM
disk_free_limit.relative = $RABBITMQ_DISK_FREE_RELATIVE_LIMIT
EOF
    fi

    if is_boolean_yes "$RABBITMQ_ENABLE_LDAP"; then
        cat >> "$RABBITMQ_CONF_FILE" <<EOF
## Select an authentication/authorisation backend to use
auth_backends.1 = rabbit_auth_backend_ldap
auth_backends.2 = internal

## Connecting to the LDAP server(s)
EOF
        read -r -a ldap_servers <<< "$(tr ',;' ' ' <<< "$RABBITMQ_LDAP_SERVERS")"
        local index=1
        for server in "${ldap_servers[@]}"; do
            cat >> "$RABBITMQ_CONF_FILE" <<EOF
auth_ldap.servers.${index} = $server
EOF
            index=$((index + 1 ))
        done
        cat >> "$RABBITMQ_CONF_FILE" <<EOF
auth_ldap.port = $RABBITMQ_LDAP_SERVERS_PORT
auth_ldap.user_dn_pattern = $RABBITMQ_LDAP_USER_DN_PATTERN

EOF

        if is_boolean_yes "$RABBITMQ_LDAP_TLS"; then
            cat >> "$RABBITMQ_CONF_FILE" <<EOF
auth_ldap.use_ssl = true

EOF
        fi
    fi

    cat >> "$RABBITMQ_CONF_FILE" <<EOF
## Management
management.tcp.port = $RABBITMQ_MANAGER_PORT_NUMBER
management.tcp.ip = $RABBITMQ_MANAGER_BIND_IP
EOF
}

########################
# Add or modify an entry in the RabbitMQ configuration file
# Globals:
#   RABBITMQ_CONF_FILE
# Arguments:
#   $1 - key
#   $2 - values (array)
# Returns:
#   None
#########################
rabbitmq_conf_set() {
    local -r key="${1:?missing key}"
    shift
    local -r -a values=("$@")

    if [[ "${#values[@]}" -eq 0 ]]; then
        stderr_print "missing value"
        return 1
    elif [[ "${#values[@]}" -ne 1 ]]; then
        for i in "${!values[@]}"; do
            rabbitmq_conf_set "${key[$i]}" "${values[$i]}"
        done
    else
        value="${values[0]}"
        debug "Setting ${key} to '${value}' in $RABBITMQ_CONF_FILE ..."
        # Check if the value was set before
        if grep -q "^[# ]*$key\s*=.*" "$RABBITMQ_CONF_FILE"; then
            # Update the existing key
            replace_in_file "$RABBITMQ_CONF_FILE" "^[# ]*${key}\s*=.*" "${key} = ${value}" false
        else
            # Add a new key
            printf '\n%s = %s' "$key" "$value" >> "$RABBITMQ_CONF_FILE"
        fi
    fi
}

########################
# Creates RabbitMQ environment file
# Globals:
#   RABBITMQ_CONF_ENV_FILE
# Arguments:
#   None
# Returns:
#   None
#########################
rabbitmq_create_environment_file() {
    debug "Creating environment file..."
    cat > "$RABBITMQ_CONF_ENV_FILE" <<EOF
HOME=$RABBITMQ_HOME_DIR
NODE_PORT=$RABBITMQ_NODE_PORT_NUMBER
NODENAME=$RABBITMQ_NODE_NAME
EOF
}

########################
# Download RabbitMQ custom plugins
# Globals:
#   RABBITMQ_*
# Arguments:
#   None
# Returns:
#   None
#########################
rabbitmq_download_community_plugins() {
    debug "Downloading custom plugins..."
    read -r -a plugins <<< "$(tr ',;' ' ' <<< "$RABBITMQ_COMMUNITY_PLUGINS")"
    cd "$RABBITMQ_PLUGINS_DIR" || return
    for plugin in "${plugins[@]}"; do
        curl --remote-name --location --silent "$plugin"
    done
    cd - || return
}

########################
# Creates RabbitMQ plugins file
# Globals:
#   RABBITMQ_*
# Arguments:
#   None
# Returns:
#   None
#########################
rabbitmq_create_enabled_plugins_file() {
    debug "Creating enabled_plugins file..."
    local plugins="rabbitmq_management_agent"

    if [[ -n "${RABBITMQ_PLUGINS:-}" ]]; then
        plugins="$RABBITMQ_PLUGINS"
    else
        if [[ "$RABBITMQ_NODE_TYPE" = "stats" ]]; then
            plugins="rabbitmq_management"
        fi
        is_boolean_yes "$RABBITMQ_ENABLE_LDAP" && plugins="${plugins}, rabbitmq_auth_backend_ldap"
    fi
    cat > "${RABBITMQ_CONF_DIR}/enabled_plugins" <<EOF
[${plugins}].
EOF
}

########################
# Creates RabbitMQ Erlang cookie
# Globals:
#   RABBITMQ_ERL_COOKIE
#   RABBITMQ_HOME_DIR
#   RABBITMQ_LIB_DIR
# Arguments:
#   None
# Returns:
#   None
#########################
rabbitmq_create_erlang_cookie() {
    debug "Creating Erlang cookie..."
    if [[ -z $RABBITMQ_ERL_COOKIE ]]; then
        info "Generating random cookie"
        RABBITMQ_ERL_COOKIE=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c32)
    fi

    echo "$RABBITMQ_ERL_COOKIE" > "${RABBITMQ_HOME_DIR}/.erlang.cookie"
}

########################
# Checks if RabbitMQ is running
# Globals:
#   RABBITMQ_PID
#   RABBITMQ_BIN_DIR
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_rabbitmq_running() {
    if [[ -z "${RABBITMQ_PID:-}" ]]; then
        false
    else
        is_service_running "$RABBITMQ_PID"
    fi
}

########################
# Checks if a RabbitMQ node is running
# Globals:
#   RABBITMQ_BIN_DIR
# Arguments:
#   $1 - Node to check
# Returns:
#   Boolean
#########################
node_is_running() {
    local node="${1:?node is required}"
    info "Checking node ${node}"
    if debug_execute "${RABBITMQ_BIN_DIR}/rabbitmqctl" await_startup -n "$node"; then
        true
    else
        false
    fi
}

########################
# Starts RabbitMQ in background and waits until it's ready
# Globals:
#   BITNAMI_DEBUG
#   RABBITMQ_BIN_DIR
# Arguments:
#   None
# Returns:
#   None
#########################
rabbitmq_start_bg() {
    is_rabbitmq_running && return
    info "Starting RabbitMQ in background..."
    local start_command=("$RABBITMQ_BIN_DIR/rabbitmq-server")
    am_i_root && start_command=("gosu" "$RABBITMQ_DAEMON_USER" "${start_command[@]}")
    debug_execute "${start_command[@]}" &
    export RABBITMQ_PID="$!"

    if ! retry_while "debug_execute ${RABBITMQ_BIN_DIR}/rabbitmqctl wait --pid $RABBITMQ_PID --timeout 5" 10 10; then
        error "Couldn't start RabbitMQ in background."
        return 1
    fi
}

########################
# Stop RabbitMQ
# Globals:
#   BITNAMI_DEBUG
#   RABBITMQ_BIN_DIR
# Arguments:
#   None
# Returns:
#   None
#########################
rabbitmq_stop() {
    ! is_rabbitmq_running && return
    info "Stopping RabbitMQ..."

    debug_execute "${RABBITMQ_BIN_DIR}/rabbitmqctl" stop
    retry_while "is_rabbitmq_running" 10 1
    # We give two extra seconds for halting Erlang VM
    sleep 2
}

########################
# Change the password of a user
# Globals:
#   BITNAMI_DEBUG
#   RABBITMQ_BIN_DIR
# Arguments:
#   $1 - User
#   $2 - Password
# Returns:
#   None
#########################
rabbitmq_change_password() {
    local user="${1:?user is required}"
    local password="${2:?password is required}"
    debug "Changing password for user '${user}'..."

    if ! debug_execute "${RABBITMQ_BIN_DIR}/rabbitmqctl" change_password "$user" "$password"; then
        error "Couldn't change password for user '${user}'."
        return 1
    fi
}

########################
# Make a node join a cluster
# Globals:
#   BITNAMI_DEBUG
#   RABBITMQ_BIN_DIR
# Arguments:
#   $1 - Node to cluster with
#   $2 - Type of node
# Returns:
#   None
#########################
rabbitmq_join_cluster() {
    local clusternode="${1:?node is required}"
    local type="${2:?type is required}"

    local join_cluster_args=("$clusternode")
    [[ "$type" = "queue-ram" ]] && join_cluster_args+=("--ram")

    debug_execute "${RABBITMQ_BIN_DIR}/rabbitmqctl" stop_app

    local counter=0
    if ! retry_while "debug_execute ${RABBITMQ_BIN_DIR}/rabbitmq-plugins --node $clusternode is_enabled rabbitmq_management" 120 1; then
        error "Node ${clusternode} is not running."
        return 1
    fi

    info "Clustering with ${clusternode}"
    if ! debug_execute "${RABBITMQ_BIN_DIR}/rabbitmqctl" join_cluster "${join_cluster_args[@]}"; then
        error "Couldn't cluster with node '${clusternode}'."
        return 1
    fi

    debug_execute "${RABBITMQ_BIN_DIR}/rabbitmqctl" start_app
}

########################
# Ensure RabbitMQ is initialized
# Globals:
#   RABBITMQ_*
# Arguments:
#   None
# Returns:
#   None
#########################
rabbitmq_initialize() {
    info "Initializing RabbitMQ..."

    # Check for mounted configuration files
    if ! is_dir_empty "$RABBITMQ_MOUNTED_CONF_DIR"; then
        cp -Lr "$RABBITMQ_MOUNTED_CONF_DIR"/* "$RABBITMQ_CONF_DIR"
    fi
    [[ ! -f "$RABBITMQ_CONF_FILE" ]] && rabbitmq_create_config_file
    [[ ! -f "$RABBITMQ_CONF_ENV_FILE" ]] && rabbitmq_create_environment_file
    [[ ! -f "${RABBITMQ_CONF_DIR}/enabled_plugins" ]] && rabbitmq_create_enabled_plugins_file
    [[ -n "${RABBITMQ_COMMUNITY_PLUGINS:-}" ]] && rabbitmq_download_community_plugins
    # User injected custom configuration
    if [[ -f "${RABBITMQ_CONF_DIR}/custom.conf" ]]; then
        debug "Injecting custom configuration from custom.conf"
        while IFS='=' read -r custom_key custom_value || [[ -n $custom_key ]]; do
            rabbitmq_conf_set "$custom_key" "$custom_value"
        done < <(grep -E "^\w.*\s?=\s?.*" "${RABBITMQ_CONF_DIR}/custom.conf")
        # Remove custom configurafion file once the changes are applied
        rm "${RABBITMQ_CONF_DIR}/custom.conf"
    fi

    [[ ! -f "${RABBITMQ_LIB_DIR}/.start" ]] && touch "${RABBITMQ_LIB_DIR}/.start"
    [[ ! -f "${RABBITMQ_HOME_DIR}/.erlang.cookie" ]] && rabbitmq_create_erlang_cookie
    chmod 400 "${RABBITMQ_HOME_DIR}/.erlang.cookie"
    ln -sf "${RABBITMQ_HOME_DIR}/.erlang.cookie" "${RABBITMQ_LIB_DIR}/.erlang.cookie"

    # Resources limits: maximum number of open file descriptors
    [[ -n "${RABBITMQ_ULIMIT_NOFILES:-}" ]] && ulimit -n "${RABBITMQ_ULIMIT_NOFILES}"

    debug "Ensuring expected directories/files exist..."
    for dir in "$RABBITMQ_DATA_DIR" "$RABBITMQ_LIB_DIR" "$RABBITMQ_HOME_DIR"; do
        ensure_dir_exists "$dir"
        am_i_root && chown -R "$RABBITMQ_DAEMON_USER:$RABBITMQ_DAEMON_GROUP" "$dir"
    done

    if ! is_mounted_dir_empty "$RABBITMQ_DATA_DIR"; then
        info "Persisted data detected. Restoring..."
        if is_boolean_yes "$RABBITMQ_FORCE_BOOT" && ! is_dir_empty "${RABBITMQ_DATA_DIR}/${RABBITMQ_NODE_NAME}"; then
            # ref: https://www.rabbitmq.com/rabbitmqctl.8.html#force_boot
            warn "Forcing node to start..."
            debug_execute "${RABBITMQ_BIN_DIR}/rabbitmqctl" force_boot
        fi
    else
        ! is_rabbitmq_running && rabbitmq_start_bg

        rabbitmq_change_password "$RABBITMQ_USERNAME" "$RABBITMQ_PASSWORD"
        if [[ "$RABBITMQ_NODE_TYPE" != "stats" ]] && [[ -n "$RABBITMQ_CLUSTER_NODE_NAME" ]]; then
            rabbitmq_join_cluster "$RABBITMQ_CLUSTER_NODE_NAME" "$RABBITMQ_NODE_TYPE"
        fi
    fi
}
