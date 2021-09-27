#!/bin/bash
#
# Bitnami Apache Geode library

# shellcheck disable=SC1090,SC1091

# Load generic libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libpersistence.sh
. /opt/bitnami/scripts/libvalidations.sh

########################
# Validate settings in GEODE_* env vars
# Globals:
#   GEODE_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
geode_validate() {
    debug "Validating settings in GEODE_* environment variables..."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }
    check_conflicting_ports() {
        local -r total="$#"
        for i in $(seq 1 "$((total - 1))"); do
            for j in $(seq "$((i + 1))" "$total"); do
                var_i="${!i}"
                var_j="${!j}"
                if [[ -n "${!var_i:-}" ]] && [[ -n "${!var_j:-}" ]] && [[ "${!var_i:-}" -eq "${!var_j:-}" ]]; then
                    print_validation_error "${var_i} and ${var_j} are bound to the same port"
                fi
            done
        done
    }
    check_resolved_hostname() {
        if ! is_hostname_resolved "$1"; then
            warn "Hostname ${1} could not be resolved, this could lead to connection issues"
        fi
    }
    check_empty_value() {
        if is_empty_value "${!1}"; then
            print_validation_error "${1} must be set"
        fi
    }
    check_yes_no_value() {
        if ! is_yes_no_value "${!1}" && ! is_true_false_value "${!1}"; then
            print_validation_error "The allowed values for ${1} are: yes no"
        fi
    }
    check_multi_value() {
        if [[ " ${2} " != *" ${!1} "* ]]; then
            print_validation_error "The allowed values for ${1} are: ${2}"
        fi
    }
    check_valid_port() {
        local port_var="${1:?missing port variable}"
        local err
        if ! err="$(validate_port "${!port_var}")"; then
            print_validation_error "An invalid port was specified in the environment variable ${port_var}: ${err}."
        fi
    }

    # Validate node type and log level
    check_empty_value "GEODE_NODE_TYPE"
    check_empty_value "GEODE_LOG_LEVEL"
    check_multi_value "GEODE_NODE_TYPE" "server locator"
    check_multi_value "GEODE_LOG_LEVEL" "severe error warning info config fine"

    # Validate hostname, bind addresses and ports
    for address in "$GEODE_ADVERTISED_HOSTNAME" "$GEODE_SERVER_BIND_ADDRESS" "$GEODE_HTTP_BIND_ADDRESS" "$GEODE_LOCATOR_BIND_ADDRESS"; do
        ! is_empty_value "$address" && ! validate_ipv4 "$address" && check_resolved_hostname "$address"
    done
    for port in "GEODE_SERVER_PORT_NUMBER" "GEODE_LOCATOR_PORT_NUMBER" "GEODE_HTTP_PORT_NUMBER" "GEODE_RMI_PORT_NUMBER"; do
        ! is_empty_value "${!port}" && check_valid_port "$port"
    done
    check_conflicting_ports "GEODE_SERVER_PORT_NUMBER" "GEODE_LOCATOR_PORT_NUMBER" "GEODE_HTTP_PORT_NUMBER" "GEODE_RMI_PORT_NUMBER"

    # Validate Apache Geode locators
    if ! is_empty_value "$GEODE_LOCATORS"; then
        local -r regexp="(([^\[/?#]+)(\[([0-9]+)\])?)?"
        read -r -a locators <<< "$(tr ',;' ' ' <<< "${GEODE_LOCATORS/%,/}")"
        for l in "${locators[@]}"; do
            if [[ "$l" =~ $regexp ]]; then
                check_resolved_hostname "${BASH_REMATCH[2]}"
            else
                print_validation_error "The locator \"$l\" doesn't follow the expected format"
            fi
        done
    fi

    # Validate Apache Geode security settings
    check_yes_no_value "GEODE_ENABLE_SECURITY"
    check_yes_no_value "GEODE_SECURITY_TLS_REQUIRE_AUTHENTICATION"
    check_yes_no_value "GEODE_SECURITY_TLS_ENDPOINT_IDENTIFICATION_ENABLED"
    if is_boolean_yes "$GEODE_ENABLE_SECURITY"; then
        if ! is_empty_value "$GEODE_SECURITY_TLS_COMPONENTS"; then
            check_empty_value "GEODE_SECURITY_TLS_PROTOCOLS"
            if [[ ! -f "$GEODE_SECURITY_TLS_KEYSTORE_FILE" || ! -f "$GEODE_SECURITY_TLS_TRUSTSTORE_FILE" ]]; then
                print_validation_error "In order to configure the TLS encryption for Apache Geode with JKS certs you must mount your geode.keystore.jks and geode.truststore.jks certs to the ${GEODE_MOUNTED_CONF_DIR}/certs directory."
            fi
        else
            # Security is enabled but TLS is not. Therefore, authentication using Security Manager is mandatory
            for var in "GEODE_SECURITY_MANAGER" "GEODE_SECURITY_USERNAME" "GEODE_SECURITY_PASSWORD"; do
                check_empty_value "$var"
            done
        fi
    else
        warn "You set the environment variable GEODE_ENABLE_SECURITY=${GEODE_ENABLE_SECURITY}. For safety reasons, enable Apache Geode security in a production environment."
    fi

    # Validation configuration files
    for file in "cache.xml" "gemfire.properties" "log4j2.xml"; do
        if [[ -f "${GEODE_CONF_DIR}/${file}" ]] || ! is_file_writable "${GEODE_CONF_DIR}/${file}"; then
            warn "A custom configuration file \"$file\" was found or the file is not writable. Configurations based on environment variables will not be applied for this file."
        fi
    done
    is_boolean_yes "$GEODE_ENABLE_SECURITY" && ! is_file_writable "$GEODE_SEC_CONF_FILE" && warn "${GEODE_SEC_CONF_FILE} is not writable. Configurations based on environment variables will not be applied for this file."

    return "$error_code"
}

########################
# Set a configuration setting value to the configuration file(s)
# Globals:
#   GEODE_*
# Arguments:
#   $1 - property key
#   $2 - property value
#   $3 - configuration file (optional)
# Returns:
#   None
#########################
geode_conf_set() {
    local -r key="${1:?key missing}"
    local -r value="${2:?value missing}"
    local -r file="${3:-"${GEODE_CONF_FILE}"}"

    # Sanitize key (sed does not support fixed string substitutions)
    local sanitized_pattern
    sanitized_pattern="^\s*(//\s*)?$(sed 's/[]\[^$.*/]/\\&/g' <<<"$key")\s*=.*"
    # Check if the configuration exists in the file
    if grep -sqE "$sanitized_pattern" "$file"; then
        # It exists, so replace the line
        replace_in_file "$file" "$sanitized_pattern" "${key} = ${value}"
    else
        # Add a new key
        printf '\n%s=%s' "$key" "$value" >>"$file"
    fi
}

########################
# Get a configuration setting value from the configuration file(s)
#     ref: https://geode.apache.org/docs/guide/112/reference/topics/gemfire_properties.html
# Globals:
#   GEODE_*
# Arguments:
#   $1 - property key
#   $2 - configuration file (optional)
# Returns:
#   String (empty string if file or key doesn't exist)
#########################
geode_conf_get() {
    local -r key="${1:?key missing}"
    local -r file="${2:-"${GEODE_CONF_FILE}"}"

    # Sanitize key (sed does not support fixed string substitutions)
    local sanitized_pattern
    sanitized_pattern="^\s*(//\s*)?$(sed 's/[]\[^$.*/]/\\&/g' <<<"$key")\s*=(.*)"
    grep -E "$sanitized_pattern" "$file" | sed -E "s|${sanitized_pattern}|\2|" | tr -d "\"' "
}

########################
# Creates Apache Geode configuration file
# Globals:
#   GEODE_*
# Arguments:
#   None
# Returns:
#   None
#########################
geode_create_config() {
    info "Creating Apache Geode configuration file"

    geode_conf_set "deploy-working-dir" "$GEODE_DATA_DIR"
    # Logging settings
    geode_conf_set "log-level" "$GEODE_LOG_LEVEL"
    # Enable JMX Manager
    geode_conf_set "jmx-manager" "true"
    geode_conf_set "jmx-manager-start" "true"
    # Hostnames and ports
    [[ -n "$GEODE_ADVERTISED_HOSTNAME" ]] && geode_conf_set "jmx-manager-hostname-for-clients" "$GEODE_ADVERTISED_HOSTNAME"
    [[ -n "$GEODE_RMI_BIND_ADDRESS" ]] && geode_conf_set "jmx-manager-bind-address" "$GEODE_RMI_BIND_ADDRESS"
    geode_conf_set "jmx-manager-port" "$GEODE_RMI_PORT_NUMBER"
    [[ -n "$GEODE_HTTP_BIND_ADDRESS" ]] && geode_conf_set "http-service-bind-address" "$GEODE_HTTP_BIND_ADDRESS"
    geode_conf_set "jmx-manager-http-port" "$GEODE_HTTP_PORT_NUMBER"
    geode_conf_set "http-service-port" "$GEODE_HTTP_PORT_NUMBER"
}

########################
# Configure a sammple SecurityManager based on the implementation below:
#     https://github.com/apache/geode/blob/develop/geode-core/src/main/java/org/apache/geode/examples/security/ExampleSecurityManager.java
# This implementation provides authentication and authorization based on a "security.json" JSON file
# Globals:
#   GEODE_*
# Arguments:
#   None
# Returns:
#   None
#########################
geode_configure_sample_security_manager() {
    if [[ "$GEODE_SECURITY_MANAGER" = "org.apache.geode.examples.security.ExampleSecurityManager" ]]; then
        if [[ ! -f "${GEODE_EXTENSIONS_DIR}/security.json" && -w "$GEODE_EXTENSIONS_DIR" ]]; then
            warn "No \"security.json\" file provided. Creating a very basic one (not suitable for production)"
            jq '.' > "${GEODE_EXTENSIONS_DIR}/security.json" <<EOF
{
    "roles": [{
        "name": "admin",
        "operationsAllowed": [
            "CLUSTER:READ",
            "CLUSTER:WRITE",
            "CLUSTER:MANAGE",
            "DATA:READ",
            "DATA:WRITE",
            "DATA:MANAGE"
        ]
    }],
    "users": [{
        "name": "$GEODE_SECURITY_USERNAME",
        "password": "$GEODE_SECURITY_PASSWORD",
        "roles": ["admin"]
    }]
}
EOF
            # Configure restrictive permissions
            chmod 440 "${GEODE_EXTENSIONS_DIR}/security.json"
        else
            info "Using custom users & roles defined at \"security.json\" file"
        fi
    fi
}

########################
# Configure security manager
# Globals:
#   GEODE_*
# Arguments:
#   None
# Returns:
#   None
#########################
geode_configure_security_manager() {
    info "Configuring Apache Geode security manager"
    geode_conf_set "security-manager" "$GEODE_SECURITY_MANAGER" "$GEODE_SEC_CONF_FILE"
    geode_conf_set "security-username" "$GEODE_SECURITY_USERNAME" "$GEODE_SEC_CONF_FILE"
    geode_conf_set "security-password" "$GEODE_SECURITY_PASSWORD" "$GEODE_SEC_CONF_FILE"
    # Configure Sample SecurityManager
    geode_configure_sample_security_manager
}

########################
# Configure TLS
# ref: https://geode.apache.org/docs/guide/114/managing/security/implementing_ssl.html
# Globals:
#   GEODE_*
# Arguments:
#   None
# Returns:
#   None
#########################
geode_configure_security_tls() {
    info "Configuring Apache Geode TLS"
    geode_conf_set "ssl-enabled-components" "$GEODE_SECURITY_TLS_COMPONENTS" "$GEODE_SEC_CONF_FILE"
    geode_conf_set "ssl-endpoint-identification-enabled" "$(is_boolean_yes "$GEODE_SECURITY_TLS_ENDPOINT_IDENTIFICATION_ENABLED" && echo "true" || echo "false")" "$GEODE_SEC_CONF_FILE"
    geode_conf_set "ssl-require-authentication" "$(is_boolean_yes "$GEODE_SECURITY_TLS_REQUIRE_AUTHENTICATION" && echo "true" || echo "false")" "$GEODE_SEC_CONF_FILE"
    geode_conf_set "ssl-keystore" "$GEODE_SECURITY_TLS_KEYSTORE_FILE" "$GEODE_SEC_CONF_FILE"
    ! is_empty_value "$GEODE_SECURITY_TLS_KEYSTORE_PASSWORD" && geode_conf_set "ssl-keystore-password" "$GEODE_SECURITY_TLS_KEYSTORE_PASSWORD" "$GEODE_SEC_CONF_FILE"
    geode_conf_set "ssl-truststore" "$GEODE_SECURITY_TLS_TRUSTSTORE_FILE" "$GEODE_SEC_CONF_FILE"
    ! is_empty_value "$GEODE_SECURITY_TLS_TRUSTSTORE_PASSWORD" && geode_conf_set "ssl-truststore-password" "$GEODE_SECURITY_TLS_TRUSTSTORE_PASSWORD" "$GEODE_SEC_CONF_FILE"
}

########################
# Wait until the locator is accessible with the currently-known credentials
# Arguments:
#   $1 - locator hostname
#   $2 - user to securely connect to the locator (optional)
#   $3 - password to securely connect to the locator (optional)
# Returns:
#   true if the locator connection succeeded, false otherwise
#########################
geode_wait_for_locator_connection() {
    local -r locator="${1:?missing locator host}"
    local -r user="${2:-}"
    local -r pass="${3:-}"

    check_locator_connection() {
        local -a connet_flags=("--locator=${locator}")
        ! is_empty_value "$user" && connet_flags+=("--user=${user}")
        ! is_empty_value "$pass" && connet_flags+=("--password=${pass}")
        if ! is_empty_value "$GEODE_SECURITY_TLS_COMPONENTS"; then
            connet_flags+=(
                "--use-ssl" "--skip-ssl-validation"
                "--key-store=${GEODE_SECURITY_TLS_KEYSTORE_FILE}"
                "--trust-store=${GEODE_SECURITY_TLS_TRUSTSTORE_FILE}"
            )
            ! is_empty_value "$GEODE_SECURITY_TLS_KEYSTORE_PASSWORD" && connet_flags+=("--key-store-password=${GEODE_SECURITY_TLS_KEYSTORE_PASSWORD}")
            ! is_empty_value "$GEODE_SECURITY_TLS_TRUSTSTORE_PASSWORD" && connet_flags+=("--trust-store-password=${GEODE_SECURITY_TLS_TRUSTSTORE_PASSWORD}")
        fi
        debug_execute gfsh -e "connect ${connet_flags[*]}" -e "status cluster-config-service"
    }
    # We use a random sleep time between retries to avoid colissions
    if ! retry_while "check_locator_connection" "12" "$(generate_random_string --type numeric --count 1)"; then
        error "Could not connect to the locator"
        return 1
    fi
}

########################
# Ensure Apache Geode is initialized as a cache server
# Globals:
#   GEODE_*
# Arguments:
#   None
# Returns:
#   None
#########################
geode_initialize_cache_server() {
    ! is_mounted_dir_empty "$GEODE_DATA_DIR" && info "Detected data from previous deployments"

    if is_empty_value "$GEODE_LOCATORS"; then
        info "No locators indicated, starting cache server as a standalone server"
        # We don't use the "Cluster Configuration Service" on standalone cache servers
        # Therefore, we need to recreate the configuration even when we detect data from
        # previous deployments
        warn "The cluster configuration service will be disabled"
        # Create configuration file
        [[ ! -f "$GEODE_CONF_FILE" && -w "$GEODE_CONF_DIR" ]] && geode_create_config
        # Configure security
        if is_boolean_yes "$GEODE_ENABLE_SECURITY" && [[ ! -f "$GEODE_SEC_CONF_FILE" && -w "$GEODE_CONF_DIR" ]]; then
            ! is_empty_value "$GEODE_SECURITY_MANAGER" && geode_configure_security_manager
            ! is_empty_value "$GEODE_SECURITY_TLS_COMPONENTS" && geode_configure_security_tls
            # Configure restrictive permissions
            chmod 440 "$GEODE_SEC_CONF_FILE"
        fi
    else
        # We use "Cluster Configuration Service" to manage the whole cluster configuration
        # as recommended by Apache Geode guidelines. In this setup, locators distribute the
        # configuration along the cluster and you only need to configure Cache servers for
        # those items that cannot be specified or altered using 'gfsh'
        # ref: https://geode.apache.org/docs/guide/114/configuring/cluster_config/gfsh_persist.html
        local user pass
        # Configure Security credentials used to connect the locators
        if is_boolean_yes "$GEODE_ENABLE_SECURITY"; then
            user="$GEODE_SECURITY_USERNAME"
            pass="$GEODE_SECURITY_PASSWORD"
            # Cache servers retrieve the configuration from the Cluster Configuration Service
            # but they cannot retrieve the configuration for the Sample SecurityManager
            # This configuration is not persisted. Therefore, we also need to generate it
            # during container recreations
            geode_configure_sample_security_manager
        fi
        info "Trying to connect to locators"
        read -r -a locators <<< "$(tr ',;' ' ' <<< "${GEODE_LOCATORS/%,/}")"
        for l in "${locators[@]}"; do
            geode_wait_for_locator_connection "$l" "${user:-}" "${pass:-}"
        done
    fi

    true
}

########################
# Ensure Apache Geode is initialized as a locator node
# Globals:
#   GEODE_*
# Arguments:
#   None
# Returns:
#   None
#########################
geode_initialize_locator() {
    ! is_mounted_dir_empty "$GEODE_DATA_DIR" && info "Detected data from previous deployments"

    # Create configuration file
    [[ ! -f "$GEODE_CONF_FILE" && -w "$GEODE_CONF_DIR" ]] && geode_create_config
    # Configure security
    if is_boolean_yes "$GEODE_ENABLE_SECURITY" && [[ ! -f "$GEODE_SEC_CONF_FILE" && -w "$GEODE_CONF_DIR" ]]; then
        ! is_empty_value "$GEODE_SECURITY_MANAGER" && geode_configure_security_manager
        ! is_empty_value "$GEODE_SECURITY_TLS_COMPONENTS" && geode_configure_security_tls
        # Configure restrictive permissions
        chmod 440 "$GEODE_SEC_CONF_FILE"
    fi

    true
}

########################
# Ensure Apache Geode is initialized
# Globals:
#   GEODE_*
# Arguments:
#   None
# Returns:
#   None
#########################
geode_initialize() {
    info "Initializing Apache Geode"

    # Ensure Apache Geode daemon user has proper permissions on data directory when runnint container as "root"
    if am_i_root; then
        info "Configuring file permissions for Apache Geode"
        is_mounted_dir_empty "$GEODE_DATA_DIR" && configure_permissions_ownership "$GEODE_DATA_DIR" -d "755" -f "644" -u "$GEODE_DAEMON_USER" -g "$GEODE_DAEMON_GROUP"
    fi

    # Check for mounted configuration files and cert files
    if ! is_dir_empty "$GEODE_MOUNTED_CONF_DIR"; then
        cp -Lr "$GEODE_MOUNTED_CONF_DIR"/* "$GEODE_CONF_DIR"
    fi

    case "$GEODE_NODE_TYPE" in
    server)
        geode_initialize_cache_server
        ;;
    locator)
        geode_initialize_locator
        ;;
    *)
        error "Type unknown: ${GEODE_NODE_TYPE}"
        return 1
        ;;
    esac

    true
}

########################
# Returns the list of flags to start a specific Geode node
# Globals:
#   GEODE_*
# Arguments:
#   None
# Returns:
#   String
#########################
geode_start_flags() {
    local -a start_flags+=(
        "--dir=${GEODE_DATA_DIR}"                                          # Set data directory
        "--classpath=${GEODE_EXTENSIONS_DIR}"                              # Load custom JAR(s) and other extensions
        "--force"                                                          # Allow overwiting the PID file if existing
        "--J=-Dgemfire.log-file=${GEODE_LOGS_DIR}/${GEODE_NODE_TYPE}.log"  # Custom log file location
    )
    # Configuration files flags
    [[ -f "$GEODE_CONF_FILE" ]] && start_flags+=("--properties-file=${GEODE_CONF_FILE}")
    [[ -f "$GEODE_SEC_CONF_FILE" ]] && start_flags+=("--security-properties-file=${GEODE_SEC_CONF_FILE}")
    # Cluster flags
    [[ -n "$GEODE_NODE_NAME" ]] && start_flags+=("--name=${GEODE_NODE_NAME}")
    [[ -n "$GEODE_LOCATORS" ]] && start_flags+=("--locators=${GEODE_LOCATORS}")
    [[ -n "$GEODE_GROUPS" ]] && start_flags+=("--groups=${GEODE_GROUPS}")
    [[ -n "$GEODE_ADVERTISED_HOSTNAME" ]] && start_flags+=("--hostname-for-clients=${GEODE_ADVERTISED_HOSTNAME}")
    # Memory flags
    [[ -n "$GEODE_INITIAL_HEAP_SIZE" ]] && start_flags+=("--initial-heap=${GEODE_INITIAL_HEAP_SIZE}")
    [[ -n "$GEODE_MAX_HEAP_SIZE" ]] && start_flags+=("--max-heap=${GEODE_MAX_HEAP_SIZE}")
    # Specific flags per node type
    case "$GEODE_NODE_TYPE" in
    server)
        start_flags+=("--server-port=${GEODE_SERVER_PORT_NUMBER}")
        [[ -n "$GEODE_SERVER_BIND_ADDRESS" ]] && start_flags+=("--server-bind-address=${GEODE_SERVER_BIND_ADDRESS}")
        if [[ -n "$GEODE_LOCATORS" ]]; then
            # Required flags to join the locator when authentication is enabled
            is_boolean_yes "$GEODE_ENABLE_SECURITY" && start_flags+=(
                "--user=${GEODE_SECURITY_USERNAME}"
                "--password=${GEODE_SECURITY_PASSWORD}"
            )
        else
            # Do not use "Cluster Configuration Service" for standalone cache servers
            start_flags+=("--use-cluster-configuration=false")
        fi
        ;;
    locator)
        start_flags+=("--port=${GEODE_LOCATOR_PORT_NUMBER}")
        [[ -n "$GEODE_LOCATOR_BIND_ADDRESS" ]] && start_flags+=("--bind-address=${GEODE_LOCATOR_BIND_ADDRESS}")
        ;;
    *)
        error "Type unknown: ${GEODE_NODE_TYPE}"
        return 1
        ;;
    esac
    echo "${start_flags[@]}"
}

########################
# Run custom initialization scripts
# Globals:
#   GEODE_*
# Arguments:
#   None
# Returns:
#   None
#########################
geode_custom_init_scripts() {
    if [[ -n $(find "${GEODE_INITSCRIPTS_DIR}/" -type f -regex ".*\.sh") ]] && [[ ! -f "${GEODE_VOLUME_DIR}/.user_scripts_initialized" ]] ; then
        info "Loading user's custom files from \"${GEODE_INITSCRIPTS_DIR}\"";
        local -r tmp_file="/tmp/filelist"
        find "${GEODE_INITSCRIPTS_DIR}/" -type f -regex ".*\.sh" | sort >"$tmp_file"
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
            *) debug "Ignoring $f" ;;
            esac
        done <$tmp_file
        rm -f "$tmp_file"
        touch "${GEODE_VOLUME_DIR}/.user_scripts_initialized"
    fi
}
