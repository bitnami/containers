#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libfs.sh

# Load Flink environment variables
. /opt/bitnami/scripts/flink-env.sh


# Create directories
dirs=(
    "${FLINK_WORK_DIR}"
    "${FLINK_CONF_DIR}"
    "${FLINK_VOLUME_DIR}"
)

# Ensure 'daemon' user exists when running as 'root'
am_i_root && ensure_user_exists "$FLINK_DAEMON_USER" --group "$FLINK_DAEMON_GROUP"

for dir in "${dirs[@]}"; do
    ensure_dir_exists "$dir"
    configure_permissions_ownership "$dir" -d "775" -f "664"
done

# Set up execution permissions for /bin folder
ensure_dir_exists "${FLINK_WORK_DIR}/bin"
configure_permissions_ownership "${FLINK_WORK_DIR}/bin" -d "775" -f "775"
