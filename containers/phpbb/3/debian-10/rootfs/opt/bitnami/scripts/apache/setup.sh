#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libapache.sh

# Load Apache environment
. /opt/bitnami/scripts/apache-env.sh

# Ensure Apache environment variables are valid
apache_validate

# Ensure Apache daemon user exists when running as 'root'
am_i_root && ensure_user_exists "$APACHE_DAEMON_USER" --group "$APACHE_DAEMON_GROUP"

# Copy vhosts files
if ! is_dir_empty "/vhosts"; then
    info "Found mounted virtual hosts in '/vhosts'. Copying them to '${APACHE_BASE_DIR}/conf/vhosts'"
    cp -Lr "/vhosts/." "${APACHE_VHOSTS_DIR}"
fi

# Mount certificate files
if ! is_dir_empty "${APACHE_BASE_DIR}/certs"; then
    warn "The directory '${APACHE_BASE_DIR}/certs' was externally mounted. This is a legacy configuration and will be deprecated soon. Please mount certificate files at '/certs' instead. Find an example at: https://github.com/bitnami/bitnami-docker-apache#using-custom-ssl-certificates"
    warn "Restoring certificates at '${APACHE_BASE_DIR}/certs' to '${APACHE_CONF_DIR}/bitnami/certs'"
    rm -rf "${APACHE_CONF_DIR}/bitnami/certs"
    ln -sf "${APACHE_BASE_DIR}/certs" "${APACHE_CONF_DIR}/bitnami/certs"
elif ! is_dir_empty "/certs"; then
    info "Mounting certificates files from '/certs'"
    rm -rf "${APACHE_CONF_DIR}/bitnami/certs"
    ln -sf "/certs" "${APACHE_CONF_DIR}/bitnami/certs"
fi

# Mount application files
if ! is_dir_empty "/app"; then
    info "Mounting application files from '/app'"
    rm -rf "$APACHE_HTDOCS_DIR"
    ln -sf "/app" "$APACHE_HTDOCS_DIR"
fi

# Restore persisted configuration files (deprecated)
if ! is_dir_empty "/bitnami/apache/conf"; then
    warn "The directory '/bitnami/apache/conf' was externally mounted. This is a legacy configuration and will be deprecated soon. Please mount certificate files at '${APACHE_CONF_DIR}' instead. Find an example at: https://github.com/bitnami/bitnami-docker-apache#full-configuration"
    warn "Restoring configuration at '/bitnami/apache/conf' to '${APACHE_CONF_DIR}'"
    rm -rf "$APACHE_CONF_DIR"
    ln -sf "/bitnami/apache/conf" "$APACHE_CONF_DIR"
fi

# Update ports in configuration
[[ -n "$APACHE_HTTP_PORT_NUMBER" ]] && info "Configuring the HTTP port" && apache_configure_http_port "$APACHE_HTTP_PORT_NUMBER"
[[ -n "$APACHE_HTTPS_PORT_NUMBER" ]] && info "Configuring the HTTPS port" && apache_configure_https_port "$APACHE_HTTPS_PORT_NUMBER"

# Fix logging issue when running as root
! am_i_root || chmod o+w "$(readlink /dev/stdout)" "$(readlink /dev/stderr)"
