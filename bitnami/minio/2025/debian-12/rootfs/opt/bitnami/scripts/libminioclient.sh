#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami MinIO Client library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libos.sh

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
    if minio_client_execute stat "${bucket_name}" >/dev/null 2>&1; then
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

    if am_i_root; then
        run_as_user "$MINIO_DAEMON_USER" "${exec}" "${args[@]}"
    else
        "${exec}" "${args[@]}"
    fi
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

    if am_i_root; then
        cat > /tmp/cmd.sh << EOF
#!/bin/bash
# timeout forks its own shell process, so we need to provide it with the expected environment
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/minio-env.sh
. /opt/bitnami/scripts/minio-client-env.sh
. /opt/bitnami/scripts/libminio.sh
. /opt/bitnami/scripts/libminioclient.sh
run_as_user "$MINIO_DAEMON_USER" "${exec}" ${args[@]}
EOF
        chmod +x /tmp/cmd.sh
        timeout 5s bash -c "/tmp/cmd.sh"
        rm -f /tmp/cmd.sh
    else
        timeout 5s "${exec}" "${args[@]}"
    fi
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
