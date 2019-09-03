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
    cat <<-"EOF"
		export ZOO_BASEDIR="/opt/bitnami/zookeeper"
		export ZOO_VOLUMEDIR="/bitnami/zookeeper"
		export ZOO_DATADIR="${ZOO_VOLUMEDIR}/data"
		export ZOO_CONFDIR="${ZOO_BASEDIR}/conf"
		export ZOO_CONF_FILE="${ZOO_CONFDIR}/zoo.cfg"
		export ZOO_LOG_DIR="${ZOO_BASEDIR}/logs"

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

    # ZooKeeper port validations
    local validate_port_args=()
    ! am_i_root && validate_port_args+=("-unprivileged")
    for var in "ZOO_PORT_NUMBER"; do
        if ! err=$(validate_port "${validate_port_args[@]}" "${!var}"); then
            error "An invalid port was specified in the environment variable $var: $err"
            exit 1
        fi
    done

    # ZooKeeper server users validations
    read -r -a server_users_list <<< "${ZOO_SERVER_USERS//[;, ]/ }"
    read -r -a server_passwords_list <<< "${ZOO_SERVER_PASSWORDS//[;, ]/ }"
    if [[ ${#server_users_list[@]} -ne ${#server_passwords_list[@]} ]]; then
        error "ZOO_SERVER_USERS and ZOO_SERVER_PASSWORDS lists should have the same length"
        exit 1
    fi

    # ZooKeeper server list validations
    read -r -a zookeeper_servers_list <<< "${ZOO_SERVERS//[;, ]/ }"
    for server in "${zookeeper_servers_list[@]}"; do
        if ! echo "$server" | grep -q -E "^[^:]+:[^:]+:[^:]+$"; then
            error "Zookeeper server ${server} should follow the next syntax: host:port:port. Example: zookeeper:2888:3888"
            exit 1
        fi
    done
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
        info "No injected configuration file found, creating default config file..."
        cp "${ZOO_CONFDIR}/zoo_sample.cfg" "$ZOO_CONF_FILE"
        zookeeper_conf_set "$ZOO_CONF_FILE" tickTime "$ZOO_TICK_TIME"
        zookeeper_conf_set "$ZOO_CONF_FILE" initLimit "$ZOO_INIT_LIMIT"
        zookeeper_conf_set "$ZOO_CONF_FILE" syncLimit "$ZOO_SYNC_LIMIT"
        zookeeper_conf_set "$ZOO_CONF_FILE" dataDir "$ZOO_DATADIR"
        zookeeper_conf_set "$ZOO_CONF_FILE" clientPort "$ZOO_PORT_NUMBER"
        zookeeper_conf_set "$ZOO_CONF_FILE" maxClientCnxns "$ZOO_MAX_CLIENT_CNXNS"
        zookeeper_conf_set "$ZOO_CONF_FILE" reconfigEnabled "$(is_boolean_yes "$ZOO_RECONFIG_ENABLED" && echo true || echo false)"
        zookeeper_conf_set "$ZOO_CONF_FILE" 4lw.commands.whitelist "$ZOO_4LW_COMMANDS_WHITELIST"

        # Add zookeeper servers to configuration
        read -r -a zookeeper_servers_list <<< "${ZOO_SERVERS//[;, ]/ }"
        if [[ ${#zookeeper_servers_list[@]} -gt 1 ]]; then
            local i=1
            for server in "${zookeeper_servers_list[@]}"; do
                info "Adding server: ${server}";
                zookeeper_conf_set "$ZOO_CONF_FILE" server.$i "${server};${ZOO_PORT_NUMBER}"
                (( i++ ))
            done
        else
            debug "The list of ZooKeeper servers is too short. Running ZooKeeper in standalone mode..."
        fi

        # Modify Java environment
        if [[ ! -f "${ZOO_CONFDIR}/java.env" ]]; then
            # Heap size
            if [[ "$JVMFLAGS" =~ -Xm[xs].*-Xm[xs] ]]; then
                debug "Using specified values (JVMFLAGS=${JVMFLAGS})"
            else
                debug "Setting '-Xmx${ZOO_HEAP_SIZE}m -Xms${ZOO_HEAP_SIZE}m' heap options..."
                export JVMFLAGS="${JVMFLAGS} -Xmx${ZOO_HEAP_SIZE}m -Xms${ZOO_HEAP_SIZE}m"
            fi
            # JAAS
            if is_boolean_yes "$ZOO_ENABLE_AUTH"; then
                info "Enabling authentication..."
                zookeeper_conf_set "$ZOO_CONF_FILE" authProvider.1 org.apache.zookeeper.server.auth.SASLAuthenticationProvider
                zookeeper_conf_set "$ZOO_CONF_FILE" requireClientAuthScheme sasl
                info "Creating jaas file..."
                zookeeper_create_jaas_file "${ZOO_CONFDIR}/zoo_jaas.conf" "$ZOO_CLIENT_USER" "$ZOO_CLIENT_PASSWORD" "$ZOO_SERVER_USERS" "$ZOO_SERVER_PASSWORDS"
                export JVMFLAGS="${JVMFLAGS} -Djava.security.auth.login.config=${ZOO_CONFDIR}/zoo_jaas.conf"
            fi

            echo "export JVMFLAGS=\"${JVMFLAGS}\"" > "${ZOO_CONFDIR}/java.env"
        fi

        # Set log level
        zookeeper_conf_set "${ZOO_CONFDIR}/log4j.properties" zookeeper.console.threshold "$ZOO_LOG_LEVEL"
    else
        info "Configuration files found..."
    fi

    if is_dir_empty "$ZOO_DATADIR"; then
        info "Deploying ZooKeeper from scratch..."
        echo "$ZOO_SERVER_ID" > "${ZOO_DATADIR}/myid"

        if is_boolean_yes "$ZOO_ENABLE_AUTH" && [[ $ZOO_SERVER_ID -eq 1 ]] && [[ -n $ZOO_SERVER_USERS ]]; then
            zookeeper_configure_acl "$ZOO_SERVER_USERS"
        fi
    else
        info "Deploying ZooKeeper with persisted data..."
    fi
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
#   None
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

    read -r -a server_users_list <<< "${server_users//[;, ]/ }"
    read -r -a server_passwords_list <<< "${server_passwords//[;, ]/ }"

    local zookeeper_server_user_passwords=""
    for i in $(seq 0 $(( ${#server_users_list[@]} - 1 ))); do
        zookeeper_server_user_passwords="${zookeeper_server_user_passwords}\n   user_${server_users_list[i]}=\"${server_passwords_list[i]}\""
    done
    zookeeper_server_user_passwords="${zookeeper_server_user_passwords#\\n   };"

    cat >"$filename" <<-EOF
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
}

########################
# Configures ACL settings
# Globals:
#   ZOO_CONF_FILE, ZOO_BASEDIR, ZOO_PORT_NUMBER
# Arguments:
#   $1 - List of server users
# Returns:
#   None
#########################
zookeeper_configure_acl() {
    local -r server_users="${1:?server users are required}"

    read -r -a server_users_list <<< "${server_users//[;, ]/ }"
    local acl_string=""
    for server_user in "${server_users_list[@]}"; do
        acl_string="${acl_string},sasl:${server_user}:crdwa"
    done
    acl_string="${acl_string#,}"

    local -r start_bg_dir="$(mktemp -d)"
    local start_command="${ZOO_BASEDIR}/bin/zkServer.sh start"
    am_i_root && ensure_dir_exists "$start_bg_dir" "$ZOO_DAEMON_USER" && start_command="gosu ${ZOO_DAEMON_USER} ${start_command}"
    ZOO_LOG_DIR=${start_bg_dir} $start_command
    wait-for-port "$ZOO_PORT_NUMBER"

    for path in / /zookeeper /zookeeper/quota; do
        info "Setting the ACL rule '${acl_string}' in ${path}"
        retry_while "${ZOO_BASEDIR}/bin/zkCli.sh setAcl ${path} ${acl_string}"
    done

    ZOO_LOG_DIR="$start_bg_dir" "${ZOO_BASEDIR}/bin/zkServer.sh" stop
    rm -r "$start_bg_dir"
}
