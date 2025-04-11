#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Library for ScyllaDB

cassandra_validate_tls() {
    info "Validating TLS settings in DB_* env vars.."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    check_empty_value() {
        if is_empty_value "${!1}"; then
            print_validation_error "The $1 environment variable is empty or not set."
        fi
    }

    check_default_password() {
        if [[ "${!1}" = "cassandra" ]]; then
            warn "You set the environment variable $1=cassandra. This is the default value when bootstrapping ScyllaDB and should not be used in production environments."
        fi
    }
    if is_boolean_yes "$DB_CLIENT_ENCRYPTION" || is_boolean_yes "$DB_INTERNODE_ENCRYPTION"; then
        ! [[ -f "$DB_SSL_CERT_FILE" ]] && print_validation_error "Certificate file $DB_SSL_CERT_FILE does not exist. Please mount a certificate file in that location"
        ! [[ -f "$DB_SSL_KEY_FILE" ]] && print_validation_error "Certificate key file $DB_SSL_KEY_FILE does not exist. Please mount a certificate file in that location"
    fi

    [[ "$error_code" -eq 0 ]] || exit "$error_code"

}

########################
# Enable client encryption in configuration
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_enable_client_encryption() {
    local cassandra_config
    cassandra_config="$(sed -E "/client_encryption_options:.*/ {N; s/client_encryption_options:[^\n]*(\n\s+#.*)?(\n)# (\s+enabled:).*/client_encryption_options:\1\2\3 $DB_CLIENT_ENCRYPTION/g}" "$DB_CONF_FILE")"
    echo "$cassandra_config" >"$DB_CONF_FILE"
}

########################
# Configure Cassandra configuration files from environment variables
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_setup_from_environment_variables() {
    # Map environment variables to config properties for cassandra-env.sh
    for var in "${!SCYLLADB_CFG_ENV_@}"; do
        # shellcheck disable=SC2001
        key="$(echo "$var" | sed -e 's/^SCYLLADB_CFG_ENV_//g')"
        value="${!var}"
        cassandra_env_conf_set "$key" "$value"
    done
    # Map environment variables to config properties for cassandra-rackdc.properties
    for var in "${!SCYLLADB_CFG_RACKDC_@}"; do
        key="$(echo "$var" | sed -e 's/^SCYLLADB_CFG_RACKDC_//g' | tr '[:upper:]' '[:lower:]')"
        value="${!var}"
        cassandra_rackdc_conf_set "$key" "$value"
    done
    # Map environment variables to config properties for commitlog_archiving.properties
    for var in "${!SCYLLADB_CFG_COMMITLOG_@}"; do
        key="$(echo "$var" | sed -e 's/^SCYLLADB_CFG_COMMITLOG_//g' | tr '[:upper:]' '[:lower:]')"
        value="${!var}"
        cassandra_commitlog_conf_set "$key" "$value"
    done
    if ! cassandra_is_file_external "$DB_MOUNTED_CONF_PATH"; then
        # Map environment variables to config properties for configuration file
        for var in "${!SCYLLADB_CFG_YAML_@}"; do
            # shellcheck disable=SC2001
            key="$(echo "$var" | sed -e 's/^SCYLLADB_CFG_YAML_//g' | tr '[:upper:]' '[:lower:]')"
            value="${!var}"
            cassandra_yaml_set "$key" "$value"
        done
    else
        debug "$DB_MOUNTED_CONF_PATH mounted. Skipping data directory configuration"
    fi
}

########################
# Generate client configuration
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_setup_client_ssl() {
    # In the case of scylladb, we do not need to generate any keyfile. Maintaining
    # this function so we do not have to change the common cassandra initialization logic
    debug "ScyllaDB does not use java keystore/truststores, so we do not need to perform conversion"
}

########################
# Configure TLS certificates in configuration file
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_configure_certificates() {
    cassandra_yaml_set "certificate" "$DB_SSL_CERT_FILE"
    cassandra_yaml_set "keyfile" "$DB_SSL_KEY_FILE"
    if ! is_empty_value "$DB_SSL_CA_FILE"; then
        cassandra_yaml_set "truststore" "$DB_SSL_CA_FILE"
    fi
}

########################
# Configure port binding (modifies scylla.yaml and cassandra-env.sh if not mounted)
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_setup_ports() {
    cassandra_setup_common_ports
    if ! cassandra_is_file_external "${DB_MOUNTED_CONF_PATH}"; then
        cassandra_yaml_set "native_shard_aware_transport_port" "$SCYLLADB_CQL_SHARD_PORT_NUMBER" "no"
        cassandra_yaml_set "api_port" "$SCYLLADB_API_PORT_NUMBER" "no"
        cassandra_yaml_set "prometheus_port" "$SCYLLADB_PROMETHEUS_PORT_NUMBER" "no"
    else
        debug "${DB_MOUNTED_CONF_PATH} mounted. Skipping native shard aware and api ports configuration"
    fi
}

########################
# Start ScyllaDB and wait until it is ready
# Globals:
#   DB_*
# Arguments:
#   $1 - Log file to write (default /dev/stdout)
#   $2 - Maximum number of retries (default $DB_INIT_MAX_RETRIES)
#   $3 - Sleep time during retries (default $DB_INIT_SLEEP_TIME)
# Returns:
#   None
#########################
cassandra_start_bg() {
    local -r logger="${1:-/dev/stdout}"
    local -r retries="${2:-$DB_INIT_MAX_RETRIES}"
    local -r sleep_time="${3:-$DB_INIT_SLEEP_TIME}"

    info "Starting $DB_FLAVOR"
    local -r cmd=("$DB_BIN_DIR/scylla")
    local args=("--options-file" "$DB_CONF_FILE")
    if is_boolean_yes "$SCYLLADB_DEVELOPER_MODE"; then
        args+=("--developer-mode" "true")
    fi

    if am_i_root; then
        run_as_user "$DB_DAEMON_USER" "${cmd[@]}" "${args[@]}" >"$logger" 2>&1 &
    else
        "${cmd[@]}" "${args[@]}" >"$logger" 2>&1 &
    fi

    echo $! >"$DB_PID_FILE"

    info "Checking that it started up correctly"

    if [[ "$logger" != "/dev/stdout" ]]; then
        am_i_root && chown "$DB_DAEMON_USER":"$DB_DAEMON_GROUP" "$logger"
        wait_for_cql_log_entry "$logger" "$retries" "$sleep_time"
    fi
    if is_boolean_yes "$SCYLLADB_RUN_JMX_PROXY"; then
        local -r jmx_proxy_cmd=("$DB_BASE_DIR/supervisor/scylla-jmx.sh")
        if am_i_root; then
            run_as_user "$DB_DAEMON_USER" "${jmx_proxy_cmd[@]}" >>"$logger" 2>&1 &
        else
            "${jmx_proxy_cmd[@]}" >>"$logger" 2>&1 &
        fi
        echo $! >"$DB_TMP_DIR"/scylla-jmx.pid
        wait_for_nodetool_up "$retries" "$sleep_time"
    fi
}

########################
# Stop ScyllaDB
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_stop() {
    ! is_cassandra_running && return
    info "Stopping $DB_FLAVOR..."
    stop_scylladb() {
        stop_service_using_pid "$DB_PID_FILE"
        is_cassandra_not_running
    }
    if ! retry_while "stop_scylladb" "$DB_INIT_MAX_RETRIES" "$DB_INIT_SLEEP_TIME"; then
        error "$DB_FLAVOR failed to stop"
        exit 1
    fi
    # Manually remove PID file
    rm -f "$DB_PID_FILE"
}

#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Library for Cassandra common

# shellcheck disable=SC1090,SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libversion.sh

########################
# Returns cassandra major version
# Globals:
#   CASSANDRA_BASE_DIR
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_get_major_version() {
    cassandra_version="$("${CASSANDRA_BASE_DIR}/bin/cassandra" -v)"
    major_version="$(get_sematic_version "$cassandra_version" 1)"
    echo "${major_version:-0}"
}

########################
# Change a Cassandra configuration yaml file by setting a property
# Globals:
#   DB_*
# Arguments:
#   $1 - property
#   $2 - value
#   $3 - Use quotes in value (default: yes)
#   $4 - Path to configuration file (default: $DB_CONF_FILE)
# Returns:
#   None
#########################
cassandra_yaml_set() {
    local -r property="${1:?missing property}"
    local -r value="${2:?missing value}"
    local -r use_quotes="${3:-yes}"
    local -r conf_file="${4:-$DB_CONF_FILE}"

    if is_boolean_yes "$use_quotes"; then
        replace_in_file "$conf_file" "^(\s*)(#\s*)?(\s*)(\-\s*)?${property}:.*" "\1\3\4${property}: '${value}'"
    else
        replace_in_file "$conf_file" "^(\s*)(#\s*)?(\s*)(\-\s*)?${property}:.*" "\1\3\4${property}: ${value}"
    fi
}

#########################
# Set default Cassandra settings if not set
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_set_default_host() {
    if [[ -z "${DB_HOST:-}" ]]; then
        warn "DB_HOST not set, defaulting to system hostname"
        local -r host="$(hostname)"
        export DB_HOST="$host"
        export DB_SEEDS="${DB_SEEDS:-$DB_HOST}"
        export DB_PEERS="${DB_PEERS:-$DB_SEEDS}"
    fi
}

########################
# Change a Cassandra configuration yaml file by setting a property as an array
# Globals:
#   DB_*
# Arguments:
#   $1 - property
#   $2 - comma-separated string with the different values
#   $3 - Use quotes in value (default: no)
#   $4 - Path to configuration file (default: $DB_CONF_FILE)
# Returns:
#   None
#########################
cassandra_yaml_set_as_array() {
    local -r property="${1:?missing property}"
    local -r array="${2:?missing value}"
    local -r use_quotes="${3:-no}"
    local -r conf_file="${4:-$DB_CONF_FILE}"
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
# Validate settings in DB_* environment variables
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_validate() {
    info "Validating settings in DB_* env vars.."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    empty_password_enabled_warn() {
        warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD}. For safety reasons, do not use this flag in a production environment."
    }

    empty_password_warn() {
        warn "You've not provided a password. Default password \"cassandra\" will be used. For safety reasons, please provide a secure password in a production environment."
    }

    empty_password_error() {
        print_validation_error "The $1 environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow the container to be started with blank passwords. This is recommended only for development."
    }

    check_default_password() {
        if [[ "${!1}" = "cassandra" ]]; then
            warn "You set the environment variable $1=cassandra. This is the default value when bootstrapping $DB_FLAVOR and should not be used in production environments."
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
                if (("${!i}" == "${!j}")); then
                    print_validation_error "${!i} and ${!j} are bound to the same port"
                fi
            done
        done
    }

    check_allowed_port() {
        local validate_port_args=()
        ! am_i_root && validate_port_args+=("-unprivileged")
        validate_port_args+=("${!1}")
        if ! err=$(validate_port "${validate_port_args[@]}"); then
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

    check_password_file DB_PASSWORD_FILE
    check_password_file DB_TRUSTSTORE_PASSWORD_FILE
    check_password_file DB_KEYSTORE_PASSWORD_FILE

    check_empty_value DB_RACK
    check_empty_value DB_DATACENTER

    if [[ -z $DB_PASSWORD ]]; then
        if ! is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
            empty_password_warn
            export DB_PASSWORD="cassandra"
        else
            empty_password_enabled_warn
        fi
    fi

    check_default_password DB_PASSWORD
    check_yes_no_value DB_PASSWORD_SEEDER
    check_true_false_value DB_ENABLE_REMOTE_CONNECTIONS
    check_true_false_value DB_CLIENT_ENCRYPTION
    check_true_false_value DB_ENABLE_USER_DEFINED_FUNCTIONS
    check_true_false_value DB_ENABLE_SCRIPTED_USER_DEFINED_FUNCTIONS
    check_positive_value DB_NUM_TOKENS
    check_positive_value DB_INIT_MAX_RETRIES
    check_positive_value DB_CQL_MAX_RETRIES
    check_positive_value DB_PEER_CQL_MAX_RETRIES
    check_positive_value DB_INIT_SLEEP_TIME
    check_positive_value DB_CQL_SLEEP_TIME
    check_positive_value DB_PEER_CQL_SLEEP_TIME
    check_positive_value DB_CQL_PORT_NUMBER
    check_positive_value DB_JMX_PORT_NUMBER
    check_positive_value DB_TRANSPORT_PORT_NUMBER

    check_conflicting_ports DB_CQL_PORT_NUMBER DB_JMX_PORT_NUMBER DB_TRANSPORT_PORT_NUMBER

    check_allowed_port DB_CQL_PORT_NUMBER
    check_allowed_port DB_TRANSPORT_PORT_NUMBER
    check_allowed_port DB_JMX_PORT_NUMBER

    check_resolved_hostname "$DB_HOST"
    for peer in ${DB_PEERS//,/ }; do
        check_resolved_hostname "$peer"
    done
    for seed in ${DB_SEEDS//,/ }; do
        check_resolved_hostname "$seed"
    done

    if [[ ! ${DB_AUTO_SNAPSHOT_TTL} =~ ([1-9]{1}[0-9]{0,}[d|h|m]) ]]; then
        print_validation_error "DB_AUTO_SNAPSHOT_TTL accepted units: d (days), h (hours) or m (minutes)"
    fi

    check_true_false_value DB_SSL_VALIDATE
    check_true_false_value DB_AUTOMATIC_SSTABLE_UPGRADE

    if ((${#DB_PASSWORD} > 512)); then
        print_validation_error "The password cannot be longer than 512 characters. Set the environment variable DB_PASSWORD with a shorter value"
    fi

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Check if a given configuration file was mounted externally
# Globals:
#   DB_*
# Arguments:
#   $1 - Filename
# Returns:
#   true if the file was mounted externally, false otherwise
#########################
cassandra_is_file_external() {
    local -r filename="${1:?file_is_missing}"
    if [[ -f "${DB_MOUNTED_CONF_DIR}/${filename}" ]]; then
        true
    else
        false
    fi
}

########################
# Copy mounted configuration files
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_copy_mounted_config() {
    if ! is_dir_empty "$DB_MOUNTED_CONF_DIR"; then
        cp -Lr "$DB_MOUNTED_CONF_DIR"/* "$DB_CONF_DIR"
    fi
}

########################
# Copy default configuration files in case there are no mounted ones
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_copy_default_config() {
    local -r tmp_file_list=/tmp/conf_file_list
    find "$DB_DEFAULT_CONF_DIR" -type f >$tmp_file_list
    while read -r f; do
        filename="${f#"${DB_DEFAULT_CONF_DIR}/"}" # Get path with subfolder
        dest="${f//$DB_DEFAULT_CONF_DIR/$DB_CONF_DIR}"
        if [[ -f "$dest" ]]; then
            debug "Found ${filename}. Skipping default"
        else
            debug "No injected ${filename} file found. Creating default ${filename} file"
            # There are conf files in subfolders. We may need to create them
            mkdir -p "$(dirname "$dest")"
            cp "$f" "$dest"
        fi
    done <$tmp_file_list
    rm "$tmp_file_list"
}

########################
# Configure the path to the different data directories (ignored if cassandra.yaml is mounted)
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_setup_data_dirs() {
    if ! cassandra_is_file_external "${DB_MOUNTED_CONF_PATH}"; then
        cassandra_yaml_set_as_array data_file_directories "${DB_DATA_DIR}/data" "$DB_CONF_FILE"

        cassandra_yaml_set commitlog_directory "$DB_COMMITLOG_DIR"
        cassandra_yaml_set hints_directory "${DB_DATA_DIR}/hints"
        cassandra_yaml_set cdc_raw_directory "${DB_DATA_DIR}/cdc_raw"
        cassandra_yaml_set saved_caches_directory "${DB_DATA_DIR}/saved_caches"
    else
        debug "${DB_MOUNTED_CONF_PATH} mounted. Skipping data directory configuration"
    fi
}

########################
# Enable password-based authentication (ignored if cassandra.yaml is mounted)
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_enable_auth() {
    if ! cassandra_is_file_external "${DB_MOUNTED_CONF_PATH}"; then
        if [[ "$ALLOW_EMPTY_PASSWORD" = "yes" ]] && [[ -z $DB_PASSWORD ]]; then
            if [[ "$DB_FLAVOR" = "scylladb" ]] || [ "$(cassandra_get_major_version)" -lt 5 ]; then
                cassandra_yaml_set "authenticator" "AllowAllAuthenticator"
            fi
            cassandra_yaml_set "authorizer" "AllowAllAuthorizer"
	else
            if [[ "$DB_FLAVOR" = "cassandra" ]] && [ "$(cassandra_get_major_version)" -ge 5 ]; then
	            replace_in_file "${DB_CONF_FILE}" "class_name.* AllowAllAuthenticator" "class_name: ${DB_AUTHENTICATOR}"
	            replace_in_file "${DB_CONF_FILE}" "class_name.* AllowAllAuthorizer" "class_name: ${DB_AUTHORIZER}"
            else
                cassandra_yaml_set "authenticator" "${DB_AUTHENTICATOR}"
                cassandra_yaml_set "authorizer" "${DB_AUTHORIZER}"
            fi
        fi
    else
        debug "${DB_MOUNTED_CONF_PATH} mounted. Skipping authentication method configuration"
    fi
}

########################
# Configure logging settings (ignored if logback.xml is mounted)
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_setup_logging() {
    if ! cassandra_is_file_external "${DB_MOUNTED_LOGBACK_PATH}"; then
        replace_in_file "${DB_LOGBACK_FILE}" "system[.]log" "${DB_FLAVOR}.log"
        if [[ "$BITNAMI_DEBUG" = "false" ]]; then
            replace_in_file "${DB_LOGBACK_FILE}" "(<appender-ref\s+ref=\"ASYNCDEBUGLOG\"\s+\/>)" "<!-- \1 -->"
        fi
    else
        debug "${DB_MOUNTED_LOGBACK_PATH} mounted. Skipping logging configuration"
    fi
}

########################
# Configure cluster settings (modifies cassandra.yaml and cassandra-env.sh if not mounted)
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_setup_cluster() {
    local host="127.0.0.1"
    local rpc_address="127.0.0.1"

    if [[ "$DB_ENABLE_REMOTE_CONNECTIONS" = "true" ]]; then
        host="$DB_HOST"
        rpc_address="0.0.0.0"
    fi
    # cassandra.yaml changes
    if ! cassandra_is_file_external "${DB_MOUNTED_CONF_PATH}"; then
        cassandra_yaml_set "num_tokens" "$DB_NUM_TOKENS" "no"
        cassandra_yaml_set "cluster_name" "$DB_CLUSTER_NAME"
        cassandra_yaml_set "listen_address" "$host"
        cassandra_yaml_set "seeds" "$DB_SEEDS"
        cassandra_yaml_set "start_rpc" "$DB_ENABLE_RPC" "no"
        if [[ "$DB_FLAVOR" = "scylladb" ]]; then
            # Ref: https://opensource.docs.scylladb.com/stable/cql/functions.html
            cassandra_yaml_set "enable_user_defined_functions" "$DB_ENABLE_USER_DEFINED_FUNCTIONS" "no"
        else
            # Ref: https://cassandra.apache.org/doc/stable/cassandra/configuration/cass_yaml_file.html#user_defined_functions_enabled
            cassandra_yaml_set "user_defined_functions_enabled" "$DB_ENABLE_USER_DEFINED_FUNCTIONS" "no"
            cassandra_yaml_set "scripted_user_defined_functions_enabled" "$DB_ENABLE_SCRIPTED_USER_DEFINED_FUNCTIONS" "no"
        fi
        cassandra_yaml_set "rpc_address" "$rpc_address"
        cassandra_yaml_set "broadcast_rpc_address" "$host"
        cassandra_yaml_set "endpoint_snitch" "$DB_ENDPOINT_SNITCH"
        cassandra_yaml_set "internode_encryption" "$DB_INTERNODE_ENCRYPTION"
        cassandra_configure_certificates
        cassandra_yaml_set "auto_snapshot_ttl" "$DB_AUTO_SNAPSHOT_TTL"

        if [[ -n "$DB_BROADCAST_ADDRESS" ]]; then
            cassandra_yaml_set "broadcast_address" "$DB_BROADCAST_ADDRESS"
        fi

        if [[ -n "$DB_AUTOMATIC_SSTABLE_UPGRADE" ]]; then
            cassandra_yaml_set "automatic_sstable_upgrade" "$DB_AUTOMATIC_SSTABLE_UPGRADE"
        fi

        cassandra_enable_client_encryption
    else
        debug "${DB_MOUNTED_CONF_PATH} mounted. Skipping cluster configuration"
    fi

    # cassandra-env.sh changes
    if ! cassandra_is_file_external "${DB_MOUNTED_ENV_PATH}"; then
        replace_in_file "${DB_ENV_FILE}" "#\s*JVM_OPTS=\"\$JVM_OPTS -Djava[.]rmi[.]server[.]hostname=[^\"]*" "JVM_OPTS=\"\$JVM_OPTS -Djava.rmi.server.hostname=${host}"
    else
        debug "${DB_MOUNTED_ENV_PATH} mounted. Skipping setting server hostname"
    fi
}

########################
# Configure java path (ignored if cassandra-env.sh is mounted)
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_setup_java() {
    if ! cassandra_is_file_external "${DB_MOUNTED_ENV_PATH}"; then
        replace_in_file "${DB_ENV_FILE}" "(calculate_heap_sizes\(\))" "\nJAVA_HOME=$JAVA_BASE_DIR\nJAVA=$JAVA_BIN_DIR/java\n\n\1"
    else
        debug "${DB_MOUNTED_ENV_PATH} mounted. Skipping JAVA_HOME configuration"
    fi
}

########################
# Configure jemalloc path (ignored if cassandra-env.sh is mounted)
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_setup_jemalloc() {
    if ! cassandra_is_file_external "${DB_MOUNTED_ENV_PATH}"; then
        if [[ -n "$(find_jemalloc_lib)" ]]; then
            echo "JVM_OPTS=\"\$JVM_OPTS -Dcassandra.libjemalloc=$(find_jemalloc_lib)\"" >>"${DB_CONF_DIR}/cassandra-env.sh"
        else
            warn "Couldn't find jemalloc installed. Skipping jemalloc configuration."
        fi
    else
        debug "${DB_MOUNTED_ENV_PATH} mounted. Skipping jemalloc configuration."
    fi
}

########################
# Change the password for the cassandra user
# Globals:
#   DB_*
# Arguments:
#   1 - Old password (default: cassandra)
#   2 - New Password (default: $DB_PASSWORD)
#   3 - Maximum number of retries (default: $DB_CQL_MAX_RETRIES)
#   4 - Sleep time between retries (default: $DB_CQL_SLEEP_TIME)
# Returns:
#   None
#########################
cassandra_change_cassandra_password() {
    local -r old_password="${1:-cassandra}"
    local -r new_password="${2:-$DB_PASSWORD}"
    local -r retries="${3:-$DB_CQL_MAX_RETRIES}"
    local -r sleep_time="${4:-$DB_CQL_SLEEP_TIME}"

    info 'Updating the password for the "cassandra" user...'
    local -r user="cassandra"
    local -r escaped_password="${new_password//\'/\'\'}"

    if (echo "ALTER USER cassandra WITH PASSWORD \$\$${escaped_password}\$\$;" | cassandra_execute_with_retries "$retries" "$sleep_time" "$user" "$old_password"); then
        debug "ALTER USER command executed. Trying to log in"
        wait_for_cql_access "$user" "$new_password" "" "$retries" "$sleep_time"
        info "Password updated successfully"
    fi
}

########################
# Create a new admin user
# Globals:
#   DB_*
# Arguments:
#   1 - New username (default: $DB_USER)
#   2 - New user password (default: $DB_PASSWORD)
#   3 - Admin username (which will create the new user) (default: cassandra)
#   4 - Admin password (default: cassandra)
#   5 - Maximum number of retries (default: $DB_CQL_MAX_RETRIES)
#   6 - Sleep time between retries (default: $DB_CQL_SLEEP_TIME)
# Returns:
#   None
#########################
cassandra_create_admin_user() {
    local -r new_user="${1:-$DB_USER}"
    local -r password="${2:-$DB_PASSWORD}"
    local -r admin_user="${3:-cassandra}"
    local -r admin_user_password="${4:-cassandra}"
    local -r retries="${5:-$DB_CQL_MAX_RETRIES}"
    local -r sleep_time="${6:-$DB_CQL_SLEEP_TIME}"

    info "Creating super-user $new_user"
    local -r escaped_password="${password//\'/\'\'}"

    echo "CREATE USER '${new_user}' WITH PASSWORD \$\$${escaped_password}\$\$ SUPERUSER;" | cassandra_execute_with_retries "$retries" "$sleep_time" "$admin_user" "$admin_user_password"
}

########################
# Configure common port binding (modifies cassandra.yaml and cassandra-env.sh if not mounted)
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_setup_common_ports() {
    if ! cassandra_is_file_external "${DB_MOUNTED_CONF_PATH}"; then
        cassandra_yaml_set "native_transport_port" "$DB_CQL_PORT_NUMBER" "no"
        cassandra_yaml_set "storage_port" "$DB_TRANSPORT_PORT_NUMBER" "no"
    else
        debug "${DB_MOUNTED_CONF_PATH} mounted. Skipping native and storage ports configuration"
    fi

    if ! cassandra_is_file_external "${DB_MOUNTED_ENV_PATH}"; then
        replace_in_file "${DB_ENV_FILE}" "JMX_PORT=.*" "JMX_PORT=$DB_JMX_PORT_NUMBER"
    else
        debug "${DB_MOUNTED_ENV_PATH} mounted. Skipping JMX port configuration"
    fi
}

########################
# Configure rack and datacenter (ignored if cassandra-rackdc.properties is mounted)
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_setup_rack_dc() {
    if ! cassandra_is_file_external "${DB_MOUNTED_RACKDC_PATH}"; then
        replace_in_file "${DB_RACKDC_FILE}" "^[#\s]*dc=.*" "dc=${DB_DATACENTER}"
        replace_in_file "${DB_RACKDC_FILE}" "^[#\s]*rack=.*" "rack=${DB_RACK}"
    else
        debug "${DB_MOUNTED_RACKDC_PATH} mounted. Skipping rack and datacenter configuration"
    fi
}

########################
# Remove PIDs, log files and conf files from a previous run (case of container restart)
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_clean_from_restart() {
    rm -f "$DB_PID_FILE"
    rm -f "$DB_FIRST_BOOT_LOG_FILE" "$DB_INITSCRIPTS_BOOT_LOG_FILE"
    if ! is_dir_empty "$DB_CONF_DIR"; then
        rm -rf "${DB_CONF_DIR:?}"/*
    fi
}

########################
# Ensure Cassandra is initialized
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_initialize() {
    info "Initializing $DB_FLAVOR database..."

    cassandra_clean_from_restart
    cassandra_copy_mounted_config
    cassandra_copy_default_config
    cassandra_enable_auth
    cassandra_setup_java
    cassandra_setup_jemalloc
    cassandra_setup_logging
    cassandra_setup_ports
    cassandra_setup_rack_dc
    cassandra_setup_data_dirs
    cassandra_setup_cluster
    cassandra_setup_from_environment_variables # Give priority to users configuration

    is_boolean_yes "$DB_CLIENT_ENCRYPTION" && cassandra_setup_client_ssl

    debug "Ensuring expected directories/files exist..."
    for dir in "$DB_DATA_DIR" "$DB_TMP_DIR" "$DB_LOG_DIR"; do
        ensure_dir_exists "$dir"
        am_i_root && chown -R "$DB_DAEMON_USER:$DB_DAEMON_GROUP" "$dir"
    done

    if ! is_dir_empty "$DB_DATA_DIR"; then
        info "Deploying $DB_FLAVOR with persisted data"
    else
        info "Deploying $DB_FLAVOR from scratch"
        cassandra_start_bg "$DB_FIRST_BOOT_LOG_FILE"
        if is_boolean_yes "$DB_PASSWORD_SEEDER"; then
            info "Password seeder node"
            # Check that all peers are ready
            for peer in ${DB_PEERS//,/ }; do
                wait_for_cql_access "cassandra" "cassandra" "$peer" "$DB_PEER_CQL_MAX_RETRIES" "$DB_PEER_CQL_SLEEP_TIME"
            done
            # Setup user
            if [[ "$DB_USER" = "cassandra" ]]; then
                cassandra_change_cassandra_password "cassandra" "$DB_PASSWORD" "$DB_CQL_MAX_RETRIES" "$DB_CQL_SLEEP_TIME"
            else
                cassandra_create_admin_user "$DB_USER" "$DB_PASSWORD" "cassandra" "cassandra" "$DB_CQL_MAX_RETRIES" "$DB_CQL_SLEEP_TIME"
            fi

            cassandra_execute_startup_cql
        else
            info "Non-seeder node. Waiting for synchronization"
            wait_for_cql_access "$DB_USER" "$DB_PASSWORD" "" "$DB_PEER_CQL_MAX_RETRIES" "$DB_PEER_CQL_SLEEP_TIME"
        fi
    fi
}

########################
# Execute Cassandra startup cql (defined in DB_STARTUP_CQL)
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_execute_startup_cql() {
    if [[ -n "$DB_STARTUP_CQL" ]]; then
        info "Executing Startup CQL"
        if ! (echo "$DB_STARTUP_CQL" | cassandra_execute_with_retries "$DB_CQL_MAX_RETRIES" "$DB_CQL_SLEEP_TIME" "$DB_USER" "$DB_PASSWORD"); then
            error "Failed executing startup CQL command"
            exit 1
        fi
        info "Startup CQL commands executed successfully"
    fi
}

########################
# Run custom initialization scripts
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
cassandra_custom_init_scripts() {
    if [[ -n "$(find "$DB_INITSCRIPTS_DIR/" \( -type f -o -type l \) -regex ".*\.\(sh\|cql\|cql.gz\)" ! -path "*/.*/*")" ]] && [[ ! -f "$DB_VOLUME_DIR/.user_scripts_initialized" ]]; then
        info "Loading user's custom files from $DB_INITSCRIPTS_DIR ..."
        local -r tmp_file="/tmp/filelist"
        if ! is_cassandra_running; then
            cassandra_start_bg "$DB_INITSCRIPTS_BOOT_LOG_FILE"
            wait_for_cql_access
        fi
        find "${DB_INITSCRIPTS_DIR}/" \( -type f -o -type l \) -regex ".*\.\(sh\|cql\|cql.gz\)" ! -path "*/.*/*" | sort >"$tmp_file"
        while read -r f; do
            case "$f" in
            *.sh)
                if [[ -x "$f" ]]; then
                    debug "Executing $f"
                    "$f"
                else
                    debug "Sourcing $f"
                    . "$f"
                fi
                ;;
            *.cql)
                debug "Executing $f"
                cassandra_execute "$DB_USER" "$DB_PASSWORD" <"$f"
                ;;
            *.cql.gz)
                debug "Executing $f"
                gunzip -c "$f" | cassandra_execute "$DB_USER" "$DB_PASSWORD"
                ;;
            *) debug "Ignoring $f" ;;
            esac
        done <$tmp_file
        rm -f "$tmp_file"
        touch "$DB_VOLUME_DIR"/.user_scripts_initialized
    fi
}

########################
# Execute an arbitrary query/queries against the running Cassandra service
# Stdin:
#   Query/queries to execute
# Globals:
#   BITNAMI_DEBUG
#   DB_*
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
    local -r user="${1:-$DB_USER}"
    local -r pass="${2:-$DB_PASSWORD}"
    local -r keyspace="${3:-}"
    local -r host="${4:-localhost}"
    local -r extra_args="${5:-}"
    local -r port="${DB_CQL_PORT_NUMBER}"
    local -r cmd=("cqlsh")
    local args=("-u" "$user" "-p" "$pass")

    is_boolean_yes "$DB_CLIENT_ENCRYPTION" && args+=("--ssl")
    [[ -n "$keyspace" ]] && args+=("-k" "$keyspace")
    if [[ -n "$extra_args" ]]; then
        local extra_args_array=()
        read -r -a extra_args_array <<<"$extra_args"
        [[ "${#extra_args[@]}" -gt 0 ]] && args+=("${extra_args_array[@]}")
    fi
    args+=("$host")
    args+=("$port")
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
#   DB_*
# Arguments:
#   $1 - Maximum number of retries (default: $DB_CQL_MAX_RETRIES)
#   $2 - Sleep time between retries (default: $DB_CQL_SLEEP_TIME)
#   $3 - User to run queries
#   $4 - Password
#   $5 - Keyspace
#   $6 - Host (default: localhost)
#   $7 - Extra flags
# Returns:
#   None
#######################
cassandra_execute_with_retries() {
    local -r retries="${1:-$DB_CQL_MAX_RETRIES}"
    local -r sleep_time="${2:-$DB_CQL_SLEEP_TIME}"
    local -r user="${3:-$DB_USER}"
    local -r pass="${4:-$DB_PASSWORD}"
    local -r keyspace="${5:-}"
    local -r host="${6:-localhost}"
    local -r extra_args="${7:-}"

    local success=no

    # Get command from stdin as we will retry it several times
    local -r command="$(cat)"

    for i in $(seq 1 "$retries"); do
        if (echo "$command" | cassandra_execute "$user" "$pass" "$keyspace" "$host" "$extra_args"); then
            success=yes
            break
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
#   DB_*
# Arguments:
#   $1 - Maximum number of retries (default $DB_INIT_MAX_RETRIES)
#   $2 - Sleep time during retries (default $DB_INIT_SLEEP_TIME)
# Returns:
#   None
#########################
wait_for_nodetool_up() {
    local -r retries="${1:-$DB_INIT_MAX_RETRIES}"
    local -r sleep_time="${2:-$DB_INIT_SLEEP_TIME}"

    debug "Checking status with nodetool"

    check_function_nodetool_node_ip() {
        # Using legacy RMI URL parsing to avoid URISyntaxException: 'Malformed IPv6 address at index 7: rmi://[127.0.0.1]:7199' error
        # https://community.datastax.com/questions/13764/java-version-for-cassandra-3113.html
        local -r check_cmd=("nodetool" "-Dcom.sun.jndi.rmiURLParsing=legacy")
        local -r check_args=("status" "--port" "$DB_JMX_PORT_NUMBER")
        local -r machine_ip="$(dns_lookup "${DB_BROADCAST_ADDRESS:-$DB_HOST}" "v4")"
        local -r check_regex="UN\s*(${DB_HOST}|${machine_ip}|127.0.0.1)"

        local output="/dev/null"
        if [[ "$BITNAMI_DEBUG" = "true" ]]; then
            output="/dev/stdout"
        fi

        "${check_cmd[@]}" "${check_args[@]}" | grep -E "${check_regex}" >"${output}"
    }

    check_function_nodetool_node_count() {
        # Using legacy RMI URL parsing to avoid URISyntaxException: 'Malformed IPv6 address at index 7: rmi://[127.0.0.1]:7199' error
        # https://community.datastax.com/questions/13764/java-version-for-cassandra-3113.html
        local -r check_cmd=("nodetool" "-Dcom.sun.jndi.rmiURLParsing=legacy")
        local -r check_args=("status" "--port" "$DB_JMX_PORT_NUMBER")
        local -r machine_ip="$(dns_lookup "${DB_BROADCAST_ADDRESS:-$DB_HOST}" "v4")"
        local -r check_regex="UN\s*"
        read -r -a host_list <<<"$(tr ',;' ' ' <<<"$DB_NODES")"
        local -r expected_node_count="${#host_list[@]}"
        local actual_node_count

        local output="/dev/null"
        if [[ "$BITNAMI_DEBUG" = "true" ]]; then
            output="/dev/stdout"
        fi

        actual_node_count=$("${check_cmd[@]}" "${check_args[@]}" | grep -c "${check_regex}" || true)
        if [[ "$expected_node_count" != "$actual_node_count" ]]; then
            false
        fi
    }

    if retry_while check_function_nodetool_node_ip "$retries" "$sleep_time"; then
        info "Nodetool reported the successful startup of $DB_FLAVOR"
        true
    else
        error "$DB_FLAVOR failed to start up"
        if [[ "$BITNAMI_DEBUG" = "true" ]]; then
            error "Nodetool output"
            "${check_cmd[@]}" "${check_args[@]}"
        fi
        exit 1
    fi

    if [[ -n "$DB_NODES" ]]; then
        if retry_while check_function_nodetool_node_count "$retries" "$sleep_time"; then
            info "All nodes reached the UN status (Up/Normal)"
            true
        else
            error "Some nodes did not reach the UN status (Up/Normal)"
            if [[ "$BITNAMI_DEBUG" = "true" ]]; then
                error "Nodetool output"
                "${check_cmd[@]}" "${check_args[@]}"
            fi
            exit 1
        fi
    fi
}

########################
# Wait until the log file shows that CQL is ready
# Globals:
#   BITNAMI_DEBUG
#   DB_*
# Arguments:
#   $1 - Log file to check
#   $1 - Maximum number of retries (default $DB_INIT_MAX_RETRIES)
#   $2 - Sleep time during retries (default $DB_INIT_SLEEP_TIME)
# Returns:
#   None
#########################
wait_for_cql_log_entry() {
    local -r logger="${1:-/dev/stdout}"
    local -r retries="${2:-$DB_INIT_MAX_RETRIES}"
    local -r sleep_time="${3:-$DB_INIT_SLEEP_TIME}"

    debug "Checking that log $logger contains entry \"Starting listening for CQL clients\""

    check_function_log_entry() {
        local -r check_cmd=("cat")
        local -r check_args=("$logger")
        local -r check_regex="Starting listening for CQL clients"

        local output="/dev/null"
        if [[ "$BITNAMI_DEBUG" = "true" ]]; then
            output="/dev/stdout"
        fi
        "${check_cmd[@]}" "${check_args[@]}" | grep -E "${check_regex}" >"${output}"
    }

    if retry_while check_function_log_entry "$retries" "$sleep_time"; then
        info "Found CQL startup log line"
    else
        error "$DB_FLAVOR failed to start up"
        error "Log content"
        cat "$logger"
        exit 1
    fi
}

########################
# Poll until the CQL command DESCRIBE KEYSPACES works successfully
# Globals:
#   DB_*
# Arguments:
#   1 - Username (default: $DB_USER)
#   2 - Password (default: $DB_PASSWORD)
#   3 - Hostname (default: $DB_HOST)
#   4 - Maximum number of retries (default: $DB_CQL_MAX_RETRIES)
#   5 - Sleep time between retries (default: $DB_CQL_SLEEP_TIME)
# Returns:
#   None
#########################
wait_for_cql_access() {
    local -r user="${1:-$DB_USER}"
    local -r password="${2:-$DB_PASSWORD}"
    local -r host="${3:-$DB_HOST}"
    local -r max_retries="${4:-$DB_CQL_MAX_RETRIES}"
    local -r sleep_time="${5:-$DB_CQL_SLEEP_TIME}"

    info "Trying to access CQL server @ $host"
    if (echo "DESCRIBE KEYSPACES" | cassandra_execute_with_retries "$max_retries" "$sleep_time" "$user" "$password" "" "$host"); then
        info "Accessed CQL server successfully"
    else
        error "Could not access CQL server"
        exit 1
    fi
}

########################
# Check if Cassandra is running
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_cassandra_running() {
    local -r pid="$(get_pid_from_file "$DB_PID_FILE")"

    if [[ -z "$pid" ]]; then
        false
    else
        is_service_running "$pid"
    fi
}

########################
# Return true if cassandra is not running
# Globals:
#   KONG_*
# Arguments:
#   None
# Returns:
#   None
#########################
is_cassandra_not_running() {
    ! is_cassandra_running
}

########################
# Set a configuration setting value to a file
# Globals:
#   None
# Arguments:
#   $1 - file
#   $2 - key
#   $3 - values (array)
# Returns:
#   None
#########################
cassandra_common_conf_set() {
    local -r file="${1:?missing file}"
    local -r key="${2:?missing key}"
    shift 2
    local values=("$@")

    if [[ "${#values[@]}" -eq 0 ]]; then
        stderr_print "missing value"
        return 1
    elif [[ "${#values[@]}" -ne 1 ]]; then
        for i in "${!values[@]}"; do
            cassandra_common_conf_set "$file" "${key[$i]}" "${values[$i]}"
        done
    else
        value="${values[0]}"
        # Check if the value was set before
        if grep -q "^[#\\s]*$key\s*=.*" "$file"; then
            # Update the existing key
            replace_in_file "$file" "^[#\\s]*${key}\s*=.*" "${key}=${value}" false
        else
            # Add a new key
            printf '\n%s=%s' "$key" "$value" >>"$file"
        fi
    fi
}

########################
# Set a configuration setting value to cassandra-env.sh
# Globals:
#   DB_CONF_DIR
# Arguments:
#   $1 - key
#   $2 - values (array)
# Returns:
#   None
#########################
cassandra_env_conf_set() {
    cassandra_common_conf_set "${DB_ENV_FILE}" "$@"
}

########################
# Set a configuration setting value to cassandra-rackdc.properties
# Globals:
#   DB_CONF_DIR
# Arguments:
#   $1 - key
#   $2 - values (array)
# Returns:
#   None
#########################
cassandra_rackdc_conf_set() {
    cassandra_common_conf_set "$DB_RACKDC_FILE" "$@"
}

########################
# Set a configuration setting value to commitlog_archiving.properties
# Globals:
#   DB_CONF_DIR
# Arguments:
#   $1 - key
#   $2 - values (array)
# Returns:
#   None
#########################
cassandra_commitlog_conf_set() {
    cassandra_common_conf_set "${DB_COMMITLOG_ARCHIVING_FILE}" "$@"
}

########################
# Find the path to the libjemalloc library file
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   Path to a libjemalloc shared object file
#########################
find_jemalloc_lib() {
    local -a locations=("/usr/lib" "/usr/lib64")
    local -r pattern='libjemalloc.so.[0-9]'
    local path
    for dir in "${locations[@]}"; do
        # Find the first element matching the pattern and quit
        [[ ! -d "$dir" ]] && continue
        path="$(find "$dir" -name "$pattern" -print -quit)"
        [[ -n "$path" ]] && break
    done
    echo "${path:-}"
}
