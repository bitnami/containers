#!/bin/bash
#
# Bitnami phpPgAdmin library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libphp.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libwebserver.sh

########################
# Validate settings in PHPPGADMIN_* env vars
# Globals:
#   PHPPGADMIN_*
# Arguments:
#   None
# Returns:
#   None
#########################
phppgadmin_validate() {
    debug "Validating settings in PHPPGADMIN_* environment variables..."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    check_yes_no_value() {
        if ! is_yes_no_value "${!1}" && ! is_true_false_value "${!1}"; then
            print_validation_error "The allowed values for $1 are [yes, no]"
        fi
    }

    is_file_writable "$PHPPGADMIN_CONF_FILE" || warn "The phpPgAdmin configuration file '${PHPPGADMIN_CONF_FILE}' is not writable. Configurations based on environment variables will not be applied for this file."

    is_empty_value "$PHPPGADMIN_ENABLE_EXTRA_LOGIN_SECURITY" || check_yes_no_value DATABASE_ENABLE_EXTRA_LOGIN_SECURITY
    check_yes_no_value PHPPGADMIN_ALLOW_REMOTE_CONNECTIONS

    web_server_validate || print_validation_error "Web server validation failed"

    return "$error_code"
}

########################
# Ensure phpPgAdmin is initialized
# Globals:
#   PHPPGADMIN_*
# Arguments:
#   None
# Returns:
#   None
#########################
phppgadmin_initialize() {
    ! is_file_writable "$PHPPGADMIN_CONF_FILE" && return

    if [[ -f "$PHPPGADMIN_MOUNTED_CONF_FILE" ]]; then
        info "Found mounted phpPgAdmin configuration file '${PHPPGADMIN_MOUNTED_CONF_FILE}', copying to '${PHPPGADMIN_CONF_FILE}'"
        cp "$PHPPGADMIN_MOUNTED_CONF_FILE" "$PHPPGADMIN_CONF_FILE"
        return
    fi

    info "Configuring phpPgAdmin"

    # Enable/disable extra login security
    ! is_empty_value "$PHPPGADMIN_ENABLE_EXTRA_LOGIN_SECURITY" && info "Setting extra_login_security option" && phppgadmin_conf_set "\$conf['extra_login_security']" "$(php_convert_to_boolean "$PHPPGADMIN_ENABLE_EXTRA_LOGIN_SECURITY")" yes

    # Configure database settings
    ! is_empty_value "$DATABASE_HOST" && info "Setting database host option" && phppgadmin_conf_set "\$conf['servers'][0]['host']" "$DATABASE_HOST"
    ! is_empty_value "$DATABASE_PORT_NUMBER" && info "Setting database port number option" && phppgadmin_conf_set "\$conf['servers'][0]['port']" "$DATABASE_PORT_NUMBER" yes
    ! is_empty_value "$DATABASE_SSL_MODE" && info "Setting database SSL mode option" && phppgadmin_conf_set "\$conf['servers'][0]['sslmode']" "$DATABASE_SSL_MODE"

    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Add or modify an entry in the phpPgAdmin configuration file (config.inc.php)
# Globals:
#   PHPPGADMIN_*
# Arguments:
#   $1 - PHP variable name
#   $2 - Value to assign to the PHP variable
#   $3 - Whether the value is a literal, or if instead it should be quoted (default: no)
# Returns:
#   None
#########################
phppgadmin_conf_set() {
    local -r key="${1:?key missing}"
    local -r value="${2:?value missing}"
    local -r is_literal="${3:-no}"
    debug "Setting ${key} to '${value}' in phpPgAdmin configuration (literal: ${is_literal})"
    # Sanitize key (sed does not support fixed string substitutions)
    local sanitized_pattern
    sanitized_pattern="(//\s*)?$(sed 's/[]\[^$.*/]/\\&/g' <<< "$key")\s*=.*"
    local entry
    is_boolean_yes "$is_literal" && entry="${key} = $value;" || entry="${key} = '$value';"
    # Check if the configuration exists in the file
    if grep -q -E "$sanitized_pattern" "$PHPPGADMIN_CONF_FILE"; then
        # It exists, so replace the line
        replace_in_file "$PHPPGADMIN_CONF_FILE" "$sanitized_pattern" "$entry"
    else
        # The phpPgAdmin configuration file includes all supported keys, but because of its format,
        # we cannot append contents to the end. We can assume thi
        warn "Could not set the phpPgAdmin '${key}' configuration. Check that the file has not been modified externally."
    fi
}

########################
# Render web server configuration for phpPgAdmin
# Globals:
#   PHPPGADMIN_*
#   WEB_SERVER_*
# Arguments:
#   None
# Returns:
#   None
#########################
phppgadmin_ensure_web_server_app_configuration_exists() {
    local -r allow_remote_connections="$PHPPGADMIN_ALLOW_REMOTE_CONNECTIONS"
    ensure_web_server_app_configuration_exists "phppgadmin" \
        --type php \
        --allow-remote-connections "$allow_remote_connections"
}

########################
# Render web server configuration for phpPgAdmin
# Globals:
#   PHPPGADMIN_*
#   WEB_SERVER_*
# Arguments:
#   None
# Returns:
#   None
#########################
phppgadmin_ensure_web_server_prefix_configuration_exists() {
    local -r prefix="${PHPPGADMIN_URL_PREFIX:-}"
    local -r allow_remote_connections="$PHPPGADMIN_ALLOW_REMOTE_CONNECTIONS"
    ensure_web_server_prefix_configuration_exists "phppgadmin" \
        --type php \
        --prefix "$prefix" \
        --allow-remote-connections "$allow_remote_connections"
}
