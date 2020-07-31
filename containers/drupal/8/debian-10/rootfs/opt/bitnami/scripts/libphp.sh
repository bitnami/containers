#!/bin/bash
#
# Bitnami PHP library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh

########################
# Add or modify an entry in the main PHP configuration file (php.ini)
# Globals:
#   PHP_CONF_FILE
# Arguments:
#   $1 - Key
#   $2 - Value
#   $3 - File to modify (default: $PHP_CONF_FILE)
# Returns:
#   None
#########################
php_conf_set() {
    local -r key="${1:?key missing}"
    local -r value="${2:?value missing}"
    local -r file="${3:-"$PHP_CONF_FILE"}"
    local pattern="^[;\s]*${key}\s*=.*$"
    if [[ "$key" = "extension" || "$key" = "zend_extension" ]]; then
        # The "extension" property works a bit different for PHP, as there is one per module to be included, meaning it is additive unlike other configurations
        # Because of that, we first check if the extension was defined in the file to replace the proper entry
        pattern="^[;\s]*${key}\s*=\s*[\"]?${value}(\.so)?[\"]?\s*$"
    fi
    local -r entry="${key} = ${value}"
    if is_file_writable "$file"; then
        # Not using the ini-file tool since it does not play well with php.ini
        if grep -q -E "$pattern" "$file"; then
            replace_in_file "$file" "$pattern" "$entry"
        else
            cat >> "$file" <<< "$entry"
        fi
    else
        warn "The PHP configuration file '${file}' is not writable. The '${key}' option will not be configured."
    fi
}

########################
# Ensure PHP is initialized
# Globals:
#   PHP_*
# Arguments:
#   None
# Returns:
#   None
#########################
php_initialize() {
    # Configure PHP options based on the runtime environment
    info "Configuring PHP options"
    ! is_empty_value "$PHP_UPLOAD_MAX_FILESIZE" && info "Setting PHP upload_max_filesize option" && php_conf_set upload_max_filesize "$PHP_UPLOAD_MAX_FILESIZE"
    ! is_empty_value "$PHP_POST_MAX_SIZE" && info "Setting PHP post_max_size option" && php_conf_set post_max_size "$PHP_POST_MAX_SIZE"
    ! is_empty_value "$PHP_MEMORY_LIMIT" && info "Setting PHP memory_limit option" && php_conf_set memory_limit "$PHP_MEMORY_LIMIT"
    ! is_empty_value "$PHP_MAX_EXECUTION_TIME" && info "Setting PHP max_execution_time option" && php_conf_set max_execution_time "$PHP_MAX_EXECUTION_TIME"

    # PHP-FPM configuration
    ! is_empty_value "$PHP_FPM_LISTEN_ADDRESS" && info "Setting PHP-FPM listen option" && php_conf_set "listen" "$PHP_FPM_LISTEN_ADDRESS" "${PHP_CONF_DIR}/php-fpm.d/www.conf"

    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Convert a yes/no value to a PHP boolean
# Globals:
#   None
# Arguments:
#   $1 - yes/no value
# Returns:
#   None
#########################
php_convert_to_boolean() {
    local -r value="${1:?missing value}"
    is_boolean_yes "$value" && echo "true" || echo "false"
}

########################
# Stop PHP-FPM
# Globals:
#   PHP_FPM_PID_FILE
# Arguments:
#   $1 - Signal (default: SIGTERM)
# Returns:
#   None
#########################
php_fpm_stop() {
    local -r signal="${1:-}"
    is_php_fpm_not_running && return
    stop_service_using_pid "$PHP_FPM_PID_FILE" "$signal"
}

########################
# Reload PHP-FPM configuration
# Globals:
#   PHP_FPM_PID_FILE
# Arguments:
#   None
# Returns:
#   None
#########################
php_fpm_reload() {
    php_fpm_stop "USR2"
}

########################
# Check if PHP-FPM is running
# Globals:
#   PHP_FPM_PID_FILE
# Arguments:
#   None
# Returns:
#   true if PHP-FPM is running, false otherwise
########################
is_php_fpm_running() {
    local pid
    pid="$(get_pid_from_file "$PHP_FPM_PID_FILE")"
    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if PHP-FPM is running
# Globals:
#   PHP_FPM_PID_FILE
# Arguments:
#   None
# Returns:
#   true PHP-FPM is not running, false otherwise
########################
is_php_fpm_not_running() {
    ! is_php_fpm_running
}
