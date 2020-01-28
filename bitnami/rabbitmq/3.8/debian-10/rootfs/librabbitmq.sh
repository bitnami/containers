#!/bin/bash
#
# Bitnami RabbitMQ library

# shellcheck disable=SC1090
# shellcheck disable=SC1091

# Load Generic Libraries
. /libfile.sh
. /libfs.sh
. /liblog.sh
. /libos.sh
. /libservice.sh
. /libvalidations.sh

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
export RABBITMQ_CONF_DIR="${RABBITMQ_BASE_DIR}/etc/rabbitmq"
export RABBITMQ_DATA_DIR="${RABBITMQ_VOLUME_DIR}/mnesia"
export RABBITMQ_HOME_DIR="${RABBITMQ_BASE_DIR}/.rabbitmq"
export RABBITMQ_LIB_DIR="${RABBITMQ_BASE_DIR}/var/lib/rabbitmq"
export RABBITMQ_LOG_DIR="${RABBITMQ_BASE_DIR}/var/log/rabbitmq"
export RABBITMQ_PLUGINS_DIR="${RABBITMQ_BASE_DIR}/plugins"
export PATH="${RABBITMQ_BIN_DIR}:${PATH}"

# OS
export RABBITMQ_DAEMON_USER="rabbitmq"
export RABBITMQ_DAEMON_GROUP="rabbitmq"

# RabbitMQ locations
export RABBITMQ_MNESIA_BASE="${RABBITMQ_DATA_DIR}"

# Settings
export RABBITMQ_CLUSTER_NODE_NAME="${RABBITMQ_CLUSTER_NODE_NAME:-}"
export RABBITMQ_CLUSTER_PARTITION_HANDLING="${RABBITMQ_CLUSTER_PARTITION_HANDLING:-ignore}"
export RABBITMQ_DISK_FREE_LIMIT="${RABBITMQ_DISK_FREE_LIMIT:-{mem_relative, 1.0\}}"
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
# Print all log messages to standard output
export RABBITMQ_LOGS="${RABBITMQ_LOGS:--}"
export RABBITMQ_ENABLE_LDAP="${RABBITMQ_ENABLE_LDAP:-no}"
export RABBITMQ_LDAP_TLS="${RABBITMQ_LDAP_TLS:-no}"
export RABBITMQ_LDAP_SERVER="${RABBITMQ_LDAP_SERVER:-}"
export RABBITMQ_LDAP_SERVER_PORT="${RABBITMQ_LDAP_SERVER_PORT:-389}"
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

    if is_boolean_yes "$RABBITMQ_ENABLE_LDAP" && ( [[ -z "${RABBITMQ_LDAP_SERVER}" ]] || [[ -z "${RABBITMQ_LDAP_USER_DN_PATTERN}" ]] ); then
        print_validation_error "The LDAP configuration is required when LDAP authentication is enabled. Set the environment variables RABBITMQ_LDAP_SERVER and RABBITMQ_LDAP_USER_DN_PATTERN."
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

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Creates RabbitMQ configuration file
# Globals:
#   RABBITMQ_CONF_DIR
# Arguments:
#   None
# Returns:
#   None
#########################
rabbitmq_create_config_file() {
    debug "Creating configuration file..."
    local auth_backend=""
    local separator=""

    is_boolean_yes "$RABBITMQ_ENABLE_LDAP" && auth_backend="{auth_backends, [rabbit_auth_backend_ldap]},"
    is_boolean_yes "$RABBITMQ_LDAP_TLS" && separator=","

    cat > "${RABBITMQ_CONF_DIR}/rabbitmq.config" <<EOF
[
  {rabbit,
    [
      $auth_backend
      {tcp_listeners, [$RABBITMQ_NODE_PORT_NUMBER]},
      {disk_free_limit, $RABBITMQ_DISK_FREE_LIMIT},
      {cluster_partition_handling, $RABBITMQ_CLUSTER_PARTITION_HANDLING},
      {default_vhost, <<"$RABBITMQ_VHOST">>},
      {default_user, <<"$RABBITMQ_USERNAME">>},
      {default_permissions, [<<".*">>, <<".*">>, <<".*">>]}
EOF

    if is_boolean_yes "$RABBITMQ_ENABLE_LDAP"; then
        cat >> "${RABBITMQ_CONF_DIR}/rabbitmq.config" <<EOF
    ]
  },
  {rabbitmq_auth_backend_ldap,
    [
     {servers,               ["$RABBITMQ_LDAP_SERVER"]},
     {user_dn_pattern,       "$RABBITMQ_LDAP_USER_DN_PATTERN"},
     {port,                  $RABBITMQ_LDAP_SERVER_PORT}$separator
EOF

        if is_boolean_yes "$RABBITMQ_LDAP_TLS"; then
            cat >> "${RABBITMQ_CONF_DIR}/rabbitmq.config" <<EOF
     {use_ssl,               true}
EOF
        fi
    fi

    cat >> "${RABBITMQ_CONF_DIR}/rabbitmq.config" <<EOF
    ]
  },
  {rabbitmq_management,
    [
      {listener, [{port, $RABBITMQ_MANAGER_PORT_NUMBER}, {ip, "$RABBITMQ_MANAGER_BIND_IP"}]},
      {strict_transport_security, "max-age=0;"}
    ]
  }
].
EOF
}

########################
# Creates RabbitMQ environment file
# Globals:
#   RABBITMQ_CONF_DIR
# Arguments:
#   None
# Returns:
#   None
#########################
rabbitmq_create_environment_file() {
    debug "Creating environment file..."
    cat > "${RABBITMQ_CONF_DIR}/rabbitmq-env.conf" <<EOF
HOME=$RABBITMQ_HOME_DIR
NODE_PORT=$RABBITMQ_NODE_PORT_NUMBER
NODENAME=$RABBITMQ_NODE_NAME
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
# Enables a RabbitMQ plugin
# Globals:
#   RABBITMQ_BIN_DIR
#   BITNAMI_DEBUG
# Arguments:
#   $1 - Plugin to enable
# Returns:
#   None
#########################
rabbitmq_enable_plugin() {
    local plugin="${1:?plugin is required}"
    debug "Enabling plugin '${plugin}'..."

    if ! debug_execute "${RABBITMQ_BIN_DIR}/rabbitmq-plugins" "enable" "--offline" "$plugin"; then
        warn "Couldn't enable plugin '${plugin}'."
    fi
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
    if [[ "${BITNAMI_DEBUG:-false}" = true ]]; then
        "${RABBITMQ_BIN_DIR}/rabbitmq-server" &
    else
        "${RABBITMQ_BIN_DIR}/rabbitmq-server" >/dev/null 2>&1 &
    fi
    export RABBITMQ_PID="$!"

    local counter=0
    while ! "${RABBITMQ_BIN_DIR}/rabbitmqctl" wait --pid "$RABBITMQ_PID" --timeout 5; do
        debug "Waiting for RabbitMQ to start..."
        counter=$((counter + 1))

        if [[ $counter -eq 10 ]]; then
            error "Couldn't start RabbitMQ in background."
            exit 1
        fi
    done
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

    local counter=10
    while [[ "$counter" -ne 0 ]] && is_rabbitmq_running; do
        debug "Waiting for RabbitMQ to stop..."
        sleep 1
        counter=$((counter - 1))
    done
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
        exit 1
    fi
}

########################
# Migrate old custom configuration files
# Globals:
#   RABBITMQ_CONF_DIR
#   RABBITMQ_VOLUME_DIR
# Arguments:
#   None
# Returns:
#   None
#########################
migrate_old_configuration() {
    debug "Persisted configuration detected. Migrating any existing configuration files..."
    warn "Configuration files won't be persisted anymore!"

    cp -Lr "${RABBITMQ_VOLUME_DIR}/conf/." "$RABBITMQ_CONF_DIR"
    cp -Lr "${RABBITMQ_VOLUME_DIR}/var/lib/rabbitmq/mnesia" "$RABBITMQ_VOLUME_DIR"

    if am_i_root; then
        [[ -e "${RABBITMQ_VOLUME_DIR}/.initialized" ]] && rm "${RABBITMQ_VOLUME_DIR}/.initialized"
        rm -rf "${RABBITMQ_VOLUME_DIR}/conf" "${RABBITMQ_VOLUME_DIR:?}/var" "${RABBITMQ_VOLUME_DIR}/.rabbitmq"
    else
        warn "Old configuration migrated, please manually remove the 'conf', 'var' and '.rabbitmq' directories from the volume."
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
    while ! debug_execute "${RABBITMQ_BIN_DIR}/rabbitmq-plugins" --node "$clusternode" is_enabled rabbitmq_management; do
        debug "Waiting for ${clusternode} to be ready..."
        counter=$((counter + 1))
        sleep 1
        if [[ $counter -eq 120 ]]; then
            error "Node ${clusternode} is not running."
            exit 1
        fi
    done

    info "Clustering with ${clusternode}"
    if ! debug_execute "${RABBITMQ_BIN_DIR}/rabbitmqctl" join_cluster "${join_cluster_args[@]}"; then
        error "Couldn't cluster with node '${clusternode}'."
        exit 1
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
    local skip_setup=false

    ! is_dir_empty "$RABBITMQ_DATA_DIR" && skip_setup=true

    # Persisted configuration files from old versions
    ! is_dir_empty "$RABBITMQ_VOLUME_DIR" && [[ -d "${RABBITMQ_VOLUME_DIR}/conf" ]] && migrate_old_configuration && skip_setup=true

    [[ ! -f "${RABBITMQ_CONF_DIR}/rabbitmq.config" ]] && rabbitmq_create_config_file
    [[ ! -f "${RABBITMQ_CONF_DIR}/rabbit-env.conf" ]] && rabbitmq_create_environment_file

    [[ ! -f "${RABBITMQ_HOME_DIR}/.erlang.cookie" ]] && rabbitmq_create_erlang_cookie
    chmod 400 "${RABBITMQ_HOME_DIR}/.erlang.cookie"
    ln -sf "${RABBITMQ_HOME_DIR}/.erlang.cookie" "${RABBITMQ_LIB_DIR}/.erlang.cookie"

    debug "Ensuring expected directories/files exist..."
    for dir in "$RABBITMQ_DATA_DIR" "$RABBITMQ_LIB_DIR" "$RABBITMQ_HOME_DIR"; do
        ensure_dir_exists "$dir"
        am_i_root && chown -R "$RABBITMQ_DAEMON_USER:$RABBITMQ_DAEMON_GROUP" "$dir"
    done
    if "$skip_setup"; then
        info "Persisted data detected. Restoring..."
    else
        ! is_rabbitmq_running && rabbitmq_start_bg

        rabbitmq_change_password "$RABBITMQ_USERNAME" "$RABBITMQ_PASSWORD"

        if [[ "$RABBITMQ_NODE_TYPE" != "stats" ]] && [[ -n "$RABBITMQ_CLUSTER_NODE_NAME" ]]; then
            rabbitmq_join_cluster "$RABBITMQ_CLUSTER_NODE_NAME" "$RABBITMQ_NODE_TYPE"
        fi
    fi

    if [[ "$RABBITMQ_NODE_TYPE" = "stats" ]]; then
        rabbitmq_enable_plugin "rabbitmq_management"
    else
        rabbitmq_enable_plugin "rabbitmq_management_agent"
    fi

    if is_boolean_yes "$RABBITMQ_ENABLE_LDAP"; then
        rabbitmq_enable_plugin "rabbitmq_auth_backend_ldap"
    fi
}
