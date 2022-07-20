#!/bin/bash
#
# Bitnami MinIO Client library

# Functions

########################
# Check if a bucket already exists
# Globals:
#   MINIO_CLIENT_CONF_DIR
# Arguments:
#   $1 - Bucket name
# Returns:
#   Boolean
minio_client_bucket_exists() {
    local -r bucket_name="${1:?bucket required}"
    if minio_client_execute ls "${bucket_name}" >/dev/null 2>&1; then
        true
    else
        false
    fi
}

########################
# Execute an arbitrary MinIO client command
# Globals:
#   MINIO_CLIENT_CONF_DIR
# Arguments:
#   $@ - Command to execute
# Returns:
#   None
minio_client_execute() {
    local -r args=("--config-dir" "${MINIO_CLIENT_CONF_DIR}" "--quiet" "$@")
    local exec
    exec=$(command -v mc)

    "${exec}" "${args[@]}"
}

########################
# Execute an arbitrary MinIO client command with a 2s timeout
# Globals:
#   MINIO_CLIENT_CONF_DIR
# Arguments:
#   $@ - Command to execute
# Returns:
#   None
minio_client_execute_timeout() {
    local -r args=("--config-dir" "${MINIO_CLIENT_CONF_DIR}" "--quiet" "$@")
    local exec
    exec=$(command -v mc)

    timeout 5s "${exec}" "${args[@]}"
}

########################
# Configure MinIO Client to use a MinIO server
# Globals:
#   MINIO_SERVER_*
# Arguments:
#   None
# Returns:
#   Series of exports to be used as 'eval' arguments
#########################
minio_client_configure_server() {
    if [[ -n "$MINIO_SERVER_HOST" ]] && [[ -n "$MINIO_SERVER_ROOT_USER" ]] && [[ -n "$MINIO_SERVER_ROOT_PASSWORD" ]]; then
        info "Adding Minio host to 'mc' configuration..."
        minio_client_execute config host add minio "${MINIO_SERVER_SCHEME}://${MINIO_SERVER_HOST}:${MINIO_SERVER_PORT_NUMBER}" "${MINIO_SERVER_ROOT_USER}" "${MINIO_SERVER_ROOT_PASSWORD}"
    fi
}

########################
# Configure MinIO Client to use a local MinIO server
# Arguments:
#   None
# Returns:
#   Series of exports to be used as 'eval' arguments
#########################
minio_client_configure_local() {
    info "Adding local Minio host to 'mc' configuration..."
    minio_client_execute config host add local "${MINIO_SERVER_SCHEME}://localhost:${MINIO_SERVER_PORT_NUMBER}" "${MINIO_SERVER_ROOT_USER}" "${MINIO_SERVER_ROOT_PASSWORD}" >/dev/null 2>&1
}
