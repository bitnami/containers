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
    check_empty_value() {
        if is_empty_value "${!1}"; then
            print_validation_error "${1} must be set"
        fi
    }
    # Warn users in case the configuration file is not writable
    is_file_writable "$KIBANA_CONF_FILE" || warn "The Kibana configuration file '${KIBANA_CONF_FILE}' is not writable. Configurations based on environment variables will not be applied for this file."

    # User inputs
    check_empty_value "KIBANA_ELASTICSEARCH_URL"
    check_empty_value "KIBANA_HOST"
    for var in "KIBANA_ELASTICSEARCH_PORT_NUMBER" "KIBANA_PORT_NUMBER"; do
        if ! err=$(validate_port "${!var}"); then
            print_validation_error "An invalid port was specified in the environment variable $var: $err"
        fi
    done

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
            kibana_conf_set "server.port" "$KIBANA_PORT_NUMBER"
            kibana_conf_set "elasticsearch.hosts" "$(kibana_sanitize_elasticsearch_hosts "${KIBANA_ELASTICSEARCH_URL}" "${KIBANA_ELASTICSEARCH_PORT_NUMBER}")"
        else
            info "Found mounted configuration directory"
            if ! cp -Lr "$KIBANA_MOUNTED_CONF_DIR"/* "$KIBANA_CONF_DIR"; then
                error "Issue copying mounted configuration files from $KIBANA_MOUNTED_CONF_DIR to $KIBANA_CONF_DIR. Make sure you are not mounting configuration files in $KIBANA_CONF_DIR and $KIBANA_MOUNTED_CONF_DIR at the same time"
                exit 1
            fi
        fi
    fi
}

########################
# Write a configuration setting value
# Globals:
#   KIBANA_*
# Arguments:
#   $1 - key
#   $2 - value
# Returns:
#   None
#########################
kibana_conf_set() {
    local key="${1:?missing key}"
    local value="${2:?missing value}"

    if [[ -s "$KIBANA_CONF_FILE" ]]; then
        yq w -i "$KIBANA_CONF_FILE" "$key" "$value"
    else
        yq n "$key" "$value" >"$KIBANA_CONF_FILE"
    fi
}

########################
# Read a configuration setting value
# Globals:
#   KIBANA_*
# Arguments:
#   $1 - key
# Returns:
#   Outputs the key to stdout (Empty response if key is not set)
#########################
kibana_conf_get() {
    local key="${1:?missing key}"

    if [[ -r "$KIBANA_CONF_FILE" ]]; then
        yq r "$KIBANA_CONF_FILE" "$key"
    fi
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

    if grep -q -E "^https?://[^:]+:[0-9]+$" <<<"$hostUrl"; then # i.e. http://localhost:9200
        echo "${hostUrl}"
    elif grep -q -E "^https?://[^:]+$" <<<"$hostUrl"; then # i.e. http://localhost
        echo "${hostUrl}:${port}"
    elif grep -q -E "^[^:]+:[0-9]+$" <<<"$hostUrl"; then # i.e. localhost:9200
        echo "http://${hostUrl}"
    else # i.e. localhost
        echo "http://${hostUrl}:${port}"
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
    local basePath=
	local rewriteBasePath=$(kibana_conf_get "[server.rewriteBasePath]")
	if [[ "$rewriteBasePath" == "true" ]]; then
		basePath=$(kibana_conf_get "[server.basePath]")
	fi
    if is_kibana_running; then
        local -r state="$(yq r - "status.overall.state" <<<"$(curl -s "127.0.0.1:${KIBANA_PORT_NUMBER}${basePath}/api/status")")"
        [[ "$state" == "green" ]]
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
