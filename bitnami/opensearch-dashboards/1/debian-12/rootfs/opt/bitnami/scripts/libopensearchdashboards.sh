#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Kibana/Opensearch Dashboards common library

# shellcheck disable=SC1090
# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh

# Functions

########################
# Validate settings in SERVER_* env vars
# Globals:
#   SERVER_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
kibana_validate() {
    debug "Validating settings in SERVER_* environment variables..."
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
    is_file_writable "$SERVER_CONF_FILE" || warn "The ${SERVER_FLAVOR^} configuration file '${SERVER_CONF_FILE}' is not writable. Configurations based on environment variables will not be applied for this file."

    if [[ "$SERVER_FLAVOR" = "kibana" ]]; then
        if is_boolean_yes "$KIBANA_CREATE_USER"; then
            if is_empty_value "$KIBANA_PASSWORD"; then
                print_validation_error "The variable KIBANA_CREATE_USER is set but no KIBANA_PASSWORD provided for the kibana_system user."
            fi
            if is_empty_value "$KIBANA_ELASTICSEARCH_PASSWORD"; then
                print_validation_error "Password for the 'elastic' user is required in order to create the kibana_system user. Please provide it using the variable KIBANA_ELASTICSEARCH_PASSWORD."
            fi
        fi
    fi

    # User inputs
    check_empty_value "SERVER_DB_URL"
    check_empty_value "SERVER_HOST"
    for var in "SERVER_DB_PORT_NUMBER" "SERVER_PORT_NUMBER"; do
        if ! err=$(validate_port "${!var}"); then
            print_validation_error "An invalid port was specified in the environment variable $var: $err"
        fi
    done

    if is_boolean_yes "$SERVER_ENABLE_TLS"; then
        if is_boolean_yes "$SERVER_TLS_USE_PEM"; then
            if [[ ! -f "$SERVER_CERT_LOCATION" ]] || [[ ! -f "$SERVER_KEY_LOCATION" ]]; then
                print_validation_error "In order to configure the TLS encryption for ${SERVER_FLAVOR^} server using PEM certs you must provide your a valid key and certificate."
            fi
        elif [[ ! -f "$SERVER_KEYSTORE_LOCATION" ]]; then
            print_validation_error "In order to configure the TLS encryption for ${SERVER_FLAVOR^} server using PKCS12 certs you must mount a valid keystore."
        fi
    fi

    if is_boolean_yes "$SERVER_DB_ENABLE_TLS"; then
        check_multi_value "SERVER_DB_TLS_VERIFICATION_MODE" "full certificate none"
        if [[ "$SERVER_DB_TLS_VERIFICATION_MODE" != "none" ]];then
            if is_boolean_yes "$SERVER_DB_TLS_USE_PEM"; then
                if [[ ! -f "$SERVER_DB_CA_CERT_LOCATION" ]]; then
                    print_validation_error "In order to connect to Elasticsearch via HTTPS, a valid CA certificate is required."
                fi
            elif [[ ! -f "$SERVER_DB_TRUSTSTORE_LOCATION" ]]; then
                print_validation_error "In order to connect to Elasticsearch via HTTPS, a valid PKCS12 truststore is required."
            fi
        fi
    fi

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Configure/initialize Kibana/Dashboards
# Globals:
#   SERVER_*
# Arguments:
#   None
# Returns:
#   None
#########################
kibana_initialize() {
    info "Configuring/Initializing ${SERVER_FLAVOR^}..."

    debug "Ensuring expected directories/files exist..."
    for dir in "$SERVER_TMP_DIR" "$SERVER_LOGS_DIR" "$SERVER_CONF_DIR" "$SERVER_DATA_DIR"; do
        ensure_dir_exists "$dir"
        am_i_root && chown -R "$SERVER_DAEMON_USER:$SERVER_DAEMON_GROUP" "$dir"
    done

    if is_file_writable "$SERVER_CONF_FILE"; then
        local dbFlavor="elasticsearch"
        [[ "$SERVER_FLAVOR" = "opensearch-dashboards" ]] && dbFlavor="opensearch"
        if is_mounted_dir_empty "$SERVER_MOUNTED_CONF_DIR"; then
            info "Setting default configuration"
            kibana_conf_set "pid.file" "$SERVER_PID_FILE"
            kibana_conf_set "server.host" "$SERVER_HOST"
            kibana_conf_set "server.port" "$SERVER_PORT_NUMBER" "int"
            kibana_conf_set "${dbFlavor}.hosts" "$(kibana_sanitize_elasticsearch_hosts "${SERVER_DB_URL}" "${SERVER_DB_PORT_NUMBER}")"

        else
            info "Found mounted configuration directory"
            if ! cp -Lr "$SERVER_MOUNTED_CONF_DIR"/* "$SERVER_CONF_DIR"; then
                error "Issue copying mounted configuration files from $SERVER_MOUNTED_CONF_DIR to $SERVER_CONF_DIR. Make sure you are not mounting configuration files in $SERVER_CONF_DIR and $SERVER_MOUNTED_CONF_DIR at the same time"
                exit 1
            fi
        fi
        # Kibana override configuration
        if [[ "$SERVER_FLAVOR" = "kibana" ]]; then
            if is_boolean_yes "$KIBANA_DISABLE_STRICT_CSP"; then
                kibana_conf_set "csp.strict" "false" "bool"
            fi
            if ! is_empty_value "$KIBANA_SERVER_PUBLICBASEURL"; then
                kibana_conf_set "server.publicBaseUrl" "$KIBANA_SERVER_PUBLICBASEURL"
            fi
            if ! is_empty_value "$KIBANA_XPACK_SECURITY_ENCRYPTIONKEY"; then
                kibana_conf_set "xpack.security.encryptionKey" "$KIBANA_XPACK_SECURITY_ENCRYPTIONKEY"
            fi
            if ! is_empty_value "$KIBANA_XPACK_REPORTING_ENCRYPTIONKEY"; then
                kibana_conf_set "xpack.reporting.encryptionKey" "$KIBANA_XPACK_REPORTING_ENCRYPTIONKEY"
            fi
            if ! is_boolean_yes "$KIBANA_NEWSFEED_ENABLED"; then
                kibana_conf_set "newsfeed.enabled" "false" "bool"
            fi
            if [[ "$KIBANA_ELASTICSEARCH_REQUESTTIMEOUT" != "30000" ]]; then
                kibana_conf_set "elasticsearch.requestTimeout" "$KIBANA_ELASTICSEARCH_REQUESTTIMEOUT"
            fi
        fi

        # Configure Elasticsearch/Opensearch authentication
        if ! is_empty_value "$SERVER_PASSWORD"; then
            local user="kibana_system"
            [[ "$SERVER_FLAVOR" = "opensearch-dashboards" ]] && user="kibanaserver"
            kibana_conf_set "${dbFlavor}.username" "$user"
            kibana_conf_set "${dbFlavor}.password" "$SERVER_PASSWORD"
        elif [[ "$SERVER_FLAVOR" = "opensearch-dashboards" ]]; then
            info "Security settings not provided, removing plugin"
            opensearch-dashboards-plugin remove securityDashboards
            replace_in_file "$SERVER_CONF_FILE" "^opensearch_security\." "#opensearch_security."
        fi

        # Configure Webserver TLS settings (Client -> Kibana/Dashboards)
        if is_boolean_yes "$SERVER_ENABLE_TLS"; then
            kibana_conf_set "server.ssl.enabled" "true" "bool"
            [[ "$SERVER_FLAVOR" = "opensearch-dashboards" ]] && kibana_conf_set "opensearch_security.cookie.secure" "true" "bool"
            if is_boolean_yes "$SERVER_TLS_USE_PEM"; then
                kibana_conf_set "server.ssl.certificate" "$SERVER_CERT_LOCATION"
                kibana_conf_set "server.ssl.key" "$SERVER_KEY_LOCATION"
                if ! is_empty_value "$SERVER_KEY_PASSWORD"; then
                    if [[ "$SERVER_FLAVOR" = "opensearch-dashboards" ]]; then
                        kibana_conf_set "server.ssl.keyPassphrase" "$SERVER_KEY_PASSWORD"
                    else
                        kibana_set_key_value "server.ssl.keyPassphrase" "$SERVER_KEY_PASSWORD"
                    fi
                fi
            else
                kibana_conf_set "server.ssl.keystore.path" "$SERVER_KEYSTORE_LOCATION"
                if ! is_empty_value "$SERVER_KEYSTORE_PASSWORD"; then
                    if [[ "$SERVER_FLAVOR" = "opensearch-dashboards" ]]; then
                        kibana_conf_set "server.ssl.keystore.password" "$SERVER_KEY_PASSWORD"
                    else
                        kibana_set_key_value "server.ssl.keystore.password" "$SERVER_KEY_PASSWORD"
                    fi
                fi
            fi
        fi

        # Configure Database TLS settings (Kibana/Dashboards -> Elasticsearch/Opensearch)
        if is_boolean_yes "$SERVER_DB_ENABLE_TLS"; then
            kibana_conf_set "${dbFlavor}.ssl.verificationMode" "$SERVER_DB_TLS_VERIFICATION_MODE"
            if [[ "$SERVER_DB_TLS_VERIFICATION_MODE" != "none" ]];then
                if is_boolean_yes "$SERVER_DB_TLS_USE_PEM"; then
                    kibana_conf_set "${dbFlavor}.ssl.certificateAuthorities" "$SERVER_DB_CA_CERT_LOCATION"
                else
                    kibana_conf_set "${dbFlavor}.ssl.truststore.path" "$SERVER_DB_TRUSTSTORE_LOCATION"
                    if ! is_empty_value "$SERVER_DB_TRUSTSTORE_PASSWORD"; then
                        if [[ "$SERVER_FLAVOR" = "opensearch-dashboards" ]]; then
                            kibana_conf_set "${dbFlavor}.ssl.truststore.password" "$SERVER_DB_TRUSTSTORE_PASSWORD"
                        else
                            kibana_set_key_value "${dbFlavor}.ssl.truststore.password" "$SERVER_DB_TRUSTSTORE_PASSWORD"
                        fi
                    fi
                fi
            fi
        fi
    fi
}

########################
# Write a configuration setting value
# Globals:
#   SERVER_CONF_FILE
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
        yq eval "(.${key}) |= \"${value}\"" "$SERVER_CONF_FILE" >"$tempfile"
        ;;
    int)
        yq eval "(.${key}) |= ${value}" "$SERVER_CONF_FILE" >"$tempfile"
        ;;
    bool)
        yq eval "(.${key}) |= (\"${value}\" | test(\"true\"))" "$SERVER_CONF_FILE" >"$tempfile"
        ;;
    *)
        error "Type unknown: ${type}"
        return 1
        ;;
    esac
    cp "$tempfile" "$SERVER_CONF_FILE"
}

########################
# Read a configuration setting value
# Globals:
#   SERVER_CONF_FILE
# Arguments:
#   $1 - key
# Returns:
#   Outputs the key to stdout (Empty response if key is not set)
#########################
kibana_conf_get() {
    local key="${1:?missing key}"

    if [[ -r "$SERVER_CONF_FILE" ]]; then
        local -r res="$(yq eval ".${key}" "$SERVER_CONF_FILE")"
        if [[ ! "$res" = "null" ]]; then
            echo "$res"
        fi
    fi
}

########################
# Configure/initialize Kibana/Dashboards
# For backwards compatibility, it is allowed to specify the host and port in
# different env-vars and this function will build the correct url.
# Globals:
#   SERVER_*
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

    if is_boolean_yes "$SERVER_DB_ENABLE_TLS"; then
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
# Check if Kibana/Dashboards is running
# Globals:
#   SERVER_*
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_kibana_running() {
    local pid
    pid="$(get_pid_from_file "${SERVER_PID_FILE}")"

    if [[ -z "$pid" ]]; then
        false
    else
        is_service_running "$pid"
    fi
}

########################
# Check if Kibana/Dashboards is not running
# Globals:
#   SERVER_*
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_kibana_not_running() {
    ! is_kibana_running
}

########################
# Check if Kibana/Dashboards is ready
# Globals:
#   SERVER_*
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_kibana_ready() {
    local basePath
    local rewriteBasePath
    local scheme="http"
    local opts=()
    rewriteBasePath=$(kibana_conf_get "server.rewriteBasePath")
    # The default value for is 'server.rewriteBasePath' is 'true' when ommited.'
    # Therefore, we must check the value is not 'true'
    ! is_boolean_yes "$rewriteBasePath" && basePath=$(kibana_conf_get "server.basePath")

    [[ "$SERVER_FLAVOR" = "opensearch-dashboards" ]] && ! is_empty_value "$SERVER_PASSWORD" && opts+=("-u" "kibanaserver:${SERVER_PASSWORD}")
    if is_boolean_yes "$SERVER_DB_ENABLE_TLS"; then
        scheme="https"
        opts+=("-k")
    fi
    if is_kibana_running; then
        # Kibana 7 and Opensearch expects .status.overall.state to be 'green', while 8 expects .status.overall.level to be 'available'
        local -r status="$(yq eval '.status.overall | pick(["state", "level"]) | .[]' - <<<"$(curl -s "${opts[@]}" "${scheme}://127.0.0.1:${SERVER_PORT_NUMBER}${basePath}/api/status")")"
        [[ "$status" = "green" || "$status" = "available" ]] && return
    else
        false
    fi
}

########################
# Wait until Kibana/Dashboards is ready
# Globals:
#   SERVER_*
# Arguments:
#   None
# Returns:
#   Boolean
#########################
wait_for_kibana_ready() {
    info "Waiting for ${SERVER_FLAVOR^} to be started and ready"
    retries="$SERVER_WAIT_READY_MAX_RETRIES"
    until is_kibana_ready || [[ "$retries" -eq 0 ]]; do
        debug "Waiting for ${SERVER_FLAVOR^} server: $((retries--)) remaining attempts..."
        sleep 2
    done
    if [[ "$retries" -eq 0 ]]; then
        error "${SERVER_FLAVOR^} is not available after ${SERVER_WAIT_READY_MAX_RETRIES} retries"
        if [[ -r "${SERVER_LOGS_DIR}/init_scripts_start.log" ]]; then
            info "Dumping ${SERVER_LOGS_DIR}/init_scripts_start.log for additional diagnostics..."
            cat "${SERVER_LOGS_DIR}/init_scripts_start.log"
        fi
        exit 1
    fi
}

########################
# Start Kibana/Dashboards in background mode
# Globals:
#   SERVER_*
# Arguments:
#   Extra arguments to pass to the command (optional array)
# Returns:
#   None
#########################
kibana_start_bg() {
    local extra_args=("${@}")

    info "Starting ${SERVER_FLAVOR^} in background"
    local start_command=("${SERVER_BIN_DIR}/${SERVER_FLAVOR}" "serve" "${extra_args[@]}")
    am_i_root && start_command=("run_as_user" "$SERVER_DAEMON_USER" "${start_command[@]}")
    debug_execute "${start_command[@]}" &
}

########################
# Run custom initialization scripts
# Globals:
#   SERVER_*
# Arguments:
#   None
# Returns:
#   None
#########################
kibana_custom_init_scripts() {
    read -r -a init_scripts <<<"$(find "$SERVER_INITSCRIPTS_DIR" -type f -name "*.sh" -print0 | xargs -0)"
    if [[ "${#init_scripts[@]}" -gt 0 ]] && [[ ! -f "$SERVER_VOLUME_DIR"/.user_scripts_initialized ]] || is_boolean_yes "$SERVER_FORCE_INITSCRIPTS"; then
        if is_boolean_yes "$SERVER_FORCE_INITSCRIPTS"; then
            info "Forcing execution of user files"
        fi

        if is_boolean_yes "${SERVER_INITSCRIPTS_START_SERVER}"; then
            # Binding to localhost to not give false positives for external connections
            kibana_start_bg "--host" "127.0.0.1" "--log-file" "${SERVER_LOGS_DIR}/init_scripts_start.log"
            wait_for_kibana_ready
        fi

        info "Loading user's custom files from $SERVER_INITSCRIPTS_DIR"
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
        touch "$SERVER_VOLUME_DIR"/.user_scripts_initialized

        is_kibana_running && stop_service_using_pid "$SERVER_PID_FILE"
        retry_while "is_kibana_not_running"
    fi
}
