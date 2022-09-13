#!/bin/bash
#
# Bitnami Kibana library

# shellcheck disable=SC1090
# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh

# Functions

########################
# Validate settings in KIBANA_* env vars
# Globals:
#   KIBANA_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
kibana_validate() {
    debug "Validating settings in KIBANA_* environment variables..."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }
    check_multi_value() {
        if [[ " ${2} " != *" ${!1} "* ]]; then
            print_validation_error "The allowed values for ${1} are: ${2}"
        fi
    }
    check_empty_value() {
        if is_empty_value "${!1}"; then
            print_validation_error "${1} must be set"
        fi
    }
    # Warn users in case the configuration file is not writable
    is_file_writable "$KIBANA_CONF_FILE" || warn "The Kibana configuration file '${KIBANA_CONF_FILE}' is not writable. Configurations based on environment variables will not be applied for this file."

    if is_boolean_yes "$KIBANA_CREATE_USER"; then
        if is_empty_value "$KIBANA_PASSWORD"; then
            print_validation_error "The variable KIBANA_CREATE_USER is set but no KIBANA_PASSWORD provided for the kibana_system user."
        fi
        if is_empty_value "$KIBANA_ELASTICSEARCH_PASSWORD"; then
            print_validation_error "Password for the 'elastic' user is required in order to create the kibana_system user. Please provide it using the variable KIBANA_ELASTICSEARCH_PASSWORD."
        fi
    fi

    # User inputs
    check_empty_value "KIBANA_ELASTICSEARCH_URL"
    check_empty_value "KIBANA_HOST"
    for var in "KIBANA_ELASTICSEARCH_PORT_NUMBER" "KIBANA_PORT_NUMBER"; do
        if ! err=$(validate_port "${!var}"); then
            print_validation_error "An invalid port was specified in the environment variable $var: $err"
        fi
    done

    if is_boolean_yes "$KIBANA_SERVER_ENABLE_TLS"; then
        if is_boolean_yes "$KIBANA_SERVER_TLS_USE_PEM"; then
            if [[ ! -f "$KIBANA_SERVER_CERT_LOCATION" ]] || [[ ! -f "$KIBANA_SERVER_KEY_LOCATION" ]]; then
                print_validation_error "In order to configure the TLS encryption for Kibana server using PEM certs you must provide your a valid key and certificate."
            fi
        elif [[ ! -f "$KIBANA_SERVER_KEYSTORE_LOCATION" ]]; then
            print_validation_error "In order to configure the TLS encryption for Kibana server using PKCS12 certs you must mount a valid keystore."
        fi
    fi

    if is_boolean_yes "$KIBANA_ELASTICSEARCH_ENABLE_TLS"; then
        check_multi_value "KIBANA_ELASTICSEARCH_TLS_VERIFICATION_MODE" "full certificate none"
        if [[ "$KIBANA_ELASTICSEARCH_TLS_VERIFICATION_MODE" != "none" ]];then
            if is_boolean_yes "$KIBANA_ELASTICSEARCH_TLS_USE_PEM"; then
                if [[ ! -f "$KIBANA_ELASTICSEARCH_CA_CERT_LOCATION" ]]; then
                    print_validation_error "In order to connect to Elasticsearch via HTTPS, a valid CA certificate is required."
                fi
            elif [[ ! -f "$KIBANA_ELASTICSEARCH_TRUSTSTORE_LOCATION" ]]; then
                print_validation_error "In order to connect to Elasticsearch via HTTPS, a valid PKCS12 truststore is required."
            fi
        fi
    fi

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Configure/initialize Kibana
# Globals:
#   KIBANA_*
# Arguments:
#   None
# Returns:
#   None
#########################
kibana_initialize() {
    info "Configuring/Initializing Kibana..."

    debug "Ensuring expected directories/files exist..."
    for dir in "$KIBANA_TMP_DIR" "$KIBANA_LOGS_DIR" "$KIBANA_CONF_DIR" "$KIBANA_DATA_DIR"; do
        ensure_dir_exists "$dir"
        am_i_root && chown -R "$KIBANA_DAEMON_USER:$KIBANA_DAEMON_GROUP" "$dir"
    done

    # Optimize feature for Kibana 6
    am_i_root && [[ -d "$KIBANA_OPTIMIZE_DIR" ]] && chown -R "$KIBANA_DAEMON_USER:$KIBANA_DAEMON_GROUP" "$KIBANA_OPTIMIZE_DIR"

    if is_file_writable "$KIBANA_CONF_FILE"; then
        if is_mounted_dir_empty "$KIBANA_MOUNTED_CONF_DIR"; then
            info "Setting default configuration"
            kibana_conf_set "pid.file" "$KIBANA_PID_FILE"
            kibana_conf_set "server.host" "$KIBANA_HOST"
            kibana_conf_set "server.port" "$KIBANA_PORT_NUMBER" "int"
            kibana_conf_set "elasticsearch.hosts" "$(kibana_sanitize_elasticsearch_hosts "${KIBANA_ELASTICSEARCH_URL}" "${KIBANA_ELASTICSEARCH_PORT_NUMBER}")"
        else
            info "Found mounted configuration directory"
            if ! cp -Lr "$KIBANA_MOUNTED_CONF_DIR"/* "$KIBANA_CONF_DIR"; then
                error "Issue copying mounted configuration files from $KIBANA_MOUNTED_CONF_DIR to $KIBANA_CONF_DIR. Make sure you are not mounting configuration files in $KIBANA_CONF_DIR and $KIBANA_MOUNTED_CONF_DIR at the same time"
                exit 1
            fi
        fi
        # Override configuration
        if ! is_empty_value "$KIBANA_PASSWORD"; then
            kibana_conf_set "elasticsearch.username" "kibana_system"
            kibana_conf_set "elasticsearch.password" "$KIBANA_PASSWORD"
        fi
        if is_boolean_yes "$KIBANA_SERVER_ENABLE_TLS"; then
            kibana_conf_set "server.ssl.enabled" "true" "bool"
            if "$KIBANA_SERVER_TLS_USE_PEM"; then
                kibana_conf_set "server.ssl.certificate" "$KIBANA_SERVER_CERT_LOCATION"
                kibana_conf_set "server.ssl.key" "$KIBANA_SERVER_KEY_LOCATION"
                ! is_empty_value "$KIBANA_SERVER_KEY_PASSWORD" && kibana_set_key_value "server.ssl.keyPassphrase" "$KIBANA_SERVER_KEY_PASSWORD"
            else
                kibana_conf_set "server.ssl.keystore.path" "$KIBANA_SERVER_KEYSTORE_LOCATION"
                ! is_empty_value "$KIBANA_SERVER_KEYSTORE_PASSWORD" && kibana_set_key_value "server.ssl.keystore.password" "$KIBANA_SERVER_KEYSTORE_PASSWORD"
            fi
        fi
        if is_boolean_yes "$KIBANA_ELASTICSEARCH_ENABLE_TLS"; then
            kibana_conf_set "elasticsearch.ssl.verificationMode" "$KIBANA_ELASTICSEARCH_TLS_VERIFICATION_MODE"
            if [[ "$KIBANA_ELASTICSEARCH_TLS_VERIFICATION_MODE" != "none" ]];then
                if "$KIBANA_ELASTICSEARCH_TLS_USE_PEM"; then
                    kibana_conf_set "elasticsearch.ssl.certificateAuthorities" "$KIBANA_ELASTICSEARCH_CA_CERT_LOCATION"
                else
                    ! is_empty_value "$KIBANA_ELASTICSEARCH_TRUSTSTORE_PASSWORD" && kibana_set_key_value "elasticsearch.ssl.truststore.password" "$KIBANA_ELASTICSEARCH_TRUSTSTORE_PASSWORD"
                    kibana_conf_set "elasticsearch.ssl.truststore.path" "$KIBANA_ELASTICSEARCH_TRUSTSTORE_LOCATION"
                fi
            fi
        fi
    fi
}

########################
# Write a configuration setting value
# Globals:
#   KIBANA_CONF_FILE
# Arguments:
#   $1 - key
#   $2 - value
#   $3 - YAML type (string, int or bool)
# Returns:
#   None
#########################
kibana_conf_set() {
    local -r key="${1:?Missing key}"
    local -r value="${2:-}"
    local -r type="${3:-string}"
    local -r tempfile=$(mktemp)

    case "$type" in
    string)
        yq eval "(.${key}) |= \"${value}\"" "$KIBANA_CONF_FILE" >"$tempfile"
        ;;
    int)
        yq eval "(.${key}) |= ${value}" "$KIBANA_CONF_FILE" >"$tempfile"
        ;;
    bool)
        yq eval "(.${key}) |= (\"${value}\" | test(\"true\"))" "$KIBANA_CONF_FILE" >"$tempfile"
        ;;
    *)
        error "Type unknown: ${type}"
        return 1
        ;;
    esac
    cp "$tempfile" "$KIBANA_CONF_FILE"
}

########################
# Read a configuration setting value
# Globals:
#   KIBANA_CONF_FILE
# Arguments:
#   $1 - key
# Returns:
#   Outputs the key to stdout (Empty response if key is not set)
#########################
kibana_conf_get() {
    local key="${1:?missing key}"

    if [[ -r "$KIBANA_CONF_FILE" ]]; then
        local -r res="$(yq eval ".${key}" "$KIBANA_CONF_FILE")"
        if [[ ! "$res" = "null" ]]; then
            echo "$res"
        fi
    fi
}

########################
# Set Elasticsearch keystore values
# Globals:
#   ELASTICSEARCH_*
# Arguments:
#   None
# Returns:
#   None
#########################
kibana_set_key_value() {
    local key="${1:?missing key}"
    local value="${2:?missing value}"

    debug "Storing key: ${key}"
    kibana-keystore add --stdin --force "$key" <<<"$value"
}

########################
# Configure/initialize Kibana
# For backwards compatibility, it is allowed to specify the host and port in
# different env-vars and this function will build the correct url.
# Globals:
#   KIBANA_*
# Arguments:
#   $1 - hostUrl
#   $2 - port
# Returns:
#   None
#########################
kibana_sanitize_elasticsearch_hosts() {
    local -r hostUrl="${1:?missing hostUrl}"
    local -r port="${2:?missing port}"
    local scheme

    if is_boolean_yes "$KIBANA_ELASTICSEARCH_ENABLE_TLS"; then
        scheme="https"
    else
        scheme="http"
    fi

    if grep -q -E "^https?://[^:]+:[0-9]+$" <<<"$hostUrl"; then # i.e. http://localhost:9200
        echo "${hostUrl}"
    elif grep -q -E "^https?://[^:]+$" <<<"$hostUrl"; then # i.e. http://localhost
        echo "${hostUrl}:${port}"
    elif grep -q -E "^[^:]+:[0-9]+$" <<<"$hostUrl"; then # i.e. localhost:9200
        echo "${scheme}://${hostUrl}"
    else # i.e. localhost
        echo "${scheme}://${hostUrl}:${port}"
    fi
}

########################
# Check if Kibana is running
# Globals:
#   KIBANA_*
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_kibana_running() {
    local pid
    pid="$(get_pid_from_file "${KIBANA_PID_FILE}")"

    if [[ -z "$pid" ]]; then
        false
    else
        is_service_running "$pid"
    fi
}

########################
# Check if Kibana is not running
# Globals:
#   KIBANA_*
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_kibana_not_running() {
    ! is_kibana_running
}

########################
# Check if Kibana is ready
# Globals:
#   KIBANA_*
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_kibana_ready() {
    local basePath
    local rewriteBasePath
    rewriteBasePath=$(kibana_conf_get "server.rewriteBasePath")
    # The default value for is 'server.rewriteBasePath' is 'true' when ommited.'
    # Therefore, we must check the value is not 'true'
    [[ ! "$rewriteBasePath" = "false" ]] && basePath=$(kibana_conf_get "server.basePath")
    if is_kibana_running; then
        # Kibana 7 expects .status.overall.state to be 'green', while 8 expects .status.overall.level to be 'available'
        local -r status="$(yq eval '.status.overall | pick(["state", "level"]) | .[]' - <<<"$(curl -s "127.0.0.1:${KIBANA_PORT_NUMBER}${basePath:-}/api/status")")"
        [[ "$status" = "green" || "$status" = "available" ]] && return
    else
        false
    fi
}

########################
# Wait until Kibana is ready
# Globals:
#   KIBANA_*
# Arguments:
#   None
# Returns:
#   Boolean
#########################
wait_for_kibana_ready() {
    info "Waiting for Kibana to be started and ready"
    retries="$KIBANA_WAIT_READY_MAX_RETRIES"
    until is_kibana_ready || [[ "$retries" -eq 0 ]]; do
        debug "Waiting for Kibana server: $((retries--)) remaining attempts..."
        sleep 2
    done
    if [[ "$retries" -eq 0 ]]; then
        error "Kibana is not available after ${KIBANA_WAIT_READY_MAX_RETRIES} retries"
        if [[ -r "${KIBANA_LOGS_DIR}/init_scripts_start.log" ]]; then
            info "Dumping ${KIBANA_LOGS_DIR}/init_scripts_start.log for additional diagnostics..."
            cat "${KIBANA_LOGS_DIR}/init_scripts_start.log"
        fi
        exit 1
    fi
}

########################
# Start Kibana in background mode
# Globals:
#   KIBANA_*
# Arguments:
#   Extra arguments to pass to the command (optional array)
# Returns:
#   None
#########################
kibana_start_bg() {
    local extra_args=("${@}")

    info "Starting Kibana in background"
    local start_command=("${KIBANA_BIN_DIR}/kibana" "serve" "${extra_args[@]}")
    am_i_root && start_command=("gosu" "$KIBANA_DAEMON_USER" "${start_command[@]}")
    debug_execute "${start_command[@]}" &
}

########################
# Run custom initialization scripts
# Globals:
#   KIBANA_*
# Arguments:
#   None
# Returns:
#   None
#########################
kibana_custom_init_scripts() {
    read -r -a init_scripts <<<"$(find "$KIBANA_INITSCRIPTS_DIR" -type f -name "*.sh" -print0 | xargs -0)"
    if [[ "${#init_scripts[@]}" -gt 0 ]] && [[ ! -f "$KIBANA_VOLUME_DIR"/.user_scripts_initialized ]] || is_boolean_yes "$KIBANA_FORCE_INITSCRIPTS"; then
        if is_boolean_yes "$KIBANA_FORCE_INITSCRIPTS"; then
            info "Forcing execution of user files"
        fi

        if is_boolean_yes "${KIBANA_INITSCRIPTS_START_SERVER}"; then
            # Binding to localhost to not give false positives for external connections
            kibana_start_bg "--host" "127.0.0.1" "--log-file" "${KIBANA_LOGS_DIR}/init_scripts_start.log"
            wait_for_kibana_ready
        fi

        info "Loading user's custom files from $KIBANA_INITSCRIPTS_DIR"
        for f in "${init_scripts[@]}"; do
            debug "Executing $f"
            case "$f" in
            *.sh)
                if [[ -x "$f" ]]; then
                    if ! "$f"; then
                        error "Failed executing $f"
                        return 1
                    fi
                else
                    warn "Sourcing $f as it is not executable by the current user, any error may cause initialization to fail"
                    . "$f"
                fi
                ;;
            *)
                warn "Skipping $f, supported formats are: .sh"
                ;;
            esac
        done
        touch "$KIBANA_VOLUME_DIR"/.user_scripts_initialized

        is_kibana_running && stop_service_using_pid "$KIBANA_PID_FILE"
        retry_while "is_kibana_not_running"
    fi
}

########################
# Waits for Elasticsearch to be available and creates the user 'kibana_user', if it doesn't exists
# Globals:
#   KIBANA_*
# Arguments:
#   None
# Returns:
#   None
#########################
kibana_create_system_user() {
    local -r retries="60"
    local -r sleep_time="5"
    local url
    url=$(kibana_sanitize_elasticsearch_hosts "${KIBANA_ELASTICSEARCH_URL}" "${KIBANA_ELASTICSEARCH_PORT_NUMBER}")
    check_elasticsearch() {
        local status_code="000"
        status_code=$(curl -L -s -k -o /dev/null "${url}" -w "%{http_code}")
        debug "Attempted to connect with Elasticserach. Status code: $status_code"
        # Any status code different to 000 will be considered valid
        [[ "$status_code" != "000" ]]
    }

    info "Waiting for Elasticsearch to be ready."
    # Wait for elasticsearch to be available
    if ! retry_while "check_elasticsearch" "$retries" "$sleep_time"; then
        error "Timeout waiting for the Elasticsearch to respond"
        return 1
    fi

    # Check kibana_system user doesn't exists
    status_code=$(curl -L -s -k -o /dev/null -u "kibana_system:${KIBANA_PASSWORD}" "${url}" -w "%{http_code}")
    if [[ "$status_code" == "401" ]]; then
        info "Setting password for user 'kibana_system'"
        curl -L -s -k -o /dev/null -X POST -u "elastic:${KIBANA_ELASTICSEARCH_PASSWORD}" -H "Content-Type: application/json" "${url}/_security/user/kibana_system/_password" -d "{\"password\":\"${KIBANA_PASSWORD}\"}"
        status_code=$(curl -L -s -k -o /dev/null -u "kibana_system:${KIBANA_PASSWORD}" "${url}" -w "%{http_code}")
        if [[ "$status_code" == "200" ]]; then
            info "Password for kibana_system successfully configured"
        else
            error "An error occurred while configuring kibana_system user"
            return 1
        fi
    else
        info "Skipping 'kibana_system' user creation. User already exists. Status code: ${status_code}"
    fi
}
