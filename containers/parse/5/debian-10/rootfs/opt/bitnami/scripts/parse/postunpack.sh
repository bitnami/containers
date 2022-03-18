#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load Parse environment
. /opt/bitnami/scripts/parse-env.sh

# Load libraries
. /opt/bitnami/scripts/libparse.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh

# Ensure the Parse base directory exists and has proper permissions
info "Configuring file permissions for Parse"
ensure_user_exists "$PARSE_DAEMON_USER" --group "$PARSE_DAEMON_GROUP" --system
for dir in "$PARSE_BASE_DIR" "$PARSE_VOLUME_DIR" "${PARSE_LOGS_DIR}" "${PARSE_TMP_DIR}"; do
    ensure_dir_exists "$dir"
    # Use daemon:root ownership for compatibility when running as a non-root user
    configure_permissions_ownership "$dir" -d "775" -f "664" -u "$PARSE_DAEMON_USER" -g "root"
done

# Grant execution permissions to parse-server
chmod +x "${PARSE_BASE_DIR}/bin"/*
