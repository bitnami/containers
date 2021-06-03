#!/bin/bash
#
# Bitnami NGINX library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh

# Functions

########################
# Check if NGINX is running
# Globals:
#   NGINX_TMP_DIR
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_nginx_running() {
    local pid
    pid="$(get_pid_from_file "$NGINX_PID_FILE")"
    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if NGINX is not running
# Globals:
#   NGINX_TMP_DIR
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_nginx_not_running() {
    ! is_nginx_running
}

########################
# Stop NGINX
# Globals:
#   NGINX_TMP_DIR
# Arguments:
#   None
# Returns:
#   None
#########################
nginx_stop() {
    ! is_nginx_running && return
    debug "Stopping NGINX"
    stop_service_using_pid "$NGINX_PID_FILE"
}

########################
# Configure NGINX server block port
# Globals:
#   NGINX_CONF_DIR
# Arguments:
#    $1 - Port number
#    $2 - (optional) Path to server block file
# Returns:
#   None
#########################
nginx_configure_port() {
    local port=${1:?missing port}
    local file=${2:-"$NGINX_CONF_FILE"}
    if is_file_writable "$file"; then
        local nginx_configuration
        debug "Setting port number to ${port} in '${file}'"
        # TODO: find an appropriate NGINX parser to avoid 'sed calls'
        nginx_configuration="$(sed -E "s/(listen\s+)[0-9]{1,5};/\1${port};/g" "$file")"
        echo "$nginx_configuration" > "$file"
    fi
}

########################
# Validate settings in NGINX_* env vars
# Globals:
#   NGINX_*
# Arguments:
#   None
# Returns:
#   None
#########################
nginx_validate() {
    info "Validating settings in NGINX_* env vars"

    if [[ -n "${NGINX_HTTP_PORT_NUMBER:-}" ]]; then
        local -a validate_port_args=()
        ! am_i_root && validate_port_args+=("-unprivileged")
        validate_port_args+=("${NGINX_HTTP_PORT_NUMBER}")
        if ! err=$(validate_port "${validate_port_args[@]}"); then
            error "An invalid port was specified in the environment variable NGINX_HTTP_PORT_NUMBER: $err"
            exit 1
        fi
    fi

    if ! is_file_writable "$NGINX_CONF_FILE"; then
        warn "The NGINX configuration file '${NGINX_CONF_FILE}' is not writable by current user. Configurations based on environment variables will not be applied."
    fi
}

########################
# Initialize NGINX
# Globals:
#   NGINX_*
# Arguments:
#   None
# Returns:
#   None
#########################
nginx_initialize() {
    info "Initializing NGINX"

    # This fixes an issue where the trap would kill the entrypoint.sh, if a PID was left over from a previous run
    # Exec replaces the process without creating a new one, and when the container is restarted it may have the same PID
    rm -f "${NGINX_TMP_DIR}/nginx.pid"

    # Persisted configuration files from old versions
    if [[ -f "$NGINX_VOLUME_DIR/conf/nginx.conf" ]]; then
        error "A 'nginx.conf' file was found inside '${NGINX_VOLUME_DIR}/conf'. This configuration is not supported anymore. Please mount the configuration file at '${NGINX_CONF_FILE}' instead."
        exit 1
    fi
    if ! is_dir_empty "$NGINX_VOLUME_DIR/conf/vhosts"; then
        error "Custom server blocks files were found inside '$NGINX_VOLUME_DIR/conf/vhosts'. This configuration is not supported anymore. Please mount your custom server blocks config files at '${NGINX_SERVER_BLOCKS_DIR}' instead."
        exit 1
    fi

    debug "Updating NGINX configuration based on environment variables"
    local nginx_user_configuration
    if am_i_root; then
        debug "Ensuring NGINX daemon user/group exists"
        ensure_user_exists "$NGINX_DAEMON_USER" --group "$NGINX_DAEMON_GROUP"
        if [[ -n "${NGINX_DAEMON_USER:-}" ]]; then
            chown -R "${NGINX_DAEMON_USER:-}" "$NGINX_TMP_DIR"
        fi
        nginx_user_configuration="$(sed -E "s/^(user\s+).*/\1 ${NGINX_DAEMON_USER:-} ${NGINX_DAEMON_GROUP:-};/g" "$NGINX_CONF_FILE")"
        is_file_writable "$NGINX_CONF_FILE" && echo "$nginx_user_configuration" > "$NGINX_CONF_FILE"
    else
        # The "user" directive makes sense only if the master process runs with super-user privileges
        # TODO: find an appropriate NGINX parser to avoid 'sed calls'
        nginx_user_configuration="$(sed -E "s/(^user)/# \1/g" "$NGINX_CONF_FILE")"
        is_file_writable "$NGINX_CONF_FILE" && echo "$nginx_user_configuration" > "$NGINX_CONF_FILE"
    fi
    if [[ -n "${NGINX_HTTP_PORT_NUMBER:-}" ]]; then
        nginx_configure_port "$NGINX_HTTP_PORT_NUMBER"
    fi
}

########################
# Ensure an NGINX application configuration exists (in server block format)
# Globals:
#   NGINX_*
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
#   --additional-configuration - Additional server block configuration (no default)
#   --external-configuration - Configuration external to server block (no default)
#   --document-root - Path to document root directory
# Returns:
#   true if the configuration was enabled, false otherwise
########################
ensure_nginx_app_configuration_exists() {
    export app="${1:?missing app}"
    # Default options
    local type=""
    local -a hosts=()
    local allow_remote_connections="yes"
    local disabled="no"
    local enable_https="yes"
    local http_port="${NGINX_HTTP_PORT_NUMBER:-"$NGINX_DEFAULT_HTTP_PORT_NUMBER"}"
    local https_port="${NGINX_HTTPS_PORT_NUMBER:-"$NGINX_DEFAULT_HTTPS_PORT_NUMBER"}"
    local var_name
    # Template variables defaults
    export additional_configuration=""
    export external_configuration=""
    export document_root="${BITNAMI_ROOT_DIR}/${app}"
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
            | --additional-configuration \
            | --external-configuration \
            | --document-root \
            | --extra-directory-configuration \
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
    # Construct host string in the format of "listen host1:port1", "listen host2:port2", ...
    export http_listen_configuration=""
    export https_listen_configuration=""
    if [[ "${#hosts[@]}" -gt 0 ]]; then
        for host in "${hosts[@]}"; do
            http_listen=$'\n'"listen ${host}:${http_port};"
            https_listen=$'\n'"listen ${host}:${https_port} ssl;"
            [[ -z "${http_listen_configuration:-}" ]] && http_listen_configuration="$http_listen" || http_listen_configuration="${http_listen_configuration}${http_listen}"
            [[ -z "${https_listen_configuration:-}" ]] && https_listen_configuration="$https_listen" || https_listen_configuration="${https_listen_configuration}${https_listen}"
        done
    else
        http_listen_configuration=$'\n'"listen ${http_port} default_server;"
        https_listen_configuration=$'\n'"listen ${https_port} ssl default_server;"
    fi
    # ACL configuration
    export acl_configuration=""
    if ! is_boolean_yes "$allow_remote_connections"; then
        acl_configuration="
default_type text/html;
if (\$remote_addr != 127.0.0.1) {
    return 403 'For security reasons, this URL is only accessible using localhost (127.0.0.1) as the hostname.';
}
# Avoid absolute redirects when connecting through a SSH tunnel
absolute_redirect off;"
    fi
    # Indent configurations
    acl_configuration="$(indent "$acl_configuration" 4)"
    additional_configuration=$'\n'"$(indent "$additional_configuration" 4)"
    external_configuration=$'\n'"$external_configuration"
    http_listen_configuration="$(indent "$http_listen_configuration" 4)"
    https_listen_configuration="$(indent "$https_listen_configuration" 4)"
    # Render templates
    # We remove lines that are empty or contain only newspaces with 'sed', so the resulting file looks better
    local template_name="app"
    [[ -n "$type" && "$type" != "php" ]] && template_name="app-${type}"
    local template_dir="${BITNAMI_ROOT_DIR}/scripts/nginx/bitnami-templates"
    local server_block_suffix=""
    is_boolean_yes "$disabled" && server_block_suffix=".disabled"
    local http_server_block="${NGINX_SERVER_BLOCKS_DIR}/${app}-server-block.conf${server_block_suffix}"
    local https_server_block="${NGINX_SERVER_BLOCKS_DIR}/${app}-https-server-block.conf${server_block_suffix}"
    if is_file_writable "$http_server_block"; then
        # Create file with root group write privileges, so it can be modified in non-root containers
        [[ ! -f "$http_server_block" ]] && touch "$http_server_block" && chmod g+rw "$http_server_block"
        render-template "${template_dir}/${template_name}-http-server-block.conf.tpl" | sed '/^\s*$/d' > "$http_server_block"
    elif [[ ! -f "$http_server_block" ]]; then
        error "Could not create server block for ${app} at '${http_server_block}'. Check permissions and ownership for parent directories."
        return 1
    else
        warn "The ${app} server block file '${http_server_block}' is not writable. Configurations based on environment variables will not be applied for this file."
    fi
    if is_boolean_yes "$enable_https"; then
        if is_file_writable "$https_server_block"; then
            # Create file with root group write privileges, so it can be modified in non-root containers
            [[ ! -f "$https_server_block" ]] && touch "$https_server_block" && chmod g+rw "$https_server_block"
            render-template "${template_dir}/${template_name}-https-server-block.conf.tpl" | sed '/^\s*$/d' > "$https_server_block"
        elif [[ ! -f "$https_server_block" ]]; then
            error "Could not create server block for ${app} at '${https_server_block}'. Check permissions and ownership for parent directories."
            return 1
        else
            warn "The ${app} server block file '${https_server_block}' is not writable. Configurations based on environment variables will not be applied for this file."
        fi
    fi
}

########################
# Ensure an NGINX application configuration does not exist anymore (in server block format)
# Globals:
#   *
# Arguments:
#   $1 - App name
# Returns:
#   true if the configuration was disabled, false otherwise
########################
ensure_nginx_app_configuration_not_exists() {
    local app="${1:?missing app}"
    local http_server_block="${NGINX_SERVER_BLOCKS_DIR}/${app}-server-block.conf"
    local https_server_block="${NGINX_SERVER_BLOCKS_DIR}/${app}-https-server-block.conf"
    # Note that 'rm -f' will not fail if the files don't exist
    # However if we lack permissions to remove the file, it will result in a non-zero exit code, as expected by this function
    rm -f "$http_server_block" "$https_server_block"
}

########################
# Ensure NGINX loads the configuration for an application in a URL prefix
# Globals:
#   NGINX_*
# Arguments:
#   $1 - App name
# Flags:
#   --type - Application type, which has an effect on what configuration template will be used, allowed values: php, (empty)
#   --allow-remote-connections - Whether to allow remote connections or to require local connections
#   --prefix - URL prefix from where it will be accessible (i.e. /myapp)
#   --additional-configuration - Additional server block configuration (no default)
#   --document-root - Path to document root directory
#   --extra-directory-configuration - Extra configuration for the document root directory
# Returns:
#   true if the configuration was enabled, false otherwise
########################
ensure_nginx_prefix_configuration_exists() {
    local app="${1:?missing app}"
    # Default options
    local type=""
    local allow_remote_connections="yes"
    local var_name
    local prefix="/${app}"
    # Template variables defaults
    export additional_configuration=""
    export document_root="${BITNAMI_ROOT_DIR}/${app}"
    export extra_directory_configuration=""
    # Validate arguments
    shift
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            --type \
            | --allow-remote-connections \
            | --additional-configuration \
            | --document-root \
            | --extra-directory-configuration \
            | --prefix \
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
    # ACL configuration
    export acl_configuration=""
    if ! is_boolean_yes "$allow_remote_connections"; then
        acl_configuration="
default_type text/html;
if (\$remote_addr != 127.0.0.1) {
    return 403 'For security reasons, this URL is only accessible using localhost (127.0.0.1) as the hostname.';
}
# Avoid absolute redirects when connecting through a SSH tunnel
absolute_redirect off;"
    fi
    # Prefix configuration
    export location="$prefix"
    # Indent configurations
    acl_configuration="$(indent "$acl_configuration" 4)"
    additional_configuration=$'\n'"$(indent "$additional_configuration" 4)"
    # Render templates
    # We remove lines that are empty or contain only newspaces with 'sed', so the resulting file looks better
    local template_name="app"
    [[ -n "$type" ]] && template_name="app-${type}"
    local template_dir="${BITNAMI_ROOT_DIR}/scripts/nginx/bitnami-templates"
    local prefix_file="${NGINX_CONF_DIR}/bitnami/${app}.conf"
    if is_file_writable "$prefix_file"; then
        # Create file with root group write privileges, so it can be modified in non-root containers
        [[ ! -f "$prefix_file" ]] && touch "$prefix_file" && chmod g+rw "$prefix_file"
        render-template "${template_dir}/${template_name}-prefix.conf.tpl" | sed '/^\s*$/d' > "$prefix_file"
    elif [[ ! -f "$prefix_file" ]]; then
        error "Could not create web server configuration file for ${app} at '${prefix_file}'. Check permissions and ownership for parent directories."
        return 1
    else
        warn "The ${app} web server configuration file '${prefix_file}' is not writable. Configurations based on environment variables will not be applied for this file."
    fi
}

########################
# Ensure NGINX application configuration is updated with the runtime configuration (i.e. ports)
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
nginx_update_app_configuration() {
    local -r app="${1:?missing app}"
    # Default options
    local -a hosts=()
    local enable_https="yes"
    local http_port="${NGINX_HTTP_PORT_NUMBER:-"$NGINX_DEFAULT_HTTP_PORT_NUMBER"}"
    local https_port="${NGINX_HTTPS_PORT_NUMBER:-"$NGINX_DEFAULT_HTTPS_PORT_NUMBER"}"
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
    # Construct host string in the format of "listen host1:port1", "listen host2:port2", ...
    export http_listen_configuration=""
    export https_listen_configuration=""
    if [[ "${#hosts[@]}" -gt 0 ]]; then
        for host in "${hosts[@]}"; do
            http_listen="listen ${host}:${http_port};"
            https_listen="listen ${host}:${https_port} ssl;"
            [[ -z "${http_listen_configuration:-}" ]] && http_listen_configuration="$http_listen" || http_listen_configuration="${http_listen_configuration}"$'\\\n'"${http_listen}"
            [[ -z "${https_listen_configuration:-}" ]] && https_listen_configuration="$https_listen" || https_listen_configuration="${https_listen_configuration}"$'\\\n'"${https_listen}"
        done
    else
        http_listen_configuration="listen ${http_port} default_server;"
        https_listen_configuration="listen ${https_port} ssl default_server;"
    fi
    # Indent configurations
    http_listen_configuration="$(indent "$http_listen_configuration" 4)"
    https_listen_configuration="$(indent "$https_listen_configuration" 4)"
    # Update configuration
    local -r http_server_block="${NGINX_SERVER_BLOCKS_DIR}/${app}-server-block.conf"
    local -r https_server_block="${NGINX_SERVER_BLOCKS_DIR}/${app}-https-server-block.conf"
    if is_file_writable "$http_server_block"; then
        replace_in_file "$http_server_block" "^\s*listen\s.*;" "$http_listen_configuration"
    else
        warn "The ${app} server block file '${http_server_block}' is not writable. Configurations based on environment variables will not be applied for this file."
    fi
    if is_boolean_yes "$enable_https"; then
        if is_file_writable "$https_server_block"; then
            replace_in_file "$https_server_block" "^\s*listen\s.*\sssl;" "$https_listen_configuration"
        else
            warn "The ${app} server block file '${https_server_block}' is not writable. Configurations based on environment variables will not be applied for this file."
        fi
    fi
}
