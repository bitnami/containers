#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libapache.sh

# Load Apache environment
. /opt/bitnami/scripts/apache-env.sh

# Ensure Apache environment variables are valid
apache_validate

# Ensure Apache daemon user exists when running as 'root'
am_i_root && ensure_user_exists "$APACHE_DAEMON_USER" --group "$APACHE_DAEMON_GROUP"

if ! is_dir_empty "$APACHE_DEFAULT_CONF_DIR"; then
    # We add the copy from default config in the initialize function for web applications
    # that make use of the Apache setup.sh script
    debug "Copying files from $APACHE_DEFAULT_CONF_DIR to $APACHE_CONF_DIR"
    cp -nr "$APACHE_DEFAULT_CONF_DIR"/. "$APACHE_CONF_DIR"
fi
# Generate SSL certs (without a passphrase)
ensure_dir_exists "${APACHE_CONF_DIR}/bitnami/certs"
if [[ ! -f "${APACHE_CONF_DIR}/bitnami/certs/server.crt" ]]; then
    info "Generating sample certificates"
    SSL_KEY_FILE="${APACHE_CONF_DIR}/bitnami/certs/server.key"
    SSL_CERT_FILE="${APACHE_CONF_DIR}/bitnami/certs/server.crt"
    SSL_CSR_FILE="${APACHE_CONF_DIR}/bitnami/certs/server.csr"
    SSL_SUBJ="/CN=example.com"
    SSL_EXT="subjectAltName=DNS:example.com,DNS:www.example.com,IP:127.0.0.1"
    rm -f "$SSL_KEY_FILE" "$SSL_CERT_FILE"
    openssl genrsa -out "$SSL_KEY_FILE" 4096
    # OpenSSL version 1.0.x does not use the same parameters as OpenSSL >= 1.1.x
    if [[ "$(openssl version | grep -oE "[0-9]+\.[0-9]+")" == "1.0" ]]; then
        openssl req -new -sha256 -out "$SSL_CSR_FILE" -key "$SSL_KEY_FILE" -nodes -subj "$SSL_SUBJ"
    else
        openssl req -new -sha256 -out "$SSL_CSR_FILE" -key "$SSL_KEY_FILE" -nodes -subj "$SSL_SUBJ" -addext "$SSL_EXT"
    fi
    openssl x509 -req -sha256 -in "$SSL_CSR_FILE" -signkey "$SSL_KEY_FILE" -out "$SSL_CERT_FILE" -days 1825 -extfile <(echo -n "$SSL_EXT")
    rm -f "$SSL_CSR_FILE"
fi
# Load SSL configuration
if [[ -f "${APACHE_CONF_DIR}/bitnami/bitnami.conf" ]] && [[ -f "${APACHE_CONF_DIR}/bitnami/bitnami-ssl.conf" ]]; then
    ensure_apache_configuration_exists "Include \"${APACHE_CONF_DIR}/bitnami/bitnami-ssl.conf\"" "bitnami-ssl\.conf" "${APACHE_CONF_DIR}/bitnami/bitnami.conf"
fi

# Copy vhosts files
if ! is_dir_empty "/vhosts"; then
    info "Found mounted virtual hosts in '/vhosts'. Copying them to '${APACHE_BASE_DIR}/conf/vhosts'"
    cp -Lr "/vhosts/." "${APACHE_VHOSTS_DIR}"
fi

# Mount certificate files
if ! is_dir_empty "${APACHE_BASE_DIR}/certs"; then
    warn "The directory '${APACHE_BASE_DIR}/certs' was externally mounted. This is a legacy configuration and will be deprecated soon. Please mount certificate files at '/certs' instead. Find an example at: https://github.com/bitnami/containers/tree/main/bitnami/apache#using-custom-ssl-certificates"
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
    warn "The directory '/bitnami/apache/conf' was externally mounted. This is a legacy configuration and will be deprecated soon. Please mount certificate files at '${APACHE_CONF_DIR}' instead. Find an example at: https://github.com/bitnami/containers/tree/main/bitnami/apache#full-configuration"
    warn "Restoring configuration at '/bitnami/apache/conf' to '${APACHE_CONF_DIR}'"
    rm -rf "$APACHE_CONF_DIR"
    ln -sf "/bitnami/apache/conf" "$APACHE_CONF_DIR"
fi

# Update ports in configuration
[[ -n "$APACHE_HTTP_PORT_NUMBER" ]] && info "Configuring the HTTP port" && apache_configure_http_port "$APACHE_HTTP_PORT_NUMBER"
[[ -n "$APACHE_HTTPS_PORT_NUMBER" ]] && info "Configuring the HTTPS port" && apache_configure_https_port "$APACHE_HTTPS_PORT_NUMBER"

# Configure ServerTokens with user values
[[ -n "$APACHE_SERVER_TOKENS" ]] && info "Configuring Apache ServerTokens directive" && apache_configure_server_tokens "$APACHE_SERVER_TOKENS"

# Fix logging issue when running as root
! am_i_root || chmod o+w "$(readlink /dev/stdout)" "$(readlink /dev/stderr)"
