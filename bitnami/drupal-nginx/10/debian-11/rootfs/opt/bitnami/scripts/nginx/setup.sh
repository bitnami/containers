#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

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

# Regenerate SSL certs (without a passphrase)
ensure_dir_exists "${NGINX_CONF_DIR}/bitnami/certs"
if [[ ! -f "${NGINX_CONF_DIR}/bitnami/certs/server.crt" ]]; then
    SSL_KEY_FILE="${NGINX_CONF_DIR}/bitnami/certs/server.key"
    SSL_CERT_FILE="${NGINX_CONF_DIR}/bitnami/certs/server.crt"
    SSL_CSR_FILE="${NGINX_CONF_DIR}/bitnami/certs/server.csr"
    SSL_SUBJ="/CN=example.com"
    SSL_EXT="subjectAltName=DNS:example.com,DNS:www.example.com,IP:127.0.0.1"
    rm -f "$SSL_KEY_FILE" "$SSL_CERT_FILE"
    openssl genrsa -out "$SSL_KEY_FILE" 4096
    openssl req -new -sha256 -out "$SSL_CSR_FILE" -key "$SSL_KEY_FILE" -nodes -subj "$SSL_SUBJ" -addext "$SSL_EXT"
    openssl x509 -req -sha256 -in "$SSL_CSR_FILE" -signkey "$SSL_KEY_FILE" -out "$SSL_CERT_FILE" -days 1825 -extfile <(echo -n "$SSL_EXT")
    rm -f "$SSL_CSR_FILE"
fi
# Run init scripts
nginx_custom_init_scripts

# Fix logging issue when running as root
! am_i_root || chmod o+w "$(readlink /dev/stdout)" "$(readlink /dev/stderr)"

# Configure HTTPS port number
if [[ -n "${NGINX_HTTPS_PORT_NUMBER:-}" ]] && [[ ! -f "${NGINX_SERVER_BLOCKS_DIR}/default-https-server-block.conf" ]] && is_file_writable "${NGINX_SERVER_BLOCKS_DIR}/default-https-server-block.conf"; then
    cp "${BITNAMI_ROOT_DIR}/scripts/nginx/bitnami-templates/default-https-server-block.conf" "${NGINX_SERVER_BLOCKS_DIR}/default-https-server-block.conf"
fi

# Initialize NGINX
nginx_initialize

