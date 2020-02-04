#!/bin/bash
#
# Bitnami Cassandra library

# shellcheck disable=SC1090
# shellcheck disable=SC1091

# Load Generic Libraries
. /libfile.sh
. /libfs.sh
. /liblog.sh
. /libnet.sh
. /libservice.sh
. /libvalidations.sh

########################
# Load global variables used on Cassandra configuration.
# Globals:
#   CASSANDRA_*
# Arguments:
#   None
# Returns:
#   Series of exports to be used as 'eval' arguments
#########################
cassandra_env() {
    cat <<"EOF"
# Bitnami debug
export MODULE=cassandra
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# Paths
export CASSANDRA_BASE_DIR="/opt/bitnami/cassandra"
export CASSANDRA_BIN_DIR="${CASSANDRA_BASE_DIR}/bin"
export CASSANDRA_CONF_DIR="${CASSANDRA_BASE_DIR}/conf"
export CASSANDRA_VOLUME_DIR="${CASSANDRA_VOLUME_DIR:-/bitnami/cassandra}"
export CASSANDRA_DATA_DIR="${CASSANDRA_DATA_DIR:-${CASSANDRA_VOLUME_DIR}/data}"
export CASSANDRA_DEFAULT_CONF_DIR="${CASSANDRA_BASE_DIR}/conf.default"
export CASSANDRA_HISTORY_DIR="/.cassandra"
export CASSANDRA_INITSCRIPTS_DIR=/docker-entrypoint-initdb.d
export CASSANDRA_LOG_DIR="${CASSANDRA_BASE_DIR}/logs"
export CASSANDRA_MOUNTED_CONF_DIR="${CASSANDRA_MOUNTED_CONF_DIR:-${CASSANDRA_VOLUME_DIR}/conf}"
export CASSANDRA_TMP_DIR="${CASSANDRA_BASE_DIR}/tmp"
export JAVA_BASE_DIR="/opt/bitnami/java"
export JAVA_BIN_DIR="${JAVA_BASE_DIR}/bin"
export PYTHON_BASE_DIR="/opt/bitnami/python"
export PYTHON_BIN_DIR="${PYTHON_BASE_DIR}/bin"

export CASSANDRA_CONF_FILE="${CASSANDRA_CONF_DIR}/cassandra.yaml"
export CASSANDRA_LOG_FILE="${CASSANDRA_LOG_DIR}/cassandra.log"
export CASSANDRA_FIRST_BOOT_LOG_FILE="${CASSANDRA_LOG_DIR}/cassandra_first_boot.log"
export CASSANDRA_INITSCRIPTS_BOOT_LOG_FILE="${CASSANDRA_LOG_DIR}/cassandra_init_scripts_boot.log"
export CASSANDRA_PID_FILE="${CASSANDRA_TMP_DIR}/cassandra.pid"

export PATH="$CASSANDRA_BIN_DIR:$JAVA_BIN_DIR:$PYTHON_BIN_DIR:$PATH"

# Users
export CASSANDRA_DAEMON_USER="cassandra"
export CASSANDRA_DAEMON_GROUP="cassandra"

# Cluster Settings
export CASSANDRA_CLIENT_ENCRYPTION="${CASSANDRA_CLIENT_ENCRYPTION:-false}"
export CASSANDRA_CLUSTER_NAME="${CASSANDRA_CLUSTER_NAME:-My Cluster}"
export CASSANDRA_DATACENTER="${CASSANDRA_DATACENTER:-dc1}"
export CASSANDRA_ENABLE_REMOTE_CONNECTIONS="${CASSANDRA_ENABLE_REMOTE_CONNECTIONS:-true}"
export CASSANDRA_ENABLE_RPC="${CASSANDRA_ENABLE_RPC:-true}"
export CASSANDRA_ENDPOINT_SNITCH="${CASSANDRA_ENDPOINT_SNITCH:-SimpleSnitch}"
export CASSANDRA_HOST="${CASSANDRA_HOST:-$(hostname)}"
export CASSANDRA_INTERNODE_ENCRYPTION="${CASSANDRA_INTERNODE_ENCRYPTION:-none}"
export CASSANDRA_NUM_TOKENS="${CASSANDRA_NUM_TOKENS:-256}"
export CASSANDRA_PASSWORD_SEEDER="${CASSANDRA_PASSWORD_SEEDER:-no}"
export CASSANDRA_SEEDS="${CASSANDRA_SEEDS:-$CASSANDRA_HOST}"
export CASSANDRA_PEERS="${CASSANDRA_PEERS:-$CASSANDRA_SEEDS}"
export CASSANDRA_RACK="${CASSANDRA_RACK:-rack1}"

# Startup CQL and init-db settings
export CASSANDRA_STARTUP_CQL="${CASSANDRA_STARTUP_CQL:-}"
export CASSANDRA_IGNORE_INITDB_SCRIPTS="${CASSANDRA_IGNORE_INITDB_SCRIPTS:-no}"

# Ports
export CASSANDRA_CQL_PORT_NUMBER="${CASSANDRA_CQL_PORT_NUMBER:-9042}"
export CASSANDRA_JMX_PORT_NUMBER="${CASSANDRA_JMX_PORT_NUMBER:-7199}"
export CASSANDRA_TRANSPORT_PORT_NUMBER="${CASSANDRA_TRANSPORT_PORT_NUMBER:-7000}"

# Retries and sleep times
export CASSANDRA_CQL_MAX_RETRIES="${CASSANDRA_CQL_MAX_RETRIES:-20}"
export CASSANDRA_CQL_SLEEP_TIME="${CASSANDRA_CQL_SLEEP_TIME:-5}"
export CASSANDRA_INIT_MAX_RETRIES="${CASSANDRA_INIT_MAX_RETRIES:-100}"
export CASSANDRA_INIT_SLEEP_TIME="${CASSANDRA_INIT_SLEEP_TIME:-5}"
export CASSANDRA_PEER_CQL_MAX_RETRIES="${CASSANDRA_PEER_CQL_MAX_RETRIES:-100}"
export CASSANDRA_PEER_CQL_SLEEP_TIME="${CASSANDRA_PEER_CQL_SLEEP_TIME:-10}"

# Credentials
export CASSANDRA_USER="${CASSANDRA_USER:-cassandra}"
export CASSANDRA_KEYSTORE_LOCATION="${CASSANDRA_KEYSTORE_LOCATION:-${CASSANDRA_VOLUME_DIR}/secrets/keystore}"
export CASSANDRA_TRUSTSTORE_LOCATION="${CASSANDRA_TRUSTSTORE_LOCATION:-${CASSANDRA_VOLUME_DIR}/secrets/truststore}"
EOF
    if [[ -n "${CASSANDRA_PASSWORD_FILE:-}" ]] && [[ -f "$CASSANDRA_PASSWORD_FILE" ]]; then
        cat <<"EOF"
export CASSANDRA_PASSWORD="$(< "${CASSANDRA_PASSWORD_FILE}")"
EOF
    else
        cat <<"EOF"
export CASSANDRA_PASSWORD="${CASSANDRA_PASSWORD:-cassandra}"
EOF
    fi
    if [[ -n "${CASSANDRA_KEYSTORE_PASSWORD_FILE:-}" ]] && [[ -f "$CASSANDRA_KEYSTORE_PASSWORD_FILE" ]]; then
        cat <<"EOF"
export CASSANDRA_KEYSTORE_PASSWORD="$(< "${CASSANDRA_KEYSTORE_PASSWORD_FILE}")"
EOF
    else
        cat <<"EOF"
export CASSANDRA_KEYSTORE_PASSWORD="${CASSANDRA_KEYSTORE_PASSWORD:-cassandra}"
EOF
    fi
    if [[ -n "${CASSANDRA_TRUSTSTORE_PASSWORD_FILE:-}" ]] && [[ -f "$CASSANDRA_TRUSTSTORE_PASSWORD_FILE" ]]; then
        cat <<"EOF"
export CASSANDRA_TRUSTSTORE_PASSWORD="$(< "${CASSANDRA_TRUSTSTORE_PASSWORD_FILE}")"
EOF
    else
        cat <<"EOF"
export CASSANDRA_TRUSTSTORE_PASSWORD="${CASSANDRA_TRUSTSTORE_PASSWORD:-cassandra}"
EOF
    fi
}

########################
# Change a Cassandra configuration yaml file by setting a property (cannot use yq because it removes comments)
# Globals:
#   CASSANDRA_*
# Arguments:
#   $1 - property
#   $2 - value
#   $3 - Use quotes in value (default: yes)
#   $4 - Path to configuration file (default: $CASSANDRA_CONF_FILE)
# Returns:
#   None
#########################
cassandra_yaml_set() {
    local -r property="${1:?missing property}"
    local -r value="${2:?missing value}"
    local -r use_quotes="${3:-yes}"
    local -r conf_file="${4:-$CASSANDRA_CONF_FILE}"

    if is_boolean_yes "$use_quotes"; then
        replace_in_file "$conf_file" "^(#\s)?(\s*)(\-\s*)?${property}:.*" "\2\3${property}: '${value}'"
    else
        replace_in_file "$conf_file" "^(#\s)?(\s*)(\-\s*)?${property}:.*" "\2\3${property}: ${value}"
    fi
}

########################
# Change a Cassandra configuration yaml file by setting a property as an array (cannot use yq because it removes comments)
# Globals:
#   CASSANDRA_*
# Arguments:
#   $1 - property
#   $2 - comma-separated string with the different values
#   $3 - Use quotes in value (default: no)
#   $4 - Path to configuration file (default: $CASSANDRA_CONF_FILE)
# Returns:
#   None
#########################
cassandra_yaml_set_as_array() {
    local -r property="${1:?missing property}"
    local -r array="${2:?missing value}"
    local -r use_quotes="${3:-no}"
    local -r conf_file="${4:-$CASSANDRA_CONF_FILE}"
    local substitution="\2${property}:"

    for value in "${array[@]}"; do
        if is_boolean_yes "$use_quotes"; then
            substitution+="\n\2  - '${value}'"
        else
            substitution+="\n\2  - ${value}"
        fi
    done
    replace_in_file "$conf_file" "^(#\s)?(\s*)${property}:.*" "${substitution}"
}

########################
# Validate settings in CASSANDRA_* environment variables
# Globals:
#   CASSANDRA_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_validate() {
    info "Validating settings in CASSANDRA_* env vars.."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    check_default_password() {
        if [[ "${!1}" = "cassandra" ]]; then
            warn "You set the environment variable $1=cassandra. This is the default value when bootstrapping Cassandra and should not be used in production environments."
        fi
    }

    check_yes_no_value() {
        if ! is_yes_no_value "${!1}"; then
            print_validation_error "The allowed values for $1 are [yes, no]"
        fi
    }

    check_true_false_value() {
        if ! is_true_false_value "${!1}"; then
            print_validation_error "The allowed values for $1 are [true, false]"
        fi
    }

    check_conflicting_ports() {
        local -r total="$#"
        for i in $(seq 1 "$((total - 1))"); do
            for j in $(seq "$((i + 1))" "$total"); do
                if (( "${!i}" == "${!j}" )); then
                    print_validation_error "${!i} and ${!j} are bound to the same port"
                fi
            done
        done
    }

    check_allowed_port() {
        local validate_port_args=()
        ! am_i_root && validate_port_args+=("-unprivileged")
        if ! err=$(validate_port "${validate_port_args[@]}" "${!1}"); then
            print_validation_error "An invalid port was specified in the environment variable $1: $err"
        fi
    }

    check_resolved_hostname() {
        if ! is_hostname_resolved "$1"; then
            warn "Hostname $1 could not be resolved. This could lead to connection issues"
        fi
    }

    check_positive_value() {
        if ! is_positive_int "${!1}"; then
            print_validation_error "The variable $1 must be positive integer"
        fi
    }

    check_empty_value() {
        if is_empty_value "${!1}"; then
            print_validation_error "The $1 environment variable is empty or not set."
        fi
    }

    check_password_file() {
        if [[ -n "${!1:-}" ]] && ! [[ -f "${!1:-}" ]]; then
            print_validation_error "The variable $1 is defined but the file ${!1} is not accessible or does not exist"
        fi
    }

    check_password_file CASSANDRA_PASSWORD_FILE
    check_password_file CASSANDRA_TRUSTSTORE_PASSWORD_FILE
    check_password_file CASSANDRA_KEYSTORE_PASSWORD_FILE

    check_empty_value CASSANDRA_PASSWORD
    check_empty_value CASSANDRA_RACK
    check_empty_value CASSANDRA_DATACENTER

    check_default_password CASSANDRA_PASSWORD

    if [[ "$CASSANDRA_CLIENT_ENCRYPTION" = "true" || "$CASSANDRA_INTERNODE_ENCRYPTION" = "true" ]]; then
        check_empty_value CASSANDRA_KEYSTORE_PASSWORD
        check_empty_value CASSANDRA_TRUSTSTORE_PASSWORD
        check_default_password CASSANDRA_KEYSTORE_PASSWORD
        check_default_password CASSANDRA_TRUSTSTORE_PASSWORD
    fi

    check_yes_no_value CASSANDRA_PASSWORD_SEEDER
    check_true_false_value CASSANDRA_ENABLE_REMOTE_CONNECTIONS
    check_true_false_value CASSANDRA_CLIENT_ENCRYPTION
    check_positive_value CASSANDRA_NUM_TOKENS
    check_positive_value CASSANDRA_INIT_MAX_RETRIES
    check_positive_value CASSANDRA_CQL_MAX_RETRIES
    check_positive_value CASSANDRA_PEER_CQL_MAX_RETRIES
    check_positive_value CASSANDRA_INIT_SLEEP_TIME
    check_positive_value CASSANDRA_CQL_SLEEP_TIME
    check_positive_value CASSANDRA_PEER_CQL_SLEEP_TIME
    check_positive_value CASSANDRA_CQL_PORT_NUMBER
    check_positive_value CASSANDRA_JMX_PORT_NUMBER
    check_positive_value CASSANDRA_TRANSPORT_PORT_NUMBER

    check_conflicting_ports CASSANDRA_CQL_PORT_NUMBER CASSANDRA_JMX_PORT_NUMBER CASSANDRA_TRANSPORT_PORT_NUMBER

    check_allowed_port CASSANDRA_CQL_PORT_NUMBER
    check_allowed_port CASSANDRA_TRANSPORT_PORT_NUMBER
    check_allowed_port CASSANDRA_JMX_PORT_NUMBER

    check_resolved_hostname "$CASSANDRA_HOST"
    for peer in ${CASSANDRA_PEERS//,/ }; do
        check_resolved_hostname "$peer"
    done
    for seed in ${CASSANDRA_SEEDS//,/ }; do
        check_resolved_hostname "$seed"
    done

    if (( ${#CASSANDRA_PASSWORD} > 512 )); then
        print_validation_error "The password cannot be longer than 512 characters. Set the environment variable CASSANDRA_PASSWORD with a shorter value"
    fi

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Check if a given configuration file was mounted externally
# Globals:
#   CASSANDRA_*
# Arguments:
#   $1 - Filename
# Returns:
#   true if the file was mounted externally, false otherwise
#########################
cassandra_is_file_external() {
    local -r filename="${1:?file_is_missing}"
    if [[ -f "${CASSANDRA_MOUNTED_CONF_DIR}/${filename}" ]]; then
        true
    else
        false
    fi
}

########################
# Copy mounted configuration files
# Globals:
#   CASSANDRA_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_copy_mounted_config() {
    if ! is_dir_empty "$CASSANDRA_MOUNTED_CONF_DIR"; then
        cp -Lr "$CASSANDRA_MOUNTED_CONF_DIR"/* "$CASSANDRA_CONF_DIR"
    fi
}

########################
# Copy default configuration files in case there are no mounted ones
# Globals:
#   CASSANDRA_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_copy_default_config() {
    local -r tmp_file_list=/tmp/conf_file_list
    find "$CASSANDRA_DEFAULT_CONF_DIR" -type f > $tmp_file_list
    while read -r f; do
        filename="${f#${CASSANDRA_DEFAULT_CONF_DIR}/}" # Get path with subfolder
        dest="$(echo $f | sed "s?$CASSANDRA_DEFAULT_CONF_DIR?$CASSANDRA_CONF_DIR?g")"
        if [[ -f "$dest" ]]; then
            debug "Found ${filename}. Skipping default"
        else
            debug "No injected ${filename} file found. Creating default ${filename} file"
            # There are conf files in subfolders. We may need to create them
            mkdir -p "$(dirname $dest)"
            cp "$f" "$dest"
        fi
    done < $tmp_file_list
    rm "$tmp_file_list"
}

########################
# Configure the path to the different data directories (ignored if cassandra.yaml is mounted)
# Globals:
#   CASSANDRA_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_setup_data_dirs() {
    if ! cassandra_is_file_external "cassandra.yaml"; then
        cassandra_yaml_set_as_array data_file_directories "${CASSANDRA_DATA_DIR}/data" $CASSANDRA_CONF_FILE

        cassandra_yaml_set commitlog_directory "${CASSANDRA_DATA_DIR}/commitlog"
        cassandra_yaml_set hints_directory "${CASSANDRA_DATA_DIR}/hints"
        cassandra_yaml_set cdc_raw_directory "${CASSANDRA_DATA_DIR}/cdc_raw"
        cassandra_yaml_set saved_caches_directory "${CASSANDRA_DATA_DIR}/saved_caches"
    else
        debug "cassandra.yaml mounted. Skipping data directory configuration"
    fi
}

########################
# Enable password-based authentication (ignored if cassandra.yaml is mounted)
# Globals:
#   CASSANDRA_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_enable_auth() {
    if ! cassandra_is_file_external "cassandra.yaml"; then
        cassandra_yaml_set "authenticator" "PasswordAuthenticator"
        cassandra_yaml_set "authorizer" "CassandraAuthorizer"
    else
        debug "cassandra.yaml mounted. Skipping authentication method configuration"
    fi
}

########################
# Configure logging settings (ignored if logback.xml is mounted)
# Globals:
#   CASSANDRA_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_setup_logging() {
    if ! cassandra_is_file_external "logback.xml"; then
        replace_in_file "${CASSANDRA_CONF_DIR}/logback.xml" "system[.]log" "cassandra.log"
        replace_in_file "${CASSANDRA_CONF_DIR}/logback.xml" "(<appender-ref\s+ref=\"ASYNCDEBUGLOG\"\s+\/>)" "<!-- \1 -->"
    else
        debug "logback.xml mounted. Skipping logging configuration"
    fi
}

########################
# Configure cluster settings (modifies cassandra.yaml and cassandra-env.sh if not mounted)
# Globals:
#   CASSANDRA_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_setup_cluster() {
    local host="127.0.0.1"
    local rpc_address="127.0.0.1"
    local cassandra_config

    if [[ "$CASSANDRA_ENABLE_REMOTE_CONNECTIONS" = "true" ]]; then
        host="$CASSANDRA_HOST"
        rpc_address="0.0.0.0"
    fi
    # cassandra.yaml changes
    if ! cassandra_is_file_external "cassandra.yaml"; then
        cassandra_yaml_set "num_tokens" "$CASSANDRA_NUM_TOKENS" "no"
        cassandra_yaml_set "cluster_name" "$CASSANDRA_CLUSTER_NAME"
        cassandra_yaml_set "listen_address" "$host"
        cassandra_yaml_set "seeds" "$CASSANDRA_SEEDS"
        cassandra_yaml_set "start_rpc" "$CASSANDRA_ENABLE_RPC" "no"
        cassandra_yaml_set "rpc_address" "$rpc_address"
        cassandra_yaml_set "broadcast_rpc_address" "$host"
        cassandra_yaml_set "endpoint_snitch" "$CASSANDRA_ENDPOINT_SNITCH"
        cassandra_yaml_set "internode_encryption" "$CASSANDRA_INTERNODE_ENCRYPTION"
        cassandra_yaml_set "keystore" "$CASSANDRA_KEYSTORE_LOCATION"
        cassandra_yaml_set "keystore_password" "$CASSANDRA_KEYSTORE_PASSWORD"
        cassandra_yaml_set "truststore" "$CASSANDRA_TRUSTSTORE_LOCATION"
        cassandra_yaml_set "truststore_password" "$CASSANDRA_TRUSTSTORE_PASSWORD"

        cassandra_config="$(sed -E "/client_encryption_options:.*/ {N; s/client_encryption_options:[^\n]*\n\s{4}enabled:.*/client_encryption_options:\n    enabled: $CASSANDRA_CLIENT_ENCRYPTION/g}" "$CASSANDRA_CONF_FILE")"
        echo "$cassandra_config" > "$CASSANDRA_CONF_FILE"
    else
        debug "cassandra.yaml mounted. Skipping cluster configuration"
    fi

    # cassandra-env.sh changes
    if ! cassandra_is_file_external "cassandra-env.sh"; then
        replace_in_file "${CASSANDRA_CONF_DIR}/cassandra-env.sh" "#\s*JVM_OPTS=\"\$JVM_OPTS -Djava[.]rmi[.]server[.]hostname=[^\"]*" "JVM_OPTS=\"\$JVM_OPTS -Djava.rmi.server.hostname=${host}"
    else
        debug "cassandra-env.sh mounted. Skipping setting server hostname"
    fi
}

########################
# Configure java path (ignored if cassandra-env.sh is mounted)
# Globals:
#   CASSANDRA_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_setup_java() {
    if ! cassandra_is_file_external "cassandra-env.sh"; then
        replace_in_file "${CASSANDRA_CONF_DIR}/cassandra-env.sh" "(calculate_heap_sizes\(\))" "\nJAVA_HOME=$JAVA_BASE_DIR\nJAVA=$JAVA_BIN_DIR/java\n\n\1"
    else
        debug "cassandra-env.sh mounted. Skipping JAVA_HOME configuration"
    fi
}

########################
# Change the password for the cassandra user
# Globals:
#   CASSANDRA_*
# Arguments:
#   1 - Old password (default: cassandra)
#   2 - New Password (default: $CASSANDRA_PASSWORD)
#   3 - Maximum number of retries (default: $CASSANDRA_CQL_MAX_RETRIES)
#   4 - Sleep time between retries (default: $CASSANDRA_CQL_SLEEP_TIME)
# Returns:
#   None
#########################
cassandra_change_cassandra_password() {
    local -r old_password="${1:-cassandra}"
    local -r new_password="${2:-$CASSANDRA_PASSWORD}"
    local -r retries="${3:-$CASSANDRA_CQL_MAX_RETRIES}"
    local -r sleep_time="${4:-$CASSANDRA_CQL_SLEEP_TIME}"

    info 'Updating the password for the "cassandra" user...'
    local -r user="cassandra"
    local -r escaped_password="${new_password//\'/\'\'}"

    local passwordChanged=no

    if (echo "ALTER USER cassandra WITH PASSWORD \$\$${escaped_password}\$\$;" | cassandra_execute_with_retries "$retries" "$sleep_time" "$user" "$old_password"); then
        debug "ALTER USER command executed. Trying to log in"
        wait_for_cql_access "$user" "$new_password" "" "$retries" "$sleep_time"
        info "Password updated successfully"
    fi
}

########################
# Create a new admin user
# Globals:
#   CASSANDRA_*
# Arguments:
#   1 - New username (default: $CASSANDRA_USER)
#   2 - New user password (default: $CASSANDRA_PASSWORD)
#   3 - Admin username (which will create the new user) (default: cassandra)
#   4 - Admin password (default: cassandra)
#   5 - Maximum number of retries (default: $CASSANDRA_CQL_MAX_RETRIES)
#   6 - Sleep time between retries (default: $CASSANDRA_CQL_SLEEP_TIME)
# Returns:
#   None
#########################
cassandra_create_admin_user() {
    local -r new_user="${1:-$CASSANDRA_USER}"
    local -r password="${2:-$CASSANDRA_PASSWORD}"
    local -r admin_user="${3:-cassandra}"
    local -r admin_user_password="${4:-cassandra}"
    local -r retries="${5:-$CASSANDRA_CQL_MAX_RETRIES}"
    local -r sleep_time="${6:-$CASSANDRA_CQL_SLEEP_TIME}"

    info "Creating super-user $new_user"
    local -r escaped_password="${password//\'/\'\'}"

    echo "CREATE USER '${new_user}' WITH PASSWORD \$\$${escaped_password}\$\$ SUPERUSER;" | cassandra_execute_with_retries "$retries" "$sleep_time" "$admin_user" "$admin_user_password"
}

########################
# Configure port binding (modifies cassandra.yaml and cassandra-env.sh if not mounted)
# Globals:
#   CASSANDRA_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_setup_ports() {
    if ! cassandra_is_file_external "cassandra.yaml"; then
        cassandra_yaml_set "native_transport_port" "$CASSANDRA_CQL_PORT_NUMBER" "no"
        cassandra_yaml_set "storage_port" "$CASSANDRA_TRANSPORT_PORT_NUMBER" "no"
    else
        debug "cassandra.yaml mounted. Skipping native and storage ports configuration"
    fi

    if ! cassandra_is_file_external "cassandra-env.sh"; then
        replace_in_file "${CASSANDRA_CONF_DIR}/cassandra-env.sh" "JMX_PORT=.*" "JMX_PORT=$CASSANDRA_JMX_PORT_NUMBER"
    else
        debug "cassandra-env.sh mounted. Skipping JMX port configuration"
    fi
}

########################
# Configure rack and datacenter (ignored if cassandra-rackdc.properties is mounted)
# Globals:
#   CASSANDRA_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_setup_rack_dc() {
    if ! cassandra_is_file_external "cassandra-rackdc.properties"; then
        replace_in_file "${CASSANDRA_CONF_DIR}/cassandra-rackdc.properties" "dc=.*" "dc=${CASSANDRA_DATACENTER}"
        replace_in_file "${CASSANDRA_CONF_DIR}/cassandra-rackdc.properties" "rack=.*" "rack=${CASSANDRA_RACK}"
    else
        debug "cassandra-rackdc.properties mounted. Skipping rack and datacenter configuration"
    fi
}

########################
# Remove PIDs, log files and conf files from a previous run (case of container restart)
# Globals:
#   CASSANDRA_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_clean_from_restart() {
    rm -f "$CASSANDRA_PID_FILE"
    rm -f "$CASSANDRA_FIRST_BOOT_LOG_FILE" "$CASSANDRA_INITSCRIPTS_BOOT_LOG_FILE"
    if ! is_dir_empty "$CASSANDRA_CONF_DIR"; then
        rm -rf "$CASSANDRA_CONF_DIR"/*
    fi
}

########################
# Ensure Cassandra is initialized
# Globals:
#   CASSANDRA_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_initialize() {
    info "Initializing Cassandra database..."

    cassandra_clean_from_restart
    cassandra_copy_mounted_config
    cassandra_copy_default_config
    cassandra_enable_auth
    cassandra_setup_java
    cassandra_setup_logging
    cassandra_setup_ports
    cassandra_setup_rack_dc
    cassandra_setup_data_dirs
    cassandra_setup_cluster

    debug "Ensuring expected directories/files exist..."
    for dir in "$CASSANDRA_DATA_DIR" "$CASSANDRA_TMP_DIR" "$CASSANDRA_LOG_DIR"; do
        ensure_dir_exists "$dir"
        am_i_root && chown -R "$CASSANDRA_DAEMON_USER:$CASSANDRA_DAEMON_GROUP" "$dir"
    done

    if ! is_dir_empty "$CASSANDRA_DATA_DIR"; then
        info "Deploying Cassandra with persisted data"
    else
        info "Deploying Cassandra from scratch"
        cassandra_start_bg "$CASSANDRA_FIRST_BOOT_LOG_FILE"
        if is_boolean_yes "$CASSANDRA_PASSWORD_SEEDER"; then
            info "Password seeder node"
            # Check that all peers are ready
            for peer in ${CASSANDRA_PEERS//,/ }; do
                wait_for_cql_access "cassandra" "cassandra" "$peer" "$CASSANDRA_PEER_CQL_MAX_RETRIES" "$CASSANDRA_PEER_CQL_SLEEP_TIME"
            done
            # Setup user
            if [[ "$CASSANDRA_USER" = "cassandra" ]]; then
                cassandra_change_cassandra_password
            else
                cassandra_create_admin_user
            fi

            cassandra_execute_startup_cql
        else
            info "Non-seeder node. Waiting for synchronization"
            wait_for_cql_access "$CASSANDRA_USER" "$CASSANDRA_PASSWORD" "" "$CASSANDRA_PEER_CQL_MAX_RETRIES" "$CASSANDRA_PEER_CQL_SLEEP_TIME"
        fi
    fi
}

########################
# Execute Cassandra startup cql (defined in CASSANDRA_STARTUP_CQL)
# Globals:
#   CASSANDRA_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_execute_startup_cql() {
    if [[ -n "$CASSANDRA_STARTUP_CQL" ]]; then
        info "Executing Startup CQL"
        if ! (echo "$CASSANDRA_STARTUP_CQL" | cassandra_execute_with_retries "$CASSANDRA_CQL_MAX_RETRIES" "$CASSANDRA_CQL_SLEEP_TIME" "$CASSANDRA_USER" "$CASSANDRA_PASSWORD"); then
            error "Failed executing startup CQL command"
            exit 1
        fi
        info "Startup CQL commands executed successfully"
    fi
}

########################
# Run custom initialization scripts
# Globals:
#   CASSANDRA_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_custom_init_scripts() {
    if [[ -n $(find "$CASSANDRA_INITSCRIPTS_DIR/" -type f -regex ".*\.\(sh\|cql\|cql.gz\)") ]] && [[ ! -f "$CASSANDRA_VOLUME_DIR/.user_scripts_initialized" ]] ; then
        info "Loading user's custom files from $CASSANDRA_INITSCRIPTS_DIR ..."
        local -r tmp_file="/tmp/filelist"
        if ! is_cassandra_running; then
            cassandra_start_bg "$CASSANDRA_INITSCRIPTS_BOOT_LOG_FILE"
            wait_for_cql_access
        fi
        find "${CASSANDRA_INITSCRIPTS_DIR}/" -type f -regex ".*\.\(sh\|cql\|cql.gz\)" | sort > "$tmp_file"
        while read -r f; do
            case "$f" in
                *.sh)
                    if [[ -x "$f" ]]; then
                        debug "Executing $f"; "$f"
                    else
                        debug "Sourcing $f"; . "$f"
                    fi
                    ;;
                *.cql)    debug "Executing $f"; cassandra_execute "$CASSANDRA_USER" "$CASSANDRA_PASSWORD" < "$f";;
                *.cql.gz) debug "Executing $f"; gunzip -c "$f" | cassandra_execute "$CASSANDRA_USER" "$CASSANDRA_PASSWORD";;
                *)        debug "Ignoring $f" ;;
            esac
        done < $tmp_file
        rm -f "$tmp_file"
        touch "$CASSANDRA_VOLUME_DIR"/.user_scripts_initialized
    fi
}

########################
# Execute an arbitrary query/queries against the running Cassandra service
# Stdin:
#   Query/queries to execute
# Globals:
#   BITNAMI_DEBUG
#   CASSANDRA_*
# Arguments:
#   $1 - User to run queries
#   $2 - Password
#   $3 - Keyspace
#   $4 - Host (default: localhost)
#   $5 - Extra flags
# Returns:
#   None
#######################
cassandra_execute() {
    local -r user="${1:-$CASSANDRA_USER}"
    local -r pass="${2:-$CASSANDRA_PASSWORD}"
    local -r keyspace="${3:-}"
    local -r host="${4:-localhost}"
    local -r extra_args="${5:-}"
    local -r cmd=("${CASSANDRA_BIN_DIR}/cqlsh")
    local args=( "-u" "$user" "-p" "$pass")

    [[ -n "$keyspace" ]] && args+=("-k" "$keyspace")
    [[ -n "$extra_args" ]] && args+=($extra_args)
    args+=("$host")
    if [[ "${BITNAMI_DEBUG}" = true ]]; then
        local -r command="$(cat)"
        debug "Executing CQL \"$command\""
        echo "$command" | "${cmd[@]}" "${args[@]}"
    else
        "${cmd[@]}" "${args[@]}" >/dev/null 2>&1
    fi
}

########################
# Execute an arbitrary query/queries against the running Cassandra service with retries (in case Cassandra is still initializing or performing consistency operations)
# Stdin:
#   Query/queries to execute
# Globals:
#   BITNAMI_DEBUG
#   CASSANDRA_*
# Arguments:
#   $1 - Maximum number of retries (default: $CASSANDRA_CQL_MAX_RETRIES)
#   $2 - Sleep time between retries (default: $CASSANDRA_CQL_SLEEP_TIME)
#   $3 - User to run queries
#   $4 - Password
#   $5 - Keyspace
#   $6 - Host (default: localhost)
#   $7 - Extra flags
# Returns:
#   None
#######################
cassandra_execute_with_retries() {
    local -r retries="${1:-$CASSANDRA_CQL_MAX_RETRIES}"
    local -r sleep_time="${2:-$CASSANDRA_CQL_SLEEP_TIME}"
    local -r user="${3:-$CASSANDRA_USER}"
    local -r pass="${4:-$CASSANDRA_PASSWORD}"
    local -r keyspace="${5:-}"
    local -r host="${6:-localhost}"
    local -r extra_args="${7:-}"

    local success=no

    # Get command from stdin as we will retry it several times
    local -r command="$(cat)"

    for i in $(seq 1 $retries); do
        if (echo "$command" | cassandra_execute "$user" "$pass" "$keyspace" "$host" "$extra_args"); then
            success=yes
            break;
        fi
        sleep "$sleep_time"
    done
    if is_boolean_yes "$success"; then
        true
    else
        error "CQL command failed $retries times"
        false
    fi
}

########################
# Wait until nodetool checks the node is ready
# Globals:
#   BITNAMI_DEBUG
#   CASSANDRA_*
# Arguments:
#   $1 - Maximum number of retries (default $CASSANDRA_INIT_MAX_RETRIES)
#   $2 - Sleep time during retries (default $CASSANDRA_INIT_SLEEP_TIME)
# Returns:
#   None
#########################
wait_for_nodetool_up() {
    local -r retries="${2:-$CASSANDRA_INIT_MAX_RETRIES}"
    local -r sleep_time="${3:-$CASSANDRA_INIT_SLEEP_TIME}"

    debug "Checking status with nodetool"

    check_function_nodetool() {
        local -r check_cmd=("${CASSANDRA_BIN_DIR}/nodetool")
        local -r check_args=("status" "--port" "$CASSANDRA_JMX_PORT_NUMBER")
        local -r machine_ip="$(dns_lookup "$CASSANDRA_HOST")"
        local -r check_regex="UN\s*(${CASSANDRA_HOST}|${machine_ip}|127.0.0.1)"
        local output="/dev/null"
        if [[ "$BITNAMI_DEBUG" = "true" ]]; then
            output="/dev/stdout"
        fi
        "${check_cmd[@]}" "${check_args[@]}" | grep -E "${check_regex}" > "${output}"
    }

    if retry_while check_function_nodetool "$retries" "$sleep_time"; then
        info "Nodetool reported the successful startup of Cassandra"
        true
    else
        error "Cassandra failed to start up"
        if [[ "$BITNAMI_DEBUG" = "true" ]]; then
            error "Nodetool output"
            "${check_cmd[@]}" "${check_args[@]}"
        fi
        exit 1
    fi
}

########################
# Wait until the log file shows that CQL is ready
# Globals:
#   BITNAMI_DEBUG
#   CASSANDRA_*
# Arguments:
#   $1 - Log file to check
#   $1 - Maximum number of retries (default $CASSANDRA_INIT_MAX_RETRIES)
#   $2 - Sleep time during retries (default $CASSANDRA_INIT_SLEEP_TIME)
# Returns:
#   None
#########################
wait_for_cql_log_entry() {
    local -r logger="${1:-/dev/stdout}"
    local -r retries="${2:-$CASSANDRA_INIT_MAX_RETRIES}"
    local -r sleep_time="${3:-$CASSANDRA_INIT_SLEEP_TIME}"

    debug "Checking that log $logger contains entry \"Starting listening for CQL clients\""

    check_function_log_entry() {
        local -r check_cmd=("cat")
        local -r check_args=("$logger")
        local -r check_regex="Starting listening for CQL clients"

        local output="/dev/null"
        if [[ "$BITNAMI_DEBUG" = "true" ]]; then
            output="/dev/stdout"
        fi
        "${check_cmd[@]}" "${check_args[@]}" | grep -E "${check_regex}" > "${output}"
    }

    if retry_while check_function_log_entry "$retries" "$sleep_time"; then
        info "Found CQL startup log line"
    else
        error "Cassandra failed to start up"
        if [[ "$BITNAMI_DEBUG" = "true" ]]; then
            error "Log content"
            cat "$logger"
        fi
        exit 1
    fi
}

########################
# Poll until the CQL command DESCRIBE KEYSPACES works successfully
# Globals:
#   CASSANDRA_*
# Arguments:
#   1 - Username (default: $CASSANDRA_USER)
#   2 - Password (default: $CASSANDRA_PASSWORD)
#   3 - Hostname (default: $CASSANDRA_HOST)
#   4 - Maximum number of retries (default: $CASSANDRA_CQL_MAX_RETRIES)
#   5 - Sleep time between retries (default: $CASSANDRA_CQL_SLEEP_TIME)
# Returns:
#   None
#########################
wait_for_cql_access() {
    local -r user="${1:-$CASSANDRA_USER}"
    local -r password="${2:-$CASSANDRA_PASSWORD}"
    local -r host="${3:-$CASSANDRA_HOST}"
    local -r max_retries="${4:-$CASSANDRA_CQL_MAX_RETRIES}"
    local -r sleep_time="${5:-$CASSANDRA_CQL_SLEEP_TIME}"

    info "Trying to access CQL server @ $host"
    if (echo "DESCRIBE KEYSPACES" | cassandra_execute_with_retries "$max_retries" "$sleep_time" "$user" "$password" "" "$host" ); then
        info "Accessed CQL server successfully"
    else
        error "Could not access CQL server"
        exit 1
    fi
}

########################
# Start Cassandra and wait until it is ready
# Globals:
#   CASSANDRA_*
# Arguments:
#   $1 - Log file to write (default /dev/stdout)
#   $2 - Maximum number of retries (default $CASSANDRA_INIT_MAX_RETRIES)
#   $3 - Sleep time during retries (default $CASSANDRA_INIT_SLEEP_TIME)
# Returns:
#   None
#########################
cassandra_start_bg() {
    local -r logger="${1:-/dev/stdout}"
    local -r retries="${2:-$CASSANDRA_INIT_MAX_RETRIES}"
    local -r sleep_time="${3:-$CASSANDRA_INIT_SLEEP_TIME}"

    info "Starting Cassandra"
    local -r cmd=("$CASSANDRA_BIN_DIR/cassandra")
    local -r args=("-p" "$CASSANDRA_PID_FILE" "-R" "-f")

    if am_i_root; then
        gosu "$CASSANDRA_DAEMON_USER" "${cmd[@]}" "${args[@]}" > "$logger" 2>&1 &
    else
        "${cmd[@]}" "${args[@]}" > "$logger" 2>&1 &
    fi

    # Even though we set the pid, cassandra is not creating the proper file, so we create it manually
    echo $! > "$CASSANDRA_PID_FILE"

    info "Checking that it started up correctly"

    if [[ "$logger" != "/dev/stdout" ]]; then
        am_i_root && chown "$CASSANDRA_DAEMON_USER":"$CASSANDRA_DAEMON_GROUP" "$logger"
        wait_for_cql_log_entry "$logger" "$retries" "$sleep_time"
    fi
    wait_for_nodetool_up "$retries" "$sleep_time"
}

########################
# Stop Cassandra
# Globals:
#   CASSANDRA_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_stop() {
    ! is_cassandra_running && return
    info "Stopping Cassandra..."
    "${CASSANDRA_BIN_DIR}/nodetool" stopdaemon
    # Manually remove PID file
    rm -f "$CASSANDRA_PID_FILE"
}

########################
# Check if Cassandra is running
# Globals:
#   CASSANDRA_*
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_cassandra_running() {
    local -r pid="$(get_pid_from_file "$CASSANDRA_PID_FILE")"

    if [[ -z "$pid" ]]; then
        false
    else
        is_service_running "$pid"
    fi
}
