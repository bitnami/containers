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
    local exec script_file
    exec=$(command -v mc)

    if am_i_root; then
        if ! script_file=$(mktemp "${TMPDIR:-/tmp}/cmd.XXXXXXXX"); then
            echo "Error: Failed to create script file" >&2
            return 1
        fi
        cat > "$script_file" << EOF
#!/bin/bash
# timeout forks its own shell process, so we need to provide it with the expected environment
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/minio-env.sh
. /opt/bitnami/scripts/minio-client-env.sh
. /opt/bitnami/scripts/libminio.sh
. /opt/bitnami/scripts/libminioclient.sh
run_as_user "$MINIO_DAEMON_USER" "${exec}" ${args[@]}
EOF
        chmod +x "$script_file"
        timeout 5s bash -c "$script_file"
        rm -f "$script_file"
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
    local scheme
    if [[ -n "$MINIO_SERVER_HOST" ]] && [[ -n "$MINIO_SERVER_ROOT_USER" ]] && [[ -n "$MINIO_SERVER_ROOT_PASSWORD" ]]; then
        scheme="$(echo "$MINIO_SERVER_SCHEME" | tr '[:upper:]' '[:lower:]')"
        info "Adding Minio host to 'mc' configuration..."
        minio_client_execute alias set minio "${scheme}://${MINIO_SERVER_HOST}:${MINIO_SERVER_PORT_NUMBER}" "$MINIO_SERVER_ROOT_USER" "$MINIO_SERVER_ROOT_PASSWORD"
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
    local scheme
    scheme="$(echo "$MINIO_SERVER_SCHEME" | tr '[:upper:]' '[:lower:]')"
    info "Adding local Minio host to 'mc' configuration..."
    minio_client_execute alias set local "${scheme}://localhost:${MINIO_SERVER_PORT_NUMBER}" "$MINIO_SERVER_ROOT_USER" "$MINIO_SERVER_ROOT_PASSWORD" >/dev/null 2>&1
}
