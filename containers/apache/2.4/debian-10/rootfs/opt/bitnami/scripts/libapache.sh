#!/bin/bash
#
# Bitnami Apache library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libservice.sh

########################
# Validate settings in APACHE_* env vars
# Globals:
#   APACHE_*
# Arguments:
#   None
# Returns:
#   None
#########################
apache_validate() {
    debug "Validating settings in APACHE_* environment variables..."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    check_allowed_port() {
        local port_var="${1:?missing port variable}"
        local validate_port_args=()
        ! am_i_root && validate_port_args+=("-unprivileged")
        if ! err=$(validate_port "${validate_port_args[@]}" "${!port_var}"); then
            print_validation_error "An invalid port was specified in the environment variable ${port_var}: ${err}."
        fi
    }

    [[ -w "$APACHE_CONF_FILE" ]] || warn "The Apache configuration file '${APACHE_CONF_FILE}' is not writable. Configurations based on environment variables will not be applied."

    if [[ -n "$APACHE_HTTP_PORT_NUMBER" ]] && [[ -n "$APACHE_HTTPS_PORT_NUMBER" ]]; then
        if [[ "$APACHE_HTTP_PORT_NUMBER" -eq "$APACHE_HTTPS_PORT_NUMBER" ]]; then
            print_validation_error "APACHE_HTTP_PORT_NUMBER and APACHE_HTTPS_PORT_NUMBER are bound to the same port!"
        fi
    fi

    [[ -n "$APACHE_HTTP_PORT_NUMBER" ]] && check_allowed_port APACHE_HTTP_PORT_NUMBER
    [[ -n "$APACHE_HTTPS_PORT_NUMBER" ]] && check_allowed_port APACHE_HTTPS_PORT_NUMBER

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Configure Apache's HTTP port
# Globals:
#   APACHE_CONF_FILE, APACHE_CONF_DIR
# Arguments:
#   None
# Returns:
#   None
#########################
apache_configure_http_port() {
    local -r port=${1:?missing port}
    local -r listen_exp="s|^\s*Listen\s+([^:]*:)?[0-9]+\s*$|Listen ${port}|"
    local -r server_name_exp="s|^\s*#?\s*ServerName\s+([^:\s]+)(:[0-9]+)?$|ServerName \1:${port}|"
    local -r vhost_exp="s|VirtualHost\s+([^:>]+)(:[0-9]+)|VirtualHost \1:${port}|"
    local apache_configuration

    if [[ -w "$APACHE_CONF_FILE" ]]; then
        debug "Configuring port ${port} on file ${APACHE_CONF_FILE}"
        apache_configuration="$(sed -E -e "$listen_exp" -e "$server_name_exp" "$APACHE_CONF_FILE")"
        echo "$apache_configuration" > "$APACHE_CONF_FILE"
    fi

    if [[ -w "${APACHE_CONF_DIR}/bitnami/bitnami.conf" ]]; then
        debug "Configuring port ${port} on file ${APACHE_CONF_DIR}/bitnami/bitnami.conf"
        apache_configuration="$(sed -E "$vhost_exp" "${APACHE_CONF_DIR}/bitnami/bitnami.conf")"
        echo "$apache_configuration" > "${APACHE_CONF_DIR}/bitnami/bitnami.conf"
    fi

    if [[ -w "${APACHE_VHOSTS_DIR}/00_status-vhost.conf" ]]; then
        debug "Configuring port ${port} on file ${APACHE_VHOSTS_DIR}/00_status-vhost.conf"
        apache_configuration="$(sed -E "$vhost_exp" "${APACHE_VHOSTS_DIR}/00_status-vhost.conf")"
        echo "$apache_configuration" > "${APACHE_VHOSTS_DIR}/00_status-vhost.conf"
    fi
}

########################
# Configure Apache's HTTPS port
# Globals:
#   APACHE_CONF_DIR
# Arguments:
#   None
# Returns:
#   None
#########################
apache_configure_https_port() {
    local -r port=${1:?missing port}
    local -r listen_exp="s|^\s*Listen\s+([^:]*:)?[0-9]+\s*$|Listen ${port}|"
    local -r vhost_exp="s|VirtualHost\s+([^:>]+)(:[0-9]+)|VirtualHost \1:${port}|"
    local apache_configuration

    if [[ -w "${APACHE_CONF_DIR}/bitnami/bitnami-ssl.conf" ]]; then
        debug "Configuring port ${port} on file ${APACHE_CONF_DIR}/bitnami/bitnami-ssl.conf"
        apache_configuration="$(sed -E -e "$listen_exp" -e "$vhost_exp" "${APACHE_CONF_DIR}/bitnami/bitnami-ssl.conf")"
        echo "$apache_configuration" > "${APACHE_CONF_DIR}/bitnami/bitnami-ssl.conf"
    fi
}

########################
# Ensure Apache is initialized
# Globals:
#   APACHE_*
# Arguments:
#   None
# Returns:
#   None
#########################
apache_initialize() {
    # Copy vhosts files
    if ! is_dir_empty "/vhosts"; then
        info "Found mounted virtual hosts in '/vhosts'. Copying them to '${APACHE_BASE_DIR}/conf/vhosts'"
        cp -Lr "/vhosts/." "${APACHE_VHOSTS_DIR}"
    fi

    # Mount certificate files
    if ! is_dir_empty "${APACHE_BASE_DIR}/certs"; then
        warn "The directory '${APACHE_BASE_DIR}/certs' was externally mounted. This is a legacy configuration and will be deprecated soon. Please mount certificate files at '/certs' instead. Find an example at: https://github.com/bitnami/bitnami-docker-apache#using-custom-ssl-certificates"
        warn "Restoring certificates at '${APACHE_BASE_DIR}/certs' to '${APACHE_CONF_DIR}/bitnami/certs'..."
        rm -rf "${APACHE_CONF_DIR}/bitnami/certs"
        ln -sf "${APACHE_BASE_DIR}/certs" "${APACHE_CONF_DIR}/bitnami/certs"
    elif ! is_dir_empty "/certs"; then
        info "Mounting certificates files from '/certs'..."
        rm -rf "${APACHE_CONF_DIR}/bitnami/certs"
        ln -sf "/certs" "${APACHE_CONF_DIR}/bitnami/certs"
    fi

    # Mount application files
    if ! is_dir_empty "/app"; then
        info "Mounting application files from '/app'..."
        rm -rf "$APACHE_HTDOCS_DIR"
        ln -sf "/app" "$APACHE_HTDOCS_DIR"
    fi

    # Port configuration
    [[ -n "$APACHE_HTTP_PORT_NUMBER" ]] && info "Configuring the HTTP port" && apache_configure_http_port "$APACHE_HTTP_PORT_NUMBER"
    [[ -n "$APACHE_HTTPS_PORT_NUMBER" ]] && info "Configuring the HTTPS port" && apache_configure_https_port "$APACHE_HTTPS_PORT_NUMBER"

    # Restore persisted configuration files (deprecated)
    if ! is_dir_empty "/bitnami/apache/conf"; then
        warn "The directory '/bitnami/apache/conf' was externally mounted. This is a legacy configuration and will be deprecated soon. Please mount certificate files at '${APACHE_CONF_DIR}' instead. Find an example at: https://github.com/bitnami/bitnami-docker-apache#full-configuration"
        warn "Restoring configuration at '/bitnami/apache/conf' to '${APACHE_CONF_DIR}'..."
        rm -rf "$APACHE_CONF_DIR"
        ln -sf "/bitnami/apache/conf" "$APACHE_CONF_DIR"
    fi
}

########################
# Enable a module in the Apache configuration file
# Globals:
#   APACHE_CONF_FILE
# Arguments:
#   $1 - Module to enable
# Returns:
#   None
#########################
apache_enable_module() {
    local -r module="${1:?missing module}"
    local -r expression="s|^\s*#+\s*(LoadModule\s+[^ ]+\s+modules/${module}\.so.*)$|\1|"
    local apache_configuration

    debug "Enabling module '${module}'..."

    if [[ -w "$APACHE_CONF_FILE" ]]; then
        apache_configuration="$(sed -E "$expression" "$APACHE_CONF_FILE")"
        echo "$apache_configuration" > "$APACHE_CONF_FILE"
    fi
}

########################
# Disable a module in the Apache configuration file
# Globals:
#   APACHE_CONF_FILE
# Arguments:
#   $1 - Module to disable
# Returns:
#   None
#########################
apache_disable_module() {
    local -r module="${1:?missing module}"
    local -r expression="s|^\s*(LoadModule\s+[^ ]+\s+modules/${module}\.so.*)$|#\1|"
    local apache_configuration

    debug "Disabling module '${module}'..."

    if [[ -w "$APACHE_CONF_FILE" ]]; then
        apache_configuration="$(sed -E "$expression" "$APACHE_CONF_FILE")"
        echo "$apache_configuration" > "$APACHE_CONF_FILE"
    fi
}

########################
# Enable a configuration entry in the Apache configuration file
# Globals:
#   APACHE_CONF_FILE
# Arguments:
#   $1 - Entry to enable
# Returns:
#   None
#########################
apache_enable_configuration_entry() {
    local -r entry="${1:?missing entry}"
    local -r expression="s|^\s*#+\s*(${entry}\s*)$|\1|"
    local apache_configuration

    debug "Enabling entry '${entry}'..."

    if [[ -w "$APACHE_CONF_FILE" ]]; then
        apache_configuration="$(sed -E "$expression" "$APACHE_CONF_FILE")"
        echo "$apache_configuration" > "$APACHE_CONF_FILE"
    fi
}

########################
# Stop Apache
# Globals:
#   APACHE_*
# Arguments:
#   None
# Returns:
#   None
#########################
apache_stop() {
    is_apache_not_running && return
    stop_service_using_pid "$APACHE_PID_FILE"
}

########################
# Check if Apache is running
# Globals:
#   APACHE_PID_FILE
# Arguments:
#   None
# Returns:
#   Whether Apache is running
########################
is_apache_running() {
    local pid
    pid="$(get_pid_from_file "$APACHE_PID_FILE")"
    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if Apache is running
# Globals:
#   APACHE_PID_FILE
# Arguments:
#   None
# Returns:
#   Whether Apache is not running
########################
is_apache_not_running() {
    ! is_apache_running
}
