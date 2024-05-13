#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Logstash library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libservice.sh

########################
# Validate settings in Logstash environment variables
# Globals:
#   LOGSTASH_*
# Arguments:
#   None
# Returns:
#   None
#########################
logstash_validate() {
    debug "Validating settings in LOGSTASH_* environment variables"
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }
    check_yes_no_value() {
        if ! is_yes_no_value "${!1}" && ! is_true_false_value "${!1}"; then
            print_validation_error "The allowed values for ${1} are: yes no"
        fi
    }
    check_resolved_hostname() {
        if ! is_hostname_resolved "$1"; then
            warn "Hostname ${1} could not be resolved, this could lead to connection issues"
        fi
    }
    check_valid_port() {
        local port_var="${1:?missing port variable}"
        local err
        if ! err="$(validate_port "${!port_var}")"; then
            print_validation_error "An invalid port was specified in the environment variable ${port_var}: ${err}."
        fi
    }

    check_resolved_hostname "$LOGSTASH_BIND_ADDRESS"
    check_yes_no_value "LOGSTASH_EXPOSE_API"
    check_valid_port "LOGSTASH_API_PORT_NUMBER"
    check_yes_no_value "LOGSTASH_ENABLE_MULTIPLE_PIPELINES"

    # Pipeline configuration parameters
    # Inputs
    check_yes_no_value "LOGSTASH_ENABLE_BEATS_INPUT"
    is_boolean_yes "$LOGSTASH_ENABLE_BEATS_INPUT" && check_valid_port "LOGSTASH_BEATS_PORT_NUMBER"
    check_yes_no_value "LOGSTASH_ENABLE_GELF_INPUT"
    is_boolean_yes "$LOGSTASH_ENABLE_GELF_INPUT" && check_valid_port "LOGSTASH_GELF_PORT_NUMBER"
    check_yes_no_value "LOGSTASH_ENABLE_HTTP_INPUT"
    is_boolean_yes "$LOGSTASH_ENABLE_HTTP_INPUT" && check_valid_port "LOGSTASH_HTTP_PORT_NUMBER"
    check_yes_no_value "LOGSTASH_ENABLE_TCP_INPUT"
    is_boolean_yes "$LOGSTASH_ENABLE_TCP_INPUT" && check_valid_port "LOGSTASH_TCP_PORT_NUMBER"
    check_yes_no_value "LOGSTASH_ENABLE_UDP_INPUT"
    is_boolean_yes "$LOGSTASH_ENABLE_UDP_INPUT" && check_valid_port "LOGSTASH_UDP_PORT_NUMBER"
    # Outputs
    check_yes_no_value "LOGSTASH_ENABLE_STDOUT_OUTPUT"
    check_yes_no_value "LOGSTASH_ENABLE_ELASTICSEARCH_OUTPUT"
    if is_boolean_yes "$LOGSTASH_ENABLE_ELASTICSEARCH_OUTPUT"; then
        check_resolved_hostname "$LOGSTASH_ELASTICSEARCH_HOST"
        check_valid_port "LOGSTASH_ELASTICSEARCH_PORT_NUMBER"
    fi

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Create sample config file
# Globals:
#   LOGSTASH_*
# Arguments:
#   None
# Returns:
#   None
#########################
logstash_create_sample_pipeline_config_file() {
    # Default supported inputs/outputs come from historic Bitnami defaults
    # Configuration reference: https://www.elastic.co/guide/en/logstash/current/config-examples.html
    info "Creating sample config file"
    local inputs=""
    local outputs=""
    # Parse inputs
    if is_boolean_yes "$LOGSTASH_ENABLE_BEATS_INPUT"; then
        inputs+=$'\n'"beats {
  ssl => false
  host => \"${LOGSTASH_BIND_ADDRESS}\"
  port => ${LOGSTASH_BEATS_PORT_NUMBER}
}"
    fi
    if is_boolean_yes "$LOGSTASH_ENABLE_GELF_INPUT"; then
        inputs+=$'\n'"gelf {
  host => \"${LOGSTASH_BIND_ADDRESS}\"
  port => ${LOGSTASH_GELF_PORT_NUMBER}
}"
    fi
    if is_boolean_yes "$LOGSTASH_ENABLE_HTTP_INPUT"; then
        inputs+=$'\n'"http {
  ssl => false
  host => \"${LOGSTASH_BIND_ADDRESS}\"
  port => ${LOGSTASH_HTTP_PORT_NUMBER}
}"
    fi
    if is_boolean_yes "$LOGSTASH_ENABLE_TCP_INPUT"; then
        inputs+=$'\n'"tcp {
  mode => \"server\"
  host => \"${LOGSTASH_BIND_ADDRESS}\"
  port => ${LOGSTASH_TCP_PORT_NUMBER}
}"
    fi
    if is_boolean_yes "$LOGSTASH_ENABLE_UDP_INPUT"; then
        inputs+=$'\n'"udp {
  host => \"${LOGSTASH_BIND_ADDRESS}\"
  port => ${LOGSTASH_UDP_PORT_NUMBER}
}"
    fi
    # Parse outputs
    is_boolean_yes "$LOGSTASH_ENABLE_STDOUT_OUTPUT" && outputs+=$'\n'"stdout { }"
    if is_boolean_yes "$LOGSTASH_ENABLE_ELASTICSEARCH_OUTPUT"; then
        outputs+=$'\n'"elasticsearch {
  hosts => [\"${LOGSTASH_ELASTICSEARCH_HOST}:${LOGSTASH_ELASTICSEARCH_PORT_NUMBER}\"]
  document_id => \"%{logstash_checksum}\"
  index => \"logstash-%{+YYYY.MM.dd}\"
}"
    fi
    # Indent and add newline so it looks good
    [[ -n "$inputs" ]] && inputs="$(indent "$inputs" 2)"$'\n'
    [[ -n "$outputs" ]] && outputs="$(indent "$outputs" 2)"$'\n'
    # Create the configuration file
    cat >"$LOGSTASH_PIPELINE_CONF_FILE" <<EOF
input {${inputs}}

output {${outputs}}
EOF
}

########################
# Create a pipeline file
# Globals:
#   LOGSTASH_*
# Arguments:
#   None
# Returns:
#   None
#########################
logstash_create_sample_pipelines_yml_file() {
    info "Creating pipelines.yml file for multiple pipelines"
    logstash_yml_set "${LOGSTASH_CONF_DIR}/pipelines.yml" '[0]."pipeline.id"' 'my-pipeline_1'
    logstash_yml_set "${LOGSTASH_CONF_DIR}/pipelines.yml" '[0]."path.config"' "$LOGSTASH_PIPELINE_CONF_DIR"
}

########################
# Configure Logstash Heap Size
# Globals:
#  LOGSTASH_*
# Arguments:
#   None
# Returns:
#   None
#########################
logstash_set_heap_size() {
    local heap_size
    if [[ -n "$LOGSTASH_HEAP_SIZE" ]]; then
        debug "Using specified values for Xmx and Xms heap options"
        heap_size="$LOGSTASH_HEAP_SIZE"
    else
        debug "Calculating appropriate Xmx and Xms values"
        local machine_mem=""
        machine_mem="$(get_total_memory)"
        if [[ "$machine_mem" -lt 65536 ]]; then
            local max_allowed_memory
            local calculated_heap_size
            calculated_heap_size="$((machine_mem / 2))"
            max_allowed_memory="$((LOGSTASH_MAX_ALLOWED_MEMORY_PERCENTAGE * machine_mem))"
            max_allowed_memory="$((max_allowed_memory / 100))"
            # Allow for absolute memory limit when calculating limit from percentage
            if [[ -n "$LOGSTASH_MAX_ALLOWED_MEMORY" && "$max_allowed_memory" -gt "$LOGSTASH_MAX_ALLOWED_MEMORY" ]]; then
                max_allowed_memory="$LOGSTASH_MAX_ALLOWED_MEMORY"
            fi
            if [[ "$calculated_heap_size" -gt "$max_allowed_memory" ]]; then
                info "Calculated Java heap size of ${calculated_heap_size} will be limited to ${max_allowed_memory}"
                calculated_heap_size="$max_allowed_memory"
            fi
            heap_size="${calculated_heap_size}m"

        else
            heap_size=32768m
        fi
    fi
    debug "Setting '-Xmx${heap_size} -Xms${heap_size}' heap options"
    replace_in_file "${LOGSTASH_CONF_DIR}/jvm.options" "-Xmx[0-9]+[mg]+" "-Xmx${heap_size}"
    replace_in_file "${LOGSTASH_CONF_DIR}/jvm.options" "-Xms[0-9]+[mg]+" "-Xms${heap_size}"
}

########################
# Write a configuration setting value
# Globals:
#   None
# Arguments:
#   $1 - conf file
#   $2 - key
#   $3 - value
#   $4 - YAML type (string, int or bool)
# Returns:
#   None
#########################
logstash_yml_set() {
    local -r conf_file="${1:?missing conf file}"
    local -r key="${2:?missing key}"
    local -r value="${3:-}"
    local -r type="${4:-string}"
    local -r tempfile=$(mktemp)

    case "$type" in
    string)
        yq eval "(.${key}) |= \"${value}\"" "$conf_file" >"$tempfile"
        ;;
    int)
        yq eval "(.${key}) |= ${value}" "$conf_file" >"$tempfile"
        ;;
    bool)
        yq eval "(.${key}) |= (\"${value}\" | test(\"true\"))" "$conf_file" >"$tempfile"
        ;;
    *)
        error "Type unknown: ${type}"
        return 1
        ;;
    esac
    cp "$tempfile" "$conf_file"
}

########################
# Ensure Logstash is initialized
# Globals:
#   LOGSTASH_*
# Arguments:
#   None
# Returns:
#   None
#########################
logstash_initialize() {
    info "Initializing Logstash"

    logstash_set_heap_size

    # Based on naming from https://www.elastic.co/guide/en/logstash/current/config-setting-files.html
    if ! is_mounted_dir_empty "$LOGSTASH_MOUNTED_CONF_DIR"; then
        info "Mounted setting files detected"
        cp -Lr "$LOGSTASH_MOUNTED_CONF_DIR"/. "$LOGSTASH_CONF_DIR"
    fi

    if is_boolean_yes "$LOGSTASH_EXPOSE_API"; then
        if is_file_writable "$LOGSTASH_CONF_FILE"; then
            info "Enabling Logstash API endpoint"
            logstash_yml_set "$LOGSTASH_CONF_FILE" '"api.http.host"' "$LOGSTASH_BIND_ADDRESS"
            logstash_yml_set "$LOGSTASH_CONF_FILE" '"api.http.port"' "$LOGSTASH_API_PORT_NUMBER"
        else
            warn "The Logstash configuration file '${LOGSTASH_CONF_FILE}' is not writable. Configurations based on environment variables will be passed as command-line arguments instead."
        fi
    fi

    if is_boolean_yes "$LOGSTASH_ENABLE_MULTIPLE_PIPELINES"; then
        if [[ -e "${LOGSTASH_MOUNTED_CONF_DIR}/pipelines.yml" ]]; then
            info "Detected mounted 'pipelines.yml' configuration file for multiple pipelines"
        else
            logstash_create_sample_pipelines_yml_file
        fi
    fi

    # Skip further configuration if Logstash pipeline configuration was passed as a string
    [[ -n "$LOGSTASH_PIPELINE_CONF_STRING" ]] && return

    if ! is_mounted_dir_empty "$LOGSTASH_MOUNTED_PIPELINE_CONF_DIR"; then
        info "Detected mounted pipeline configuration files"
        cp -Lr "$LOGSTASH_MOUNTED_PIPELINE_CONF_DIR"/* "$LOGSTASH_PIPELINE_CONF_DIR"
    elif [[ -e "${LOGSTASH_MOUNTED_CONF_DIR}/${LOGSTASH_PIPELINE_CONF_FILENAME}" ]]; then
        # Support for legacy configuration before configurations were separated into 'config' and 'pipeline'
        warn "Detected mounted '${LOGSTASH_MOUNTED_CONF_DIR}/${LOGSTASH_PIPELINE_CONF_FILENAME}' pipeline configuration file in legacy directory."
        warn "Support for this configuration may be deprecated in a future version of this image. Please mount the pipeline files to '${LOGSTASH_MOUNTED_PIPELINE_CONF_DIR}' instead."
        cp -Lr "${LOGSTASH_MOUNTED_CONF_DIR}/${LOGSTASH_PIPELINE_CONF_FILENAME}" "$LOGSTASH_PIPELINE_CONF_DIR"
    elif is_dir_empty "$LOGSTASH_PIPELINE_CONF_DIR"; then
        logstash_create_sample_pipeline_config_file
    else
        info "Detected existing files in '${LOGSTASH_PIPELINE_CONF_DIR}', skipping sample pipeline generation"
    fi
}

########################
# Check if Logstash is running
# Globals:
#   LOGSTASH_PID_FILE
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_logstash_running() {
    # Logstash does not create any PID file
    # We regenerate the PID file for each time we query it to avoid getting outdated
    pgrep -f "org.logstash.Logstash" >"$LOGSTASH_PID_FILE"

    local pid
    pid="$(get_pid_from_file "$LOGSTASH_PID_FILE")"
    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if Logstash is not running
# Globals:
#   LOGSTASH_PID_FILE
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_logstash_not_running() {
    ! is_logstash_running
    return "$?"
}

########################
# Stop Logstash
# Globals:
#   LOGSTASH_PID_FILE
# Arguments:
#   None
# Returns:
#   None
#########################
logstash_stop() {
    ! is_logstash_running && return
    debug "Stopping Logstash"
    stop_service_using_pid "$LOGSTASH_PID_FILE"
}

########################
# Install Logstash plugins
# Globals:
#   LOGSTASH_*
# Arguments:
#   None
# Returns:
#   None
#########################
logstash_install_plugins() {
    read -r -a plugins_list <<<"$(tr ',;' ' ' <<<"$LOGSTASH_PLUGINS")"

    # Skip if there isn't any plugin to install
    [[ -z "${plugins_list[*]:-}" ]] && return

    # Install plugins
    info "Installing plugins: ${plugins_list[*]}"
    for plugin in "${plugins_list[@]}"; do
        debug "Installing plugin: ${plugin}"
        if [[ "${BITNAMI_DEBUG:-false}" = true ]]; then
            logstash-plugin install "$plugin"
        else
            logstash-plugin install "$plugin" >/dev/null 2>&1
        fi
    done
}
