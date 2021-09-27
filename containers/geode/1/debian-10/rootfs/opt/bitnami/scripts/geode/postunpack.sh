#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libgeode.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh

# Load Apache Geode environment
. /opt/bitnami/scripts/geode-env.sh

# Ensure required directories exist
chmod g+rwX "$GEODE_BASE_DIR"
for dir in "$GEODE_VOLUME_DIR" "$GEODE_DATA_DIR" "$GEODE_MOUNTED_CONF_DIR" "$GEODE_CONF_DIR" "$GEODE_CERTS_DIR" "$GEODE_EXTENSIONS_DIR" "$GEODE_LOGS_DIR" "$GEODE_INITSCRIPTS_DIR"; do
    ensure_dir_exists "$dir"
    configure_permissions_ownership "$dir" -d "775" -f "664"
done
