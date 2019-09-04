#!/bin/bash
#
# Bitnami ZooKeeper library

# shellcheck disable=SC1091

# Load Generic Libraries
. /liblog.sh
. /libvalidations.sh
. /libos.sh

# Functions

########################
# Load global variables used on ZooKeeper configuration
# Globals:
#   ZOO_*
# Arguments:
#   None
# Returns:
#   Series of exports to be used as 'eval' arguments
#########################
zookeeper_env() {
    cat <<"EOF"
export ZOO_BASE_DIR="/opt/bitnami/zookeeper"
export ZOO_VOLUME_DIR="/bitnami/zookeeper"
export ZOO_DATA_DIR="${ZOO_VOLUME_DIR}/data"
export ZOO_CONF_DIR="${ZOO_BASE_DIR}/conf"
export ZOO_CONF_FILE="${ZOO_CONF_DIR}/zoo.cfg"
export ZOO_LOG_DIR="${ZOO_BASE_DIR}/logs"

export ZOO_DAEMON_USER="zookeeper"
export ZOO_DAEMON_GROUP="zookeeper"

export ZOO_PORT_NUMBER="${ZOO_PORT_NUMBER:-2181}"
export ZOO_SERVER_ID="${ZOO_SERVER_ID:-1}"
export ZOO_SERVERS="${ZOO_SERVERS:-}"

export ZOO_TICK_TIME="${ZOO_TICK_TIME:-2000}"
export ZOO_INIT_LIMIT="${ZOO_INIT_LIMIT:-10}"
export ZOO_SYNC_LIMIT="${ZOO_SYNC_LIMIT:-5}"
export ZOO_MAX_CLIENT_CNXNS="${ZOO_MAX_CLIENT_CNXNS:-60}"
export ZOO_LOG_LEVEL="${ZOO_LOG_LEVEL:-INFO}"
export ZOO_4LW_COMMANDS_WHITELIST="${ZOO_4LW_COMMANDS_WHITELIST:-srvr, mntr}"
export ZOO_RECONFIG_ENABLED="${ZOO_RECONFIG_ENABLED:-no}"

export JVMFLAGS="${JVMFLAGS:-}"
export ZOO_HEAP_SIZE="${ZOO_HEAP_SIZE:-1024}"

export ALLOW_ANONYMOUS_LOGIN="${ALLOW_ANONYMOUS_LOGIN:-no}"
export ZOO_ENABLE_AUTH="${ZOO_ENABLE_AUTH:-no}"
export ZOO_CLIENT_USER="${ZOO_CLIENT_USER:-}"
export ZOO_CLIENT_PASSWORD="${ZOO_CLIENT_PASSWORD:-}"
export ZOO_SERVER_USERS="${ZOO_SERVER_USERS:-}"
export ZOO_SERVER_PASSWORDS="${ZOO_SERVER_PASSWORDS:-}"
EOF
}

########################
# Validate settings in ZOO_* env vars
# Globals:
#   ZOO_*
# Arguments:
#   None
# Returns:
#   None
#########################
zookeeper_validate() {
    debug "Validating settings in ZOO_* env vars..."

    local error_code=0

    # ZooKeeper authentication validations
    if is_boolean_yes "$ALLOW_ANONYMOUS_LOGIN"; then
        warn "You have set the environment variable ALLOW_ANONYMOUS_LOGIN=${ALLOW_ANONYMOUS_LOGIN}. For safety reasons, do not use this flag in a production environment."
    elif ! is_boolean_yes "$ZOO_ENABLE_AUTH"; then
        error "The ZOO_ENABLE_AUTH environment variable does not configure authentication. Set the environment variable ALLOW_ANONYMOUS_LOGIN=yes to allow unauthenticated users to connect to ZooKeeper. This is recommended only for development."
        (( ++error_code ))
    fi

    # ZooKeeper port validations
    local validate_port_args=()
    ! am_i_root && validate_port_args+=("-unprivileged")
    if ! err=$(validate_port "${validate_port_args[@]}" "$ZOO_PORT_NUMBER"); then
        error "An invalid port was specified in the environment variable ZOO_PORT_NUMBER: $err"
        (( ++error_code ))
    fi

    # ZooKeeper server users validations
    read -r -a server_users_list <<< "${ZOO_SERVER_USERS//[;, ]/ }"
    read -r -a server_passwords_list <<< "${ZOO_SERVER_PASSWORDS//[;, ]/ }"
    if [[ ${#server_users_list[@]} -ne ${#server_passwords_list[@]} ]]; then
        error "ZOO_SERVER_USERS and ZOO_SERVER_PASSWORDS lists should have the same length"
        (( ++error_code ))
    fi

    # ZooKeeper server list validations
    if [[ -n $ZOO_SERVERS ]]; then
        read -r -a zookeeper_servers_list <<< "${ZOO_SERVERS//[;, ]/ }"
        for server in "${zookeeper_servers_list[@]}"; do
            if ! echo "$server" | grep -q -E "^[^:]+:[^:]+:[^:]+$"; then
                error "Zookeeper server ${server} should follow the next syntax: host:port:port. Example: zookeeper:2888:3888"
                (( ++error_code ))
            fi
        done
    fi

    [[ error_code -eq 0 ]] || exit $error_code
}

########################
# Ensure ZooKeeper is initialized
# Globals:
#   ZOO_*
# Arguments:
#   None
# Returns:
#   None
#########################
zookeeper_initialize() {
    info "Initializing ZooKeeper..."

    if [[ ! -f "$ZOO_CONF_FILE" ]]; then
        info "No injected configuration file found, creating default config files..."
        zookeeper_generate_conf

        zookeeper_configure_heap_size "$ZOO_HEAP_SIZE"
        if is_boolean_yes "$ZOO_ENABLE_AUTH"; then
            zookeeper_enable_authentication "$ZOO_CONF_FILE"
            zookeeper_create_jaas_file "${ZOO_CONF_DIR}/zoo_jaas.conf" "$ZOO_CLIENT_USER" "$ZOO_CLIENT_PASSWORD" "$ZOO_SERVER_USERS" "$ZOO_SERVER_PASSWORDS"
        fi
    else
        info "Configuration files found..."
    fi

    if is_dir_empty "$ZOO_DATA_DIR"; then
        info "Deploying ZooKeeper from scratch..."
        echo "$ZOO_SERVER_ID" > "${ZOO_DATA_DIR}/myid"

        if is_boolean_yes "$ZOO_ENABLE_AUTH" && [[ $ZOO_SERVER_ID -eq 1 ]] && [[ -n $ZOO_SERVER_USERS ]]; then
            zookeeper_configure_acl "$ZOO_SERVER_USERS"
        fi
    else
        info "Deploying ZooKeeper with persisted data..."
    fi
}

########################
# Generate the configuration files for ZooKeeper
# Globals:
#   ZOO_*
# Arguments:
#   None
# Returns:
#   None
#########################
zookeeper_generate_conf() {
    cp "${ZOO_CONF_DIR}/zoo_sample.cfg" "$ZOO_CONF_FILE"
    zookeeper_conf_set "$ZOO_CONF_FILE" tickTime "$ZOO_TICK_TIME"
    zookeeper_conf_set "$ZOO_CONF_FILE" initLimit "$ZOO_INIT_LIMIT"
    zookeeper_conf_set "$ZOO_CONF_FILE" syncLimit "$ZOO_SYNC_LIMIT"
    zookeeper_conf_set "$ZOO_CONF_FILE" dataDir "$ZOO_DATA_DIR"
    zookeeper_conf_set "$ZOO_CONF_FILE" clientPort "$ZOO_PORT_NUMBER"
    zookeeper_conf_set "$ZOO_CONF_FILE" maxClientCnxns "$ZOO_MAX_CLIENT_CNXNS"
    zookeeper_conf_set "$ZOO_CONF_FILE" reconfigEnabled "$(is_boolean_yes "$ZOO_RECONFIG_ENABLED" && echo true || echo false)"
    zookeeper_conf_set "$ZOO_CONF_FILE" 4lw.commands.whitelist "$ZOO_4LW_COMMANDS_WHITELIST"
    # Set log level
    zookeeper_conf_set "${ZOO_CONF_DIR}/log4j.properties" zookeeper.console.threshold "$ZOO_LOG_LEVEL"

    # Add zookeeper servers to configuration
    read -r -a zookeeper_servers_list <<< "${ZOO_SERVERS//[;, ]/ }"
    if [[ ${#zookeeper_servers_list[@]} -gt 1 ]]; then
        local i=1
        for server in "${zookeeper_servers_list[@]}"; do
            info "Adding server: ${server}"
            zookeeper_conf_set "$ZOO_CONF_FILE" server.$i "${server};${ZOO_PORT_NUMBER}"
            (( i++ ))
        done
    else
        info "No additional servers were specified. ZooKeeper will run in standalone mode..."
    fi
}

########################
# Configure heap size
# Globals:
#   JVMFLAGS
# Arguments:
#   $1 - heap_size
# Returns:
#   None
#########################
zookeeper_configure_heap_size() {
    local -r heap_size="${1:?heap_size is required}"

    if [[ "$JVMFLAGS" =~ -Xm[xs].*-Xm[xs] ]]; then
        debug "Using specified values (JVMFLAGS=${JVMFLAGS})"
    else
        debug "Setting '-Xmx${heap_size}m -Xms${heap_size}m' heap options..."
        zookeeper_export_jvmflags "-Xmx${heap_size}m -Xms${heap_size}m"
    fi
}

########################
# Enable authentication for ZooKeeper
# Globals:
#   None
# Arguments:
#   $1 - filename
# Returns:
#   None
#########################
zookeeper_enable_authentication() {
    local -r filename="${1:?filename is required}"

    info "Enabling authentication..."
    zookeeper_conf_set "$filename" authProvider.1 org.apache.zookeeper.server.auth.SASLAuthenticationProvider
    zookeeper_conf_set "$filename" requireClientAuthScheme sasl
}

########################
# Set a configuration setting value into a configuration file
# Globals:
#   None
# Arguments:
#   $1 - filename
#   $2 - key
#   $3 - value
# Returns:
#   None
#########################
zookeeper_conf_set() {
    local -r filename="${1:?filename is required}"
    local -r key="${2:?key is required}"
    local -r value="${3:?value is required}"

    if grep -q -E "^\s*#*\s*${key}=" "$filename"; then
        sed -i -E "s@^\s*#*\s*${key}=.*@${key}=${value}@g" "$filename"
    else
        echo "${key}=${value}" >> "$filename"
    fi
}

########################
# Create a JAAS file for authentication
# Globals:
#   JVMFLAGS
# Arguments:
#   $1 - filename
#   $2 - Client user
#   $3 - Client password
#   $4 - List of server users
#   $5 - List of server passwords
# Returns:
#   None
#########################
zookeeper_create_jaas_file() {
    local -r filename="${1:?filename is required}"
    local -r client_user="${2:?client user is required}"
    local -r client_password="${3:?client password is required}"
    local -r server_users="${4:?server users are required}"
    local -r server_passwords="${5:?server passwords are required}"

    info "Creating jaas file..."
    read -r -a server_users_list <<< "${server_users//[;, ]/ }"
    read -r -a server_passwords_list <<< "${server_passwords//[;, ]/ }"

    local zookeeper_server_user_passwords=""
    for i in $(seq 0 $(( ${#server_users_list[@]} - 1 ))); do
        zookeeper_server_user_passwords="${zookeeper_server_user_passwords}\n   user_${server_users_list[i]}=\"${server_passwords_list[i]}\""
    done
    zookeeper_server_user_passwords="${zookeeper_server_user_passwords#\\n   };"

    cat >"$filename" <<EOF
Client {
    org.apache.zookeeper.server.auth.DigestLoginModule required
    username="${client_user}"
    password="${client_password}";
};
Server {
    org.apache.zookeeper.server.auth.DigestLoginModule required
    $(echo -e -n "${zookeeper_server_user_passwords}")
};
EOF
    zookeeper_export_jvmflags "-Djava.security.auth.login.config=${filename}"
}

########################
# Configures ACL settings
# Globals:
#   ZOO_CONF_FILE, ZOO_BASE_DIR, ZOO_PORT_NUMBER
# Arguments:
#   $1 - List of server users
# Returns:
#   None
#########################
zookeeper_configure_acl() {
    local -r server_users="${1:?server users are required}"

    local acl_string=""
    for server_user in ${server_users//[;, ]/ }; do
        acl_string="${acl_string},sasl:${server_user}:crdwa"
    done
    acl_string="${acl_string#,}"

    local -r start_bg_dir="$(mktemp -d)"
    zookeeper_start_bg "$start_bg_dir"

    for path in / /zookeeper /zookeeper/quota; do
        info "Setting the ACL rule '${acl_string}' in ${path}"
        retry_while "${ZOO_BASE_DIR}/bin/zkCli.sh setAcl ${path} ${acl_string}" 400
    done

    zookeeper_stop
    rm -r "$start_bg_dir"
}

########################
# Export JVMFLAGS
# Globals:
#   JVMFLAGS
# Arguments:
#   $1 - value
# Returns:
#   None
#########################
zookeeper_export_jvmflags() {
    local -r value="${1:?value is required}"

    export JVMFLAGS="${JVMFLAGS} ${value}"
    echo "export JVMFLAGS=\"${JVMFLAGS}\"" > "${ZOO_CONF_DIR}/java.env"
}

########################
# Start ZooKeeper in background mode and waits until it's ready
# Globals:
#   ZOO_*
# Arguments:
#   start_bg_dir
# Returns:
#   None
#########################
zookeeper_start_bg() {
    local -r start_bg_dir="${1:-$ZOO_LOG_DIR}"

    local start_command="${ZOO_BASE_DIR}/bin/zkServer.sh start"
    am_i_root && ensure_dir_exists "$start_bg_dir" "$ZOO_DAEMON_USER" && start_command="gosu ${ZOO_DAEMON_USER} ${start_command}"
    ZOO_LOG_DIR=${start_bg_dir} $start_command
    wait-for-port -timeout 60 "$ZOO_PORT_NUMBER"
}

########################
# Stop ZooKeeper
# Globals:
#   ZOO_*
# Arguments:
#   log_dir
# Returns:
#   None
#########################
zookeeper_stop() {
    local -r log_dir="${1:-$ZOO_LOG_DIR}"

    ZOO_LOG_DIR="$log_dir" "${ZOO_BASE_DIR}/bin/zkServer.sh" stop
}
