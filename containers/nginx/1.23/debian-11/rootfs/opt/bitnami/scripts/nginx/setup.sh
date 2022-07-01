#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libnginx.sh

# Load NGINX environment variables
. /opt/bitnami/scripts/nginx-env.sh

# Ensure NGINX environment variables settings are valid
nginx_validate

# Ensure NGINX is stopped when this script ends
trap "nginx_stop" EXIT

# Ensure NGINX daemon user exists when running as 'root'
am_i_root && ensure_user_exists "$NGINX_DAEMON_USER" --group "$NGINX_DAEMON_GROUP"

# Run init scripts
nginx_custom_init_scripts

# Validate HTTPS port number
if [[ -n "${NGINX_HTTPS_PORT_NUMBER:-}" ]]; then
    validate_port_args=()
    ! am_i_root && validate_port_args+=("-unprivileged")
    validate_port_args+=("$NGINX_HTTPS_PORT_NUMBER")
    if ! err=$(validate_port "${validate_port_args[@]}"); then
        error "An invalid port was specified in the environment variable NGINX_HTTPS_PORT_NUMBER: $err"
        exit 1
    fi
fi

# Fix logging issue when running as root
! am_i_root || chmod o+w "$(readlink /dev/stdout)" "$(readlink /dev/stderr)"

# Initialize NGINX
nginx_initialize

