#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
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
    check_yes_no_value() {
        if ! is_yes_no_value "${!1}" && ! is_true_false_value "${!1}"; then
            print_validation_error "An invalid value was specified in the environment variable ${1}. Valid values are: yes or no"
        fi
    }
    check_true_false_value() {
        if ! is_yes_no_value "${!1}" && ! is_true_false_value "${!1}"; then
            print_validation_error "An invalid value was specified in the environment variable ${1}. Valid values are: true or false"
        fi
    }
    check_multi_value() {
        if [[ " ${2} " != *" ${!1} "* ]]; then
            print_validation_error "The allowed values for ${1} are: ${2}"
        fi
    }
    check_conflicting_ports() {
        local -r total="$#"
        for i in $(seq 1 "$((total - 1))"); do
            for j in $(seq "$((i + 1))" "$total"); do
                if (("${!i}" == "${!j}")); then
                    print_validation_error "${!i} and ${!j} are bound to the same port"
                fi
            done
        done
    }
    check_allowed_port() {
        local port_var="${1:?missing port variable}"
        local -a validate_port_args=()
        ! am_i_root && validate_port_args+=("-unprivileged")
        validate_port_args+=("${!port_var}")
        if ! err="$(validate_port "${validate_port_args[@]}")"; then
            print_validation_error "An invalid port was specified in the environment variable ${port_var}: ${err}."
        fi
    }

    check_fqdn() {
        if [[ "${!1}" == *.* ]]; then
            if [[ "${RABBITMQ_USE_LONGNAME}" = false ]]; then
                print_validation_error "The node name appears to be a fully qualified hostname and RABBITMQ_USE_LONGNAME is not set."
            fi
        fi
    }

    check_file_exists_or_path_writable() {
        local path_to_check="${!1}"
        local full_path_to_check
        full_path_to_check=$(realpath "${path_to_check}")
        local path_directory_to_check="${full_path_to_check%/*}"

        # check if given path is empty
        if [[ -z "${path_to_check}" ]]; then
            # not okay if the given path is empty
            print_validation_error "The variable ${1} must be set to either an existant file or a non-existant file in a writable directory."
        fi
        # check if file at given path exists
        if [[ ! -f "${path_to_check}" ]]; then
            # if the file does not exist, check if the directory is writable
            if [[ ! -w "${path_directory_to_check}" ]]; then
                # not okay if not writable
                print_validation_error "The variable ${1} must be set to either an existant file or a non-existant file in a writable directory."
            fi
            # ok if writable
        fi
        # ok if the file exists
    }

    check_yes_no_value "RABBITMQ_LOAD_DEFINITIONS"
    check_yes_no_value "RABBITMQ_SECURE_PASSWORD"
    check_yes_no_value "RABBITMQ_ENABLE_LDAP"
    check_yes_no_value "RABBITMQ_LDAP_TLS"
    check_yes_no_value "RABBITMQ_UPDATE_PASSWORD"
    check_conflicting_ports "RABBITMQ_MANAGEMENT_PORT_NUMBER" "RABBITMQ_NODE_PORT_NUMBER" "RABBITMQ_MANAGEMENT_SSL_PORT_NUMBER" "RABBITMQ_NODE_SSL_PORT_NUMBER"
    check_multi_value "RABBITMQ_SSL_VERIFY" "verify_none verify_peer"
    check_multi_value "RABBITMQ_MANAGEMENT_SSL_VERIFY" "verify_none verify_peer"
    check_file_exists_or_path_writable "RABBITMQ_COMBINED_CERT_PATH"
    check_true_false_value "RABBITMQ_USE_LONGNAME"
    check_fqdn "RABBITMQ_NODE_NAME"

    if is_boolean_yes "$RABBITMQ_LOAD_DEFINITIONS"; then
        if [[ -f "$RABBITMQ_DEFINITIONS_FILE" ]]; then
            is_boolean_yes "$RABBITMQ_SECURE_PASSWORD" && grep -q '"users"' "$RABBITMQ_DEFINITIONS_FILE" && warn 'A definition file with "users" was found. The RABBITMQ_SECURE_PASSWORD environment variables will be ignored.'
        else
            print_validation_error "The definitions file $RABBITMQ_DEFINITIONS_FILE is not found. Please ensure that the path is correct or change the RABBITMQ_DEFINITIONS_FILE variable."
        fi
    elif [[ -z "$RABBITMQ_PASSWORD" ]]; then
        print_validation_error "You must indicate a password"
    fi

    if is_boolean_yes "$RABBITMQ_ENABLE_LDAP" && { [[ -z "${RABBITMQ_LDAP_SERVERS}" ]] || [[ -z "${RABBITMQ_LDAP_USER_DN_PATTERN}" ]]; }; then
        print_validation_error "The LDAP configuration is required when LDAP authentication is enabled. Set the environment variables RABBITMQ_LDAP_SERVERS and RABBITMQ_LDAP_USER_DN_PATTERN."
    fi

    if [[ "$RABBITMQ_NODE_TYPE" = "stats" ]]; then
        if ! validate_ip "$RABBITMQ_MANAGEMENT_BIND_IP"; then
            print_validation_error "An invalid IP was specified in the environment variable RABBITMQ_MANAGEMENT_BIND_IP."
        fi
        check_allowed_port "RABBITMQ_MANAGEMENT_PORT_NUMBER"
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

    # Validate high memory watermark
    # It can be specified as an absolute value, or as a relative (either in percentage or value between 0 and 1)
    if ! is_empty_value "$RABBITMQ_VM_MEMORY_HIGH_WATERMARK" && ! rabbitmq_is_absolute_value "$RABBITMQ_VM_MEMORY_HIGH_WATERMARK" && ! rabbitmq_is_relative_value "$RABBITMQ_VM_MEMORY_HIGH_WATERMARK"; then
        print_validation_error "RABBITMQ_VM_MEMORY_HIGH_WATERMARK must be specified as an absolute or relative value. Example of absolute values: 1GiB, 1G, 100M, 1048576. Example of relative values: 50%, 0.5."
    fi

    [[ "$error_code" -eq 0 ]] || return "$error_code"
}

########################
# Checks whether an input value refers to an absolute memory value
# Globals:
#   None
# Arguments:
#   $1 - value
# Returns:
#   boolean
#########################
rabbitmq_is_absolute_value() {
    local value="${1:?missing value}"
    [[ "$1" =~ ^[1-9][0-9]*([MG](i?B)?)?$ ]]
}

########################
# Checks whether an input value refers to an absolute memory value
# Globals:
#   None
# Arguments:
#   $1 - value
# Returns:
#   boolean
#########################
rabbitmq_is_relative_value() {
    local value="${1:?missing value}"
    [[ "$1" =~ ^[0-9]+(\.[0-9]+)?%$ || "$1" =~ ^0\.[0-9][0-9]*$ ]]
}

########################
# Checks whether SSL configurations should be enabled
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   boolean
#########################
rabbitmq_is_ssl_enabled() {
    local -r env_prefix="${1:-ssl}"
    local env_var
    for ssl_key in cacertfile certfile keyfile; do
        env_var="RABBITMQ_${env_prefix^^}_${ssl_key^^}"
        ! is_empty_value "${!env_var:-}" && return "$?"
    done
    false
}

########################
# Prints RabbitMQ SSL configuration entries
# Globals:
#   RABBITMQ_*
# Arguments:
#   None
# Returns:
#   None
#########################
rabbitmq_print_ssl_configuration() {
    local -r env_prefix="${1:-ssl}"
    local -r conf_prefix="${2:-ssl_options}"

    # Assume SSL is disabled when no environment variables matching 'RABBITMQ_SSL_*' have been specified
    rabbitmq_is_ssl_enabled "$env_prefix" || return

    local -r -a ssl_keys=(
        cacertfile
        certfile
        keyfile
        password
        depth
        fail_if_no_peer_cert
        verify
    )
    local env_var env_var_value
    for ssl_key in "${ssl_keys[@]}"; do
        env_var="RABBITMQ_${env_prefix^^}_${ssl_key^^}"
        env_var_value="${!env_var:-}"
        # Skip if the environment variable is empty/not defined
        is_empty_value "$env_var_value" && continue
        echo -n "${conf_prefix}.${ssl_key} = "
        # Process boolean value for 'fail_if_no_peer_cert'
        if [[ "$ssl_key" = "fail_if_no_peer_cert" ]]; then
            is_boolean_yes "$env_var_value" && echo "true" || echo "false"
        else
            echo "$env_var_value"
        fi
    done
    echo
}

########################
# Prints RabbitMQ networking-specific configuration entries
# Globals:
#   RABBITMQ_*
# Arguments:
#   None
# Returns:
#   None
#########################
rabbitmq_print_networking_configuration() {
    echo "## Networking"
    if rabbitmq_is_ssl_enabled; then
        echo "listeners.ssl.default = ${RABBITMQ_NODE_SSL_PORT_NUMBER}"
        rabbitmq_print_ssl_configuration
    else
        echo "listeners.tcp.default = ${RABBITMQ_NODE_PORT_NUMBER}"
        echo
    fi
}

########################
# Prints RabbitMQ management configuration entries
# Globals:
#   RABBITMQ_*
# Arguments:
#   None
# Returns:
#   None
#########################
rabbitmq_print_management_configuration() {
    echo "## Management"
    if rabbitmq_is_ssl_enabled "management_ssl"; then
        echo "management.ssl.ip = ${RABBITMQ_MANAGEMENT_BIND_IP}"
        echo "management.ssl.port = ${RABBITMQ_MANAGEMENT_SSL_PORT_NUMBER}"
        rabbitmq_print_ssl_configuration "management_ssl" "management.ssl"
    else
        # Assume SSL is disabled when no environment variables matching 'RABBITMQ_SSL_*' have been specified
        echo "management.tcp.ip = ${RABBITMQ_MANAGEMENT_BIND_IP}"
        echo "management.tcp.port = ${RABBITMQ_MANAGEMENT_PORT_NUMBER}"
    fi

    # Allow access to web UI
    if is_boolean_yes "$RABBITMQ_MANAGEMENT_ALLOW_WEB_ACCESS"; then
        echo "loopback_users.${RABBITMQ_USERNAME} = false"
    else
        echo "loopback_users.${RABBITMQ_USERNAME} = true"
    fi

    # End config file section
    echo
}

########################
# Prints RabbitMQ LDAP-specific configuration entries
# Globals:
#   RABBITMQ_*
# Arguments:
#   None
# Returns:
#   None
#########################
rabbitmq_print_ldap_configuration() {
    if is_boolean_yes "$RABBITMQ_ENABLE_LDAP"; then
        cat <<EOF
## LDAP
# Select an authentication/authorisation backend to use
auth_backends.1 = rabbit_auth_backend_ldap
auth_backends.2 = internal
# Connection to LDAP server(s)
auth_ldap.port = $RABBITMQ_LDAP_SERVERS_PORT
auth_ldap.user_dn_pattern = $RABBITMQ_LDAP_USER_DN_PATTERN
EOF
        read -r -a ldap_servers <<<"$(tr ',;' ' ' <<<"$RABBITMQ_LDAP_SERVERS")"
        local index=1
        for server in "${ldap_servers[@]}"; do
            echo "auth_ldap.servers.${index} = ${server}"
            ((index++))
        done
        if is_boolean_yes "$RABBITMQ_LDAP_TLS"; then
            echo "auth_ldap.use_ssl = true"
        fi
        # Add newline to separate sections in the config file
        echo
    fi
}

rabbitmq_print_resource_limits_configuration() {
    echo "## Resource limits"
    # Memory threshold configuration
    local memory_size="$RABBITMQ_VM_MEMORY_HIGH_WATERMARK"
    if ! is_empty_value "$memory_size"; then
        if rabbitmq_is_absolute_value "$memory_size"; then
            echo "# Set an absolute memory threshold"
            echo "vm_memory_high_watermark.absolute = ${memory_size}"
        elif rabbitmq_is_relative_value "$memory_size"; then
            echo "# Set a relative memory threshold"
            if [[ "$memory_size" =~ %$ ]]; then
                # Convert percentage to a relative value (< 1)
                memory_size="$(awk '{ print $1 / 100 }' <<<"${memory_size//%/}")"
            fi
            # Only keep first three decimals
            printf "vm_memory_high_watermark.relative = %.03f\n" "$memory_size"
        fi
    fi
    # Disk limit configuration
    if [[ -n "$RABBITMQ_DISK_FREE_ABSOLUTE_LIMIT" ]]; then
        echo "# Set an absolute free disk space limit"
        echo "disk_free_limit.absolute = ${RABBITMQ_DISK_FREE_ABSOLUTE_LIMIT}"
    else
        echo "# Set a free disk space limit relative to total available RAM"
        echo "disk_free_limit.relative = ${RABBITMQ_DISK_FREE_RELATIVE_LIMIT}"
    fi
}

########################
# Enable generating log to file
# Globals:
#   RABBITMQ_*
# Arguments:
#   None
# Returns:
#   None
#########################
rabbitmq_enable_log_file() {
    replace_in_file "$RABBITMQ_CONF_FILE" 'log\.console.*' 'log\.console = false'
}

########################
# Creates RabbitMQ configuration file
# Globals:
#   RABBITMQ_*
# Arguments:
#   None
# Returns:
#   None
#########################
rabbitmq_create_config_file() {
    debug "Creating configuration file..."
    (
        cat <<EOF
## Clustering
cluster_partition_handling = ${RABBITMQ_CLUSTER_PARTITION_HANDLING}

## Defaults
# During the first start, RabbitMQ will create a vhost and a user
# These config items control what gets created
default_permissions.configure = .*
default_permissions.read = .*
default_permissions.write = .*
log.console = true
EOF

        # When loading definitions, default vhost and user/pass won't be created: https://www.rabbitmq.com/definitions.html#import-on-boot
        if ! is_boolean_yes "$RABBITMQ_LOAD_DEFINITIONS"; then
            cat <<EOF
default_vhost = ${RABBITMQ_VHOST:?}
default_user = ${RABBITMQ_USERNAME}
EOF
            # In most cases (i.e. container images), it is not a concern to specify the default password this way
            ! is_boolean_yes "$RABBITMQ_SECURE_PASSWORD" && cat <<<"default_pass = ${RABBITMQ_PASSWORD}"
            echo
        fi

        if is_boolean_yes "$RABBITMQ_LOAD_DEFINITIONS"; then
            cat <<EOF
load_definitions = ${RABBITMQ_DEFINITIONS_FILE}
EOF
        fi
        rabbitmq_print_networking_configuration
        rabbitmq_print_management_configuration
        rabbitmq_print_ldap_configuration
        rabbitmq_print_resource_limits_configuration
    ) >>"$RABBITMQ_CONF_FILE"
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
            printf '\n%s = %s' "$key" "$value" >>"$RABBITMQ_CONF_FILE"
        fi
    fi
}

########################
# Prints the Erlang root directory
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   Erlang root directory
#########################
rabbitmq_erlang_dir() {
    dirname "$(dirname "$(which erl)")"
}

########################
# Prints the Erlang SSL directory
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   Erlang SSL directory
#########################
rabbitmq_erlang_ssl_dir() {
    echo "$(find "$(rabbitmq_erlang_dir)" -name 'ssl-[0-9]*')/ebin"
}

########################
# Create combined SSL certificate and key file
# Ref: https://www.rabbitmq.com/clustering-ssl.html#combined-key-file
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#########################
rabbitmq_create_combined_ssl_file() {
    if [[ ! -f "$RABBITMQ_COMBINED_CERT_PATH" ]]; then
        cat "$RABBITMQ_SSL_CERTFILE" "$RABBITMQ_SSL_KEYFILE" >"$RABBITMQ_COMBINED_CERT_PATH"
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
    {
        cat <<EOF
HOME=$RABBITMQ_HOME_DIR
NODE_PORT=$RABBITMQ_NODE_PORT_NUMBER
NODENAME=$RABBITMQ_NODE_NAME
EOF
        if [[ -f "$RABBITMQ_COMBINED_CERT_PATH" ]]; then
            cat <<EOF
# SSL configuration
ERL_SSL_PATH=$(rabbitmq_erlang_ssl_dir)
SERVER_ADDITIONAL_ERL_ARGS="-pa \$ERL_SSL_PATH
  -proto_dist inet_tls \
  -ssl_dist_opt server_certfile ${RABBITMQ_COMBINED_CERT_PATH} \
  -ssl_dist_opt server_secure_renegotiate true client_secure_renegotiate true"
RABBITMQ_CTL_ERL_ARGS="\$SERVER_ADDITIONAL_ERL_ARGS"
EOF
        fi
    } >"$RABBITMQ_CONF_ENV_FILE"
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
    read -r -a plugins <<<"$(tr ',;' ' ' <<<"$RABBITMQ_COMMUNITY_PLUGINS")"
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
    local -a plugins=("rabbitmq_management_agent" "rabbitmq_prometheus")

    if [[ -n "${RABBITMQ_PLUGINS:-}" ]]; then
        read -r -a extra_plugins_array <<<"$(tr ',;' ' ' <<<"$RABBITMQ_PLUGINS")"
        [[ "${#extra_plugins_array[@]}" -gt 0 ]] && plugins+=("${extra_plugins_array[@]}")
    else
        if [[ "$RABBITMQ_NODE_TYPE" = "stats" ]]; then
            plugins=("rabbitmq_management")
        fi
        is_boolean_yes "$RABBITMQ_ENABLE_LDAP" && plugins+=("rabbitmq_auth_backend_ldap")
    fi
    cat >"${RABBITMQ_CONF_DIR}/enabled_plugins" <<EOF
[$(echo "${plugins[@]}" | sed -E 's/\s+/,/g')].
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

    echo "$RABBITMQ_ERL_COOKIE" >"${RABBITMQ_HOME_DIR}/.erlang.cookie"
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
    if [[ -z "${RABBITMQ_PID:-}" && -n "${RABBITMQ_PID_FILE:-}" ]]; then
        RABBITMQ_PID="$(get_pid_from_file "$RABBITMQ_PID_FILE")"
    fi
    if [[ -z "${RABBITMQ_PID:-}" ]]; then
        false
    else
        is_service_running "$RABBITMQ_PID"
    fi
}

########################
# Checks if RabbitMQ is not running
# Globals:
#   RABBITMQ_PID
#   RABBITMQ_BIN_DIR
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_rabbitmq_not_running() {
    ! is_rabbitmq_running
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
    am_i_root && start_command=("run_as_user" "$RABBITMQ_DAEMON_USER" "${start_command[@]}")
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

    if ! debug_execute "${RABBITMQ_BIN_DIR}/rabbitmqctl" change_password -- "$user" "$password"; then
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
# Declare a new virtual host
# Globals:
#   BITNAMI_DEBUG
#   RABBITMQ_BIN_DIR
# Arguments:
#   $1 - Name
# Returns:
#   None
#########################
rabbitmq_declare_vhost() {
    local name="${1:?name is required}"
    debug "Declaring vhost '${name}'..."

    if ! debug_execute "${RABBITMQ_BIN_DIR}/rabbitmqctl" add_vhost -- "${name}"; then
        error "Couldn't declared vhost '${name}'."
        return 1
    fi
}

########################
# Allow a user to access a virtual host
# Globals:
#   BITNAMI_DEBUG
#   RABBITMQ_BIN_DIR
# Arguments:
#   $1 - User
#   $2 - Vhost
# Returns:
#   None
#########################
rabbitmq_set_user_vhost_permission() {
    local user="${1:?user is required}"
    local vhost="${2:?vhost is required}"
    debug "Assigning permissions to user '${user}' to access vhost '${vhost}'..."

    if ! debug_execute "${RABBITMQ_BIN_DIR}/rabbitmqctl" set_permissions --vhost "${vhost}" "${user}" ".*" ".*" ".*"; then
        error "Couldn't assigned perrmissions to user '${user}' to access vhost '${vhost}'."
        return 1
    fi
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
    rabbitmq_is_ssl_enabled && rabbitmq_create_combined_ssl_file
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

    debug "Ensuring expected directories/files exist..."
    for dir in "$RABBITMQ_DATA_DIR" "$RABBITMQ_LIB_DIR" "$RABBITMQ_HOME_DIR"; do
        ensure_dir_exists "$dir"
        am_i_root && chown -R "$RABBITMQ_DAEMON_USER:$RABBITMQ_DAEMON_GROUP" "$dir"
    done

    # Use realpath to avoid symlink issues
    # ref: https://github.com/bitnami/bitnami-docker-rabbitmq/pull/184
    if ! is_mounted_dir_empty "$(realpath "$RABBITMQ_DATA_DIR")"; then
        info "Persisted data detected. Restoring..."
        if is_boolean_yes "$RABBITMQ_FORCE_BOOT" && ! is_dir_empty "${RABBITMQ_DATA_DIR}/${RABBITMQ_NODE_NAME}"; then
            # ref: https://www.rabbitmq.com/rabbitmqctl.8.html#force_boot
            warn "Forcing node to start..."
            debug_execute "${RABBITMQ_BIN_DIR}/rabbitmqctl" force_boot
        fi
        if is_boolean_yes "$RABBITMQ_UPDATE_PASSWORD"; then
            ! is_rabbitmq_running && rabbitmq_start_bg
            if is_boolean_yes "$RABBITMQ_LOAD_DEFINITIONS"; then
                if ! grep -q '"users"' "$RABBITMQ_DEFINITIONS_FILE"; then
                    info "Updating password"
                    rabbitmq_change_password "$RABBITMQ_USERNAME" "$RABBITMQ_PASSWORD"
                fi
            elif is_boolean_yes "$RABBITMQ_SECURE_PASSWORD"; then
                info "Updating password"
                rabbitmq_change_password "$RABBITMQ_USERNAME" "$RABBITMQ_PASSWORD"
            fi
        fi
    else
        ! is_rabbitmq_running && rabbitmq_start_bg
        if is_boolean_yes "$RABBITMQ_LOAD_DEFINITIONS"; then
            if ! grep -q '"users"' "$RABBITMQ_DEFINITIONS_FILE"; then
                debug_execute "${RABBITMQ_BIN_DIR}/rabbitmqctl" add_user "$RABBITMQ_USERNAME" "$RABBITMQ_PASSWORD"
                debug_execute "${RABBITMQ_BIN_DIR}/rabbitmqctl" set_user_tags "$RABBITMQ_USERNAME" administrator
            fi
        elif is_boolean_yes "$RABBITMQ_SECURE_PASSWORD"; then
            rabbitmq_change_password "$RABBITMQ_USERNAME" "$RABBITMQ_PASSWORD"
        fi

        if [[ -n "${RABBITMQ_VHOSTS:-}" ]]; then
            for vhost in ${RABBITMQ_VHOSTS}; do
                rabbitmq_declare_vhost "${vhost}"
                if [[ -n "${RABBITMQ_USERNAME}" ]]; then
                    rabbitmq_set_user_vhost_permission "${RABBITMQ_USERNAME}" "${vhost}"
                fi
            done
        fi

        if [[ "$RABBITMQ_NODE_TYPE" != "stats" ]] && [[ -n "$RABBITMQ_CLUSTER_NODE_NAME" ]]; then
            rabbitmq_join_cluster "$RABBITMQ_CLUSTER_NODE_NAME" "$RABBITMQ_NODE_TYPE"
        fi
    fi
}

########################
# Run custom initialization scripts
# Globals:
#   RABBITMQ_*
# Arguments:
#   None
# Returns:z<
#   None
#########################
rabbitmq_custom_init_scripts() {
    if [[ -n $(find "${RABBITMQ_INITSCRIPTS_DIR}/" -type f -regex ".*\.sh") ]]; then
        info "Loading user's custom files from $RABBITMQ_INITSCRIPTS_DIR ..."
        local -r tmp_file="/tmp/filelist"
        find "${RABBITMQ_INITSCRIPTS_DIR}/" -type f -regex ".*\.sh" | sort >"$tmp_file"
        while read -r f; do
            case "$f" in
            *.sh)
                if [[ -x "$f" ]]; then
                    debug "Executing $f"
                    "$f"
                else
                    debug "Sourcing $f"
                    # shellcheck disable=SC1090
                    . "$f"
                fi
                ;;
            *)
                debug "Ignoring $f"
                ;;
            esac
        done <$tmp_file
        rm -f "$tmp_file"
    else
        info "No custom scripts in $RABBITMQ_INITSCRIPTS_DIR"
    fi
}
