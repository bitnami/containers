#!/bin/bash
#
# Bitnami Logstash library

# shellcheck disable=SC1090
# shellcheck disable=SC1091

# Load Generic Libraries
. /liblog.sh
. /libvalidations.sh
. /libos.sh
. /libfs.sh

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
export LOGSTASH_LOG_FILE="${LOGSTASH_LOG_DIR}/logstash-plain.log"
export LOGSTASH_MOUNTED_CONF_DIR="${LOGSTASH_VOLUME_DIR}/config"

## Users
export LOGSTASH_DAEMON_USER="logstash"
export LOGSTASH_DAEMON_GROUP="logstash"

## Exposed
export LOGSTASH_API_PORT_NUMBER="${LOGSTASH_API_PORT_NUMBER:-9600}"
export LOGSTASH_CONF_STRING="${LOGSTASH_CONF_STRING:-}"
export LOGSTASH_EXPOSE_API="${LOGSTASH_EXPOSE_API:-no}"
EOF
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

        if [[ -e "$LOGSTASH_CONF_FILE" ]]; then
            info "Config file detected."
        else
            info "Deploying Logstash with dummy config file..."
            logstash_create_dummy_config_file
        fi
    fi
}
