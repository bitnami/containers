#!/bin/bash
#
# Bitnami Logstash library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libfs.sh

########################
# Loads global variables used on LogstashLogstash configuration.
# Globals:
# Arguments:
#   None
# Returns:
#   Series of exports to be used as 'eval' arguments
#########################
logstash_env() {
    cat <<"EOF"
# Bitnami debug
export MODULE=logstash
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

## Paths
export LOGSTASH_BASE_DIR="/opt/bitnami/logstash"
export LOGSTASH_VOLUME_DIR="${LOGSTASH_VOLUME_DIR:-/bitnami/logstash}"
export LOGSTASH_DATA_DIR="${LOGSTASH_BASE_DIR}/data"
export LOGSTASH_CONF_DIR="${LOGSTASH_BASE_DIR}/config"
export LOGSTASH_BIN_DIR="${LOGSTASH_BASE_DIR}/bin"
export LOGSTASH_LOG_DIR="${LOGSTASH_BASE_DIR}/logs"
export LOGSTASH_CONF_FILENAME="${LOGSTASH_CONF_FILENAME:-default_config.conf}"
export LOGSTASH_CONF_FILE="${LOGSTASH_CONF_DIR}/${LOGSTASH_CONF_FILENAME}"
export LOGSTASH_PIPELINES_FILE="${LOGSTASH_CONF_DIR}/pipelines.yml"
export LOGSTASH_LOG_FILE="${LOGSTASH_LOG_DIR}/logstash-plain.log"
export LOGSTASH_MOUNTED_CONF_DIR="${LOGSTASH_VOLUME_DIR}/config"

## Users
export LOGSTASH_DAEMON_USER="logstash"
export LOGSTASH_DAEMON_GROUP="logstash"

## Exposed
export LOGSTASH_API_PORT_NUMBER="${LOGSTASH_API_PORT_NUMBER:-9600}"
export LOGSTASH_CONF_STRING="${LOGSTASH_CONF_STRING:-}"
export LOGSTASH_EXPOSE_API="${LOGSTASH_EXPOSE_API:-no}"

## Configuration
export LOGSTASH_ENABLE_MULTIPLE_PIPELINES="${LOGSTASH_ENABLE_MULTIPLE_PIPELINES:-false}"
export LOGSTASH_HEAP_SIZE="${LOGSTASH_HEAP_SIZE:-1g}"
export LOGSTASH_MAX_ALLOWED_MEMORY_PERCENTAGE="${LOGSTASH_MAX_ALLOWED_MEMORY_PERCENTAGE:-100}"
EOF
}

########################
# Create dummy config file
# Globals:
#   LOGSTASH_*
# Arguments:
#   None
# Returns:
#   None
#########################
logstash_create_dummy_config_file() {
    info "Creating dummy config file"
    cat > "$LOGSTASH_CONF_FILE" <<EOF
input {
  http { port => 8080 }
}

output {
  stdout {}
}
EOF
}

########################
# Create dummy pipeline file
# Globals:
#   LOGSTASH_*
# Arguments:
#   None
# Returns:
#   None
#########################
logstash_create_dummy_pipeline_file() {
    info "Creating dummy pipeline file"
    cat > "$LOGSTASH_PIPELINES_FILE" <<EOF
- pipeline.id: my-pipeline_1
  path.config: "$LOGSTASH_CONF_FILE"
EOF
}

########################
# Validate settings in Logstash environment variables
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
logstash_validate() {
    debug "Validating settings in LOGSTASH_* env vars..."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    if ! err=$(validate_port "$LOGSTASH_API_PORT_NUMBER"); then
        print_validation_error "An invalid port was specified in the environment variable LOGSTASH_API_PORT_NUMBER: $err"
    fi

    if ! is_yes_no_value "$LOGSTASH_EXPOSE_API"; then
        print_validation_error "The values allowed for LOGSTASH_EXPOSE_API are: yes or no"
    fi

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Copy mounted configuration files
# Globals:
#   LOGSTASH_*
# Arguments:
#   None
# Returns:
#   None
#########################
logstash_copy_mounted_config() {
    if ! is_dir_empty "$LOGSTASH_MOUNTED_CONF_DIR"; then
        info "Mounted config directory detected"
        cp -Lr "$LOGSTASH_MOUNTED_CONF_DIR"/* "$LOGSTASH_CONF_DIR"
    fi
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
        debug "Using specified values for Xmx and Xms heap options..."
        heap_size="$LOGSTASH_HEAP_SIZE"
    else
        debug "Calculating appropiate Xmx and Xms values..."
        local machine_mem=""
        machine_mem="$(get_total_memory)"
        if [[ "$machine_mem" -lt 65536 ]]; then
            local max_allowed_memory
            local calculated_heap_size
            calculated_heap_size="$((machine_mem / 2))"
            max_allowed_memory="$((LOGSTASH_MAX_ALLOWED_MEMORY_PERCENTAGE * machine_mem))"
            max_allowed_memory="$((max_allowed_memory / 100))"
            if [[ "$calculated_heap_size" -gt "$max_allowed_memory" ]]; then
                info "Calculated Java heap size of ${calculated_heap_size} will be limited to ${max_allowed_memory}"
                calculated_heap_size="$max_allowed_memory"
            fi
            heap_size="${calculated_heap_size}m"

        else
            heap_size=32768m
        fi
    fi
    debug "Setting '-Xmx${heap_size} -Xms${heap_size}' heap options..."
    replace_in_file "${LOGSTASH_CONF_DIR}/jvm.options" "-Xmx[0-9]+[mg]+" "-Xmx${heap_size}"
    replace_in_file "${LOGSTASH_CONF_DIR}/jvm.options" "-Xms[0-9]+[mg]+" "-Xms${heap_size}"
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
    info "Initializing Logstash server..."

    am_i_root && chown -LR "$LOGSTASH_DAEMON_USER":"$LOGSTASH_DAEMON_GROUP" "$LOGSTASH_LOG_DIR" "$LOGSTASH_CONF_DIR" "$LOGSTASH_BIN_DIR" "$LOGSTASH_LIB_DIR" "$LOGSTASH_DATA_DIR"

    if [[ -z "$LOGSTASH_CONF_STRING" ]]; then
        logstash_copy_mounted_config

        if [[ -e "$LOGSTASH_MOUNTED_CONF_DIR/$LOGSTASH_CONF_FILENAME" ]]; then
            info "User's config file detected."
        else
            logstash_create_dummy_config_file
        fi

        if is_boolean_yes "$LOGSTASH_ENABLE_MULTIPLE_PIPELINES"; then
            if [[ -e "$LOGSTASH_MOUNTED_CONF_DIR/pipelines.yml" ]]; then
                info "User's pipelines file detected."
            else
                logstash_create_dummy_pipeline_file
            fi
        fi
    fi
    logstash_set_heap_size
}
