#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami OpenResty library

# shellcheck disable=SC1090,SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh

# Functions

########################
# Check if OpenResty is running
# Globals:
#   OPENRESTY_PID_FILE
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_openresty_running() {
    local pid
    pid="$(get_pid_from_file "$OPENRESTY_PID_FILE")"
    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if OpenResty is not running
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_openresty_not_running() {
    ! is_openresty_running
}

########################
# Stop OpenResty
# Globals:
#   OPENRESTY_PID_FILE
# Arguments:
#   None
# Returns:
#   None
#########################
openresty_stop() {
    ! is_openresty_running && return
    debug "Stopping OpenResty"
    stop_service_using_pid "$OPENRESTY_PID_FILE"
}

########################
# Configure OpenResty server block port
# Globals:
#   OPENRESTY_CONF_DIR
# Arguments:
#    $1 - Port number
#    $2 - (optional) Path to server block file
# Returns:
#   None
#########################
openresty_configure_port() {
    local port=${1:?missing port}
    local file=${2:-"$OPENRESTY_CONF_FILE"}
    if is_file_writable "$file"; then
        local openresty_configuration
        debug "Setting port number to ${port} in '${file}'"
        # TODO: find an appropriate NGINX parser to avoid 'sed calls'
        openresty_configuration="$(sed -E "s/(listen\s+)[0-9]{1,5};/\1${port};/g" "$file")"
        echo "$openresty_configuration" > "$file"
    fi
}

########################
# Validate settings in OPENRESTY_* env vars
# Globals:
#   OPENRESTY_*
# Arguments:
#   None
# Returns:
#   None
#########################
openresty_validate() {
    info "Validating settings in OPENRESTY_* env vars"

    if [[ -n "${OPENRESTY_HTTP_PORT_NUMBER:-}" ]]; then
        local -a validate_port_args=()
        ! am_i_root && validate_port_args+=("-unprivileged")
        validate_port_args+=("${OPENRESTY_HTTP_PORT_NUMBER}")
        if ! err=$(validate_port "${validate_port_args[@]}"); then
            error "An invalid port was specified in the environment variable OPENRESTY_HTTP_PORT_NUMBER: $err"
            exit 1
        fi
    fi

    if ! is_file_writable "$OPENRESTY_CONF_FILE"; then
        warn "The OpenResty configuration file '${OPENRESTY_CONF_FILE}' is not writable by current user. Configurations based on environment variables will not be applied."
    fi
}

########################
# Initialize OpenResty
# Globals:
#   OPENRESTY_*
# Arguments:
#   None
# Returns:
#   None
#########################
openresty_initialize() {
    info "Initializing OpenResty"

    # This fixes an issue where the trap would kill the entrypoint.sh, if a PID was left over from a previous run
    # Exec replaces the process without creating a new one, and when the container is restarted it may have the same PID
    rm -f "$OPENRESTY_PID_FILE"

    # Persisted configuration files from old versions
    if [[ -f "$OPENRESTY_VOLUME_DIR/conf/nginx.conf" ]]; then
        error "A 'nginx.conf' file was found inside '${OPENRESTY_VOLUME_DIR}/conf'. This configuration is not supported anymore. Please mount the configuration file at '${OPENRESTY_CONF_FILE}' instead."
        exit 1
    fi
    if ! is_dir_empty "$OPENRESTY_VOLUME_DIR/conf/vhosts"; then
        error "Custom server blocks files were found inside '$OPENRESTY_VOLUME_DIR/conf/vhosts'. This configuration is not supported anymore. Please mount your custom server blocks config files at '${OPENRESTY_SERVER_BLOCKS_DIR}' instead."
        exit 1
    fi

    debug "Updating OpenResty configuration based on environment variables"
    local openresty_user_configuration
    if am_i_root; then
        debug "Ensuring OpenResty daemon user/group exists"
        ensure_user_exists "$OPENRESTY_DAEMON_USER" --group "$OPENRESTY_DAEMON_GROUP"
        if [[ -n "${OPENRESTY_DAEMON_USER:-}" ]]; then
            chown -R "${OPENRESTY_DAEMON_USER:-}" "$OPENRESTY_TMP_DIR"
        fi
        openresty_user_configuration="$(sed -E "s/^(user\s+).*/\1 ${OPENRESTY_DAEMON_USER:-} ${OPENRESTY_DAEMON_GROUP:-};/g" "$OPENRESTY_CONF_FILE")"
        is_file_writable "$OPENRESTY_CONF_FILE" && echo "$openresty_user_configuration" > "$OPENRESTY_CONF_FILE"
    else
        # The "user" directive makes sense only if the master process runs with super-user privileges
        # TODO: find an appropriate OpenResty parser to avoid 'sed calls'
        openresty_user_configuration="$(sed -E "s/(^user)/# \1/g" "$OPENRESTY_CONF_FILE")"
        is_file_writable "$OPENRESTY_CONF_FILE" && echo "$openresty_user_configuration" > "$OPENRESTY_CONF_FILE"
    fi
    if [[ -n "${OPENRESTY_HTTP_PORT_NUMBER:-}" ]]; then
        openresty_configure_port "$OPENRESTY_HTTP_PORT_NUMBER"
    fi
}

########################
# Run custom initialization scripts
# Globals:
#   OPENRESTY_*
# Arguments:
#   None
# Returns:
#   None
#########################
openresty_custom_init_scripts() {
    info "Loading custom scripts..."
    if [[ -d "$OPENRESTY_INITSCRIPTS_DIR" ]] && [[ -n $(find "$OPENRESTY_INITSCRIPTS_DIR/" -type f -regex ".*\.sh") ]] && [[ ! -f "$OPENRESTY_VOLUME_DIR/.user_scripts_initialized" || "$OPENRESTY_FORCE_INITSCRIPTS" == "true" ]]; then
        info "Loading user's custom files from $OPENRESTY_INITSCRIPTS_DIR ..."
        find "$OPENRESTY_INITSCRIPTS_DIR/" -type f -regex ".*\.sh" | sort | while read -r f; do
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
        done
        touch "$OPENRESTY_VOLUME_DIR"/.user_scripts_initialized
    fi
}
