#!/bin/bash
#
# Bitnami web server handler library

# shellcheck disable=SC1091

# Load generic libraries
. /opt/bitnami/scripts/liblog.sh

# Load web server libraries
[[ -f "/opt/bitnami/scripts/libapache.sh" ]] && . /opt/bitnami/scripts/libapache.sh
[[ -f "/opt/bitnami/scripts/libnginx.sh" ]] && . /opt/bitnami/scripts/libnginx.sh

########################
# Prints the list of enabled web servers
# Globals:
#   WEB_SERVER_TYPE
# Arguments:
#   None
# Returns:
#   None
#########################
web_server_list() {
    local -r -a supported_web_servers=(apache nginx)
    local -a existing_web_servers=()
    for web_server in "${supported_web_servers[@]}"; do
        [[ -f "/opt/bitnami/scripts/${web_server}-env.sh" ]] && existing_web_servers+=("$web_server")
    done
    echo "${existing_web_servers[@]:-}"
}

########################
# Prints the currently-enabled web server type (only one, in order of preference)
# Globals:
#   WEB_SERVER_TYPE
# Arguments:
#   None
# Returns:
#   None
#########################
web_server_type() {
    local -a web_servers
    read -r -a web_servers <<< "$(web_server_list)"
    echo "${web_servers[0]:-}"
}

########################
# Validate that a supported web server is configured
# Globals:
#   WEB_SERVER_*
# Arguments:
#   None
# Returns:
#   None
#########################
web_server_validate() {
    local error_code=0
    local supported_web_servers=("apache" "nginx")

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    if [[ -z "$(web_server_type)" || ! " ${supported_web_servers[*]} " == *" $(web_server_type) "* ]]; then
        print_validation_error "Could not detect any supported web servers. It must be one of: ${supported_web_servers[*]}"
    elif ! type -t "is_$(web_server_type)_running" >/dev/null; then
        print_validation_error "Could not load the $(web_server_type) web server library from /opt/bitnami/scripts. Check that it exists and is readable."
    fi

    return "$error_code"
}

########################
# Check whether the web server is running
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   true if the web server is running, false otherwise
#########################
is_web_server_running() {
    "is_$(web_server_type)_running"
}

########################
# Start web server
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   None
#########################
web_server_start() {
    info "Starting $(web_server_type) in background"
    "${BITNAMI_ROOT_DIR}/scripts/$(web_server_type)/start.sh"
}

########################
# Stop web server
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   None
#########################
web_server_stop() {
    info "Stopping $(web_server_type)"
    "${BITNAMI_ROOT_DIR}/scripts/$(web_server_type)/stop.sh"
}

########################
# Restart web server
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   None
#########################
web_server_restart() {
    info "Restarting $(web_server_type)"
    "${BITNAMI_ROOT_DIR}/scripts/$(web_server_type)/restart.sh"
}

########################
# Reload web server
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   None
#########################
web_server_reload() {
    info "Reloading $(web_server_type) configuration"
    "${BITNAMI_ROOT_DIR}/scripts/$(web_server_type)/reload.sh"
}

########################
# Ensure a web server application configuration exists (i.e. Apache virtual host format or NGINX server block)
# It serves as a wrapper for the specific web server function
# Globals:
#   *
# Arguments:
#   $1 - App name
# Flags:
#   --hosts - Hosts to enable
#   --type - Application type, which has an effect on which configuration template to use
#   --allow-remote-connections - Whether to allow remote connections or to require local connections
#   --disabled - Whether to render the file with a .disabled prefix
#   --enable-https - Enable app configuration on HTTPS port
#   --http-port - HTTP port number
#   --https-port - HTTPS port number
#   --document-root - Path to document root directory
# Apache-specific flags:
#   --apache-additional-configuration - Additional vhost configuration (no default)
#   --apache-before-vhost-configuration - Configuration to add before the <VirtualHost> directive (no default)
#   --apache-allow-override - Whether to allow .htaccess files (only allowed when --move-htaccess is set to 'no')
#   --apache-extra-directory-configuration - Extra configuration for the document root directory
#   --apache-move-htaccess - Move .htaccess files to a common place so they can be loaded during Apache startup
# NGINX-specific flags:
#   --nginx-additional-configuration - Additional server block configuration (no default)
# Returns:
#   true if the configuration was enabled, false otherwise
########################
ensure_web_server_app_configuration_exists() {
    local app="${1:?missing app}"
    local -a web_servers args
    read -r -a web_servers <<< "$(web_server_list)"
    for web_server in "${web_servers[@]}"; do
        args=("$app")
        # Validate arguments
        shift
        while [[ "$#" -gt 0 ]]; do
            case "$1" in
                # Common flags
                --hosts \
                | --type \
                | --allow-remote-connections \
                | --disabled \
                | --enable-https \
                | --http-port \
                | --https-port \
                | --document-root \
                )
                    args+=("$1" "${2:?missing value}")
                    shift
                    ;;

                # Specific Apache flags
                --apache-additional-configuration \
                | --apache-before-vhost-configuration \
                | --apache-allow-override \
                | --apache-extra-directory-configuration \
                | --apache-move-htaccess \
                )
                    [[ "$web_server" == "apache" ]] && args+=("${1//apache-/}" "${2:?missing value}")
                    shift
                    ;;

                # Specific NGINX flags
                --nginx-additional-configuration)
                    [[ "$web_server" == "nginx" ]] && args+=("${1//nginx-/}" "${2:?missing value}")
                    shift
                    ;;

                *)
                    echo "Invalid command line flag $1" >&2
                    return 1
                    ;;
            esac
            shift
        done
        "ensure_${web_server}_app_configuration_exists" "${args[@]}"
    done
}

########################
# Ensure a web server application configuration does not exist anymore (i.e. Apache virtual host format or NGINX server block)
# It serves as a wrapper for the specific web server function
# Globals:
#   *
# Arguments:
#   $1 - App name
# Returns:
#   true if the configuration was disabled, false otherwise
########################
ensure_web_server_app_configuration_not_exists() {
    local app="${1:?missing app}"
    local -a web_servers
    read -r -a web_servers <<< "$(web_server_list)"
    for web_server in "${web_servers[@]}"; do
        "ensure_${web_server}_app_configuration_not_exists" "$app"
    done
}

########################
# Ensure the web server loads the configuration for an application in a URL prefix
# It serves as a wrapper for the specific web server function
# Globals:
#   *
# Arguments:
#   $1 - App name
# Flags:
#   --allow-remote-connections - Whether to allow remote connections or to require local connections
#   --document-root - Path to document root directory
#   --prefix - URL prefix from where it will be accessible (i.e. /myapp)
#   --type - Application type, which has an effect on what configuration template will be used
# Apache-specific flags:
#   --apache-additional-configuration - Additional vhost configuration (no default)
#   --apache-allow-override - Whether to allow .htaccess files (only allowed when --move-htaccess is set to 'no')
#   --apache-extra-directory-configuration - Extra configuration for the document root directory
#   --apache-move-htaccess - Move .htaccess files to a common place so they can be loaded during Apache startup
# NGINX-specific flags:
#   --nginx-additional-configuration - Additional server block configuration (no default)
# Returns:
#   true if the configuration was enabled, false otherwise
########################
ensure_web_server_prefix_configuration_exists() {
    local app="${1:?missing app}"
    local -a web_servers args
    read -r -a web_servers <<< "$(web_server_list)"
    for web_server in "${web_servers[@]}"; do
        args=("$app")
        # Validate arguments
        shift
        while [[ "$#" -gt 0 ]]; do
            case "$1" in
                # Common flags
                --allow-remote-connections \
                | --document-root \
                | --prefix \
                | --type \
                )
                    args+=("$1" "${2:?missing value}")
                    shift
                    ;;

                # Specific Apache flags
                --apache-additional-configuration \
                | --apache-allow-override \
                | --apache-extra-directory-configuration \
                | --apache-move-htaccess \
                )
                    [[ "$web_server" == "apache" ]] && args+=("${1//apache-/}" "$2")
                    shift
                    ;;

                # Specific NGINX flags
                --nginx-additional-configuration)
                    [[ "$web_server" == "nginx" ]] && args+=("${1//nginx-/}" "$2")
                    shift
                    ;;

                *)
                    echo "Invalid command line flag $1" >&2
                    return 1
                    ;;
            esac
            shift
        done
        "ensure_${web_server}_prefix_configuration_exists" "${args[@]}"
    done
}

########################
# Ensure a web server application configuration is updated with the runtime configuration (i.e. ports)
# It serves as a wrapper for the specific web server function
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
web_server_update_app_configuration() {
    local app="${1:?missing app}"
    local -a web_servers args
    read -r -a web_servers <<< "$(web_server_list)"
    for web_server in "${web_servers[@]}"; do
        args=("$app")
        # Validate arguments
        shift
        while [[ "$#" -gt 0 ]]; do
            case "$1" in
                # Common flags
                --hosts \
                | --enable-https \
                | --http-port \
                | --https-port \
                )
                    args+=("$1" "${2:?missing value}")
                    shift
                    ;;

                *)
                    echo "Invalid command line flag $1" >&2
                    return 1
                    ;;
            esac
            shift
        done
        "${web_server}_update_app_configuration" "${args[@]}"
    done
}

########################
# Enable loading page, which shows users that the initialization process is not yet completed
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   None
#########################
web_server_enable_loading_page() {
    ensure_web_server_app_configuration_exists "__loading" --hosts "_default_" \
        --apache-additional-configuration "
# Show a HTTP 503 Service Unavailable page by default
RedirectMatch 503 ^/$
# Show index.html if server is answering with 404 Not Found or 503 Service Unavailable status codes
ErrorDocument 404 /index.html
ErrorDocument 503 /index.html" \
        --nginx-additional-configuration "
# Show a HTTP 503 Service Unavailable page by default
location / {
  return 503;
}
# Show index.html if server is answering with 404 Not Found or 503 Service Unavailable status codes
error_page 404 @installing;
error_page 503 @installing;
location @installing {
  rewrite ^(.*)$ /index.html break;
}"
    web_server_reload
}

########################
# Enable loading page, which shows users that the initialization process is not yet completed
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   None
#########################
web_server_disable_install_page() {
    ensure_web_server_app_configuration_not_exists "__loading"
    web_server_reload
}
