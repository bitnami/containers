#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami phpMyAdmin library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libphp.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libwebserver.sh

########################
# Validate settings in PHPMYADMIN_* env vars
# Globals:
#   PHPMYADMIN_*
# Arguments:
#   None
# Returns:
#   None
#########################
phpmyadmin_validate() {
    debug "Validating settings in PHPMYADMIN_* environment variables..."
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

    is_file_writable "$PHPMYADMIN_CONF_FILE" || warn "The phpMyAdmin configuration file '${PHPMYADMIN_CONF_FILE}' is not writable. Configurations based on environment variables will not be applied for this file."

    is_empty_value "${REQUIRE_LOCAL:-}" || warn "The usage of 'REQUIRE_LOCAL' is deprecated. It will not be taken into account."
    is_empty_value "${PHPMYADMIN_ALLOW_NO_PASSWORD:-}" || warn "The usage of 'PHPMYADMIN_ALLOW_NO_PASSWORD' is deprecated and will soon be removed. Use 'DATABASE_ALLOW_NO_PASSWORD' instead."

    is_empty_value "$PHPMYADMIN_ALLOW_ARBITRARY_SERVER" || check_yes_no_value PHPMYADMIN_ALLOW_ARBITRARY_SERVER
    check_yes_no_value PHPMYADMIN_ALLOW_REMOTE_CONNECTIONS
    is_empty_value "$DATABASE_ALLOW_NO_PASSWORD" || check_yes_no_value DATABASE_ALLOW_NO_PASSWORD
    is_empty_value "$DATABASE_ENABLE_SSL" || check_yes_no_value DATABASE_ENABLE_SSL

    check_yes_no_value CONFIGURATION_STORAGE_ENABLE
    if is_boolean_yes "$CONFIGURATION_STORAGE_ENABLE"; then
        for ev in \
                "CONFIGURATION_STORAGE_DB_HOST" \
                "CONFIGURATION_STORAGE_DB_PORT_NUMBER" \
                "CONFIGURATION_STORAGE_DB_USER" \
                "CONFIGURATION_STORAGE_DB_PASSWORD" \
                "CONFIGURATION_STORAGE_DB_NAME"; do
            is_empty_value "${!ev}" && print_validation_error "The ${ev} environment variable is empty or not set."
        done
    fi

    return "$error_code"
}

########################
# Ensure phpMyAdmin is initialized
# Globals:
#   PHPMYADMIN_*
# Arguments:
#   None
# Returns:
#   None
#########################
phpmyadmin_initialize() {
    ! is_file_writable "$PHPMYADMIN_CONF_FILE" && return

    if [[ -f "$PHPMYADMIN_MOUNTED_CONF_FILE" ]]; then
        info "Found mounted phpMyAdmin configuration file '${PHPMYADMIN_MOUNTED_CONF_FILE}', copying to '${PHPMYADMIN_CONF_FILE}'"
        cp "$PHPMYADMIN_MOUNTED_CONF_FILE" "$PHPMYADMIN_CONF_FILE"
        return
    fi

    info "Configuring phpMyAdmin"

    # Allow arbitrary server
    ! is_empty_value "$PHPMYADMIN_ALLOW_ARBITRARY_SERVER" && info "Setting AllowArbitraryServer option" && phpmyadmin_conf_set "\$cfg['AllowArbitraryServer']" "$(php_convert_to_boolean "$PHPMYADMIN_ALLOW_ARBITRARY_SERVER")" yes

    # Support reverse proxy
    ! is_empty_value "$PHPMYADMIN_ABSOLUTE_URI" && info "Setting PmaAbsoluteUri option" && phpmyadmin_conf_set "\$cfg['PmaAbsoluteUri']" "$PHPMYADMIN_ABSOLUTE_URI"

    # Configure database settings
    ! is_empty_value "$DATABASE_HOST" && info "Setting database host option" && phpmyadmin_conf_set "\$cfg['Servers'][\$i]['host']" "$DATABASE_HOST"
    ! is_empty_value "$DATABASE_PORT_NUMBER" && info "Setting database port number option" && phpmyadmin_conf_set "\$cfg['Servers'][\$i]['port']" "$DATABASE_PORT_NUMBER"
    ! is_empty_value "$DATABASE_ALLOW_NO_PASSWORD" && info "Setting AllowNoPassword option" && phpmyadmin_conf_set "\$cfg['Servers'][\$i]['AllowNoPassword']" "$(php_convert_to_boolean "$DATABASE_ALLOW_NO_PASSWORD")" yes
    if is_boolean_yes "$DATABASE_ENABLE_SSL"; then
        local database_ssl_option_env_var
        info "Configuring SSL options"
        phpmyadmin_conf_set "\$cfg['Servers'][\$i]['ssl']" true yes
        [ -f "$DATABASE_SSL_KEY" ] && phpmyadmin_conf_set "\$cfg['Servers'][\$i]['ssl_key']" "$DATABASE_SSL_KEY"
        [ -f "$DATABASE_SSL_CERT" ] && phpmyadmin_conf_set "\$cfg['Servers'][\$i]['ssl_cert']" "$DATABASE_SSL_CERT"
        [ -f "$DATABASE_SSL_CA" ] && phpmyadmin_conf_set "\$cfg['Servers'][\$i]['ssl_ca']" "$DATABASE_SSL_CA"
        ! is_empty_value "$DATABASE_SSL_CA_PATH" && phpmyadmin_conf_set "\$cfg['Servers'][\$i]['ssl_ca_path']" "$DATABASE_SSL_CA_PATH"
        ! is_empty_value "$DATABASE_SSL_CIPHERS" && phpmyadmin_conf_set "\$cfg['Servers'][\$i]['ssl_ciphers']" "$DATABASE_SSL_CIPHERS"
        ! is_empty_value "$DATABASE_SSL_VERIFY" && phpmyadmin_conf_set "\$cfg['Servers'][\$i]['ssl_verify']" "$(php_convert_to_boolean "$DATABASE_SSL_VERIFY")" yes
    fi

    # Configure configuration storage settings
    if is_boolean_yes "$CONFIGURATION_STORAGE_ENABLE"; then
        phpmyadmin_conf_set "\$cfg['Servers'][\$i]['controlhost']" "$CONFIGURATION_STORAGE_DB_HOST" no
        phpmyadmin_conf_set "\$cfg['Servers'][\$i]['controlport']" "$CONFIGURATION_STORAGE_DB_PORT_NUMBER" no
        phpmyadmin_conf_set "\$cfg['Servers'][\$i]['controluser']" "$CONFIGURATION_STORAGE_DB_USER" no
        phpmyadmin_conf_set "\$cfg['Servers'][\$i]['controlpass']" "$CONFIGURATION_STORAGE_DB_PASSWORD" no
        phpmyadmin_conf_set "\$cfg['Servers'][\$i]['pmadb']" "$CONFIGURATION_STORAGE_DB_NAME" no
        replace_in_file "$PHPMYADMIN_CONF_FILE" "^(\s*//\s*)?(\\\$cfg\['Servers'\]\[\\\$i\]\['.*']\s*=)" "\2" true
    fi

    # Configure allow deny order/rules settings
    ! is_empty_value "$CONFIGURATION_ALLOWDENY_ORDER" && phpmyadmin_conf_set "\$cfg['Servers'][\$i]['AllowDeny']['order']" "$CONFIGURATION_ALLOWDENY_ORDER"
    ! is_empty_value "$CONFIGURATION_ALLOWDENY_RULES" && phpmyadmin_conf_set "\$cfg['Servers'][\$i]['AllowDeny']['rules']" "array($CONFIGURATION_ALLOWDENY_RULES)" yes

    # Configure automatic login with account
    if ! is_empty_value "$DATABASE_USER"; then
      info "Setting auth_type option" && phpmyadmin_conf_set "\$cfg['Servers'][\$i]['auth_type']" config
      info "Setting database user option" && phpmyadmin_conf_set "\$cfg['Servers'][\$i]['user']" "$DATABASE_USER"
      ! is_empty_value "$DATABASE_PASSWORD" && info "Setting database password option" && phpmyadmin_conf_set "\$cfg['Servers'][\$i]['password']" "$DATABASE_PASSWORD"
    fi

    # Generate random blowfish secret, used for encrypting
    info "Setting blowfish_secret option to a randomly generated value"
    local blowfish_secret
    blowfish_secret="$(generate_random_string -t alphanumeric -c 32)"
    phpmyadmin_conf_set "\$cfg['blowfish_secret']" "$blowfish_secret"
}

########################
# Add or modify an entry in the phpMyAdmin configuration file (config.inc.php)
# Globals:
#   PHPMYADMIN_*
# Arguments:
#   $1 - PHP variable name
#   $2 - Value to assign to the PHP variable
#   $3 - Whether the value is a literal, or if instead it should be quoted (default: no)
# Returns:
#   None
#########################
phpmyadmin_conf_set() {
    local -r key="${1:?key missing}"
    local -r value="${2:?value missing}"
    local -r is_literal="${3:-no}"
    debug "Setting ${key} to '${value}' in phpMyAdmin configuration (literal: ${is_literal})"
    # Sanitize key (sed does not support fixed string substitutions)
    local sanitized_pattern
    sanitized_pattern="^(\s*//\s*)?$(sed 's/[]\[^$.*/]/\\&/g' <<< "$key")\s*=.*"
    local entry
    is_boolean_yes "$is_literal" && entry="${key} = $value;" || entry="${key} = '$value';"
    # Check if the configuration exists in the file
    if grep -q -E "$sanitized_pattern" "$PHPMYADMIN_CONF_FILE"; then
        # It exists, so replace the line
        replace_in_file "$PHPMYADMIN_CONF_FILE" "$sanitized_pattern" "$entry"
    else
        # It does not exist, so add new line
        cat >> "$PHPMYADMIN_CONF_FILE" <<< "$entry"
    fi
}

########################
# Render web server configuration for phpMyAdmin
# Globals:
#   PHPMYADMIN_*
#   WEB_SERVER_*
# Arguments:
#   None
# Returns:
#   None
#########################
phpmyadmin_ensure_web_server_app_configuration_exists() {
    web_server_validate
    local allow_remote_connections="$PHPMYADMIN_ALLOW_REMOTE_CONNECTIONS"
    ensure_web_server_app_configuration_exists "phpmyadmin" \
        --type php \
        --allow-remote-connections "$allow_remote_connections"
}

########################
# Render web server configuration for phpMyAdmin
# Globals:
#   PHPMYADMIN_*
#   WEB_SERVER_*
# Arguments:
#   None
# Returns:
#   None
#########################
phpmyadmin_ensure_web_server_prefix_configuration_exists() {
    web_server_validate
    local prefix="${PHPMYADMIN_URL_PREFIX:-}"
    local allow_remote_connections="$PHPMYADMIN_ALLOW_REMOTE_CONNECTIONS"
    ensure_web_server_prefix_configuration_exists "phpmyadmin" \
        --type php \
        --prefix "$prefix" \
        --allow-remote-connections "$allow_remote_connections"
}
