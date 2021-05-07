#!/bin/bash
#
# Bitnami Apache library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libfile.sh
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
    debug "Validating settings in APACHE_* environment variables"
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    check_allowed_port() {
        local port_var="${1:?missing port variable}"
        local -a validate_port_args=()
        ! am_i_root && validate_port_args+=("-unprivileged")
        validate_port_args+=("${!port_var}")
        if ! err=$(validate_port "${validate_port_args[@]}"); then
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
# Enable a module in the Apache configuration file
# Globals:
#   APACHE_CONF_FILE
# Arguments:
#   $1 - Module to enable
#   $2 - Path to module .so file (optional if already defined in httpd.conf)
# Returns:
#   None
#########################
apache_enable_module() {
    local -r name="${1:?missing name}"
    local -r file="${2:-}"
    local -r regex="[#\s]*(LoadModule\s+${name}\s+.*)$"
    local apache_configuration

    if [[ -w "$APACHE_CONF_FILE" ]]; then
        debug "Enabling module '${name}'"
        if grep -q -E "$regex" "$APACHE_CONF_FILE"; then
            # Uncomment line if the module was already defined
            replace_in_file "$APACHE_CONF_FILE" "$regex" "\1"
        elif [[ -n "$file" ]]; then
            # Add right after the last LoadModule, so all Apache modules are organized in the same section of the file
            append_file_after_last_match "$APACHE_CONF_FILE" "^[#\s]*LoadModule" "LoadModule ${name} ${file}"
        else
            error "Module ${name} was not defined in ${APACHE_CONF_FILE}. Please specify the 'file' parameter for 'apache_enable_module'."
        fi
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
    local -r name="${1:?missing name}"
    local -r file="${2:-}"
    local -r regex="[#\s]*(LoadModule\s+${name}\s+.*)$"
    local apache_configuration

    if [[ -w "$APACHE_CONF_FILE" ]]; then
        debug "Disabling module '${name}'"
        replace_in_file "$APACHE_CONF_FILE" "$regex" "#\1"
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

########################
# Ensure configuration gets added to the main Apache configuration file
# Globals:
#   APACHE_*
# Arguments:
#   $1 - configuration string
#   $2 - pattern to use for checking if the configuration already exists (default: $1)
# Returns:
#   None
########################
ensure_apache_configuration_exists() {
    local -r conf="${1:?conf missing}"
    local -r pattern="${2:-"$conf"}"
    # Enable configuration by appending to httpd.conf
    if ! grep -E -q "$pattern" "$APACHE_CONF_FILE"; then
        if is_file_writable "$APACHE_CONF_FILE"; then
            cat >> "$APACHE_CONF_FILE" <<< "$conf"
        else
            error "Could not add the following configuration to '${APACHE_CONF_FILE}:"
            error ""
            error "$(indent "$conf" 4)"
            error ""
            error "Include the configuration manually and try again."
            return 1
        fi
    fi
}

########################
# Collect all the .htaccess files from /opt/bitnami/$name and write the result in the 'htaccess' directory
# Globals:
#   APACHE_*
# Arguments:
#   $1 - App name
#   $2 - Overwrite the original .htaccess with the explanation text (defaults to 'yes')
# Flags:
#   --document-root - Path to document root directory
# Returns:
#   None
########################
apache_replace_htaccess_files() {
    local -r app="${1:?missing app}"
    local -r result_file="${APACHE_HTACCESS_DIR}/${app}-htaccess.conf"
    # Default options
    local document_root="${BITNAMI_ROOT_DIR}/${app}"
    local overwrite="yes"
    local -a htaccess_files
    local htaccess_dir
    local htaccess_contents
    # Validate arguments
    shift
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            --document-root)
                shift
                document_root="$1"
                ;;
            --overwrite)
                shift
                overwrite="$1"
                ;;
            *)
                echo "Invalid command line flag ${1}" >&2
                return 1
                ;;
        esac
        shift
    done
    if is_file_writable "$result_file"; then
        # Locate all .htaccess files inside the document root
        read -r -a htaccess_files <<< "$(find "$document_root" -name .htaccess -print0 | xargs -0)"
        [[ "${#htaccess_files[@]}" = 0 ]] && return
        # Create file with root group write privileges, so it can be modified in non-root containers
        [[ ! -f "$result_file" ]] && touch "$result_file" && chmod g+rw "$result_file"
        for htaccess_file in "${htaccess_files[@]}"; do
            htaccess_dir="$(dirname "$htaccess_file")"
            htaccess_contents="$(indent "$(< "$htaccess_file")" 2)"
            # Skip if it was already included to the resulting htaccess file
            if grep -q "^<Directory \"$htaccess_dir\">" <<< "$htaccess_contents"; then
                continue
            fi
            # Add to the htaccess file
            cat >> "$result_file" <<EOF
<Directory "${htaccess_dir}">
${htaccess_contents}
</Directory>
EOF
            # Overwrite the original .htaccess with the explanation text
            if is_boolean_yes "$overwrite"; then
                echo "# This configuration has been moved to the ${result_file} config file for performance and security reasons" > "$htaccess_file"
            fi
        done
    elif [[ ! -f "$result_file" ]]; then
        error "Could not create htaccess for ${app} at '${result_file}'. Check permissions and ownership for parent directories."
        return 1
    else
        warn "The ${app} htaccess file '${result_file}' is not writable. Configurations based on environment variables will not be applied for this file."
        return
    fi
}

########################
# Ensure an Apache application configuration exists (in virtual host format)
# Globals:
#   APACHE_*
# Arguments:
#   $1 - App name
# Flags:
#   --hosts - Hosts to enable
#   --type - Application type, which has an effect on what configuration template will be used, allowed values: php, (empty)
#   --allow-remote-connections - Whether to allow remote connections or to require local connections
#   --disabled - Whether to render the file with a .disabled prefix
#   --enable-https - Enable app configuration on HTTPS port
#   --http-port - HTTP port number
#   --https-port - HTTPS port number
#   --move-htaccess - Move .htaccess files to a common place so they can be loaded during Apache startup
#   --additional-configuration - Additional vhost configuration (no default)
#   --before-vhost-configuration - Configuration to add before the <VirtualHost> directive (no default)
#   --allow-override - Whether to allow .htaccess files (only allowed when --move-htaccess is set to 'no')
#   --document-root - Path to document root directory
#   --extra-directory-configuration - Extra configuration for the document root directory
# Returns:
#   true if the configuration was enabled, false otherwise
########################
ensure_apache_app_configuration_exists() {
    local -r app="${1:?missing app}"
    # Default options
    local -a hosts=("127.0.0.1" "_default_")
    local type=""
    local allow_remote_connections="yes"
    local disabled="no"
    local enable_https="yes"
    local http_port="${APACHE_HTTP_PORT_NUMBER:-"$APACHE_DEFAULT_HTTP_PORT_NUMBER"}"
    local https_port="${APACHE_HTTPS_PORT_NUMBER:-"$APACHE_DEFAULT_HTTPS_PORT_NUMBER"}"
    local move_htaccess="yes"
    local var_name
    # Template variables defaults
    export additional_configuration=""
    export before_vhost_configuration=""
    export allow_override="All"
    export document_root="${BITNAMI_ROOT_DIR}/${app}"
    export extra_directory_configuration=""
    export proxy_address=""
    # Validate arguments
    shift
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            --hosts)
                shift
                read -r -a hosts <<< "$1"
                ;;
            --type \
            | --allow-remote-connections \
            | --disabled \
            | --enable-https \
            | --http-port \
            | --https-port \
            | --move-htaccess \
            | --additional-configuration \
            | --before-vhost-configuration \
            | --allow-override \
            | --document-root \
            | --extra-directory-configuration \
            | --proxy-address \
            )
                var_name="$(echo "$1" | sed -e "s/^--//" -e "s/-/_/g")"
                shift
                export "${var_name}"="$1"
                ;;
            *)
                echo "Invalid command line flag $1" >&2
                return 1
                ;;
        esac
        shift
    done
    # Construct host string in the format of "host1:port1[ host2:port2[ ...]]"
    export http_listen_addresses=""
    export https_listen_addresses=""
    for host in "${hosts[@]}"; do
        http_listen="${host}:${http_port}"
        https_listen="${host}:${https_port}"
        [[ -z "${http_listen_addresses:-}" ]] && http_listen_addresses="$http_listen" || http_listen_addresses="${http_listen_addresses} ${http_listen}"
        [[ -z "${https_listen_addresses:-}" ]] && https_listen_addresses="$https_listen" || https_listen_addresses="${https_listen_addresses} ${https_listen}"
    done
    # App .htaccess support
    export htaccess_include
    is_boolean_yes "$move_htaccess" && apache_replace_htaccess_files "$app" --document-root "$document_root"
    if [[ -f "${APACHE_HTACCESS_DIR}/${app}-htaccess.conf" ]]; then
        allow_override="None"
        htaccess_include="Include \"${APACHE_HTACCESS_DIR}/${app}-htaccess.conf\""
    else
        allow_override="$allow_override"
        htaccess_include=""
    fi
    # ACL configuration
    export acl_configuration
    if is_boolean_yes "$allow_remote_connections"; then
        acl_configuration="Require all granted"
    else
        acl_configuration="$(cat <<EOF
Require local
ErrorDocument 403 "For security reasons, this URL is only accessible using localhost (127.0.0.1) as the hostname."
# AuthType Basic
# AuthName ${app}
# AuthUserFile "${APACHE_BASE_DIR}/users"
# Require valid-user
EOF
)"
    fi
    # Indent configurations
    additional_configuration="$(indent $'\n'"$additional_configuration" 2)"
    htaccess_include="$(indent $'\n'"$htaccess_include" 2)"
    extra_directory_configuration="$(indent $'\n'"$extra_directory_configuration" 4)"
    # Render templates
    # We remove lines that are empty or contain only newspaces with 'sed', so the resulting file looks better
    local template_name="app"
    [[ -n "$type" && "$type" != "php" ]] && template_name="app-${type}"
    local -r template_dir="${BITNAMI_ROOT_DIR}/scripts/apache/bitnami-templates"
    local vhost_suffix=""
    is_boolean_yes "$disabled" && vhost_suffix=".disabled"
    local -r http_vhost="${APACHE_VHOSTS_DIR}/${app}-vhost.conf${vhost_suffix}"
    local -r https_vhost="${APACHE_VHOSTS_DIR}/${app}-https-vhost.conf${vhost_suffix}"
    if is_file_writable "$http_vhost"; then
        # Create file with root group write privileges, so it can be modified in non-root containers
        [[ ! -f "$http_vhost" ]] && touch "$http_vhost" && chmod g+rw "$http_vhost"
        render-template "${template_dir}/${template_name}-http-vhost.conf.tpl" | sed '/^\s*$/d' > "$http_vhost"
    elif [[ ! -f "$http_vhost" ]]; then
        error "Could not create virtual host for ${app} at '${http_vhost}'. Check permissions and ownership for parent directories."
        return 1
    else
        warn "The ${app} virtual host file '${http_vhost}' is not writable. Configurations based on environment variables will not be applied for this file."
    fi
    if is_boolean_yes "$enable_https"; then
        if is_file_writable "$https_vhost"; then
            # Create file with root group write privileges, so it can be modified in non-root containers
            [[ ! -f "$https_vhost" ]] && touch "$https_vhost" && chmod g+rw "$https_vhost"
            render-template "${template_dir}/${template_name}-https-vhost.conf.tpl" | sed '/^\s*$/d' > "$https_vhost"
        elif [[ ! -f "$https_vhost" ]]; then
            error "Could not create virtual host for ${app} at '${https_vhost}'. Check permissions and ownership for parent directories."
            return 1
        else
            warn "The ${app} virtual host file '${https_vhost}' is not writable. Configurations based on environment variables will not be applied for this file."
        fi
    fi
}

########################
# Ensure an Apache application configuration does not exist anymore (in virtual hosts format)
# Globals:
#   *
# Arguments:
#   $1 - App name
# Returns:
#   true if the configuration was disabled, false otherwise
########################
ensure_apache_app_configuration_not_exists() {
    local -r app="${1:?missing app}"
    local -r http_vhost="${APACHE_VHOSTS_DIR}/${app}-vhost.conf"
    local -r https_vhost="${APACHE_VHOSTS_DIR}/${app}-https-vhost.conf"
    # Note that 'rm -f' will not fail if the files don't exist
    # However if we lack permissions to remove the file, it will result in a non-zero exit code, as expected by this function
    rm -f "$http_vhost" "$https_vhost"
}

########################
# Ensure Apache loads the configuration for an application in a URL prefix
# Globals:
#   APACHE_*
# Arguments:
#   $1 - App name
# Flags:
#   --type - Application type, which has an effect on what configuration template will be used, allowed values: php, (empty)
#   --allow-remote-connections - Whether to allow remote connections or to require local connections
#   --move-htaccess - Move .htaccess files to a common place so they can be loaded during Apache startup
#   --prefix - URL prefix from where it will be accessible (i.e. /myapp)
#   --additional-configuration - Additional vhost configuration (no default)
#   --allow-override - Whether to allow .htaccess files (only allowed when --move-htaccess is set to 'no')
#   --document-root - Path to document root directory
#   --extra-directory-configuration - Extra configuration for the document root directory
# Returns:
#   true if the configuration was enabled, false otherwise
########################
ensure_apache_prefix_configuration_exists() {
    local -r app="${1:?missing app}"
    # Default options
    local type=""
    local allow_remote_connections="yes"
    local move_htaccess="yes"
    local prefix="/${app}"
    local var_name
    # Template variables defaults
    export additional_configuration=""
    export allow_override="All"
    export document_root="${BITNAMI_ROOT_DIR}/${app}"
    export extra_directory_configuration=""
    # Validate arguments
    shift
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            --type \
            | --allow-remote-connections \
            | --move-htaccess \
            | --prefix \
            | --additional-configuration \
            | --allow-override \
            | --document-root \
            | --extra-directory-configuration \
            )
                var_name="$(echo "$1" | sed -e "s/^--//" -e "s/-/_/g")"
                shift
                declare "${var_name}"="$1"
                ;;
            *)
                echo "Invalid command line flag $1" >&2
                return 1
                ;;
        esac
        shift
    done
    # App .htaccess support
    export htaccess_include
    is_boolean_yes "$move_htaccess" && apache_replace_htaccess_files "$app" --document-root "$document_root"
    if [[ -f "${APACHE_HTACCESS_DIR}/${app}-htaccess.conf" ]]; then
        allow_override="None"
        htaccess_include="Include \"${APACHE_HTACCESS_DIR}/${app}-htaccess.conf\""
    else
        allow_override="$allow_override"
        htaccess_include=""
    fi
    # ACL configuration
    export acl_configuration
    if is_boolean_yes "$allow_remote_connections"; then
        acl_configuration="Require all granted"
    else
        acl_configuration="$(cat <<EOF
Require local
ErrorDocument 403 "For security reasons, this URL is only accessible using localhost (127.0.0.1) as the hostname."
# AuthType Basic
# AuthName ${app}
# AuthUserFile "${APACHE_BASE_DIR}/users"
# Require valid-user
EOF
)"
    fi
    # Prefix configuration
    export prefix_conf="Alias ${prefix} \"${document_root}\""
    # Indent configurations
    acl_configuration="$(indent $'\n'"$acl_configuration" 2)"
    extra_directory_configuration="$(indent $'\n'"$extra_directory_configuration" 2)"
    # Render templates
    # We remove lines that are empty or contain only newspaces with 'sed', so the resulting file looks better
    local template_name="app"
    [[ -n "$type" && "$type" != "php" ]] && template_name="app-${type}"
    local -r template_dir="${BITNAMI_ROOT_DIR}/scripts/apache/bitnami-templates"
    local -r prefix_file="${APACHE_CONF_DIR}/bitnami/${app}.conf"
    if is_file_writable "$prefix_file"; then
        # Create file with root group write privileges, so it can be modified in non-root containers
        [[ ! -f "$prefix_file" ]] && touch "$prefix_file" && chmod g+rw "$prefix_file"
        render-template "${template_dir}/${template_name}-prefix.conf.tpl" | sed '/^\s*$/d' > "$prefix_file"
        ensure_apache_configuration_exists "Include \"$prefix_file\""
    elif [[ ! -f "$prefix_file" ]]; then
        error "Could not create web server configuration file for ${app} at '${prefix_file}'. Check permissions and ownership for parent directories."
        return 1
    else
        warn "The ${app} web server configuration file '${prefix_file}' is not writable. Configurations based on environment variables will not be applied for this file."
    fi
}

########################
# Ensure Apache application configuration is updated with the runtime configuration (i.e. ports)
# Globals:
#   *
# Arguments:
#   $1 - App name
# Flags:
#   --hosts - Hosts to enable
#   --enable-https - Update HTTPS app configuration
#   --http-port - HTTP port number
#   --https-port - HTTPS port number
# Returns:
#   true if the configuration was updated, false otherwise
########################
apache_update_app_configuration() {
    local -r app="${1:?missing app}"
    # Default options
    local -a hosts=("127.0.0.1" "_default_")
    local enable_https="yes"
    local http_port="${APACHE_HTTP_PORT_NUMBER:-"$APACHE_DEFAULT_HTTP_PORT_NUMBER"}"
    local https_port="${APACHE_HTTPS_PORT_NUMBER:-"$APACHE_DEFAULT_HTTPS_PORT_NUMBER"}"
    # Validate arguments
    shift
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            --hosts)
                shift
                read -r -a hosts <<< "$1"
                ;;

            # Common flags
            --enable-https \
            | --http-port \
            | --https-port \
            )
                args+=("$1" "$2")
                shift
                ;;

            *)
                echo "Invalid command line flag $1" >&2
                return 1
                ;;
        esac
        shift
    done
    # Construct host string in the format of "host1:port1[ host2:port2[ ...]]"
    export http_listen_addresses=""
    export https_listen_addresses=""
    for host in "${hosts[@]}"; do
        http_listen="${host}:${http_port}"
        https_listen="${host}:${https_port}"
        [[ -z "${http_listen_addresses:-}" ]] && http_listen_addresses="$http_listen" || http_listen_addresses="${http_listen_addresses} ${http_listen}"
        [[ -z "${https_listen_addresses:-}" ]] && https_listen_addresses="$https_listen" || https_listen_addresses="${https_listen_addresses} ${https_listen}"
    done
    # Update configuration
    local -r http_vhost="${APACHE_VHOSTS_DIR}/${app}-vhost.conf"
    local -r https_vhost="${APACHE_VHOSTS_DIR}/${app}-https-vhost.conf"
    if is_file_writable "$http_vhost"; then
        replace_in_file "$http_vhost" "^<VirtualHost\s.*>$" "<VirtualHost ${http_listen_addresses}>"
    else
        warn "The ${app} virtual host file '${http_vhost}' is not writable. Configurations based on environment variables will not be applied for this file."
    fi
    if is_boolean_yes "$enable_https"; then
        if is_file_writable "$https_vhost"; then
            replace_in_file "$https_vhost" "^<VirtualHost\s.*>$" "<VirtualHost ${https_listen_addresses}>"
        else
            warn "The ${app} virtual host file '${https_vhost}' is not writable. Configurations based on environment variables will not be applied for this file."
        fi
    fi
}

########################
# Create a password file for basic authentication and restrict its permissions
# Globals:
#   *
# Arguments:
#   $1 - file
#   $2 - username
#   $3 - password
# Returns:
#   true if the configuration was updated, false otherwise
########################
apache_create_password_file() {
    local -r file="${1:?missing file}"
    local -r username="${2:?missing username}"
    local -r password="${3:?missing password}"

    "${APACHE_BIN_DIR}/htpasswd" -bc "$file" "$username" "$password"
    am_i_root && configure_permissions_ownership "$file" --file-mode "600" --user "$APACHE_DAEMON_USER" --group "$APACHE_DAEMON_GROUP"
}
